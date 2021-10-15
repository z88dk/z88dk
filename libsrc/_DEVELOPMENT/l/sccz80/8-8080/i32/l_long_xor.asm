;       Z88 Small C+ Run Time Library 
;       Long functions
;       "8080" mode
;       Stefano - 29/4/2002
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_xor
EXTERN    __retloc

;Logical routines for long functions    dehl
;first opr on stack


; "xor" deHL' and dehl into HLde'
.l_long_xor
    ex (sp),hl
    ld (__retloc),hl
    pop bc

    ld hl,sp   ;points to hl on stack

    ld a,c
    xor (hl)
    inc hl
    ld c,a

    ld a,b
    xor (hl)
    inc hl
    ld b,a

    ld a,e
    xor (hl)
    inc hl
    ld e,a

    ld a,d
    xor (hl)
    inc hl
    ld d,a

    ld sp,hl

    ld hl,(__retloc)
    push hl

    ld hl,bc      ;get the lower 16 back into hl
    ret
