
#ifndef _FONT_FZX_H
#define _FONT_FZX_H

#include <stddef.h>
#include <stdint.h>

// DATA STRUCTURES

struct fzx_char                     // FONT'S CHAR DESCRIPTOR
{

   uint16_t             kern_offset;    // kern in bits 15..14, offset to bitmap from fzx_char address
   uint8_t              shift_width_1;  // shift in bits 7..4, width-1 in bits 3..0

};

struct fzx_font                     // FONT STRUCTURE
{

   uint8_t              height;         // row height in pixels
   uint8_t              tracking;       // horizontal gap between chars in pixels
   uint8_t              last_char;      // last defined char bitmap, in 32..255

};

// FZX_FONT_BITMAP returns a struct_fzx_char array for the font that is indexed by ascii code
// fzx fonts only define bitmaps for ascii codes >= 32 and up to some maximum code defined in the font structure

#define FZX_FONT_BITMAP(font) ((struct fzx_char *)((char *)(font) + sizeof(struct fzx_font) - sizeof(struct fzx_char)*32))

struct fzx_cmetric                  // FONT CHARACTER METRICS
{

   uint8_t              kern;           // num pixels to leftshift rendered char within string, 0-3
   uint8_t              width;          // width of glyph, 1-16
   uint8_t              shift;          // num pixels to downshift rendered char from top of line, 0-15
   void                *bitmap;         // address of glyph bitmap
   
};

struct fzx_state                    // FZX STATE
{

   struct fzx_font     *font;           // current font
   uint8_t              lm;             // left margin in pixels
   uint8_t              flags;          // reserved, set to 0 to reset
   uint8_t              x;              // current x coordinate in pixels
   uint8_t              y;              // current y coordinate in pixels

};

extern struct fzx_state fzx;

#define FZX_MODE_OR    0xb600
#define FZX_MODE_XOR   0xae00
#define FZX_MODE_RESET 0xa62f

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern uint16_t   fzx_buffer_extent(void *buf, size_t len);
extern char      *fzx_buffer_partition(void *buf, size_t len, uint16_t width);
extern char      *fzx_buffer_partition_ww(void *buf, size_t len, uint16_t width);
extern int        fzx_char_metrics(struct fzx_cmetric *m, char c);
extern int        fzx_mode(int mode);
extern int        fzx_putc(char c);
extern int        fzx_puts(char *s);
extern int        fzx_setat(uint16_t y, uint16_t x);
extern uint16_t   fzx_string_extent(char *s);
extern char      *fzx_string_partition(char *s, uint16_t width);
extern char      *fzx_string_partition_ww(char *s, uint16_t width);
extern int        fzx_write(void *buf, size_t len);

#else

// SCCZ80

extern uint16_t   __LIB__               fzx_buffer_extent(void *buf, size_t len);
extern char       __LIB__              *fzx_buffer_partition(void *buf, size_t len, uint16_t width);
extern char       __LIB__              *fzx_buffer_partition_ww(void *buf, size_t len, uint16_t width);
extern int        __LIB__               fzx_char_metrics(struct fzx_cmetric *m, char c);
extern int        __LIB__ __FASTCALL__  fzx_mode(int mode);
extern int        __LIB__ __FASTCALL__  fzx_putc(char c);
extern int        __LIB__ __FASTCALL__  fzx_puts(char *s);
extern int        __LIB__               fzx_setat(uint16_t y, uint16_t x);
extern uint16_t   __LIB__ __FASTCALL__  fzx_string_extent(char *s);
extern char       __LIB__              *fzx_string_partition(char *s, uint16_t width);
extern char       __LIB__              *fzx_string_partition_ww(char *s, uint16_t width);
extern int        __LIB__               fzx_write(void *buf, size_t len);

// SCCZ80 CALLEE LINKAGE

