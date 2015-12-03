
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getc_unlocked(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_getc_unlocked

EXTERN asm_fgetc_unlocked

defc asm_getc_unlocked = asm_fgetc_unlocked

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
