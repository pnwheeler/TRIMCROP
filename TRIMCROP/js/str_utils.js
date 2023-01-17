//--------------------Get file name string-----------------------
function getFileName(url) {
    let path = url.toString()
    return (path.slice(path.lastIndexOf("/")+1))
}

//--------------------Get local path string----------------------
function getLocalPath(url){
    let path = url.toString()
    path = path.replace(/^(file:\/{3})/,"")
    return (decodeURIComponent(path))
}

//------------Configure arguments for ffmpeg command-------------
function config_ffmpeg_args(in_url, out_url, start, total_duration, w, h, x, y){
    let in_path = getLocalPath(in_url)
    let out_path = getLocalPath(out_url)
    let crop_params = "crop=" + Math.round(w)
        + ":" + Math.round(h)
        + ":" + Math.round(x)
        + ":" + Math.round(y)
    let from = start + "ms"
    let duration = total_duration + "ms"

    return(["-progress", "-", "-nostats",   //-----prefer "progress" option over "stats"
            "-stats_period", .1,            //-----send updates every tenth second
            "-y",                           //-----force overwrite if necessary
            "-ss", from,                    //-----seek from
            "-i", in_path,                  //-----input file
             "-to", duration,               //-----seek duration
            "-filter:v", crop_params,       //-----crop filter
            out_path])                      //-----output file
}

//---------------Parse the lines of ffmpeg progress--------------
function parse_stats(progressInfo){
    let text = progressInfo.toString()
    let line = text.split(/[\r\n]+/g)
    let curr_pos = line[6].split("=")[1]
    let progress = line[11].split("=")[1]
    return {curr_pos, progress}
}
