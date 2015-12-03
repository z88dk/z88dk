
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlwr

EXTERN asm_strlwr

defc strlwr = asm_strlwr
