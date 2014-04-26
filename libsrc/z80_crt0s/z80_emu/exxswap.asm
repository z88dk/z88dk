;
;       Replacement for "exx"
;
;       $Id: exxswap.asm,v 1.2 2014-04-26 00:03:52 pauloscustodio Exp $:


		PUBLIC	exxswap


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