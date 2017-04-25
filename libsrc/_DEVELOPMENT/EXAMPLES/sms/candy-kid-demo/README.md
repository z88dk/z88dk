# CandyKidDemoSMS
Candy Kid Demo for the Sega Master System 2017 Competition

###### RELEASE
Monday, 27th March 2017

###### INTRO
Candy Kid Demo is based on the retro arcade simple maze chase video game Candy Kid.
<br />
The goal was simply to port a basic demo to run on real Sega Master System hardware.

###### INSTRUCTIONS
Move joystick Up / Down / Left / Right to alternate Kid / Adi / Suz / Pro sprites.
<br />
Press button 1 to start demo and press button 2 to play random sound effects.
<br />
Note: press Pause button the real hardware should pause / resume the demo.

###### TOOLS
- Programming:	devkitSMS
- Lanugauges:	C / Z80
- Visual Studio 2008
- Graphics:		BMP2Tile
- Music:		Mod2PSG2
- Assembler:	WLA-DX
- Disassembler:	SMS Examine
- Emulators:	Fusion / Meka / Emulicious

###### SOURCE CODE
http://github.com/SteveProXNA/CandyKidDemoSMS

###### ROM HACKING
You can hack this ROM!  
Download and dump CandyKidDemo.sms into Hex Editor, e.g. HxD, and modify bytes:

- 0x0050	Steps to move Kid: 1, 2, 4, 8 pixels.
- 0x0051	Delay for enemy ghosts arm moves.
- 0x0052	Hands for enemy ghosts to toggle.
- 0x0053	Music 0=music play otherwise off.
- 0x0054	Sound	0=sound on otherwise off.
- 0x0055	Paths to test individually 1 thru 8.

###### CREDITS
Extra special thanks to: sverx for devkitSMS https://github.com/sverx/devkitSMS
<br />
Special thanks to: 
Maxim, Martin, Ville Helin, Steve Snake, Bock + Emulicious devs
<br />
Also, I "borrowed" sound effects from Baluba Balok http://bit.ly/2nnSQJG Thanks!

###### SOCIAL MEDIA
- You Tube https://youtu.be/HbtZgRN_j0Y

###### COMPANY BIO
StevePro Studios is an independent game developer that builds and publishes 80s retro arcade video games!
<br />
Founded by Steven Boland "SteveProXNA" (Jan-2007) a "one man team of one" currently based in Dublin, Ireland.

Previous Sega-based retro games published include "Candy Kid" available here:
- iOS		http://apple.co/1QcidUk
- Android	http://goo.gl/5rWsYO
- Kindle	http://amzn.to/1IQPBA4
- PC		http://amzn.to/1QiHM9d

###### CONTACT
- Blog:		http://steveproxna.blogspot.com
- Email:	steven_boland@hotmail.com
- Twitter:	[@SteveProXNA](http://twitter.com/SteveProXNA)
