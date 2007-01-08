; char __CALLEE__ *strchr_callee(char *s, char c)
; return ptr to first occurrence of c in s
; 04.2001 dom

XLIB strchr_callee
XDEF ASMDISP_STRCHR_CALLEE

.strchr_callee

   pop af
   pop bc
   pop hl
   push af
   
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
   
   or a
   jr z, zeroret
   
   inc hl
   jp loop

.zeroret

   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRCHR_CALLEE = asmentry - strchr_callee
