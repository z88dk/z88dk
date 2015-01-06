
#ifndef _FONT_FZX_H
#define _FONT_FZX_H

#include <stddef.h>
#include <stdint.h>
#include <rect.h>

// DATA STRUCTURES

struct fzx_font
{
   uint8_t   height;                   // pixel height of font
   uint8_t   tracking;                 // horizontal gap between chars in pixels
   uint8_t   last_char;                // last defined char in bitmap 32..255
};

struct fzx_char
{
   uint16_t  kern_offset;              // kern in bits 15..14, offset to char bitmap
   uint8_t   shift_width_1;            // vertical shift in bits 7..4, width-1 in bits 3..0
};

struct fzx_cmetric
{
   uint8_t   kern;                     // num pixels to leftshift rendered char within string, 0-3
   uint8_t   width;                    // width of glyph, 1-16
   uint8_t   shift;                    // num pixels to downshift rendered char from top of line, 0-15
   uint8_t  *bitmap;                   // address of glyph bitmap
};

struct fzx_state
{
   uint8_t          jp;                // 195 = z80 jump instruction
   void            *fzx_draw;          // address of fzx_draw function
   struct fzx_font *font;              // selected font
   uint16_t         x;                 // x coordinate in pixels
   uint16_t         y;                 // y coordinate in pixels
   struct r_Rect16  window;            // display area units in pixels
   uint16_t         left_margin;       // left margin in pixels
   
   // zx spectrum only below (temporary declaration here)
   
   uint8_t          fgnd_attr;         // text colour
   uint8_t          fgnd_mask;         // set bits indicate kept background attribute bits
};

// FZX DRAW MODES

extern void _fzx_draw_cpl(void);       // INVERT fzx pixels before ORing into display
extern void _fzx_draw_or(void);        // OR fzx pixels into display
extern void _fzx_draw_reset(void);     // CLEAR display where fzx pixels are set
extern void _fzx_draw_xor(void);       // XOR fzx pixels into display

// FUNCTIONS

#ifdef __SDCC

// SDCC

extern void      fzx_state_init(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window);

extern void      fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y);
extern int       fzx_putc(struct fzx_state *fs, int c);

extern char     *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c);
extern uint16_t  fzx_glyph_width(struct fzx_font *ff, int c);

extern uint16_t  fzx_string_extent(struct fzx_font *ff, char *s);
extern char     *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width);
extern char     *fzx_string_partition_ww(struct fzx_font *ff, char *s, uint16_t allowed_width);

extern uint16_t  fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen);
extern char     *fzx_buffer_partition(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);
extern char     *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);

extern int       fzx_puts(struct fzx_state *fs, char *s);
extern int       fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width);

extern int       fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen);
extern int       fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width);

#else

// SCCZ80

extern void     __LIB__             fzx_state_init(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window);

extern void     __LIB__             fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y);
extern int      __LIB__             fzx_putc(struct fzx_state *fs, int c);

extern char     __LIB__            *fzx_char_metrics(struct fzx_font *ff, struct fzx_cmetric *fm, int c);
extern uint16_t __LIB__             fzx_glyph_width(struct fzx_font *ff, int c);

extern uint16_t __LIB__             fzx_string_extent(struct fzx_font *ff, char *s);
extern char     __LIB__            *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width);
extern char     __LIB__            *fzx_string_partition_ww(struct fzx_font *ff, char *s, uint16_t allowed_width);

extern uint16_t __LIB__             fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen);
extern char     __LIB__            *fzx_buffer_partition(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);
extern char     __LIB__            *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);

extern int      __LIB__             fzx_puts(struct fzx_state *fs, char *s);
extern int      __LIB__             fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width);

extern int      __LIB__             fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen);
extern int      __LIB__             fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width);

// SCCZ80 CALLEE LINKAGE

extern void     __LIB__ __CALLEE__  fzx_state_init_callee(struct fzx_state *fs, struct fzx_font *ff, struct r_Rect16 *window);

extern void     __LIB__ __CALLEE__  fzx_at_callee(struct fzx_state *fs, uint16_t x, uint16_t y);
extern int      __LIB__ __CALLEE__  fzx_putc_callee(struct fzx_state *fs, int c);

extern char     __LIB__ __CALLEE__ *fzx_char_metrics_callee(struct fzx_font *ff, struct fzx_cmetric *fm, int c);
extern uint16_t __LIB__ __CALLEE__  fzx_glyph_width_callee(struct fzx_font *ff, int c);

extern uint16_t __LIB__ __CALLEE__  fzx_string_extent_callee(struct fzx_font *ff, char *s);
extern char     __LIB__ __CALLEE__ *fzx_string_partition_callee(struct fzx_font *ff, char *s, uint16_t allowed_width);
extern char     __LIB__ __CALLEE__ *fzx_string_partition_ww_callee(struct fzx_font *ff, char *s, uint16_t allowed_width);

