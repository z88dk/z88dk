; char __CALLEE__ *strstr_callee(char *s, char *w)
; return ptr to first occurrence of string w in s
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strstr_callee
PUBLIC _strstr_callee
PUBLIC ASMDISP_STRSTR_CALLEE

.strstr_callee
._strstr_callee

   pop af
   pop hl
   pop de
   push af
   
   ; enter : de = char *s
   ;         hl = char *w
   ; exit  : found : hl = ptr, NC flag set
   ;         else  : hl = 0, C flag set
   ; uses  : af, de, hl
   
.asmentry

   dec de
   
.loop1

   inc de
   ld a,(de)
   cp (hl)
   jr z, maybe
   or a
   jp nz, loop1
   
.fail

   ld l,a
   ld h,a
   scf
   ret
   
.maybe

   push hl                   ; save char *w
   push de                   ; save char *s

   ex de,hl

.loop2

   ld a,(de)
   or a
   jr z, match
   inc de
   
   cp (hl)
   inc hl
   jp z, loop2
   
   pop de
   pop hl
   jp loop1
   
.match

   pop hl
   pop de
   ret

DEFC ASMDISP_STRSTR_CALLEE = # asmentry - strstr_callee
