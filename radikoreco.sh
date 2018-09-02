#!/bin/bash

source $HOME/RadikoSimulator/settings

##################################################
##########　Needless to modify below.   ##########
##################################################

#
# GPS Location Values of the 47 Prefectures
#
declare -A prefectures
prefectures["Hokkaido"]="43.06417,141.34694,gps"
prefectures["Aomori"]="40.82444,140.74,gps"
prefectures["Iwate"]="39.70361,141.1525,gps"
prefectures["Miyagi"]="38.26889,140.87194,gps"
prefectures["Akita"]="39.71861,140.1025,gps"
prefectures["Yamagata"]="38.24056,140.36333,gps"
prefectures["Fukushima"]="37.75,140.46778,gps"
prefectures["Ibaraki"]="36.34139,140.44667,gps"
prefectures["Tochigi"]="36.56583,139.88361,gps"
prefectures["Gunma"]="36.39111,139.06083,gps"
prefectures["Saitama"]="35.85694,139.64889,gps"
prefectures["Chiba"]="35.60472,140.12333,gps"
prefectures["Tokyo"]="35.68944,139.69167,gps"
prefectures["Kanagawa"]="35.44778,139.6425,gps"
prefectures["Nigata"]="37.90222,139.02361,gps"
prefectures["Toyama"]="36.69528,137.21139,gps"
prefectures["Ishikawa"]="36.59444,136.62556,gps"
prefectures["Fukui"]="36.06528,136.22194,gps"
prefectures["Yamanashi"]="35.66389,138.56833,gps"
prefectures["Nagano"]="36.65139,138.18111,gps"
prefectures["Gifu"]="35.39111,136.72222,gps"
prefectures["Shizuoka"]="34.97694,138.38306,gps"
prefectures["Aichi"]="35.18028,136.90667,gps"
prefectures["Mie"]="34.73028,136.50861,gps"
prefectures["Shiga"]="35.00444,135.86833,gps"
prefectures["Kyoto"]="35.02139,135.75556,gps"
prefectures["Osaka"]="34.68639,135.52,gps"
prefectures["Hyogo"]="34.69139,135.18306,gps"
prefectures["Nara"]="34.68528,135.83278,gps"
prefectures["Wakayama"]="34.22611,135.1675,gps"
prefectures["Tottori"]="35.50361,134.23833,gps"
prefectures["Shimane"]="35.47222,133.05056,gps"
prefectures["Okayama"]="34.66167,133.935,gps"
prefectures["Hiroshima"]="34.39639,132.45944,gps"
prefectures["Yamaguchi"]="34.18583,131.47139,gps"
prefectures["Tokushima"]="34.06583,134.55944,gps"
prefectures["Kagawa"]="34.34028,134.04333,gps"
prefectures["Ehime"]="33.84167,132.76611,gps"
prefectures["Kouchi"]="33.55972,133.53111,gps"
prefectures["Fukuoka"]="33.60639,130.41806,gps"
prefectures["Saga"]="33.24944,130.29889,gps"
prefectures["Nagasaki"]="32.74472,129.87361,gps"
prefectures["Kumamoto"]="32.78972,130.74167,gps"
prefectures["Oita"]="33.23806,131.6125,gps"
prefectures["Miyazaki"]="31.91111,131.42389,gps"
prefectures["Kagoshima"]="31.56028,130.55806,gps"
prefectures["Okinawa"]="26.2125,127.68111,gps"

#
# Usage and Warnings
#
while getopts d:s:l:t:p: OPT
  do
     case $OPT in
       "s" ) FLG_S="TRUE" ; VALUE_S="$OPTARG" ;;
       "l" ) FLG_L="TRUE" ; VALUE_L="$OPTARG" ;;
       "t" ) FLG_T="TRUE" ; VALUE_T="$OPTARG" ;;
       "p" ) FLG_P="TRUE" ; VALUE_P="$OPTARG" ;;
        *  ) echo "Usage: $0 -s <StationCode> -l <Prefecture> -t <RecordingDuration> -p <ProgramTitle>"
             echo "Example: $0 -s NBC -l Nagasaki -t 30 -p \"じげらナイトキャンラジ\""
exit 1;;
     esac
   done

if [ -z $VALUE_S ] || [ -z $VALUE_L ] || [ -z $VALUE_T ] || [ -z $VALUE_P ]; then
 echo "Usage: $0 -s <StationCode> -l <Prefecture> -t <RecordingDuration> -p <ProgramTitle>"
 echo "Example: $0 -s NBC -l Nagasaki -t 30 -p \"じげらナイトキャンラジ\""
 exit 1
fi

if [ -e $keyfile ] ;then
  :
else
  echo "Not Found PartialKey File!"
  exit 1
fi


