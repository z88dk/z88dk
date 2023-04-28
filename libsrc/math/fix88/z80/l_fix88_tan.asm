;
; Z80 fixed Q8.8 maths routines
;


    SECTION code_math
    PUBLIC  l_fix88_tan

    EXTERN  l_fix88_sin
    EXTERN  l_fix88_cos
    EXTERN  l_fix88_div


; Entry: h.l = Q8.8 number
; Exit:  h.l = tan of it
;
; tan x = sin x / cos x
l_fix88_tan:
    push    hl
    call    l_fix88_sin
    ex      (sp),hl
    call    l_fix88_cos
    ex      de,hl
    pop     hl
    jp      l_fix88_div
