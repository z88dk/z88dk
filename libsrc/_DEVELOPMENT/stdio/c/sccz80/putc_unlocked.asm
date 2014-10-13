
; int putc_unlocked(int c, FILE *stream)

SECTION seg_code_stdio

PUBLIC putc_unlocked

EXTERN fputc_unlocked

defc putc_unlocked = fputc_unlocked
