use leptos::prelude::*;
use leptos_meta::{provide_meta_context, MetaTags, Title};
use leptos_router::{
    components::{Route, Router, Routes},
    path,
};

// --- HTML GRUNDGERÜST (Wird vom Server für das erste Rendering benötigt) ---
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
    // Erlaubt das Setzen von Titeln und Meta-Tags
    provide_meta_context();

    view! {
        <Title text="Leptos Login"/>
        
        // Router regelt die Unterseiten
        <Router>
            <main>
                <Routes fallback=|| "Seite nicht gefunden.">
                    // Dies lädt unsere Login-Seite auf dem Pfad "/"
                    <Route path=path!("/") view=LoginPage/>
                </Routes>
            </main>
        </Router>
    }
}

// --- BACKEND (Läuft auf dem Server) --- Test
#[server(LoginEndpoint)]
pub async fn verify_login(username: String, password: String) -> Result<bool, ServerFnError> {
    // Die künstliche tokio-Wartezeit wurde entfernt, um Fehler zu vermeiden!
    
    if username == "admin" && password == "123" {
        Ok(true)
    } else {
        Err(ServerFnError::ServerError("Falscher Benutzername oder Passwort".into()))
    }
}

// --- FRONTEND (Login-Formular) ---
#[component]
pub fn LoginPage() -> impl IntoView {
    let login_action = ServerAction::<LoginEndpoint>::new();
    let pending = login_action.pending();
    let value = login_action.value();

    view! {
        <div style="max-width: 400px; margin: 50px auto; font-family: sans-serif; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
            <h2>"Login System"</h2>
            
            // ActionForm darf als Leptos-Komponente kein direktes 'style' Attribut haben,
            // daher stylen wir das normale <div> innendrin.
            <ActionForm action=login_action>
                <div style="display: flex; flex-direction: column; gap: 15px;">
                    <div style="display: flex; flex-direction: column;">
                        <label for="username">"Benutzername:"</label>
                        <input type="text" name="username" id="username" required style="padding: 8px;"/>
                    </div>
                    
                    <div style="display: flex; flex-direction: column;">
                        <label for="password">"Passwort:"</label>
                        <input type="password" name="password" id="password" required style="padding: 8px;"/>
                    </div>
                    
                    <button type="submit" disabled=pending style="padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        <Show when=move || pending.get() fallback=|| "Einloggen">
                            "Lädt..."
                        </Show>
                    </button>
                </div>
            </ActionForm>

            <div style="margin-top: 20px; font-weight: bold;">
                <Show when=move || value.get().is_some()>
                    {move || match value.get().unwrap() {
                        Ok(_) => view! { <p style="color: green;">"Erfolgreich eingeloggt!"</p> }.into_any(),
                        Err(e) => view! { <p style="color: red;">{e.to_string()}</p> }.into_any(),
                    }}
                </Show>
            </div>
        </div>
    }
}
//Test