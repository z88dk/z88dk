/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

// #define TARGET_GG
/* uncomment previous line to compile for the GameGear */

// #define MD_PAD_SUPPORT
/* uncomment previous line to add support for the Genesis/MegaDrive pad (SMS only) */

/* library initialization. you don't need to call this if you use devkitSMS crt0.rel */
void SMS_init (void);

/* VDP operative mode handling functions */
void SMS_VDPturnOnFeature (unsigned int feature) __z88dk_fastcall;
void SMS_VDPturnOffFeature (unsigned int feature)__z88dk_fastcall;
/* turns on/off a VDP feature */
/* feature can be one of the following: */

/* group 0 */
#define VDPFEATURE_EXTRAHEIGHT      0x0002
#define VDPFEATURE_SHIFTSPRITES     0x0008
#define VDPFEATURE_HIDEFIRSTCOL     0x0020
#define VDPFEATURE_LEFTCOLBLANK     0x0020     /* a better name */
#define VDPFEATURE_LOCKHSCROLL      0x0040
#define VDPFEATURE_LOCKVSCROLL      0x0080

/* group 1 */
#define VDPFEATURE_ZOOMSPRITES      0x0101
#define VDPFEATURE_USETALLSPRITES   0x0102
#define VDPFEATURE_240LINES         0x0108
#define VDPFEATURE_224LINES         0x0110
#define VDPFEATURE_FRAMEIRQ         0x0120
#define VDPFEATURE_SHOWDISPLAY      0x0140

/* (it's possible to combine (OR) them if they belong to the same group) */
/* example: VDPFEATURE_ZOOMSPRITES|VDPFEATURE_USETALLSPRITES */

/* handy macros :) */
#define SMS_displayOn()   SMS_VDPturnOnFeature(VDPFEATURE_SHOWDISPLAY)   /* turns on display */
#define SMS_displayOff()  SMS_VDPturnOffFeature(VDPFEATURE_SHOWDISPLAY)  /* turns off display */

void SMS_setBGScrollX (unsigned char scrollX) __z88dk_fastcall;
void SMS_setBGScrollY (unsigned char scrollY) __z88dk_fastcall;
void SMS_setBackdropColor (unsigned char entry) __z88dk_fastcall;
void SMS_useFirstHalfTilesforSprites (_Bool usefirsthalf) __z88dk_fastcall;
void SMS_setSpriteMode (unsigned char mode) __z88dk_fastcall;
/* modes for SMS_setSpriteMode */
#define SPRITEMODE_NORMAL         0x00
#define SPRITEMODE_TALL           0x01
#define SPRITEMODE_ZOOMED         0x02
#define SPRITEMODE_TALL_ZOOMED    0x03

/* macro for ROM bankswitching */
volatile __at (0xffff) unsigned char ROM_bank_to_be_mapped_on_slot2;
#define SMS_mapROMBank(n)       ROM_bank_to_be_mapped_on_slot2=(n)

/* macro for SRAM access */
volatile __at (0xfffc) unsigned char SRAM_bank_to_be_mapped_on_slot2;
#define SMS_enableSRAM()        SRAM_bank_to_be_mapped_on_slot2=0x08
#define SMS_enableSRAMBank(n)   SRAM_bank_to_be_mapped_on_slot2=((((n)<<2)|0x08)&0x0C)
#define SMS_disableSRAM()       SRAM_bank_to_be_mapped_on_slot2=0x00

/* SRAM access is as easy as accessing an array of char */
__at (0x8000) unsigned char SMS_SRAM[];

/* wait until next VBlank starts */
void SMS_waitForVBlank (void);

/* functions to load tiles into VRAM */
void SMS_loadTiles (void *src, unsigned int tilefrom, unsigned int size);
void SMS_loadPSGaidencompressedTiles (void *src, unsigned int tilefrom);

/* functions for the tilemap */
void SMS_loadTileMap (unsigned char x, unsigned char y, void *src, unsigned int size);
void SMS_loadSTMcompressedTileMapArea (unsigned char x, unsigned char y, unsigned char *src, unsigned char width);
void SMS_loadTileMapArea (unsigned char x, unsigned char y, void *src, unsigned char width, unsigned char height);

// turning SMS_loadSTMcompressedTileMap into a define
// void SMS_loadSTMcompressedTileMap (unsigned char x, unsigned char y, unsigned char *src);
#define SMS_loadSTMcompressedTileMap(x,y,src)     SMS_loadSTMcompressedTileMapArea(x,y,src,32)

