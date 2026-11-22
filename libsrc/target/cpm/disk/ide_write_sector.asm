; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; ide_write_sector: BCDE is the absolute LBA (E is the low byte) and
; HL is a 512-byte buffer. Carry is set on success and HL is then
; buffer + 512. AF, BC, DE, and HL are free.

	SECTION	code_driver

	PUBLIC	ide_write_sector

	EXTERN	cpm_bios_xfer

ide_write_sector:
	ld	a,1
	jp	cpm_bios_xfer
