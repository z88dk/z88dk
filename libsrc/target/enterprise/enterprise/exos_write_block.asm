;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_block(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_write_block.asm $
;

	SECTION code_clib
	PUBLIC	exos_write_block
	PUBLIC	_exos_write_block

	EXTERN     asm_exos_write_block

exos_write_block:
_exos_write_block:
	
	pop	af
	pop de
	pop bc
	pop hl
	push hl
	push bc
	push de
	push af

   jp asm_exos_write_block
