; char __CALLEE__ *strrstr_callee(char *s, char *w)
; return ptr to last occurrence of string w in s
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strrstr_callee
PUBLIC _strrstr_callee
PUBLIC ASMDISP_STRRSTR_CALLEE
EXTERN     rcmx_cpir


.strrstr_callee
._strrstr_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : de = char *w
   ;         hl = char *s
   ; exit  : found : hl = ptr, NC flag set
   ;         else  : hl = ptr to '\0' in s, C flag set
   ; uses  : af, bc, hl

.asmentry

   ; first find end of s and len(s)
   
   xor a
   ld c,a
   ld b,a
   cpir
   dec hl
   
   ; de = char *w
   ; hl = terminating '\0' in char *s
   ; bc = -(length of char *s)-1
   
   ; degenerate case
   
   ld a,(de)
   or a
   ret z
   
.loop1

   dec hl
   inc bc
   
   ld a,b
   or c
   jr z, nomatch

   ld a,(de)
   cp (hl)
   jp nz, loop1

   push hl                   ; save char *s
   push de                   ; save char *w

.loop2

   inc de
   ld a,(de)
   or a
   jr z, match
   inc hl
   cp (hl)
   jp z, loop2
   
   pop de
   pop hl
   jp loop1

.nomatch

   ld l,c
   ld h,b
   scf
   ret

.match

   pop de
   pop hl
   ret

DEFC ASMDISP_STRRSTR_CALLEE = # asmentry - strrstr_callee
