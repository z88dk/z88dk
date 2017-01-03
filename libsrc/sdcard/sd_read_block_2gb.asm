;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	int sd_read_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_read_block_2gb.asm,v 1.4 2017-01-03 00:27:43 aralbrec Exp $
;

	PUBLIC	sd_read_block_2gb
   PUBLIC   _sd_read_block_2gb

	EXTERN		sd_read_block_2gb_callee
	EXTERN	ASMDISP_SD_READ_BLOCK_2GB_CALLEE

sd_read_block_2gb:
_sd_read_block_2gb:
	pop af	; ret addr
	pop hl	; dst addr
	exx
	pop hl	; sector pos lsb
	pop de	; sector pos msb
	pop ix	; SD_INFO struct
	
	push af
	
	jp sd_read_block_2gb_callee + ASMDISP_SD_READ_BLOCK_2GB_CALLEE

