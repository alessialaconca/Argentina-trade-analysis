*66769_LaConca

*-------------- PUNTO 1 -----------------

use arg_10anni_exp.dta
*La variabile keep mi permette di mantenere solo le variabili necessarie, rimuovendo quindi tutte le variabili superflue mantenendo  solo l'anno di riferimento, i paesi di riferimento e il valore dell'export/import
keep refyear partnerdesc reporteriso fobvalue

*Grazie alla variabile ren rinomino la variabile export
ren fobvalue export

*In vista del grafico creo la variabile logaritmica dell'export in modo da avere un grafico più pulito con la variabile gen che permette di creare una nuova variabille
gen log_exp= ln(export)
save arg_10anni_exp.dta

*Svolgo gli stessi passaggi per l'import
use arg_10anni_exp.dta
keep refyear partnerdesc reporteriso cifvalue
ren cifvalue import
gen log_imp= ln(import)
save arg_10anni_exp.dta

*Procedo a utilizzare la funzione merge per unire i valori di import ed export dei due dataset. Questa funzione permette appunto di unire i valori di due dataset ordinati per una o più variabili che questi hanno in comune. In questo caso è utile per poter poi creare il grafico che mostra l'andamento dell'import e dell'export
merge 1:1 refyear partnerdesc reporteriso using arg_10anni_exp.dta

*Drop mi consente di rimuovere le variabili indicate, quindi rimuovo la variabile merge che si crea utilizzando la funzione
drop _merge
save arg_10anni_completo

*Per poter utilizzare merge 1:1 con il gdp (disponibile solo fino al 2023) nel secondo punto del report, ho rimosso il valore del 2024 avendo quindi i dati dal 2014 al 2023
drop in 10 

*Creo un grafico a linee per mostrare l'andamento dell'import e export.
 twoway (line log_import refyear, lcolor(blue) lwidth(medium)) (scatter log_import refyear, mcolor(blue) msymbol(circle)) (line log_ex
> port refyear, lcolor(maroon) lwidth(medium) lpattern(dash)) (scatter log_export refyear, mcolor(maroon) msymbol(triangle)),title("And
> amento delle importazioni e delle esportazioni", size(medium) color(black)) subtitle("Valori in logaritmi", size(small)) legend(label
> (2 "Importazioni") label(4 "Esportazioni") position(3) ring(10) cols(1)) xtitle("Anno", size(small)) ytitle("Log(importazioni e espor
> tazioni)", size(small))

save arg_10anni_e_gdp_completo.dta
*-------------- PUNTO 2 -----------------

use gdp.dta

