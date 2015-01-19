;
;	SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	Read card information details
;
;	$Id: sd_read_csd.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	sd_read_csd
	
	EXTERN	sector_buffer_loc

	EXTERN		sd_send_command_null_args
	EXTERN		sd_wait_data_token
	EXTERN		sd_read_bytes_to_sector_buffer

    INCLUDE "sdcard.def"


; Returns BC:DE = Total capacity of card (in sectors)


sd_read_csd:
	
	ld a,CMD9				; send "read CSD" command: 49 00 00 00 00 01 to read card info
	call sd_send_command_null_args

	ld a,sd_error_bad_command_response
	ret nz	; ZF set if command response = 00	

	call sd_wait_data_token		; wait for the data token
	ld a,sd_error_data_token_timeout
	ret nz

sd_id_ok:
	ld b,18				; read the card info to sector buffer (16 bytes + 2 CRC)
	call sd_read_bytes_to_sector_buffer	

	ld ix,(sector_buffer_loc)		; compute card's capacity
	bit 6,(ix)
	jr z,sd_csd_v1

sd_csd_v2:
	ld l,(ix+9)			; for CSD v2.00
	ld h,(ix+8)
	inc hl
	ld a,10
	ld bc,0
sd_csd2lp:
	add hl,hl
	rl c
	rl b
	dec a
	jr nz,sd_csd2lp
	ex de,hl				; Return Capacity (number of sectors) in BC:DE
	xor a
	ret
	
sd_csd_v1:
	ld a,(ix+6)			; For CSD v1.00
	and @00000011
	ld d,a
	ld e,(ix+7)
	ld a,(ix+8)
	and @11000000
	sla a
	rl e
	rl d
	sla a
	rl e
	rl d				; DE = 12 bit value: "C_SIZE"
	
	ld a,(ix+9)
	and @00000011
	ld b,a
	ld a,(ix+10)
	and @10000000
	sla a
	rl b				; B = 3 bit value: "C_MULT"
	
	inc b
	inc b
	ld hl,0
sd_cmsh:
	sla e
	rl d
	rl l
	rl h
	djnz sd_cmsh			; HL:DE = ("C_MULT"+1) * (2 ^ (C_MULT+2))
	
	ld a,(ix+5)
	and @00001111			; A = "READ_BL_LEN"
	jr z,sd_nbls
	ld b,a
sd_blsh:
	sla e
	rl d
	rl l
	rl h
	djnz sd_blsh			; Cap (bytes) HL:DE = ("C_MULT"+1) * (2 ^ (C_MULT+2)) * (2^READ_BL_LEN)
	
	ld b,9				; convert number of bytes to numer of sectors
sd_cbsec:
	srl h
	rr l
	rr d
	rr e
	djnz sd_cbsec

sd_nbls:
	push hl
	pop bc				; Return Capacity (number of sectors) in BC:DE
	xor a
	ret
