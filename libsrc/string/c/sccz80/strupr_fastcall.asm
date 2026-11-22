
; char *strupr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strupr_fastcall

EXTERN asm_strupr

defc strupr_fastcall = asm_strupr


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strupr_fastcall
defc _strupr_fastcall = strupr_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strupr_fastcall
defc ___strupr_fastcall = strupr_fastcall
ENDIF

