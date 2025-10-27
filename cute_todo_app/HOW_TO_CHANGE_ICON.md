# How to Change the App Icon

## Quick Steps:

### 1. Create Your Icon Image
- Create a PNG image (1024x1024 pixels recommended)
- Make sure it's square
- Save it as `app_icon.png`

### 2. Place Icon in Assets Folder
- Put your icon in: `assets/icon/app_icon.png`
- You can use the same image or create a foreground version: `assets/icon/app_icon_foreground.png`

### 3. Run the Icon Generator
Open terminal and run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. Rebuild Your App
```bash
flutter run
```

## Icon Specifications:

**For Best Results:**
- **Size**: 1024x1024 pixels
- **Format**: PNG with transparency
- **Style**: Simple, recognizable design
- **Colors**: Match your app theme (Pink #FFB3BA and Purple #7B68EE)

**Background Color:**
- Currently set to: `#FFB3BA` (cute pink)
- You can change this in `pubspec.yaml` under `adaptive_icon_background`

## Icon Ideas for Cute Todo App:
- ✅ Checkmark with hearts
- 📝 Cute notepad/clipboard
- ⭐ Star with checklist
- 🎀 Ribbon/bow with task
- 💖 Heart with checkmark
- 🌸 Flower with checklist

## Online Icon Generators:
1. **Canva** - https://www.canva.com/ (Free, easy to use)
2. **App Icon Generator** - https://www.appicon.co/
3. **Icon Kitchen** - https://icon.kitchen/

## Quick Fix - Use Default Flutter Colors:
If you want to start with a simple colored icon:
1. Create a solid color PNG (pink or purple)
2. Add a simple white checkmark or star in the center
3. Save as `app_icon.png` in `assets/icon/`
4. Run the commands above

---

**Current Configuration:**
- Icon path: `assets/icon/app_icon.png`
- Foreground: `assets/icon/app_icon_foreground.png`
- Background color: `#FFB3BA` (Pink)
- Package: `flutter_launcher_icons: ^0.14.1`
