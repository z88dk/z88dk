; void gotoxy_callee(uint x, uint y)
; 09.2017 stefano

    SECTION code_clib
    PUBLIC  gotoxy_callee
    PUBLIC  _gotoxy_callee
    PUBLIC  asm_gotoxy

    EXTERN  __console_x
    EXTERN  __console_y

gotoxy_callee:
_gotoxy_callee:

    pop     hl
    pop     de
    pop     bc
    push    hl

asm_gotoxy:
    ld      hl,__console_x
    ; c = x    e = y
    ld      (hl),c
    inc     hl
    ld      (hl),e
    ret
