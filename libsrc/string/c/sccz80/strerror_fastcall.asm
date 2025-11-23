
; char *strerror(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strerror_fastcall

EXTERN asm_strerror

defc strerror_fastcall = asm_strerror


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strerror_fastcall
defc _strerror_fastcall = strerror_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strerror_fastcall
defc ___strerror_fastcall = strerror_fastcall
ENDIF

