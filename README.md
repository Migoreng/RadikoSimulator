# RadikoSimulator
RadikoSimulator is consist of 3 script files radikoreco.sh,radikoplay.sh and radikopast.sh.  
Those scripts are to purely simulate protocol of radiko app for Android OS on another Linux OS understand Bash. They require a PartialKey which corresponds to protocol version to adopt in common.

## radikoreco.sh
This script provides recording in real-time function by simulation with ffmpeg.  
  
### Requirements
*ffmpeg  
  
## radikoplay.sh
This script provides playing in real-time by simulation with arbitrary audio player.  
  
### Requirements
*omxplayer (ONLY FOR Raspberry Pi and highly recommended)
*ffplay  
*vlc  
  
Whichever users would like needed.  
  
## radikopast.sh
This script provides recording in past by simulation with wget.  It has ability to fast obtain the streams within a week after broadcasting is over during they are available in [time-free](https://radiko.jp/rg/timefree/).  But it gets  worthless filler whenever it is about to catch filler due to broadcasting in time-free is not allowed.

## general.sh
This script provides program booking function by specified keywords. When it was given params (Station-code,location,program), creates a booking form as a script. Cussion script are executed every minutes, it also executes the one therefore booking records start.

## cussion
This script creates directories for booking form scripts to put in and does execute the ones in each directories all. Cussion should be executed every minutes by crontab.

### Requirements
*wget

# Features
* Unbounded access  
	The simulator needs the arbitrary value in domestic location. Users have to specify one of prefectures to determine accessing area, lets themselves be able to access to the all of stations.  

* Annoying restrictions free  
	The app in Web and Android gives users some restrictions such positioning every hour for use of the service. The simulator has no restriction because it does simulate only protocol, not what the app works.  

# PartialKey
All versions are available in those functions.

# Others
[Blog](http://eurekamigoreng.blog.fc2.com)
