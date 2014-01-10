
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ftrylockfile (FILE *stream)
;
; Return 0 if lock successfuly acquired.
;
; ===============================================================

XLIB asm_ftrylockfile

LIB __stdio_lock_tryacquire, error_znc, error_mc

asm_ftrylockfile:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, hl
   
   call __stdio_lock_tryacquire

   jp nc, error_znc            ; if successfully acquired lock
   jp error_mc
