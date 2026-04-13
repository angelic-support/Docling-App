# Hand-Over Prompt: Security Audit and GitHub Push Preparation

## Context

We are preparing to push the **Docling App** project to a new GitHub repository, followed by uploading the latest release zip file via GitHub Releases. Before any code is committed or pushed, the repository must be rigorously audited to ensure **no sensitive information, massive binaries, or personal data** is accidentally uploaded.

### Workspace Reference
- **Project root:** `[Project Root Directory]`

---

## Your Task

Perform a comprehensive security audit of the project directory. Your goal is to ensure the codebase is clean, secure, and ready for a public or private GitHub repository. 

Do **not** run `git push` or publish anything to GitHub until all steps below are successfully completed and reviewed by the user.

### Step 1: `.gitignore` Validation
1. Check if a `.gitignore` file exists in the project root. If it doesn't, create one.
2. Ensure the `.gitignore` explicitly ignores the following:
   - Secret files: `.env`, `*.key`, `secrets.json`, etc.
   - Large directories: `dist/`, `build/`, `__pycache__/`, `venv/`, `env/`, `node_modules/`
   - The generated zip file: `Docling_App_Release.zip`, `*.zip`, `*.tar.gz`
   - Any sensitive user-specific paths or raw documentation (e.g., local test PDFs, data folders).

### Step 2: Secret and Sensitive Data Scanning
1. Search the plain-text files (like `.py`, `.ps1`, `.bat`, `.md`, `json`) for potential hardcoded secrets:
   - API Keys (OpenAI, HuggingFace, Gemini, etc.)
   - Passwords or credentials
   - Personal file paths containing specific usernames (e.g., `[User Home]\...`) hardcoded in the scripts.
2. If any are found, **stop immediately** and provide the user with commands or code blocks to remove/parameterize them using environment variables.

### Step 3: Git Status Audit
1. Run `git init` if the repository is not initialized.
2. Run `git status` and list all files that are currently untracked or staged.
3. Verify that the large `dist` folder and the `.zip` file are **not** present in the `git status` output.
4. Provide the list of files to be committed to the user and clearly state why they are safe.

---

## Final Review

Once you have verified the `.gitignore`, scanned for secrets, and confirmed the `git status` output is clean:
1. Present a brief "Security Audit Report" to the user detailing what was checked and what was fixed.
2. Ask the user for explicit permission to proceed with creating the initial commit and pushing to GitHub.
