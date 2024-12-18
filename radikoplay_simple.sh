#!/bin/bash

source $HOME/RadikoSimulator/settings

##################################################
##########　Needless to modify below.   ##########
##################################################

#
# GPS Location Values of the 47 Prefectures
#
declare -A prefectures
prefectures=(
	["Hokkaido"]="43.06417,141.34694,gps"
	["Aomori"]="40.82444,140.74,gps"
	["Iwate"]="39.70361,141.1525,gps"
	["Miyagi"]="38.26889,140.87194,gps"
	["Akita"]="39.71861,140.1025,gps"
	["Yamagata"]="38.24056,140.36333,gps"
	["Fukushima"]="37.75,140.46778,gps"
	["Ibaraki"]="36.34139,140.44667,gps"
	["Tochigi"]="36.56583,139.88361,gps"
	["Gunma"]="36.39111,139.06083,gps"
	["Saitama"]="35.85694,139.64889,gps"
	["Chiba"]="35.60472,140.12333,gps"
	["Tokyo"]="35.68944,139.69167,gps"
	["Kanagawa"]="35.44778,139.6425,gps"
	["Nigata"]="37.90222,139.02361,gps"
	["Toyama"]="36.69528,137.21139,gps"
	["Ishikawa"]="36.59444,136.62556,gps"
	["Fukui"]="36.06528,136.22194,gps"
	["Yamanashi"]="35.66389,138.56833,gps"
	["Nagano"]="36.65139,138.18111,gps"
	["Gifu"]="35.39111,136.72222,gps"
	["Shizuoka"]="34.97694,138.38306,gps"
	["Aichi"]="35.18028,136.90667,gps"
	["Mie"]="34.73028,136.50861,gps"
	["Shiga"]="35.00444,135.86833,gps"
	["Kyoto"]="35.02139,135.75556,gps"
	["Osaka"]="34.68639,135.52,gps"
	["Hyogo"]="34.69139,135.18306,gps"
	["Nara"]="34.68528,135.83278,gps"
	["Wakayama"]="34.22611,135.1675,gps"
	["Tottori"]="35.50361,134.23833,gps"
	["Shimane"]="35.47222,133.05056,gps"
	["Okayama"]="34.66167,133.935,gps"
	["Hiroshima"]="34.39639,132.45944,gps"
	["Yamaguchi"]="34.18583,131.47139,gps"
	["Tokushima"]="34.06583,134.55944,gps"
	["Kagawa"]="34.34028,134.04333,gps"
	["Ehime"]="33.84167,132.76611,gps"
	["Kouchi"]="33.55972,133.53111,gps"
	["Fukuoka"]="33.60639,130.41806,gps"
	["Saga"]="33.24944,130.29889,gps"
	["Nagasaki"]="32.74472,129.87361,gps"
	["Kumamoto"]="32.78972,130.74167,gps"
	["Oita"]="33.23806,131.6125,gps"
	["Miyazaki"]="31.91111,131.42389,gps"
	["Kagoshima"]="31.56028,130.55806,gps"
	["Okinawa"]="26.2125,127.68111,gps"
)
#
# Each Stations in Japan
#
declare -A stations
stations=(
	["HBCラジオ"]="HBC Hokkaido" # Hokkaido
	["STVラジオ"]="STV Hokkaido" # Hokkaido
	["AIR-G'（FM北海道）"]="AIR-G Hokkaido" # Hokkaido
	["FM NORTH WAVE"]="NORTHWAVE Hokkaido" # Hokkaido
	["RAB青森放送"]="RAB Aomori" # Aomori
	["エフエム青森"]="AFB Aomori" # Aomori
	["IBCラジオ"]="IBC Iwate" # Iwate
	["エフエム岩手"]="FMI Iwate" # Iwate
	["TBCラジオ"]="TBC Miyagi" # Miyagi
	["Date fm エフエム仙台"]="DATEFM Miyagi" # Miyagi
	["ABSラジオ"]="DATEFM Akita" # Akita
	["エフエム秋田"]="AFM Akita" # Akita
	["YBC山形放送"]="YBC Yamagata" # Yamagata
	["Rhythm Station　エフエム山形"]="RFM Yamagata"  # Yamagata
	["RFCラジオ福島"]="RFC Fukushima" # Fukushima
	["ふくしまFM"]="FMF Fukushima" # Fukushima
	["NHKラジオ第1（札幌）"]="JOIK Hokkaido" # Hokkaido
	["NHKラジオ第1（仙台）"]="JOHK Aomori" # Aomori Iwate Miyagi Akita Yamagata Fukushima
	["TBSラジオ"]="TBS Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["文化放送"]="QRR Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["ニッポン放送"]="LFR Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["interfm"]="INT Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["TOKYO FM"]="FMT Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["J-WAVE"]="FMJ Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["ラジオ日本"]="JORF Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["BAYFM78"]="BAYFM78 Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["NACK5"]="NACK5 Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["ＦＭヨコハマ"]="YFM Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["LuckyFM 茨城放送"]="IBS Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa
	["CRT栃木放送"]="CRT Tochigi" # Tochigi
	["RADIO BERRY"]="RADIOBERRY Tochigi" # Tochigi
	["FM GUNMA"]="FMGUNMA Gunma" # Gunma
	["NHKラジオ第1（東京）"]="JOAK Ibaraki" # Ibaraki Tochigi Gunma Saitama Chiba Tokyo Kanagawa Niigata Yamanashi Nagano
	["BSNラジオ"]="BSN Niigata" # Niigata
	["FM NIIGATA"]="FMNIIGATA Niigata" # Niigata
	["KNBラジオ"]="KNB Toyama" # Toyama
	["FMとやま"]="FMTOYAMA Ishikawa" # Ishikawa
	["MROラジオ"]="MROラジオ Ishikawa" # Ishikawa
	["エフエム石川"]="HELLOFIVE Ishikawa" # Ishikawa
	["FBCラジオ"]="FBC Fukui" # Fukui
	["FM福井"]="FMFUKUI Fukui" # Fukui
	["YBSラジオ"]="YBS Yamanashi" # Yamanashi
	["FM FUJI"]="FM-FUJI Yamanashi" # Yamanashi
	["SBCラジオ"]="SBC Nagano" # Nagano
	["FM長野"]="FMN Nagano" # Nagano
	["NHKラジオ第1（名古屋）"]="JOCK Toyama" # Toyama Ishikawa Fukui Gifu Shizuoka Aichi Mie
	["CBCラジオ"]="CBC Gifu" # Gifu Aichi Mie
	["TOKAI RADIO"]="TOKAIRADIO Gifu" # Gifu Aichi Mie
	["ぎふチャン"]="GBS Gifu" # Gifu Aichi Mie
	["ZIP-FM"]="ZIP-FM Gifu" # Gifu Aichi Mie
	["FM AICHI"]="FMAICHI Gifu" # Gifu Aichi Mie
	["FMGIFU"]="FMGIFU Gifu" # Gifu
	["SBSラジオ"]="SBS Shizuoka" # Shizuoka
	["K-MIX"]="K-MIX Shizuoka" # Shizuoka
	["レディオキューブ FM三重"]="FMMIE Mie" # Mie
	["ABCラジオ"]="ABC Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["MBSラジオ"]="MBS Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["OBCラジオ大阪"]="OBC Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["FM COCOLO"]="CCL Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["FM802"]="802 Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["FM大阪"]="FMO Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["Kiss FM KOBE"]="KISSFMKOBE Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["ラジオ関西"]="CRK Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["e-radio FM滋賀"]="E-RADIO Shiga" # Shiga
	["KBS京都ラジオ"]="KBS Shiga" # Shiga Kyoto Osaka
	["α-STATION FM KYOTO"]="ALPHA-STATION Shiga" # Shiga Kyoto Osaka Nara
	["WBS和歌山放送"]="WBS Wakayama" # Wakayama
	["NHKラジオ第1（大阪）"]="JOBK Shiga" # Shiga Kyoto Osaka Hyogo Nara Wakayama
	["BSSラジオ"]="BSS Tottori" # Tottori Shimane
	["エフエム山陰"]="FM-SANIN Tottori" # Tottori Shimane
	["RSKラジオ"]="RSK Okayama" # Okayama
	["FM岡山"]="FM-OKAYAMA Okayama" # Okayama
	["RCCラジオ"]="RCC Hiroshima" # Hiroshima
	["広島FM"]="HFM Hiroshima" # Hiroshima
	["KRY山口放送"]="KRY Yamaguchi" # Yamaguchi
	["エフエム山口"]="FMY Yamaguchi" # Yamaguchi
	["JRT四国放送"]="JRT Tokushima" # Tokushima
	["FM徳島"]="FM807 Tokushima" # Tokushima
	["RNC西日本放送"]="RNC Kagawa" # Kagawa
	["エフエム香川"]="FMKAGAWA Kagawa" # Kagawa
	["RNB南海放送"]="RNB Ehime" # Ehime
	["FM愛媛"]="JOEU-FM Ehime" # Ehime
	["RKC高知放送"]="RKC Kochi" # Kochi
	["エフエム高知"]="HI-SIX Kochi" # Kochi
	["NHKラジオ第1（広島）"]="JOFK Tottori" # Tottori Shimane Okayama Hiroshima Yamaguchi
	["NHKラジオ第1（松山）"]="JOZK Tokushima" # Tokushima Kagawa Ehime Kochi
	["RKBラジオ"]="RKB Fukuoka" # Fukuoka Saga
	["KBCラジオ"]="KBC Fukuoka" # Fukuoka Saga
	["LOVE FM"]="LOVEFM Fukuoka" # Fukuoka
	["CROSS FM"]="CROSSFM Fukuoka" # Fukuoka
	["FM FUKUOKA"]="FMFUKUOKA Fukuoka" # Fukuoka
	["エフエム佐賀"]="FMS Saga" # Saga
	["NBCラジオ"]="NBC Saga" # Saga Nagasaki
	["FM長崎"]="FMNAGASAKI Nagasaki" # Nagasaki
	["RKKラジオ"]="RKK Kumamoto" # Kumamoto
	["FMKエフエム熊本"]="FMK Kumamoto" # Kumamoto
	["OBSラジオ"]="OBS Oita" # Oita
	["エフエム大分"]="FM_OITA Oita" # Oita
	["宮崎放送"]="MRT Miyazaki" # Miyazaki
	["エフエム宮崎"]="JOYFM Miyazaki" # Miyazaki
	["MBCラジオ"]="MBC Kagoshima" # Kagoshima
	["μＦＭ"]="MYUFM Kagoshima" # Kagoshima
	["RBCiラジオ"]="RBC Okinawa" # Okinawa
	["ラジオ沖縄"]="ROK Okinawa" # Okinawa
	["FM沖縄"]="FM_OKINAWA Okinawa" # Okinawa
	["NHKラジオ第1（福岡）"]="JOLK Fukuoka" # Fukuoka Saga Nagasaki Kumamoto Oita Miyazaki Kagoshima Okinawa
	["ラジオNIKKEI第1"]="RN1 Tokyo" # everywhere
	["ラジオNIKKEI第2"]="RN2 Tokyo" # everywhere
	["NHK-FM（東京）"]="JOAK-FM Tokyo" # everywhere
)

