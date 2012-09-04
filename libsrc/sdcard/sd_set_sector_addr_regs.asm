;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_set_sector_addr_regs.asm,v 1.2 2012-09-04 15:53:32 stefano Exp $
;

	XLIB	sd_set_sector_addr_regs
IF SDHC_SUPPORT
	XREF	cmd_generic_args
ENDIF
	XREF	sd_card_info


sd_set_sector_addr_regs:

	; sector HLDE -> B,D,E,C
	
	ld	b,h
	ld	c,e
	ld	e,d
	ld	d,l


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
