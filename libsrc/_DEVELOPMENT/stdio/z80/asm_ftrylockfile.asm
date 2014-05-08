
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ftrylockfile (FILE *stream)
;
; Return 0 if lock successfuly acquired.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm_ftrylockfile
PUBLIC asm0_ftrylockfile

EXTERN __stdio_lock_tryacquire, error_znc, error_mc

asm_ftrylockfile:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_ftrylockfile:

   call __stdio_lock_tryacquire

   jp nc, error_znc            ; if successfully acquired lock
   jp error_mc
