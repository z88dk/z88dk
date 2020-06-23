;
;       Generic pseudo graphics routines for text-only platforms
;
;       Xor pixel at (x,y) coordinate.


	SECTION		code_graphics
	PUBLIC		w_xorpixel

	defc	NEEDxor = 1

.w_xorpixel
	INCLUDE		"w_pixel.asm"
