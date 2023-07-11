# Peak Finder- Digitales Gipfelbuch
### Semesterprojekt Victor Blaga & Fabian Rafreider (The real Fabi) IOT2  SS-2023 

### ESP Code:
https://github.com/fabian1606/Peak-finder-esp32-code 

### Projektbeschreibung:

Peakfinder ist eine app die es usern ermöglicht auf digitale gipfelbücher zuzugreifen und eigene einträge hinzuzufügen.
dafür hat jeder gipfel ein modul mit einem esp als kern, dieser hostet eine webseite die den gipfelbucheintrag zulässt und usern eine Nachweiß Plattform zu bieten um ihren gipfelstieg in der app als erfolg hinzuzufügen.

Ebenfalls sammelt der esp währenddessen durchschnitts daten der anwesenheit von umliegendengeräten, was zur nachvollziehung der beliebtheit des gipfels folgt.

Diese werte und die Erfolge der usern können diese in der flutter app nachsehen.



### Api Aufbau:

  #### User Service 


     -> login
        -> request: Post: {"email":"example@mail.de","password":"123456789"}
        -> response: 200 ->"neuer account wird in datenbank angelegt"

     -> register
        -> request: Post: {"email":"example@mail.de","password":"123456789"}
        -> response: 200 ->"account und password werden im backend verglichen"

     -> registeerMail
        -> request: Post: {"email":"example@mail.de"}
        -> response: 200 -> "email wird an user gesendet, ist für user gedacht welche auf dem berg einen eintrag machen und später benachrichtigt werden sollen, damit sie sich anschliessend einen account machen können und die app runterladen können"



  #### Data Service

     -> addData
        -> request: Post: {"msgs":[{"msg":"Hallo","email":"Beispiel@email.de},{"msg":"Hallo","email":"Beispiel@email.de"}],"avgVisitors":[{"timestamp":"230707,"value":"25"},{"timestamp":"230708","value":"25"}],"id":"001"}
             -> value: "average visitors" - timestamp "format JJJJMMTTHH, dadurch ist das jüngste datum automatisch die größte zahl" - id: "eine Zahl die auf den namen dess berges zurückführbar ist"
        -> response: 200 -> "speichert die daten in die datenbank"

     -> getPeakData
        -> request: Get: {"peakId":"001","email":"beispiel@email.de","password":"123456"}
        -> response: -> {"name": peak[0].name,"id": peak[0].peakId,"avgVisitors": peak[0].averageVisitors}
        {"peak": {"name": "Zugspitze","id": "001","avgVisitors": "value"}, "msgs": "[{"msg":"hallo"},{}"msg":"hallo"},...]"}
     
     -> getPeakName
        -> request: Get: {"peakId":"001","newPeakName":"Mount Bacon"} - New Peakname funktioniert nur falls es noch kein mountain mit dieser id in der datenbank existiert, der wert newPeakName ist eigentlich nur zu testzwecken entstanden.
        -> response: {"peakName":"Zugspitze"} or "new peakListItem created"
    
     -> getUserData
        -> request: Get {"email":"beispiel@email.de","password":"123456789"}
        -> response: {"email":"beispiel@email.de","[{"peakId":"001","peakName":"Zugspitze","msg":"Hallo Welt"},{}"peakId":"002","peakName":"Mount Bacon","msg":"Hallo Welt"},...]"}
    
     -> addSingleMessage
        -> request: Post: {"email":"beispiel@email.de","password":"123456","msg":"Hallo Welt","id":"peakId"}
        -> response: 200 -> message saved
    
     -> getAllPeaks
        -> request: get
        -> response: ["{"peakName":"Zugspitze","peakId":"001"},{"peakName":"Zugspitze","peakId":"001"},..."]
        (the responses onnly count if input correct)

### Installation
#### node:
- jeweils in userService, dataService und web_register npm i ausgeführt werden
- Eine vernünftige .env angelegt werden, siehe .env.example -> userService sollte port 3003 und dataService port 3004 haben
     -> zu den nötigen werten der .env gehören einlog daten zu einer mongodb datenbank, sowie zu einem email provider service
