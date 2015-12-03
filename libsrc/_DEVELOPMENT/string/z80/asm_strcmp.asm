
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strcmp(const char *s1, const char *s2)
;
; Compare string s1 to string s2.  Return when the first
; differing char is found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strcmp

asm_strcmp:

   ; enter : hl = char *s2
   ;         de = char *s1
   ;
   ; exit  :  a = h = *s1-*s2 of first differing char
   ;         de = ptr in s1 to first differing char or NUL if equal
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, bc, de, hl

loop:

   ld a,(de)                   ; a = *s1
   cpi                         ; *s1 - *s2
   jr nz, different
   inc de
   
   or a                        ; end of string?
   jr nz, loop
   
equal:                         ; both strings ended same time

   dec de
   ld l,a
   ld h,a
   ret

different:

   dec hl
   sub (hl)
   ld h,a
   ret
