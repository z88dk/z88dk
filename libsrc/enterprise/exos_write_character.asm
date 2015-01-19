;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_character(unsigned char ch_number, unsigned char character);
;
;
;	$Id: exos_write_character.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;

	PUBLIC    exos_write_character

	EXTERN     exos_write_character_callee

EXTERN ASMDISP_EXOS_WRITE_CHARACTER_CALLEE

exos_write_character:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_write_character_callee + ASMDISP_EXOS_WRITE_CHARACTER_CALLEE

