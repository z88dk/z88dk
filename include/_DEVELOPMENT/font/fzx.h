
#ifndef _FZX_H
#define _FZX_H

// DATA STRUCTURES

struct fzx_char                     // FONT'S CHAR DESCRIPTOR
{

   uint             kern_offset;    // kern in bits 15..14, offset to bitmap from fzx_char address
   uchar            shift_width_1;  // shift in bits 7..4, width-1 in bits 3..0

};

struct fzx_font                     // FONT STRUCTURE
{

   uchar            height;         // row height in pixels
   uchar            tracking;       // horizontal gap between chars in pixels
   uchar            last_char;      // last defined char bitmap in 32..255
   struct fzx_char  bmp[0];         // begin char bitmap definitions at char code 32

};

struct fzx_cmetric                  // FONT CHARACTER METRICS
{

   uchar            kern;           // num pixels to leftshift rendered char within string, 0-3
   uchar            width;          // width of glyph, 1-16
   uchar            shift;          // num pixels to downshift rendered char from top of line, 0-15
   void            *bitmap;         // address of glyph bitmap
   
};

struct fzx_state                    // FZX STATE
{

   struct fzx_font *font;           // current font
   uchar            lm;             // left margin in pixels
   uchar            flags;          // reserved, set to 0 to reset
   uchar            x;              // current x coordinate in pixels
   uchar            y;              // current y coordinate in pixels

};

#define FZX_MODE_OR    0xb600
#define FZX_MODE_XOR   0xae00
#define FZX_MODE_RESET 0xa62f

// SCCZ80

extern uint   __LIB__               fzx_buffer_extent(void *buf, size_t len);
extern char   __LIB__              *fzx_buffer_partition(void *buf, size_t len, uint width);
extern char   __LIB__              *fzx_buffer_partition_ww(void *buf, size_t len, uint width);
extern int    __LIB__               fzx_char_metrics(struct fzx_cmetric *m, char c);
extern int    __LIB__ __FASTCALL__  fzx_mode(int mode);
extern int    __LIB__ __FASTCALL__  fzx_putc(char c);
extern int    __LIB__ __FASTCALL__  fzx_puts(char *s);
extern int    __LIB__               fzx_setat(uint y, uint x);
extern uint   __LIB__ __FASTCALL__  fzx_string_extent(char *s);
extern char   __LIB__              *fzx_string_partition(char *s, uint width);
extern char   __LIB__              *fzx_string_partition_ww(char *s, uint width);
extern int    __LIB__               fzx_write(void *buf, size_t len);

// SCCZ80 CALLEE LINKAGE

extern uint   __LIB__ __CALLEE__    fzx_buffer_extent_callee(void *buf, size_t len);
extern char   __LIB__ __CALLEE__   *fzx_buffer_partition_callee(void *buf, size_t len, uint width);
extern char   __LIB__ __CALLEE__   *fzx_buffer_partition_ww_callee(void *buf, size_t len, uint width);
extern int    __LIB__ __CALLEE__    fzx_char_metrics_callee(struct fzx_cmetric *m, char c);
extern int    __LIB__ __CALLEE__    fzx_setat_callee(uint y, uint x);
extern char   __LIB__ __CALLEE__   *fzx_string_partition_callee(char *s, uint width);
extern char   __LIB__ __CALLEE__   *fzx_string_partition_ww_callee(char *s, uint width);
extern int    __LIB__ __CALLEE__    fzx_write_callee(void *buf, size_t len);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define fzx_buffer_extent(a,b)             fzx_buffer_extent_callee(a,b)
#define fzx_buffer_partition(a,b,c)        fzx_buffer_partition_callee(a,b,c)
#define fzx_buffer_partition_ww(a,b,c)     fzx_buffer_partition_ww_callee(a,b,c)
#define fzx_char_metrics(a,b)              fzx_char_metrics_callee(a,b)
#define fzx_setat(a,b)                     fzx_setat_callee(a,b)
#define fzx_string_partition(a,b)          fzx_string_partition_callee(a,b)
#define fzx_string_partition_ww(a,b)       fzx_string_partition_callee(a,b)
#define fzx_write(a,b)                     fzx_write_callee(a,b)

// FZX FONTS BY ANDREW OWEN

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

#endif
