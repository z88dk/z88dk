
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int feof_unlocked(FILE *stream)
;
; Return non-zero if eof indicator is set on stream.
;
; ===============================================================

XLIB asm_feof_unlocked

asm_feof_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if stream is at eof
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is not at eof
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl

   ld a,(ix+3)
   and $10                     ; eof bit only
   
   ld l,a
   ld h,a
   
   ret
