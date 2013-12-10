
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strnchr(const char *s, size_t n, int c)
;
; Return ptr to first occurrence of c in string s.
; Does not examine more than n chars.
;
; ===============================================================

XLIB strnchr_callee
XDEF asm_strnchr

LIB error_zc

strnchr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

asm_strnchr:

   ; enter : hl = char *s
   ;          e = char c
   ;         bc = size_t n
   ;
   ; exit  : 
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to char c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, e, hl

   ld a,b                      ; if n == 0 not found
   or c
   jp z, error_zc

   ld a,e

loop:

   ld e,(hl)                   ; current char in s
   
   cpi
   jr z, match                 ; found char
   jp po, error_zc             ; n exceeded
   
   inc e                       ; is current char NUL?
   dec e
   jp nz, loop

   jp error_zc

match:

   dec hl
   ret
