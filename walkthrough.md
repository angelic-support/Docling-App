# Docling App — Portable Build Walkthrough

## Overview

This document records how the portable, offline-ready **Docling App** was built and packaged for distribution to non-technical Windows users.

---

## What Was Built

A fully self-contained Windows zip archive that:
- Runs entirely offline (no internet required after unzipping)
- Requires zero installation from the end-user (no Python, no pip, no admin rights)
- Launches with a double-click on a `.bat` file

---

## Final Output

| File | Size | Location |
|---|---|---|
| `Docling_App_Release.zip` | ~631 MB | `[Project Root Directory]\` |

---

## Zip Contents Structure

```
Docling_App_Release.zip
└── Docling_App_Portable\
    ├── Launch Document App.bat     ← End-user entry point
    ├── app.py                      ← Main Streamlit application
    ├── requirements.txt
    ├── python\                     ← Portable Python 3.11 runtime + all pip libs
    │   └── site-packages\          ← docling, torch, streamlit, etc.
    └── models\
        └── huggingface\hub\        ← Bundled AI layout model (~164 MB offline)
```

---

## How the Package Was Created

### Step 1 — Portable Python
Portable Python 3.11 was placed in `dist\Docling_App_Portable\python\` and all required pip packages (`docling`, `torch`, `streamlit`, etc.) were installed into its `site-packages`.

### Step 2 — AI Models Bundled Offline
The Docling layout model (`docling-layout-heron`, ~164 MB) was downloaded and placed into:
```
dist\Docling_App_Portable\models\huggingface\hub\
```

### Step 3 — Offline Launch Script
`Launch Document App.bat` was configured with the following environment variables to force fully offline operation:
```bat
set HF_HOME=%~dp0models\huggingface
set HF_HUB_OFFLINE=1
set TRANSFORMERS_OFFLINE=1
```

### Step 4 — Compression
The portable folder was zipped using Windows native `tar.exe` (bsdtar 3.8.4):
```powershell
cd "[Project Root Directory]"
tar.exe -a -c -f Docling_App_Release.zip -C dist Docling_App_Portable
```

> **Why `tar.exe` instead of `Compress-Archive`?**  
> PowerShell's `Compress-Archive` is extremely slow on thousands of small files (common with Python packages). `tar.exe` is the native Windows method and is significantly faster.

---

## How to Distribute

1. Share `Docling_App_Release.zip` with the end-user (via USB, Google Drive, etc.)
2. Instruct them to:
   - **Unzip** the archive anywhere on their Windows PC (no admin rights needed)
   - **Double-click** `Launch Document App.bat` inside the unzipped folder
   - A browser window will open automatically with the Docling Converter UI

---

## How to Rebuild

### Rebuild the portable environment from scratch:
```powershell
cd "[Project Root Directory]"
.\build_portable_app.ps1
```

### Re-download AI models into the portable folder:
```powershell
.\download_models.ps1
```

### Re-compress after any changes:
```powershell
tar.exe -a -c -f Docling_App_Release.zip -C dist Docling_App_Portable
```

---

## Build Date
2026-04-13
