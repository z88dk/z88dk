; long __CALLEE__ lseek_callee(int fd, long offset, int whence)
; 06.2008 aralbrec

XLIB lseek_callee
XDEF ASMDISP_LSEEK_CALLEE

LIB l_jpix, stdio_fdcommon1
LIB stdio_error_ebadf_mc, stdio_error_mc

INCLUDE "../stdio.def"

.lseek_callee

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   push af

.asmentry

   ; enter :     c' = whence
   ;         de'hl' = offset
   ;             l  = fd
   ; exit  : dehl = new file pos, carry reset
   ;         dehl = -1, carry set for fail
   
   call stdio_fdcommon1        ; ix = fdstruct *
   jp nc, cont
   
   call stdio_error_ebadf_mc   ; problem with fd
   ld e,l
   ld d,h
   ret

.cont

   exx
   ld a,STDIO_MSG_SEEK
   call l_jpix
   ret nc
   
   call stdio_error_mc
   ld e,l
   ld d,h
   ret

defc ASMDISP_LSEEK_CALLEE = asmentry - lseek_callee
