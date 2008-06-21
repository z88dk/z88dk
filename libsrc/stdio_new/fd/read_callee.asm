; uint __CALLEE__ read_callee(int fd, void *dst, uint size)
; 06.2008 aralbrec

XLIB read_callee
XDEF ASMDISP_READ_CALLEE

LIB stdio_error_ebadf_mc, stdio_success_znc, stdio_error_eacces_mc, stdio_error_mc
LIB fd_fdtblindex, l_jpix

INCLUDE "stdio.def"

.read_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : bc = uint size
   ;         de = void *dst
   ;          l = int fd
   ; exit  : hl = num bytes read, carry reset if success
   ;         hl = -1, carry set if fail

   ld a,l
   CP MAXFILES
   jp nc, stdio_error_ebadf_mc
   
   ld a,b                      ; reading 0 bytes is not an error
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

   bit 2,(ix+3)                ; open for reading?
   jp z, stdio_error_eacces_mc

   ld l,c
   ld h,b                      ; hl = size
   ld c,STDIO_MSG_READ
   call l_jpix
   
   ret nc                      ; ret with hl = bytes read if success
   jp stdio_error_mc

defc ASMDISP_READ_CALLEE = asmentry - read_callee
