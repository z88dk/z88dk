;
;       Generic pseudo graphics routines for text-only platforms
;
;       Reset pixel at (x,y) coordinate.



	SECTION		code_graphics
	PUBLIC		w_respixel

	defc	NEEDunplot = 1


.w_respixel			
	INCLUDE		"w_pixel.asm"

