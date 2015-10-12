# isaac10UI Demo-Integration
(English version below)
## Setup
### Einführung
Dieses Projekt zeigt eine beispielhafte Integration der Funktionen der API von isaac10 in einer Ruby-On-Rails-Applikation wie sie in der [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs) aufgeführt sind.
Folgende Funktionen werden behandelt:

- Anzeigen der Registrierseite mit isaac10-UI
- Registrieren & Anlegen von Kunden für den isaac10-Demo-Händler auf der Staging-Umgebung und in dieser Applikation selbst
- Anzeigen & Ändern von Accountinformationen von registrierten Kunden mit isaac10-UI
- Anzeige von Buchungen und Buchungsverwaltung mit isaac10-UI
- Anzeige von Rechnungen und Rechnungsdownload mit isaac10-UI
- Anzeigen von Produkten mittels `getProducts()`

Gleichzeitig ist dieses Projekt auch Teil einer Continuous-Integration-Umgebung, eine laufende Instanz dieser Applikation befindet sich unter [FIXME: Heroku](http://foo.bar) und wird für automatisierte Tests verwendet.
### Grundlegende Anforderungen an die Integration
Wie in der [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs) beschrieben werden die benötigten JavaScript-Bibliotheken einfach über `<script>`-Tags in eine HTML-Seite eingebunden. In dieser Applikation geschieht dies mit den Dateien `isaac10_api.js` und `isaac10_ui.js` in `app/views/layouts/application.html.erb`, die eigentliche Verwendung der isaac10-API und isaac10-UI geschieht innerhalb von `<script>`-Tags in den jeweiligen `index.html.erb`-Dateien im jeweiligen Bereich der Applikation (siehe unten).
Weiterhin wird für die Datenhaltung der erzeugten Datensätze ein Model mit Feldern für eine Kundennummer und das API-Token für die weitere Authentifizierung des Kunden benötigt. Beim erfolgreichen Abschluß einer Buchung und Registrierung werden die Datensätze `customer_number` und `customer_api_token` mittels eines Webhooks von isaac10 zurückgegeben. Innerhalb dieser Beispielapplikation werden sie als Felder `customer_number` und `customer_api_token` in einem `Customer`-Model abgespeichert. Stellen Sie in ihrer Applikation sicher dass Sie diese Daten ähnlich abspeichern können.   
Weitere spezielle Anforderungen gibt es nicht.
#### Diese Applikation lokal starten
Um diese Applikation lokal auszuführen werden die üblichen Schritte ausgeführt:
  - `git clone FIXME: github-url` 
  - `bin/rake db:create:all`
  - `bin/rake db:migrate`

Diese Schritte erzeugen lediglich eine "customers"-Tabelle mit den oben beschriebenen Feldern.  
Beim lokalen Betrieb ist darauf zu achten dass diese Applikation dazu erstellt wurde um entweder mit einer ebenfalls lokalen Instanz von isaac10 zu interagieren oder im Production-Modus mit der Staging-Umgebung von isaac10. Da diese Applikation auch als Teil einer CI-Umgebung dient werden die enthaltenen Feature-Tests (mit Selenium/Capybara) entweder gegen eine laufende lokale Instanz dieser Applikation oder die deployte Version auf Heroku ausgeführt. Die Einstellungen hierfür (`Capybara.app_host` etc.) sind selbsterklärend.
#### Umgebungsvariablen
Neben den üblichen Umgebungsvariablen (`RAILS_ENV` etc.) werden noch weitere für die Steuerung der Tests benutzt:
- `TEST_AGAINST_HEROKU` wird gesetzt wenn die Applikation deployt wurde und die enthaltenen Selenium-Tests gegen die deployte Applikation ausgeführt werden sollen um mit der Staging-Umgebung zu interagieren.
- `SELENIUM_BROWSER` kann auf `chrome` gesetzt werden um die Selenium-Tests mit dem chromedriver auszuführen. Wird nichts oder etwas anderes angegeben wird Firefox benutzt.

## isaac10-Funktionen
### Anzeigen von Produkten
Für das Anzeigen von Produkten von einer Subdomain ist keine Authentifizierung o.Ä. nötig. Die nötigen API-Calls werden alle in `app/views/products/index.html.erb` gemacht und die restliche Seite wird mit den Daten aus der JSON-Antwort zusammengebaut.
### isaac10-UI
Wie in der [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs) beschrieben wird die UI mit einem isaac10-Objekt initalisiert. Sämtliche Views in dieser Applikation bekommen die Informationen über die verwendete Subdomain über Gon, die Initialisierung und Verwendung des isaac10-Objekts geschieht innerhalb von `$(document).ready()`:
```javascript
$(document).ready(function() {
    var RAILS_ENV = gon.rails_env;
    var SUBDOMAIN = gon.subdomain;
    var isaac10   = new Isaac10(SUBDOMAIN, RAILS_ENV);
    [...]
});
```
#### Registrierung & Anlegen von Kunden/Buchungen
Die Registrierseite besteht aus einer `index`-Action/View und einer `create`-Action. In der Index-View wird wie in der  [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs) beschrieben das isaac10-UI-Objekt initialisiert und eingebunden:
```javascript
    Isaac10UI.setup({
      "isaac10Instance": isaac10,
      "fetchTemplate"  : "bootstrap3",
      "locale"         : "de"
    }).render("#isaac10-ui");
  });
```
Um die Formulare darzustellen ist folgender HTML-Code nötig:
```HTML
<div id="isaac10-ui"></div>
```
Die Daten eines neuen Kunden werden wie oben und in der API-Dokumentation beschrieben via Webhook an die `RegisterController#create`-Action übermittelt und werden dort persistiert.
#### Kundenfunktionen
Für sämtliche Kundenfunktionen ist nur eine einzige `index`-Action/View nötig. Wie oben werden die benötigten Variablen mit Gon übertragen und der Kunde mit den Daten über die API authentifiziert:
```javascript
var RAILS_ENV      = gon.rails_env;
var SUBDOMAIN      = gon.subdomain;
var isaac10        = new Isaac10(SUBDOMAIN, RAILS_ENV);
var customerNumber = gon.customer_number;
var customerToken  = gon.customer_token;
isaac10.authenticateCustomer(customerNumber, customerToken);
    
Isaac10UI.setup({
  "isaac10Instance": isaac10,
  "fetchTemplate"  : "bootstrap3",
  "locale"         : "de"
}).render("#isaac10-ui");
```
Wie oben werden die Formulare in ein `<div>`-Tag gerendert. Die weitere Navigation ist über Anchor-Elemente in den URLs realisiert: Um eine URL in der Form `customer#/bills` zu erhalten müssen folgende `link_to`-Helper verwendet werden:
```
<%= link_to t(".bills_link"), customer_path(anchor: "/bills") %>
```

___
## Setup
### Introduction
This project showcases a sample integration of functionality provided by isaac10's API inside a Ruby-On-Rails application like stated on [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs). The following functionalities are addressed:
- Display of the registration page via isaac10-UI
- Registration and creation of customer records for the isaac10-demo-merchant on the staging environment and this application
- Display and edit of account data of registered customers via isaac10-UI
- Display and edit of subscriptions via isaac10-UI
- Display and edit of bills and bill download via isaac10-UI
- Display of products via `getProducts()`

At the same time, this project is part of a continuous-integration-setup, a running instance is found on [FIXME: Heroku](http://foo.bar) and is used for automated testing.
### Basic requirements for integrating
Like stated in the docs ([isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs)), all needed JavaScripts are loaded inside `<script>`-tags within an HTML-document. In this application, the files `isaac10_api.js` and `isaac10_ui.js` are loaded in `app/views/layouts/application.html.erb`. The actual usage of the libraries happens inside `<script>`-tags in the corresponding `index.html.erb`-files for each single functionality (see below).

For storing the submitted records, you need at least a model which can store values for a customer number and an API-token. This data is needed for further authentication of the customer. Upon successful creation of a subscription and registration, these two values are sent as `customer_number` and `customer_api_token` via a webhook from isaac10. In this sample application they are stored as `customer_number` and `customer_api_token` as fields of the `Customer`-model. You have to make sure that your own application can handle this in a similar fashion.   
There are no further special requirements.
#### Start this app locally
Starting this application locally is straightforward:
  - `git clone FIXME: github-url` 
  - `bin/rake db:create:all`
  - `bin/rake db:migrate`

These steps merely create one table named "customers" with the fields stated above.  
Notice that this application was made to be used to test against a local running instance of isaac10 or to be deployed and be used to test against the staging-environment of isaac10. Because this application is part of a continuous-integration-setup its containing tests (with Selenium/Capybara) are either using a running local instance or a deployed version of this app. All settings regarding this (`Capybaara.app_host` etc.) should be self-explanatory.
#### Environment variables
Besides standard variables like `RAILS_ENV` there are a few more for controlling the tests:
- `TEST_AGAINST_HEROKU` is set when the app is deployed and the contained selenium-tests should use the deployed instance to test against the staging environment
- `SELENIUM_BROWSER` can be set to `chrome` for running the tests using the chromedriver. If set to anything else or nothing Firefox will be used.
## isaac10 functionality
### Display of products
To display products there are no special settings like authentication needed. All needed API-calls take place in `app/views/products/index.html.erb`, the page istself is filled with data coming from the JSON-response.
### isaac10-UI
Like stated on [isaac10-API-Dokumentation](https://isaac10-api-dokumentation.readme.io/v1.0/docs) the UI is initialized with an isaac10-object. All views in this demo application get the needed data via the Gon gem, initialization and usage is done within `$(document).ready()`:
```javascript
$(document).ready(function() {
    var RAILS_ENV = gon.rails_env;
    var SUBDOMAIN = gon.subdomain;
    var isaac10   = new Isaac10(SUBDOMAIN, RAILS_ENV);
    [...]
});
```
#### Registration and creation of customers/subscriptions
The 'register'-page is made of an `index`-action/view and a `create`-action. Inside the index-view the isaac10-UI-object is initialized and used like stated in the docs:
```javascript
    Isaac10UI.setup({
      "isaac10Instance": isaac10,
      "fetchTemplate"  : "bootstrap3",
      "locale"         : "de"
    }).render("#isaac10-ui");
  });
```
To render the forms the following has to appear on the same page:
```HTML
<div id="isaac10-ui"></div>
```
Like stated above and in the docs the customer data is submitted to the `RegisterController#create`-action via webhook and is persisted there.
#### Customer functionality
For all customer functionality only one `index`-action/view is needed. Like above, the needed variables are submitted by Gon and the customer is authenticated via the isaac10-API-object:
```javascript
var RAILS_ENV      = gon.rails_env;
var SUBDOMAIN      = gon.subdomain;
var isaac10        = new Isaac10(SUBDOMAIN, RAILS_ENV);
var customerNumber = gon.customer_number;
var customerToken  = gon.customer_token;
isaac10.authenticateCustomer(customerNumber, customerToken);
    
Isaac10UI.setup({
  "isaac10Instance": isaac10,
  "fetchTemplate"  : "bootstrap3",
  "locale"         : "de"
}).render("#isaac10-ui");
```
Like above the forms are rendered into a `<div>`-Tag. All further navigation is made using anchor-elements of URLs. To be able to include an URL of the form `customer#/bills` you have to use the `link_to`-helper like so:
```
<%= link_to t(".bills_link"), customer_path(anchor: "/bills") %>
```
