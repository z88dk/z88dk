
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strncasecmp(const char *s1, const char *s2, size_t n)
;
; Perform caseless compare of string s1 to string s2, examining
; no more than n chars.  Return when the first differing char is
; found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strncasecmp

EXTERN asm_tolower

asm_strncasecmp:

   ; enter : hl = char *s2
   ;         de = char *s1
   ;         bc = size_t n
   ;
   ; exit  :  a = h = *s1-*s2 of first differing caseless char
   ;         de = ptr in s1 to byte after last char compared or NUL
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, bc, de, hl, ixl

loop:

   ld a,b
   or c
   jr z, equal

   ld a,(hl)
   call asm_tolower
   ld ixl,a                  ; ixl = *s2
   
   ld a,(de)
   call asm_tolower
   
   cp ixl                    ; *s1 - *s2
   jr nz, different

   inc de
   inc hl
   dec bc
   
   or a                      ; end of string?         
   jr nz, loop
   
   dec de

equal:                       ; both strings ended same time

   ld l,a
   ld h,a
   ret 
   
different:

   sub ixl
   ld h,a
   ret
