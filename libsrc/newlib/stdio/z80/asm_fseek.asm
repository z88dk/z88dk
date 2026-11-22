
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fseek(FILE *stream, long offset, int whence)
;
; Move to new position in file indicated by the signed value
; offset.
;
; If whence is:
;
; STDIO_SEEK_SET (0) : offset is relative to start of file
; STDIO_SEEK_CUR (1) : offset is relative to current position
; STDIO_SEEK_END (2) : offset is relative to end of file
;
; For STDIO_SEEK_SET, offset is treated as unsigned.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fseek

EXTERN asm0_fseek_unlocked, __stdio_lock_release

asm_fseek:

   ; enter :   ix = FILE *
   ;         dehl = offset
   ;            c = whence
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses  : all except ix
   
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
   
   call asm0_fseek_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fseek

EXTERN asm_fseek_unlocked

defc asm_fseek = asm_fseek_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
