# starthier
Deze repo bevat alle instructies om je lokale DEV in te richten. 

## Webserver software
Om te kunnen devven moet je altijd een webserver hebben, anders kun je niks runnen. Docker mag ook als je dat leuk vindt. 
- Kies [Laragon](https://laragon.org/index.html) op Windows
- Kies [XAMPP](https://sourceforge.net/projects/xampp/files/XAMPP%20Mac%20OS%20X/) op Mac

## WordPress 
WordPress is de basis waar alle andere applicaties op aansluiten, dus dit moet dus altijd eerst geïnstalleerd zijn. 

### Installatie: 

- Download WordPress (https://nl.wordpress.org/download/)
- Extract WordPress en plaats de inhoud in de root van je webserver bijv. C:\xampp\htdocs of C:\laragon\www
- Voor je begint met installeren, maak een nieuwe database in PHPMyAdmin (localhost/phpmyadmin)
- Installeer WordPress, ga in je browser naar http://localhost en loop de stappen door
- Geef je site een leuke titel en username, bijvoorbeeld 'skc_dev' en 'admin' 

### Essentiële plugins:
Deze plugins zijn nodig om Teams, Commissies en Fotopagina's werkend te krijgen. Ook zijn ze nodig om de juiste rollen toe te voegen binnen de site. 
- In je lokale development WordPress, installeer en activeer de volgende plugin: 
	- Pods - Aangepaste Content Typen en Velden
- Ga naar de productie WordPress versie > Pods Admin > Import/Export Packages
- Exporteer de instellingen van alle Pods, bewaar deze instellingen
- Importeer de instellingen in Pods in je lokale development WordPress
- Activeer de Pods Roles and Capabilities Tool, ga hiervoor naar Pods Admin > Components (Onderdelen) 
- Schakel alle rechten in voor de Administrator rol, ga hiervoor naar Pods Admin > Roles & Capabilities
- De Commissies, Fotopagina's en Teams zijn nu zichtbaar links in je menu sidebar

### Data toevoegen: 
- Creëer de roles Barcie, Bestuur, CommissieCo, ScheidsCo, TC en Teamcoordinator, zodat de lokale TC-app en Team-Portal kunnen werken. Dit kan bij Pods Admin > Roles & Capabilities.
	- De rol Barcie is nodig om de barleden te laten verschijnen in TeamPortal
	- Teamcoordinator is nodig om de teamtaken en barleden te plannen
	- TC is nodig om in de TC-app in te kunnen loggen	
	- Bestuur is op productie om bestuur de site te laten editen
	- CommissieCo en ScheidsCo zijn waarschijnlijk oud en obsolete 
- Creëer wat dummy teams en commissies en voeg hier gebruikers aan toe

Gefeliciteerd, WordPress is klaar en geïnstalleerd! Je kunt nu de andere applicaties aansluiten. 

## Team-Portal
Zie de [Team-Portal](https://github.com/skcvolleybal/team-portal/) repository voor install instructies

## TC-App
Zie de [TC-app](https://github.com/skcvolleybal/tc-app/) repository voor install instructies
