# --- STAGE 1: Builder ---
FROM rust:1-bookworm AS builder

# 1. WebAssembly-Target für das Frontend hinzufügen
RUN rustup target add wasm32-unknown-unknown

# 2. cargo-leptos installieren (Das Build-Tool für Fullstack Leptos)
RUN cargo install cargo-leptos --locked

WORKDIR /app

# 3. Den gesamten Quellcode kopieren
COPY . .

# 4. Die App im Release-Modus bauen. 
# cargo-leptos baut automatisch das Backend (nativ) und das Frontend (WASM)
RUN cargo leptos build --release

# --- STAGE 2: Runtime ---
# Wir nutzen Debian Slim. Das ist für dynamisch gelinkte Rust-Binaries (glibc)
# meistens die schmerzfreieste und kleinste Lösung (besser als Alpine für Rust).
FROM debian:bookworm-slim

WORKDIR /app

# (Optional aber empfohlen) SSL-Zertifikate installieren, falls dein Server 
# externe HTTPS-APIs aufrufen muss
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openssl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 1. Das Server-Binary kopieren. 
# WICHTIG: Ersetze "mein_leptos_projekt" mit dem "name" aus deiner Cargo.toml!
COPY --from=builder /app/target/release/finanzplaner /app/server

# 2. Die Frontend-Dateien (WASM, JS, CSS) kopieren
COPY --from=builder /app/target/site /app/site

# 3. Leptos mitteilen, wo die Dateien liegen und auf welchem Port er lauschen soll
ENV LEPTOS_SITE_ROOT=site
ENV LEPTOS_SITE_ADDR="0.0.0.0:3000"
ENV LEPTOS_ENV="PROD"

EXPOSE 3000

# Den Server starten
CMD ["/app/server"]


###Um die App zu starten:
#docker build -t meine-leptos-app . 
