
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getc(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

XLIB asm_getc

LIB asm_fgetc

defc asm_getc = asm_fgetc

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
