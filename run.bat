@echo off
rem run.bat - starts the game (compiles it first if needed)
cd /d "%~dp0"
if not exist build\DinoRunner.exe call compile.bat
if exist build\DinoRunner.exe start "" "build\DinoRunner.exe"
