;
;	NEC PC-8001: read sectors from the disk
;
;	int pc8001_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;
;	Reads count sectors of 256 bytes into buf, starting at the sector (the first on a track is 1) of the track (the drives
;	are single sided: the track is the cylinder), and carries on to the next track after sector 16.  Returns 0, or 1 if the
;	disk unit reported an error.  Interrupts are the caller's to turn off.
;

	MODULE	pc8001_disk_read

	SECTION	code_clib
	PUBLIC	pc8001_disk_read
	PUBLIC	_pc8001_disk_read
	PUBLIC	pc8001_disk_read_callee
	PUBLIC	_pc8001_disk_read_callee

	EXTERN	asm_pc8001_disk_call
	EXTERN	asm_pc8001_disk_call_callee

pc8001_disk_read:
_pc8001_disk_read:
	ld	a,0
	jp	asm_pc8001_disk_call

pc8001_disk_read_callee:
_pc8001_disk_read_callee:
	ld	a,0
	jp	asm_pc8001_disk_call_callee