extern uint16_t   __LIB__ __CALLEE__    fzx_buffer_extent_callee(void *buf, size_t len);
extern char       __LIB__ __CALLEE__   *fzx_buffer_partition_callee(void *buf, size_t len, uint16_t width);
extern char       __LIB__ __CALLEE__   *fzx_buffer_partition_ww_callee(void *buf, size_t len, uint16_t width);
extern int        __LIB__ __CALLEE__    fzx_char_metrics_callee(struct fzx_cmetric *m, char c);
extern int        __LIB__ __CALLEE__    fzx_setat_callee(uint16_t y, uint16_t x);
extern char       __LIB__ __CALLEE__   *fzx_string_partition_callee(char *s, uint16_t width);
extern char       __LIB__ __CALLEE__   *fzx_string_partition_ww_callee(char *s, uint16_t width);
extern int        __LIB__ __CALLEE__    fzx_write_callee(void *buf, size_t len);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define fzx_buffer_extent(a,b)             fzx_buffer_extent_callee(a,b)
#define fzx_buffer_partition(a,b,c)        fzx_buffer_partition_callee(a,b,c)
#define fzx_buffer_partition_ww(a,b,c)     fzx_buffer_partition_ww_callee(a,b,c)
#define fzx_char_metrics(a,b)              fzx_char_metrics_callee(a,b)
#define fzx_setat(a,b)                     fzx_setat_callee(a,b)
#define fzx_string_partition(a,b)          fzx_string_partition_callee(a,b)
#define fzx_string_partition_ww(a,b)       fzx_string_partition_callee(a,b)
#define fzx_write(a,b)                     fzx_write_callee(a,b)

#endif


// FZX FONTS BY ANDREW OWEN

#if __SDCC | __SDCC_IX | __SDCC_IY

extern struct fzx_font *ff_ao_Aribeth14;
extern struct fzx_font *ff_ao_Aribeth6;
extern struct fzx_font *ff_ao_Aribeth8;
extern struct fzx_font *ff_ao_Arkade;
extern struct fzx_font *ff_ao_Blackadder;
extern struct fzx_font *ff_ao_Cayeux;
extern struct fzx_font *ff_ao_Cheveron;
extern struct fzx_font *ff_ao_Chloe;
extern struct fzx_font *ff_ao_Dutch;
extern struct fzx_font *ff_ao_GenevaMonoBold;
extern struct fzx_font *ff_ao_GenevaMonoBoldItalic;
extern struct fzx_font *ff_ao_GenevaMonoCyrillic;
extern struct fzx_font *ff_ao_GenevaMonoItalic;
extern struct fzx_font *ff_ao_GenevaMonoRoman;
extern struct fzx_font *ff_ao_GenevaMonoSymbol;
extern struct fzx_font *ff_ao_Grotesk;
extern struct fzx_font *ff_ao_Hemery;
extern struct fzx_font *ff_ao_Hiroshi;
extern struct fzx_font *ff_ao_Jangeborg;
extern struct fzx_font *ff_ao_Kaitaia;
extern struct fzx_font *ff_ao_Klausjahn;
extern struct fzx_font *ff_ao_Lettera;
extern struct fzx_font *ff_ao_Napier;
extern struct fzx_font *ff_ao_Newbrand;
extern struct fzx_font *ff_ao_OldEnglish;
extern struct fzx_font *ff_ao_OpenDyslexic;
extern struct fzx_font *ff_ao_Orion;
extern struct fzx_font *ff_ao_Prefect;
extern struct fzx_font *ff_ao_Programmer;
extern struct fzx_font *ff_ao_RoundelSans;
extern struct fzx_font *ff_ao_RoundelSerif;
extern struct fzx_font *ff_ao_Sabon;
extern struct fzx_font *ff_ao_Sinclair;
extern struct fzx_font *ff_ao_SoixanteQuatre;
extern struct fzx_font *ff_ao_Soxz;
extern struct fzx_font *ff_ao_SpecDings;
extern struct fzx_font *ff_ao_Swiss;
extern struct fzx_font *ff_ao_Trader;
extern struct fzx_font *ff_ao_Twombly;
extern struct fzx_font *ff_ao_Vickers;
extern struct fzx_font *ff_ao_Videotex;
extern struct fzx_font *ff_ao_Zaibatsu;

