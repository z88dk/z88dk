
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ungetc(int c, FILE *stream)
;
; Push char back onto stream.
;
; ===============================================================

XLIB asm_ungetc

LIB asm_ungetc_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_ungetc:

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

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_ungetc_unlocked
   jp __stdio_lock_release
