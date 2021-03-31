;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_character(unsigned char ch_number, unsigned char character);
;
;
;	$Id: exos_write_character.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC    exos_write_character
	PUBLIC    _exos_write_character

	EXTERN     asm_exos_write_character


exos_write_character:
_exos_write_character:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_exos_write_character

