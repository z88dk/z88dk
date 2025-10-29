
; ===============================================================
; October 2014
; ===============================================================
; 
; off_t lseek(int fd, off_t offset, int whence)
;
; offset is an unsigned quantity when whence = SEEK_SET
; and is signed otherwise.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_lseek

EXTERN __fcntl_fdstruct_from_fd_2, l_jpix
EXTERN error_einval_lmc, error_lmc

asm_lseek:

   ; enter :   bc = int fd
   ;         dehl = offset
   ;            a = whence
   ;
   ; exit  : success
   ;
   ;            dehl = new file position
   ;            carry reset
   ;
   ;         fail
   ;
   ;            dehl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, exx, ix

   cp 3
   jp nc, error_einval_lmc     ; if whence is invalid
   
   push bc                     ; save fd
   ld c,a                      ; c = whence
   
   exx
   
   ld c,a                      ; c = whence

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fdstruct_from_fd_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp c, error_lmc             ; if fd is invalid

   ;   ix = FDSTRUCT *
   ;    c = whence
   ;    c'= whence
   ; dehl'= offset
   
   ld a,STDIO_MSG_SEEK
   call l_jpix                 ; deliver seek message
   
   ret nc
   jp error_lmc                ; if driver reports error
