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
0. Installation of yet not installed required utilities from the list: **perl5**, **Xvfb**, **xwd**, **convert**.
1. Decompression of the external librarie archive if it is not decompressed yet.
2. Search for a compatible browser executables in the currect directory.
3. If such is found, the prompt to use the latest version one or proceed is shown.
4. Search for a compatible browser executables that could be runt by commands.
5. If such is found, the promt tp use the latest verison one or proceed is shown.
6. The prompt to specify the absolute path of the compatible browser executable (or its command) or proceed is shown.
7. While user specifies non-compatible executable or command, the latter prompt is again shown.
8. The prompt to download, install and use the latest **Ungoogled** **Chromium** automatically or exit to download certain compatible browser executable manually is shown.
9. The compatible browser executable specified in one of the prior phases is executed on a virtual screen.
10. The `scraper.pl` is launched and connected to this browser via local **WebSockets**.
11. During `scraper.pl` execution, https://cloudflare.com/ web-page is loaded and saved as `.pdf`.
12. A virtual screen state is saved via **xwd** and then converted to `.png` via **convert**.

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
