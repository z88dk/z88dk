;
;       Replacement for "ex af,af"
;
;       $Id: afswap.asm,v 1.1 2007-11-02 10:03:32 stefano Exp $:


		XLIB	afswap


.af1	defw	0

.afswap
        ;EX      AF,AF'
        push	hl
        push	af
        ld	hl,(af1)
        ex	(sp),hl
        ld	(af1),hl
        pop	af
        pop	hl
	ret