#ifndef _GFX_H
#define _GFX_H

// font

#define FONT_LEN 768

extern  unsigned char font[];

// sprite graphics

extern  unsigned char bomber[];
extern  unsigned char explosion[];
extern  unsigned char flyer[];
extern  unsigned char impact[];
extern  unsigned char player[];

// background tile graphics

extern unsigned char ptiles[];

#define TILES_BASE 128
#define TILES_LEN  109

extern unsigned char tiles[];

// compressed screens

extern unsigned char menu[];
extern unsigned char warning[];

#endif
