# TRIMCROP
### Qt6/QML app to trim and crop videos on desktop. 
![](https://github.com/pnwheeler/TRIMCROP/blob/main/TRIMCROP/TRIM_CROP.ico)

## About
Provides a visual interface to ffmpeg[^1].

Saving the video sends all the information configured on the front end(i.e. trim positions, information about the crop selection area) to ffmpeg, which is ultimately responsible for the actual transcoding. To do this, I exposed the QProcess class & a few of it's methods to QML[^2], defined the command I wanted to run[^3], and wait[^4] for ffmpeg to finish the heavy lifting. 

| TRIM | CROP | EXPORT |
| --- | --- | --- |
| ![trim gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/adjust_timeline.gif) | ![crop gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/crop_move.gif) | ![save_gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/save.gif) | 

[^1]: Requires ffmpeg!
[^2]: QProcess exposed [here](https://github.com/pnwheeler/TRIMCROP/blob/051ddb1c038c86690142744da49244b6b37b6df4/TRIMCROP/main.cpp#L8-#L39).
[^3]: The ffmpeg command is set up [here](https://github.com/pnwheeler/TRIMCROP/blob/051ddb1c038c86690142744da49244b6b37b6df4/TRIMCROP/js/str_utils.js#L25-L32).
[^4]: ffmpeg's `-stats-period` option is set up to send updates 10x/s to provide UI feedback on the progress.
