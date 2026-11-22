;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_mult
PUBLIC  l_long_mult_u

EXTERN  l_mult_0
EXTERN  l_mult_ulong_0

;result = primary * secondary
;enter with secondary in dehl, primary on stack
;exit with product in dehl

.l_long_mult
.l_long_mult_u
    push    de                  ;put secondary on stack
    push    hl

    ld      bc,hl               ;secondary LSW

    ld      de,sp+6             ;primary LSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_ulong_0      ;dehl = de * bc

    push    hl                  ;result LSW
    push    de                  ;partial result MSW

    ld      de,sp+12            ;primary MSW offset
    ld      hl,(de)

    ld      a,h                 ;check for primary MSW zero
    or      l
    jp      Z,demoted_prim      ;primary MSW is zero

    ld      bc,hl

    ld      de,sp+4             ;secondary LSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc
    push    hl

.demoted_prim
    ld      de,sp+6             ;secondary MSW offset
    ld      hl,(de)

    ld      a,h                 ;check for secondary MSW zero
    or      l
    jp      Z,demoted_sec       ;secondary MSW is zero

    ld      bc,hl

    ld      de,sp+10            ;primary LSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc               ;result MSW
    push    hl

.demoted_sec
    ld      de,sp+8             ;get return from stack
    ld      hl,(de)
    ld      de,sp+12            ;place return on stack
    ld      (de),hl

    pop     hl                  ;result MSW
    pop     bc                  ;result LSW

    ld      de,sp+8             ;point to return again
    ex      de,hl               ;result MSW <> return sp
    ld      sp,hl               ;remove stacked parameters

    ld      hl,bc               ;result LSW
    ret
