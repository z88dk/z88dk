    MODULE  sprintff_outc
    SECTION code_clib

IF __CPU_Z80__
    PUBLIC  sprintff_outc     
    EXTERN  fputc_cons

    EXTERN  __far_start
    EXTERN  __far_end
    EXTERN  __far_page
    EXTERN  l_far_incptrs

; Output a character to a string - __far version
sprintff_outc:
    pop     bc
    pop     hl     ;fp
    pop     de     ;character
    push    bc
    push    ix     ;save ix
    push    hl     ;get fp into ix
    pop     ix

    call    __far_start
    ex      af,af

    ld      bc,(ix+4)   ;Length remaining
    ld      a,c
    or      b
    jr      z,no_space
    dec     bc          ;reduce space
    ld      (ix+4),bc
    exx
    ld      bc,(ix+0)   ;pick up far pointer
    ld      e,(ix+2)
    ld      d,0
    call    __far_page  ;page it in
    exx
    ld      a,b         ;make sure we can terminate within the buffer
    or      c
    jr      z,just_terminate    ;no space, just drop a \0 on the current positon
    ld      a,e         ;Load up the character we need to print
    exx
    ld      (hl),a      ;Print it
    call    l_far_incptrs
    ld      (ix+0),bc   ;Store the incremented __far pointer for next time
    ld      (ix+2),e
    exx
just_terminate:
    exx
    ld      (hl),0
no_space:
    ex      af,af
    call    __far_end
    pop     ix
    ret
ENDIF
