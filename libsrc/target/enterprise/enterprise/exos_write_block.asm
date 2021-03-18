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

	EXTERN     exos_write_block_callee
	EXTERN     ASMDISP_EXOS_WRITE_BLOCK_CALLEE

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

   jp exos_write_block_callee + ASMDISP_EXOS_WRITE_BLOCK_CALLEE
