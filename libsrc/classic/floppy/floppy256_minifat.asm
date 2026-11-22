;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Mini-FAT names for one 256-byte floppy.
;	L = 0 selects the drive. Carry is set when the transfer is ready.
;	BCDE is the LBA, E low. HL is the buffer.
;	The target supplies floppy256_sector. This file does not call it
;	during init: there is no sector and no buffer yet.
;

	SECTION	code_driver

	PUBLIC	asm_disk_initialize
	PUBLIC	ide_read_sector
	PUBLIC	ide_write_sector

	EXTERN	floppy256_read
	EXTERN	floppy256_write

	defc	ide_read_sector = floppy256_read
	defc	ide_write_sector = floppy256_write

asm_disk_initialize:
	ld	a,l
	or	a
	jr	z,f256_mf_init
	ret

f256_mf_init:
	scf
	ret
