@ECHO OFF

TITLE Minecraft Bedrock Edition Server Downloader - Pocketmine-MP

PING www.google.nl -n 1 -w 1000
CLS

IF ERRORLEVEL 1 (
    ECHO ===================================FAILED===================================
    ECHO [ERROR] You need intenet connection in intallation proccess, Check your intenet connection and try again
    ECHO ============================================================================
    COLOR 4
    PAUSE
)
CLS
    CD /d %~dp0
    COLOR B

    IF NOT EXIST Server (
        MKDIR Server
        ECHO [Installer] Created folder Server successfully.
    )

    CD Server
    ECHO [Installer]  Finding the latest version of PocketMine
    FOR /F "delims=" %%A IN ('powershell.exe -NoLogo -NoProfile -Command ^ 
        "(& curl.exe -ks https://api.github.com/repos/pmmp/PocketMine-MP/releases/latest | ConvertFrom-Json).tag_name"') DO (
            SET VERSION="%%~A"
    )

    IF %VERSION%==" " (
        COLOR 4
        ECHO ===================================FAILED===================================
        ECHO [ERROR] Missing some packages on your windows, Download started in browser...
        ECHO ============================================================================
        ECHO [Installer]  Openning browser for manually download...
        START "" https://doc.pmmp.io/en/rtfd/installation/downloads.html
    ) ELSE (
        ECHO [Installer]  Downloading Essential files...
        ECHO =============================================================================
        CURL -kOL https://github.com/pmmp/PocketMine-MP/releases/download/%VERSION%/start.cmd
        CURL -kOL https://github.com/pmmp/PocketMine-MP/releases/download/%VERSION%/PocketMine-MP.phar
        CURL -kOL https://jenkins.pmmp.io/job/PHP-8.0-Aggregate/lastSuccessfulBuild/artifact/PHP-8.0-Windows-x64.zip
        ECHO =============================================================================
        ECHO [Installer]  All Essential files downloaded successfully
        ECHO [Installer]  Extracting Essential files...
        powershell.exe -NoLogo -NoProfile -Command "& { $shell = New-Object -COM Shell.Application; $target = $shell.NameSpace('%CD%'); $zip = $shell.NameSpace('%CD%\PHP-8.0-Windows-x64.zip'); $target.CopyHere($zip.Items(), 16); }"
        ECHO [Installer]  Extracted Essential files successfully, Now your server is ready to start
        COLOR A
    )
PAUSE
