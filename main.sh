#!/bin/bash

sudo echo -n

if ! command -v perl > /dev/null || ! command -v Xvfb > /dev/null \
|| ! command -v xwd > /dev/null || ! command -v convert > /dev/null
then if [[ "$OSTYPE" == "linux-gnu"* ]]
     then if [ -f /etc/debian_version ]
          then echo -n 'Installing requirements ...'
               ( sudo apt install -y perl Xvfb xwd ImageMagick > /dev/null 2> requirements.log && \
                 rm -rf requirements.log && \
                 echo ' OK' ) || \
               ( echo ' FAIL'
                 echo "See 'requirements.log' for details" >&2
                 exit 2 )
          elif [ -f /etc/redhat-release ]
          then echo -n 'Installing requirements ...'
               ( sudo yum install -y perl xorg-x11-server-Xvfb xwd ImageMagick > /dev/null 2> requirements.log && \
                 rm -rf requirements.log && \
                 echo ' OK' ) || \
               ( echo ' FAIL'
                 echo "See 'requirements.log' for details" >&2
                 exit 2 )
          elif [ -f /etc/arch-release ]
          then echo -n 'Installing requirements ...'
               ( sudo pacman -Sy perl xorg-server-xvfb xwd ImageMagick --noconfirm > /dev/null 2> requirements.log && \
                 rm -rf requirements.log && \
                 echo ' OK' ) || \
               ( echo ' FAIL'
                 echo "See 'requirements.log' for details" >&2
                 exit 2 )
          fi
     elif [[ "$OSTYPE" == "darwin"* ]]
     then if ! command -v brew > /dev/null
          then /bin/bash -c "$(curl -fsSL
               https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          fi
          yes | brew install perl > /dev/null
          yes | brew install XQuartz > /dev/null
          yes | brew install imagemagick > /dev/null
     fi
fi

if [ -s extlib.tar.bz2 ]
then echo -n 'Decompressing external librarie ...'
     ( tar -xjf extlib.tar.bz2 2> decompress.log && \
       rm -rf extlib.tar.bz2 decompress.log && \
       echo ' OK' ) || \
     ( echo ' FAIL'
       echo "See 'decompress.log' for details" >&2
       exit 2 )
elif [ ! -d extlib ]
then echo "Error. Neither 'extlib/' nor 'extlib.tar.bz2' is present" >&2
     exit 2
fi


LOCAL_VERSION="$(find . -type f -name 'chrome' -exec dirname {} \; | sort -V | head -1 | sed 's/\.\///')"
if [[ -n $LOCAL_VERSION ]]
then echo "Found compatible browser '$LOCAL_VERSION/chrome' in the current directory"
     read -e -p 'Should it be used in the execution? [Y/n] '
     if [[ ! $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
     then BROWSER="$LOCAL_VERSION/chrome"
     fi
else 
fi

if [[ -z $BROWSER ]]
then BROWSERS=(
       'google-chrome' 'google-chrome-stable' 'google-chrome-beta' 'google-chrome-unstable'
       'chromium' 'chromium-browser' 'chromium-freeworld' 'ungoogled-chromium'
     )

     for i in "${!BROWSERS[@]}"
     do VERSION=$("${BROWSERS[i]}" --product-version 2> /dev/null)
        if [ -z $VERSION ]
        then BROWSERS[i]="${BROWSERS[i]}:0"
        else BROWSERS[i]="${BROWSERS[i]}:$VERSION"
        fi
     done

     COMMAND_VERSION="$(echo -n "${BROWSERS[@]}" | sed 's/ /\n/g' | sort -V | head -1 | sed 's/:/ /')"
     if [[ $COMMAND_VERSION =~ ' 0'$ ]]
     then echo "Neither 'Chromium' nor 'Google Chrome' was found on your system"
     else echo "The latest compatible browser release that was found is '$COMMAND_VERSION'"
          read -e -p 'Should it be used in the execution? [Y/n] '
          if [[ ! $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
          then BROWSER="$(echo $COMMAND_VERSION | sed 's/ *//')"
          fi
     fi
fi

while [[ -z $BROWSER ]]
do read -e -p 'Specify the absolute path of the compatible browser executable or its command-alias? [Y/n] '
   if [[ $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
   then break
   else read -e -p "The command-alias or the absolute path (consider using 'realpath' or 'readlink -f'): "
        if [[ -n $($REPLY --product-version 2> /dev/null) ]]
        then BROWSER=$REPLY
        else echo -n 'Error. The specified' >&2
             if [[ $REPLY == *'/'* ]]
             then echo -n ' absolute path (command-alias)' >&2
             else echo -n ' command-alias (absolute path)' >&2
             fi
             echo ' is non-compatible' >&2
        fi
   fi
done

if [[ -z $BROWSER ]] && [[ -z $UNGOOGLED_CHROMIUM ]]
then read -e -p "Download 'Ungoogled Chromium' here [Y] or exit to install 'Chromium' or 'Google Chrome' manually [n]? "
     if [[ $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
     then exit 0
     else REMOTE_VERSION="$(
            curl -s https://ungoogled-software.github.io/ungoogled-chromium-binaries/releases/linux_portable/64bit/ \
            | grep -m 1 '><a' | sed 's/.*">//; s/<.*//'
          )"
          echo -n "Downloading 'Ungoogled Chromium $REMOTE_VERSION' for Linux 64bit ..."
          NAME="ungoogled-chromium_$(echo $REMOTE_VERSION)_linux"
          if [[ $NAME == $LOCAL_VERSION ]]
          then echo "Error. 'Ungoogled Chromium $REMOTE_VERSION' is already installed" >&2
               exit 2
          fi
          ( wget https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/$REMOTE_VERSION/$NAME.tar.xz \
                 2> download.log && \
            rm -rf download.log && \
            echo ' OK' ) || \
          ( echo ' FAIL'
            echo "See 'download.log' for details" >&2
            exit 2 )
          echo -n "Decompressing '$NAME.tar.xz' ..."
          ( tar -xf $NAME.tar.xz 2> decompress.log && \
            rm -rf $NAME.tar.xz \
                   $NAME/chrome_* \
                   $NAME/chromed* \
                   decompress.log && \
            echo ' OK' ) || \
          ( echo ' FAIL'
            echo "See 'decompress.log' for details" >&2
            exit 2 )
          BROWSER="$NAME/chrome"
     fi
fi

Xvfb :9222 &

DISPLAY=:9222 $BROWSER \
--no-sandbox \
--disable-gpu \
--disable-software-rasterizer \
--remote-debugging-port=9222 \
--remote-allow-origins=* 2> /dev/null &

perl -I "$PWD/extlib/" scraper.pl

SCREENSHOT=$(date -I)
xwd -root -display :9222 -out $SCREENSHOT.xwd
convert $SCREENSHOT.xwd $SCREENSHOT.png
rm -rf $SCREENSHOT.xwd
sudo pkill -f 'Xvfb :9222'
