; uint __CALLEE__ write_callee(int fd, void *src, uint size)
; 06.2008 aralbrec

PUBLIC write_callee
PUBLIC ASMDISP_WRITE_CALLEE

EXTERN stdio_success_znc, stdio_error_ebadf_mc, stdio_error_eacces_mc, stdio_error_mc
EXTERN l_jpix, stdio_fdcommon1

INCLUDE "../stdio.def"

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

   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd

   bit 1,(ix+3)                ; open for writing?
   jp z, stdio_error_eacces_mc
   
   ld a,b                      ; writing 0 bytes is not an error
   or c
   jp z, stdio_success_znc
   
   ld l,c
   ld h,b                      ; hl = size
   ld a,STDIO_MSG_WRIT
   call l_jpix
   
   ret nc                      ; ret with hl = bytes written if success
   jp stdio_error_mc
   
defc ASMDISP_WRITE_CALLEE = # asmentry - write_callee
