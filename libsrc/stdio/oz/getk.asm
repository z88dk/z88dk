;
;	OZ 700 console library
;	foo stub for GETK
;
;	getk() Read key status
;
;	$Id: getk.asm,v 1.1 2002-11-20 14:17:02 stefano Exp $
;


		XLIB	getk

.getk
		ld	hl,13
		ret
