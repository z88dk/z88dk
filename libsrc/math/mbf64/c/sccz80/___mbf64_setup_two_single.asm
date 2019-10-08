        SECTION         code_fp_mbf64

        PUBLIC          ___mbf64_setup_single_two
        EXTERN          ___mbf32_FPREG
        EXTERN          ___mbf32_VALTYP


; Used for the routines which accept single precision
;
; Entry: -
; Stack: +0 defw return address
;        +2 defw callee return address
;        +4 defw right hand LSW
;        +6 defw right hand NLSW
;        +8 defw right hand NMSW
;        +10 defw right hand MSW
;        +12 defw left hand LSW
;        +14 defw left hand NLSW
;        +16 defw left hand NMSW
;        +18 defw lefthand MSW
___mbf64_setup_single_two:
        ld      a,4
        ld      (___mbf32_VALTYP),a
        ld      hl,8
        add     hl,sp
        ld      de,___mbf32_FPREG               ;Store the right hand
        ld      bc,4
        ldir
	ld	bc,4
	add	hl,bc
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        pop     hl
        push    ix
        push    hl
	ret
