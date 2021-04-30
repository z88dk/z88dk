/*
 * Headerfile for Amstrad CPC specific functions
 *
 * $Id: cpc.h - fall 2107 - $
 */

#ifndef __CPC_H__
#define __CPC_H__

#include <sys/compiler.h>
#include <sys/types.h>

///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

// FDC detection (0-none, 1-Amstrad, 2-Vortex)
extern int  __LIB__ cpc_fdc(void);

// CPC model detection (0-464, 1-664, 2-6128)
extern int  __LIB__ cpc_model(void);


///////////////////////////////////////////
// KEYBOARD FUNCTIONS
///////////////////////////////////////////

extern char  __LIB__  cpc_AnyKeyPressed(void);
extern char  __LIB__  cpc_TestKey(int key)  __z88dk_fastcall;
extern char  __LIB__  cpc_TestKeyF(int key)  __z88dk_fastcall;
extern void  __LIB__  cpc_DeleteKeys(void);
extern char  __LIB__  cpc_RedefineKey(int key)  __z88dk_fastcall;
extern void  __LIB__  cpc_ScanKeyboard(void);

extern void __LIB__              cpc_AssignKey(int key, int value) __smallc ;
extern void __LIB__    cpc_AssignKey_callee(int key, int value)  __smallc __z88dk_callee;
#define cpc_AssignKey(a,b) cpc_AssignKey_callee(a,b)

///////////////////////////////////////////
// VIDEO RELATED FUNCTIONS
///////////////////////////////////////////

// Set video mode via Firmware
extern int __LIB__  cpc_setmode(int) __z88dk_fastcall;
extern int __LIB__  cpc_SetModo(int) __z88dk_fastcall;

// Switch video mode directly
extern int __LIB__  cpc_SetMode(int) __z88dk_fastcall;

// Set CPC color for a specified pen (set color in a palette element)
extern void __LIB__              cpc_set_palette(int pen, int color) __smallc ;
extern void __LIB__    cpc_set_palette_callee(int pen, int color)  __smallc __z88dk_callee;
extern void __LIB__              cpc_SetInk(int pen, int color) __smallc ;
extern void __LIB__    cpc_SetInk_callee(int pen, int color)  __smallc __z88dk_callee;
#define cpc_SetInk(a,b) cpc_SetInk_callee(a,b)
#define cpc_set_palette(a,b) cpc_set_palette_callee(a,b)

// Set CPC color
extern void __LIB__              cpc_SetColour(int pos, int color) __smallc ;
extern void __LIB__    cpc_SetColour_callee(int pos, int color)  __smallc __z88dk_callee;
#define cpc_SetColour(a,b) cpc_SetColour_callee(a,b)

// Set Border Color
extern void  __LIB__  cpc_SetBorder(int color) __z88dk_fastcall;


extern unsigned int __LIB__              cpc_GetScrAddress(int x, int y) __smallc ;
extern unsigned int __LIB__    cpc_GetScrAddress_callee(int x, int y)  __smallc __z88dk_callee;
#define cpc_GetScrAddress(a,b) cpc_GetScrAddress_callee(a,b)



