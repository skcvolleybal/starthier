# starthier
Met deze repo installeer je in 1x WordPress, WordPress plugins, TeamPortal repository en TC-app repository plus alle dependencies en MySQL table migrations om alle SKC applicaties samen te laten werken. 

Een werkende Docker installatie op je systeem is een requirement.

## Mac / Linux
Run ./start.sh in de Docker map. 

## Windows
Run start.bat in de Docker map. 

# Gebruik na opstart
* WordPress, Team-Portal, TC-app en MySQL draaien als Docker containers en worden exposed via localhost:[poortnummer]. Voor het externe poortnummer van elke service, run ```docker ps```. 
* De files voor WordPress, Team-Portal en TC-app worden als bind mount beschikbaar gemaakt op je lokale machine. Alles wordt gemount naar bijvoorbeeld ./docker/tc-app.
* Lees de docker-compose.yml om meer te weten. 

### Nog to-do Docker: 
- Kijk hoe de productie Pods (Commissies, Fotopagina's, Teams, User) zijn ingericht. Bouw de pods na in je lokale Wordpress (**Je kan ook de alle pods importeren via een JSON string**). Belangrijkste pods zijn Teams en User, zonder deze twee werkt Team-Portal niet. 
- Activeer de Pods Roles and Capabilities Tool, ga hiervoor naar Pods Admin > Components (Onderdelen) 
- Schakel alle rechten in voor de Administrator rol, ga hiervoor naar Pods Admin > Roles & Capabilities
- De Commissies, Fotopagina's en Teams zijn nu zichtbaar links in je menu sidebar
