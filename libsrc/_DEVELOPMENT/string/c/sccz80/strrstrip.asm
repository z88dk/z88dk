
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrstrip

EXTERN asm_strrstrip

defc strrstrip = asm_strrstrip

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstrip
defc _strrstrip = strrstrip
ENDIF

