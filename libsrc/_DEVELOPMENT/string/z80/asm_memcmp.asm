
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int memcmp(const void *s1, const void *s2, size_t n)
;
; Compare maximum of n bytes of s1 to s2.  Return when first
; differing char is found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memcmp
PUBLIC asm0_memcmp

asm_memcmp:

   ; enter : bc = uint n
   ;         hl = void *s2
   ;         de = void *s1
   ;
   ; exit  :  a = h = *s1-*s2 of last char compared
   ;         de = ptr in s1 to first differing char
   ;
   ;         if s1==s2 : hl=0, bc=0,  nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flags set
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr z, equal

asm0_memcmp:
loop:

   ld a,(de)                   ; a = *s1
   cpi                         ; *s1 - *s2
   jr nz, different
   
   inc de
   jp pe, loop
   
equal:

   ld l,c
   ld h,b
   ret

different:

   dec hl
   sub (hl)
   ld h,a
   ret
