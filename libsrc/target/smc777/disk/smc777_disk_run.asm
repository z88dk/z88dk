;
;	Sony SMC-777: reading and writing sectors, the one path that smc777_disk_read and smc777_disk_write take
;
;	The floppy controller is an MB8876 (an MB8877 with an inverted data bus, which the board inverts back) at ports $30 (command and
;	status), $31 (track), $32 (sector) and $33 (data); port $34 selects the drive (bit 0) on write.  The disk is single sided: the
;	cylinder is the track, 16 sectors of 256 bytes numbered 1 to 16 (the layout appmake +smc777 writes, the program from cylinder 1).
;	A sector is moved by polling the status for the data request: a byte every 32 us in double density, so interrupts are off for the
;	length of the call (and come back if they were on).
;
;	Sectors are moved one command each, and the controller's head settling delay (the E bit) is asked for only on the first sector of
;	a call: asked for on every one, the delay is longer than the gap to the next sector, which then costs a whole turn of the disk.
;
;	A failure to read or write a sector is tried again up to TRIES times, from a restore.
;
;	The heads' position is remembered (the first call restores to track 0).  Seeks and restores go at 12 ms a step.
;
;	The C entries set the mode (0 read, 1 write) and jump here.  The arguments are drive, track, sector, count and buf,
;	pushed in that order (__smallc).
;

	MODULE	smc777_disk_run

	defc	TRIES = 3		;(more attempts at a sector after a failure: the heads are found again each time)

	SECTION	code_clib
	PUBLIC	asm_smc777_disk_call
	PUBLIC	asm_smc777_disk_call_callee
	PUBLIC	asm_smc777_disk_regs

; Entry: a = the mode.  The caller's own return address is on the stack above the arguments.
asm_smc777_disk_call:
	ld	(mode),a
	call	load_args
	jr	run

asm_smc777_disk_call_callee:
	ld	(mode),a
	call	load_args
	pop	bc			;the return address
	pop	de			;and the five arguments
	pop	de
	pop	de
	pop	de
	pop	de
	push	bc
	jr	run

; The same from assembler, with the arguments in registers.
; Entry: a = the mode (0 read, 1 write), e = drive (0 or 1), d = the cylinder, c = sector (1 to 16), b = count, hl = buf.
; Exit: hl = 0, or 1 on an error.
asm_smc777_disk_regs:
	ld	(mode),a
	ld	a,e
	ld	(drive),a
	ld	a,d
	ld	(track),a
	ld	a,c
	ld	(sector),a
	ld	a,b
	ld	(count),a

; Entry: hl = buf and the variables set.  Exit: hl = 0, or 1 on an error.
run:
	ld	a,TRIES
	ld	(tries),a
	ld	a,$04
	ld	(efl),a			;(the head settling delay for the first sector of the call only)
	ld	a,i			;(the interrupt flag, kept on the stack)
	push	af
	di
	ld	(buf),hl
next:
	ld	a,(count)
	or	a
	jp	z,done
	call	position
	jp	nz,retry
	ld	a,(sector)
	out	($32),a
	ld	hl,(buf)
	ld	a,(mode)
	or	a
	jr	nz,write
	ld	a,(efl)
	or	$80			;read sector
	out	($30),a
	ld	d,0
read_byte:
	in	a,($30)
	bit	1,a			;data request?
	jr	nz,read_got
	rrca
	jr	c,read_byte		;still busy
	jp	retry			;the command ended without the data
read_got:
	in	a,($33)
	ld	(hl),a
	inc	hl
	dec	d
	jr	nz,read_byte
	call	fdc_wait
	and	$1D			;lost data, CRC error, record not found, or never finished
	jp	nz,retry
	jr	moved
write:
	ld	a,(efl)
	or	$A0			;write sector
	out	($30),a
	ld	d,0
write_byte:
	in	a,($30)
	bit	1,a
	jr	nz,write_got
	rrca
	jr	c,write_byte
	jp	retry
