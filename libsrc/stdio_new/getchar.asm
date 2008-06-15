; int getchar(void)
; 06.2008 aralbrec

XLIB getchar

LIB fgetc
XREF ASMDISP_FGETC, _stdin

.getchar

   ld ix,(_stdin)
   jp fgetc + ASMDISP_FGETC