extern uint16_t __LIB__ __CALLEE__  fzx_buffer_extent_callee(struct fzx_font *ff, char *buf, uint16_t buflen);
extern char     __LIB__ __CALLEE__ *fzx_buffer_partition_callee(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);
extern char     __LIB__ __CALLEE__ *fzx_buffer_partition_ww_callee(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width);

extern int      __LIB__ __CALLEE__  fzx_puts_callee(struct fzx_state *fs, char *s);
extern int      __LIB__ __CALLEE__  fzx_puts_justified_callee(struct fzx_state *fs, char *s, uint16_t allowed_width);

extern int      __LIB__ __CALLEE__  fzx_write_callee(struct fzx_state *fs, char *buf, uint16_t buflen);
extern int      __LIB__ __CALLEE__  fzx_write_justified_callee(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define fzx_state_init(a,b,c)               fzx_state_init_callee(a,b,c)
#define fzx_at(a,b,c)                       fzx_at_callee(a,b,c)
#define fzx_putc(a,b)                       fzx_putc_callee(a,b)
#define fzx_char_metrics(a,b,c)             fzx_char_metrics_callee(a,b,c)
#define fzx_glyph_width(a,b)                fzx_glyph_width_callee(a,b)
#define fzx_string_extent(a,b)              fzx_string_extent_callee(a,b)
#define fzx_string_partition(a,b,c)         fzx_string_partition_callee(a,b,c)
#define fzx_string_partition_ww(a,b,c)      fzx_string_partition_ww_callee(a,b,c)
#define fzx_buffer_extent(a,b,c)            fzx_buffer_extent_callee(a,b,c)
#define fzx_buffer_partition(a,b,c,d)       fzx_buffer_partition_callee(a,b,c,d)
#define fzx_buffer_partition_ww(a,b,c,d)    fzx_buffer_partition_ww_callee(a,b,c,d)
#define fzx_puts(a,b)                       fzx_puts_callee(a,b)
#define fzx_puts_justified(a,b,c)           fzx_puts_justified_callee(a,b,c)
#define fzx_write(a,b,c)                    fzx_write_callee(a,b,c)
#define fzx_write_justified(a,b,c,d)        fzx_write_justified_callee(a,b,c,d)

#endif


// FZX FONTS BY ANDREW OWEN, LATIN VARIANTS BY TK90X

#ifdef __SDCC

extern struct fzx_font *ff_ao_Aribeth14;
extern struct fzx_font *ff_ao_Aribeth6;
extern struct fzx_font *ff_ao_Aribeth8;
extern struct fzx_font *ff_ao_Arkade;
extern struct fzx_font *ff_ao_Blackadder;
extern struct fzx_font *ff_ao_Cayeux;
extern struct fzx_font *ff_ao_Cheveron;
extern struct fzx_font *ff_ao_Chloe;
extern struct fzx_font *ff_ao_Dutch;
extern struct fzx_font *ff_ao_DutchLatin1;
extern struct fzx_font *ff_ao_DutchLatin5;
extern struct fzx_font *ff_ao_GenevaMonoBold;
extern struct fzx_font *ff_ao_GenevaMonoBoldItalic;
extern struct fzx_font *ff_ao_GenevaMonoCyrillic;
extern struct fzx_font *ff_ao_GenevaMonoItalic;
extern struct fzx_font *ff_ao_GenevaMonoRoman;
extern struct fzx_font *ff_ao_GenevaMonoSymbol;
extern struct fzx_font *ff_ao_Grotesk;
extern struct fzx_font *ff_ao_GroteskLatin1;
extern struct fzx_font *ff_ao_GroteskLatin5;
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
extern struct fzx_font *ff_ao_RoundelSansLatin1;
extern struct fzx_font *ff_ao_RoundelSansLatin5;
extern struct fzx_font *ff_ao_RoundelSerif;
extern struct fzx_font *ff_ao_RoundelSerifLatin1;
extern struct fzx_font *ff_ao_RoundelSerifLatin5;
extern struct fzx_font *ff_ao_Sabon;
extern struct fzx_font *ff_ao_Sinclair;
extern struct fzx_font *ff_ao_SinclairLatin1;
extern struct fzx_font *ff_ao_SinclairLatin5;
extern struct fzx_font *ff_ao_SoixanteQuatre;
extern struct fzx_font *ff_ao_Soxz;
extern struct fzx_font *ff_ao_SpecDings;
extern struct fzx_font *ff_ao_Swiss;
extern struct fzx_font *ff_ao_Trader;
extern struct fzx_font *ff_ao_Twombly;
extern struct fzx_font *ff_ao_Vickers;
extern struct fzx_font *ff_ao_Videotex;
extern struct fzx_font *ff_ao_Zaibatsu;
extern struct fzx_font *ff_ao_ZaibatsuLatin1;
extern struct fzx_font *ff_ao_ZaibatsuLatin5;

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
#define ff_ao_DutchLatin1           ((struct fzx_font *)(_ff_ao_DutchLatin1))
#define ff_ao_DutchLatin1           ((struct fzx_font *)(_ff_ao_DutchLatin5))
#define ff_ao_GenevaMonoBold        ((struct fzx_font *)(_ff_ao_GenevaMonoBold))
#define ff_ao_GenevaMonoBoldItalic  ((struct fzx_font *)(_ff_ao_GenevaMonoBoldItalic))
#define ff_ao_GenevaMonoCyrillic    ((struct fzx_font *)(_ff_ao_GenevaMonoCyrillic))
#define ff_ao_GenevaMonoItalic      ((struct fzx_font *)(_ff_ao_GenevaMonoItalic))
#define ff_ao_GenevaMonoRoman       ((struct fzx_font *)(_ff_ao_GenevaMonoRoman))
#define ff_ao_GenevaMonoSymbol      ((struct fzx_font *)(_ff_ao_GenevaMonoSymbol))
#define ff_ao_Grotesk               ((struct fzx_font *)(_ff_ao_Grotesk))
#define ff_ao_GroteskLatin1         ((struct fzx_font *)(_ff_ao_GroteskLatin1))
#define ff_ao_GroteskLatin5         ((struct fzx_font *)(_ff_ao_GroteskLatin5))
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
#define ff_ao_RoundelSansLatin1     ((struct fzx_font *)(_ff_ao_RoundelSansLatin1))
#define ff_ao_RoundelSansLatin5     ((struct fzx_font *)(_ff_ao_RoundelSansLatin5))
#define ff_ao_RoundelSerif          ((struct fzx_font *)(_ff_ao_RoundelSerif))
#define ff_ao_RoundelSerifLatin1    ((struct fzx_font *)(_ff_ao_RoundelSerifLatin1))
#define ff_ao_RoundelSerifLatin5    ((struct fzx_font *)(_ff_ao_RoundelSerifLatin5))
#define ff_ao_Sabon                 ((struct fzx_font *)(_ff_ao_Sabon))
#define ff_ao_Sinclair              ((struct fzx_font *)(_ff_ao_Sinclair))
#define ff_ao_SinclairLatin1        ((struct fzx_font *)(_ff_ao_SinclairLatin1))
#define ff_ao_SinclairLatin5        ((struct fzx_font *)(_ff_ao_SinclairLatin5))
#define ff_ao_SoixanteQuatre        ((struct fzx_font *)(_ff_ao_SoixanteQuatre))
#define ff_ao_Soxz                  ((struct fzx_font *)(_ff_ao_Soxz))
#define ff_ao_SpecDings             ((struct fzx_font *)(_ff_ao_SpecDings))
#define ff_ao_Swiss                 ((struct fzx_font *)(_ff_ao_Swiss))
#define ff_ao_Trader                ((struct fzx_font *)(_ff_ao_Trader))
#define ff_ao_Twombly               ((struct fzx_font *)(_ff_ao_Twombly))
#define ff_ao_Vickers               ((struct fzx_font *)(_ff_ao_Vickers))
#define ff_ao_Videotex              ((struct fzx_font *)(_ff_ao_Videotex))
#define ff_ao_Zaibatsu              ((struct fzx_font *)(_ff_ao_Zaibatsu))
#define ff_ao_ZaibatsuLatin1        ((struct fzx_font *)(_ff_ao_ZaibatsuLatin1))
#define ff_ao_ZaibatsuLatin5        ((struct fzx_font *)(_ff_ao_ZaibatsuLatin5))

extern void __LIB__ _ff_ao_Aribeth14(void);
extern void __LIB__ _ff_ao_Aribeth6(void);
extern void __LIB__ _ff_ao_Aribeth8(void);
extern void __LIB__ _ff_ao_Arkade(void);
extern void __LIB__ _ff_ao_Blackadder(void);
extern void __LIB__ _ff_ao_Cayeux(void);
extern void __LIB__ _ff_ao_Cheveron(void);
extern void __LIB__ _ff_ao_Chloe(void);
extern void __LIB__ _ff_ao_Dutch(void);
extern void __LIB__ _ff_ao_DutchLatin1(void);
extern void __LIB__ _ff_ao_DutchLatin5(void);
extern void __LIB__ _ff_ao_GenevaMonoBold(void);
extern void __LIB__ _ff_ao_GenevaMonoBoldItalic(void);
extern void __LIB__ _ff_ao_GenevaMonoCyrillic(void);
extern void __LIB__ _ff_ao_GenevaMonoItalic(void);
extern void __LIB__ _ff_ao_GenevaMonoRoman(void);
extern void __LIB__ _ff_ao_GenevaMonoSymbol(void);
extern void __LIB__ _ff_ao_Grotesk(void);
extern void __LIB__ _ff_ao_GroteskLatin1(void);
extern void __LIB__ _ff_ao_GroteskLatin5(void);
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
extern void __LIB__ _ff_ao_RoundelSansLatin1(void);
extern void __LIB__ _ff_ao_RoundelSansLatin5(void);
extern void __LIB__ _ff_ao_RoundelSerif(void);
extern void __LIB__ _ff_ao_RoundelSerifLatin1(void);
extern void __LIB__ _ff_ao_RoundelSerifLatin5(void);
extern void __LIB__ _ff_ao_Sabon(void);
extern void __LIB__ _ff_ao_Sinclair(void);
extern void __LIB__ _ff_ao_SinclairLatin1(void);
extern void __LIB__ _ff_ao_SinclairLatin5(void);
extern void __LIB__ _ff_ao_SoixanteQuatre(void);
extern void __LIB__ _ff_ao_Soxz(void);
extern void __LIB__ _ff_ao_SpecDings(void);
extern void __LIB__ _ff_ao_Swiss(void);
extern void __LIB__ _ff_ao_Trader(void);
extern void __LIB__ _ff_ao_Twombly(void);
extern void __LIB__ _ff_ao_Vickers(void);
extern void __LIB__ _ff_ao_Videotex(void);
extern void __LIB__ _ff_ao_Zaibatsu(void);
extern void __LIB__ _ff_ao_ZaibatsuLatin1(void);
extern void __LIB__ _ff_ao_ZaibatsuLatin5(void);

#endif


// FZX FONTS FROM KLUB UZIVATELU DESKTOPU
// http://www.worldofspectrum.org/infoseekid.cgi?id=0023578

#ifdef __SDCC

extern struct fzx_font *ff_dkud1_Beerland2;
extern struct fzx_font *ff_dkud1_Cinema;
extern struct fzx_font *ff_dkud1_Cobretti;
extern struct fzx_font *ff_dkud1_Consul1;
extern struct fzx_font *ff_dkud1_Consul2;
extern struct fzx_font *ff_dkud1_Crusade;
extern struct fzx_font *ff_dkud1_DoubleBold;
extern struct fzx_font *ff_dkud1_Edice13;
extern struct fzx_font *ff_dkud1_JmenoRuze;
extern struct fzx_font *ff_dkud1_Kurziva;
extern struct fzx_font *ff_dkud1_Little;
extern struct fzx_font *ff_dkud1_MahJongg;
extern struct fzx_font *ff_dkud1_Overline;
extern struct fzx_font *ff_dkud1_Phones2;
extern struct fzx_font *ff_dkud1_RightBold;
extern struct fzx_font *ff_dkud1_SciFi;
extern struct fzx_font *ff_dkud1_Sinclair;
extern struct fzx_font *ff_dkud1_Subtitles;
extern struct fzx_font *ff_dkud1_Transcript;
extern struct fzx_font *ff_dkud1_UpnUp1;
extern struct fzx_font *ff_dkud1_UpnUp2;

#else

#define ff_dkud1_Beerland2     ((struct fzx_font *)(_ff_dkud1_Beerland2))
#define ff_dkud1_Cinema        ((struct fzx_font *)(_ff_dkud1_Cinema))
#define ff_dkud1_Cobretti      ((struct fzx_font *)(_ff_dkud1_Cobretti))
#define ff_dkud1_Consul1       ((struct fzx_font *)(_ff_dkud1_Consul1))
#define ff_dkud1_Consul2       ((struct fzx_font *)(_ff_dkud1_Consul2))
#define ff_dkud1_Crusade       ((struct fzx_font *)(_ff_dkud1_Crusade))
#define ff_dkud1_DoubleBold    ((struct fzx_font *)(_ff_dkud1_DoubleBold))
#define ff_dkud1_Edice13       ((struct fzx_font *)(_ff_dkud1_Edice13))
#define ff_dkud1_JmenoRuze     ((struct fzx_font *)(_ff_dkud1_JmenoRuze))
#define ff_dkud1_Kurziva       ((struct fzx_font *)(_ff_dkud1_Kurziva))
#define ff_dkud1_Little        ((struct fzx_font *)(_ff_dkud1_Little))
#define ff_dkud1_MahJongg      ((struct fzx_font *)(_ff_dkud1_MahJongg))
#define ff_dkud1_Overline      ((struct fzx_font *)(_ff_dkud1_Overline))
#define ff_dkud1_Phones2       ((struct fzx_font *)(_ff_dkud1_Phones2))
#define ff_dkud1_RightBold     ((struct fzx_font *)(_ff_dkud1_RightBold))
#define ff_dkud1_SciFi         ((struct fzx_font *)(_ff_dkud1_SciFi))
#define ff_dkud1_Sinclair      ((struct fzx_font *)(_ff_dkud1_Sinclair2))
#define ff_dkud1_Subtitles     ((struct fzx_font *)(_ff_dkud1_Subtitles))
#define ff_dkud1_Transcript    ((struct fzx_font *)(_ff_dkud1_Transcript))
#define ff_dkud1_UpnUp1        ((struct fzx_font *)(_ff_dkud1_UpnUp1))
#define ff_dkud1_UpnUp2        ((struct fzx_font *)(_ff_dkud1_UpnUp2))

extern void __LIB__ _ff_dkud1_Beerland2(void);
extern void __LIB__ _ff_dkud1_Cinema(void);
extern void __LIB__ _ff_dkud1_Cobretti(void);
extern void __LIB__ _ff_dkud1_Consul1(void);
extern void __LIB__ _ff_dkud1_Consul2(void);
extern void __LIB__ _ff_dkud1_Crusade(void);
extern void __LIB__ _ff_dkud1_DoubleBold(void);
extern void __LIB__ _ff_dkud1_Edice13(void);
extern void __LIB__ _ff_dkud1_JmenoRuze(void);
extern void __LIB__ _ff_dkud1_Kurziva(void);
extern void __LIB__ _ff_dkud1_Little(void);
extern void __LIB__ _ff_dkud1_MahJongg(void);
extern void __LIB__ _ff_dkud1_Overline(void);
extern void __LIB__ _ff_dkud1_Phones2(void);
extern void __LIB__ _ff_dkud1_RightBold(void);
extern void __LIB__ _ff_dkud1_SciFi(void);
extern void __LIB__ _ff_dkud1_Sinclair(void);
extern void __LIB__ _ff_dkud1_Subtitles(void);
extern void __LIB__ _ff_dkud1_Transcript(void);
extern void __LIB__ _ff_dkud1_UpnUp1(void);
extern void __LIB__ _ff_dkud1_UpnUp2(void);

#endif


// FZX FONTS FROM UNIVERSUM'S DESKTOP
// http://www.worldofspectrum.org/infoseekid.cgi?id=0016682

#ifdef __SDCC

extern struct fzx_font *ff_dkud2_Academy;
extern struct fzx_font *ff_dkud2_Belegost1;
extern struct fzx_font *ff_dkud2_Belegost2;
extern struct fzx_font *ff_dkud2_BigBold;
extern struct fzx_font *ff_dkud2_UltraBold;
extern struct fzx_font *ff_dkud2_UpcaseBold;
extern struct fzx_font *ff_dkud2_Cobra;
extern struct fzx_font *ff_dkud2_Crash;
extern struct fzx_font *ff_dkud2_doc;
extern struct fzx_font *ff_dkud2_Eclipse;
extern struct fzx_font *ff_dkud2_Extra;
extern struct fzx_font *ff_dkud2_Hijack;
extern struct fzx_font *ff_dkud2_Italika;
extern struct fzx_font *ff_dkud2_Just6;
extern struct fzx_font *ff_dkud2_Locomotion;
extern struct fzx_font *ff_dkud2_Midnight;
extern struct fzx_font *ff_dkud2_MoonAlert;
extern struct fzx_font *ff_dkud2_Nether;
extern struct fzx_font *ff_dkud2_Neverend;
extern struct fzx_font *ff_dkud2_Roman;
extern struct fzx_font *ff_dkud2_Script1;
extern struct fzx_font *ff_dkud2_Script2;
extern struct fzx_font *ff_dkud2_Standard;
extern struct fzx_font *ff_dkud2_Tomahawk;
extern struct fzx_font *ff_dkud2_Wildvest;
extern struct fzx_font *ff_dkud2_Winter;

#else

#define ff_dkud2_Academy       ((struct fzx_font *)(_ff_dkud2_Academy))
#define ff_dkud2_Belegost1     ((struct fzx_font *)(_ff_dkud2_Belegost1))
#define ff_dkud2_Belegost2     ((struct fzx_font *)(_ff_dkud2_Belegost2))
#define ff_dkud2_BigBold       ((struct fzx_font *)(_ff_dkud2_BigBold))
#define ff_dkud2_UltraBold     ((struct fzx_font *)(_ff_dkud2_UltraBold))
#define ff_dkud2_UpcaseBold    ((struct fzx_font *)(_ff_dkud2_UpcaseBold))
#define ff_dkud2_Cobra         ((struct fzx_font *)(_ff_dkud2_Cobra))
#define ff_dkud2_Crash         ((struct fzx_font *)(_ff_dkud2_Crash))
#define ff_dkud2_doc           ((struct fzx_font *)(_ff_dkud2_doc))
#define ff_dkud2_Eclipse       ((struct fzx_font *)(_ff_dkud2_Eclipse))
#define ff_dkud2_Extra         ((struct fzx_font *)(_ff_dkud2_Extra))
#define ff_dkud2_Hijack        ((struct fzx_font *)(_ff_dkud2_Hijack))
#define ff_dkud2_Italika       ((struct fzx_font *)(_ff_dkud2_Italika))
#define ff_dkud2_Just6         ((struct fzx_font *)(_ff_dkud2_Just6))
#define ff_dkud2_Locomotion    ((struct fzx_font *)(_ff_dkud2_Locomotion))
#define ff_dkud2_Midnight      ((struct fzx_font *)(_ff_dkud2_Midnight))
#define ff_dkud2_MoonAlert     ((struct fzx_font *)(_ff_dkud2_MoonAlert))
#define ff_dkud2_Nether        ((struct fzx_font *)(_ff_dkud2_Nether))
#define ff_dkud2_Neverend      ((struct fzx_font *)(_ff_dkud2_Neverend))
#define ff_dkud2_Roman         ((struct fzx_font *)(_ff_dkud2_Roman))
#define ff_dkud2_Script1       ((struct fzx_font *)(_ff_dkud2_Script1))
#define ff_dkud2_Script2       ((struct fzx_font *)(_ff_dkud2_Script2))
#define ff_dkud2_Standard      ((struct fzx_font *)(_ff_dkud2_Standard))
#define ff_dkud2_Tomahawk      ((struct fzx_font *)(_ff_dkud2_Tomahawk))
#define ff_dkud2_Wildvest      ((struct fzx_font *)(_ff_dkud2_Wildvest))
#define ff_dkud2_Winter        ((struct fzx_font *)(_ff_dkud2_Winter))

extern void __LIB__ _ff_dkud2_Academy(void);
extern void __LIB__ _ff_dkud2_Belegost1(void);
extern void __LIB__ _ff_dkud2_Belegost2(void);
extern void __LIB__ _ff_dkud2_BigBold(void);
extern void __LIB__ _ff_dkud2_UltraBold(void);
extern void __LIB__ _ff_dkud2_UpcaseBold(void);
extern void __LIB__ _ff_dkud2_Cobra(void);
extern void __LIB__ _ff_dkud2_Crash(void);
extern void __LIB__ _ff_dkud2_doc(void);
extern void __LIB__ _ff_dkud2_Eclipse(void);
extern void __LIB__ _ff_dkud2_Extra(void);
extern void __LIB__ _ff_dkud2_Hijack(void);
extern void __LIB__ _ff_dkud2_Italika(void);
extern void __LIB__ _ff_dkud2_Just6(void);
extern void __LIB__ _ff_dkud2_Locomotion(void);
extern void __LIB__ _ff_dkud2_Midnight(void);
extern void __LIB__ _ff_dkud2_MoonAlert(void);
extern void __LIB__ _ff_dkud2_Nether(void);
extern void __LIB__ _ff_dkud2_Neverend(void);
extern void __LIB__ _ff_dkud2_Roman(void);
extern void __LIB__ _ff_dkud2_Script1(void);
extern void __LIB__ _ff_dkud2_Script2(void);
extern void __LIB__ _ff_dkud2_Standard(void);
extern void __LIB__ _ff_dkud2_Tomahawk(void);
extern void __LIB__ _ff_dkud2_Wildvest(void);
extern void __LIB__ _ff_dkud2_Winter(void);

#endif


// FZX FONTS FROM KLUB UZIVATELU DESKTOPU 3
// http://www.worldofspectrum.org/infoseekid.cgi?id=0023577

#ifdef __SDCC

extern struct fzx_font *ff_dkud3_Azbuka;
extern struct fzx_font *ff_dkud3_AzbukaBold;
extern struct fzx_font *ff_dkud3_Belegost3;
extern struct fzx_font *ff_dkud3_CobraLight;
extern struct fzx_font *ff_dkud3_CobraTall;
extern struct fzx_font *ff_dkud3_DeutchBold;
extern struct fzx_font *ff_dkud3_TrnsDeutch;
extern struct fzx_font *ff_dkud3_Echo;
extern struct fzx_font *ff_dkud3_Erotic;
extern struct fzx_font *ff_dkud3_Lovely;
extern struct fzx_font *ff_dkud3_NisaSport1;
extern struct fzx_font *ff_dkud3_NisaSport2;
extern struct fzx_font *ff_dkud3_Notes;
extern struct fzx_font *ff_dkud3_Pearl;
extern struct fzx_font *ff_dkud3_Pipe;
extern struct fzx_font *ff_dkud3_PipePlus;
extern struct fzx_font *ff_dkud3_QuaUni;
extern struct fzx_font *ff_dkud3_Script;
extern struct fzx_font *ff_dkud3_Small1;
extern struct fzx_font *ff_dkud3_Small2;
extern struct fzx_font *ff_dkud3_SteAff;
extern struct fzx_font *ff_dkud3_Times1;
extern struct fzx_font *ff_dkud3_Times2;
extern struct fzx_font *ff_dkud3_Western;
extern struct fzx_font *ff_dkud3_Windows;
extern struct fzx_font *ff_dkud3_WingCmdr1;
extern struct fzx_font *ff_dkud3_WingCmdr2;

#else

#define ff_dkud3_Azbuka        ((struct fzx_font *)(_ff_dkud3_Azbuka))
#define ff_dkud3_AzbukaBold    ((struct fzx_font *)(_ff_dkud3_AzbukaBold))
#define ff_dkud3_Belegost3     ((struct fzx_font *)(_ff_dkud3_Belegost3))
#define ff_dkud3_CobraLight    ((struct fzx_font *)(_ff_dkud3_CobraLight))
#define ff_dkud3_CobraTall     ((struct fzx_font *)(_ff_dkud3_CobraTall))
#define ff_dkud3_DeutchBold    ((struct fzx_font *)(_ff_dkud3_DeutchBold))
#define ff_dkud3_TrnsDeutch    ((struct fzx_font *)(_ff_dkud3_TrnsDeutch))
#define ff_dkud3_Echo          ((struct fzx_font *)(_ff_dkud3_Echo))
#define ff_dkud3_Erotic        ((struct fzx_font *)(_ff_dkud3_Erotic))
#define ff_dkud3_Lovely        ((struct fzx_font *)(_ff_dkud3_Lovely))
#define ff_dkud3_NisaSport1    ((struct fzx_font *)(_ff_dkud3_NisaSport1))
#define ff_dkud3_NisaSport2    ((struct fzx_font *)(_ff_dkud3_NisaSport2))
#define ff_dkud3_Notes         ((struct fzx_font *)(_ff_dkud3_Notes))
#define ff_dkud3_Pearl         ((struct fzx_font *)(_ff_dkud3_Pearl))
#define ff_dkud3_Pipe          ((struct fzx_font *)(_ff_dkud3_Pipe))
#define ff_dkud3_PipePlus      ((struct fzx_font *)(_ff_dkud3_PipePlus))
#define ff_dkud3_QuaUni        ((struct fzx_font *)(_ff_dkud3_QuaUni))
#define ff_dkud3_Script        ((struct fzx_font *)(_ff_dkud3_Script))
#define ff_dkud3_Small1        ((struct fzx_font *)(_ff_dkud3_Small1))
#define ff_dkud3_Small2        ((struct fzx_font *)(_ff_dkud3_Small2))
#define ff_dkud3_SteAff        ((struct fzx_font *)(_ff_dkud3_SteAff))
#define ff_dkud3_Times1        ((struct fzx_font *)(_ff_dkud3_Times1))
#define ff_dkud3_Times2        ((struct fzx_font *)(_ff_dkud3_Times2))
#define ff_dkud3_Western       ((struct fzx_font *)(_ff_dkud3_Western))
#define ff_dkud3_Windows       ((struct fzx_font *)(_ff_dkud3_Windows))
#define ff_dkud3_WingCmdr1     ((struct fzx_font *)(_ff_dkud3_WingCmdr1))
#define ff_dkud3_WingCmdr2     ((struct fzx_font *)(_ff_dkud3_WingCmdr2))

extern void __LIB__ _ff_dkud3_Azbuka(void);
extern void __LIB__ _ff_dkud3_AzbukaBold(void);
extern void __LIB__ _ff_dkud3_Belegost3(void);
extern void __LIB__ _ff_dkud3_CobraLight(void);
extern void __LIB__ _ff_dkud3_CobraTall(void);
extern void __LIB__ _ff_dkud3_DeutchBold(void);
extern void __LIB__ _ff_dkud3_TrnsDeutch(void);
extern void __LIB__ _ff_dkud3_Echo(void);
extern void __LIB__ _ff_dkud3_Erotic(void);
extern void __LIB__ _ff_dkud3_Lovely(void);
extern void __LIB__ _ff_dkud3_NisaSport1(void);
extern void __LIB__ _ff_dkud3_NisaSport2(void);
extern void __LIB__ _ff_dkud3_Notes(void);
extern void __LIB__ _ff_dkud3_Pearl(void);
extern void __LIB__ _ff_dkud3_Pipe(void);
extern void __LIB__ _ff_dkud3_PipePlus(void);
extern void __LIB__ _ff_dkud3_QuaUni(void);
extern void __LIB__ _ff_dkud3_Script(void);
extern void __LIB__ _ff_dkud3_Small1(void);
extern void __LIB__ _ff_dkud3_Small2(void);
extern void __LIB__ _ff_dkud3_SteAff(void);
extern void __LIB__ _ff_dkud3_Times1(void);
extern void __LIB__ _ff_dkud3_Times2(void);
extern void __LIB__ _ff_dkud3_Western(void);
extern void __LIB__ _ff_dkud3_Windows(void);
extern void __LIB__ _ff_dkud3_WingCmdr1(void);
extern void __LIB__ _ff_dkud3_WingCmdr2(void);

#endif


// FZX FONTS FROM DESKTOP FONT EDITOR
// http://www.worldofspectrum.org/infoseekid.cgi?id=0016682

#ifdef __SDCC

extern struct fzx_font *ff_dkud4_Font01;
extern struct fzx_font *ff_dkud4_Font02;
extern struct fzx_font *ff_dkud4_Font03;
extern struct fzx_font *ff_dkud4_Font04;
extern struct fzx_font *ff_dkud4_Font05;
extern struct fzx_font *ff_dkud4_Font06;
extern struct fzx_font *ff_dkud4_Font07;
extern struct fzx_font *ff_dkud4_Font08;
extern struct fzx_font *ff_dkud4_Font09;
extern struct fzx_font *ff_dkud4_Font10;
extern struct fzx_font *ff_dkud4_Font11;
extern struct fzx_font *ff_dkud4_Font12;
extern struct fzx_font *ff_dkud4_Font13;
extern struct fzx_font *ff_dkud4_Font14;
extern struct fzx_font *ff_dkud4_Font15;

#else

#define ff_dkud4_Font01        ((struct fzx_font *)(_ff_dkud4_Font01))
#define ff_dkud4_Font02        ((struct fzx_font *)(_ff_dkud4_Font02))
#define ff_dkud4_Font03        ((struct fzx_font *)(_ff_dkud4_Font03))
#define ff_dkud4_Font04        ((struct fzx_font *)(_ff_dkud4_Font04))
#define ff_dkud4_Font05        ((struct fzx_font *)(_ff_dkud4_Font05))
#define ff_dkud4_Font06        ((struct fzx_font *)(_ff_dkud4_Font06))
#define ff_dkud4_Font07        ((struct fzx_font *)(_ff_dkud4_Font07))
#define ff_dkud4_Font08        ((struct fzx_font *)(_ff_dkud4_Font08))
#define ff_dkud4_Font09        ((struct fzx_font *)(_ff_dkud4_Font09))
#define ff_dkud4_Font10        ((struct fzx_font *)(_ff_dkud4_Font10))
#define ff_dkud4_Font11        ((struct fzx_font *)(_ff_dkud4_Font11))
#define ff_dkud4_Font12        ((struct fzx_font *)(_ff_dkud4_Font12))
#define ff_dkud4_Font13        ((struct fzx_font *)(_ff_dkud4_Font13))
#define ff_dkud4_Font14        ((struct fzx_font *)(_ff_dkud4_Font14))
#define ff_dkud4_Font15        ((struct fzx_font *)(_ff_dkud4_Font15))

extern void __LIB__ _ff_dkud4_Font01(void);
extern void __LIB__ _ff_dkud4_Font02(void);
extern void __LIB__ _ff_dkud4_Font03(void);
extern void __LIB__ _ff_dkud4_Font04(void);
extern void __LIB__ _ff_dkud4_Font05(void);
extern void __LIB__ _ff_dkud4_Font06(void);
extern void __LIB__ _ff_dkud4_Font07(void);
extern void __LIB__ _ff_dkud4_Font08(void);
extern void __LIB__ _ff_dkud4_Font09(void);
extern void __LIB__ _ff_dkud4_Font10(void);
extern void __LIB__ _ff_dkud4_Font11(void);
extern void __LIB__ _ff_dkud4_Font12(void);
extern void __LIB__ _ff_dkud4_Font13(void);
extern void __LIB__ _ff_dkud4_Font14(void);
extern void __LIB__ _ff_dkud4_Font15(void);

#endif


// FZX FONTS BY INDEPENDENT DESIGNERS KWEEPA & TK90X

#ifdef __SDCC

extern struct fzx_font *ff_ind_Termino;
extern struct fzx_font *ff_ind_TerminoLatin1;
extern struct fzx_font *ff_ind_TerminoLatin5;
extern struct fzx_font *ff_ind_vga;

#else

#define ff_ind_Termino         ((struct fzx_font *)(_ff_ind_Termino))
#define ff_ind_TerminoLatin1   ((struct fzx_font *)(_ff_ind_TerminoLatin1))
#define ff_ind_TerminoLatin5   ((struct fzx_font *)(_ff_ind_TerminoLatin5))
#define ff_ind_vga             ((struct fzx_font *)(_ff_ind_vga))

extern void __LIB__ _ff_ind_Termino(void);
extern void __LIB__ _ff_ind_TerminoLatin1(void);
extern void __LIB__ _ff_ind_TerminoLatin5(void);
extern void __LIB__ _ff_ind_vga(void);

#endif


// FZX FONTS BY UTZ

#ifdef __SDCC

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
