;
;	Sharp X1: read sectors of the disk
;
;	int x1_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;
;	Reads count sectors of 256 bytes into buf, starting at the sector (the first on a track is 1) of the track (the sides alternate:
;	track = 2 * cylinder + side), and carries on to the next track after sector 16.  Returns 0, or 1 if the controller reported an
;	error.  Interrupts are turned off for the call and restored.
;

	MODULE	x1_disk_read

	SECTION	code_clib
	PUBLIC	x1_disk_read
	PUBLIC	_x1_disk_read
	PUBLIC	x1_disk_read_callee
	PUBLIC	_x1_disk_read_callee

	EXTERN	asm_x1_disk_call
	EXTERN	asm_x1_disk_call_callee

x1_disk_read:
_x1_disk_read:
	ld	a,0
	jp	asm_x1_disk_call

x1_disk_read_callee:
_x1_disk_read_callee:
	ld	a,0
	jp	asm_x1_disk_call_callee
