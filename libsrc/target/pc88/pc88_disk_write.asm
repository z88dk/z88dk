;
;	NEC PC-8801: write sectors to the disk
;
;	int pc88_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;
;
;	Writes count sectors of 256 bytes from buf, starting at the sector (the first on a track is 1) of the track (the sides
;	alternate: track = 2 * cylinder + side), and carries on to the next track after sector 16.  Returns 0, or 1 if the
;	disk unit reported an error.  Interrupts are the caller's to turn off.
;

	MODULE	pc88_disk_write

	SECTION	code_clib
	PUBLIC	pc88_disk_write
	PUBLIC	_pc88_disk_write
	PUBLIC	pc88_disk_write_callee
	PUBLIC	_pc88_disk_write_callee

	EXTERN	asm_pc88_disk_call
	EXTERN	asm_pc88_disk_call_callee

pc88_disk_write:
_pc88_disk_write:
	ld	a,1
	jp	asm_pc88_disk_call

pc88_disk_write_callee:
_pc88_disk_write_callee:
	ld	a,1
	jp	asm_pc88_disk_call_callee
