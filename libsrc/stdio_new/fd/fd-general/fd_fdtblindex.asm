; fd_fdtblindex
; 06.2008 aralbrec

XLIB fd_fdtblindex
XREF _fdtbl

.fd_fdtblindex

   ; find fdstruct entry in fdtbl corresponding to fd number
   ;
   ; enter :  a = fd
   ; exit  : hl = & fdtbl[fd]
   
   add a,a
   add a,_fdtbl % 256
   ld l,a
   ld h,_fdtbl / 256
   ret nc
   inc h
   ret
