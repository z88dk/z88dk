;
;       Replacement for "exx"
;
;       $Id: exxswap.asm,v 1.1 2007-11-02 10:03:32 stefano Exp $:


		XLIB	exxswap


.altregs   defs   6

.exxswap
        push	hl
        ld	hl,(altregs)
        ex	(sp),hl
        ld	(altregs),hl

        push	bc
        ld	hl,(altregs+2)
        ex	(sp),hl
        ld	(altregs+2),hl
        pop	bc

        push	de
        ld	hl,(altregs+4)
        ex	(sp),hl
        ld	(altregs+4),hl
        pop	de

        pop	hl
	ret