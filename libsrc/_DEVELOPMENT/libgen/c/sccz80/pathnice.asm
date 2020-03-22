; char *pathnice(char *path)

SECTION code_string

PUBLIC pathnice

EXTERN asm_pathnice

defc pathnice = asm_pathnice

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pathnice
defc _pathnice = pathnice
ENDIF

