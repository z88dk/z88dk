
; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlwr_fastcall

EXTERN asm_strlwr

defc strlwr_fastcall = asm_strlwr


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlwr_fastcall
defc _strlwr_fastcall = strlwr_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strlwr_fastcall
defc ___strlwr_fastcall = strlwr_fastcall
ENDIF

