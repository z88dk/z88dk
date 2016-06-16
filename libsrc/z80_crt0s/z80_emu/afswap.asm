;
;       Replacement for "ex af,af"
;
;       $Id: afswap.asm,v 1.3 2016-06-16 20:31:05 dom Exp $:

		SECTION code_crt0_sccz80
		PUBLIC	afswap



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

	SECTION		bss_crt
.af1	defw	0
