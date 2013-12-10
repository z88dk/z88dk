
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

XLIB strchr_callee
XDEF asm_strchr

strchr_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_strchr:

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
   ;           hl = 0
   ;
   ; uses  : af, hl

loop:

   ld a,(hl)
   cp c
   ret z
   
   inc hl
   
   or a
   jp nz, loop
   
   ld l,a
   ld h,a
   
   scf
   ret
