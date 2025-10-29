    MODULE  sprintf_outc
    SECTION code_clib

    PUBLIC  sprintf_outc     
    EXTERN  fputc_cons

IF __CPU_INTEL__ | __CPU_GBZ80__
sprintf_outc:
    pop     bc
    pop     hl      ;fp
    pop     de      ;character
    push    bc

    inc     hl      ;+1
    inc     hl      ;+2
    ld      c,(hl)
    inc     hl      ;+3
    ld      b,(hl)
    ld      a,b
    or      c
    ret     z
    dec     bc
    ld      (hl),b
    dec     hl      ;+2
    ld      (hl),c
    dec     hl      ;+1
    ld      a,(hl)
    dec     hl      ;+0
    push    hl      ;save fp
    ld      l,(hl)
    ld      h,a
    ld      a,b
    or      c
    jr      z,just_terminate
    ld      (hl),e
    inc     hl
just_terminate:
    ld      (hl),0
    pop     de
    ex      de,hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ret
ELSE
sprintf_outc:
    pop     bc
    pop     hl     ;fp
    pop     de     ;charcter
    push    bc
    push    ix     ;save ix
IF __CPU_RABBIT__
    ld      ix,hl
ELSE
    push    hl    ;get fp into ix
    pop     ix
ENDIF

    ld      bc,(ix+2)
    ld      a,c
    or      b
    jr      z,no_space
    dec     bc    ;reduce space
    ld      (ix+2),bc
    ld      hl,(ix+0)
    ld      a,b   ;make sure we can terminate
    or      c
    jr      z,just_terminate
    ld      (hl),e
    inc     hl
just_terminate:
    ld      (hl),0
    ld      (ix+0),hl
no_space:
    pop     ix
    ret
ENDIF
