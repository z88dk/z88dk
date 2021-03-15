
;
; Invoke a GSX/GIOS function with a single parameter in "intin"
;

;
; $Id: gios_1pm.asm $
;

SECTION code_clib

PUBLIC	gios_1pm
PUBLIC	_gios_1pm

EXTERN ASMDISP_GIOS_1PM
EXTERN gios_1pm_callee

gios_1pm:
_gios_1pm:

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp gios_1pm_callee + ASMDISP_GIOS_1PM
