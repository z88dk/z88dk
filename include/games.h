#ifndef __GAMES_H__
#define __GAMES_H__

#include <sys/compiler.h>

#ifdef __TIKI100__
#include <tiki100.h>
#endif


/*
 *	Videogames support code
 *
 *	Stefano, Jan 2001
 *
 *	$Id: games.h,v 1.29 2016-11-28 07:33:11 stefano Exp $
 *
 */

/* save the sprite background in another sprite */
extern void __LIB__ bksave(int x, int y, void *sprite) __smallc;
extern void __LIB__  bkrestore(void *sprite) __z88dk_fastcall;

/* pick up a sprite directly from the screen */
extern void __LIB__ getsprite(int x, int y, void *sprite) __smallc; // This isn't still finished

/* draw a sprite of variable size */
extern void __LIB__ putsprite(int ortype, int x, int y, void *sprite) __smallc;

#define spr_and  166+47*256 // CPL - AND (HL)
#define spr_or   182 // OR (HL)
#define spr_xor  174 // XOR (HL)

#define spr_mask spr_and
#define SPR_AND  spr_and
#define SPR_OR   spr_or
#define SPR_XOR  spr_xor
#define SPR_MASK spr_and


/* Joystick (or whatever game device) control function */
extern unsigned int __LIB__  joystick(int game_device) __z88dk_fastcall;

#define MOVE_RIGHT 1
#define MOVE_LEFT  2
#define MOVE_DOWN  4
#define MOVE_UP    8
#define MOVE_FIRE  16
#define MOVE_FIRE1 MOVE_FIRE
#define MOVE_FIRE2 32
#define MOVE_FIRE3 64
#define MOVE_FIRE4 128


#ifndef MAKE_LIB

#ifdef __C128__
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN"};
	#define GAME_DEVICES 3
#endif

#ifdef __CPC__
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "QAOP-MN"};
	#define GAME_DEVICES 3
#endif

#ifdef __ENTERPRISE__
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2"};
	#define GAME_DEVICES 3
#endif

#ifdef __PC6001__
	unsigned char *joystick_type[] = { "Stick/Cursor"};
	#define GAME_DEVICES 1
#endif

#ifdef __MSX__
	unsigned char *joystick_type[] = { "Cursor", "Joystick 1", "Joystick 2"};
	#define GAME_DEVICES 3
#endif

#ifdef __MTX__
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
	#define GAME_DEVICES 2
#endif

#ifdef __BEE__
	unsigned char *joystick_type[] = {"Arrows and SPACE", "Arrows + SPACE (256TC)", "Joystick on parallel port"};
	#define GAME_DEVICES 3
#endif

#ifdef __MC1000__
	unsigned char *joystick_type[] = {"Joystick A", "Joystick B"};
	#define GAME_DEVICES 2
#endif

#ifdef __OSCA__
	unsigned char *joystick_type[] = { "Cursor", "Joystick"};
	#define GAME_DEVICES 2
#endif

#ifdef __SVI__
	unsigned char *joystick_type[] = { "Cursor", "Joystick 1", "Joystick 2"};
	#define GAME_DEVICES 3
#endif

#ifdef __SPECTRUM__
	unsigned char *joystick_type[] = {"Kempston","Sinclair 1","Sinclair 2","Cursor","Fuller"};
	#define GAME_DEVICES 5
#endif

#ifdef __ZX81__
	unsigned char *joystick_type[] = {"Kempston","ZXpand","QAOP-MN","Cursor"};
	#define GAME_DEVICES 4
#endif

#ifdef __TI82__
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef __TI83__
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef __TI85__
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef __TI86__
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef __ZXVGS__
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2", "Joystick 3"};
	#define GAME_DEVICES 4
#endif

#ifdef __Z9001__
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
	#define GAME_DEVICES 2
#endif

#ifndef GAME_DEVICES
	unsigned char *joystick_type[] = {"QAOP-MN","8246-05"};
	#define GAME_DEVICES 2
#endif

#endif

#endif
