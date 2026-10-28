
; int fscanf_unlocked(FILE *stream, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _fscanf_unlocked

EXTERN asm_fscanf_unlocked

defc _fscanf_unlocked = asm_fscanf_unlocked
