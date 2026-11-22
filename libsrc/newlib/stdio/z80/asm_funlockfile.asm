
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void funlockfile(FILE *file)
;
; Reduce lock count of file by one.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_funlockfile

EXTERN __stdio_lock_release

asm_funlockfile:

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : f, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp __stdio_lock_release
