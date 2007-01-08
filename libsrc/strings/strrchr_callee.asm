; char __CALLEE__ *strrchr_callee(char *s, char c)
; return ptr to last occurrence of c in s
; 04.2001 dom

XLIB strrchr_callee
XDEF ASMDISP_STRRCHR_CALLEE

.strrchr_callee

   pop hl
   pop bc
   pop de
   push hl
   
   ; enter :  c = char c
   ;         de = char *s
   ; exit  : found : hl = ptr
   ;         else  : hl = 0
   ; uses  : af, de, hl

.asmentry

   ld hl,0
   dec de
   
.loop

   inc de
   ld a,(de)
   or a
   ret z
   
   cp c
   jp nz, loop
   
   ld l,e
   ld h,d
   jp loop

DEFC ASMDISP_STRRCHR_CALLEE = asmentry - strrchr_callee
