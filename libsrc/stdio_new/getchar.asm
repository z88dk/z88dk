; int getchar(void)
; 06.2008 aralbrec

XLIB getchar

LIB fgetc
XREF _stdin, ASMDISP_FGETC

.getchar

   ld ix,(_stdin)
   jp fgetc + ASMDISP_FGETC
