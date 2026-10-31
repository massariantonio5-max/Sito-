---
name: creazione-sito
description: Procedura completa per creare o rifare un sito, una landing page o una pagina web in questo progetto senza il look generico "fatto dall'AI". Usala ogni volta che l'utente chiede di creare, costruire, rifare, ridisegnare o sistemare una pagina o un sito, anche se non nomina la skill. Combina PRODUCT.md e DESIGN.md con le skill design-taste-frontend, impeccable, playwright-cli e img2threejs, e impone un ciclo di verifica con screenshot desktop e mobile e /impeccable audit finché la pagina non è pulita.
---

# Creazione sito

Ogni pagina passa per quattro fasi: contesto, costruzione, verifica, consegna. Non saltare la verifica: una pagina non è finita finché lo script e l'audit non sono puliti e non hai guardato gli screenshot.

## 1. Contesto (prima di scrivere codice)

1. **Strumenti.** Le skill `design-taste-frontend`, `impeccable`, `playwright-cli` e `img2threejs` sono in `.claude/skills/`. Il comando globale `playwright-cli` sparisce a ogni nuovo container cloud: se manca, `npm install -g @playwright/cli@latest` (lo script di verifica lo reinstalla da solo).
2. **PRODUCT.md.** Se non esiste nella root, esegui `/impeccable init`. Chiedi all'utente solo ciò che non puoi dedurre: pubblico, scopo del sito, vincoli, tono. Non inventare queste informazioni.
3. **DESIGN.md.** Leggi `DESIGN.md` nella root (stile Notion, da VoltAgent/awesome-design-md) per colori, spaziature, raggi e componenti. Se l'utente vuole un altro stile, scaricalo da `https://raw.githubusercontent.com/VoltAgent/awesome-design-md/HEAD/design-md/<sito>/DESIGN.md` e sostituisci il file.
4. **Direzione.** Usa la skill `design-taste-frontend` per scegliere la direzione artistica (composizione, tipografia, palette, immagini) coerente con PRODUCT.md e DESIGN.md.
5. **3D.** Solo se la pagina richiede un oggetto 3D da un'immagine di riferimento, usa la skill `img2threejs`.

## 2. Regole di design

Queste regole battono DESIGN.md quando sono in conflitto.

- **Niente Inter.** DESIGN.md indica "Notion Sans (Inter-based)": scegli invece un font adatto al progetto (Google Fonts o self-hosted), con un abbinamento titoli/testo motivato.
- **Niente gradienti viola-blu**, né altri gradienti viola. Il `primary` viola di DESIGN.md va al massimo come colore pieno della CTA principale; se il detector di Impeccable lo segnala, sostituiscilo con un accento proprio del progetto.
- **Niente card annidate** dentro altre card.
- **Niente testo grigio su sfondi colorati.** Su bande colorate (es. `brand-navy`, card pastello) usa il colore ink/on-dark della banda, con contrasto WCAG AA (4.5:1 testo, 3:1 testo grande).
- **Niente tic da AI:** icona in un quadrato arrotondato sopra ogni titolo, layout SaaS standard (hero + 3 feature card + CTA), emoji come icone.
- **Testi veri**, specifici del prodotto (da PRODUCT.md). Mai lorem ipsum o slogan generici.
- Mobile-first: niente larghezze fisse che superano 390px, immagini con `max-width: 100%`, target touch di almeno 44px.

## 3. Ciclo di verifica (per ogni pagina)

1. **Servi il sito in HTTP**, perché Playwright CLI blocca `file://`. Dalla cartella del sito:
   ```bash
   python3 -m http.server 4173   # in background
   ```
2. **Esegui lo script di verifica:**
   ```bash
   .claude/skills/creazione-sito/scripts/verifica.sh http://localhost:4173/<pagina>.html screenshots/<pagina>
   ```
   Fa screenshot a 1440×900 e 390×844 (viewport e pagina intera), controlla lo scroll orizzontale, l'uso di Inter e lancia `impeccable detect` sulla pagina renderizzata. Esce con 0 solo se tutto è pulito.
3. **Guarda gli screenshot** con il tool Read (`desktop.png`, `mobile.png`, e i `-full.png`). Cerca: sovrapposizioni, testo tagliato, contrasto basso, spaziature incoerenti, gerarchia debole, elementi che sembrano un template.
4. **Esegui `/impeccable audit`** sulla pagina; se il design è debole, anche `/impeccable critique`.
5. **Correggi.** Per i problemi di stile usa i comandi di Impeccable adatti: `polish` (rifinitura), `distill` (semplificare), `bolder` (pagina piatta), `quieter` (pagina rumorosa), `animate` (movimento).
6. **Ripeti dal punto 2** finché script, detector e audit sono puliti e gli screenshot non mostrano problemi. Se un avviso è un'eccezione voluta, annotala con il motivo invece di ignorarla in silenzio (es. `npx impeccable ignores add-value overused-font <Font> --reason "..."`).

## 4. Consegna

1. Mostra all'utente gli screenshot finali desktop e mobile (SendUserFile o un artifact).
2. Indica lo stile DESIGN.md usato, il font e la palette scelti.
3. Elenca le eccezioni alle regole, ciascuna con il motivo.
4. Non committare la cartella `screenshots/` se l'utente non lo chiede; commit e push del codice del sito sul branch di lavoro.
