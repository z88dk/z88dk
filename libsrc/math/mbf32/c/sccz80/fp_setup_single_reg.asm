

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_single_reg
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP


; Used for the routines which accept single_reg precision
;
; Entry: dehl = floating point number
; Stack: defw return address
___mbf32_setup_single_reg:
    ld      a,4
    ld      (___mbf32_VALTYP),a
IF __CPU_GBZ80__
    ld      c,l                 ;Put the right hand operand into FPREG
    ld      b,h
    ld      hl,___mbf32_FPREG
    ld      (hl),c
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
ELSE
    ld      (___mbf32_FPREG + 0),hl
  IF __CPU_INTEL__
    ex      de,hl
    ld      (___mbf32_FPREG + 2),hl
  ELSE
    ld      (___mbf32_FPREG + 2),de
  ENDIF
  IF !__CPU_INTEL__
    pop     hl
    push    ix
    push    hl
  ENDIF
ENDIF
    ret
