
; char *dirname(char *s)

SECTION code_clib
SECTION code_string

PUBLIC dirname_fastcall

EXTERN asm_dirname

defc dirname_fastcall = asm_dirname


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _dirname_fastcall
defc _dirname_fastcall = dirname_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___dirname_fastcall
defc ___dirname_fastcall = dirname_fastcall
ENDIF

