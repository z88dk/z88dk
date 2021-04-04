
;
; Invoke a GSX/GIOS function with a single parameter in "intin"
;

;
; $Id: gios_1pm.asm $
;

SECTION code_clib

PUBLIC	gios_1pm
PUBLIC	_gios_1pm

EXTERN asm_gios_1pm

gios_1pm:
_gios_1pm:

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp asm_gios_1pm
