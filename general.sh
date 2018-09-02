#!/bin/bash

#　　【RadikoSimulator用録音予約スクリプト】
#このスクリプトは引数を3つ与えられて実行することで自動的にキーワード検索をして次の日時の番組を予約することができる。
#ただしこのスクリプトは予約の帳票をスクリプトとして出力するだけなので、そのスクリプトを叩いて録音するためには
#ワンクッション置く必要がある。そのため、クッションスクリプトを作成し、それをcrontabが毎分叩くということで
#予約録音が実現する。
#2018年03月04日
#
#＊前方一致、後方一致、部分一致、完全一致の検索パターンを第四引数で指定するよう機能を拡張した。
#＊番組表にマッチする番組名が複数あるときそれらを一括に予約するようにした。
#
# @@@@@@@@@@@@@@@@@
# @便利な番組名検索@
# @@@@@@@@@@@@@@@@@
# ステーションコードがFMTの場合
# station='FMT'
# wget -q -O - http://radiko.jp/v3/program/station/weekly/$station.xml | \
# grep -e "<title>.*</title>" | \
# grep -e 速水 -e 中西 \
# | sed -e "s/<title>\(.*\)<\/title>/\1/" -e "s/\s//g" | sort | uniq
# ＊＊＊grep -eの行を増やして絞り込みをいくらでも可能にすることができる＊＊＊

source $HOME/RadikoSimulator/settings


cd $(dirname $0)

station=$1 #局名(NBCなど)
location=$2 #地域名(Nagasakiなど)
program=$3 #番組名
pattern=$4 #前方一致1、後方一致2、部分一致3、完全一致4

#####################################
#予約票を格納するディレクトリを生成する#
#####################################
mkdir -p $bookingdir/HBC/
mkdir -p $bookingdir/STV/
mkdir -p $bookingdir/AIR-G/
mkdir -p $bookingdir/NORTHWAVE/
mkdir -p $bookingdir/RAB/
mkdir -p $bookingdir/AFB/
mkdir -p $bookingdir/IBC/
mkdir -p $bookingdir/FMI/
mkdir -p $bookingdir/TBC/
mkdir -p $bookingdir/DATEFM/
mkdir -p $bookingdir/ABS/
mkdir -p $bookingdir/YBC/
mkdir -p $bookingdir/RFC/
mkdir -p $bookingdir/FMF/
mkdir -p $bookingdir/JOHK/
mkdir -p $bookingdir/JOHK-FM/
mkdir -p $bookingdir/TBS/
mkdir -p $bookingdir/QRR/
mkdir -p $bookingdir/LFR/
mkdir -p $bookingdir/INT/
mkdir -p $bookingdir/FMT/
mkdir -p $bookingdir/FMJ/
mkdir -p $bookingdir/JORF/
mkdir -p $bookingdir/BAYFM78/
mkdir -p $bookingdir/NACK5/
mkdir -p $bookingdir/YFM/
mkdir -p $bookingdir/IBS/
mkdir -p $bookingdir/CRT/
mkdir -p $bookingdir/RADIOBERRY/
mkdir -p $bookingdir/FMGUNMA/
mkdir -p $bookingdir/JOAK/
mkdir -p $bookingdir/JOAB/
mkdir -p $bookingdir/JOAK-FM/
mkdir -p $bookingdir/BSN/
mkdir -p $bookingdir/FMNIIGATA/
mkdir -p $bookingdir/FMPORT/
mkdir -p $bookingdir/KNB/
mkdir -p $bookingdir/FMTOYAMA/
mkdir -p $bookingdir/MRO/
mkdir -p $bookingdir/HELLOFIVE/
mkdir -p $bookingdir/FBC/
mkdir -p $bookingdir/YBS/
mkdir -p $bookingdir/FM-FUJI/
mkdir -p $bookingdir/SBC/
mkdir -p $bookingdir/FMN/
mkdir -p $bookingdir/CBC/
mkdir -p $bookingdir/TOKAIRADIO/
mkdir -p $bookingdir/GBS/
mkdir -p $bookingdir/ZIP-FM/
mkdir -p $bookingdir/RADIONEO/
mkdir -p $bookingdir/FMAICHI/
mkdir -p $bookingdir/FMGIFU/
mkdir -p $bookingdir/SBS/
mkdir -p $bookingdir/K-MIX/
mkdir -p $bookingdir/FMMIE/
mkdir -p $bookingdir/ABC/
mkdir -p $bookingdir/MBS/
mkdir -p $bookingdir/OBC/
mkdir -p $bookingdir/CCL/
mkdir -p $bookingdir/802/
mkdir -p $bookingdir/FMO/
mkdir -p $bookingdir/KISSFMKOBE/
mkdir -p $bookingdir/CRK/
mkdir -p $bookingdir/E-RADIO/
mkdir -p $bookingdir/KBS/
mkdir -p $bookingdir/ALPHA-STATION/
mkdir -p $bookingdir/WBS/
mkdir -p $bookingdir/BSS/
mkdir -p $bookingdir/RSK/
mkdir -p $bookingdir/RCC/
mkdir -p $bookingdir/HFM/
mkdir -p $bookingdir/KRY/
mkdir -p $bookingdir/JRT/
mkdir -p $bookingdir/RNC/
mkdir -p $bookingdir/FMKAGAWA/
mkdir -p $bookingdir/RNB/
mkdir -p $bookingdir/JOEU-FM/
mkdir -p $bookingdir/RKC/
mkdir -p $bookingdir/JOFK/
mkdir -p $bookingdir/JOFK-FM/
mkdir -p $bookingdir/JOZK/
mkdir -p $bookingdir/JOZK-FM/
mkdir -p $bookingdir/RKB/
mkdir -p $bookingdir/KBC/
mkdir -p $bookingdir/LOVEFM/
mkdir -p $bookingdir/CROSSFM/
mkdir -p $bookingdir/FMFUKUOKA/
mkdir -p $bookingdir/NBC/
mkdir -p $bookingdir/FMNAGASAKI/
mkdir -p $bookingdir/RKK/
mkdir -p $bookingdir/FMK/
mkdir -p $bookingdir/OBS/
mkdir -p $bookingdir/FM_OITA/
mkdir -p $bookingdir/MRT/
mkdir -p $bookingdir/MBC/
mkdir -p $bookingdir/MYUFM/
mkdir -p $bookingdir/RBC/
mkdir -p $bookingdir/ROK/
mkdir -p $bookingdir/FM_OKINAWA/
mkdir -p $bookingdir/JOLK/
mkdir -p $bookingdir/JOLK-FM/
mkdir -p $bookingdir/RN1/
mkdir -p $bookingdir/RN2/
mkdir -p $bookingdir/HOUSOU-DAIGAKU/




