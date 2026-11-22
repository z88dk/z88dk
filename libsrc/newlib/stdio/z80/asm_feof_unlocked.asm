
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int feof_unlocked(FILE *stream)
;
; Return non-zero if eof indicator is set on stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_feof_unlocked
PUBLIC asm1_feof_unlocked

asm_feof_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if stream is at eof
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is not at eof
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid
   
   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm1_feof_unlocked:

   ld a,(ix+3)
   and $10                     ; eof bit only
   
   ld l,a
   ld h,a
   
   ret