#else

#define ff_ao_Aribeth14             ((struct fzx_font *)(_ff_ao_Aribeth14))
#define ff_ao_Aribeth6              ((struct fzx_font *)(_ff_ao_Aribeth6))
#define ff_ao_Aribeth8              ((struct fzx_font *)(_ff_ao_Aribeth8))
#define ff_ao_Arkade                ((struct fzx_font *)(_ff_ao_Arkade))
#define ff_ao_Blackadder            ((struct fzx_font *)(_ff_ao_Blackadder))
#define ff_ao_Cayeux                ((struct fzx_font *)(_ff_ao_Cayeux))
#define ff_ao_Cheveron              ((struct fzx_font *)(_ff_ao_Cheveron))
#define ff_ao_Chloe                 ((struct fzx_font *)(_ff_ao_Chloe))
#define ff_ao_Dutch                 ((struct fzx_font *)(_ff_ao_Dutch))
#define ff_ao_GenevaMonoBold        ((struct fzx_font *)(_ff_ao_GenevaMonoBold))
#define ff_ao_GenevaMonoBoldItalic  ((struct fzx_font *)(_ff_ao_GenevaMonoBoldItalic))
#define ff_ao_GenevaMonoCyrillic    ((struct fzx_font *)(_ff_ao_GenevaMonoCyrillic))
#define ff_ao_GenevaMonoItalic      ((struct fzx_font *)(_ff_ao_GenevaMonoItalic))
#define ff_ao_GenevaMonoRoman       ((struct fzx_font *)(_ff_ao_GenevaMonoRoman))
#define ff_ao_GenevaMonoSymbol      ((struct fzx_font *)(_ff_ao_GenevaMonoSymbol))
#define ff_ao_Grotesk               ((struct fzx_font *)(_ff_ao_Grotesk))
#define ff_ao_Hemery                ((struct fzx_font *)(_ff_ao_Hemery))
#define ff_ao_Hiroshi               ((struct fzx_font *)(_ff_ao_Hiroshi))
#define ff_ao_Jangeborg             ((struct fzx_font *)(_ff_ao_Jangeborg))
#define ff_ao_Kaitaia               ((struct fzx_font *)(_ff_ao_Kaitaia))
#define ff_ao_Klausjahn             ((struct fzx_font *)(_ff_ao_Klausjahn))
#define ff_ao_Lettera               ((struct fzx_font *)(_ff_ao_Lettera))
#define ff_ao_Napier                ((struct fzx_font *)(_ff_ao_Napier))
#define ff_ao_Newbrand              ((struct fzx_font *)(_ff_ao_Newbrand))
#define ff_ao_OldEnglish            ((struct fzx_font *)(_ff_ao_OldEnglish))
#define ff_ao_OpenDyslexic          ((struct fzx_font *)(_ff_ao_OpenDyslexic))
#define ff_ao_Orion                 ((struct fzx_font *)(_ff_ao_Orion))
#define ff_ao_Prefect               ((struct fzx_font *)(_ff_ao_Prefect))
#define ff_ao_Programmer            ((struct fzx_font *)(_ff_ao_Programmer))
#define ff_ao_RoundelSans           ((struct fzx_font *)(_ff_ao_RoundelSans))
#define ff_ao_RoundelSerif          ((struct fzx_font *)(_ff_ao_RoundelSerif))
#define ff_ao_Sabon                 ((struct fzx_font *)(_ff_ao_Sabon))
#define ff_ao_Sinclair              ((struct fzx_font *)(_ff_ao_Sinclair))
#define ff_ao_SoixanteQuatre        ((struct fzx_font *)(_ff_ao_SoixanteQuatre))
#define ff_ao_Soxz                  ((struct fzx_font *)(_ff_ao_Soxz))
#define ff_ao_SpecDings             ((struct fzx_font *)(_ff_ao_SpecDings))
#define ff_ao_Swiss                 ((struct fzx_font *)(_ff_ao_Swiss))
#define ff_ao_Trader                ((struct fzx_font *)(_ff_ao_Trader))
#define ff_ao_Twombly               ((struct fzx_font *)(_ff_ao_Twombly))
#define ff_ao_Vickers               ((struct fzx_font *)(_ff_ao_Vickers))
#define ff_ao_Videotex              ((struct fzx_font *)(_ff_ao_Videotex))
#define ff_ao_Zaibatsu              ((struct fzx_font *)(_ff_ao_Zaibatsu))

