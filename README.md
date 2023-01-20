# TRIMCROP
### Qt6/QML app to trim and crop videos on desktop. 
![](https://github.com/pnwheeler/TRIMCROP/blob/main/TRIMCROP/TRIM_CROP.ico)

## About
Provides a visual interface to ffmpeg[^1].

Saving the video sends all the information configured on the front end(i.e. trim positions, crop ROI) to ffmpeg, which is ultimately responsible for the actual transcoding. To do this, I exposed Qt's QProcess class to QML, defined the command[^2] I wanted to run, and let ffmpeg do the heavy lifting.  

| TRIM | CROP | EXPORT |
| --- | --- | --- |
| ![trim gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/adjust_timeline.gif) | ![crop gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/crop_move.gif) | ![save_gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/save.gif) | 

[^1]: Requires ffmpeg
[^2]: You can find the command [here](https://github.com/pnwheeler/TRIMCROP/blob/main/TRIMCROP/js/str_utils.js) 

