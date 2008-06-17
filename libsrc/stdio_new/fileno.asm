; int __FASTCALL__ fileno(FILE *stream)
; 06.2008 aralbrec

XLIB fileno
XDEF LIBDISP_FILENO

LIB stdio_error_ebadf_mc
XREF _fd_table

include "stdio.def"

.fileno

   ; enter : hl = FILE *
   ; exit  : hl = fd and carry reset for success
   ;         hl = -1 and carry set for fail
   ;         de used
   ; uses  : af, b, de, hl

   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = fdstruct *

.libentry

   ; hl = fdstruct *

   ld de,_fd_table
   ld b,MAXFILES               ; max number of files in fdtable[]
   
.loop

   ld a,(de)
   inc de
   cp l
   jr nz, notthisone
   
   ld a,(de)
   cp h
   jr z, success

.notthisone

   inc de
   djnz loop

   jp stdio_error_ebadf_mc

.success

   ld a,MAXFILES
   sub b
   ld l,a
   ld h,0
   ret

defc LIBDISP_FILENO = libentry - fileno
