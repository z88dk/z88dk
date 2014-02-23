
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ferror_unlocked(FILE *stream)
;
; Return non-zero if error indicator is set on stream.
;
; ===============================================================

XLIB asm_ferror_unlocked

asm_ferror_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry reset
   ;
   ;         if stream in error state
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is error free
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl

   ld a,(ix+3)
   and $08                     ; err bit only
   
   ld l,a
   ld h,a
   
   ret
