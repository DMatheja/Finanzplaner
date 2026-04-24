# Finanzplaner
Rust, Leptos (Full Stack), Finanzplaner: 

Alt Anleitung: (Hello world)

sudo apt update
sudo apt install build-essential

cargo new [projekt-name]    #Erstellt ein Projekt
cd [projekt-name]           #in die Directory
cargo add leptos      
cargo install trunk         #Kann dauern

trunk serve                 #startet die Website



#########Anleitung Neu:######## FULL STACK
Commands immer in WSL ausführen: [Wie im Screenshot zu sehen]

sudo apt update

sudo apt upgrade -y

sudo apt install build-essential pkg-config libssl-dev -y #Windows spezifisch da es sonst Probleme gibt

rustup update

rustup target add wasm32-unknown-unknown #Für das Frontend in WASM

cargo install --locked cargo-leptos         #trunk benutzt man nur für frontend, cargo ist full-stack. Dieser Command braucht eine Weile.

                     #Projekt erstellen:
cd ~
mkdir -p Entwicklung/Rust
cd Entwicklung/Rust
cargo leptos new --git https://github.com/leptos-rs/start-actix 
#Dann [Projektnamen eingeben]
cd [Project Name]
code . #Öffnet VSCode #optional wenn schon in VSCode

#Gehe im VSCode Explorer links in den Ordner src und öffne die Datei app.rs -> Das ist der source code in Rust.
#Jetzt programmieren

cargo leptos watch #startet die Website



<img width="2558" height="1440" alt="image" src="https://github.com/user-attachments/assets/f283c4e0-c183-4177-9ed3-0ed1b0c852c3" />

