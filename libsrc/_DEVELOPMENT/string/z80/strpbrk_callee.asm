
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strpbrk(const char *s1, const char *s2)
;
; Return ptr to first occurrence in s1 of any char from s2.
;
; ===============================================================

XLIB strpbrk_callee
XDEF asm_strpbrk

LIB asm_strchr

strpbrk_callee:

   pop hl
   pop de
   ex (sp),hl

asm_strpbrk:

   ; enter : hl = char *s1 = string
   ;         de = char *s2 = needles
   ;
   ; exit  : 
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
   jr z, not_found
   
   ; see if this char from string is in needles
   
   push hl                     ; save current string
   
   ld c,a                      ; c = char
   ld l,e
   ld h,d                      ; hl = needles
   call asm_strchr             ; is c in needles?
   
   pop hl                      ; current s1
   ret nc                      ; char found in needles

   inc hl
   jp loop

not_found:

   ld l,a
   ld h,a
   
   scf
   ret
