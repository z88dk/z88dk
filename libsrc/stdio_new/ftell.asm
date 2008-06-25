; long __FASTCALL__ ftell(FILE *stream)
; 06.2008 aralbrec

XLIB ftell
XDEF ASMDISP_FTELL

LIB stdio_error_mc, l_declong, l_jpix

INCLUDE "stdio.def"

.ftell

   push hl
   pop ix                      ; ix = FILE *

.asmentry

   ; enter : ix = FILE *
   ; exit  : dehl = file position and carry reset for success
   ;         dehl = -1 and carry if fail

   ld b,0                      ; report file pos, no change
   ld c,STDIO_MSG_SEEK
   call l_jpix
   jr c, error

   bit 0,(ix+3)                ; if an unget char is pending
   jp nz, l_declong            ;  decrement file position
   
   ret

.error

   call stdio_error_mc
   ld e,l
   ld d,h
   
   ret

defc ASMDISP_FTELL = asmentry - ftell
