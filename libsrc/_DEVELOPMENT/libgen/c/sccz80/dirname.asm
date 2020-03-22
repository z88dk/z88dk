; char *dirname(char *path)

SECTION code_string

PUBLIC dirname

EXTERN asm_dirname

defc dirname = asm_dirname

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _dirname
defc _dirname = dirname
ENDIF

