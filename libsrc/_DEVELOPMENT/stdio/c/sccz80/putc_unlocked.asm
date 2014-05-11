
; int putc_unlocked(int c, FILE *stream)

PUBLIC putc_unlocked

EXTERN fputc_unlocked

;defc putc_unlocked = fputc_unlocked

putc_unlocked:

   jp fputc_unlocked
