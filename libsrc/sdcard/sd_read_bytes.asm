;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_read_bytes.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_read_bytes
	PUBLIC	sd_read_bytes_to_sector_buffer
	
	EXTERN		sd_get_byte
	
	EXTERN	sector_buffer_loc

	

sd_read_bytes_to_sector_buffer:
	ld hl,sector_buffer_loc

	
sd_read_bytes:
	push hl
sd_rblp:
	call sd_get_byte
	ld (hl),a
	inc hl
	djnz sd_rblp
	pop hl
	ret
