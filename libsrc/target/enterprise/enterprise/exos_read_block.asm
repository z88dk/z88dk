;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_read_block(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_read_block.asm $
;

	SECTION code_clib
	PUBLIC	exos_read_block
	PUBLIC	_exos_read_block

	EXTERN     asm_exos_read_block

exos_read_block:
_exos_read_block:
	
	pop	af
	pop de
	pop bc
	pop hl
	push hl
	push bc
	push de
	push af

   jp asm_exos_read_block