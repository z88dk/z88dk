; char __CALLEE__ *strstrip_callee(char *s, char c)
; remove occurences of leading char c from string s
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strstrip_callee
PUBLIC _strstrip_callee
PUBLIC ASMDISP_STRSTRIP_CALLEE

.strstrip_callee
._strstrip_callee

   pop hl
   pop de
   ex (sp),hl
   ld a,e
   
   ; enter :  a = char c
   ;         hl = char *s
   ; exit  : hl = char *s
   ; uses  : af, bc, de, hl
   
.asmentry
   
   ld e,l
   ld d,h

.skip

   cp (hl)
   inc hl
   jp z, skip
   dec hl

   ; the case where there are no unwanted chars is common...
   
   ld a,l
   cp e
   jr nz, copy
   ld a,h
   cp d
   jr nz, copy
   
   ex de,hl
   ret

.copy

   push de
   
.copyloop

   ld a,(hl)
   ldi
   or a
   jp nz, copyloop
   
   pop hl
   ret

DEFC ASMDISP_STRSTRIP_CALLEE = # asmentry - strstrip_callee
