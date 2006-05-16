@echo off
@setlocal

for /f "usebackq" %%I in (`c:\Progra~1\Python24\python.exe -c "from files import appversion; print '%%03.0f'%%(float(appversion)*100)"`) do set VER=%%I

@if exist OverlayEditor_%VER%_src.zip del OverlayEditor_%VER%_src.zip
@if exist OverlayEditor_%VER%_linux.tar.gz del OverlayEditor_%VER%_linux.tar.gz
@if exist OverlayEditor_%VER%_mac.zip del OverlayEditor_%VER%_mac.zip
@if exist OverlayEditor_%VER%_win32.zip del OverlayEditor_%VER%_win32.zip

rd  /s /q OverlayEditor.app >nul: 2>&1
del /s /q dist  >nul: 2>&1
del /s /q *.bak >nul: 2>&1
del /s /q *.pyc >nul: 2>&1

@set PY=OverlayEditor.py draw.py files.py
@set DATA=OverlayEditor.html
@set RSRC=Resources/add.png Resources/delete.png Resources/goto.png Resources/import.png Resources/new.png Resources/open.png Resources/OverlayEditor.png Resources/prefs.png Resources/reload.png Resources/save.png Resources/screenshot.png

@REM source
zip -r OverlayEditor_%VER%_src.zip dist.cmd %PY% setup.py %DATA% %RSRC% linux MacOS win32/*.exe win32/*.ico |findstr -vc:"adding:"

@REM linux
REM tar -zcf OverlayEditor_%VER%_linux.tar.gz %PY% %DATA% %RSRC% linux win32/bglunzip.exe win32/DSFTool.exe

@REM mac
mkdir OverlayEditor.app\Contents
for %%I in (%DATA%) do (copy %%I OverlayEditor.app\Contents\ |findstr -v "file(s) copied")
mkdir OverlayEditor.app\Contents\MacOS
xcopy /q MacOS\* OverlayEditor.app\Contents\MacOS\ |findstr -v "file(s) copied"
for %%I in (%PY%) do (copy %%I OverlayEditor.app\Contents\MacOS\ |findstr -v "file(s) copied")
mkdir OverlayEditor.app\Contents\Resources
for %%I in (%RSRC%) do (copy Resources\%%~nxI OverlayEditor.app\Contents\Resources\ |findstr -v "file(s) copied")
del  OverlayEditor.app\Contents\MacOS\OverlayEditor.html
move OverlayEditor.app\Contents\MacOS\Info.plist OverlayEditor.app\Contents\
move OverlayEditor.app\Contents\MacOS\OverlayEditor.icns OverlayEditor.app\Contents\Resources\
zip -j OverlayEditor_%VER%_mac.zip MacOS/OverlayEditor.html |findstr -vc:"adding:"
zip -r OverlayEditor_%VER%_mac.zip OverlayEditor.app |findstr -vc:"adding:"

@REM win32
setup.py -q py2exe
@set cwd="%CD%"
cd dist
zip -r ..\OverlayEditor_%VER%_win32.zip * |findstr -vc:"adding:"
@cd %cwd%
rd  /s /q build

:end
