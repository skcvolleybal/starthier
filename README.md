# starthier
Met deze repo installeer je in 1x WordPress, WordPress plugins, TeamPortal repository en TC-app repository plus alle dependencies en MySQL table migrations om alle SKC applicaties samen te laten werken. 


# Installatie
Een werkende Docker instance (https://www.docker.com/) op je systeem is een requirement.

* Mac: Run ```sh start.sh``` in de Docker map. 
* Linux: Run ```sh start.sh``` in de Docker map. 
* Windows: Run ```start.bat``` in de Docker map, waarschijnlijk via PowerShell

# Development
Na install vind je de services op de volgende urls:
- WordPress: http://localhost:8080 
- Team-Portal frontend: http://localhost:4200
- Team-Portal backend: http://localhost/team-portal/api/groepen
- TC-app frontend: http://localhost/tc-app
- TC-app backend: http://localhost/tc-app/php/interface.php

De files voor WordPress, Team-Portal en TC-app worden als bind mount beschikbaar gemaakt op je lokale machine. Alles wordt gemount naar bijvoorbeeld ./docker/tc-app. Lees de docker-compose.yml om meer te weten. 