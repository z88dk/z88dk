; char *basename_ext(char *path)

SECTION code_string

PUBLIC basename_ext

EXTERN asm_basename_ext

defc basename_ext = asm_basename_ext

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _basename_ext
defc _basename_ext = basename_ext
ENDIF

