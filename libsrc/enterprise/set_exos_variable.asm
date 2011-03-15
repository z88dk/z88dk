;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	set_exos_variable(unsigned char variable, unsigned char value);
;
;
;	$Id: set_exos_variable.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	set_exos_variable

	LIB set_exos_variable_callee

XREF ASMDISP_SET_EXOS_VARIABLE_CALLEE

set_exos_variable:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp set_exos_variable_callee + ASMDISP_SET_EXOS_VARIABLE_CALLEE

