
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetc(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

XLIB asm_fgetc

LIB asm_fgetc_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fgetc:

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
   
   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fgetc_unlocked
   jp __stdio_lock_release