extern void __LIB__ _ff_ao_Aribeth14(void);
extern void __LIB__ _ff_ao_Aribeth6(void);
extern void __LIB__ _ff_ao_Aribeth8(void);
extern void __LIB__ _ff_ao_Arkade(void);
extern void __LIB__ _ff_ao_Blackadder(void);
extern void __LIB__ _ff_ao_Cayeux(void);
extern void __LIB__ _ff_ao_Cheveron(void);
extern void __LIB__ _ff_ao_Chloe(void);
extern void __LIB__ _ff_ao_Dutch(void);
extern void __LIB__ _ff_ao_GenevaMonoBold(void);
extern void __LIB__ _ff_ao_GenevaMonoBoldItalic(void);
extern void __LIB__ _ff_ao_GenevaMonoCyrillic(void);
extern void __LIB__ _ff_ao_GenevaMonoItalic(void);
extern void __LIB__ _ff_ao_GenevaMonoRoman(void);
extern void __LIB__ _ff_ao_GenevaMonoSymbol(void);
extern void __LIB__ _ff_ao_Grotesk(void);
extern void __LIB__ _ff_ao_Hemery(void);
extern void __LIB__ _ff_ao_Hiroshi(void);
extern void __LIB__ _ff_ao_Jangeborg(void);
extern void __LIB__ _ff_ao_Kaitaia(void);
extern void __LIB__ _ff_ao_Klausjahn(void);
extern void __LIB__ _ff_ao_Lettera(void);
extern void __LIB__ _ff_ao_Napier(void);
extern void __LIB__ _ff_ao_Newbrand(void);
extern void __LIB__ _ff_ao_OldEnglish(void);
extern void __LIB__ _ff_ao_OpenDyslexic(void);
extern void __LIB__ _ff_ao_Orion(void);
extern void __LIB__ _ff_ao_Prefect(void);
extern void __LIB__ _ff_ao_Programmer(void);
extern void __LIB__ _ff_ao_RoundelSans(void);
extern void __LIB__ _ff_ao_RoundelSerif(void);
extern void __LIB__ _ff_ao_Sabon(void);
extern void __LIB__ _ff_ao_Sinclair(void);
extern void __LIB__ _ff_ao_SoixanteQuatre(void);
extern void __LIB__ _ff_ao_Soxz(void);
extern void __LIB__ _ff_ao_SpecDings(void);
extern void __LIB__ _ff_ao_Swiss(void);
extern void __LIB__ _ff_ao_Trader(void);
extern void __LIB__ _ff_ao_Twombly(void);
extern void __LIB__ _ff_ao_Vickers(void);
extern void __LIB__ _ff_ao_Videotex(void);
extern void __LIB__ _ff_ao_Zaibatsu(void);

#endif


// FZX FONTS BY UTZ

#if __SDCC | __SDCC_IX | __SDCC_IY

