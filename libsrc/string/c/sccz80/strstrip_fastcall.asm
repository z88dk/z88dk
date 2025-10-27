
; char *strstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strstrip_fastcall

EXTERN asm_strstrip

defc strstrip_fastcall = asm_strstrip


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strstrip_fastcall
defc _strstrip_fastcall = strstrip_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strstrip_fastcall
defc ___strstrip_fastcall = strstrip_fastcall
ENDIF

