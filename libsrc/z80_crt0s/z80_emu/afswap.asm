;
;       Replacement for "ex af,af"
;
;       $Id: afswap.asm,v 1.2 2014-04-26 00:03:52 pauloscustodio Exp $:


		PUBLIC	afswap


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