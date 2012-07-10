;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_set_sector_addr_lba0.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;

	XLIB	sd_set_sector_addr_lba0

	XREF	cmd_generic_args
	XREF	sd_card_info
	XREF	sector_lba0	


sd_set_sector_addr_lba0:

	ld bc,(sector_lba0+2)
	ld hl,(sector_lba0)			; sector LBA BC:HL -> B,D,E,C
	ld d,c
	ld e,h
	ld c,l

IF SDHC_SUPPORT
	ld a,(sd_card_info)
	and $10
	jr nz,lbatoargs			; if SDHC card, we use direct sector access
ENDIF

	ld a,d				; otherwise need to multiply by 512
	add hl,hl
	adc a,a	
	ex de,hl
	ld b,a
	ld c,0
lbatoargs:
	ld hl,cmd_generic_args
	ld (hl),b
	inc hl
	ld (hl),d
	inc hl
	ld (hl),e
	inc hl
	ld (hl),c
	ret
