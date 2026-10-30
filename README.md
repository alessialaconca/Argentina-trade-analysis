# Argentina: commercio internazionale e specializzazione produttiva

**Un’analisi dei flussi commerciali, dei partner e della struttura settoriale dell’Argentina, realizzata con Stata per il corso di Economia e Politica Internazionale (maggio 2025).**

Il progetto studia come si è evoluto il commercio estero argentino, quali prodotti e mercati ne sostengono gli scambi e quanto questi siano caratterizzati da specializzazione o da scambi bidirezionali negli stessi settori. All’andamento di importazioni ed esportazioni affianca un approfondimento sui rapporti con gli Stati Uniti, sui profili tariffari e sul peso dei beni intermedi.

## Obiettivi e dati

Il lavoro risponde a quattro domande:

- Come cambiano esportazioni, importazioni, saldo commerciale e apertura al commercio estero?
- Quali settori e paesi partner hanno il peso maggiore negli scambi argentini?
- Quali specializzazioni emergono dal commercio settoriale e dagli scambi con gli USA?
- Quanto incidono i beni intermedi sulle importazioni e sulle esportazioni?

La fonte principale è **UN Comtrade**, affiancata da dati sul PIL attribuiti alla **World Bank** nei materiali del progetto e da un esame dei profili tariffari **CEPII**. Le serie dei beni disponibili coprono il **2015–2024**; l’analisi con il PIL si concentra sul **2015–2023**. Gli approfondimenti per settore, partner e beni intermedi riguardano il **2024**, mentre i dati dei servizi sono del **2021**.

## Cosa è stato fatto

Il lavoro comprende la selezione e la pulizia delle variabili, l’unione dei dataset di import ed export, il calcolo degli indicatori e la loro rappresentazione grafica. Le elaborazioni sono state sviluppate in **Stata** e raccolte in una relazione che interpreta la struttura del commercio argentino.

| Ambito | Analisi svolta |
| --- | --- |
| Evoluzione del commercio | Confronto delle serie annuali di import ed export, anche in logaritmi, e calcolo del saldo commerciale. |
| Apertura commerciale | Rapporto fra la media di esportazioni e importazioni e il PIL: `(X + M) / (2 × PIL) × 100`. |
| Concentrazione degli scambi | Calcolo di quote e quote cumulate per individuare i principali settori e partner. |
| Specializzazione settoriale | Costruzione di un RCA adjusted basato sul saldo settoriale, corretto per il saldo complessivo e rapportato al PIL. |
| Commercio con gli USA | Calcolo dei saldi settoriali e dell’indice Grubel–Lloyd, per settore e in forma aggregata. |
| Tariffe e beni intermedi | Confronto descrittivo dei profili tariffari e selezione delle categorie intermedie della classificazione BEC. |

I risultati sono presentati attraverso grafici temporali, composizioni per settore e paese, diagrammi degli indici settoriali e confronti dei saldi commerciali.

## Risultati principali

### 1. Contrazione, ripresa e variazioni del saldo commerciale

Fra il 2015 e il 2023, entrambi i flussi raggiungono il minimo nel **2020**, seguito da una ripresa nel 2021 e nel 2022. Nel 2022 le esportazioni raggiungono **88,45 miliardi di dollari** e le importazioni **81,52 miliardi**. Nel 2023 entrambi i flussi diminuiscono e il saldo torna negativo, dopo quattro anni consecutivi di avanzo.

| Anno | Esportazioni | Importazioni | Saldo commerciale |
| --- | ---: | ---: | ---: |
| 2020 | 54,88 | 42,36 | +12,53 |
| 2021 | 77,93 | 63,18 | +14,75 |
| 2022 | 88,45 | 81,52 | +6,92 |
| 2023 | 66,79 | 73,71 | −6,93 |
| 2024 | 79,72 | 60,82 | +18,90 |

