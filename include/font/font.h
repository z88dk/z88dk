

#ifndef __FONT_FONT_H__
#define __FONT_FONT_H__

struct _font;

// 6x8 fonts (good for TMS99x8 text modes)
extern struct _font font_6x8_clairsys;
extern struct _font font_6x8_coleco_adam_system;
extern struct _font font_6x8_einstein_system;
extern struct _font font_6x8_msx_system;
extern struct _font font_6x8_pmd85_system;

// 8x8 fonts
extern struct _font font_8x8_bbc_system;
extern struct _font font_8x8_c64_system;
extern struct _font font_8x8_clairsys;
extern struct _font font_8x8_clairsys_bold;
extern struct _font font_8x8_coleco_adam_system;
extern struct _font font_8x8_cpc_system;
extern struct _font font_8x8_einstein_system;
extern struct _font font_8x8_msx_system;
extern struct _font font_8x8_pmd85_system;
extern struct _font font_8x8_sam_system;
extern struct _font font_8x8_vga_rom;
extern struct _font font_8x8_zx_system;

// 4x8 fonts
extern struct _font font_4x8_64_minix;
extern struct _font font_4x8_64_nbot;
extern struct _font font_4x8_64_omni1;
extern struct _font font_4x8_64_omni2;
extern struct _font font_4x8_64_owen;
extern struct _font font_4x8_80columns;
extern struct _font font_4x8_color80;
extern struct _font font_4x8_default;
extern struct _font font_4x8_highspeed80;
extern struct _font font_4x8_screen80;

// 8x10 fonts (for VG5000)
extern struct _font font_8x10_bbc_system;
extern struct _font font_8x10_c64_system;
extern struct _font font_8x10_clairsys;
extern struct _font font_8x10_clairsys_bold;
extern struct _font font_8x10_cpc_system;
extern struct _font font_8x10_vga_rom;
extern struct _font font_8x10_zx_system;

#endif
