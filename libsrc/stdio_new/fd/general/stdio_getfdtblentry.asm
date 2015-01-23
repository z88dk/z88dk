; stdio_getfdtblentry
; 07.2009 aralbrec

PUBLIC stdio_getfdtblentry
EXTERN _stdio_fdtbl

; return address of table entry holding fd struct address
;
; enter :  a = fd
; exit  : hl = & stdio_fdtbl[fd], carry reset
;         carry set if fd out of range
; uses  : af, hl

INCLUDE "../../stdio.def"

.stdio_getfdtblentry

   cp STDIO_NUMFD
   ccf
   ret c
   
   add a,a
   add a,_stdio_fdtbl % 256
   ld l,a
   ld h,_stdio_fdtbl / 256
   ret nc
   inc h
   or a
   ret