*Valori in miliardi di dollari correnti, dalle estrazioni UN Comtrade conservate; esportazioni FOB e importazioni CIF. Il 2024 completa le serie disponibili, mentre l’analisi con il PIL termina nel 2023.*

Nel dataset elaborato con il PIL, l’apertura commerciale passa da circa **9,83% nel 2015** a un massimo di **14,50% nel 2021**, per scendere al **10,87% nel 2023**. Questi valori usano la media di import ed export: il rapporto alternativo `(X + M) / PIL` sarebbe doppio per costruzione.

### 2. Il ruolo dei partner e le differenze fra import ed export

Il **Brasile** è il primo partner su entrambi i fronti. Nel 2024 le principali destinazioni dell’export sono Brasile (**17,07%**), USA (**8,11%**) e Cile (**7,94%**). Per l’import, Brasile (**23,51%**), Cina (**19,17%**) e USA (**10,24%**) rappresentano insieme circa il **53%** del totale distribuito fra i partner.

La composizione settoriale evidenzia differenze fra ciò che il paese vende e ciò che acquista:

- **Esportazioni:** dopo la categoria residuale dei beni non specificati (13,98%), spiccano cereali (12,69%), residui delle industrie alimentari e mangimi (10,53%), veicoli (9,81%) e combustibili minerali (9,44%).
- **Importazioni:** prevalgono macchinari e apparecchi meccanici (15,88%), veicoli (14,73%) e apparecchiature elettriche (10,06%).

Le quote per partner escludono la riga del totale mondiale. Le quote settoriali sono calcolate sul totale dei settori presenti nelle rispettive estrazioni.

L’elaborazione originale dell’RCA adjusted segnala valori positivi per cereali e residui delle industrie alimentari, e negativi per macchinari e apparecchiature elettriche. Questa lettura resta qualitativa: scala del PIL e costruzione dell’indicatore richiedono ancora verifica.

### 3. Una componente minoritaria di commercio intra-settoriale con gli USA

L’indice **Grubel–Lloyd aggregato è circa 0,325**. L’indicatore varia da 0, quando non ci sono scambi bidirezionali nello stesso settore, a 1, quando importazioni ed esportazioni si bilanciano in ciascun settore. Il valore ottenuto indica una componente di commercio intra-settoriale presente, ma minoritaria secondo questa misura.

Il ricontrollo dei CSV bilaterali del 2024 restituisce un **avanzo argentino di circa 0,24 miliardi di dollari** per i beni. Questo risultato differisce dal deficit riportato nella relazione originale; nella presente sintesi è utilizzato il valore ricavato dai dati conservati.

### 4. Il peso dei beni intermedi

I beni intermedi rappresentano il **63,26% delle importazioni** e il **47,24% delle esportazioni** nel 2024. Sono quindi maggioritari negli acquisti dall’estero e costituiscono quasi metà delle vendite estere.

Il risultato evidenzia il ruolo di materiali, componenti e semilavorati negli scambi argentini. È un elemento utile per studiare i legami produttivi internazionali, ma non misura direttamente la partecipazione alle catene globali del valore in termini di valore aggiunto.

## Cosa emerge dal progetto

L’analisi descrive un commercio estero variabile nel tempo, con un ruolo centrale del Brasile e una struttura dell’export in cui hanno rilievo prodotti agricoli, alimentari, veicoli ed energia. Nell’import pesano soprattutto macchinari, veicoli e apparecchiature elettriche. Le quote dei beni intermedi e l’indice Grubel–Lloyd aggiungono due prospettive complementari: la funzione produttiva dei beni scambiati e il grado di sovrapposizione fra settori di importazione ed esportazione.

Il lavoro è **descrittivo**: documenta andamenti e differenze nella struttura degli scambi, senza stimare effetti causali di crisi, politiche economiche o tariffe.

## Materiali e limiti

Sono disponibili il [report originale](report/_LaConca.pdf), il [codice Stata](code/dofile_LaConca.do) e i [dati con la loro descrizione](data/README.md). I grafici sono consultabili nella relazione.
