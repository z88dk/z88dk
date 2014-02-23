
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputc_unlocked(int c, FILE *stream)
;
; Write char to stream.
;
; ===============================================================

XLIB asm_fputc_unlocked
XDEF asm_putc_unlocked

LIB error_mc, __stdio_verify_output, __stdio_send_output_raw_chars_unchecked

asm_fputc_unlocked:
asm_putc_unlocked:

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

   call __stdio_verify_output  ; check that output on stream is ok
   ret c

   push de                     ; save char c
   
   ld bc,1
   call __stdio_send_output_raw_chars_unchecked

   pop hl                      ; l = char c
   
   ld h,0
   ret nc                      ; if no error
   
   jp error_mc
