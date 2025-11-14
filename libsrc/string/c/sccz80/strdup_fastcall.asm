
; char *strdup(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strdup_fastcall

EXTERN asm_strdup

defc strdup_fastcall = asm_strdup


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strdup_fastcall
defc _strdup_fastcall = strdup_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strdup_fastcall
defc ___strdup_fastcall = strdup_fastcall
ENDIF