#### Flutter: 
- Flutter muss installiert werden https://docs.flutter.dev/ 
- Developer Modus auf dem Handy (Android) anschalten
- flutter: ```flutter pub get``` ausführen
- ```flutter run``` ausführen um die app auf dem Gerät zu installieren
#### ESP-32
- Platform IO extension für VS-code installieren
- Projekt öffnen 
- Code flashen
### Setup
- Power button des ESPs im 1s Abstand 2 mal  drücken dadurch wird der config- Modus aktiviert. Und Name und Berg ID können eingegeben werden.
### Technologien
- BLE: Wir verwenden BLE um daten vom es zum ESP auf das Handy zu übertragen -> BLE benötigt keine Kopplung -> Prozess läuft im Hintergrund ab ohne User interaktionen
- Captive portal: Wir verwenden captive portals um den User nachdem er sich mit dem ESP Wlan verbunden hat direkt auf die Website weiterzuleiten
- Node Mailer: Wir verschicken automaisch mails um dem User die registrierung zu erleichtern
- Wifi Sniffer: Wir verwenden eine funktion der esp-wifi library von espIDF die es uns ermöglicht die Anzahl der Nutzer auf dem Gipfel zu tracken.
### Unsere Daten:
Die Daten ergeben sich aus den Geräten, die sich auf dem Gipfel versuchen mit dem Wlan des ESP-32 zu verbinden bzw daten über das Netzwerk wie Netzwerkname vom esp anfragen.

Diese Daten werden dann sobald sich ein Handy mit der App auf dem Gipfel befindet per ble an dieses übertragen. Das Handy schickt diese per http Request an den Server, welcher sie in einer Mongo-db Datenbank speichert.

Die Flutter app fragt die anzahl der Menschen die den Gipfel erreicht haben auch aus dem Backend per HTTP- Request an und zeigt sie in einem Graph an. 

#### Entity Relationship Model

![entityrelationship.png](entityrelationship.png)

### Sachen erledigt

#### Must Have (bestehens-relevant)

- [x] Sensormodul, das Daten erhebt und in ein System einspeist:
- [x] Backend mit eigener dokumentierter API für HTTP-Requests
- [x] Anzeige der gespeicherten Sensorwerte
- [x] Nutzung von .env oder Ähnlichem, um Credentials auf github zu verbergen.
- [x] Ausformuliertes Datenmodell inkl. Entity-Relationship-Model
- [x] github Monorepo
- [x] .gitignore, in der node_modules enthalten ist. Hochgeladener node_modules-Ordner = Schelle.
- [x] Projekt-Doku als README.md
- [x] Screencast (in Google Drive, nicht im Repo!)

#### Should Have (~ relevant für die Note vor dem Komma)

- [x] UX-getriebenes Konzept
- [x] Frontend für User
- [x] User-Authentifizierung (Register / Login)
- [x] Anzeige / Visualisierung der Sensorwerte
- [x] Interessantere, komplexere Datenabfragen und -darstellungen
- [x] Skalierbarkeit des Systems (mehr User / mehr Sensoren / etc.)
- [x] Microservices-Infrastruktur (User Service, Data Service, etc.)


#### Could Have (~ relevant für die Note nach dem Komma)

- [x] Gestaltetes Frontend / ggf. mit Framework (next.js / vue / …)
- [x] Prototyping: Cases für Komponenten usw., 3d-gedruckt oder Lasercuts
- [ ] Aufwändige Datenvisualisierungen über Graphen hinaus
- [x] Zuordnung neue Sensormodule zu User (Pairing-Prozess), zumindest als Überlegung
- [ ] Zuordnung der User zu ihren Sensormodulen, damit sie nur ihre eigenen bzw. berechtigten Sensoren sehen
- [ ] User-Authentifizierung über distinguierte Libraries / Frameworks (z. B. Passport, JSON Web Tokens)
- [ ] Session-Timeouts
- [x] Sensor- / ESP-Informationen im Frontend bearbeiten
- [x] Sensor objektorientiert programmiert
- [ ] Deep Sleep-Implementierung
- [ ] Onboarding: Logon speichern / Cookie setzen / localStorage / Wizard statistische / prognostische Auswertung der Daten (AI?)
- [ ] User-Authentifizierung über externen Dienst (z. B. Google)
- [ ] Alerts / Alarme Konfigurieren einzelner Sensormodule (z. B. Intervalle ändern)
- [ ] OpenAPI / Swagger.io / [apicur.io](http://apicur.io) nutzen
- [ ] Benutzerrollen (nur ansehen, editieren, etc.)
- [x] Überlegungen zur Energieversorgung (Laufzeit, Energiespeicher, Lademöglichkeit, etc.)
- [ ] Lauffähige Docker-Container / shell + batch für alle Images + Container

#### We Haves:
- [x] Registration Mails
- [x] Webserver auf dem ESP mit Frontend
- [x] API auf dem ESP
- [x] EEprom Verwendung auf dem ESP
- [x] Custom Partition Table (Neue Speicherzuordnung wegen zu wenig speiherplatz)
- [x] Captive portal zum weiterleiten der User
- [x] Reset Button doppelclick
- [x] Backend in ordnern sortiert und typisiert