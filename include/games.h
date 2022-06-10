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
 *	$Id: games.h $
 *
 */

/* save the sprite background in another sprite (the 'background' struct and its size is target dependent) */
extern void __LIB__ bksave(int x, int y, void *background) __smallc;
extern void __LIB__  bkrestore(void *background) __z88dk_fastcall;

/* pick up a sprite directly from the screen  (not yet working with coordinates > 255) */
extern void __LIB__ getsprite(int x, int y, void *sprite) __smallc;

/* draw a sprite of variable size */
extern void __LIB__ putsprite(int ortype, int x, int y, void *sprite) __smallc;
extern void __LIB__ putsprite_callee(int ortype, int x, int y, void *sprite) __smallc __z88dk_callee;
#define putsprite(a,b,c,d)           putsprite_callee(a,b,c,d)

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


/* Order fo rbelow is right, left, down, up, fire, fire2, fire3, fire4 */
/* Internal keyboard joysticks that use inkey driver */
extern uint8_t __LIB__ joystick_sc(int *scan_codes) __z88dk_fastcall;
/* Takes an array of ascii codes to check for joystick (0 terminated) */
extern uint8_t __LIB__ kjoystick(uint8_t *keycodes) __z88dk_fastcall;

#define MOVE_RIGHT 1
#define MOVE_LEFT  2
#define MOVE_DOWN  4
#define MOVE_UP    8
#define MOVE_FIRE  16
#define MOVE_FIRE1 MOVE_FIRE
#define MOVE_FIRE2 32
#define MOVE_FIRE3 64
#define MOVE_FIRE4 128


extern const unsigned char *joystick_type[];

#ifdef __C128__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __CPC__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __ENTERPRISE__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __TVC__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1/internal", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __GAL__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Arrows and SPACE", "QAOP-MN"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __GAMEBOY__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joypad"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __PC6001__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __M5__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1 + Space", "QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __MSX__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Cursor", "Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __MTX__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __BEE__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Arrows and SPACE", "Arrows + SPACE (256TC)", "Joystick on parallel port"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __PENCIL2__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __COLECO__
#ifndef __BIT90__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "Joystick 2 + Keypad 1", "Joystick 2 + Keypad 2"};
#endif
	#define GAME_DEVICES 4
#endif
#endif

#ifdef __BIT90__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "QAOP-MN", "8246-05", "hjkl-sd", "Cursor", "Joystick 1", "Joystick 2", "Joystick 2 + Keypad 1", "Joystick 2 + Keypad 2"};
#endif
	#define GAME_DEVICES 8
#endif

#ifdef __HOMELAB__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __HOMELAB2__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __LASER500__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __MC1000__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick A", "Joystick B"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __MYVISION__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Cursor","1234-56"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __OSCA__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Cursor", "Joystick"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __PACMAN__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __PV1000__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __LYNX__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __RX78__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SVI__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SMS__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joypad 1", "Joypad 2" };
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __SPC1000__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1", "QAOP-MN", "8246-05", "hjkl-sd", "Cursors"};
#endif
	#define GAME_DEVICES 5
#endif

#ifdef __SC3000__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 1", "Joystick 2", "QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __SAM__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1","Joystick 2","QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __SPECTRUM__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Kempston","Sinclair 1","Sinclair 2","Cursor","Fuller","QAOP-MN"};
#endif
	#define GAME_DEVICES 6
#endif

#ifdef __PASOPIA7__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif


#ifdef __SUPER80__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __AQUARIUS__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __ALPHATRO__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __KROKHA__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __LVIV__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"HZJQ-XB", "8246-05", "Cursor"};
#endif
	#define GAME_DEVICES 3
#endif


#ifdef __ONDRA__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick", "QAOP-MN", "Cursor", "hjkl-sd"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __SMC777__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2"};
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __PMD85__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __PRIMO__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __MIKRO80__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif


#ifdef __SORCERER__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __TRS80__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __SV8000_
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick R", "Joystick L" };
#endif
	#define GAME_DEVICES 2
#endif

#ifdef __ACE__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Keys 1-5","Keys 6-0","Cursor"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __ZX81__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"kempston","zxpand","qaop-mn","cursor"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __TI82__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI83__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI85__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __TI86__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Cursor,2nd-Alpha"};
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __VECTOR06C__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif


#ifdef __VG5000__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2","AQOP-MN", "8246-05", "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 6
#endif


#ifdef __VZ200__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Keys 1-5","Keys 6-0","QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __ZXVGS__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick 0", "Joystick 1", "Joystick 2", "Joystick 3"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __Z80TVGAME__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "Joystick" };
#endif
	#define GAME_DEVICES 1
#endif

#ifdef __Z1013__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN", "8246-05"};
#endif
	#define GAME_DEVICES 4
#endif

#ifdef __Z9001__
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"Joystick 1", "Joystick 2", "QAOP-MN"};
#endif
	#define GAME_DEVICES 3
#endif

#ifdef __GL__
#ifdef GL_TARGET_GL6000
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = { "QAOP-MN", "8246-05",  "hjkl-sd", "Cursor"};
#endif
	#define GAME_DEVICES 4
#endif
#endif



#ifndef GAME_DEVICES
#ifdef DEFINE_JOYSTICK_TYPE
	const unsigned char *joystick_type[] = {"QAOP-MN","8246-05"};
#endif
	#define GAME_DEVICES 2
#endif





#endif
