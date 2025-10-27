
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrstrip_fastcall

EXTERN asm_strrstrip

defc strrstrip_fastcall = asm_strrstrip


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strrstrip_fastcall
defc _strrstrip_fastcall = strrstrip_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrstrip_fastcall
defc ___strrstrip_fastcall = strrstrip_fastcall
ENDIF

