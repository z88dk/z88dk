zcc +sms -v -O3 main.c @zproject.lst -o 3dcity -pragma-include:zpragma.inc -create-app


# 3D City
Classic 8-bit Shoot 'em up built for the Sega Master System

###### RELEASE
Sunday, 27th March 2016

###### INTRO
3D City is a simple "Shoot 'em up" video game originally programmed by StevePro Studios in New Zealand, January 1988.
The game was written using BASIC programming language built on the Sega SC-3000 [source code: http://bit.ly/1n1oEk1].

Inspired from previous posts on Sega Console Programming [http://bit.ly/1RhssZD] and the z88dk Programming Setup [http://bit.ly/25nnSzf],
3D City was the impetus to build an 8-bit video game in C / Z80 assembler for the Sega Master System.


###### INSTRUCTIONS
Simple!	Move target and shoot all enemy ships before they kill you.  4x misses and it is Game Over.
Hint: 	hold controller Button2 down while moving target slows target down for more focused attack.


###### TOOLS
- Programming:	z88dk
- Graphics:		BMP2Tile
- Music:		Mod2PSG2
- Assembler:	WLA-DX
- Disassembler:	SMS Examine
- Emulators:	Fusion + Meka


###### SOURCE CODE
http://github.com/SteveProXNA/3Dcity


###### ROM HACKING
You can hack this ROM!  
Download and dump 3Dcity.sms into Hex Editor, e.g. HxD, and modify the bytes:

- 0x00C0	Death	Non-zero = invincibility!
- 0x00C1	Level	0=easy (default)  1=hard.
- 0x00C2	Enemy	0=3x enemies else 1 or 2.
- 0x00C3	Music	0=music on otherwise off.
- 0x00C4	Sound	0=sound on otherwise off.
- 0x00C5	Tiles	0=tiles scroll yes else no.
- 0x00C6	Stars	0=stars flash yes else no.


###### CREDITS
Special thanks to: 
haroldoop, Maxim, Martin, Ville Helin, Bock + Steve Snake


###### REVIEW
- Retro Gaming Mag by Carl Williams http://bit.ly/29fdfLM


###### SOCIAL MEDIA
- You Tube https://youtu.be/bIU90DfdXIU


###### COMPANY BIO
StevePro Studios is an independent game developer that builds and publishes 80s retro arcade video games!
Founded by Steven Boland "SteveProXNA" (Jan-2007) a "one man team of one" currently based in Dublin, Ireland.

Previous Sega-based retro games published include "Candy Kid" available here:
- iOS		http://apple.co/1QcidUk
- Android	http://goo.gl/5rWsYO
- Kindle	http://amzn.to/1IQPBA4
- PC		http://amzn.to/1QiHM9d


###### CONTACT
- Blog:		http://steveproxna.blogspot.com
- Twitter:	[@SteveProXNA](http://twitter.com/SteveProXNA)
