
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putc_unlocked(int c, FILE *stream)
;
; Write char to stream.
;
; ===============================================================

XLIB asm_putc_unlocked

LIB asm_fputc_unlocked

defc asm_putc_unlocked = asm_fputc_unlocked

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
