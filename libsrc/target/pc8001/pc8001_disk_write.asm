;
;	NEC PC-8001: write sectors to the disk
;
;	int pc8001_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;
;
;	Writes count sectors of 256 bytes from buf, starting at the sector (the first on a track is 1) of the track (the drives
;	are single sided: the track is the cylinder), and carries on to the next track after sector 16.  Returns 0, or 1 if the
;	disk unit reported an error.  Interrupts are the caller's to turn off.
;

	MODULE	pc8001_disk_write

	SECTION	code_clib
	PUBLIC	pc8001_disk_write
	PUBLIC	_pc8001_disk_write
	PUBLIC	pc8001_disk_write_callee
	PUBLIC	_pc8001_disk_write_callee

	EXTERN	asm_pc8001_disk_call
	EXTERN	asm_pc8001_disk_call_callee

pc8001_disk_write:
_pc8001_disk_write:
	ld	a,1
	jp	asm_pc8001_disk_call

pc8001_disk_write_callee:
_pc8001_disk_write_callee:
	ld	a,1
	jp	asm_pc8001_disk_call_callee
