; char __CALLEE__ *strrchr_callee(char *s, char c)
; return ptr to last occurrence of c in s
; 04.2001 dom, 01.2007 aralbrec

SECTION code_clib
PUBLIC strrchr_callee
PUBLIC _strrchr_callee
PUBLIC ASMDISP_STRRCHR_CALLEE

.strrchr_callee
._strrchr_callee

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
   
.loop

   ld a,(de)
   cp c
   
   jp nz, nomatch
   ld l,e
   ld h,d

.nomatch

   or a
   inc de
   jp nz, loop

   ret

DEFC ASMDISP_STRRCHR_CALLEE = # asmentry - strrchr_callee
