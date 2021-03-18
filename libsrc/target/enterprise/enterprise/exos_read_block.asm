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

	EXTERN     exos_read_block_callee
	EXTERN     ASMDISP_EXOS_READ_BLOCK_CALLEE

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

   jp exos_read_block_callee + ASMDISP_EXOS_READ_BLOCK_CALLEE
