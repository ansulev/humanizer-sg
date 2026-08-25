---
name: humanizer-es
description: |
  Reescribe texto en español que suena a IA para que lea como lo escribiría una
  persona, sin cambiar lo que dice. Úsalo al editar o revisar prosa en español con
  muletillas de IA, lenguaje de venta, fuentes vagas, estructura repetitiva, palabras
  de relleno o restos de chatbot. También cuando te digan "humaniza esto", "hazlo más
  humano" o "humaniza el texto de arriba". Capa en español sobre el método de `humanizer`.
license: MIT
metadata:
  version: "0.1"
---

# Humanizer ES: quitar el tono IA en español

Reescribe texto que suena a IA para que lea como la persona que escribe, no como un
chatbot. No cambies lo que dice ni inventes datos. Devuelve el texto en español, con
tildes, ñ y signos de apertura `¿` `¡` correctos.

Este skill es una **capa en español** sobre `humanizer` (SoT del método y de las reglas
estructurales). No dupliques aquí los 35 patrones: aplica los estructurales de `humanizer`
tal cual y añade lo específico del español de abajo.

## Cómo invocarlo

Funciona con `/humanizer-es` y también en lenguaje natural: "humaniza esto",
"hazlo más humano", "quítale el tono de IA".

**Si te dicen "el texto de arriba" / "de abajo" / "esto"** sin pegar nada: toma el bloque de
texto inmediatamente anterior (o posterior) de la conversación. Si hay más de un candidato o
no está claro cuál es, pregúntalo en una línea antes de reescribir. No reescribas código,
salida de terminal ni mensajes del sistema aunque sean el bloque anterior.

Si te dan una ruta de fichero, trabaja en modo fichero (más abajo).

## Qué hacer

1. **Aplica el método de `humanizer`.** Los patrones estructurales son iguales en cualquier
   idioma: rayas (—/–), comillas tipográficas (`"` `"` → `"`), negrita de más, emojis,
   listas con mini-títulos en negrita, grupos forzados de tres, rangos falsos "de X a Y",
   restos de chatbot, disculpas de límite de conocimiento, relleno y exceso de matices.
2. **Conserva cada afirmación.** Puedes acortar lo aburrido, ampliar lo útil y unir o partir
   párrafos. No añadas ningún dato, nombre, cifra, fecha, cita o fuente que no venga del
   original o del usuario. Si falta un dato, pregunta o usa una frase más simple.
3. **Mantén el registro.** No cambies *tú* por *usted* ni al revés. Conserva el español del
   autor (peninsular, latino, etc.); no lo "neutralices" salvo que se pida.
4. **Voz.** Añade personalidad solo si el texto y el autor lo piden (blog, opinión, personal).
   Texto técnico, legal o de referencia: neutro y llano.

Si el usuario da una muestra de su escritura, imítala y prioriza sus hábitos sobre estas reglas.

## Palabras y frases de IA en español

Las mismas categorías que §7 de `humanizer`, pero con el léxico real del español. Aparecen
mucho más en texto de IA, sobre todo en grupo. No las prohíbas de una en una: quítalas cuando
inflan una idea corriente.

**Importancia inflada / muletillas:** cabe destacar, cabe mencionar, cabe resaltar, es
importante señalar/mencionar/destacar, sin lugar a dudas, sin duda alguna, hoy en día, en la
actualidad, en un mundo cada vez más, marca un antes y un después, punto de inflexión, se erige
como, se posiciona como, juega un papel fundamental/crucial/clave, de vital importancia, en el
corazón de, rico patrimonio, un sinfín de, una amplia gama de, un abanico de.

**Verbos que esquivan *es*/*tiene* (§8):** cuenta con, dispone de, ofrece, brinda, se
caracteriza por, destaca por, alberga → usa *es*, *tiene*, *hay*.

**Venta (§4):** impresionante, fascinante, deslumbrante, enclavado/ubicado en, sumérgete en,
descubre, no te lo puedes perder, experiencia única, joya escondida.

**Cierres y transiciones de relleno:** en resumen, en conclusión, en definitiva, por otro
lado, por otra parte, además (apilados), el futuro es prometedor, sigue creciendo.

**Relleno (§23) → corto:** con el fin de → para; debido a que → porque; en el momento actual
→ ahora; tiene la capacidad de → puede; a día de hoy → hoy.

## Específico del español (más allá de `humanizer`)

- **Cadenas de gerundios.** "permitiendo… logrando… brindando… garantizando" al final de
  frase suenan a IA. Parte en frases con verbo conjugado.
- **"no solo… sino también" / "ya sea… o".** Igual que §9: dilo directo.
- **Rangos falsos "desde… hasta".** Como §12 pero en español: enumera los temas.
- **Signos de apertura.** Toda interrogación/exclamación lleva `¿…?` `¡…!`. Un editor o una
  herramienta en inglés los borra: reponlos.
- **Tildes y ñ.** Nunca los sustituyas por ASCII (nao→não no; "ano"≠"año"). Revísalos al final.
- **Mayúsculas en títulos (§17).** El español no usa mayúscula inicial en cada palabra:
  "Estrategias de negociación", no "Estrategias De Negociación".

## Copy y marketing (SEONOVE)

`humanizer` §4 quita el lenguaje de venta. En copy publicitario eso se pasa: persuadir **es**
el trabajo del texto. Regla para este caso:

- **Conserva** la persuasión real: beneficio concreto, prueba, cifra, oferta, llamada a la
  acción clara.
- **Quita** la persuasión vacía de IA: superlativos sin dato (*impresionante*, *único*,
  *revolucionario*), promesas sin sujeto, entusiasmo genérico, cierres de aire optimista.
- Un claim de marketing necesita un hecho detrás. Si no lo tienes, pídelo; no te lo inventes
  (regla 2, sin excepciones para copy).

Si el texto es copy, dilo en el resumen: "modo copy — persuasión conservada, relleno quitado".

## Falsos positivos

Valen los mismos avisos que en `humanizer` § "Check for false positives". Además:
- Una tilde diacrítica correcta (*sí*, *tú*, *él*, *más*) no es un tell: consérvala.
- El *usted* no es tono IA: es registro. No lo quites.
- Un gerundio suelto y correcto no es un tell; el problema es la cadena de tres o más.

## Cómo devolver el resultado

Igual que `humanizer`:
- **Texto pegado (por defecto):** borrador, lista breve de tells que quedan, y versión final.
- **Modo archivo:** al dar una ruta, reescribe solo la prosa; deja código, YAML, datos y
  enlaces intactos; añade un resumen corto.
- **Modo integrado (PR, commit, doc):** devuelve solo el texto final.

## Proceso

1. Marca cada tell (estructural de `humanizer` + léxico español de arriba).
2. Escribe un borrador. Léelo en voz alta: ritmo, verbos simples (*es*/*tiene*), registro.
3. Pregúntate: ¿qué sigue sonando a IA? ¿añadí o quité algún dato, nombre, cifra o cita?
   Cualquier dato añadido o perdido es un error.
4. Escribe la versión final. Repón `¿` `¡`, tildes y ñ. Aplica la regla de rayas (§14).

## Catalán (futuro)

Cuando toque, se añade un `humanizer-ca` con la misma estructura: método de `humanizer` +
léxico de IA en catalán (p. ej. "cal destacar", "sens dubte", "hui en dia", "juga un paper
clau", "un seguit de"). No está hecho todavía.

## Fuente

Método y patrones estructurales: el skill `humanizer` (mismo repo / misma carpeta de
skills), basado en
[Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).
El léxico en español de este skill es propio, para los mismos tipos de patrón.
