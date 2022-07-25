
SECTION code_fp_math32

PUBLIC  m32_fabs_fastcall
PUBLIC _m32_fabsf


._m32_fabsf
.m32_fabs_fastcall
    ld a,d
    and $7f         ;reset sign bit
    ld d,a
    ret
