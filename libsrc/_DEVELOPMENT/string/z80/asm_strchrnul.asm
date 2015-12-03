
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strchrnul(const char *s, int c)
;
; Return ptr to first occurrence of c in string s or ptr to
; terminating 0 in s if c is not found.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strchrnul

asm_strchrnul:

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
   ;           hl = ptr to terminating 0
   ;
   ; uses  : af, hl

loop:

   ld a,(hl)
   cp c
   ret z
   
   inc hl
   
   or a
   jr nz, loop
   
   dec hl
      
   scf
   ret