*Dato che il gdp viene riconosciuto come stringa e non come numero creo una nuova variabile senza il punto (l'elemento per cui stata lo riconosce come stringa). Quindi lo modifico in modo da ottenere valori numerici utilizzando poi la funzione destring su questo valore. Dopodichè sostituisco la precedente variabile gdp con la variabile gdp numerica con le variabili drop e poi rename per rinominarla nel modo più comodo per essere poi richiamata in seguito.
gen gdp_clean = subinstr(gdp, ".", "", .)
destring gdp_clean, replace
drop gdp
rename gdp_clean gdp

*Unisco ora i dataset dei valori per i 10 anni con i valori corrispondenti del gdp utilizzando come variabile in comune refyear (l'anno di riferimento)
use arg_10anni_completo.dta
merge 1:1 refyear using gdp.dta
drop _merge

*Creo con la funzione gen la variabile che calcola la bilancia commerciale
gen bilancia_comm = export-import

*Creo quindi la variabile che mi permette di misurare il grado di apertura del paese. Utilizzo la formula di pagina 3 del documento del CEPII
gen apertura = (export + import)/2 / gdp * 100

*Creo un grafico a linee per mostrare l'andamento dell'apertura e della bilancia commerciale in questi anni (2014-2023)
twoway (line apertura refyear, lcolor(blue) lpattern(solid) lwidth(medium)) 
twoway (line bilancia_comm refyear, lcolor(blue) lpattern(solid) lwidth(medium)) 


save arg_10anni_e_gdp_completo.dta, replace

*-------------- PUNTO 3 -----------------

*----- settori ------

*per valori dei settori export rimuovo tutte le variabili superflue mantenendo quindi i paesi di riferimento, il valore dell'export/import e i codici dei settori 
keep reportercode reporteriso cmdcode cmddesc fobvalue
ren fobvalue exports

*genero una nuova variabile equivalente alla somma totale dei valori degli export dei settori con la funzione egen. Egen infatti a differenza della funzione gen crea variabili usando funzioni spesso basate su statistiche di gruppo o su più righe.
egen Tot_X=total(exports)

*genero ora la variabile che mostra quanto il singolo settore occupa nel totale delle esportazioni utilizzando la funzione gen 
gen sect_shares= exports/ Tot_X

*genero la variabile che conta il numero dei settori esportatori dell'Argentina con egen
egen Numb_sector=count(exports)

*creo una variabile RankSect che assegna un rango decrescente ai valori di exports utilizzando rank(export)
egen RankSect=rank( exports)

*utilizzo gsort per ordinare i dati sulla base del ranking dei settori o dei paesi. La funzione gsort con il simbolo "-" prima della variabile infatti ordina i dati dal valore più alto di sect_shares al più basso.
gsort -sect_shares

*genero una variabile per calcolare la cumulata del valore dei settori e metto come limite l'80%, in modo da comprendere solo i settori che compongono l'80% del commercio del paese. Per fare ciò utilizzo keep if  
gen sect_shares_cum=sum( sect_shares)
label var sect_shares_cum "comulative values of destination shares"
keep if sect_shares_cum<=.8
save arg_export_punto3.dta

*Per avere il nome delle variabili chiaro nel grafico riassumo la loro descrizione con la funzione replace if
replace cmddesc = "Commodities not specified" if cmdcode == 99
replace cmddesc = "Cereals"                   if cmdcode == 10
replace cmddesc = "Food industries"           if cmdcode == 23
replace cmddesc = "Vehicles"                  if cmdcode == 87
replace cmddesc = "Mineral fuels"             if cmdcode == 27
replace cmddesc = "Animal/vegetable fats"     if cmdcode == 15
replace cmddesc = "Meat"                      if cmdcode == 2
replace cmddesc = "Oil seeds"                 if cmdcode == 12
replace cmddesc = "Natural pearls & jewelry"  if cmdcode == 71
replace cmddesc = "Fish and crustaceans"      if cmdcode == 3

*per creare una pie chart devo trasformare i valori dei settori in percentuale. Genero quindi una nuova variabile con questa caratteristica
gen sector_share_pct = sect_shares * 100
graph pie sector_share_pct, over(cmddesc) plabel(_all percent, size(*0.8)) title("Quote settoriali export") 

*Svolgo gli stessi passaggi per i valori dei settori dell' import

keep reportercode reporteriso cmdcode cmddesc cifvalue
ren cifvalue imports
egen Tot_M=total(imports)
gen sect_shares= imports/ Tot_M
egen Numb_sector=count(imports)
egen RankSect=rank( imports), field

gsort -sect_shares
gen sect_shares_cum=sum( sect_shares)
label var sect_shares_cum "comulative values of destination shares"
keep if sect_shares_cum<=.8
save arg_import_punto3.dta

replace cmddesc = "Oil seeds"              if cmdcode == 12
replace cmddesc = "Mineral fuels"          if cmdcode == 27
replace cmddesc = "Organic chemicals"      if cmdcode == 29
replace cmddesc = "Pharmaceuticals"        if cmdcode == 30
replace cmddesc = "Fertilizers"            if cmdcode == 31
replace cmddesc = "Chemical products"      if cmdcode == 38
replace cmddesc = "Plastics and articles"  if cmdcode == 39
replace cmddesc = "Rubber and articles"    if cmdcode == 40
replace cmddesc = "Iron and steel"         if cmdcode == 72
replace cmddesc = "Machinery"              if cmdcode == 84
replace cmddesc = "Electrical equipment"   if cmdcode == 85
replace cmddesc = "Vehicles"               if cmdcode == 87
replace cmddesc = "Instruments"            if cmdcode == 90

gen sector_share_pct = sect_shares * 100
graph pie sector_share_pct, over(cmddesc) plabel(_all percent, size(*0.8)) title("Quote settoriali import") 


*----- paesi ------

*svolgo gli stessi passaggi ora per i differenti paesi con cui commercia l'Argentina per trovare quelli compresi nel 70% del totale delle importazioni/esportazioni

*inizio dall'export.
*In questo caso, mantengo le variabili corrispondenti all'abbreviazione di riferimento per l'Argentina, il codice dei vari paesi con cui commercia e l'abbreviazione del loro nome.
use arg_exp_all.dta
keep reportercode reporteriso partnercode partneriso fobvalue
ren fobvalue exports
label var exports "exports by destination"

egen Tot_X=total(exports)
label var Tot_X "total good exports"
gen dest_shares= exports/ Tot_X
label var dest_shares "destination shares"
egen Numb_destination=count(exports)
egen RankDest=rank( exports), field


gsort -dest_shares
gen dest_shares_cum=sum( dest_shares)
label var dest_shares_cum "comulative values of destination shares"
keep if dest_shares_cum<=.7

*Creo il grafico
gen dest_share_pct = dest_shares * 100
graph pie dest_share_pct, over(partneriso) plabel(_all percent, size(*0.8)) title("Quote paesi export")

*svolgo gli stessi passaggi per l'import 
use arg_imp_all.dta
keep reportercode reporteriso partnercode partneriso cifvalue
ren cifvalue imports
label var imports "import by destination"

egen Tot_M=total(imports)
label var Tot_M "total good imports"
gen dest_shares= imports/ Tot_M
label var dest_shares "destination shares"
egen Numb_destination=count(imports)
egen RankDest=rank( imports), field

gsort -dest_shares
gen dest_shares_cum=sum( dest_shares)
label var dest_shares_cum "comulative values of destination shares"
keep if dest_shares_cum<=.7
save arg_imp_all.dta, replace

*Creo il grafico
 


*-------------- PUNTO 4 -----------------

*utilizzando gli stessi dati usati per il punto 3 unisco i due file per avere in un unico dataset import ed export con la funzione merge.
use arg_export_punto3.dta
merge 1:1 reportercode reporteriso cmdcode using arg_import_punto3.dta
save punto_4_finale

*per unire con il gdp solo del 2023, creo una nuova variabile momentanea per poter utilizzare merge m:1 in modo da avere il valore del gdp del 2023 in tutte le righe del dataset
use solo_v2_2023.dta, clear
gen joinkey = 1
save solo_v2_2023.dta, replace

*creo la variabile anche nel dataset principale
use punto_4_finale.dta, clear
gen joinkey = 1
*unisco il valore del gdp 
merge m:1 joinkey using solo_v2_2023.dta

*rimuovo ora le variabili superflue e rinomino la variabile del gdp
drop joinkey _merge
ren v2_clean gdp


*ora calcolo il RCA adjusted (Revealed Comparative Advantage)

*calcolo la bilancia commerciale settoriale:
gen trade_balance_k = exports - import
*calcolo la bilancia commerciale totale:
gen trade_balance_total = Tot_X - Tot_M
*calcolo il peso (rapporto fra commercio del settore e commercio totale):
gen weight_k = (exports + import) / (Tot_X + Tot_M)
*calcolo l'aggiustamento (parte tra parentesi quadre):
gen adjustment = trade_balance_k - trade_balance_total * weight_k
*calcolo il RCA finale:
gen rca_adj2 = (1000 / gdp) * adjustment


*creo un grafico dot plot 
graph twoway (scatter cmdcode rca_adj2, msymbol(o) msize(vsmall)), xline(0, lpattern(dash) lcolor(gs8)) ylab(, angle(0) labsize(vsmall)) title("Dot chart di rca_adj per cmdcode") xtitle("rca_adj") ytitle("cmdcode")

*-------------- PUNTO 5 -----------------

*Sia nel dataset dell'import che dell'export, rimuovo tutte le variabili superflue mantenendo quindi i paesi di riferimento, il valore dell'export/import e i codici dei settori
use arg_usa_export.dta
keep refyear reporteriso partneriso cmdcode fobvalue
ren fobvalue exports
save arg_usa_export.dta, replace

use arg_usa_import.dta
keep refyear reporteriso partneriso cmdcode cifvalue
ren cifvalue imports

*Unisco i dataset per avere export e import insieme
merge 1:1 cmdcode refyear reporteriso partneriso using arg_usa_export.dta
drop _merge

*Ordino il dataset per il codice del settore in modo crescente con la funzione gsort
gsort cmdcode

*utilizzo la funzione replace if che mi permette di sostituire valori specifici nelle variabili indicate. In questo caso vista la presenza di valori nulli nelle variabili di export e import li sostituisco con il valore 0 per poter svolgere in seguito i calcoli 
replace exports = 0 if exports == .
replace imports = 0 if imports == .

*Genero le variabili che comprendono il valore totale delle importazioni e esportazioni con gli USA
gen X_usa = total(exports)
label var X_usa "totale export"

gen M_usa = total(imports)
label var M_usa "totale import"

*Calcolo l'indice di Grubel-Lloyd

*Sommo le variabili import ed export per ogni settore
gen sum_XM = exports + imports

*Ne calcolo la differenza in valore assoluto
gen abs_diff = abs(exports - imports)

*Calcolo con le variabili create il valore dell'indice
gen GL_index = 1 - (abs_diff / sum_XM)

*calcolo ora il G&L by partner regions
gen somme = (exports + imports) / (X_usa + M_usa)
gen GL_sett = GL_index * somme
egen GL_finale = total (GL_sett)

*creo il dot graph per mostrare il valore del GL index 
graph twoway (scatter cmdcode GL_index, msymbol(o) msize(vsmall)), xline(0, lpattern(dash) lcolor(gs8)) ylab(, angle(0) labsize(vsma
> ll))  xtitle("GL_index") ytitle("cmdcode")

*svolgo i passaggi ora per i servizi
use punto_5_servizi_finito.dta
*dato che il valore degli export è nullo lo sostituisco con 0
replace exports = 0 if exports == .

*per i servizi il valore dell'indice è zero dato che è zero il valore dell'export dall'Argentina verso gli USA. Di conseguenza i valori degli indici saranno anche loro pari a 0.

*---- trade balance ----

*utilizzo la funzione gen per creare la variabile del trade balance settoriale
gen trade_balance= exports-imports

*per creare un grafico con i settori principali utilizzo innanzitutto gsort - per ordinarli e avere un ordine decrescente.
gsort -trade_balance

*genero poi un a variabile indice per selezionare i primi 10 e elimino tutti i valori successivi al decimo con keep if
gen rank = _n
keep if rank <= 10

*creo ora il grafico a barre con i primi 10 valori
graph bar trade_balance, over(cmdcode, sort(1) descending label(angle(45))) bar(1, color(navy)) title("Top 10 Tra
> de Balance by CMD Code")

save trade_balance_grafico

*-------------- PUNTO 7 -----------------

*mantengo con la funzione keep le variabili necessarie: l'anno di riferimento, le variabili per riconoscere il paese, il codice del settore e il valore dell'import
keep period reportercode reporteriso cmdcode cifvalue
ren cifvalue imports

*Utilizzo la funzione collapse (sum) che consente di sommare i valori di una variabile per le variabili che vengono definite, mantenendo però una sola riga, lasciando quindi nel dataset solo la riga con il valore necessario. Quindi sommo i valori intermedi dell'import in una sola riga, definita per il codice del paese e l'anno di riferimento.
collapse (sum) imports, by (reportercode refyear)
ren imports imports_interm
save arg_usa_M_TotInterm_punto7

*svolgo gli stessi passaggi per l'export
keep refyear reportercode reporteriso cmdcode fobvalue
ren fobvalue exports
collapse (sum) exports, by (reportercode refyear)
ren exports exports_interm
save arg_usa_X_TotInterm_punto7


*---------------
*Lavoro ora sul file in cui sono presenti i totali delle importazioni e esportazioni con gli USA
use ARG_USA_X_M_BEC_Tot_P7.dta

*mantengo quindi la variabile che contiene le informazioni necessarie per il calcolo delle quote: flusso, anno, paese, codice settore e valori di import/export
keep flowcode refyear reportercode reporteriso cmdcode cifvalue fobvalue

*rinomino i valori monetari di import/export 
ren cifvalue imports
ren fobvalue exports

*aggiungo etichette descrittive alle variabili di import/export totali
label var imports "total BEC imports"
label var exports "total BEC exports"

save ARG_USA_X_M_BEC_Tot_P7

*lavoro prima per ottenere solo i valori dell'import dal file totale
keep in 1

*rimuovo i valori legati all'export e le variabili non necessarie
drop exports
drop flowcode reportercode reporteriso cmdcode

*unisco quindi il file appena ottenuto con i totali intermedi calcolati in precedenza, in base all'anno, con la funzione merge
merge 1:1 period using arg_usa_M_TotInterm_punto7
drop _merge

*con la variabile gen creo la variabile che rappresenta la quota delle importazioni di beni intermedi sul totale delle importazioni
gen interm_share = imports_interm / imports
label var interm_share "share of intermediates in imports"

save ARG_M_BEC_Shares.dta

*per creare un grafico a torta, genero la variabile complementare che rappresenta il resto delle importazioni (beni non intermedi)
gen altri_beni = 1 - interm_share

*genero il grafico a torta che rappresenta la composizione percentuale delle esportazioni
graph pie interm_share altri_beni, plabel(_all percent)

*svolgo gli stessi passaggi ma ora per ottenere le quote dell'export
use use ARG_USA_X_M_BEC_Tot_P7.dta
keep in 2
drop imports
drop flowcode reportercode reporteriso cmdcode

merge 1:1 refyear using arg_usa_X_TotInterm_punto7
drop _merge

gen interm_share = exports_interm / exports
label var interm_share "share of intermediates in exports"

save ARG_X_BEC_Shares.dta
gen altri_beni = 1 - interm_share
graph pie interm_share altri_beni, plabel(_all percent)
