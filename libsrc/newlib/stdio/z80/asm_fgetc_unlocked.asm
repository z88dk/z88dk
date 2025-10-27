
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetc_unlocked(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fgetc_unlocked
PUBLIC asm0_fgetc_unlocked

EXTERN __stdio_verify_input, __stdio_recv_input_raw_getc, error_mc

asm_fgetc_unlocked:

   ; enter : ix = FILE *
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

asm0_fgetc_unlocked:

   call __stdio_verify_input   ; check that input from stream is ok
   ret c

   call __stdio_recv_input_raw_getc
   ret nc
   
   jp error_mc
