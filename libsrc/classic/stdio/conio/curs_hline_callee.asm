; void curs_hline_callee(uint x, uint y)
; 09.2024 stefano

    SECTION code_clib
    PUBLIC  curs_hline_callee
    PUBLIC  _curs_hline_callee
    PUBLIC  asm_curs_hline

    EXTERN  __console_x
    EXTERN  __console_y
    EXTERN  fputc_cons


curs_hline_callee:
_curs_hline_callee:

    pop     hl
    pop     de                          ; n
    pop     bc                          ; ch
    push    hl

asm_curs_hline:

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
  ENDIF

    ld      b, e
    ld      a, (__console_x)
    ld      e, a
    ld      a, (__console_y)
    ld      d, a

curs_hline_loop:
    push    de
    push    bc
    ld      a, e
    ld      (__console_x), a
    ld      a, d
    ld      (__console_y), a
    call    fputc_cons
    pop     bc
    pop     de
    inc     e
    djnz    curs_hline_loop

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF

    ret