void SMS_crt0_RST08(unsigned int addr) __z88dk_fastcall __preserves_regs(a,b,d,e,h,l,iyh,iyl);
void SMS_crt0_RST18(unsigned int tile) __z88dk_fastcall __preserves_regs(b,c,d,e,h,l,iyh,iyl);

/* function for setting tiles/moving 'cursor' */
#define SMS_setTile(tile)         SMS_crt0_RST18(tile)
#define SMS_setAddr(addr)         SMS_crt0_RST08(addr)

/* PNT define (has address and VDP flags) */
#define SMS_PNTAddress            0x7800
/* macro for turning x,y into VRAM addr */
#define XYtoADDR(x,y)             (SMS_PNTAddress|((unsigned int)(y)<<6)|((unsigned char)(x)<<1))
#define SMS_setNextTileatXY(x,y)  SMS_setAddr(XYtoADDR((x),(y)))
#define SMS_setNextTileatLoc(loc) SMS_setAddr(SMS_PNTAddress|((unsigned int)(loc)<<1))
#define SMS_setNextTileatAddr(a)  SMS_setAddr(a)
#define SMS_setTileatXY(x,y,tile) {SMS_setAddr(XYtoADDR((x),(y)));SMS_setTile(tile);}

/* handy defines for tilemaps entry */
#define TILE_FLIPPED_X            0x0200
#define TILE_FLIPPED_Y            0x0400
#define TILE_USE_SPRITE_PALETTE   0x0800
#define TILE_PRIORITY             0x1000

/* functions for sprites handling */
void SMS_initSprites (void);
signed char SMS_addSprite (unsigned char x, unsigned char y, unsigned char tile);  /* returns -1 if no more sprites are available */
signed char SMS_reserveSprite (void);
void SMS_updateSpritePosition (signed char sprite, unsigned char x, unsigned char y);
void SMS_updateSpriteImage (signed char sprite, unsigned char image);
void SMS_hideSprite (signed char sprite);
void SMS_setClippingWindow (unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1);
signed char SMS_addSpriteClipping (int x, int y, unsigned char tile);   /* returns -1 if no more sprites are available or sprite clipped */
void SMS_finalizeSprites (void);
void SMS_copySpritestoSAT (void);

/* ***************************************************************** */
/* Colors / palettes handling                                        */
/* ***************************************************************** */

/* SMS_CRAMAddress define (has address and VDP flags) */
#define SMS_CRAMAddress                    0xC000

#ifdef TARGET_GG
/* GG functions to set a color / load a palette */
void GG_setBGPaletteColor (unsigned char entry, unsigned int color);
void GG_setSpritePaletteColor (unsigned char entry, unsigned int color);
void GG_loadBGPalette (void *palette) __z88dk_fastcall;
void GG_loadSpritePalette (void *palette) __z88dk_fastcall;
#define GG_setNextBGColoratIndex(i)       SMS_setAddr(SMS_CRAMAddress|((i)<<1))
#define GG_setNextSpriteColoratIndex(i)   SMS_setAddr(SMS_CRAMAddress|0x20|((i)<<1))
// void GG_setColor (unsigned int color) __z88dk_fastcall __preserves_regs(b,c,d,e,h,l,iyh,iyl);
#define GG_setColor(color)       SMS_crt0_RST18(color)
/* GG macros for colors */
#define RGB(r,g,b)        ((r)|((g)<<4)|((b)<<8))
#define RGB8(r,g,b)       (((r)>>4)|(((g)>>4)<<4)|(((b)>>4)<<8))
#define RGBHTML(RGB24bit) (((RGB24bit)>>20)|((((RGB24bit)&0xFFFF)>>12)<<4)|((((RGB24bit)&0xFF)>>4)<<8))
#else
/* SMS functions to set a color / load a palette */
void SMS_setBGPaletteColor (unsigned char entry, unsigned char color);
void SMS_setSpritePaletteColor (unsigned char entry, unsigned char color);
void SMS_loadBGPalette (void *palette) __z88dk_fastcall;
void SMS_loadSpritePalette (void *palette) __z88dk_fastcall;
#define SMS_setNextBGColoratIndex(i)       SMS_setAddr(SMS_CRAMAddress|(i))
#define SMS_setNextSpriteColoratIndex(i)   SMS_setAddr(SMS_CRAMAddress|0x10|(i))
void SMS_setColor (unsigned char color) __z88dk_fastcall __preserves_regs(b,c,d,e,h,l,iyh,iyl);
/* SMS macros for colors */
#define RGB(r,g,b)        ((r)|((g)<<2)|((b)<<4))
#define RGB8(r,g,b)       (((r)>>6)|(((g)>>6)<<2)|(((b)>>6)<<4))
#define RGBHTML(RGB24bit) (((RGB24bit)>>22)|((((RGB24bit)&0xFFFF)>>14)<<2)|((((RGB24bit)&0xFF)>>6)<<4))
void SMS_loadBGPaletteHalfBrightness (void *palette) __z88dk_fastcall;
void SMS_loadSpritePaletteHalfBrightness (void *palette) __z88dk_fastcall;
void SMS_zeroBGPalette (void);
void SMS_zeroSpritePalette (void);
#endif

