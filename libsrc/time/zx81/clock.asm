;
;	ZX81 clock() function
;	By Stefano Bodrato - summer 2000
;

	XLIB	clock

.clock
; 16536/7 word running backwards from 65535 to 32768 (bit 15 always set).
; It is reset by basic if running a PAUSE statement.

	ld	a,(16436)
	xor	255
	ld	l,a
	ld	a,(16437)
	xor	128
	ld	h,a
	ld	de,0
	ret
