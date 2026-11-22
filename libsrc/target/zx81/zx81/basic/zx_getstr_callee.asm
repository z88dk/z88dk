;
;   ZX 81 specific routines
;   by Stefano Bodrato, Oct 2007
;
;   Copy a variable from basic
;
;   int __CALLEE__ zx_getstr_callee(char variable, char *value);
;
;
;   $Id: zx_getstr_callee.asm $
;

    SECTION code_clib
    PUBLIC  zx_getstr_callee
    PUBLIC  _zx_getstr_callee
    PUBLIC  asm_zx_getstr
    EXTERN  zx81toasc

zx_getstr_callee:
_zx_getstr_callee:

    pop     bc
    pop     hl
    pop     de
    push    bc

; enter : hl = char *value
;          e = char variable

asm_zx_getstr:
    push    ix                          ;save callers ix (iy on zx81) - rom may corrupt it

    ld      a, e

    and     31
    add     69

    ld      d, a
    push    hl                          ; save destination

    ld      hl, ($4010)                 ; VARS

loop:
    ld      a, (hl)
    cp      128
    jr      z, notfound                 ;  n.b. z => nc

    cp      d
    jr      z, found

    push    de
  IF    FORlambda
    EXTERN  __lambda_next_one
    call    __lambda_next_one
  ELSE
    call    $09F2                       ;get next variable start
  ENDIF
    ex      de, hl
    pop     de
    jr      loop


found:
    inc     hl
    ld      c, (hl)
    ld      a, c
    inc     hl
    ld      b, (hl)
    or      b
    inc     hl

    pop     de
    jr      z, zerolen
;    ldir
;-----------------------------
outloop:
    call    zx81toasc
    ld      (de), a
    inc     hl
    inc     de
    dec     bc
    ld      a, b
    or      c
    jr      nz, outloop
;------------------------------
zerolen:
    pop     ix
    xor     a
    ld      (de), a
    ld      h, a
    ld      l, a
    ret

notfound:
    pop     hl
    pop     ix
    ld      hl, -1
    ret
