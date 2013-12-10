
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

XLIB strchrnul_callee
XDEF asm_strchrnul

strchrnul_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_strchrnul:

   ; enter :  c = char c
   ;         hl = char *s
   ;
   ; exit  : 
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
   jp nz, loop
   
   dec hl
      
   scf
   ret
