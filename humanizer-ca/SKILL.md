---
name: humanizer-ca
description: |
  Reescriu text en català que sona a IA perquè es llegeixi com si l'hagués escrit una
  persona, sense canviar què diu. Fes-lo servir per editar o revisar prosa en català amb
  crosses d'IA, llenguatge de venda, fonts vagues, estructura repetitiva, castellanismes,
  puntuació o pronoms febles mal posats, farciment o restes de xatbot. També quan et diguin
  "humanitza això", "fes-ho més humà" o "humanitza el text de dalt". Capa catalana sobre
  el mètode de `humanizer`.
license: MIT
metadata:
  version: "0.1"
---

# Humanizer CA: treure el to IA en català

Reescriu text que sona a IA perquè llegeixi com la persona que escriu, no com un xatbot.
No canviïs què diu ni t'inventis dades. Torna el text en català correcte: apòstrofs,
punt volat (l·l), accents oberts i tancats, i pronoms febles al seu lloc.

Aquest skill és una **capa catalana** sobre `humanizer` (SoT del mètode i de les regles
estructurals). No dupliquis aquí els 35 patrons: aplica els estructurals de `humanizer`
tal com són i afegeix el que és propi del català.

## Com invocar-lo

Funciona amb `/humanizer-ca` i també en llenguatge natural: "humanitza això",
"fes-ho més humà", "treu-li el to d'IA", "passa-ho a català humà".

**Si et diuen "el text de dalt" / "de sota" / "això"** sense enganxar res: agafa el bloc de
text immediatament anterior (o posterior) de la conversa. Si hi ha més d'un candidat o no
és clar quin és, pregunta-ho en una línia abans de reescriure. No reescriguis codi, sortida
de terminal ni missatges del sistema encara que siguin el bloc anterior.

Si et donen una ruta de fitxer, treballa en mode fitxer (a sota).

## Què fer

1. **Aplica el mètode de `humanizer`.** Els patrons estructurals són iguals en qualsevol
   llengua: guions llargs (—/–), cometes tipogràfiques, excés de negreta, emojis, llistes
   amb mini-títols en negreta, grups forçats de tres, rangs falsos "de X a Y", restes de
   xatbot, disculpes de límit de coneixement, farciment i excés de matisos.
2. **Conserva cada afirmació.** Pots escurçar el que és avorrit, ampliar el que és útil i
   unir o partir paràgrafs. No afegeixis cap dada, nom, xifra, data, cita ni font que no
   vingui de l'original o de l'usuari. Si falta una dada, pregunta o fes una frase més simple.
3. **Mantén la varietat i el registre.** No passis de central a valencià ni al revés, ni de
   *tu* a *vostè*. Si l'original escriu *hui*, *aquest*, *seua* o *amb*, respecta-ho.
4. **Veu.** Personalitat només si el text i qui escriu ho demanen (blog, opinió, personal).
   Text tècnic, legal o de referència: neutre i pla.

Si l'usuari dona una mostra de la seva escriptura, imita-la i prioritza els seus hàbits.

## Paraules i frases d'IA en català

Mateixes categories que §7 de `humanizer`, amb el lèxic real del català. Surten molt més en
text d'IA, sobretot en grup. No les prohibeixis una per una: treu-les quan inflen una idea
corrent.

**Importància inflada / crosses:** cal destacar, cal esmentar, cal remarcar, és important
assenyalar/destacar, sens dubte, sense cap mena de dubte, avui dia, en l'actualitat, en un
món cada cop més, marca un abans i un després, punt d'inflexió, s'erigeix com, es posiciona
com, juga un paper fonamental/clau/cabdal, de vital importància, al cor de, ric patrimoni,
un seguit de, un ampli ventall de, una àmplia gamma de.

