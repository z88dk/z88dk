
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void clearerr(FILE *stream)
;
; Clear the EOF and error indicators for the stream.
;
; ===============================================================

XLIB asm_clearerr
XDEF asm_clearerr_unlocked

LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc, error_znc

asm_clearerr:

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
   ;            carry set, errno = enolck
   ;
   ; uses  : af, bc, de, hl

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_clearerr_unlocked
   jp __stdio_lock_release

asm_clearerr_unlocked:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;         hl = 0
   ;         carry reset
   ;
   ; uses  : af, hl

   ld a,(ix+3)
   and $e7                     ; clear eof and err bits
   ld (ix+3),a
   
   jp error_znc
