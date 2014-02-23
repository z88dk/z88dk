
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void clearerr_unlocked(FILE *stream)
;
; Clear the EOF and error indicators for the stream.
;
; ===============================================================

XLIB asm_clearerr_unlocked

LIB error_znc

asm_clearerr_unlocked:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;         hl = 0
   ;         carry reset
   ;
   ; uses  : af

   ld a,(ix+3)
   and $e7                     ; clear eof and err bits
   ld (ix+3),a
   
   jp error_znc
