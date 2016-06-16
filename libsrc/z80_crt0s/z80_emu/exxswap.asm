;
;       Replacement for "exx"
;
;       $Id: exxswap.asm,v 1.3 2016-06-16 20:31:05 dom Exp $:

		SECTION		code_crt0_sccz80
		SECTION 	exxswap



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

		SECTION		bss_crt
.altregs   defs   6
