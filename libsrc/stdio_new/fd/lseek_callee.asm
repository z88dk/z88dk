; long __CALLEE__ lseek_callee(int fd, long offset, int whence)
; 06.2008 aralbrec

XLIB lseek_callee
XDEF ASMDISP_LSEEK_CALLEE

LIB stdio_error_mc, l_jpix, fd_common1

INCLUDE "stdio.def"

.lseek_callee

   pop af
   pop bc
   pop de
   pop hl
   exx
   pop hl
   push af

.asmentry

   ; enter :     c' = whence
   ;         de'hl' = offset
   ;             l  = fd
   ; exit  : dehl = new file pos, carry reset
   ;         dehl = -1, carry set for fail

   call fd_common1             ; ix = fdstruct
   jr c, error

   exx
   ld b,c
   ld c,STDIO_MSG_SEEK
   call l_jpix
   ret nc
   
   call stdio_error_mc

.error

   ld e,l
   ld d,h
   ret

defc ASMDISP_LSEEK_CALLEE = asmentry - lseek_callee
