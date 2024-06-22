# cloudflare-bypass-headless-web-scraper
[![Author](https://img.shields.io/badge/Author-@faraui-lightgreen.svg)](https://github.com/faraui)
[![License](https://img.shields.io/badge/License-ISC-lightblue.svg)](https://raw.githubusercontent.com/faraui/cloudflare-bypass-headless-web-scraper/main/LICENSE.txt)
[![Stars](https://img.shields.io/badge/Stars->100-lightyellow.svg)](https://github.com/faraui/cloudflare-bypass-headless-web-scraper/stargazers)

Headless web-scraper template that bypasses **Cloudflare** protection. Working on **X** **v**irtual **f**rame **b**uffer (**Xvfb**) and **Perl** modified **WWW::Mechanize::Chrome** module.

This modification involves neither new methods nor functions, but much of fixes and alterations, including the removal of functionality that is unnecessary for this template, such as **Windows**-specific requirements. This modified **WWW::Mechanize::Chrome** is provided here with all its dependencies, a total size of which, including **WWW::Mechanize::Chrome** itself, is less than 4.9 Mb.

The main advantage caused by this modification is the ability of `$mech->content_as_pdf(%options)` content rendering method to succesfully work even if a browser is not executed in its built-in headless mode; see [metacpan.org/pod/WWW::Mechanize::Chrome#$mech->content_as_pdf(%options)](https://metacpan.org/pod/WWW::Mechanize::Chrome#$mech-%3Econtent_as_pdf(%25options)).

The one and only inconvenience caused by this modificitation is the neglection of **Imager** module that is used to process screenshots (e.g. in `$mech->content_as_png()` method). However, **xwd** and **convert** utilities combination can be and is used in this template instead in order to achieve a comparable results.

> [!NOTE]
> If no web-pages screenshots are to be taken, **xwd** and **convert** (**ImageMagick**) may not be installed.\
> To not install these automatically, edit the `main.sh` appropriately.

As opposed to most other web-scrapers, this template does *not* require user to have a certain **WebDriver**, but only a certain **Chromium** or **Google Chrome** instance. If no such is present on a user operating system, one could be downloaded and installed automatically when `main.sh` is executed.

**WebDriver** is *not* required, since this template is working with **Chromium** or **Google Chrome** directly via **DevTools** and a local **WebSockets** connections. This solution reduces the number of dependencies.

**Perl** is in use, as it is installed on most **Linux** systems by default and it is effecient to process text with, which is essential for a parser to be written as soon as possible. In conclusion, it may be noted that this template can be succesfully executed in a **Docker** container with little to no modifications.

## Execution phases
0. Installation of yet not installed required utilities from the list: **perl5**, **Xvfb**, **xwd**, **convert**. Decompression of the external librarie archive if it is not decompressed yet.
1. Search for a compatible browser executables in the currect directory. If such are found, the prompt to use the latest version one or proceed is shown.
2. If a browser executable was not declared in the previous phase, search for a compatible browser executables that could be runt by commands. If such are found, the promt to use the latest verison one or proceed is shown.
3. If a browser executable was not declared in the previous phase, the prompt to either specify a compatible browser executable absolute path (its command) or proceed to phase 4 is shown. While the specified executable absolute path or command is non-compatible, this prompt is again shown.
4. If a browser executable was not declared in the previous phase, the prompt to download, install and use the latest **Ungoogled** **Chromium** automatically or exit to download certain compatible browser executable manually is shown.
5. The compatible browser executable specified in one of the prior phases is executed on a virtual screen.
6. The `scraper.pl` is launched and connected to this browser via local **WebSockets**.
7. During `scraper.pl` execution, https://cloudflare.com/ web-page is loaded and saved as `.pdf`.
8. A virtual screen state is saved via **xwd** and then converted to `.png` via **convert**.

## Structure
```diff
[ 1.1M] cloudflare-bypass-headless-web-scraper
!! [  753] LICENSE.txt
~~ [ 4.4K] README.md
~~ [ 1.1M] extlib.tar.bz2
++ [ 6.0K] main.sh
~~ [ 1.0K] scraper.pl
```

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
