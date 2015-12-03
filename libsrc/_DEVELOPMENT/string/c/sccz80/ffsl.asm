
; int ffsl(long i)

SECTION code_clib
SECTION code_string

PUBLIC ffsl

EXTERN asm_ffsl

defc ffsl = asm_ffsl
