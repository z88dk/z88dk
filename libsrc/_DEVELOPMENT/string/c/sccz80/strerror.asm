
; char *strerror(int errnum)

SECTION code_clib
SECTION code_string

PUBLIC strerror

EXTERN asm_strerror

defc strerror = asm_strerror
