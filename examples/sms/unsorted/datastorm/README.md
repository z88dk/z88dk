# Data Storm v1.00 by haroldoop
[Original Website](http://www.smspower.org/Homebrew/DataStorm-SMS)

The source code here consists of everything needed to compile the game and does not include raw binary assets that need conversion to sms-friendly formats using other tools as an intermediate step.  To see everything, visit the link above.

## Compiling

zsdcc compile (high optimization means compile times can be long):
```
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 datastorm.c gfx.c -o datastorm --fsigned-char -create-app -pragma-include:zpragma.inc
```

---
---

# Data Storm
(Original Text)


About
-----

This is a Sega Master System clone of an Atari 2600 game named [Turmoil].

I had originally made the first, unfinished, version for [SMS Power's 2012 competition][SMSPower-2012], then now, four years later, I decided to resume development on this for the [2016 competition][SMSPower-2016].

Instructions
------------

Press any button to leave the demo mode. Now take a deep breath.  You have five seconds to get ready for some of the fastest fun you've ever had.

The objective is to zoom up and down the center alley and blast aliens as they streak by.  Keep shooting and keep moving to avoid a deadly collision with a speeding alien spacecraft.

Pressing up or down on your joypad moves your ship up and down the middle alley in the screen.  Moving your joypad left and right turns your ship left and right to face, or travel, down the lanes.  Your ship is always on rapid fire.  Oodles of bullets can be on the screen at once so you can enjoy destroying more aliens, more often, than ever before!

You begin the game with five ships.  If you can blast all of the aliens in a level, you'll receive a bonus ship.  You can hold up to 6 ships at one time.  Ships are destroyed by accidentally running into passing aliens.

Data Storm features a variety of speedy aliens which travel back and forth across the screen at their own unique paces.  The faster they move, the more points they are worth.  All aliens, except for the Prizes, must be shot while your ship is in the center alley.

There are five different Enemy Ships to blast.  A collision will be deadly no matter which ship you hit:

* Arrows:  If allowed to cross the screen, Arrows turn into Tanks.
* Tanks:  These can only be destroyed from behind.  If shot head on, your bullet blasts will merely push the Tanks back a bit.
* Prizes:  When a Prize appears at the edge of the screen, you have just a few seconds to race down the lane and touch it. (If you don't get there in time, the Prize will turn into a Supersonic Cannon Ball.) After touching the Prize, you must quickly return to the center alley to avoid getting smashed by the indestructible Ghost Ship.

Tools used
----------

* [Atom] for editing the sources;
* [SDCC] for compiling the game;
* [devkitSMS] for interfacing with the Sega Master System's hardware;
* [PSGlib] for playing music and sound effects;
* [Tile Layer Pro] for editing the tileset;
* [Deflemask] for editing some of the sound effects;
* [PSGTalk] for converting some of the sound effects;
* [Emulicious] for testing the game.

[Turmoil]: https://atariage.com/software_page.php?SoftwareID=1420
[SMSPower-2012]: http://www.smspower.org/Competitions/Coding-2012
[SMSPower-2016]: http://www.smspower.org/forums/15883-Competitions2016
[Atom]: https://atom.io/
[SDCC]: http://sdcc.sourceforge.net/
[devkitSMS]: https://github.com/sverx/devkitSMS
[PSGlib]: https://github.com/sverx/PSGlib/
[Tile Layer Pro]: http://www.romhacking.net/utilities/108/
[Deflemask]: http://www.deflemask.com/
[PSGTalk]: https://github.com/furrtek/PSGTalk
[Emulicious]: http://emulicious.net/
