
; char *strerror(int errnum)

SECTION code_clib
SECTION code_string

PUBLIC strerror

EXTERN asm_strerror

defc strerror = asm_strerror

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strerror
defc _strerror = strerror
ENDIF

