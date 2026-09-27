# Rabbit Simulator — primera versión del mapa

Este proyecto contiene un generador de mapa para Roblox Studio. Crea una isla pastel con un jardín circular central, un árbol fantástico, cuatro spawns y cuatro pasillos.

## Cómo instalarlo

1. Abre Roblox Studio y crea o abre tu experiencia.
2. En **Explorer**, abre `ServerScriptService`.
3. Crea un objeto **Script**.
4. Copia el contenido de `src/ServerScriptService/BuildRabbitMap.server.lua` dentro del Script.
5. Pulsa **Play** o **Run**.

El script reconstruye únicamente la carpeta `Workspace.RabbitWorld`, por lo que puedes ejecutarlo varias veces durante el diseño sin duplicar el mapa.

## Diseño incluido

- Iluminación pastel con atmósfera, bloom suave y cielo visible.
- Isla grande de césped y jardín circular elevado.
- Árbol central de más de 50 studs, con raíces enterradas, detalles de corteza, hojas rojas y violetas, frutos luminosos y letrero.
- Cuatro `SpawnLocation` transparentes alrededor del árbol.
- Cuatro escaleras alineadas con cuatro pasillos de 100 studs de largo y 15 studs de ancho.
- Bordes luminosos, faroles y árboles decorativos para que el mapa sea fácil de leer y atractivo en capturas.

## Próximos pasos recomendados

La estructura deja espacio para añadir después las zonas de zanahorias al final de cada pasillo. Conviene añadir primero un sistema de recolección y `leaderstats` de semillas, y después tiendas de mejoras, mascotas, skins y renacimientos.

> Nota: un skybox artístico personalizado necesita seis imágenes subidas a Roblox. Por ahora el script usa iluminación y atmósfera pastel para que el mapa se vea bien incluso sin assets externos; el skybox se puede reemplazar más adelante sin cambiar el resto del mapa.
