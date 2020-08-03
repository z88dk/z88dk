

        SECTION         code_fp_mbf32

	PUBLIC		___mbf32_return

	EXTERN		___mbf32_FPREG

; Return the value that's in the DAC
___mbf32_return:
IF __CPU_GBZ80__
    ld      hl,___mbf32_FPREG+3
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    dec     hl
    ld      a,(hl-)
    ld      l,(hl)
    ld      h,a
    ret
ELSE
  IF __CPU_INTEL__
    ld      hl,(___mbf32_FPREG+2)
    ex      de,hl
  ELSE
    pop     ix
    ld      de,(___mbf32_FPREG+2)
  ENDIF
    ld      hl,(___mbf32_FPREG)
    ret
ENDIF