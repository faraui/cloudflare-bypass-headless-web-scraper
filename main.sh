#!/bin/bash

sudo echo -n

if ! command -v perl > /dev/null \
|| ! command -v Xvfb > /dev/null \
|| ! command -v xwd > /dev/null \
|| ! command -v convert > /dev/null
then if [[ "$OSTYPE" == "linux-gnu"* ]]
     then if [ -f /etc/debian_version ]
          then echo -n 'Installing requirements ...'
               sudo apt install -y perl Xvfb xwd ImageMagick > /dev/null 2> requirements.log \
               && echo ' OK' && rm -rf requirements.log \
               || echo ' FAIL' && echo "See 'requirements.log' for details" >&2 && exit 2
          elif [ -f /etc/redhat-release ]
          then echo -n 'Installing requirements ...'
               sudo yum install -y perl xorg-x11-server-Xvfb xwd ImageMagick > /dev/null \
               && echo ' OK' && rm -rf requirements.log \
               || echo ' FAIL' && echo "See 'requirements.log' for details" >&2 && exit 2
          elif [ -f /etc/arch-release ]
          then echo -n 'Installing requirements ...'
               sudo pacman -Sy perl xorg-server-xvfb xwd ImageMagick --noconfirm > /dev/null \
               && echo ' OK' && rm -rf requirements.log \
               || echo ' FAIL' && echo "See 'requirements.log' for details" >&2 && exit 2
          fi
     elif [[ "$OSTYPE" == "darwin"* ]]
     then if ! command -v brew > /dev/null
          then /bin/bash -c "$(curl -fsSL
               https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          fi
          echo 'yes' | brew install perl > /dev/null
          echo 'yes' | brew install XQuartz > /dev/null
          echo 'yes' | brew install imagemagick > /dev/null
     fi
fi

if [ -f extlib.tar.bz2 ]
then echo -n 'Decompressing external librarie ...'
     { tar -xjf extlib.tar.bz2 \
       && rm -rf extlib.tar.bz2
     } 2> decompress.log \
     && echo ' OK' && rm -rf decompress.log \
     || echo ' FAIL' \
        && echo "See 'decompress.log' for details" >&2 \
        && exit 2
elif [ ! -d extlib ]
then echo "Error. Neither 'extlib/' nor 'extlib.tar.bz2' is present" >&2
     exit 2
fi

if [ -f chrome-linux-64/chrome ]
then echo "Found compatible browser with 'chrome-linux-64/chrome' path from the current directory"
     read -e -p 'Should it be used in the execution? [Y/n] '
     if [[ ! $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
     then BROWSER='chrome-linux-64/chrome'
     fi
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

     LOCAL_VERSION="$(echo -n "${BROWSERS[@]}" | sed 's/ /\n/g' | sort -V | head -1 | sed 's/:/ /')"
     if [[ $LOCAL_VERSION =~ ' 0'$ ]]
     then echo "Neither 'Chromium' nor 'Google Chrome' was found on your system"
     else echo "The latest compatible browser release that was found is '$LOCAL_VERSION'"
          read -e -p 'Should it be used in the execution? [Y/n] '
          if [[ ! $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
          then BROWSER="$(echo $LOCAL_VERSION | sed 's/ *//')"
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


if [[ -z $BROWSER ]]
then read -e -p "Download 'Ungoogled Chromium' here [Y] or exit to install 'Chromium' or 'Google Chrome' manually [n]? "
     if [[ $REPLY =~ ^[nNmMbBтТьЬиИ] ]]
     then exit 0
     else REMOTE_VERSION="$(
            curl -s https://ungoogled-software.github.io/ungoogled-chromium-binaries/releases/linux_portable/64bit/ \
            | grep -m 1 '><a' | sed 's/.*">//; s/<.*//'
          )"
          echo -n "Downloading 'Ungoogled Chromium $REMOTE_VERSION' for Linux 64bit ..."
          FULL_NAME="ungoogled-chromium_$(echo $REMOTE_VERSION)_linux.tar.xz"
          wget -o $FULL_NAME \
          https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/$LATEST/$FULL_NAME \
          2> download.log && echo ' OK' && rm -rf download.log \
          || echo ' FAIL' && echo "See 'download.log' for details" >&2 && exit 2
          echo -n "Decompressing '$FULL_NAME' ..."
          tar -xf $FULL_NAME 2> decompress.log && echo ' OK' && rm -rf $FULL_NAME \
          || echo ' FAIL' && echo "See 'decompress.log' for details" >&2 && exit 2
          BROWSER='chrome-linux-64/chrome'
     fi
fi

Xvfb :9222 & DISPLAY=:9222 $BROWSER \
--disable-gpu --disable-software-rasterizer \
--remote-debugging-port=9222 --remote-allow-origins=* 2> /dev/null &

perl -I "$PWD/extlib/" scrape.pl

xwd -root -display :9222 -out screenshot.xwd
convert screenshot.xwd screenshot2.png
sudo pkill Xvfb