extern struct fzx_font *ff_utz_1stGrade;
extern struct fzx_font *ff_utz_Blokz;
extern struct fzx_font *ff_utz_GridDrop0;
extern struct fzx_font *ff_utz_GridDrop1;
extern struct fzx_font *ff_utz_Handpress;
extern struct fzx_font *ff_utz_KickDrop;
extern struct fzx_font *ff_utz_Notez;
extern struct fzx_font *ff_utz_PhatKidzBRK;
extern struct fzx_font *ff_utz_Phraktur;
extern struct fzx_font *ff_utz_SkoolBrkCD;
extern struct fzx_font *ff_utz_SkoolBrkEXT;
extern struct fzx_font *ff_utz_SkoolBrkU;
extern struct fzx_font *ff_utz_ShadowFlower;
extern struct fzx_font *ff_utz_Skyscrap;
extern struct fzx_font *ff_utz_TinyTexanS;
extern struct fzx_font *ff_utz_TinyTexanXS;
extern struct fzx_font *ff_utz_TinyTexanXXS;

#else

#define ff_utz_1stGrade        ((struct fzx_font *)(_ff_utz_1stGrade))
#define ff_utz_Blokz           ((struct fzx_font *)(_ff_utz_Blokz))
#define ff_utz_GridDrop0       ((struct fzx_font *)(_ff_utz_GridDrop0))
#define ff_utz_GridDrop1       ((struct fzx_font *)(_ff_utz_GridDrop1))
#define ff_utz_Handpress       ((struct fzx_font *)(_ff_utz_Handpress))
#define ff_utz_KickDrop        ((struct fzx_font *)(_ff_utz_KickDrop))
#define ff_utz_Notez           ((struct fzx_font *)(_ff_utz_Notez))
#define ff_utz_PhatKidzBRK     ((struct fzx_font *)(_ff_utz_PhatKidzBRK))
#define ff_utz_Phraktur        ((struct fzx_font *)(_ff_utz_Phraktur))
#define ff_utz_SkoolBrkCD      ((struct fzx_font *)(_ff_utz_SkoolBrkCD))
#define ff_utz_SkoolBrkEXT     ((struct fzx_font *)(_ff_utz_SkoolBrkEXT))
#define ff_utz_SkoolBrkU       ((struct fzx_font *)(_ff_utz_SkoolBrkU))
#define ff_utz_ShadowFlower    ((struct fzx_font *)(_ff_utz_ShadowFlower))
#define ff_utz_Skyscrap        ((struct fzx_font *)(_ff_utz_Skyscrap))
#define ff_utz_TinyTexanS      ((struct fzx_font *)(_ff_utz_TinyTexanS))
#define ff_utz_TinyTexanXS     ((struct fzx_font *)(_ff_utz_TinyTexanXS))
#define ff_utz_TinyTexanXXS    ((struct fzx_font *)(_ff_utz_TinyTexanXXS))

extern void __LIB__ _ff_utz_1stGrade(void);
extern void __LIB__ _ff_utz_Blokz(void);
extern void __LIB__ _ff_utz_GridDrop0(void);
extern void __LIB__ _ff_utz_GridDrop1(void);
extern void __LIB__ _ff_utz_Handpress(void);
extern void __LIB__ _ff_utz_KickDrop(void);
extern void __LIB__ _ff_utz_Notez(void);
extern void __LIB__ _ff_utz_PhatKidzBRK(void);
extern void __LIB__ _ff_utz_Phraktur(void);
extern void __LIB__ _ff_utz_SkoolBrkCD(void);
extern void __LIB__ _ff_utz_SkoolBrkEXT(void);
extern void __LIB__ _ff_utz_SkoolBrkU(void);
extern void __LIB__ _ff_utz_ShadowFlower(void);
extern void __LIB__ _ff_utz_Skyscrap(void);
extern void __LIB__ _ff_utz_TinyTexanS(void);
extern void __LIB__ _ff_utz_TinyTexanXS(void);
extern void __LIB__ _ff_utz_TinyTexanXXS(void);

#endif

#endif
