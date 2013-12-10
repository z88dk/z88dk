
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *stpcpy(char * restrict s1, const char * restrict s2)
;
; Copy string s2 to s1, return ptr to terminating NUL in s1
;
; ===============================================================

XLIB stpcpy_callee
XDEF asm_stpcpy

stpcpy_callee:

   pop bc
   pop hl
   pop de
   push bc

asm_stpcpy:

   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;
   ; exit  : hl = ptr in dst to terminating NUL
   ;         de = ptr in src to terminating NUL
   ;
   ; uses  : af, bc, de, hl

loop:

   ld a,(hl)
   ldi
   
   or a
   jp nz, loop
   
   dec de
   dec hl
   
   ex de,hl
   ret
