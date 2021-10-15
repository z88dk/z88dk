;       Z88 Small C+ Run Time Library 
;       Long support functions
;       "8080" mode
;       Stefano - 30/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_ucmp
EXTERN __retloc
EXTERN __retloc2

; Unsigned compare of dehl (stack) and dehl (registers)
;
; Entry:    primary  = (under two return addresses on stack)
;           secondary= dehl
;
; Exit:     z = numbers the same
;           nz = numbers different
;           c/nc = sign of difference [set if secondary > primary]
;
; Code takes secondary from primary


.l_long_ucmp
    ex      (sp),hl
    ld      (__retloc),hl    ;first return
    pop     bc        ;low word
    pop     hl        ;second return value
    ld      (__retloc2),hl

    ld      hl,sp   ;points to hl on stack

    ld      a,(hl)
    sub     c
    ld      c,a
    inc     hl

    ld      a,(hl)
    sbc     a,b
    ld      b,a
    inc     hl

    ld      a,(hl)
    sbc     a,e
    ld      e,a
    inc     hl

    ld      a,(hl)
    sbc     a,d
    ld      d,a
    inc     hl

    ld      sp,hl

; ATP we have done the comparision and are left with dehl = result of
; primary - secondary, if we have a carry then secondary > primary

    jp      C,l_long_ucmp1

; Primary was larger, return nc
    ld      a,c
    or      b
    or      d
    or      e
    scf             ; Replace with and a?
    ccf
    jp      retloc

; Secondary was larger, return c
.l_long_ucmp1
    ld      a,c
    or      b
    or      d
    or      e
    scf
.retloc
    ; We need to preserve flags
    ld      hl,(__retloc2)
    push    hl
    ld      hl,(__retloc)
    push    hl

    ld      hl,1    ; Saves some mem in comparision unfunctions
    ret