#
# Terminate params needed to start recording.
#
pid=$$
duration=`expr $VALUE_T \* 60`
location=${prefectures[$VALUE_L]}
outdir="$defaultdir/$VALUE_P"
mkdir -p $outdir
mkdir -p $(dirname $0)/cache/reco
latest="`cat $outdir/current 2>/dev/null`.aac"



# "current" file creation
echo -n "$radiodate" > $outdir/current



#
# Randomly Choice of X-Radiko-User(Same as install_id)
#
xradikouser=`head -c 1k /dev/urandom | md5sum | awk '{ print $1 }'`
echo "Your current InstallID is ${xradikouser}"

#
# Authentication Step1 
#
wget -nv \
     --header="Pragma: no-cache" \
     --header="Cache-Control: no-cache" \
     --header="X-Radiko-App: aSmartPhone6" \
     --header="X-Radiko-App-Version: 5.0.4" \
     --header="X-Radiko-User: ${xradikouser}" \
     --header="X-Radiko-Device: 19.NX513J" \
     --no-check-certificate \
     --save-headers \
     -O $(dirname $0)/cache/reco/auth1_${pid} \
     https://radiko.jp/v2/api/auth1 \
     2> /dev/null
if [ $? -ne 0 ]; then
  echo "Authentication step1 did fail."
  exit 1
fi

#
# Clip PartialKey as required and the other params to be sent.
#
authtoken=`perl -ne 'print $1 if(/x-radiko-authtoken: ([\w-]+)/i)' $(dirname $0)/cache/reco/auth1_${pid}`
offset=`perl -ne 'print $1 if(/x-radiko-keyoffset: (\d+)/i)' $(dirname $0)/cache/reco/auth1_${pid}`
length=`perl -ne 'print $1 if(/x-radiko-keylength: (\d+)/i)' $(dirname $0)/cache/reco/auth1_${pid}`
partialkey=`dd if=$keyfile bs=1 skip=${offset} count=${length} 2>/dev/null | base64`

#
# Authentication Step2
#
wget -nv \
    --header="Pragma: no-cache" \
    --header="Cache-Control: no-cache" \
    --header="X-Radiko-App: aSmartPhone6" \
    --header="X-Radiko-App-Version: 5.0.4" \
    --header="X-Radiko-User: ${xradikouser}" \
    --header="X-Radiko-Device: 19.NX513J" \
    --header="X-Radiko-Authtoken: ${authtoken}" \
    --header="X-Radiko-Partialkey: ${partialkey}" \
    --header="X-Radiko-Connection: wifi" \
    --header="X-Radiko-Location: ${location}" \
    --no-check-certificate \
    --save-headers \
    -O $(dirname $0)/cache/reco/auth2_${pid} \
    https://radiko.jp/v2/api/auth2 \
    2> /dev/null

if [ $? -ne 0 -o ! -f $(dirname $0)/cache/reco/auth2_${pid} ]; then
  echo "Authentication step2 did fail."
  exit 1
fi

echo "Authentication was successful!"

areaid=`perl -ne 'print $1 if(/^([^,]+),/i)' $(dirname $0)/cache/reco/auth2_${pid}`
echo "Your Location is set as ${location} Now!"


#
# Show Detail while processing
#
echo "StationCode:$VALUE_S"
echo "Location:$VALUE_L"
echo "ProgramName:$VALUE_P"
echo "RecordingLatestDate:$latest"
echo "SaveTo:$outdir"
echo "SaveAs:${outdir}/${radiodate}"
echo "Started: `date "+%Y%m%d %H:%M:%S"`"
echo "End:     `date \"+%Y%m%d %H:%M:%S\" --date +${duration}seconds`"
echo -e "\e[7m Press 'q' or 'Ctrl + C' to stop this recording. \e[m"

#
# Obtain Initial Playlist(.m3u8) and Save Stream data(.aac)
#
wget -nv \
  --header="X-Radiko-AuthToken: ${authtoken}" \
  --save-headers \
  -O $(dirname $0)/cache/reco/ignite_${pid} \
  http://f-radiko.smartstream.ne.jp/${VALUE_S}/_definst_/simul-stream.stream/playlist.m3u8 \
  2>/dev/null

iniplalis=`cat $(dirname $0)/cache/reco/ignite_${pid} 2>/dev/null | grep '.m3u8'`  
mkdir -p $RECdir/${VALUE_P}
ffmpeg -loglevel error -stats -i "${iniplalis}" -headers "X-Radiko-AuthToken: ${authtoken}" -t ${duration} -c copy $RECdir/${VALUE_P}/${VALUE_P}_${radiodate}.aac


#
# Eliminate trash.
#
rm -f $(dirname $0)/cache/reco/_${pid}
rm -f $(dirname $0)/cache/reco/auth1_${pid}
rm -f $(dirname $0)/cache/reco/auth2_${pid}
rm -f $(dirname $0)/cache/reco/ignite_${pid}
