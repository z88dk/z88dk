; int __FASTCALL__ close(int fd)
; 07.2009 aralbrec

PUBLIC close
PUBLIC LIBDISP_CLOSE, LIBDISP2_CLOSE

EXTERN stdio_fdcommon1, l_jpix, stdio_findfdstruct, stdio_free
EXTERN stdio_success_znc, stdio_error_ebadf_mc

INCLUDE "../stdio.def"

; enter :  l = fd to close
; exit  : hl = 0, carry reset for success
;         hl =-1, carry set for fail

.close

   ; 1. locate fdstruct in fdtbl
   
   call stdio_fdcommon1
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   ; 2. remove fd from fdtbl
   ;
   ; ix = fdstruct *
   ; hl = & stdio_fdtbl[fd] + 1

.libentry2

   ld (hl),0
   dec hl
   ld (hl),0

.libentry
.loop

   ; 3. reduce reference count
   ; 
   ; ix = fdstruct *
   
   dec (ix+4)
   jp nz, stdio_success_znc    ; if refcount did not reach zero, all done!
  
   ; 4. send close message to filter or device
   ; 
   ; ix = fdstruct *
   
   bit 7,(ix+3)                ; is this a dup fd?  
   
   ld a,STDIO_MSG_CLOS
   call z, l_jpix              ; send close message but only if not a dup fd
   
   ; 5. find fdtbl entry corresponding to fdstruct
   ;
   ; ix = fdstruct *
   
   call stdio_findfdstruct     ; hl = & stdio_fdtbl[fd] + 1
   jr c, not_in_fdtbl
   
   ; 6. remove fdstruct from fdtbl
   ;
   ; ix = fdstruct *
   ; hl = & stdio_fdtbl[fd] + 1

   ld (hl),0
   dec hl
   ld (hl),0

.not_in_fdtbl

   ; 7. if dup / filter record next fdstruct
   ;
   ; ix = fdstruct *
   
   bit 7,(ix+3)                ; is this a dup fd?
   jr z, not_dup_fd
   
   ld l,(ix+1)
   ld h,(ix+2)                 ; hl = connected fdstruct
   
   jp rejoin

.not_dup_fd

   bit 6,(ix+3)                ; is it a filter fd?
   jr z, driver_fd
   
   ld l,(ix+6)
   ld h,(ix+7)                 ; hl = connected fdstruct

.rejoin

   ; 8. free fdstruct memory
   ;
   ; ix = fdstruct *
   ; hl = connected fdstruct
   
   push ix
   ex (sp),hl                  ; hl = fdstruct *
   call stdio_free
   pop ix                      ; ix = connected fdstruct *
   
   ; 9. close connected fdstruct
   ;
   ; ix = connected fdstruct *
   
   jp loop

.driver_fd

   ; 10. free fdstruct memory
   ;
   ; ix = fdstruct *
   
   push ix
   pop hl
   call stdio_free
   jp stdio_success_znc
   
defc LIBDISP_CLOSE = # libentry - close
defc LIBDISP2_CLOSE = # libentry2 - close

