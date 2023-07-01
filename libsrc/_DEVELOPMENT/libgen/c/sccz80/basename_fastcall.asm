
; char *basename(char *s)

SECTION code_clib
SECTION code_string

PUBLIC basename_fastcall

EXTERN asm_basename

defc basename_fastcall = asm_basename


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _basename_fastcall
defc _basename_fastcall = basename_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___basename_fastcall
defc ___basename_fastcall = basename_fastcall
ENDIF

