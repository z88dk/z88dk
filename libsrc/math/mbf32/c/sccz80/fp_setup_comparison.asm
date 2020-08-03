

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_comparison
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP
	EXTERN		___mbf32_CMPNUM
	EXTERN		msbios
	EXTERN		___mbf32_shuffle_temp



; Put the two arguments into the required places
;
; This is for comparison routines, where we need to use 
; double precision values (so pad them out)
;
; Entry: dehl = right hand operand
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbf32_setup_comparison:
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
    ld      hl,___mbf32_shuffle_temp
    pop     de      ;Return address
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     hl      ;Callee return
    pop     de      ;Left LSW
    pop     bc      ;Left MSW
    push    hl
    ld      hl,___mbf32_shuffle_temp
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    push    hl

ELSE
    ; The right value needs to go into FPREG
    ld      (___mbf32_FPREG + 0),hl
  IF __CPU_INTEL__
    ex      de,hl
    ld      (___mbf32_FPREG + 2),hl
  ELSE
    ld      (___mbf32_FPREG + 2),de
  ENDIF
  IF __CPU_INTEL__
    pop     hl
    ld      (___mbf32_shuffle_temp),hl
  ELSE
    pop     af		;Return address
  ENDIF
    pop     hl		;Caller return address
    pop     de		;Left LSW
    pop     bc		;Left MSW
    push    hl

  IF __CPU_INTEL__
    ld      hl,(___mbf32_shuffle_temp)
    push    hl
  ELSE
    push    af		;Our return address
  ENDIF
ENDIF

IF __CPU_INTEL__ || __CPU_GBZ80__
    call    ___mbf32_CMPNUM
ELSE
    push    ix
    ld      ix,___mbf32_CMPNUM
    call    msbios
    pop     ix
ENDIF
    ret
