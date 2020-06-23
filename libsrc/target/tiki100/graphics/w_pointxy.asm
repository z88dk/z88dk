;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



	SECTION		code_graphics
	PUBLIC		w_pointxy

	defc	NEEDpoint= 1


.w_pointxy			
	INCLUDE		"w_pixel.asm"

