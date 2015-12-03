
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strpbrk(const char *s1, const char *s2)
;
; Return ptr to first occurrence in s1 of any char from s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strpbrk

EXTERN asm_strchr, error_zc

asm_strpbrk:

   ; enter : hl = char *s1 = string
   ;         de = char *s2 = needles
   ;
   ; exit  : de = char *s2 = needles
   ;
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr in s1
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, c, hl

loop:

   ld a,(hl)
   or a
   jp z, error_zc
   
   ; see if this char from string is in needles
   
   push hl                     ; save current string
   
   ld c,a                      ; c = char
   ld l,e
   ld h,d                      ; hl = needles
   call asm_strchr             ; is c in needles?
   
   pop hl                      ; current s1
   ret nc                      ; char found in needles

   inc hl
   jr loop
