;
;	Enterprise 64/128 clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.1 2011-03-18 07:12:41 stefano Exp $
;

	XLIB	clock

.clock

	rst   30h
	defb  32
	
    ;              C hours   0 .. 23 (BCD)
    ;              D minutes 0 .. 59 (BCD)
    ;              E seconds 0 .. 59 (BCD) 	

	; let's copy the result in dehl
	; in a quick but wrong way..
	ex	de,hl
	ld	d,0
	ld	e,c
	
	ret
