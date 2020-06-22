;
;       Plot pixel at (x,y) coordinate.

	SECTION		code_graphics
	PUBLIC		w_plotpixel

	defc	NEEDplot = 1


.w_plotpixel
	INCLUDE		"w_pixel.asm"

