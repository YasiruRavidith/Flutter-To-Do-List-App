# 🔒 Security Fix Guide - Remove Exposed Google API Key

## ✅ What Has Been Done:

1. ✅ Added `google-services.json` to `.gitignore`
2. ✅ Removed `google-services.json` from Git tracking
3. ✅ Committed the changes
4. ✅ Removed the file from Git history locally

## ⚠️ CRITICAL NEXT STEPS:

### Step 1: Rotate Your API Keys (DO THIS FIRST!)

**Even after removing from Git, the exposed keys are still compromised!**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Credentials**
4. Find the exposed API key and **RESTRICT or DELETE** it
5. Create a new API key with proper restrictions
6. Download new `google-services.json` from [Firebase Console](https://console.firebase.google.com/)
7. Replace the file in `android/app/google-services.json` with the new one

### Step 2: Force Push to Remote Repository

**⚠️ WARNING: This will rewrite history! Notify any collaborators first!**

```powershell
# Navigate to repository
cd "D:\DEV\Flutter To Do List"

# Force push to remote (rewrites history)
git push origin --force --all

# Also force push tags if you have any
git push origin --force --tags
```

### Step 3: Verify on GitHub

1. Go to your repository on GitHub
2. Check the file `android/app/google-services.json` in commit history
3. It should no longer appear in any commit
4. Check Security Alerts - they may take a few hours to clear

### Step 4: Re-clone Repository (For All Team Members)

If you have other computers or team members working on this repo:

```powershell
# Delete old clone
Remove-Item -Recurse -Force "old-repo-folder"

# Fresh clone
git clone https://github.com/YasiruRavidith/Flutter-To-Do-List-App.git
```

## 📋 Backup Your google-services.json

Keep a secure backup of your `google-services.json`:

**Current Location:** `D:\DEV\Flutter To Do List\cute_todo_app\android\app\google-services.json`

**Backup to:** A secure location OUTSIDE the Git repository, like:
- `D:\DEV\Flutter Secrets\google-services.json`
- Password manager
- Encrypted USB drive

## 🔐 Future Prevention:

1. ✅ Never commit `google-services.json` again (already in .gitignore)
2. ✅ Use environment variables for API keys in code
3. ✅ Add API key restrictions in Google Cloud Console
4. ✅ Enable branch protection rules on GitHub
5. ✅ Use GitHub's secret scanning alerts

## 📝 API Key Restrictions to Add:

In Google Cloud Console, restrict your API key to:

**Application restrictions:**
- Android apps only
- Add your package name: `com.yasiru.cute_todo_app`
- Add your SHA-1 certificate fingerprint

**API restrictions:**
- Cloud Firestore API
- Firebase Authentication API
- Google Sign-In API
- Only enable APIs you're actually using

## ✅ Verification Checklist:

- [ ] Rotated/restricted exposed API keys in Google Cloud Console
- [ ] Downloaded new google-services.json from Firebase
- [ ] Replaced local google-services.json with new one
- [ ] Force pushed to GitHub (`git push origin --force --all`)
- [ ] Verified file is removed from GitHub commit history
- [ ] GitHub security alert cleared (may take time)
- [ ] Backed up google-services.json to secure location
- [ ] Added API key restrictions in Google Cloud Console
- [ ] Tested app still works with new configuration

## 🆘 If You Need Help:

1. **Google Cloud Console:** https://console.cloud.google.com/
2. **Firebase Console:** https://console.firebase.google.com/
3. **GitHub Security:** https://github.com/YasiruRavidith/Flutter-To-Do-List-App/security

## 📞 Support:

If you're unsure about any step, ask before proceeding!
