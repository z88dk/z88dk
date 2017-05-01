# Space Hawks by KanedaFr
[Original Source](https://bitbucket.org/SpritesMind/spacehawks_sms/downloads/?tab=branches)  
[Webpage at SMS POWER](http://www.smspower.org/Homebrew/SpaceHawks-SMS)

The source code here consists of everything needed to compile the game and does not include raw binary assets that need conversion to sms-friendly formats using other tools as an intermediate step.  To see everything, visit the link above.

## Description

This game is the unofficial port of the Amstrad game to the Sega Master System.
I built it for the SMS Power! devkitSMS Coding Competition 2016.
Final ROM is 32kb, with 14kb from the assets.

It's my first try on SMS, while I develop for 15years on Genesis.
I learnt a lot on this one and fixed my bad knowledge on the VDP, thank to sverx and SMSPower members.

To build it from source, see the readme.build
Please note that I was unable to fix, for now, the glitch which occurs on some sprites while playing.
Competition deadline is coming, so I'll fix it later, I hope.

Special thanks to sverx, ichigo and Maxim

KanedaFr - October 2016

## Compiling

zsdcc compile (high optimization setting may lead to long compile time):
~~~
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject.lst -o spacehawks -pragma-include:zpragma.inc -create-app
~~~
Because this project is properly distributed across many .c files, compiles during development could be sped up using incremental compilation.
