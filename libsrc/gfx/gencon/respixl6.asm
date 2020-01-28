;
;       Generic pseudo graphics routines for text-only platforms
;
;       Reset pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	respixel


.respixel			
	defc	NEEDunplot = 1
	INCLUDE "pixel6.inc"

