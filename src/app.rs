use leptos::{prelude::*, task::spawn_local};
use leptos_meta::{provide_meta_context, MetaTags, Title};
use leptos_router::{components::{Route, Router, Routes}, path};
use std::sync::{Mutex, OnceLock};
use std::collections::HashMap;

// --- SERVER STATUS (Simuliert eine Datenbank für das Rate-Limiting) ---
struct AppState {
    defense_active: bool,
    failed_attempts: HashMap<String, u32>, // Speichert Fehlversuche pro Username
}

fn get_state() -> &'static Mutex<AppState> {
    static STATE: OnceLock<Mutex<AppState>> = OnceLock::new();
    STATE.get_or_init(|| Mutex::new(AppState { 
        defense_active: false, 
        failed_attempts: HashMap::new() 
    }))
}

// --- HTML GRUNDGERÜST ---
pub fn shell(options: LeptosOptions) -> impl IntoView {
    view! {
        <!DOCTYPE html>
        <html lang="de">
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <AutoReload options=options.clone() />
                <HydrationScripts options/>
                <MetaTags/>
            </head>
            <body>
                <App/>
            </body>
        </html>
    }
}

// --- HAUPT-APP & ROUTING ---
#[component]
pub fn App() -> impl IntoView {
    provide_meta_context();
    view! {
        <Title text="Leptos Security Demo"/>
        <Router>
            <main>
                <Routes fallback=|| "Seite nicht gefunden.">
                    <Route path=path!("/") view=SecurityDemoPage/>
                </Routes>
            </main>
        </Router>
    }
}

// --- BACKEND (Server-Funktionen) ---

#[server(LoginEndpoint)]
pub async fn verify_login(username: String, password: String) -> Result<bool, ServerFnError> {
    let mut state = get_state().lock().unwrap();
    let attempts = *state.failed_attempts.get(&username).unwrap_or(&0);

    // 1. ABWEHRMECHANISMUS: Rate Limiting prüfen
    if state.defense_active && attempts >= 3 {
        return Err(ServerFnError::ServerError(
            "Account temporär gesperrt (Rate-Limiting aktiv)!".into()
        ));
    }

    // 2. SIMULIERTE DATENBANK (Mehrere Nutzer)
    let users = [
        ("admin", "123"), // Unsicheres Passwort!
        ("user1", "sicher!99"),
        ("test", "qwertz"),
    ];

    let is_valid = users.iter().any(|(u, p)| *u == username && *p == password);

    if is_valid {
        state.failed_attempts.remove(&username); // Reset bei Erfolg
        Ok(true)
    } else {
        // Fehlversuch hochzählen
        state.failed_attempts.insert(username.clone(), attempts + 1);
        Err(ServerFnError::ServerError("Falscher Benutzername oder Passwort".into()))
    }
}

#[server(ToggleDefenseEndpoint)]
pub async fn toggle_defense(active: bool) -> Result<(), ServerFnError> {
    let mut state = get_state().lock().unwrap();
    state.defense_active = active;
    state.failed_attempts.clear(); // Reset beim Umschalten für saubere Tests
    Ok(())
}

// --- FRONTEND (UI) ---

#[component]
pub fn SecurityDemoPage() -> impl IntoView {
    // State für den Login
    let login_action = ServerAction::<LoginEndpoint>::new();
    let login_pending = login_action.pending();
    let login_value = login_action.value();

    // State für das Hacker-Panel
    let (defense_on, set_defense_on) = signal(false);
    let (attack_log, set_attack_log) = signal(Vec::<String>::new());

    // Funktion für den simulierten Angriff
    let run_attack = move |_| {
        set_attack_log.set(vec!["[!] Starte Wörterbuch-Angriff auf 'admin'...".to_string()]);
        
        spawn_local(async move {
            let passwords = ["12345", "passwort", "qwertz", "admin123", "geheim"];
            
            for pw in passwords {
                let res = verify_login("admin".to_string(), pw.to_string()).await;
                
                let log_msg = match res {
                    Ok(true) => format!("✅ ERFOLG: Passwort geknackt ('{}')", pw),
                    Err(e) => format!("❌ FEHLSCHLAG ('{}'): {}", pw, e.to_string()),
                    _ => "Unbekannter Fehler".to_string(),
                };
                
                set_attack_log.update(|log| log.push(log_msg.clone()));

                // Abbrechen, wenn wir drin sind
                if log_msg.contains("ERFOLG") { break; }
            }
        });
    };

    // Funktion zum Umschalten der Abwehr
    let toggle_defense_action = move |e: leptos::ev::Event| {
        let is_checked = event_target_checked(&e);
        set_defense_on.set(is_checked);
        spawn_local(async move {
            let _ = toggle_defense(is_checked).await;
        });
    };

    view! {
        <div style="display: flex; gap: 20px; max-width: 800px; margin: 50px auto; font-family: sans-serif;">
            
            // LINKE SEITE: Normaler Login
            <div style="flex: 1; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
                <h2>"Benutzer Login"</h2>
                <ActionForm action=login_action>
                    <div style="display: flex; flex-direction: column; gap: 15px;">
                        <input type="text" name="username" placeholder="Benutzername" required style="padding: 8px;"/>
                        <input type="password" name="password" placeholder="Passwort" required style="padding: 8px;"/>
                        <button type="submit" disabled=login_pending style="padding: 10px; background: #007bff; color: white; border: none; cursor: pointer;">
                            <Show when=move || login_pending.get() fallback=|| "Einloggen">
                                "Lädt..."
                            </Show>
                        </button>
                    </div>
                </ActionForm>

                <div style="margin-top: 15px; font-weight: bold;">
                    <Show when=move || login_value.get().is_some()>
                        {move || match login_value.get().unwrap() {
                            Ok(_) => view! { <p style="color: green;">"Erfolgreich eingeloggt!"</p> }.into_any(),
                            Err(e) => view! { <p style="color: red;">{e.to_string()}</p> }.into_any(),
                        }}
                    </Show>
                </div>
            </div>

            // RECHTE SEITE: Hacker & Admin Panel
            <div style="flex: 1; padding: 20px; border: 1px solid #ff4444; border-radius: 8px; background: #fff9f9;">
                <h2 style="color: #cc0000;">"Security Panel"</h2>
                
                <div style="margin-bottom: 20px;">
                    <label style="font-weight: bold; cursor: pointer;">
                        <input type="checkbox" on:change=toggle_defense_action />
                        " Abwehrmechanismus aktivieren (Max 3 Versuche)"
                    </label>
                </div>

                <button on:click=run_attack style="padding: 10px; width: 100%; background: #cc0000; color: white; border: none; font-weight: bold; cursor: pointer;">
                    "Brute-Force Angriff starten"
                </button>

                <div style="margin-top: 15px; background: #222; color: #0f0; padding: 10px; border-radius: 4px; font-family: monospace; min-height: 100px;">
                    <For
                        each=move || attack_log.get()
                        key=|msg| msg.clone()
                        children=move |msg| view! { <div style="margin-bottom: 4px;">{msg}</div> }
                    />
                </div>
            </div>
        </div>
    }
}