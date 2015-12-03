
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strcasecmp(const char *s1, const char *s2)
;
; Perform caseless compare of string s1 to string s2.  Return
; when the first differing char is found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strcasecmp

EXTERN asm_tolower

asm_strcasecmp:

   ; enter : hl = char *s2
   ;         de = char *s1
   ;
   ; exit  :  a = h = *s1-*s2 of first differing caseless char
   ;         de = ptr in s1 to first differing char or NUL if equal
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, c, de, hl

loop:

   ld a,(hl)
   call asm_tolower
   ld c,a                    ; c = *s2
   
   ld a,(de)
   call asm_tolower
   
   cp c                      ; *s1 - *s2
   jr nz, different

   inc de
   inc hl
   
   or a                      ; end of string?      
   jr nz, loop

equal:                       ; both strings ended same time

   dec de
   
   ld l,a	
   ld h,a
   ret 
   
different:

   sub c
   ld h,a
   ret
