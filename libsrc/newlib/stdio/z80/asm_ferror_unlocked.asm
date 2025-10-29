
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ferror_unlocked(FILE *stream)
;
; Return non-zero if error indicator is set on stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_ferror_unlocked
PUBLIC asm1_ferror_unlocked

asm_ferror_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry reset
   ;
   ;         if stream in error state
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is error free
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

asm1_ferror_unlocked:

   ld a,(ix+3)
   and $08                     ; err bit only
   
   ld l,a
   ld h,a
   
   ret
