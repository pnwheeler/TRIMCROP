# TRIMCROP
![](https://github.com/pnwheeler/TRIMCROP/blob/main/TRIMCROP/TRIM_CROP.ico)
### Qt6/QML app to trim and crop videos on desktop

## About
Windows' Photos app doesn't have a cropping tool, so I wanted to see what I could come up with/learn some new things. 
It basically uses Qt's QML qtquickcontrols components as a front end to ffmpeg (which is responsible for the actual video transcoding). 

### Crop
<p> <img width="337" height="auto" src="https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/crop_move.gif"> </p>
The crop region is made of several Rectangle{} components. The area can be positioned, and edges are moved separately.
The absolute positioning of rects + resizing is a bit hacky/wonky. 

*Might update in the future using ShapePath & add the ability to lock to aspect ratios/scale on corners.*

### Trim
<p> <img width="337" height="auto" src="https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/adjust_timeline.gif"> </p>
The trim tool uses QML's quickcontrols2 Slider{} for seeking and RangeSlider{} to demark start and end positions. When either handle is pressed, media playback is paused and the output seeks to the current position. 
Some wonkyness in the video looping logic. The MediaPlayer component backend uses WMF by default & the exposed methods are pretty basic. 

*Might update when the ffmpeg backend is released*

### Save
<p> <img width="330" height="auto" src="https://github.com/pnwheeler/TRIMCROP/blob/main/gifs/save.gif"> </p>
Saving the video sends all the parameters(i.e. timestamps, file paths, crop positions/dimensions) to ffmpeg. 
The Process component exposes Qt's QProcess class, & a few of it's methods, to run program(ffmpeg) and pipe its stdout back to the app. 
I configured the command to send "-progress" updates every .1/s for UI visualization(progress output is parsed from str_utils.js).

## Notes
1. Requires ffmpeg in PATH
2. Made/tested-on Win 11 


