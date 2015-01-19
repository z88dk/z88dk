;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	set_exos_variable(unsigned char variable, unsigned char value);
;
;
;	$Id: set_exos_variable.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;

	PUBLIC	set_exos_variable

	EXTERN set_exos_variable_callee

EXTERN ASMDISP_SET_EXOS_VARIABLE_CALLEE

set_exos_variable:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp set_exos_variable_callee + ASMDISP_SET_EXOS_VARIABLE_CALLEE

