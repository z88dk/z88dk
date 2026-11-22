
; ===============================================================
; Oct 2014
; ===============================================================
; 
; int fileno_unlocked(FILE *stream)
;
; Return file descriptor associated with stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fileno_unlocked
PUBLIC asm0_fileno_unlocked

EXTERN __stdio_verify_valid
EXTERN __fcntl_fd_from_fdstruct, __fcntl_fdtbl_size

asm_fileno_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : success
   ;
   ;            hl = fd
   ;            carry reset
   ;
   ;         fail if FILE invalid, no fd
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
   call __stdio_verify_valid
   ret c                           ; if FILE* is invalid

asm0_fileno_unlocked:

   ld e,(ix+1)
   ld d,(ix+2)                     ; de = FDSTRUCT *

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fd_from_fdstruct

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_MULTITHREAD & $08

   jr c, exit

ELSE

   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld a,__fcntl_fdtbl_size
   sub b
   
   ld l,a
   ld h,0                      ; hl = fd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_MULTITHREAD & $08

exit:

   EXTERN __fcntl_unlock_fdtbl
   jp __fcntl_unlock_fdtbl

ELSE

   ret

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
