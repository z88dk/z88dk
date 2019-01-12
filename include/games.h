#ifndef __GAMES_H__
#define __GAMES_H__

#include <sys/compiler.h>
#include <stdint.h>

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

/* Internal keyboard joysticks that use inkey driver */
extern uint8_t __LIB__ joystick_sc(int *scan_codes) __z88dk_fastcall;
extern uint8_t __LIB__ kjoystick(uint8_t keycodes) __z88dk_fastcall;

#define MOVE_RIGHT 1
#define MOVE_LEFT  2
#define MOVE_DOWN  4
#define MOVE_UP    8
#define MOVE_FIRE  16
#define MOVE_FIRE1 MOVE_FIRE
#define MOVE_FIRE2 32
#define MOVE_FIRE3 64
#define MOVE_FIRE4 128


extern unsigned char *joystick_type[];

#ifdef __C128__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __CPC__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __ENTERPRISE__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __GAL__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Arrows and SPACE", "5678-0"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __PC6001__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Stick/Cursor"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __M5__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 1 + Space", "QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __MSX__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Cursor", "Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __MTX__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __BEE__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Arrows and SPACE", "Arrows + SPACE (256TC)", "Joystick on parallel port"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __COLECO__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "Joystick 2 + Keypad 1", "Joystick 2 + Keypad 2"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __LASER500__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __MC1000__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick A", "Joystick B"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __OSCA__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Cursor", "Joystick"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __PV1000__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __LYNX__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __RX78__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SVI__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SPC1000__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 1", "QAOP-MN", "8246-05", "hjkl-sd", "Cursors"};
#endif
	#define GAME_DEVICES 5
#endif

#ifdef __SC3000__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SPECTRUM__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Kempston","Sinclair 1","Sinclair 2","Cursor","Fuller"};
#endif
	#define GAME_DEVICES 5
#endif

#ifdef __SUPER80__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __AQUARIUS__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __ALPHATRO__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __SORCERER__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __TRS80__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif


#ifdef __ACE__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Keys 1-5","Keys 6-0","Cursor"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __ZX81__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Kempston","ZXpand","QAOP-MN","Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __TI82__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI83__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI85__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI86__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __VG5000__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2","AQOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif


#ifdef __VZ200__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Keys 1-5","Keys 6-0","QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __ZXVGS__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2", "Joystick 3"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __Z80TVGAME__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = { "Joystick" };
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __Z9001__
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif


#ifndef GAME_DEVICES
#ifdef DEFINE_JOYSTICK_TYPE
	unsigned char *joystick_type[] = {"QAOP-MN","8246-05"};
#endif
	#define GAME_DEVICES 2
#endif


#endif
