;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	int sd_write_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_write_sector.asm,v 1.6 2017-01-03 00:27:43 aralbrec Exp $
;

	PUBLIC	sd_write_sector
   PUBLIC   _sd_write_sector

	EXTERN		asm_sd_write_sector

sd_write_sector:
_sd_write_sector:
	pop af	; ret addr
	pop hl	; dst addr
	exx
	pop hl	; sector pos lsb
	pop de	; sector pos msb
	pop ix	; SD_INFO struct
	
	push af
	
	jp asm_sd_write_sector

