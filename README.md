# Background Upload in iOS 🚀
---

## Overview

This repository demonstrates how to implement **background uploads** in iOS applications using SwiftUI and the `URLSession` API with a `.background` configuration. The app allows you to upload images to [imgBB](https://api.imgbb.com/) while running code in the background, even when the app is suspended or terminated.

---

## Features

- **SwiftUI Integration**: Modern UI designed using SwiftUI.
- **Background Upload**: Uploads files using `URLSession` with `.background` configuration.
- **imgBB API Integration**: Utilizes the imgBB API for uploading and managing image files.
- **Error Handling**: Handles upload errors and provides success/error feedback.

---

## API Used: imgBB

To upload images, the project uses the [imgBB API](https://api.imgbb.com/). This REST API allows you to upload images and retrieve their URLs up to 32 MB free.

### API Key Requirement

Before running the project, you **must obtain an API key** from imgBB:
1. Visit the [imgBB API Key Page](https://api.imgbb.com/).
2. Create an account (if you don’t already have one).
3. Generate an API key.

## Getting Started

### Step 1: Clone the Repository
```bash
git clone https://github.com/diananareiko/backgroundUpload.git
cd your-repo-name
```

### Step 2: Add Your API Key
1. Open the project in Xcode.
2. Navigate to `Info.plist`.
3. Fill in IMGBB_API_KEY

### Step 3: Build and Run
- Open the project in Xcode.
- Select a real device as the build target (simulators don’t support background uploads effectively).
- Build and run the app.

---

## How It Works

### 1. Uploading Images
The app enables users to upload images to imgBB. The upload process runs in the background, allowing it to continue even if the app is suspended.

### 2. Background Upload with URLSession
- A `URLSession` instance with a `.background` configuration handles file uploads.
- The app saves the image data as a temporary file and uploads it to the imgBB API using `uploadTask`.
---

## Technology Stack

- **SwiftUI**: For building the app's user interface.
- **URLSession**: For managing background upload tasks.
- **imgBB API**: For handling image uploads.
- **Xcode**: For iOS app development.

---

## Screenshots

| ![Photo 1](https://github.com/user-attachments/assets/8e951bbd-2c66-443b-b093-549251f36698) | ![Photo 2](https://github.com/user-attachments/assets/4f667eab-35e8-4b0c-9c23-966afa8a4b8a) | ![Photo 3](https://github.com/user-attachments/assets/f3ea3190-a7b1-4d36-b237-d4b0326b3da2) |
|---|---|---|
| Screenshot 1 | Screenshot 2 | Screenshot 3 |


---

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch.
3. Make your changes and submit a pull request.

## Useful Resources

- [imgBB API Documentation](https://api.imgbb.com/)
- [URLSession in Background](https://developer.apple.com/documentation/foundation/urlsession)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
  
---

## **Developed By**

**Diana Nareiko**  
Email: diananareiko8@gmail.com  
GitHub: [https://github.com/diananareiko](https://github.com/diananareiko)

---
