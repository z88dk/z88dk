
; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC strlen_fastcall

EXTERN asm_strlen

defc strlen_fastcall = asm_strlen

; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _strlen_fastcall
defc _strlen_fastcall = strlen_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strlen_fastcall
defc ___strlen_fastcall = strlen_fastcall
ENDIF

