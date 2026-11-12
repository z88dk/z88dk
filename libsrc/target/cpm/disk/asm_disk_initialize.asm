; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; asm_disk_initialize: L is the drive. Only drive 0 is present.
; SELDSK with E = 0 logs the disk in. Carry is set when the BIOS
; returns a disk parameter header. HL is 0 then. L not 0 returns
; HL = 2 and carry clear. A missing drive returns HL = 0 and carry
; clear. BC is not preserved.

	SECTION	code_driver

	PUBLIC	asm_disk_initialize

	EXTERN	cpm_bios

asm_disk_initialize:
	ld	a,l
	or	a
	jp	Z,adi_sel
	ld	hl,2
	or	a
	ret

adi_sel:
	ld	c,0
	ld	e,0
	ld	a,24			; SELDSK
	call	cpm_bios
	ld	a,h
	or	l
	ret	Z
	ld	hl,0
	scf
	ret
