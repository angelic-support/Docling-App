# Hand-Over Prompt: Compress Docling Portable App into Final Zip

## Context

A portable Python Streamlit app called **Docling App** has been fully built and
is ready to be zipped for distribution to non-technical Windows users. All
dependencies and AI models have already been bundled offline into the portable
directory.

### Workspace

- **Project root:** `c:\Users\Angeluser\Downloads\Docling App`
- **Portable app folder:** `c:\Users\Angeluser\Downloads\Docling App\dist\Docling_App_Portable`
- **Target zip output:** `c:\Users\Angeluser\Downloads\Docling App\Docling_App_Release.zip`

### What has already been done

1. Portable Python 3.11 is in `dist\Docling_App_Portable\python\`
2. All pip packages (including `docling`, `torch`, `streamlit`) are installed
   under the portable Python's `site-packages`.
3. The Docling AI layout model (`docling-layout-heron`, ~164 MB) has been
   downloaded and placed in `dist\Docling_App_Portable\models\huggingface\hub\`.
4. The launch script `dist\Docling_App_Portable\Launch Document App.bat` has
   been updated to set `HF_HOME`, `HF_HUB_OFFLINE=1`, and
   `TRANSFORMERS_OFFLINE=1` so the app runs fully offline on the end-user's
   machine.
5. `app.py` and `requirements.txt` are already copied into the portable folder.

### Uncompressed size

The full `dist\Docling_App_Portable` folder is **~1.6 GB uncompressed**.

---

## Your Task

**Compress `dist\Docling_App_Portable` into `Docling_App_Release.zip` using
`tar.exe`** (the fast native Windows method). Do NOT use PowerShell's
`Compress-Archive` — it is extremely slow on thousands of small files.

### Step-by-step

1. **Verify `tar.exe` is available:**
   ```powershell
   tar.exe --version
   ```
   It should be available on Windows 10/11 natively. If not, see the
   fallback below.

2. **Run the compression command** from the project root:
   ```powershell
   cd "c:\Users\Angeluser\Downloads\Docling App"
   tar.exe -a -c -f Docling_App_Release.zip -C dist Docling_App_Portable
   ```
   - `-a` = auto-detect format from extension (uses zip since `.zip`)
   - `-c` = create archive
   - `-f` = output filename
   - `-C dist` = change into the `dist` directory first, so the zip root
     contains `Docling_App_Portable\` not `dist\Docling_App_Portable\`

3. **Verify the output:**
   ```powershell
   $size = (Get-Item "Docling_App_Release.zip").Length / 1MB
   Write-Host ("Zip size: {0:N1} MB" -f $size)
   ```
   Expected size: **~700–900 MB**.

4. **Fallback** (if `tar.exe` is unavailable):
   Use 7-Zip if installed:
   ```powershell
   & "C:\Program Files\7-Zip\7z.exe" a -tzip Docling_App_Release.zip ".\dist\Docling_App_Portable\*"
   ```

---

## After Compression

Once the zip is confirmed to exist and is >300 MB:

1. Inform the user that `Docling_App_Release.zip` is ready to distribute.
2. Remind them that end-users just need to:
   - Unzip the archive anywhere on their Windows machine (no admin rights
     needed)
   - Double-click `Launch Document App.bat` inside the unzipped folder
   - A browser window will open automatically with the Docling Converter UI
3. Optionally create a `walkthrough.md` in the project root documenting the
   build process and how to rebuild it in the future.

---

## Key Files Reference

| File | Purpose |
|---|---|
| `dist\Docling_App_Portable\Launch Document App.bat` | End-user launch script (offline-ready) |
| `dist\Docling_App_Portable\app.py` | Main Streamlit application |
| `dist\Docling_App_Portable\python\` | Portable Python 3.11 runtime + all libs |
| `dist\Docling_App_Portable\models\huggingface\` | Bundled AI models (offline) |
| `build_portable_app.ps1` | Script to rebuild the portable env from scratch |
| `download_models.ps1` | Script to re-download AI models into the portable folder |
