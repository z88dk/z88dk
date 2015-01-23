; int getchar(void)
; 06.2008 aralbrec

PUBLIC getchar

EXTERN fgetc
EXTERN ASMDISP_FGETC, _stdin

.getchar

   ld ix,(_stdin)
   jp fgetc + ASMDISP_FGETC
