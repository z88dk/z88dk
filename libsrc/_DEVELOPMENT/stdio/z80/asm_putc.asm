
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putc(int c, FILE *stream)
;
; Write char on stream.
;
; ===============================================================

XLIB asm_putc

LIB asm_fputc

defc asm_putc = asm_fputc

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
