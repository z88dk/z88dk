;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_set_sector_addr_lba0.asm,v 1.4 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_set_sector_addr_lba0

	EXTERN	cmd_generic_args
	EXTERN	sector_lba0	
IF SDHC_SUPPORT
	EXTERN	sd_card_info
ENDIF



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
