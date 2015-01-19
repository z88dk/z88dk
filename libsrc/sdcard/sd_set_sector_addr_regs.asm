;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;	set B to number of bytes required  
;
;	$Id: sd_set_sector_addr_regs.asm,v 1.6 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_set_sector_addr_regs
	EXTERN	cmd_generic_args
IF SDHC_SUPPORT
	EXTERN	sd_card_info
ENDIF


sd_set_sector_addr_regs:

	; sector HLDE -> B,D,E,C
	
	ld	b,h
	ld	c,e
	ld	e,d
	ld	d,l

	jr	nc,lbatoargs	; if C is reset -> do not multiply by 512
						; (linear addressing for cards <= 2GB only)
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
