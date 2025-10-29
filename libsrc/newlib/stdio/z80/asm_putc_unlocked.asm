
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putc_unlocked(int c, FILE *stream)
;
; Write char to stream.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_putc_unlocked

EXTERN asm_fputc_unlocked

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
