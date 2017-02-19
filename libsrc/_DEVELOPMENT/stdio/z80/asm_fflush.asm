
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fflush(FILE *stream)
;
; Flush the stream.  For streams most recently written to, this
; means sending any buffered output to the device.  For streams
; most recently read from, this means seeking backward to unread
; any unconsumed input.
;
; If stream == 0, all streams are flushed.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fflush
PUBLIC asm0_fflush, asm1_fflush

EXTERN asm1_fflush_unlocked, asm__fflushall, __stdio_lock_release

asm_fflush:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if lock could not be acquired
   ;         if stream is in error state
   ;         if write failed
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   ld a,ixl
   or ixh
   jp z, asm__fflushall

asm0_fflush:

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
   
   call asm1_fflush_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fflush

EXTERN asm_fflush_unlocked

defc asm_fflush = asm_fflush_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
