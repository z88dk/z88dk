; $Id: bit_close.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_close
    PUBLIC     _bit_close

.bit_close
._bit_close

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
