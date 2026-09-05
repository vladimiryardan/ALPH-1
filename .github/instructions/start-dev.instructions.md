---
applyTo: "**/start-dev.sh"
---

# Running the development server

- Run this script from Git Bash, from the project root or from the `ZvladSecureFolderIgnore` directory:
  `bash ZvladSecureFolderIgnore/start-dev.sh`
- The script requires CommandBox (`box`) to be installed and available on `PATH`.
- Keep `ZvladSecureFolderIgnore/atticladder-dev.env.sh` present and configured locally. Do not commit or copy its secret values into source files or documentation.
- The script loads the development environment, clears any inherited `SMTP_TLS` and `SMTP_SSL` values, then stops and starts the CommandBox server.
- After changing values in `atticladder-dev.env.sh`, run the script again so the server receives the updated environment.
- If the script reports that the env file is missing, run it from the repository checkout or verify that the script and env file are in the same directory.