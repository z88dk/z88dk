
; int putc(int c, FILE *stream)

XLIB putc

LIB fputc

;defc putc = fputc

putc:

   jp fputc
