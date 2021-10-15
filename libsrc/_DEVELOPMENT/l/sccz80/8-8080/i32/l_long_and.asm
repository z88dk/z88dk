;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_long_and
EXTERN    __retloc

;Logical routines for long functions    dehl
;first opr on stack

.l_long_and
    ex      (sp),hl
    ld      (__retloc),hl
    pop     bc

    ld      hl,sp       ;points to hl on stack

    ld      a,c
    and     (hl)
    inc     hl
    ld      c,a

    ld      a,b
    and     (hl)
    inc     hl
    ld      b,a

    ld      a,e
    and     (hl)
    inc     hl
    ld      e,a

    ld      a,d
    and     (hl)
    inc     hl
    ld      d,a

    ld      sp,hl

    ld      hl,(__retloc)
    push    hl

    ld      l,c         ;get the lower 16 back into hl
    ld      h,b
    ret
