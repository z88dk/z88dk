; int __FASTCALL__ fgetc(FILE *stream)
; 05.2008 aralbrec

PUBLIC fgetc
PUBLIC ASMDISP_FGETC
EXTERN l_jpix, stdio_error_mc, stdio_error_eacces_mc

INCLUDE "../stdio.def"

.fgetc

   push hl
   pop ix

.asmentry

   ; enter : ix = FILE *
   ; exit  : a = hl = char and carry reset for success
   ;         hl = -1 and carry set for fail
   ; uses  : af, bc, de, hl

   bit 2,(ix+3)                ; open for input?
   jp z, stdio_error_eacces_mc

   bit 0,(ix+3)                ; is an unget char available?
   jr z, readfromstream

   ld l,(ix+4)
   ld h,0                      ; hl = unget char  
   res 0,(ix+3)                ; unget char no longer available
   
   ld a,l
   or a
   ret

.readfromstream

   ld a,STDIO_MSG_GETC
   call l_jpix
   jp c, stdio_error_mc
   
   ld l,a
   ld h,0
   ret

defc ASMDISP_FGETC = # asmentry - fgetc
