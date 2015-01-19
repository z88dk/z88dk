; $Id: bit_close.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_close

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
