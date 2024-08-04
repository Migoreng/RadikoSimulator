# How to install RadikoSimulator into termux on Android devices
## A tested environment
- Android 13
- Termux 0.118.1 ( 2024.06.21 updated )

## Install and set up Termux on your Android device 
You should install Termux from **F-droid**, not Google Play store because the last one doesn't work properly.
If you don't let Termux access your storage, run this command.
```bash
temux-setup-storage
```

## Install required packages
First, you run this command
```bash
apt update && apt dist-upgrade
```

and then, you execute the following commands each.
```bash
apt install curl
apt install wget
apt install perl
apt install git
apt install vlc
```

## Install RadikoSimulator from the official repository by git
```bash
git clone https://github.com/Migoreng/RadikoSimulator
```

## Modify radikoplay.sh to set it uses vlc
```
nano ~/RadikoSimulator/radikoplay.sh
```
Uncomment the line begins at vlc and comment out the one begins at fflplay.
Make change like this.
```bash
vlc ${iniplalis} 2>/dev/null
# ffplay -i ${iniplalis} 2>/dev/null
```
and then, overwrite it and exit nano.
<kbd>Ctrl</kbd> + <kbd> Shift </kbd> + <kbd> x </kbd>, and then push <kbd> y </kbd> and <kbd> Enter </kbd>.

# How to test playing any station
```bash
cd ~/RadikoSimulator
bash radikoplay.sh TBS Tokyo
```
You should be able to listen to TBS radio as long as you're in Japan.
When you want to end playing, insert "quit" and enter.

Enjoy it!