if [ -z "$location" -o -z "$station" -o -z "$program" ]; then
    echo 'The first argument must be station-code ("NBC" etc.)'
    echo 'The second argument must be location ("Nagasaki" etc.)'
    echo 'The last argument must be a fully qualified program name ("じげらナイト　キャンラジ" etc.)'
    exit 1
fi


#番組表を取得する
wget -q -O "$station.xml" http://radiko.jp/v3/program/station/weekly/$station.xml
if [ $? -ne 0 ]; then
    echo 'Failed to get the program list (XML file). Maybe inputting error of station code.'
    rm $station.xml
    exit 2
fi

#番組表に番組名がマッチするか(マッチ数が1以上か)を判定し、マッチしなければ条件分岐で即終了
matchflg=1
case "$pattern" in
  1 )  grep -c "<title>$program.*</title>" $station.xml>/dev/null && matchflg=0 ;;
  2 )  grep -c "<title>.*$program</title>" $station.xml>/dev/null && matchflg=0 ;;
  3 )  grep -c "<title>.*$program.*</title>" $station.xml>/dev/null && matchflg=0 ;;
  4 )  grep -c "<title>$program</title>" $station.xml>/dev/null && matchflg=0 ;;
  * )  echo "One of 4 search patterns must be specified." && exit 4 ;;
esac
[ $matchflg -eq 0 ] || ( echo "The specified program was not found." && exit 3 )

cnt=0 #未来の番組のマッチ数

#マッチした番組名の次回放送日時を取得する
case "$pattern" in
  1 )  weeks=$(grep -B 1 "<title>$program.*</title>" $station.xml | grep -oP '(?<= ft=\")\d+(?=\")' | cut -b 1-12 ) ;;
  2 )  weeks=$(grep -B 1 "<title>.*$program</title>" $station.xml | grep -oP '(?<= ft=\")\d+(?=\")' | cut -b 1-12 ) ;;
  3 )  weeks=$(grep -B 1 "<title>.*$program.*</title>" $station.xml | grep -oP '(?<= ft=\")\d+(?=\")' | cut -b 1-12 ) ;;
  4 )  weeks=$(grep -B 1 "<title>$program</title>" $station.xml | grep -oP '(?<= ft=\")\d+(?=\")' | cut -b 1-12 ) ;;
esac

while read line
do
 if [[ $line -gt $(date '+%Y%m%d%H%M') ]]; then
    next_date=$line

#まだ番組表に未来の時刻が見つからない場合は終了する
if [ -z "$next_date" ]; then
    echo "The program available was not found. Perhaps the program is not listed still now." && exit 2
fi


#次回の放送日時を基に放送時間を取得する(秒単位から分単位に変換する)
duration=$(( $(grep "ft=\"$next_date" $station.xml | grep -oP '(?<= dur=\")\d+(?=\")') / 60 ))

#番組表からスペース除去
program=$(echo "$program" | sed -e 's/ *//g' -e 's/　*//g')

#予約票の作成(予約票は作りだされるスクリプトファイル)
mkdir -p $bookingdir/$station
cat <<BOOKING > $bookingdir/$station/$next_date && \
chmod +x $bookingdir/$station/$next_date && \
cnt=$((cnt + 1))
#!/bin/bash
#この行からBOOKINGまでの間が予約票の中身です。必要であれば他のスクリプトを実行する記述などを加えることができます。基本的に変更する必要はありません。

$radirecodir -s $station -l $location -t $duration -p '$program'
 
BOOKING

else
  next_date=''
  continue
fi
done <<END
$weeks
END

rm $station.xml

[[ $cnt -gt 0 ]] || echo 'The futuristc program available was not found!'

exit 0

