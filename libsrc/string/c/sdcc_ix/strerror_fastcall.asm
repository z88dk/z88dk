
; char *strerror_fastcall(int errnum)

SECTION code_clib
SECTION code_string

PUBLIC _strerror_fastcall

EXTERN asm_strerror

defc _strerror_fastcall = asm_strerror
