# SB Loadscreen

A highly customizable loadscreen system for RedM servers, offering multiple background types, sleek animations, and a modern interface to enhance the player connection experience.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Multiple Background Options
- **Image Backgrounds**: Use static images with optional rotation
- **Video Backgrounds**: Implement local video files with customizable settings
- **YouTube Integration**: Stream YouTube videos during loading
- **Google Drive Support**: Use videos hosted on Google Drive
- **Random Image Selection**: Choose from a pool of background images

### Audio System
- **Background Music**: Add custom audio tracks to your loadscreen
- **Volume Control**: Configure audio levels for optimal player experience
- **Mute Options**: Control audio muting for various media types

### Visual Customization
- **Loading Spinners**: Choose from multiple loading icon styles
- **Custom Colors**: Personalize your loading screen with brand colors
- **Time Display**: Show elapsed loading time for player awareness
- **Modern Interface**: Clean, responsive design that scales to any resolution

### Loading Control
- **Skip Options**: Configure if and when players can skip the loadscreen
- **Load Time Management**: Smart handling of loading completion
- **Loading Status**: Visual indicators of loading progress

## Installation

1. Download the resource
2. Place in your `resources/[screenLoader]` folder
3. Ensure the folder is named `sb_loadscreen`
4. Add `ensure sb_loadscreen` to your server.cfg
5. Add `loadscreen sb_loadscreen` to your server.cfg
6. Configure the loadscreen in the config.js file
7. Restart your server

## Configuration

The resource is highly configurable through the `config.js` file:

### Background Image Configuration

```js
image: {
    active: true, // Enable image background
    source: "url('nui://sb_loadscreen/ui/assets/background.png')",
    backgroundcolor: "#4d4d4d",
    random: {
        active: false, // Use random images
        sources: [ // Array of image paths
            "url('nui://sb_loadscreen/ui/assets/background.png')",
            "url('nui://sb_loadscreen/ui/assets/images/background1.jpg')"
        ],
        rotate: {
            active: false, // Enable image rotation
            sequenced: false, // Show images in sequence or randomly
            time: 5, // Rotate every X seconds
        }
    }
}
```

### Video Configuration

```js
video: {
    active: false, // Enable local video background
    source: "nui://sb_loadscreen/ui/assets/video.mp4",
    looped: true, // Loop the video
    mute: true,
    volume: 0.5, // 0-1 volume range
}
```

### YouTube Integration

```js
youtube: {
    active: false, // Enable YouTube video background
    source: "4KPpWQ7XVO8", // YouTube video ID
    looped: false,
    mute: false,
    volume: 50 // 0-100 volume range
}
```

### Audio Settings

```js
audio: {
    active: false, // Enable background audio
    source: 'nui://sb_loadscreen/ui/assets/music.mp3',
    volume: 0.5, // 0-1 volume range
}
```

### Loading Display Options

```js
loadtime: {
    skip: true, // Allow skipping after main game loads
    lang: "A bit more..." // Custom text
},
timeelapsed: true, // Show elapsed time
loading: {
    active: true, // Show loading spinner
    icon: "fadedots", // Loading spinner style
    color: "#942626" // Spinner color
}
```

## Technical Details

### Requirements
- RedM server

### Available Loading Spinner Styles
- fadedots
- bouncing
- circle
- dual-ring
- ellipsis
- facebook
- grid
- heart
- hourglass
- ring
- ripple
- roller
- spinner
- And more...

### Helper Integration
For enhanced functionality, consider using with the `sb_loadscreen_helper` script which enables:
- Automatic detection of game initialization
- Improved spacebar skip handling
- First spawn detection

## License

This script is protected by the cfx.re Escrow and Keymaster system and is licensed exclusively to the individual purchaser. The license is tied to the purchaser's cfx.re account.

### Key License Terms:
- Script is bound to the purchaser's cfx.re account license key
- Only the config.js file(s) may be modified
- No redistribution, reselling, or transfer allowed
- No decompilation or reverse engineering permitted
- For use only on servers owned/operated by the purchaser

For complete license terms, please see the [LICENSE](./LICENSE) file included with this script.

**IMPORTANT**: Attempting to circumvent the protection system or violate license terms will result in immediate termination of your license without refund.

## Credits

Created by Salah