// Print to direct screen address  (fully coloured font)
extern void __LIB__              cpc_PrintGphStr(char *text, unsigned int address) __smallc ;
extern void __LIB__    cpc_PrintGphStr_callee(char *text, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStr(a,b) cpc_PrintGphStr_callee(a,b)

// Print to direct screen address, specify pen color
extern void __LIB__              cpc_PrintGphStrStd(int pen, char *text, unsigned int address) __smallc ;
extern void __LIB__    cpc_PrintGphStrStd_callee(int pen, char *text, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStrStd(a,b,c) cpc_PrintGphStrStd_callee(a,b,c)

// Print to direct screen address (mode 1)
extern void __LIB__              cpc_PrintGphStrM1(char *text, unsigned int address) __smallc ;
extern void __LIB__    cpc_PrintGphStrM1_callee(char *text, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStrM1(a,b) cpc_PrintGphStrM1_callee(a,b)



// Print to direct screen address, double height (fully coloured font)
extern void __LIB__              cpc_PrintGphStr2X(char *text, unsigned int address) __smallc ;
extern void __LIB__    cpc_PrintGphStr2X_callee(char *text, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStr2X(a,b) cpc_PrintGphStr2X_callee(a,b)

// Print to direct screen address, double height (mode 1)
extern void __LIB__              cpc_PrintGphStrM12X(char *text, unsigned int address) __smallc ;
extern void __LIB__    cpc_PrintGphStrM12X_callee(char *text, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStrM12X(a,b) cpc_PrintGphStrM12X_callee(a,b)



// Print at x,y  (fully coloured font)
extern void __LIB__              cpc_PrintGphStrXY(char *text, int x, int y) __smallc ;
extern void __LIB__    cpc_PrintGphStrXY_callee(char *text, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrXY(a,b,c) cpc_PrintGphStrXY_callee(a,b,c)

// Print at x,y in double height (for fully coloured font)
extern void __LIB__              cpc_PrintGphStrXY2X(char *text, int x, int y) __smallc ;
extern void __LIB__    cpc_PrintGphStrXY2X_callee(char *text, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrXY2X(a,b,c) cpc_PrintGphStrXY2X_callee(a,b,c)

// Print at x,y, specify pen color
extern void __LIB__              cpc_PrintGphStrStdXY(int pen, char *text, int x, int y) __smallc ;
extern void __LIB__    cpc_PrintGphStrStdXY_callee(int pen, char *text, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrStdXY(a,b,c,d) cpc_PrintGphStrStdXY_callee(a,b,c,d)

// Print at x,y (mode 1)
extern void __LIB__              cpc_PrintGphStrXYM1(char *text, int x, int y) __smallc ;
extern void __LIB__    cpc_PrintGphStrXYM1_callee(char *text, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrXYM1(a,b,c) cpc_PrintGphStrXYM1_callee(a,b,c)

// Print at x,y (mode 1)
extern void __LIB__              cpc_PrintGphStrXYM12X(char *text, int x, int y) __smallc ;
extern void __LIB__    cpc_PrintGphStrXYM12X_callee(char *text, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrXYM12X(a,b,c) cpc_PrintGphStrXYM12X_callee(a,b,c)



// Set font colors (for fully coloured font)
extern void __LIB__              cpc_SetInkGphStr(int color, int valor) __smallc ;
extern void __LIB__    cpc_SetInkGphStr_callee(int color, int valor)  __smallc __z88dk_callee;
#define cpc_SetInkGphStr(a,b) cpc_SetInkGphStr_callee(a,b)

// Set font colors (for mode 1 font)
extern void __LIB__              cpc_SetInkGphStrM1(int color, int valor) __smallc ;
extern void __LIB__    cpc_SetInkGphStrM1_callee(int color, int valor)  __smallc __z88dk_callee;
#define cpc_SetInkGphStrM1(a,b) cpc_SetInkGphStrM1_callee(a,b)

// Rotate left region
extern void __LIB__              cpc_RLI(unsigned int pos, int w, int h) __smallc ;
extern void __LIB__    cpc_RLI_callee(unsigned int pos, int w, int h)  __smallc __z88dk_callee;
#define cpc_RLI(a,b,c) cpc_RLI_callee(a,b,c)

// Rotate left region
extern void __LIB__              cpc_RRI(unsigned int pos, int w, int h) __smallc ;
extern void __LIB__    cpc_RRI_callee(unsigned int pos, int w, int h)  __smallc __z88dk_callee;
#define cpc_RRI(a,b,c) cpc_RRI_callee(a,b,c)

// Clear Screen
extern void   __LIB__   	cpc_ClrScr(void);

// Print String using firmware
extern char  __LIB__  cpc_PrintStr(char *text)  __z88dk_fastcall;


///////////////////////////////////////////
// SPRITES
///////////////////////////////////////////

extern void __LIB__              cpc_PutSp(char *sprite, int height, int width, unsigned int address) __smallc ;
extern void __LIB__    cpc_PutSp_callee(char *sprite, int height, int width, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PutSp(a,b,c,d) cpc_PutSp_callee(a,b,c,d)

extern void __LIB__              cpc_PutSpXOR(char *sprite, int height, int width, unsigned int address) __smallc ;
extern void __LIB__    cpc_PutSpXOR_callee(char *sprite, int height, int width, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PutSpXOR(a,b,c,d) cpc_PutSpXOR_callee(a,b,c,d)

extern void __LIB__              cpc_PutSpTr(char *sprite, int height, int width, unsigned int address) __smallc ;
extern void __LIB__    cpc_PutSpTr_callee(char *sprite, int height, int width, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PutSpTr(a,b,c,d) cpc_PutSpTr_callee(a,b,c,d)

extern void __LIB__              cpc_PutMaskSp(char *sprite, int height, int width, unsigned int address) __smallc ;
extern void __LIB__    cpc_PutMaskSp_callee(char *sprite, int height, int width, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PutMaskSp(a,b,c,d) cpc_PutMaskSp_callee(a,b,c,d)

extern void __LIB__              cpc_GetSp(char *sprite, int height, int width, unsigned int address) __smallc ;
extern void __LIB__    cpc_GetSp_callee(char *sprite, int height, int width, unsigned int address)  __smallc __z88dk_callee;
#define cpc_GetSp(a,b,c,d) cpc_GetSp_callee(a,b,c,d)


/*
// minimun sprite structure
struct sprite {
	int sp0;		//2 bytes 	01
	int sp1;		//2 bytes	23
	int coord0;		//2 bytes	45	current superbuffer address
	int coord1;		//2 bytes	67  old superbuffer address		
	unsigned char cx, cy;	//2 bytes 89 	current coordinates 
	unsigned char ox, oy;	//2 bytes 1011  old coordinates 
	unsigned char move1;	
	unsigned char move;		// 	.. to know the movement direction of the sprite
};

// Set Sprite position
extern void __LIB__              cpc_SpUpdX(struct sprite *sprite, int x) __smallc ;
extern void __LIB__    cpc_SpUpdX_callee(struct sprite *sprite, int x)  __smallc __z88dk_callee;
#define cpc_SpUpdX(a,b) cpc_SpUpdX_callee(a,b)
extern void __LIB__              cpc_SpUpdY(struct sprite *sprite, int y) __smallc ;
extern void __LIB__    cpc_SpUpdY_callee(struct sprite *sprite, int y)  __smallc __z88dk_callee;
#define cpc_SpUpdY(a,b) cpc_SpUpdY_callee(a,b)

// Tiles
extern char  __LIB__   cpc_PutSpTileMap(struct sprite *sprite) __z88dk_fastcall;
extern char  __LIB__   cpc_PutMaskSpriteTileMap2b(struct sprite *sprite) __z88dk_fastcall;
#define cpc_PutMaskSpTileMap2b(a) cpc_PutMaskSpriteTileMap2b(a)
extern void  __LIB__   cpc_UpdateTileMap(int spritelist) __z88dk_fastcall;
extern void  __LIB__   cpc_ShowTileMap(int x) __z88dk_fastcall;
extern void  __LIB__   cpc_ShowTileMap2(void);
extern void  __LIB__   cpc_ResetTouchedTiles(void);
extern void  __LIB__   cpc_ShowTouchedTiles(void);

extern void __LIB__              cpc_SetTile(int x, int y, int byte) __smallc ;
extern void __LIB__    cpc_SetTile_callee(int x, int y, int byte)  __smallc __z88dk_callee;
#define cpc_SetTile(a,b,c) cpc_SetTile_callee(a,b,c)

extern void __LIB__              cpc_PutTiles(int x, int y, int w, int h, char *buffer) __smallc ;
extern void __LIB__    cpc_PutTiles_callee(int x, int y, int w, int h, char *buffer)  __smallc __z88dk_callee;
#define cpc_PutTiles(a,b,c,d,e) cpc_PutTiles_callee(a,b,c,d,e)

extern void __LIB__              cpc_GetTiles(int x, int y, int w, int h, char *buffer) __smallc ;
extern void __LIB__    cpc_GetTiles_callee(int x, int y, int w, int h, char *buffer)  __smallc __z88dk_callee;
#define cpc_GetTiles(a,b,c,d,e) cpc_GetTiles_callee(a,b,c,d,e)

extern void  __LIB__   cpc_SuperbufferAddress(struct sprite *sprite) __z88dk_fastcall;

// Test if there is collision between 2 sprites
extern void __LIB__              cpc_CollSp(struct sprite *sprite1, struct sprite *sprite2) __smallc ;
extern void __LIB__    cpc_CollSp_callee(struct sprite *sprite1, struct sprite *sprite2)  __smallc __z88dk_callee;
#define cpc_CollSp(a,b) cpc_CollSp_callee(a,b)

// Update Screen
extern void  __LIB__		cpc_UpdScr(void);
*/


///////////////////////////////////////////
// MISC FUNCTIONS
///////////////////////////////////////////

// (old way) Enable/Disable firmware: forcefully modify interrupts to jump to nothing
extern void   __LIB__   	cpc_DisableFirmware(void);
extern void   __LIB__   	cpc_EnableFirmware(void);

// Tiny ROM based console gets implementation
extern int __LIB__ cpc_gets(char *s);

// Copies a string to a CPC RSX compatible one
extern char __LIB__  *cpc_rsx_str(char *str) __z88dk_fastcall;    // (malloc lib is required)

extern char __LIB__              *cpc_rsx_strcpy(char *, char *) __smallc ;
extern char __LIB__    *cpc_rsx_strcpy_callee(char *, char *)  __smallc __z88dk_callee;
#define cpc_rsx_strcpy(a,b) cpc_rsx_strcpy_callee(a,b)

// Data decompression, PUcrunch format
extern void __LIB__              cpc_Uncrunch(void *src, void *dest) __smallc ;
extern void __LIB__    cpc_Uncrunch_callee(void *, void *)  __smallc __z88dk_callee;
#define cpc_Uncrunch(a,b) cpc_Uncrunch_callee(a,b)

// Data decompression, Exomizer 2 format
extern void __LIB__              cpc_UnExo(void *src, void *dest) __smallc ;
extern void __LIB__    cpc_UnExo_callee(void *, void *)  __smallc __z88dk_callee;
#define cpc_UnExo(a,b) cpc_UnExo_callee(a,b)

// Call RSX/Bar command
extern int __LIB__ cpc_rsx(char *cmd,...);

// RSX return error codes
#define RSX_NOT_FOUND	-1

#define RSX_NOT_OPEN	0x0E	// file not open as expected
#define RSX_HARD_EOF	0x0F	// hard end of file
#define RSX_SOFT_EOF	0x1A	// soft end of file
#define RSX_BAD_CMD	0x10	// bad command, usually wrong filename
#define RSX_FILE_EXIST	0x11	// file already exists
#define RSX_FILE_NOT_FOUND	0x12	// file doesn't exist
#define RSX_DIR_FULL	0x13	// directory is full
#define RSX_DISK_FULL	0x14	// disc is full
#define RSX_DISK_CHANGE	0x15	// disk has been changed with files open on it
#define RSX_READ_ONLY	0x16	// file is read-only

// RSX bitwise coded return error codes
#define RSX_HARD_ERR	64
#define RSX_HE_CRC	32	// data error - CRC err. on data or ID field
#define RSX_HE_OVERRUN	16	// overrun error
#define RSX_HE_NOTREADY	8	// drive not ready - no disk in drive
#define RSX_HE_NOSECTOR	4	// no data - can't find sector
#define RSX_HE_WPROTECT	2	// not writable - wr protected
#define RSX_HE_NOMARK	1	// address mark missing


// Hide/Show BIOS error messages
extern void  __LIB__  bios_msg(int flag) __z88dk_fastcall;

#define MSG_ENABLE	0
#define MSG_DISABLE	255

#endif
