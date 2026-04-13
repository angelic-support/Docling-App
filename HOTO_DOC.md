# Hand-Over Context: Portable Python Packaging

## Why this task exists
The user needs to distribute a Python Streamlit app (`Docling App`) to non-technical coworkers using Windows machines. These coworkers do not have admin rights and cannot install complete Python environments. The chosen solution is to create a "Portable Python" package: a zip file containing the Python runtime, all libraries, the application code, and a `.bat launch script.

## Current Workspace
- **Target Folder:** `c:\Users\Angeluser\Downloads\Docling App`
- **Application Code:** `app.py`, `requirements.txt`
- **Output:** Built environment is in `dist/Docling_App_Portable/`. Zipped release is mapped to `Docling_App_Release.zip`.

## What has been done so far
1. We investigated the application structure and agreed to proceed with creating a portable Python environment.
2. We generated a PowerShell build script (`build_portable_app.ps1`) to automate downloading portable Python 3.11, installing `pip`, downloading packages from `requirements.txt`, and configuring the local folder.
3. We successfully executed this script. It downloaded Python, installed all libraries (including the large `docling` and `torch` dependencies), copied `app.py`, and generated a `Launch Document App.bat` file.
4. **Where it stopped:** The script reached the final command `Compress-Archive` to zip the resulting folder into `Docling_App_Release.zip`. **The user aborted the process because the zip step was taking incredibly long**, which is a known issue with PowerShell's native archiver handling thousands of small Python `site-packages` files.

## What you need to do next
1. **Verify if the Zip Finished:** The background task may have finished zipping after the user cancelled the wait. Check if `c:\Users\Angeluser\Downloads\Docling App\Docling_App_Release.zip` exists and is a reasonable size (>300MB).
2. **Speed up Compression:** If the zip never finished or failed, you will need to re-run the compression using a faster method in the terminal. **Do not use `Compress-Archive` again.** Try checking if `tar.exe` is available (native in Windows 10/11) to zip the folder dynamically, e.g., `tar.exe -a -c -f Docling_App_Release.zip dist\Docling_App_Portable`.
3. **Handle Docling Models (Crucial Open Item):** The application relies on `docling`. While we successfully packaged the Python code, Docling needs HuggingFace layout models. Currently, it will attempt to download these the first time it runs, which will fail if the coworkers have strict firewalls or no internet.
    - Ask the user if offline model packaging is required.
    - If yes, you need to create a script that downloads the models into the portable directory (perhaps by temporarily setting `HF_HOME` inside the portable environment and triggering a dummy Docling parse) before generating the final zip.
4. **Finalize Task Tracking:** Check off the remaining items in the `task.md` document.
5. **Create Walkthrough:** Generate a clear `walkthrough.md` documenting how the package works and how to maintain the `build_portable_app.ps1`.
