:: The MIT License (MIT)
:: 
:: Copyright (c) 2025 LogicLoopHole
:: 
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: 
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.
::
@echo off
setlocal enabledelayedexpansion

REM Define the registry path where the NotifyIconSettings subkeys are located
set "registryPath=HKCU\Control Panel\NotifyIconSettings"

REM Get the list of subkeys under NotifyIconSettings
for /f "tokens=*" %%a in ('reg query "%registryPath%" /s /f "" 2^>nul') do (
    REM Check if the line contains the subkey path
    echo %%a | findstr /r "^HKEY_CURRENT_USER\\Control Panel\\NotifyIconSettings\\.*" >nul
    if !errorlevel! equ 0 (
        REM Remove "HKEY_CURRENT_USER" from the path
        set "subkeyPath=%%a"
        set "subkeyPath=!subkeyPath:HKEY_CURRENT_USER=HKEY_CURRENT_USER!"
        
        REM Remove the key path and get only the subkey path
        echo !subkeyPath! | findstr /r /c:"\\Control Panel\\NotifyIconSettings\\[^\\]*$" >nul
        if !errorlevel! equ 0 (
            echo Updating registry key: !subkeyPath!
            reg add "!subkeyPath!" /v IsPromoted /t REG_DWORD /d 1 /f
        )
    )
)

echo All tray icons should now be set to be shown.
endlocal