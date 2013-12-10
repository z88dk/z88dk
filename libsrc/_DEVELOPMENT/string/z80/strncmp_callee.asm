
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strncmp(const char *s1, const char *s2, size_t n)
;
; Compare at most n chars of string s1 to string s2.  Return when
; the first differing char is found with *s1 - *s2.
;
; ===============================================================

XLIB strncmp_callee
XDEF asm_strncmp

strncmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

asm_strncmp:

   ; enter : bc = uint n
   ;         de = char *s1
   ;         hl = char *s2
   ;
   ; exit  :  a = h = *s1-*s2 of last char compared
   ;         de = ptr in s1 to first differing char or s1+n if equal
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr z, equal
      
loop:

   ld a,(de)                   ; a = *s1
   cpi                         ; *s1 - *s2
   jr nz, different
   jp po, equal
   inc de
   
   or a
   jp nz, loop
   
   dec de
   
equal:

   ld hl,0
   ret

different:

   dec hl
   sub (hl)
   ld h,a
   ret
