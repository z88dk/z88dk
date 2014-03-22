
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetc_unlocked(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

XLIB asm_fgetc_unlocked

LIB __stdio_verify_input, __stdio_recv_input_raw_getc, error_mc

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

   call __stdio_verify_input   ; check that input from stream is ok
   ret c

   call __stdio_recv_input_raw_getc
   ret nc
   
   jp error_mc
