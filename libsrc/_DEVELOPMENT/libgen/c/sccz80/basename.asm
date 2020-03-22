; char *basename(char *path)

SECTION code_string

PUBLIC basename

EXTERN asm_basename

defc basename = asm_basename

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _basename
defc _basename = basename
ENDIF

