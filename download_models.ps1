# ============================================================
# download_models.ps1
# Downloads all Docling AI models into the portable Python
# environment so the app can run fully offline.
# ============================================================

$ErrorActionPreference = "Stop"

$PortableDir = Join-Path $PSScriptRoot "dist\Docling_App_Portable"
$PythonExe   = Join-Path $PortableDir "python\python.exe"
$ModelsDir   = Join-Path $PortableDir "models"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docling Model Downloader" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $PythonExe)) {
    Write-Host "ERROR: Portable Python not found at: $PythonExe" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ModelsDir)) {
    New-Item -ItemType Directory -Path $ModelsDir | Out-Null
    Write-Host "Created models directory: $ModelsDir" -ForegroundColor Green
}

Write-Host "Portable Python : $PythonExe" -ForegroundColor Yellow
Write-Host "Models folder   : $ModelsDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "Starting download. This may take 10-30+ minutes (~1-2 GB)." -ForegroundColor Yellow
Write-Host ""

$TempScript = Join-Path $PortableDir "download_models_temp.py"

$modelsDirEscaped = $ModelsDir -replace '\\', '\\'

@"
import os, sys

models_dir = r'$ModelsDir'
os.environ['HF_HOME']                = models_dir
os.environ['HF_DATASETS_CACHE']      = models_dir
os.environ['TRANSFORMERS_CACHE']     = models_dir
os.environ['DOCLING_ARTIFACTS_PATH'] = models_dir

print(f"[INFO] HF_HOME set to: {models_dir}")
print("[INFO] Importing Docling...")
sys.stdout.flush()

from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import DocumentConverter, PdfFormatOption
from docling.datamodel.base_models import InputFormat
from docling.backend.pypdfium2_backend import PyPdfiumDocumentBackend
from docling.pipeline.standard_pdf_pipeline import StandardPdfPipeline

print("[INFO] Initializing converter - this triggers model downloads...")
sys.stdout.flush()

pipeline_options = PdfPipelineOptions(
    do_ocr=True,
    do_table_structure=True,
)

converter = DocumentConverter(
    allowed_formats=[InputFormat.PDF],
    format_options={
        InputFormat.PDF: PdfFormatOption(
            pipeline_cls=StandardPdfPipeline,
            backend=PyPdfiumDocumentBackend,
            pipeline_options=pipeline_options,
        )
    }
)

print("")
print("[OK] All models downloaded successfully.")
print(f"[INFO] Stored in: {models_dir}")
"@ | Out-File -FilePath $TempScript -Encoding utf8

$env:HF_HOME                = $ModelsDir
$env:TRANSFORMERS_CACHE     = $ModelsDir
$env:DOCLING_ARTIFACTS_PATH = $ModelsDir

Write-Host "Running download via portable Python..." -ForegroundColor Cyan
Write-Host ""

try {
    & $PythonExe $TempScript
    if ($LASTEXITCODE -ne 0) { throw "Python exited with code $LASTEXITCODE" }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SUCCESS: All models downloaded!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Models saved to: $ModelsDir" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT: The launch .bat will be updated to set HF_HOME offline." -ForegroundColor Yellow

} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
} finally {
    if (Test-Path $TempScript) { Remove-Item $TempScript }
}
