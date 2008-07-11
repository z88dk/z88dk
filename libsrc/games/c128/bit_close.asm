; $Id: bit_close.asm,v 1.1 2008-07-11 15:10:57 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_close

.bit_close

;-----
; Stefano Bodrato - fix for new SID, version 8580
	ld	bc,$d404
	ld	e,0
resetsid:
	out	(c),e
	inc	c
	ld	a,c
	cp	$15	; loop up to $d414 (all three oscillators)
	jr	nz,resetsid
;-----

ret
