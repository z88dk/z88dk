; uint __CALLEE__ write_callee(int fd, void *src, uint size)
; 06.2008 aralbrec

XLIB write_callee
XDEF ASMDISP_WRITE_CALLEE

LIB stdio_error_ebadf_mc, stdio_success_znc, stdio_error_eacces_mc, stdio_error_mc
LIB fd_fdtblindex, l_jpix

INCLUDE "stdio.def"

.write_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : bc = uint size
   ;         de = void *src
   ;          l = int fd
   ; exit  : hl = num bytes written, carry reset if success
   ;         hl = -1, carry set if fail

   ld a,l
   CP MAXFILES
   jp nc, stdio_error_ebadf_mc
   
   ld a,b                      ; writing 0 bytes is not an error
   or c
   jp z, stdio_success_znc

   ld a,l
   call fd_fdtblindex          ; hl = entry in fdtbl
   
   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                    ; ix = fdstruct
   
   or ixl
   jp z, stdio_error_ebadf_mc  ; no fdstruct with given fd
   
   bit 1,(ix+3)                ; open for writing?
   jp z, stdio_error_eacces_mc
   
   ld l,c
   ld h,b                      ; hl = size
   ld c,STDIO_MSG_WRIT
   call l_jpix
   
   ret nc                      ; ret with hl = bytes written if success
   jp stdio_error_mc
   
defc ASMDISP_WRITE_CALLEE = asmentry - write_callee
