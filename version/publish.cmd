@echo off

cls
set "comment=Incrementing Version, development commit"
set "increment=N"
set "command="

:loop
IF [%1]==[] (
	goto git
) ELSE (
	echo checking %1
	IF /I [%1]==[t] (
		set "command=%command% -t"
		set "increment=Y"
	) ELSE IF /I [%1]==[s] (
		set "command=%command% -s"
		set "increment=Y"
	) ELSE IF /I [%1]==[m] (
		set "command=%command% -m"
		set "increment=Y"
	) ELSE (
		set comment=%~1
	)
)
SHIFT
GOTO loop	

:git
rem rd /Q /S example/cache-core
rem rd /Q /S example/files
echo Comment: %comment%
echo Increment: %increment%
echo Command: %command%

IF /I (%increment%)==(Y) (
	python update_version.py%command% > nul
)
set /p version=<"src/main/resources/version.nfo"
set version=%version:~9,-1%
set "comment=(ver: %version%) %comment%"

echo Version: %version%

git add .
git commit -am "%comment%"
git push origin develop

:sysexit