**Verbs que esquiven *ser*/*tenir* (§8):** compta amb, disposa de, ofereix, es caracteritza
per, destaca per, acull → fes servir *és*, *té*, *hi ha*.

**Venda (§4):** impressionant, fascinant, enlluernador, situat/enclavat a, submergeix-te en,
descobreix, no t'ho pots perdre, experiència única, joia amagada.

**Tancaments i transicions de farciment:** en resum, en conclusió, en definitiva, d'altra
banda, per altra banda, a més (apilats), el futur és prometedor, continua creixent.

**Farciment (§23) → curt:** amb la finalitat de → per a; pel fet que → perquè; en el moment
actual → ara; té la capacitat de → pot; a dia d'avui → avui.

## Específic del català (el valor real d'aquest skill)

### Castellanismes i calcs
El tell més fort: els models s'entrenen sobretot en castellà i calquen. Revisa'ls sempre.

| Calc | Correcte |
|---|---|
| tenir que | haver de |
| donar-se compte | adonar-se |
| en quant a | quant a / pel que fa a |
| degut a (causal) | a causa de / per |
| hi han (plural) | hi ha (invariable) |
| el mateix / la mateixa (com a pronom) | repeteix el nom o fes servir un pronom feble |
| disfrutar | gaudir |
| acercar | acostar |
| logro | assoliment / fita |
| enfoque | enfocament |
| apoyar | donar suport |
| busqueda | cerca / recerca |
| desarrollar | desenvolupar |
| bueno, vale, pues (en text escrit) | treu-ho o reescriu |

### Pronoms febles
La IA els deixa caure i el text sona traduït. Reposa'ls: *n'hi ha*, *hi anem*, *en parlem*,
*se'n va*, *dona-l'hi*. La seva absència és un dels senyals més clars de text no català.

### Punt volat (l·l)
`col·legi`, `intel·ligent`, `paral·lel`, `excel·lent`, `instal·lació`. La IA sovint escriu
`colegi`, `intelligent` o fa servir un punt normal. Revisa-ho abans de tornar el text.

### Apostrofació i contraccions
`l'empresa`, `d'acord`, `s'ha`, `n'hi`, `porta'l`, `pel`, `del`, `als`. Comprova cada
apòstrof: un editor en anglès o castellà els trenca.

### Accents oberts i tancats
`è`/`é` i `ò`/`ó` no són intercanviables: *cafè*, *què*, *això*, *òbviament*, *només*.
Recorda la reforma de 2016: molts diacrítics van desaparèixer i només en queden uns quants
(*sóc/soc* no, però sí *mà*, *més*, *sí*, *són* segons la norma vigent). En cas de dubte,
deixa la forma de l'original: no "corregeixis" el que ja és correcte.

### Majúscules en títols (§17)
El català no posa majúscula inicial a cada paraula: "Estratègies de negociació", no
"Estratègies De Negociació".

### Article personal
En central s'escriu *en Joan*, *la Maria*. No l'afegeixis ni el treguis: segueix l'original.

## Copy i màrqueting (SEONOVE)

`humanizer` §4 treu el llenguatge de venda. En copy publicitari això és massa: persuadir
**és** la feina del text. Regla per a aquest cas:

- **Conserva** la persuasió real: benefici concret, prova, xifra, oferta, crida a l'acció clara.
- **Treu** la persuasió buida d'IA: superlatius sense dada (*impressionant*, *únic*,
  *revolucionari*), promeses sense subjecte, entusiasme genèric, tancaments d'aire optimista.
- Un claim de màrqueting necessita un fet al darrere. Si no el tens, demana'l; no te
  l'inventis (regla 2, sense excepcions per a copy).

Si el text és copy, digues-ho al resum: "mode copy — persuasió conservada, farciment tret".

## Falsos positius

Valen els mateixos avisos que `humanizer` § "Check for false positives". A més:
- Un gerundi correcte i sol no és cap tell; el problema és la cadena de tres o més.
- *Vostè* no és to d'IA: és registre. No el treguis.
- El valencià o el balear no són errors a "corregir" cap al central.
- Les formes col·loquials pròpies de l'autor (*doncs*, *escolta*, *mira*) en text informal
  són veu, no crossa.

## Com tornar el resultat

Igual que `humanizer`:
- **Text enganxat (per defecte):** esborrany, llista breu de tells que queden, i versió final.
- **Mode fitxer:** amb una ruta, reescriu només la prosa; deixa codi, YAML, dades i enllaços
  intactes; després fes un resum curt.
- **Mode integrat (PR, commit, doc):** torna només el text final.

## Procés

1. Marca cada tell (estructural de `humanizer` + lèxic català de dalt).
2. Escriu un esborrany. Llegeix-lo en veu alta: ritme, verbs simples (*és*/*té*), registre.
3. Pregunta't: què segueix sonant a IA? He afegit o tret cap dada, nom, xifra o cita?
   Qualsevol dada afegida o perduda és un error.
4. Escriu la versió final. Revisa punt volat, apòstrofs, accents i pronoms febles.
   Aplica la regla de guions (§14).

## Font

Mètode i patrons estructurals: el skill `humanizer` (mateix repo / mateixa carpeta de
skills), basat en
[Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).
El lèxic català d'aquest skill és propi, per als mateixos tipus de patró.
