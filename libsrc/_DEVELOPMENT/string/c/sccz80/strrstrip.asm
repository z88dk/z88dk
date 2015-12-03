
; char *strrstrip(char *s)

SECTION code_clib
SECTION code_string

PUBLIC strrstrip

EXTERN asm_strrstrip

defc strrstrip = asm_strrstrip
