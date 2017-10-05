
; char *strupr(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strupr

EXTERN asm_strupr

defc strupr = asm_strupr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strupr
defc _strupr = strupr
ENDIF

