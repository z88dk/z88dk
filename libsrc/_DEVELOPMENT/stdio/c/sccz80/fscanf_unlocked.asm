
; int fscanf_unlocked(FILE *stream, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC fscanf_unlocked

EXTERN asm_fscanf_unlocked

defc fscanf_unlocked = asm_fscanf_unlocked
