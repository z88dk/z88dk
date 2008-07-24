; int __CALLEE__ writebyte_callee(int fd, int c)
; 06.2008 aralbrec

XLIB writebyte_callee
XDEF ASMDISP_WRITEBYTE_CALLEE

LIB fd_common1, l_jpix, stdio_error_eacces_mc, stdio_error_mc, stdio_success_znc

INCLUDE "stdio.def"

.writebyte_callee

   pop hl
   pop bc
   ex (sp),hl
   ld b,c

.asmentry

   ; enter :  l = fd
   ;          b = char
   
   call fd_common1             ; ix = fdstruct
   ret c
   
   bit 1,(ix+3)                ; open for writing?
   jp z, stdio_error_eacces_mc

   ld c,STDIO_MSG_PUTC
   call l_jpix
   jp c, stdio_error_mc
   jp stdio_success_znc

defc ASMDISP_WRITEBYTE_CALLEE = asmentry - writebyte_callee
