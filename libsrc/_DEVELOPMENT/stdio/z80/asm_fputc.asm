
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputc(int c, FILE *stream)
;
; Write char on stream.
;
; ===============================================================

XLIB asm_fputc

LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fputc:

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

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fputc_unlocked
   jp __stdio_lock_release
