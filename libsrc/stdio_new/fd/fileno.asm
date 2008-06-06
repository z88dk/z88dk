; int __FASTCALL__ fileno(FILE *stream)
; 06.2008 aralbrec

XLIB fileno
XDEF ASMDISP_FILENO
LIB l_jpix, stdio_error

INCLUDE "stdio.def"

.fileno

   push hl
   pop ix                      ; ix = FILE *

.asmentry

   ; enter : ix = FILE *
   ; exit  : hl = fd and carry reset if success
   ;         hl = -1 and carry set if fail

   bit 7,(ix+3)                ; check if FILE* is valid
   jp z, stdio_error
   
   ld c,STDIO_SERVICE_GETFD
   call l_jpix
   jp c, stdio_error
   
   ld l,a
   ld h,0
   ret

DEFC ASMDISP_FILENO = asmentry - fileno
