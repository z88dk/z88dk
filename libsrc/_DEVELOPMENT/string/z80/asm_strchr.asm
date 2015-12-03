
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strchr(const char *s, int c)
;
; Return ptr to first occurrence of c in string s or NULL
; if c is not found.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strchr

EXTERN error_zc

asm_strchr:

   ; enter :  c = char c
   ;         hl = char *s
   ;
   ; exit  :  c = char c
   ;
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, hl

loop:

   ld a,(hl)
   cp c
   ret z
   
   inc hl
   
   or a
   jr nz, loop
   
   jp error_zc
