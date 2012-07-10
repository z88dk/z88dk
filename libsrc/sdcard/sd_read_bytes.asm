;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_read_bytes.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;

	XLIB	sd_read_bytes
	XDEF	sd_read_bytes_to_sector_buffer
	
	LIB		sd_get_byte
	
	XREF	sector_buffer_loc

	

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
