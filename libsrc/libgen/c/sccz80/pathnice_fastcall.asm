
; char *pathnice(char *s)

SECTION code_clib
SECTION code_string

PUBLIC pathnice_fastcall

EXTERN asm_pathnice

defc pathnice_fastcall = asm_pathnice


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _pathnice_fastcall
defc _pathnice_fastcall = pathnice_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___pathnice_fastcall
defc ___pathnice_fastcall = pathnice_fastcall
ENDIF

