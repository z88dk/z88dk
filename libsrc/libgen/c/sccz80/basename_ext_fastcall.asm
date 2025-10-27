
; char *basename_ext(char *s)

SECTION code_clib
SECTION code_string

PUBLIC basename_ext_fastcall

EXTERN asm_basename_ext

defc basename_ext_fastcall = asm_basename_ext


; SDCC bridge for Classic
IF __CLASSIC && !__CPU_GBZ80__
PUBLIC _basename_ext_fastcall
defc _basename_ext_fastcall = basename_ext_fastcall
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___basename_ext_fastcall
defc ___basename_ext_fastcall = basename_ext_fastcall
ENDIF

