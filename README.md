# cloudflare-bypass-headless-web-scraper
[![Author](https://img.shields.io/badge/Author-@faraui-lightgreen.svg)](https://github.com/faraui)
[![License](https://img.shields.io/badge/License-ISC-lightblue.svg)](https://raw.githubusercontent.com/faraui/cloudflare-bypass-headless-web-scraper/main/LICENSE.txt)
[![Stars](https://img.shields.io/badge/Stars->100-lightyellow.svg)](https://github.com/faraui/cloudflare-bypass-headless-web-scraper/stargazers)

Headless web-scraper template that bypasses **Cloudflare** protection. Working on **X** **v**irtual **f**rame **b**uffer (**Xvfb**) and **Perl** module **WWW::Mechanize::Chrome**, modified to not implement methods with **macOS**- or **Windows**-specific requirements. This modified **WWW::Mechanize::Chrome** is provided here with all its dependencies and requirements, a total size of which, including **WWW::Mechanize::Chrome**, is less than `4.9 Mb`.

The one and only inconvenience caused by this modificitation is the neglection of **Imager::File::PNG** module that is used to process web-page screenshots. However, **xwd** and **convert** utilities combination can be and is used in this template instead in order to achieve a comparable results.

> [!NOTE]
> If no web-pages screenshots are to be taken, **xwd** and **convert** (**ImageMagick**) may not be installed.\
> To not install these automatically, edit the `main.sh` appropriately.

As opposed to most other web-scrapers, this template does *not* require user to have a certain **WebDriver**, but only a certain **Google Chrome** or **Chromium** instance. If no such is present on a user operating system, one could be downloaded and installed automatically when `main.sh` is executed.

**WebDriver** is *not* required, since this template is working with **Google Chrome** or **Chromium** directly via **DevTools** and a local **WebSockets** connections. Such solution reduces the number of dependencies.

**Perl** is in use, as it is installed on most **Linux** systems by default and it is effecient to process text with, which is essential for a parser to be written as soon as possible. In conclusion, it may be noted that this template can be succesfully executed in a **Docker** container with little to no modifications.

## Execution phases
0. Installation of yet not installed required utilities from the list: `perl5`, `Xvfb`, `xwd`, `convert`.
1. Decompression of the external librarie archive if it is not decompressed yet.
2. Search for a compatible browser executable from the currect directory and then from the commands.
3. For these found executables, the prompt to use one from the current directory and the latest version one from the commands is shown.
4. If no executables found or user chose to use none of them, the prompt to specify the absolute path of the compatible browser executable or its command is shown.
5. While user specifies non-compatible executable or command, the latter prompt is again shown.
6. If user chose to not specify the absolute path of the compatible browser executable or its command, the prompt to download, install and use the latest **Ungoogled** **Chromium** automatically or exit to download certain compatible browser executable manually is shown.
7. The compatible browser executable specified in one of the prior phases is executed on a virtual screen.
8. The `scraper.pl` is launched and connected to such browser being executed via local **WebSockets**.
9. A virtual screen state is saved via **xwd** and then converted to `.png` via **convert**.

## Installation
```bash
git clone https://github.com/faraui/cloudflare-bypass-headless-web-scraper.git
cd cloudflare-bypass-headless-web-scraper
chmod ugo+x main.sh
```

## Launch
```bash
./main.sh
```
