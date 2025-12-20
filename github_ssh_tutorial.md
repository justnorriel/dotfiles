# Complete Guide: Fix GitHub Push Authentication & Switch to SSH (2025)

## Table of Contents
- [Overview](#overview)
- [Problem: Authentication Failed](#problem-authentication-failed)
- [Solution: Switch to SSH](#solution-switch-to-ssh)
- [Step 1: Generate SSH Key](#step-1-generate-ssh-key)
- [Step 2: Add SSH Key to GitHub](#step-2-add-ssh-key-to-github)
- [Step 3: Test SSH Connection](#step-3-test-ssh-connection)
- [Step 4: Update Remote URL](#step-4-update-remote-url)
- [Step 5: Push Your Changes](#step-5-push-your-changes)
- [Troubleshooting](#troubleshooting)
- [Quick Reference](#quick-reference)

## Overview

This guide walks you through fixing GitHub authentication issues and switching from HTTPS to SSH authentication. As of August 2021, GitHub no longer accepts password authentication for Git operations, making SSH the recommended method.

## Problem: Authentication Failed

If you see this error when pushing to GitHub:

```
remote: Support for password authentication was removed on August 13, 2021.
fatal: Authentication failed for 'https://github.com/username/repo.git/'
```

This means you're using HTTPS authentication, which GitHub has deprecated. The solution is to switch to SSH.

## Solution: Switch to SSH

SSH (Secure Shell) provides a secure way to authenticate with GitHub without entering credentials every time.

### Benefits of SSH:
- No password prompts
- More secure than HTTPS
- Works across all Git operations
- Easy to manage multiple accounts

## Step 1: Generate SSH Key

### Check for Existing SSH Keys

First, check if you already have SSH keys:

```bash
ls -al ~/.ssh
```

Look for files named:
- `id_rsa.pub`
- `id_ecdsa.pub`
- `id_ed25519.pub`

If you see any of these, you can skip to [Step 2](#step-2-add-ssh-key-to-github).

### Generate a New SSH Key

If you don't have an SSH key, generate one:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**Note:** Replace `your_email@example.com` with your GitHub email address.

**For older systems that don't support Ed25519:**

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### During Key Generation

When prompted:

1. **"Enter file in which to save the key"**: Press Enter to accept the default location
2. **"Enter passphrase"**: Enter a secure passphrase (optional but recommended) or press Enter for no passphrase
3. **"Enter same passphrase again"**: Re-enter your passphrase or press Enter

You should see output like:

```
Your identification has been saved in /home/user/.ssh/id_ed25519
Your public key has been saved in /home/user/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx your_email@example.com
```

### Start SSH Agent and Add Your Key

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your SSH private key
ssh-add ~/.ssh/id_ed25519
```

**If you used RSA:**

```bash
ssh-add ~/.ssh/id_rsa
```

## Step 2: Add SSH Key to GitHub

### Copy Your Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

**For RSA keys:**

```bash
cat ~/.ssh/id_rsa.pub
```

This will output something like:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx your_email@example.com
```

Select and copy the **entire output**.

### Add to GitHub

1. Go to [GitHub.com](https://github.com) and sign in
2. Click your profile photo (top right) → **Settings**
3. In the left sidebar, click **SSH and GPG keys**
4. Click **New SSH key** or **Add SSH key**
5. In the "Title" field, add a descriptive label (e.g., "Personal Laptop" or "Work Desktop")
6. In the "Key" field, paste your public key
7. Click **Add SSH key**
8. If prompted, confirm your GitHub password

## Step 3: Test SSH Connection

Verify that your SSH connection works:

```bash
ssh -T git@github.com
```

You may see a warning like:

```
The authenticity of host 'github.com (IP)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes` and press Enter.

**Success looks like:**

```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

## Step 4: Update Remote URL

### Check Current Remote URL

```bash
git remote -v
```

You'll see something like:

```
origin  https://github.com/username/repo.git (fetch)
origin  https://github.com/username/repo.git (push)
```

### Switch to SSH URL

```bash
git remote set-url origin git@github.com:username/repo.git
```

**Important:** Replace `username` and `repo` with your actual GitHub username and repository name.

### Verify the Change

```bash
git remote -v
```

Should now show:

```
origin  git@github.com:username/repo.git (fetch)
origin  git@github.com:username/repo.git (push)
```

## Step 5: Push Your Changes

Now you can push without authentication errors:

```bash
git push origin main
```

**Or if your branch is named differently:**

```bash
git push origin master
# or
git push origin your-branch-name
```

## Troubleshooting

### Permission Denied (publickey)

If you see:

```
Permission denied (publickey).
fatal: Could not read from remote repository.
```

**Solutions:**

1. Ensure SSH key is added to ssh-agent:
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

2. Verify the key is added to GitHub (check Step 2)

3. Test connection again:
   ```bash
   ssh -T git@github.com
   ```

### Wrong SSH Key Being Used

If you have multiple SSH keys:

1. Create/edit `~/.ssh/config`:
   ```bash
   nano ~/.ssh/config
   ```

2. Add this configuration:
   ```
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519
   ```

3. Save and exit (Ctrl+X, then Y, then Enter)

### SSH Agent Not Running

If `ssh-add` fails:

```bash
# Start the agent
eval "$(ssh-agent -s)"

# Then add your key
ssh-add ~/.ssh/id_ed25519
```

### Port 22 Blocked

If your network blocks port 22:

1. Edit `~/.ssh/config`:
   ```
   Host github.com
       HostName ssh.github.com
       Port 443
       User git
   ```

2. Test connection:
   ```bash
   ssh -T git@github.com
   ```

## Quick Reference

### Essential Commands

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key
ssh-add ~/.ssh/id_ed25519

# Copy public key (Linux/Mac)
cat ~/.ssh/id_ed25519.pub

# Test GitHub connection
ssh -T git@github.com

# Update remote to SSH
git remote set-url origin git@github.com:username/repo.git

# Verify remote URL
git remote -v

# Push changes
git push origin main
```

### URL Format Reference

| Type  | Format |
|-------|--------|
| HTTPS | `https://github.com/username/repo.git` |
| SSH   | `git@github.com:username/repo.git` |

### Common File Locations

| Item | Location |
|------|----------|
| SSH Keys | `~/.ssh/` |
| Public Key (Ed25519) | `~/.ssh/id_ed25519.pub` |
| Private Key (Ed25519) | `~/.ssh/id_ed25519` |
| Public Key (RSA) | `~/.ssh/id_rsa.pub` |
| Private Key (RSA) | `~/.ssh/id_rsa` |
| SSH Config | `~/.ssh/config` |

## Additional Resources

- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) (alternative to SSH)
- [Git Documentation](https://git-scm.com/doc)

---

**Last Updated:** December 2025

**Note:** This guide assumes you're using a Unix-like system (Linux, macOS, WSL). Windows users using Git Bash can follow the same commands. For Windows Command Prompt or PowerShell, some commands may differ slightly.
