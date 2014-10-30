
;
;       z88dk RS232 Functions
;
;       'ROM page' for the Spectrum +
;
;       $Id: rs232_page_romout.asm,v 1.1 2014-10-30 10:26:48 stefano Exp $

XLIB	rs232_page_romout

	defc	bank2	= $1ffd
	defc	bank678 = $5b67

.rs232_page_romout
	di
	ld	bc,bank2
	ld	a,(bank678)
	set	2,a
	ld	(bank678),a
	out	(c),a
	ei
	ret

