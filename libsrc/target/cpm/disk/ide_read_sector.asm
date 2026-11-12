; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; ide_read_sector: BCDE is the absolute LBA (E is the low byte) and
; HL is a 512-byte buffer. Carry is set on success and HL is then
; buffer + 512. AF, BC, DE, and HL are free.

	SECTION	code_driver

	PUBLIC	ide_read_sector

	EXTERN	cpm_bios_xfer

ide_read_sector:
	xor	a
	jp	cpm_bios_xfer
