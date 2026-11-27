; sccz80 crt0 library - 8080 version
; The low 64 bits of a product do not depend on the signs

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mult

EXTERN  l_i64_mult_u

defc l_i64_mult = l_i64_mult_u
