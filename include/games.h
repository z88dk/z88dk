#ifndef __GAMES_H__
#define __GAMES_H__

#include <sys/compiler.h>


/*
 *	Videogames support code
 *
 *	Stefano, Jan 2001
 *
 *	$Id: games.h,v 1.21 2014-12-10 07:51:31 stefano Exp $
 *
 */

/* save the sprite background in another sprite */
extern __LIB__ bksave(int x, int y, void *sprite);
extern __LIB__ __FASTCALL__ bkrestore(void *sprite);

/* pick up a sprite directly from the screen */
extern __LIB__ getsprite(int x, int y, void *sprite); // This isn't still finished

/* draw a sprite of variable size */
extern __LIB__ putsprite(int ortype, int x, int y, void *sprite);

#define spr_and  166+47*256 // CPL - AND (HL)
#define spr_or   182 // OR (HL)
#define spr_xor  174 // XOR (HL)

#define spr_mask spr_and
#define SPR_AND  spr_and
#define SPR_OR   spr_or
#define SPR_XOR  spr_xor
#define SPR_MASK spr_and


/* Joystick (or whatever game device) control function */
extern __LIB__ __FASTCALL__ joystick(int game_device);

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

#ifndef GAME_DEVICES
	unsigned char *joystick_type[] = {"QAOP-MN","8246-05"};
	#define GAME_DEVICES 2
#endif

#endif

#endif
