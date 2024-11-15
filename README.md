# starthier
Met deze repo installeer je in 1x WordPress, WordPress plugins, TeamPortal repository en TC-app repository plus alle dependencies en MySQL table migrations om alle SKC applicaties samen te laten werken. 

Een werkende Docker installatie op je systeem is een requirement.

# Mac / Linux
Run ./start.sh in de Docker map. 

# Windows
Run start.bat in de Docker map. 

### Nog to-do Docker: 
- Kijk hoe de productie Pods (Commissies, Fotopagina's, Teams, User) zijn ingericht. Bouw de pods na in je lokale Wordpress (**Je kan ook de alle pods importeren via een JSON string**). Belangrijkste pods zijn Teams en User, zonder deze twee werkt Team-Portal niet. 
- Activeer de Pods Roles and Capabilities Tool, ga hiervoor naar Pods Admin > Components (Onderdelen) 
- Schakel alle rechten in voor de Administrator rol, ga hiervoor naar Pods Admin > Roles & Capabilities
- De Commissies, Fotopagina's en Teams zijn nu zichtbaar links in je menu sidebar
