; char __CALLEE__ *strchrnul_callee(char *s, char c)
; return ptr to first occurrence of c in s
; 04.2001 dom, 04.2012 stefano

SECTION code_clib
PUBLIC strchrnul_callee
PUBLIC _strchrnul_callee
PUBLIC ASMDISP_STRCHRNUL_CALLEE

.strchrnul_callee
._strchrnul_callee

   pop hl
   pop bc
   ex (sp),hl
   
   ; enter :  c = char c
   ;         hl = char *s
   ; exit  : found : hl = ptr, NC flag set
   ;         else  : hl = 0,  C flag set
   ; uses  : af, hl
   
.asmentry
.loop

   ld a,(hl)
   cp c
   ret z
   
   inc hl
   or a
   jp nz, loop
   dec hl
;   ld l,a
;   ld h,a
   scf
   ret

DEFC ASMDISP_STRCHRNUL_CALLEE = # asmentry - strchrnul_callee
