
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputs(const char *s, FILE *stream)
;
; Write string to stream.  Return number of bytes written.
;
; ===============================================================

XLIB asm_fputs

LIB asm_fputs_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fputs:

   ; enter : ix = FILE *
   ;         hl = char *s
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = strlen(s)
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
   
   call asm_fputs_unlocked
   jp __stdio_lock_release
