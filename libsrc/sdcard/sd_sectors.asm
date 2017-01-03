; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Stefano Bodrato,   Mar 2010
;
;	$Id: sd_sectors.asm,v 1.3 2017-01-03 00:27:43 aralbrec Exp $ 
;
; Get the size in sectors of an MMC/SD card
; unsigned long sd_size(struct SD_INFO descriptor);

; Offset in bytes for the CSD field in the MMC struct.
; 1 (slot number) + 1 (slot port) + 1 (flags) + 16 (CID) = 19

defc CSD_OFFSET = 19

;
;	Original code:
;
;	int	c_size;
;	int c_size_mult;
;	int block_len;
;
;	c_size = ((mmc->CSD[6]&3)<<10) + (mmc->CSD[7]<<2) + (mmc->CSD[8]>>6);
;	c_size_mult = 1<<(((mmc->CSD[9]&3)<<1) + (mmc->CSD[10]>>7));
;	block_len = 1 << ((mmc->CSD[5]&15)-8);
;
;	if (c_size == 0xFFF)  return (unsigned long)0;
;	
;	return ( (unsigned long)++c_size * (unsigned long)c_size_mult * (unsigned long)block_len );
;	


        PUBLIC    sd_sectors
        PUBLIC    _sd_sectors
        INCLUDE "z80_crt0.hdr"
		
sd_sectors:
_sd_sectors:
		; __FASTCALL__
		
	ld		de,CSD_OFFSET
	add		hl,de
	push	hl	; MMC struct
	pop		ix
		
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
	
	; Return Capacity (number of sectors) in HL:DE
	ret
