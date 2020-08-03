

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_single
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP


; Used for the routines which accept single precision
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbf32_setup_single:
    ld      a,4
    ld      (___mbf32_VALTYP),a
IF __CPU_GBZ80__
    ld      hl,sp+4
ELSE
    ld      hl,4
    add     hl,sp
ENDIF
    ld      de,___mbf32_FPREG		;Store the right hand
IF __CPU_INTEL__ || __CPU_GBZ80__
    ld      b,4
copy_loop:
    ld      a,(hl)
    ld      (de),a
    inc     hl
    inc     de
    djnz    copy_loop
ELSE
    ld      bc,4
    ldir
ENDIF
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    pop     hl
    push    ix
    push    hl
ENDIF
    ret
