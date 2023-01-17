# TRIMCROP
![](https://github.com/pnwheeler/TRIMCROP/blob/main/TRIMCROP/TRIM_CROP.ico)
## About
### Qt6/QML desktop app to trim and crop videos. Acts as a front end to configure parameters for ffmpeg's seek and filter options.

| TRIM | CROP |
| --- | --- |
| ![trim gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/adjust_timeline.gif) | ![crop gif](https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/crop_move.gif) | 

## QProcess
| SAVE |
| --- |
| <p align="center"> <img width="460" height="auto" src="https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/save.gif"> </p> |
| Saving the video sends all the relevant arguments(i.e. timestamps, file paths, crop positions/dimensions) to ffmpeg. The Process component exposes Qt's QProcess class, & a few of it's methods, to execute the ffmpeg command. Sends updates 10 times/s to track transcoding progress on the UI |

## Notes
1. Requires ffmpeg


