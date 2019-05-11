

        SECTION code_fp_mbf64

        PUBLIC  l_f64_dpush3

	EXTERN	___mbf64_FA

;------------------------------------------------------
; Push FA onto stack under ret address and stacked long
;------------------------------------------------------
l_f64_dpush3:
	pop     de		;return address
	pop	bc		;LSW of long
	pop	af		;MSW of long
        ld      hl,(___mbf64_FA + 6)
        push    hl
        ld      hl,(___mbf64_FA + 4)
        push    hl
        ld      hl,(___mbf64_FA + 2)
        push    hl
        ld      hl,(___mbf64_FA + 0)
        push    hl
	push	af
	push	bc
	ex	de,hl
	jp	(hl)
