
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *_strnlwr(void *p, size_t n)
;
; Change letters in buffer p to lower case.
;
; ===============================================================

XLIB asm__strnlwr

LIB asm_tolower

asm__strnlwr:

   ; enter : hl = void *p
   ;         bc = size_t n
   ;
   ; exit  : hl = void *p
   ;         bc = 0
   ;
   ; uses  : af, bc

   ld a,b
   or c
   ret z
   
   push hl

loop:

   ld a,(hl)
   call asm_tolower
   ld (hl),a
   
   cpd                         ; hl++, bc--
   jp pe, loop

   pop hl
   ret
