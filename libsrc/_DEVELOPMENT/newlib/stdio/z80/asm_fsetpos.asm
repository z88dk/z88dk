
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fsetpos(FILE *stream, const fpos_t *pos)
;
; Set the file position of stream according to pos.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fsetpos

EXTERN asm0_fsetpos_unlocked, __stdio_lock_release

asm_fsetpos:

   ; enter :   ix = FILE *
   ;           hl = fpos_t *pos
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
   
   call asm0_fsetpos_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fsetpos

EXTERN asm_fsetpos_unlocked

defc asm_fsetpos = asm_fsetpos_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
