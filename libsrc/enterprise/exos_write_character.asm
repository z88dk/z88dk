;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_character(unsigned char ch_number, unsigned char character);
;
;
;	$Id: exos_write_character.asm,v 1.1 2011-03-14 11:36:48 stefano Exp $
;

	XLIB    exos_write_character

	LIB     exos_write_character_callee

XREF ASMDISP_EXOS_WRITE_CHARACTER_CALLEE

exos_write_character:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_write_character_callee + ASMDISP_EXOS_WRITE_CHARACTER_CALLEE

