
; int putc_unlocked(int c, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC putc_unlocked

EXTERN fputc_unlocked

defc putc_unlocked = fputc_unlocked
