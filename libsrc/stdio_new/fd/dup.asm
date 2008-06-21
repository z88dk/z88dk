; int __FASTCALL__ dup(int fd)
; 06.2008 aralbrec

XLIB dup

LIB fd_findslot, dup_common1, dup_common2
LIB stdio_error_enfile_mc, stdio_error_ebadf_mc

INCLUDE "stdio.def"

.dup

   ld e,l
   call fd_findslot
   jp c, stdio_error_enfile_mc ; fdtbl is full
   
   ld a,MAXFILES
   sub b
   ld c,a                      ; c = fd dst
   ld l,e                      ; l = fd src

   ld a,l
   cp MAXFILES
   jp nc, stdio_error_ebadf_mc ; src fd is out of range
   
   call dup_common1
   ret c

   ex de,hl
   jp dup_common2
