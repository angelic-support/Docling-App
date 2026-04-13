$ErrorActionPreference = "Stop"

$workspace = $PSScriptRoot
$distDir = "$workspace\dist"
$portableDir = "$distDir\Docling_App_Portable"
$releaseZip = "$workspace\Docling_App_Release.zip"
$pythonVer = "3.11.9"
$pythonUrl = "https://www.python.org/ftp/python/$pythonVer/python-$pythonVer-embed-amd64.zip"

Write-Host "Cleaning up previous builds..."
if (Test-Path $distDir) { Remove-Item -Recurse -Force $distDir }
if (Test-Path $releaseZip) { Remove-Item -Force $releaseZip }

New-Item -ItemType Directory -Force -Path $portableDir > $null

Write-Host "Downloading Portable Python $pythonVer..."
$pythonZipPath = "$distDir\python.zip"
Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonZipPath

Write-Host "Extracting Python..."
$pythonDir = "$portableDir\python"
Expand-Archive -Path $pythonZipPath -DestinationPath $pythonDir -Force
Remove-Item $pythonZipPath

Write-Host "Enabling site-packages in embedded Python..."
$pthFile = Get-ChildItem -Path $pythonDir -Filter "*._pth" | Select-Object -First 1
$pthContent = Get-Content $pthFile.FullName
$pthContent = $pthContent -replace "#import site", "import site"
Set-Content -Path $pthFile.FullName -Value $pthContent

Write-Host "Downloading get-pip.py..."
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$pythonDir\get-pip.py"

Write-Host "Installing Pip..."
Set-Location $pythonDir
& .\python.exe get-pip.py --no-warn-script-location
if ($LASTEXITCODE -ne 0) { throw "pip installation failed" }

Write-Host "Installing application dependencies..."
Copy-Item "$workspace\requirements.txt" "$portableDir\requirements.txt"
Set-Location $portableDir
& .\python\python.exe -m pip install -r requirements.txt --no-warn-script-location
if ($LASTEXITCODE -ne 0) { throw "pip install requirements failed" }

Write-Host "Copying application files..."
Copy-Item "$workspace\app.py" "$portableDir\app.py"

Write-Host "Creating Launch script..."
$batContent = @"
@echo off
echo Starting the Document App, please wait...
.\python\python.exe -m streamlit run app.py
pause
"@
Set-Content -Path "$portableDir\Launch Document App.bat" -Value $batContent

Write-Host "Zipping the release..."
Set-Location $workspace
Compress-Archive -Path $portableDir -DestinationPath $releaseZip -Force

Write-Host "Build complete! Package is ready at: $releaseZip"
