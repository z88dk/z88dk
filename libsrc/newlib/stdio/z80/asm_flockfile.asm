
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int flockfile(FILE *file)
;
; Increase lock count on file by one.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_flockfile

EXTERN __stdio_lock_acquire, error_znc

asm_flockfile:

   ; Acquire the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if FILE is invalid
   ;
   ;            hl = -1
   ;            carry set, errno = EBADF
   ;
   ; uses  : af, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __stdio_lock_acquire
   jp nc, error_znc            ; if lock acquired
   
   jr asm_flockfile            ; try again
