;  Query analog paddle values


        SECTION code_clib
        PUBLIC    paddle
        PUBLIC    _paddle

        EXTERN  __nabu_p1

.paddle
._paddle
    ;__FASTCALL__ : paddle no. in HL
    ld      a,l
    ld      hl,0
    cp      0
    ret     z
    dec     a
    and     7
    ld      hl,__nabu_p1
    add     a,l
    ld      l,a
    adc     a,h
    sub     l
    ld      h,a
    ld      l,(hl)
    ld      h,0
    ret
