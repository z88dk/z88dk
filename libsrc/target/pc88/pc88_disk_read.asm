;
;	NEC PC-8801: read sectors from the disk
;
;	int pc88_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;
;	Reads count sectors of 256 bytes into buf, starting at the sector (the first on a track is 1) of the track (the sides
;	alternate: track = 2 * cylinder + side), and carries on to the next track after sector 16.  Returns 0, or 1 if the
;	disk unit reported an error.  Interrupts are the caller's to turn off.
;

	MODULE	pc88_disk_read

	SECTION	code_clib
	PUBLIC	pc88_disk_read
	PUBLIC	_pc88_disk_read
	PUBLIC	pc88_disk_read_callee
	PUBLIC	_pc88_disk_read_callee

	EXTERN	asm_pc88_disk_call
	EXTERN	asm_pc88_disk_call_callee

pc88_disk_read:
_pc88_disk_read:
	ld	a,0
	jp	asm_pc88_disk_call

pc88_disk_read_callee:
_pc88_disk_read_callee:
	ld	a,0
	jp	asm_pc88_disk_call_callee
