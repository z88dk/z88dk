
; ===============================================================
; Oct 2014
; ===============================================================
; 
; int fileno(FILE *stream)
;
; Return file descriptor associated with stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fileno

EXTERN asm0_fileno_unlocked
EXTERN __stdio_verify_valid_lock, __stdio_lock_release

asm_fileno:

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

   call __stdio_verify_valid_lock
   ret c
   
   call asm0_fileno_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fileno

EXTERN asm_fileno_unlocked

defc asm_fileno = asm_fileno_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