/* functions to read joypad(s) */
unsigned int SMS_getKeysStatus (void);
unsigned int SMS_getKeysPressed (void);
unsigned int SMS_getKeysHeld (void);
unsigned int SMS_getKeysReleased (void);

/* handy defines for joypad(s) handling */
#ifndef CONTROLLER_PORTS
#define CONTROLLER_PORTS
#define PORT_A_KEY_UP           0x0001
#define PORT_A_KEY_DOWN         0x0002
#define PORT_A_KEY_LEFT         0x0004
#define PORT_A_KEY_RIGHT        0x0008
#define PORT_A_KEY_1            0x0010
#define PORT_A_KEY_2            0x0020
#define PORT_A_KEY_START        PORT_A_KEY_1    /* handy alias */

#define PORT_B_KEY_UP           0x0040
#define PORT_B_KEY_DOWN         0x0080
#define PORT_B_KEY_LEFT         0x0100
#define PORT_B_KEY_RIGHT        0x0200
#define PORT_B_KEY_1            0x0400
#define PORT_B_KEY_2            0x0800
#define PORT_B_KEY_START        PORT_B_KEY_1    /* handy alias */

#define RESET_KEY               0x1000          /* (absent on SMS II) */
#define CARTRIDGE_SLOT          0x2000          /* ??? */
#define PORT_A_TH               0x4000          /* for light gun */
#define PORT_B_TH               0x8000          /* for light gun */
#endif

#ifdef TARGET_GG
#define GG_KEY_START            0x8000          /* START key on GG */
#endif

#ifdef MD_PAD_SUPPORT
/* functions to read additional MD buttons */
unsigned int SMS_getMDKeysStatus (void);
unsigned int SMS_getMDKeysPressed (void);
unsigned int SMS_getMDKeysHeld (void);
unsigned int SMS_getMDKeysReleased (void);

/* handy defines for additional MD joypad(s) handling */
#define PORT_A_MD_KEY_Z         0x0001
#define PORT_A_MD_KEY_Y         0x0002
#define PORT_A_MD_KEY_X         0x0004
#define PORT_A_MD_KEY_MODE      0x0008
#define PORT_A_MD_KEY_A         0x0010
#define PORT_A_MD_KEY_START     0x0020
/* port B still missing */
#endif

#ifndef TARGET_GG
/* pause handling (SMS only) */
_Bool SMS_queryPauseRequested (void);
void SMS_resetPauseRequest (void);
#endif

#ifndef TARGET_GG
/* VDPType handling (SMS only) */
unsigned char SMS_VDPType (void);
/* WARNING: these constants may change value later, please use defines */
#define VDP_PAL                 0x80
#define VDP_NTSC                0x40
#endif

extern volatile unsigned char SMS_VDPFlags;
#define VDPFLAG_SPRITEOVERFLOW  0x40
#define VDPFLAG_SPRITECOLLISION 0x20

/* line interrupt */
void SMS_setLineInterruptHandler (void (*theHandlerFunction)(void));
void SMS_setLineCounter (unsigned char count);
#define SMS_enableLineInterrupt()   SMS_VDPturnOnFeature(0x0010)   /* turns on line IRQ */
#define SMS_disableLineInterrupt()  SMS_VDPturnOffFeature(0x0010)  /* turns off line IRQ */

/* Vcount */
unsigned char SMS_getVCount (void);
/* Hcount */
unsigned char SMS_getHCount (void);

