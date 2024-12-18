# 1. Set the new Git user information
git config --global user.name "raieshg"
git config --global user.email "raieshg@gmail.com"

# 2. Clear any existing credentials cached locally
git credential-cache exit

# 3. Install GitHub CLI if not installed (Linux example)
# Skip this step if you already have GitHub CLI installed
# sudo apt install gh

# 4. Authenticate with GitHub using the browser
gh auth login

# 5. Follow the prompts:
#    - Select GitHub.com
#    - Choose HTTPS for communication
#    - Choose "Login with a web browser"
#    - Copy the one-time code provided by the CLI
#    - Paste the code into GitHub’s authentication page in your browser
#    - Complete the login process and grant permissions

# 6. Verify the authentication to ensure it's set up correctly
gh auth status

