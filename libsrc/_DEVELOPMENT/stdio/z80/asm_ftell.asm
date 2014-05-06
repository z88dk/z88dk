
; ===============================================================
; Jan 2014
; ===============================================================
; 
; unsigned long ftell(FILE *stream)
;
; Return current file position.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_ftell

LIB asm0_ftell_unlocked, __stdio_lock_release

asm_ftell:

   ; enter :   ix = FILE *
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           dehl = current file position
   ;           carry reset
   ;
   ;         fail
   ;
   ;           dehl = -1
   ;           carry set
   ;
   ; uses  : all except ix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   LIB __stdio_verify_valid_lock, ftell_immediate_error_ebadf

   call __stdio_verify_valid_lock
   jp c, ftell_immediate_error_ebadf

ELSE

   LIB __stdio_lock_acquire, ftell_immediate_error_enolck
   
   call __stdio_lock_acquire
   jp c, ftell_immediate_error_enolck

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call asm0_ftell_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_ftell

LIB asm_ftell_unlocked

asm_ftell:

   jp asm_ftell_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
