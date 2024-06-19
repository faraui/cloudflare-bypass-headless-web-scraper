# cloudflare-bypass-headless-web-scraper
[![Author](https://img.shields.io/badge/Author-@faraui-pink.svg)](https://github.com/faraui)
[![License](https://img.shields.io/badge/License-ISC-lightgreen.svg)](https://raw.githubusercontent.com/faraui/cloudflare-bypass-headless-web-scraper/main/LICENSE.txt)
[![Version](https://img.shields.io/badge/Version-1.0.0-lightblue.svg)](https://github.com/faraui/cloudflare-bypass-headless-web-scraper/releases/latest)
[![Stars](https://img.shields.io/badge/Stars->100-lightyellow.svg)](https://github.com/faraui/cloudflare-bypass-headless-web-scraper/stargazers)

Headless web-scraper template that bypasses Cloudflare protection. Working on **X** **v**irtual **f**rame **b**uffer (**Xvfb**) and Perl module **WWW::Mechanize::Chrome**, modified to not implement methods that require Windows- or macOS-specific Perl modules.

The one and only inconvenience caused by this modificitation is the neglection of **Imager::File::PNG** module that is used to process web-page screenshots. However, **xwd** and **convert** utilities combination can be and is used in this script instead in order to achieve a comparable results.

1. When executed, this script is initially decompressing external librarie archive.
2. Then it searches for compatible browser executable, first in the currect directory and then in the command-aliases list.
3. For each such finding, the prompt to use it for web-scraping is shown.
4. If there is no findings or user chose to use none of them, then the prompt to specify the absolute path of the compatible browser executable or its command-alias is shown.
5. While user specifies non-compatible executable or command-alias, the latter prompt is again shown.
6. If user chose to not specify the absolute path of the compatible browser executable or its command-alias, then the prompt to download and install the latest Ungoogled Chromium automatically or exit is shown.
7. 

## Installation
```bash
git clone https://github.com/faraui/cloudflare-bypass-headless-web-scraper.git
cd cloudflare-bypass-headless-web-scraper
chmod ugo+x main.sh
```

