;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_mult

EXTERN  l_mult_0
EXTERN  l_mult_ulong_0

;primary = secondary * primary
;enter with secondary in dehl, primary on stack
;exit with product in dehl
.l_long_mult
    pop     bc                  ;get return
    push    de                  ;put secondary on stack
    push    hl
    push    bc                  ;replace return

    ld      bc,hl               ;secondary LSW

    ld      de,sp+6             ;primary LSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_ulong_0      ;dehl = de * bc

    pop     bc                  ;get return
    push    hl                  ;result LSW
    push    bc                  ;push return
    push    de                  ;partial result MSW

    ld      de,sp+6             ;secondary LSW offset
    ld      hl,(de)
    ld      bc,hl

    ld      de,sp+12            ;primary MSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc
    push    hl

    ld      de,sp+8             ;secondary MSW offset
    ld      hl,(de)
    ld      bc,hl

    ld      de,sp+10            ;primary LSW offset
    ld      hl,(de)
    ex      de,hl

    call    l_mult_0            ;hl = de * bc

    pop     bc                  ;partial result MSW
    add     hl,bc               ;result MSW

    ex      (sp),hl             ;result MSW <> return

    ld      de,sp+10            ;place return on stack
    ld      (de),hl

    pop     hl                  ;result MSW
    pop     bc                  ;result LSW

    ld      de,sp+6             ;point to return again
    ex      de,hl               ;result MSW <> return sp
    ld      sp,hl               ;remove stacked parameters

    ld      hl,bc               ;result LSW
    ret
