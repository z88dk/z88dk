; char __CALLEE__ *strchr_callee(char *s, char c)
; return ptr to first occurrence of c in s
; 04.2001 dom

SECTION code_clib
PUBLIC strchr_callee
PUBLIC _strchr_callee
PUBLIC ASMDISP_STRCHR_CALLEE

.strchr_callee
._strchr_callee

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
   
   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRCHR_CALLEE = # asmentry - strchr_callee
