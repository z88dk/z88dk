; common code

XLIB fd_common1

LIB stdio_error_ebadf_mc
LIB fd_fdtblindex

INCLUDE "stdio.def"

.fd_common1

   ld a,l
   cp MAXFILES
   jp nc, stdio_error_ebadf_mc
   
   call fd_fdtblindex          ; hl = entry in fdtbl

   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                    ; ix = fdstruct
   
   or ixl
   jp z, stdio_error_ebadf_mc  ; no fdstruct with given fd

   ret
