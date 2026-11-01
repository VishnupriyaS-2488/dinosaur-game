@echo off
rem ---------------------------------------------------------------
rem  compile.bat - builds Dino Runner into build\DinoRunner.exe
rem  Run it from the project folder (double-click, or type compile.bat)
rem ---------------------------------------------------------------
setlocal
cd /d "%~dp0"

rem Where Raylib lives. Change this line if you unzipped it somewhere else,
rem or set a RAYLIB_DIR environment variable (see README.md).
if "%RAYLIB_DIR%"=="" set "RAYLIB_DIR=C:\raylib"

where gcc >nul 2>nul
if errorlevel 1 goto nogcc
if not exist "%RAYLIB_DIR%\include\raylib.h" goto noraylib
if not exist "%RAYLIB_DIR%\lib\libraylib.a" goto noraylib
if not exist build mkdir build

echo Compiling Dino Runner...
gcc src\main.c -o build\DinoRunner.exe -std=gnu11 -O2 -Wall -Wextra -I"%RAYLIB_DIR%\include" -L"%RAYLIB_DIR%\lib" -lraylib -lopengl32 -lgdi32 -lwinmm -static -mwindows
if errorlevel 1 goto failed

echo.
echo SUCCESS: build\DinoRunner.exe was created.
echo Start it with run.bat
goto end

:nogcc
echo ERROR: gcc was not found. Install MinGW-w64 and add its "bin" folder to PATH. See README.md.
goto end

:noraylib
echo ERROR: Raylib was not found in "%RAYLIB_DIR%".
echo Expected: %RAYLIB_DIR%\include\raylib.h and %RAYLIB_DIR%\lib\libraylib.a
echo Fix the RAYLIB_DIR line in compile.bat, or see README.md.
goto end

:failed
echo.
echo COMPILATION FAILED. Read the messages above.

:end
pause