write_got:
	ld	a,(hl)
	out	($33),a
	inc	hl
	dec	d
	jr	nz,write_byte
	call	fdc_wait
	and	$7D			;lost data, CRC, record not found, write fault, write protected, or never finished
	jp	nz,retry
moved:
	xor	a
	ld	(efl),a			;(the head is settled)
	ld	a,TRIES			;(the next sector has its own attempts)
	ld	(tries),a
	ld	(buf),hl
	ld	hl,count
	dec	(hl)
	ld	a,(sector)
	inc	a
	ld	(sector),a
	cp	17
	jp	c,next
	ld	a,1			;after sector 16: the next track
	ld	(sector),a
	ld	hl,track
	inc	(hl)
	jp	next
done:
	ld	hl,0
	jr	finish
retry:
	ld	a,(tries)
	or	a
	jr	z,error			;(out of attempts)
	dec	a
	ld	(tries),a
	ld	a,$D0			;force interrupt: idle, then the heads are found again and the sector tried again
	out	($30),a
	xor	a
	ld	(cyl1),a
	ld	a,$04
	ld	(efl),a
	jp	next
error:
	ld	a,$D0			;force interrupt: the controller is idle again
	out	($30),a
	ld	hl,1
finish:
	pop	af
	ret	po
	ei
	ret

; The drive selected and the heads on the track's cylinder.  Z if all is well.  Uses all.
position:
	ld	a,(drive)
	and	1
	out	($34),a
	ld	hl,0
ready:
	in	a,($30)
	rlca				;bit 7: not ready
	jr	nc,ready_ok
	dec	hl
	ld	a,h
	or	l
	jr	nz,ready
	jp	failed			;(never ready: no disk, or no drive)
ready_ok:
	ld	a,(track)
	ld	d,a			;the cylinder
	ld	a,(cyl1)
	or	a
	jr	nz,known
	ld	a,$01			;restore, 12 ms a step
	out	($30),a
	call	fdc_wait
	and	$81			;not ready, or still busy
	jp	nz,failed
	ld	a,1
	ld	(cyl1),a		;(the cylinder plus one: 0 is not known)
known:
	ld	a,(cyl1)
	dec	a
	cp	d
	jr	z,there
	ld	a,d
	out	($33),a			;the data register is where to go
	ld	a,$11			;seek, 12 ms a step (no verify: the sector commands check the IDs)
	out	($30),a
	call	fdc_wait
	and	$99			;not ready, CRC error, record not found, still busy
	jp	nz,failed
	ld	a,d
	inc	a
	ld	(cyl1),a
there:
	xor	a
	ret
failed:
	xor	a
	ld	(cyl1),a		;(where the heads are is not known now)
	or	1
	ret

; Wait for the controller to finish its command (bounded: a seek across the disk takes about a second).  Exit: a = its status; bit 0
; is still set if it never did.  Keeps bc and de.
fdc_wait:
	push	bc
	push	de
	ld	b,12
	ld	de,0
wait_busy:
	in	a,($30)
	rrca
	jr	nc,wait_done
	dec	de
	ld	a,d
	or	e
	jr	nz,wait_busy
	djnz	wait_busy
wait_done:
	in	a,($30)
	pop	de
	pop	bc
	ret

; The arguments from the stack, two calls down: hl = buf.  (call load_args, then the entry's own return address, then ours)
load_args:
	ld	hl,4
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)			;buf
	inc	hl
	ld	a,(hl)
	ld	(count),a
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	(sector),a
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	(track),a
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	(drive),a
	ex	de,hl
	ret

	SECTION	bss_clib
mode:	defb	0
drive:	defb	0
track:	defb	0
sector:	defb	0
count:	defb	0
cyl1:	defb	0			;the cylinder the heads are on, plus one (0: not known)
efl:	defb	0			;4 until the first sector is through: the E bit of the command
buf:	defw	0
tries:	defb	0			;the attempts left at this sector
