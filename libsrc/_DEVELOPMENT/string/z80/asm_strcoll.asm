
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strcoll(const char *s1, const char *s2)
;
; Compare string s1 to string s2.  Return when the first
; differing char is found with *s1 - *s2.  Char comparison
; is done using currently defined locale.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strcoll

EXTERN __lc_char_cmp_bc

asm_strcoll:

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

   push de
   push hl
   
   ld a,(de)
   ld b,a
   ld c,(hl)
   
   call __lc_char_cmp_bc       ; a = *s1 - *s2
   
   pop hl
   pop de
   
   jr nz, different
   
   ld a,(de)
   inc de
   inc hl
   
   or a
   jr nz, loop                 ; end of string?
   
equal:                         ; both strings ended same time

   dec de
   ld l,a
   ld h,a
   ret

different:

   ld h,a
   ret