station_name=$1 # 外部入力(放送局名を受け取る)
broadcast_info=(${stations[$station_name]}) # 放送局名をもとに放送局コードと都道府県のペアを取り出す
broadcast_code=${broadcast_info[0]} # 放送局コードを抽出
area=${broadcast_info[1]} # 都道府県を抽出

#
# Choice of X-Radiko-User(install_id)
#
mkdir -p $(dirname $0)/cache/play
pid=$$
xradikouser=`head -c 1k /dev/urandom | md5sum | awk '{ print $1 }'`

echo "Your InstallID is ${xradikouser}"


if [ $# -eq 1 ]; then
  channel=$broadcast_code
  location=${prefectures["$area"]}
else
  echo "usage: $0 <放送局名>"
  echo "example: $0 TBSラジオ"
  echo "エラー: 引数は1つだけ指定してください。"
  exit 1
fi

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
     -O $(dirname $0)/cache/play/auth1_${pid} \
     https://radiko.jp/v2/api/auth1 \
     2>/dev/null

if [ $? -ne 0 ]; then
  echo "Authentication step1 did fail."
  exit 1
fi

#
# Gnerate PartialKey and Other params to be sent.
#
authtoken=`perl -ne 'print $1 if(/x-radiko-authtoken: ([\w-]+)/i)' $(dirname $0)/cache/play/auth1_${pid}`
offset=`perl -ne 'print $1 if(/x-radiko-keyoffset: (\d+)/i)' $(dirname $0)/cache/play/auth1_${pid}`
length=`perl -ne 'print $1 if(/x-radiko-keylength: (\d+)/i)' $(dirname $0)/cache/play/auth1_${pid}`
partialkey=`dd if=$keyfile bs=1 skip=${offset} count=${length} 2> /dev/null | base64`

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
     -O $(dirname $0)/cache/play/auth2_${pid} \
     https://radiko.jp/v2/api/auth2 \
     2>/dev/null

if [ $? -ne 0 -o ! -f $(dirname $0)/cache/play/auth2_${pid} ]; then
  echo "Authentication step2 did fail."
  exit 1
fi

echo "Authentication was successful!"

areaid=`perl -ne 'print $1 if(/^([^,]+),/i)' $(dirname $0)/cache/play/auth2_${pid}`
echo "areaid: ${areaid}"
echo "area: ${area}"
echo "Your Location is set as ${location} Now!"

#
# Obtain Initial Playlist(.m3u8) and Save Stream data(.aac)
#
wget -nv \
  --header="X-Radiko-AuthToken: ${authtoken}" \
  --save-headers \
  -O $(dirname $0)/cache/play/ignite_${pid} \
  http://f-radiko.smartstream.ne.jp/${channel}/_definst_/simul-stream.stream/playlist.m3u8 \
  2>/dev/null

iniplalis=`cat $(dirname $0)/cache/play/ignite_${pid} | grep '.m3u8'`

### Uncomment any one of the lines to enable listen to the radio in real-time by an arbitrary player. (Recording function is going to be disabled) ###
#vlc ${iniplalis} 2>/dev/null        # Play by VLC 
#cvlc ${iniplalis} 2>/dev/null        # Play by cvlc
ffplay -i ${iniplalis} 2>/dev/null  # Play by ffplay
#omxplayer ${iniplalis} 2>/dev/null  # Play by omxplayer (Highly Recommended for Raspberry Pi)
#echo ${iniplalis} 	             # Show detail

# Those lines do eliminate trash. 
rm -f $(dirname $0)/cache/play/ignite_${pid}
rm -f $(dirname $0)/cache/play/auth1_${pid} 
rm -f $(dirname $0)/cache/play/auth2_${pid} 
