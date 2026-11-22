;
;	Sony SMC-777: read sectors of the disk
;
;	int smc777_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
;
;	Reads count sectors of 256 bytes into buf, starting at the sector (the first on a track is 1) of the
;	track (the disk is single sided: the track is the cylinder), and carries on to the next track after sector 16.  Returns 0, or 1 if
;	the controller reported an error.  Interrupts are turned off for the call and restored.
;

	MODULE	smc777_disk_read

	SECTION	code_clib
	PUBLIC	smc777_disk_read
	PUBLIC	_smc777_disk_read
	PUBLIC	smc777_disk_read_callee
	PUBLIC	_smc777_disk_read_callee

	EXTERN	asm_smc777_disk_call
	EXTERN	asm_smc777_disk_call_callee

smc777_disk_read:
_smc777_disk_read:
	ld	a,0
	jp	asm_smc777_disk_call

smc777_disk_read_callee:
_smc777_disk_read_callee:
	ld	a,0
	jp	asm_smc777_disk_call_callee
