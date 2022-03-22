#ifndef __MZ_H__
#define __MZ_H__


// Works on later models only (MZ-700, MZ-800, MZ-1500)

extern void __LIB__  mz_border() __z88dk_fastcall;


/*
   MZ800 video modes. 
   
   Valid values, with 16K VRAM are 0 (320x200x4) and 4 (640x200x1), single frame.
   With 32K, the options are:
     0 - 320x200x4 (Frame A)
	 1 - 320x200x4 (Frame B)
	 2 - 320x200x16
	 
	 4 - 640x200x1 (Frame A)
	 5 - 640x200x1 (Frame B)
     6 - 640x200x4
	 
	 8 - MZ-700 text mode (40x25, 8 colors)
*/

// Set video mode on MZ800
extern void __LIB__  set_mz800_vmode() __z88dk_fastcall;

// Read current MZ800 video mode register value
extern int __LIB__  get_mz800_vmode();

// Wait VSYNC
extern void __LIB__  mz800_vsync();



#endif
