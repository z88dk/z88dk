

	SECTION		code_fp_mbf32

	PUBLIC		modf
	EXTERN		floor
	EXTERN		ceil
	EXTERN		msbios
	EXTERN		___mbf32_SUBCDE
	EXTERN		___mbf32_FPREG
	EXTERN		l_glong
	EXTERN		___mbf32_return

; double modf(double value, double *iptr)
modf:
    ld      hl,4
    add     hl,sp
    call    l_glong
IF __CPU_INTEL__
    ld      a,e
    rra
    jp      c,isnegative
ELSE
    bit     7,e
    jr      nz,isnegative
ENDIF
    push    de
    push    hl	
    call    floor
    pop     bc
    pop     bc
    jr      rejoin
isnegative:
    push    de
    push    hl
    call    ceil
    pop     bc
    pop     bc
rejoin:
    ld      c,l
    ld      b,h
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    ; Now store the float
    ld      (hl),c
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
IF __CPU_INTEL__
    ex      de,hl
    ld      (___mbf32_FPREG+2),hl
    ld      l,c
    ld      h,b
    ld      (___mbf32_FPREG),hl
ELIF __CPU_GBZ80__
    ld      hl,___mbf32_FPREG
    ld      (hl),c
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
ELSE
    ld      (___mbf32_FPREG),bc
    ld      (___mbf32_FPREG+2),de
ENDIF
    ld      hl,4
    add     hl,sp	
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
IF __CPU_INTEL__
    call    ___mbf32_SUBCDE
    ld      hl,(___mbf32_FPREG+2)
    ex      de,hl
    ld      hl,(___mbf32_FPREG)
ELIF __CPU_GBZ80__
    call    ___mbf32_SUBCDE
    ld      hl,___mbf32_FPREG+3
    ld      d,(hl)
    dec     hl
    ld      e,(hl)
    dec     hl
    ld      a,(hl-)
    ld      l,(hl)
    ld      h,a
ELSE
    push    ix
    ld      ix,___mbf32_SUBCDE
    call    msbios
    pop     ix
    ld      hl,(___mbf32_FPREG)
    ld      de,(___mbf32_FPREG+2)
ENDIF
    ; Now flip the sign
    ld      a,e
    xor     $80
    ld      e,a
    ret
	

