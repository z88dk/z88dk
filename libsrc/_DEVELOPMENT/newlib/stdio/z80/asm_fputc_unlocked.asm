
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputc_unlocked(int c, FILE *stream)
;
; Write char to stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fputc_unlocked
PUBLIC asm0_fputc_unlocked

EXTERN error_mc, __stdio_verify_output, __stdio_send_output_raw_chars_unchecked

asm_fputc_unlocked:

   ; enter : ix = FILE *
   ;          e = char c
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = char c
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fputc_unlocked:

   call __stdio_verify_output  ; check that output on stream is ok
   ret c

   push de                     ; save char c
   
   ld bc,1
   call __stdio_send_output_raw_chars_unchecked

   pop hl                      ; l = char c
   
   ld h,0
   ret nc                      ; if no error
   
   jp error_mc
