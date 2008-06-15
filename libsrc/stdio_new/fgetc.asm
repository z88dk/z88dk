; int __FASTCALL__ fgetc(FILE *stream)
; 05.2008 aralbrec

XLIB fgetc
XDEF ASMDISP_FGETC
LIB l_jpix, stdio_error

INCLUDE "stdio.def"

.fgetc

   push hl
   pop ix

.asmentry

   ; enter : ix = FILE *
   ; exit  : hl = char and carry reset for success
   ;         hl = -1 and carry set for fail
   ; uses  : af, bc, de, hl, ix

   bit 2,(ix+3)                ; open for input?
   jp z, stdio_error

   bit 0,(ix+3)                ; is an unget char available?
   jr z, readfromstream

   ld l,(ix+4)
   ld h,0                      ; hl = unget char  
   res 0,(ix+3)                ; unget char no longer available
   or a
   ret

.readfromstream

   ld c,STDIO_MSG_GETC
   call l_jpix
   jp c, stdio_error
   
   ld l,a
   ld h,0
   ret

defc ASMDISP_FGETC = asmentry - fgetc
