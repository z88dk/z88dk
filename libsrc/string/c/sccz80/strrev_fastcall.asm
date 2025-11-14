
; char *strrev(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrev_fastcall

EXTERN asm_strrev

defc strrev_fastcall = asm_strrev


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrev_fastcall
defc _strrev_fastcall = strrev_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrev_fastcall
defc ___strrev_fastcall = strrev_fastcall
ENDIF

