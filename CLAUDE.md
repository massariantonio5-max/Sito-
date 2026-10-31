# Sito — regole di lavoro

## Strumenti installati (in `.claude/skills/`)

- `design-taste-frontend` (Taste Skill) — direzione artistica e regole anti-slop.
- `impeccable` — `/impeccable init | audit | critique | polish | distill | bolder | quieter | animate`.
- `playwright-cli` — browser, screenshot, verifica visiva. Comando globale: `npm install -g @playwright/cli@latest` (va reinstallato in ogni nuovo container cloud).
- `img2threejs` — solo se serve un oggetto 3D da un'immagine di riferimento.

## Contesto di design

- `DESIGN.md` (root) — stile Notion da VoltAgent/awesome-design-md: colori, spaziature, raggi, componenti.
- `PRODUCT.md` — **non ancora creato**. Prima della prima pagina esegui `/impeccable init` e chiedi all'utente pubblico, scopo, vincoli e tono.

## Regole (hanno la precedenza su DESIGN.md quando c'è conflitto)

- Niente Inter, né Inter usato di default. DESIGN.md indica "Notion Sans (Inter-based)": sostituiscilo con un font scelto per il progetto.
- Niente gradienti viola-blu. Il viola di DESIGN.md (`primary`) si usa solo come colore pieno della CTA principale, mai in un gradiente.
- Niente card annidate dentro altre card.
- Niente testo grigio su sfondi colorati: sulle bande colorate (es. `brand-navy`, card pastello) usa testo nel colore "ink" o "on-dark" della banda.
- Niente icona in un quadrato arrotondato sopra ogni titolo, niente layout SaaS standard (hero + 3 feature card + CTA).
- Testi specifici del prodotto, mai lorem ipsum o slogan generici.

## Ciclo di verifica per ogni pagina

1. Costruisci la pagina.
2. Servila in HTTP (Playwright CLI blocca `file://`), ad es. `npx --yes serve -l 4173 .`.
3. `playwright-cli open http://localhost:4173/<pagina>`, poi screenshot a 1440px e a 390px (`playwright-cli resize 1440 900` / `resize 390 844`, poi `screenshot`). Guarda le immagini.
4. `/impeccable audit` (e `/impeccable critique` se serve); scansione anche con `.claude/skills/impeccable/scripts/impeccable detect http://localhost:4173/<pagina>`.
5. Correggi e ripeti finché l'audit è pulito e non ci sono overflow, contrasto basso, sovrapposizioni o scroll orizzontale su mobile.
6. Mostra all'utente gli screenshot finali e le eventuali eccezioni con il motivo.
