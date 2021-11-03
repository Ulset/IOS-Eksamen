# IOS-Eksamen Sander Ulset

## Rammer
* Prosjektet med kildekode leveres pakket i en zipfil
* Xcode 12 (eller nyere) og Swift skal benyttes - Skriv i et dokument vedlagt i oppgaven
hvilken versjon av Xcode og Swift du bruker
* Visuelt design blir ikke vektlagt, så lenge applikasjonen oppfyller kravene i oppgaven
* God struktur og idiomatisk kode blir vektlagt
* Det forventes at du har lest, satt deg inn i, akseptert og følger reglene for intellektuell
redelighet
* Alt man lager av UI skal lages sånn at det tilpasser seg de ulike
iPhone-skjermstørrelsene
* Forutsetninger du gjør eller eventuelle kommentarer kan du skrive i en readme.md-fil
som legges ved. Skriv alle kilder og referanser i denne.
* Koden som leveres skal være kompilerbar og kunne kjøres i iPhone simulator med den
Xcode-versjonen oppgitt, uten endringer.
* Kilder og referanser skal oppgis tydelig

## Introduksjon
I dette oppgavesettet skal du lage en app som baserer seg på et API som serverer tilfeldig
genererte brukere: https://randomuser.me. Dokumentasjonen for API-et er å finne her:
https://randomuser.me/documentation. Utover det som står i oppgavetekstene forventes det
også at dere tar stilling til feilhåndtering. Dersom for eksempel et API-kall skulle feile bør det
vises en feilmelding til bruker. Skjermbilder i oppgavene er kun eksempler på data som skal
vises, ikke nødvendigvis veiledning for design. Seed som brukes er “ios”, bruk den som
standard hvis ikke annet er oppgitt. Om oppgaven ikke spesifiserer noe annet så velger dere
selv hvordan data skal presenteres.
OBS: Pass på at du leverer all kildekode i zip-filen, se gjennom denne en ekstra gang og
verifiser at alle filer som skal være med, er med før du leverer.

## Oppgaver
* __Oppgave 1__
  * Lag en app med en tab der du viser en liste med 100 brukere. Hvert liste-element skal
inneholde fornavn, etternavn, og profilbildet til brukeren
* __Oppgave 2__
  * Legg til funksjonalitet for at når en trykker på et listeelement, så tas man til en profilside for
brukeren. Denne siden skal minst inneholde følgende informasjon: Fornavn, etternavn, by,
email, fødselsdato, alder, og telefonnummer. Hvordan informasjonen vises/struktureres er opp til
deg.
* __Oppgave 3__
  1. Legg til en ny tab: Kart. I denne taben skal det være en side som viser et kart med de
samme 100 personene. Hver person markeres i kartet med deres profilbilde. Om en
trykker på et bilde skal profilsiden (fra oppgave 2) til den brukeren åpnes.
  2. Legg til en knapp på profilsiden som åpner kartet sentrert på den brukeren, ingen andre
brukere skal vises i kartet når du åpner det på denne måten.

* __Oppgave 4__
  1. Persister alle brukere slik at appen fungerer uten internett når den først har hentet data,
selv etter en omstart.
  2. Legg til en redigerknapp på profilsiden som lar en redigere følgende felter for bruker:
Fornavn, etternavn, by, epost, telefonnummer. Når en lagrer skal endringene persisteres
slik at de overskriver data fra API-et, mens felter som ikke har blitt endret fortsatt viser
API-data. Endringene skal fortsatt være synlige etter en omstart av app.
  3. Gjør det også mulig å redigere fødselsdato. Redigering av fødselsdato skal bruke native
datepicker. MERK: Hvis du redigerer fødselsdato må også alder-attributtet oppdateres.
TIPS: Rediger-siden kan fint vises som en egen skjerm som vises over profilsiden etter
man har trykket rediger.

* __Oppgave 5__
  1. Legg til en slett-knapp på profilsiden til hver bruker. Dersom en sletter en bruker skal den
ikke dukke opp igjen, selv om API-et leverer den.
  2. Legg til en ny tab: Innstillinger. I denne taben skal det være en side hvor det er mulig å
skrive inn en ny “seed” for brukerdataene. Dersom en endrer seed skal alle brukere i
databasen som ikke har blitt endret slettes. Deretter skal appen benytte den nye seeden
til å hente 100 nye brukere som skal vises i brukerlisten sammen med brukerne som
ikke ble slettet. En bruker regnes som endret hvis en har redigert en eller flere attributter
og lagret på brukeren. E.g. dersom en endrer etternavnet til en bruker, men ikke rører de
99 andre brukerene, skal 99 slettes og 1 beholdes. Etter at en da har hentet 100 nye
brukere vil det vises 101 brukere i brukerlisten. Pass på at seed også persisteres slik at
samme seed benyttes til fremtidige kall så lenge den ikke endres.

* __Oppgave 6__
  * Det er festlig med bursdag! Legg til funksjonalitet slik at om en åpner profilsiden til en bruker
som har bursdag den inneværende uken så:
    1. Skal det vises en 🎉-emoji i nedre høyre hjørne av profilbildet.
    2. Skal det regne 🍰,🎂 og🧁-emojis over skjermen så lenge en er inne på den profilsiden.
Disse skal altså animeres slik at de beveger seg fra toppen til bunnen av skjermen. Mot
slutten av skjermen så skal de gå fra 100% størrelse til 1%
    3. Du bør minst teste for to scenarioer; at bruker har bursdag denne uken og at de
ikke har det.
