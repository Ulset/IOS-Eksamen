### Eksamen Sander Ulset
### Grade: `A`

## Setup
* Xcode versjon: `13.1 (13A1030d)`
* IOS target: `IOS 14.7`
* Simulator: `IOS 15`

## Dependencies
* https://github.com/hackiftekhar/IQKeyboardManager
  * For at keyboardet ikke skal gå over input feltene

## Ting jeg syntes ble bra
* Jeg liker egentlig veldig godt måten jeg håndterte oppdateringer av data (Array av closures)
* Appen tilpasser seg forskjellige mobilstørrelser
* Hvis man er i navigation tab `Personer` og har gått inn på en spesifikk person, hvis denne personen slettes via `Instillinger` vil den automatisk gå tilbake til forrige view i navigation stacken. Hvis personen fortsatt finnes (eller er gjort endringer på via å trykke på dem i `Kart` og så `Rediger`) vil dette være oppdatert.
* Alle bilder caches etter behov, og lagres via URL oppgitt når den ble hentet. Siden APIet vi brukte har bare et X antall bilder den gir tilbake, vil den etterhvert aldri trenge å laste ned bilder igjen.
   * Det skal nevnes at bildene blir __ikke__ cachet når man henter personene fra APIet, bare når den skal vises.
   * Hvis cache-miss og ingen internett, vil et standard bilde gis tilbake.
* Når man trykker seg inn på en person vil bildet være av bedre kvalitet.
* ALLE stedene hvor man ser data er synkronisert med hverandre. Dette betyr at uansett hvor du sletter noen fra eller gjør endringer vil dette persistere gjennom hele appen.
* `Vis på kart` knappen vil bare vise en person, og det er ikke mulig å bla rundt.
* Knappene på `Instillinger` har utvidede funskjoner for lettere debugging
   * `Slett alt` har mulighet for å slette alt eller bare de som er uendret.
   * `Heny nye` har mulighet for å hente bare folk som ikke har vært slettet før, eller alle uavhengig om de er slettet før.
   * `Reset 'slettet' liste` vil fjenre 'tidligere slettet' markering for alle. 
* Når man bytter seed vil de personene som blir fjernet __ikke__ markeres som slettet, dette vil kun skje når brukeren aktivt trykker på slett.
