; void curs_vline_callee(uint x, uint y)
; 09.2024 stefano

    SECTION code_clib
    PUBLIC  curs_vline_callee
    PUBLIC  _curs_vline_callee
    PUBLIC  asm_curs_vline

    EXTERN  __console_x
    EXTERN  __console_y
    EXTERN  fputc_cons


curs_vline_callee:
_curs_vline_callee:

    pop     hl
    pop     de                          ; n
    pop     bc                          ; ch
    push    hl

asm_curs_vline:

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
  ENDIF

    ld      b, e
    ld      a, (__console_x)
    ld      e, a
    ld      a, (__console_y)
    ld      d, a

curs_vline_loop:
    push    de
    push    bc
    ld      a, e
    ld      (__console_x), a
    ld      a, d
    ld      (__console_y), a
    call    fputc_cons
    pop     bc
    pop     de
    inc     d
    djnz    curs_vline_loop

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF

    ret
