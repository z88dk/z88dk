#ifndef GAMES_H
#define GAMES_H

/*
 *	Videogames support code
 *
 *	Stefano, Jan 2001
 *
 *	$Id: games.h,v 1.5 2001-09-07 07:45:45 stefano Exp $
 *
 */


/* save the sprite background in another sprite */
extern __LIB__ bksave(int x, int y, void *sprite);
extern __LIB__ bkrestore(void *sprite);

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
extern __LIB__ joystick(int game_device);

#define MOVE_RIGHT 1
#define MOVE_LEFT  2
#define MOVE_DOWN  4
#define MOVE_UP    8
#define MOVE_FIRE  16
#define MOVE_FIRE1 MOVE_FIRE
#define MOVE_FIRE2 32
#define MOVE_FIRE3 64
#define MOVE_FIRE4 128


#ifdef SPECTRUM
	unsigned char *joystick_type[] = {"Kempston","Sinclair 1","Sinclair 2","Cursor","Fuller"};
	#define GAME_DEVICES 5
#endif

#ifdef TI82
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef TI83
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef TI85
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifdef TI86
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
	#define GAME_DEVICES 1
#endif

#ifndef GAME_DEVICES
	unsigned char *joystick_type[] = {"QAOP-MN","8246-05"};
	#define GAME_DEVICES 2
#endif

#endif