/* low level functions */
void SMS_VRAMmemcpy (unsigned int dst, void *src, unsigned int size);
void SMS_VRAMmemcpy_brief (unsigned int dst, void *src, unsigned char size);
void SMS_VRAMmemset (unsigned int dst, unsigned char value, unsigned int size);
void SMS_VRAMmemsetW (unsigned int dst, unsigned int value, unsigned int size);

/* VRAM unsafe functions. Fast, but dangerous! */
void UNSAFE_SMS_copySpritestoSAT (void);
void UNSAFE_SMS_VRAMmemcpy32 (unsigned int dst, void *src);
void UNSAFE_SMS_VRAMmemcpy64 (unsigned int dst, void *src);
void UNSAFE_SMS_VRAMmemcpy128 (unsigned int dst, void *src);

/* handy macros for UNSAFE_SMS_VRAMmemcpy* */
#define UNSAFE_SMS_load1Tile(src,theTile)     UNSAFE_SMS_VRAMmemcpy32((theTile)*32,(src))
#define UNSAFE_SMS_load2Tiles(src,tilefrom)   UNSAFE_SMS_VRAMmemcpy64((tilefrom)*32,(src))
#define UNSAFE_SMS_load4Tiles(src,tilefrom)   UNSAFE_SMS_VRAMmemcpy128((tilefrom)*32,(src))

/* macros for SEGA and SDSC headers */
#define SMS_BYTE_TO_BCD(n) (((n)/10)*16+((n)%10))

#ifndef TARGET_GG
/* "SMS Export" (32KB) */
#define SMS_EMBED_SEGA_ROM_HEADER_REGION_CODE  0x4C
#else
/* "GG international" (32KB) */
#define SMS_EMBED_SEGA_ROM_HEADER_REGION_CODE  0x7C
#endif

#define SMS_EMBED_SEGA_ROM_HEADER(productCode,revision)                                        \
 const __at (0x7ff0) unsigned char __SMS__SEGA_signature[16]={'T','M','R',' ','S','E','G','A', \
                                                                          0xFF,0xFF,0xFF,0xFF, \
                  SMS_BYTE_TO_BCD((productCode)%100),SMS_BYTE_TO_BCD(((productCode)/100)%100), \
           (((productCode)/10000)<<4)|((revision)&0x0f),SMS_EMBED_SEGA_ROM_HEADER_REGION_CODE}

#define SMS_EMBED_SDSC_HEADER(verMaj,verMin,dateYear,dateMonth,dateDay,author,name,descr)      \
                          const __at (0x7fe0-sizeof(author)) char __SMS__SDSC_author[]=author; \
                 const __at (0x7fe0-sizeof(author)-sizeof(name)) char __SMS__SDSC_name[]=name; \
 const __at (0x7fe0-sizeof(author)-sizeof(name)-sizeof(descr)) char __SMS__SDSC_descr[]=descr; \
                          const __at (0x7fe0) char __SMS__SDSC_signature[16]={'S','D','S','C', \
                                              SMS_BYTE_TO_BCD(verMaj),SMS_BYTE_TO_BCD(verMin), \
                                          SMS_BYTE_TO_BCD(dateDay),SMS_BYTE_TO_BCD(dateMonth), \
                              SMS_BYTE_TO_BCD((dateYear)%100),SMS_BYTE_TO_BCD((dateYear)/100), \
                                                                  (0x7fe0-sizeof(author))%256, \
                                                                   (0x7fe0-sizeof(author))>>8, \
                                                     (0x7fe0-sizeof(author)-sizeof(name))%256, \
                                                      (0x7fe0-sizeof(author)-sizeof(name))>>8, \
                                       (0x7fe0-sizeof(author)-sizeof(name)-sizeof(descr))%256, \
                                        (0x7fe0-sizeof(author)-sizeof(name)-sizeof(descr))>>8}
/* pretty nice, isn't it? :) */

/* to set SDSC header date to 0000-00-00 so that ihx2sms updates that with compilation date */
#define SMS_EMBED_SDSC_HEADER_AUTO_DATE(verMaj,verMin,author,name,descr)                       \
                        SMS_EMBED_SDSC_HEADER((verMaj),(verMin),0,0,0,(author),(name),(descr))

/* the Interrupt Service Routines (do not modify) */
void SMS_isr (void) __interrupt;
void SMS_nmi_isr (void) __critical __interrupt;

/* STILL MISSING
void SMS_VDPSetSATLocation (unsigned int location);
void SMS_VDPSetPNTLocation (unsigned int location);
void SMS_VDPSetSpritesLocation (unsigned int location);
*/
