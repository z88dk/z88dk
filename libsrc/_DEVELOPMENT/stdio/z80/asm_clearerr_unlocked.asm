
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void clearerr_unlocked(FILE *stream)
;
; Clear the EOF and error indicators for the stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_clearerr_unlocked
PUBLIC asm1_clearerr_unlocked

EXTERN error_znc

asm_clearerr_unlocked:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if lock could not be acquired
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm1_clearerr_unlocked:

   ld a,(ix+3)
   and $e7                     ; clear eof and err bits
   ld (ix+3),a
   
   jp error_znc
