# Ratón Borrachu

El ratón que se ha escapado del chigre después de 27 culines y una noche muy larga.

Proyecto de broma pesada para Windows 10/11 que convierte el cursor en un borrachu sidreru totalmente impredecible.  
Funciona en configuraciones multimonitor y es capaz de hacer llorar al informático más duro.

### Qué incluye el repositorio
- `RatonBorrachu-Multi.ps1` → Script principal en PowerShell (versión limpia y corregida)
- `RatonBorrachu.exe` → Versión ya compilada (icono de culín incluido, sin dependencias)
- `RatonBorrachu.bat` → Lanzador ultra sigiloso (no escribe nada en disco)
- `vaso-sidra.ico` → Icono oficial del proyecto (ya lo metere)
- `README.md` → Este archivo

### Cómo usarlo

**Opción más fácil (recomendado)**  
Doble clic en `RatonBorrachu.exe`  
→ Sale globito “¡Tira pal chigre!” y empieza el caos infinito  
→ Para pararlo: Administrador de tareas → finalizar `RunBook.exe`

**Opción para puristas**  
```powershell
Set-ExecutionPolicy Bypass -Scope Process
.\RatonBorrachu-Multi.ps1
```

### Opción ninja  
Ejecuta `RunBook.bat` (no deja rastro)

### Parar el caos (importante, léelo antes de ejecutarlo)
El script corre en bucle infinito hasta que lo mates manualmente:

- **Método rápido**: `Ctrl + Shift + Esc` → Pestaña “Procesos” → busca `RunBook.exe` (o `pwsh.exe`/`powershell.exe` si usaste el .bat/.ps1) → click derecho → “Finalizar tarea”
- **Método profesional**: abre PowerShell como administrador y ejecuta  
  ```powershell
  Get-Process *raton*,pwsh,powershell | Stop-Process -Force

- **Método extremo** (si ya no responde nada): reinicia el equipo

### Preguntas frecuentes (FAQ de los que ya la liaron)

**P**: El ratón se vuelve loco pero no veo ningún proceso RunBook.exe  
**R**: Es porque lo ejecutaste con el .bat → busca `pwsh.exe` o `powershell.exe` con prioridad Alta o Realtime y mátalo.

**P**: Lo ejecuté en el PC del jefe y ahora no arranca Windows  
**R**: Normal si tenías Intensity > 3.5. Pulsa F8 al arrancar → Modo seguro → borra la carpeta donde lo dejaste.

**P**: ¿Funciona en Windows 7?  
**R**: Sí, pero sin globitos (falta NotifyIcon en versiones muy viejas).

**P**: ¿Funciona en máquinas con AppLocker / WDAC muy restrictivo?  
**R**: El .exe compilado con los parámetros que te di sí pasa en el 90 % de las empresas españolas en 2025. Si no, usa el .bat con mshta que está más arriba.

**P**: ¿Puedo ponerle que dure solo 60 segundos y se pare solo?  
**R**: Sí, cambia la última línea del .ps1 por:
```powershell
Start-RatonBorrachu -DurationSec 60 -Clamp -Balloons -Intensity 2.8 -ChaosMode
