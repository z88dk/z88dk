
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ungetc_unlocked(int c, FILE *stream)
;
; Push char back onto stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_ungetc_unlocked
PUBLIC asm0_ungetc_unlocked

EXTERN __stdio_verify_input, error_mc

asm_ungetc_unlocked:

   ; enter : ix = FILE *
   ;         hl = char
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = char
   ;            carry reset
   ;
   ;         if fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_ungetc_unlocked:

   ld a,h
   or a
   jp nz, error_mc             ; if hl > 255

   bit 0,(ix+4)
   jp nz, error_mc             ; if ungetc already present

   ld (ix+6),l                 ; store ungetc
   
   ld a,(ix+3)
   and $48                     ; examine R and ERR flags
   cp $40                      ; open for reading and ERR = 0 ?
   jp nz, error_mc
   
   res 4,(ix+3)                ; clear eof
   
   bit 1,(ix+4)
   call z, __stdio_verify_input  ; if last operation was write, flush
   
   set 0,(ix+4)                ; ungetc is present
   ret
