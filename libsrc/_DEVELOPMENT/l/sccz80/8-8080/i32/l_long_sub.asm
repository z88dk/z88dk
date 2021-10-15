;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_sub
EXTERN  __retloc


;primary = secondary - primary
;enter with secondary, primary on stack

.l_long_sub
    ex      (sp),hl
    ld      (__retloc),hl
    pop     bc

    ld      hl,sp   ;points to hl on stack

    ld      a,(hl)
    sub     c
    inc     hl
    ld      c,a

    ld      a,(hl)
    sbc     a,b
    inc     hl
    ld      b,a

    ld      a,(hl)
    sbc     a,e
    inc     hl
    ld      e,a

    ld      a,(hl)
    sbc     a,d
    inc     hl
    ld      d,a

    ld      sp,hl

    ld      hl,(__retloc)
    push    hl

    ld      hl,bc     ;get the lower 16 back into hl
    ret

