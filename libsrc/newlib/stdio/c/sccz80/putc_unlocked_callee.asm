
; int putc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC putc_unlocked_callee

EXTERN fputc_unlocked_callee

defc putc_unlocked_callee = fputc_unlocked_callee
