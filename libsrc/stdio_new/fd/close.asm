; int __FASTCALL__ close(int fd)
; 06.2008 aralbrec

XLIB close
XDEF LIBDISP_CLOSE

LIB stdio_free, l_jphl, fclose, fd_fdtblindex
LIB stdio_success_znc, stdio_error_ebadf_mc, stdio_error_mc
XREF LIBDISP_FCLOSE

INCLUDE "stdio.def"

.close

   ; 1. lookup fdstruct in fdtbl
   ;
   ;  l = fd

   ld a,l
   cp MAXFILES
   jp nc, stdio_error_ebadf_mc
   
   call fd_fdtblindex          ; hl = fdtable entry for fd

   ld e,(hl)
   ld (hl),0                   ; zero out the fdtable entry
   inc hl
   ld a,(hl)
   ld (hl),0
   ld d,a                      ; de = fdstruct associated with fd

   or e                        ; if fdstruct==0 the fd is not used
   jp z, stdio_error_ebadf_mc
   
   ; 2. reduce reference count
   ;
   ; de = fdstruct

.libentry
.closefdstruct

   ld hl,5
   add hl,de                   ; hl = fdstruct.refcount
   dec (hl)                    ; refcount--
   jp nz, stdio_success_znc    ; if refcount did not reach zero, all done!
   
   ; 3. dup fd gets special treatment
   ;
   ; hl = fdstruct.refcount
   ; de = fdstruct
   
   dec hl
   dec hl
   bit 7,(hl)                  ; is this a dup fd?
   jr z, closedev              ; if not need to send close message
   
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = fdstruct of dup
   
   push hl
   ex de,hl
   call stdio_free             ; free the dup fdstruct
   pop hl                      ; next fdstruct to close

   jp fclose + LIBDISP_FCLOSE
   
.closedev

   ; 4. send close message to device / filter
   ;
   ; de = fdstruct
   
   push de
   ex de,hl
   ld c,STDIO_MSG_CLOS
   call l_jphl
   pop hl
   jr c, dev_error             ; device indicates close error
   
   ; 5. release memory taken by fdstruct
   ; 
   ; hl = fdstruct
   
   call stdio_free
   jp stdio_success_znc

.dev_error

   call stdio_free
   jp stdio_error_mc

defc LIBDISP_CLOSE = libentry - close
