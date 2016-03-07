; char __CALLEE__ *strrstrip_callee(char *s, char c)
; remove any occurrences of c at the end of s
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strrstrip_callee
PUBLIC _strrstrip_callee
PUBLIC ASMDISP_STRRSTRIP_CALLEE

.strrstrip_callee
._strrstrip_callee

   pop hl
   pop bc
   ex (sp),hl
   
   ; enter :  c = char c
   ;         hl = char *s
   ; exit  : hl = char *s
   ; uses  : af, de
   
.asmentry
   
   push hl
   
.failloop

   ld a,(hl)
   or a
   jr z, fail
   inc hl
   
   cp c
   jp nz, failloop
   
   ld e,l
   ld d,h
   dec de
   
.passloop

   ld a,(hl)
   or a
   jr z,pass
   inc hl
   
   cp c
   jr nz, failloop
   jp passloop

.pass

   xor a
   ld (de),a
   
.fail

   pop hl
   ret

DEFC ASMDISP_STRRSTRIP_CALLEE = # asmentry - strrstrip_callee
