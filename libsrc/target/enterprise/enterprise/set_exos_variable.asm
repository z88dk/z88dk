;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	set_exos_variable(unsigned char variable, unsigned char value);
;
;
;	$Id: set_exos_variable.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

    SECTION code_clib
	PUBLIC	set_exos_variable
	PUBLIC	_set_exos_variable

	EXTERN asm_set_exos_variable


set_exos_variable:
_set_exos_variable:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_set_exos_variable

