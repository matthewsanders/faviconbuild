@echo off

REM defaults
set outdir=build
set subdir=favicons
set linksubdir=\%subdir%
set name=favicon
set source=source.png
set color=#000000
set imagemagickdir=windows
set outext=ejs

goto :commandlineparsestart

REM helper functions
:usage
setlocal
	echo Version: faviconbuild 1.0.0 http://theknowledgeaccelerator.com
	echo Copyright: Copyright (C) 2015 Matthew Sanders
	echo usage: build [Options ...]
	echo Options:
	echo 	-o  ^| --outdir          Output Root Directory (where icon and script files are placed)
	echo 	-k  ^| --imagemagick     ImageMagick directory
	echo 	-s  ^| --subdir          Directory where png images are placed
	echo 	-ls ^| --linksubdir      Directory placed in links and content attributes for script
    echo 	-i  ^| --source          Source Image (hint: make this a square image larger then current largest output image)
    echo 	-c  ^| --bgcolor         Background color (used for windows tile)
    echo 	-e  ^| --scriptext       Script Extension (ex: html, ejs, etc.)
    echo 	-h  ^| --help            This Menu
endlocal
goto :eof

:convertImage
setlocal
	set source_name=%1
	set size_w=%2
	set size_h=%3
	set bg_color=%4
	if "%size_h%" == "" set size_h=%size_w%
	set options=-resize %size_w%x%size_h%
	
	if NOT "%bg_color%" == "" set options=%options% -background %bg_color%
	if NOT "%size_w%" == "%size_h%" set options=%options% -gravity center -extent %size_w%x%size_h%

	%imagemagickdir%convert %source_name% %options% %outdir%%subdir%%name%-%size_w%x%size_h%.png
endlocal
goto :eof

:createIcon
setlocal
	set files=
	:whileLoop
		set size=%1
		set files=%files% %outdir%%subdir%%name%-%size%x%size%.png
		shift
	if NOT "%1" == "" goto whileLoop
	
	%imagemagickdir%convert %files% %outdir%%name%.ico
endlocal
goto :eof

:createLink
setlocal
	set rel=%1
	set size_w=%2
	set size_h=%3
	set include_sizes=%4
	set sizes=
	set convert=%5

	if "%size_h%" == "" set size_h=%size_w%
	if "%include_sizes%" == "true" set sizes= sizes="%size_w%x%size_h%" 

	echo ^<link rel=%rel%%sizes% href="%linksubdir%%name%-%size_w%x%size_h%.png"^> >> %outdir%%name%.%outext%
	if "%convert%" == "true" call :convertImage %source% %size_w% %size_h%
endlocal
goto :eof

:createMeta
setlocal
	set meta_name=%1
	set size_w=%2
	set size_h=%3
	set convert=%4
	set content=%5

	if "%content%" == "" set content=%linksubdir%%name%-%size_w%x%size_h%.png

	echo ^<meta name=%meta_name% content="%content%"^> >> %outdir%%name%.%outext%
	if "%convert%" == "true" call :convertImage %source% %size_w% %size_h% %color%
	
endlocal
goto :eof

REM command line parsing
:commandlineparsestart
if -%1-==-- goto commandlineparseend
if /I %1 == -o set outdir=%2& shift
if /I %1 == --outdir set outdir=%2& shift
if /I %1 == -k set imagemagickdir=%2& shift
if /I %1 == --imagemagick set imagemagickdir=%2& shift
if /I %1 == -s set subdir=%2& shift
if /I %1 == --subdir set subdir=%2& shift
if /I %1 == -ls set linksubdir=%2& shift
if /I %1 == --linksubdir set linksubdir=%2& shift
if /I %1 == -i set source=%2& shift
if /I %1 == --source set source=%2& shift
if /I %1 == -c set color=%2& shift
if /I %1 == --color set color=%2& shift
if /I %1 == -e set outext=%2& shift
if /I %1 == --ext set outext=%2& shift
if /I %1 == -h goto usage
if /I %1 == --help goto usage
shift
goto commandlineparsestart
:commandlineparseend

REM directory fixup
if %outdir% == "" (
	set outdir=.
)
set outdir=%outdir%\
if %subdir% == "" (
	set subdir=.
)
set subdir=%subdir%\
if %imagemagickdir% == "" (
	set imagemagickdir=.
)
set imagemagickdir=%imagemagickdir%\

REM main program
mkdir %outdir%%subdir% >nul 2>&1
del /s %outdir%%name%.%outext% >nul 2>&1

for /F "tokens=*" %%A in (favinput.txt) do (
	call :loop %%A
)
goto :EOF

:loop
setlocal enabledelayedexpansion
	set input=%*
	set percent=%%
	set input=%input:#=%
	set output=%input:,=!percent!%
	
	call %output%
endlocal
GOTO :EOF