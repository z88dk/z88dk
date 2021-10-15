;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_add
EXTERN  __retloc

;primary = secondary + primary
;enter with secondary, primary on stack

.l_long_add
    pop     bc      ;Return address
    push    hl      ;Low word

    ld      hl,__retloc
    ld      (hl),c
    inc     hl
    ld      (hl),b
    pop     bc

    ld      hl,sp+0

    ld      a,(hl)
    add     c
    inc     hl
    ld      c,a

    ld      a,(hl)
    adc     a,b
    inc     hl
    ld      b,a

    ld      a,(hl)
    adc     a,e
    inc     hl
    ld      e,a

    ld      a,(hl)
    adc     a,d
    inc     hl
    ld      d,a
    ld      sp,hl

    ld      hl,__retloc
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    push    hl
    ld      hl,bc   ;get the lower 16 back into hl
    ret
