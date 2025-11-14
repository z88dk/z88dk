
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int feof(FILE *stream)
;
; Return non-zero if eof indicator is set on stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_feof

EXTERN asm1_feof_unlocked, __stdio_lock_release

asm_feof:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0 and Z flag set if not eof
   ;            hl = non-zero and NZ flag set if eof
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid_lock
      
   call __stdio_verify_valid_lock
   ret c

ELSE

   EXTERN __stdio_lock_acquire, error_enolck_mc
   
   call __stdio_lock_acquire
   jp c, error_enolck_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call asm1_feof_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_feof

EXTERN asm_feof_unlocked

defc asm_feof = asm_feof_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
