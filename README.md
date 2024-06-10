# Japanese
## ラジコシミュレーター
ラジコシミュレーターは3つのスクリプトファイル(radikoreco.sh,radikoplay.sh,radikopash.sh)から構成されているものです。
これらのスクリプトはAndroidOS用のradikoアプリを純粋にシミュレートして、Bashを使用できるLinuxOSで動きます。
バージョンの異なるradikoのプロトコルごとにあるパーシャルキーが必要です。

## radikoreco.sh
ffmpegを使用して放送をリアルタイムで録音します。

### 必要なもの
* ffmpeg

## radikoplay.sh
任意の音楽再生ソフトを使用して放送をリアルタイムで再生します。

### 必要なもの
以下のいずれかが必要です。
* omxplayer (Raspberry Piを使用している場合はこれを推奨します)
* ffplay
* vlc

## radikopast.sh
wgetを使用してタイムシフト(聞き逃し配信)を保存します。

### 必要なもの
* wget

## 主な特徴
* エリアフリー

任意の47都道府県全てのエリアを指定することができます。これにより全ての放送局にアクセスすることができます。

* 広告フリー

純粋なシミュレートをするだけのスクリプトなので、広告はありません。

## general.sh
このスクリプトは指定したキーワードで番組の予約をすることができます。パラメータ(放送局コード,都道府県,番組名)を指定し、予約を作成します。クッションスクリプトは毎分実行され、実行されると予約録音を開始します。

## cussion
このスクリプトは、各予約のスクリプトのディレクトリを作成し、ディレクトリ内のスクリプトを実行します。クッションはcrontabで毎分実行されます。

## パーシャルキー
全てのバージョンで機能するものが入っています。

# その他
使用例や紹介記事のリンクです。
[Blog](http://eurekamigoreng.blog.fc2.com)
[Note](https://note.com/pax_fox/n/n944b2f50f58a)

# 使い方
## 準備
```bash
$ git clone https://github.com/Migoreng/RadikoSimulator
$ cd RadikoSimulator
```

## リアルタイム視聴
```bash
$ ./radikoplay.sh <放送局コード> <当道府県>
```

長崎エリアを指定してNBCを聴く場合
```bash
$ ./radikoplay.sh NBC Nagasaki
```

## リアルタイム録音
```bash
$ ./radikoreco.sh -s <放送局コード> -l <都道府県> -t <分> -p <録音を保存するファイル名>
```
録音を途中で停止する場合は<kbd>q</kbd> または <kbd>Ctrl</kbd> + <kbd>C</kbd>

長崎エリアを指定してNBCをリアルタイムで30分間録音し、保存するファイル名を『じげらナイトキャンラジ』とする場合
```bash
$ ./radikoreco.sh -s NBC -l Nagasaki -t 30 -p "じげらナイトキャンラジ"
```

## タイムシフト保存(聞き逃し配信を保存)
```bash
$ ./radikopast.sh -s <放送局コード> -l <都道府県> -f <放送開始日時(yyyymmddHHMMSS)> -e <放送終了日時(yyyymmddHHMMSS)> -p <録音を保存するファイル名>
```

長崎エリアを指定してNBCのタイムシフトを保存する場合。  
放送開始時刻は2018年2月3日20時30分00秒  
放送終了時刻は2018年2月3日21時00分00秒  
保存するファイル名を『じげらナイトキャンラジ』とする場合
```bash
$ ./radikopast.sh -s NBC -l Nagasaki -f 20180203203000 -e 20180203210000 -p "じげらナイトキャンラジ"
```
**注意**
5時間を超える録音の場合エラーが発生して保存に失敗する可能性がある


--- 
# English
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
[Note](https://note.com/pax_fox/n/n944b2f50f58a)
