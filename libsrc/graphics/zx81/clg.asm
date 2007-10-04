
	XLIB	clg

;
;	$Id: clg.asm,v 1.2 2007-10-04 20:16:12 stefano Exp $
;

; ******************************************************************
;
;	Clear graphics area, 
;
;	In text mode we can just happily call the ROM
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;

.clg
		jp	2602	
