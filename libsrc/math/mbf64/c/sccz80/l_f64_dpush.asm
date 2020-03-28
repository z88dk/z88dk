

        SECTION code_fp_mbf64

        PUBLIC  l_f64_dpush
        PUBLIC  l_f64_dldpsh

	EXTERN	___mbf64_FA


; Load FA from (hl) and push FA onto stack
;-----------------------------------------
l_f64_dldpsh:
	ld      de,___mbf64_FA
        ld      bc,8
        ldir
;------------------------------------------
; Push FA onto stack (under return address)
;------------------------------------------
l_f64_dpush:
	pop     de
        ld      hl,(___mbf64_FA + 6)
        push    hl
        ld      hl,(___mbf64_FA + 4)
        push    hl
        ld      hl,(___mbf64_FA + 2)
        push    hl
        ld      hl,(___mbf64_FA + 0)
        push    hl
        ex      de,hl
        jp      (hl)
