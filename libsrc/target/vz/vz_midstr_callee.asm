;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- char __CALLEE__ *vz_midstr_callee(char *str, int pos)

SECTION code_clib
PUBLIC vz_midstr_callee
PUBLIC _vz_midstr_callee
PUBLIC asm_vz_midstr

.vz_midstr_callee
._vz_midstr_callee

   pop af
   pop de
   pop hl
   push af

   ; de = int pos
   ; hl = char *str
   
.asm_vz_midstr

   add hl,de
   ld l,(hl)
   ld h,0
   ret

