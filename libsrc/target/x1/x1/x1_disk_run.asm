;
;	Sharp X1: reading and writing sectors, the one path that x1_disk_read and x1_disk_write take
;
;	The X1's floppy controller is an MB8877 at ports $0FF8 (command and status), $0FF9 (track), $0FFA (sector) and $0FFB (data),
;	and $0FFC (write) selects the drive (bits 1-0), the side (bit 4) and the motor (bit 7).  A sector is moved by polling the
;	status for the data request: a byte every 32 us in double density, so interrupts are off for the length of the call (and
;	come back if they were on).  The ports are decoded from all 16 bits, so a port is read with IN A,($F8) after LD A,$0F.
;
; 	A failure to read or write a sector is tried again up to TRIES times, from a restore.
;
;	The heads' position is remembered (the first call restores to track 0); the motor bit is dropped at the end of each call,
;	and the hardware keeps the drive turning for a while, so a following call does not wait for it to spin up.
;
;	The C entries set the mode (0 read, 1 write) and jump here.  The arguments are drive, track, sector, count and buf,
;	pushed in that order (__smallc).
;

	MODULE	x1_disk_run

	defc	TRIES = 3		;(more attempts at a sector after a failure: the heads are found again each time)

	SECTION	code_clib
	PUBLIC	asm_x1_disk_call
	PUBLIC	asm_x1_disk_call_callee
	PUBLIC	asm_x1_disk_regs

; Entry: a = the mode.  The caller's own return address is on the stack above the arguments.
asm_x1_disk_call:
	ld	(mode),a
	call	load_args
	jr	run

asm_x1_disk_call_callee:
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
; Entry: a = the mode (0 read, 1 write), e = drive, d = track (2 * cylinder + side), c = sector (1 to 16), b = count, hl = buf.
; Exit: hl = 0, or 1 on an error.
asm_x1_disk_regs:
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
	ld	bc,$0FFA
	out	(c),a
	ld	hl,(buf)
	ld	a,(mode)
	or	a
	jr	nz,write
	ld	a,$84			;read sector, with the head settling delay
	call	fdc_cmd
	ld	bc,$0FFB
	ld	d,0
read_byte:
	ld	a,$0F
	in	a,($F8)
	bit	1,a			;data request?
	jr	nz,read_got
	rrca
	jr	c,read_byte		;still busy
	jp	retry			;the command ended without the data
read_got:
	in	a,(c)
	ld	(hl),a
	inc	hl
	dec	d
	jr	nz,read_byte
	call	fdc_wait
	and	$1D			;lost data, CRC error, record not found, or never finished
	jp	nz,retry
	jr	moved
write:
	ld	a,$A4			;write sector
	call	fdc_cmd
	ld	bc,$0FFB
	ld	d,0
write_byte:
	ld	a,$0F
	in	a,($F8)
	bit	1,a
	jr	nz,write_got
	rrca
	jr	c,write_byte
	jp	retry
write_got:
	ld	a,(hl)
	out	(c),a
	inc	hl
	dec	d
	jr	nz,write_byte
	call	fdc_wait
	and	$7D			;lost data, CRC, record not found, write fault, write protected, or never finished
	jp	nz,retry
moved:
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
	call	fdc_cmd
	xor	a
	ld	(cyl1),a
	jp	next
error:
	ld	a,$D0			;force interrupt: the controller is idle again
	call	fdc_cmd
	ld	hl,1
finish:
	ld	a,(ctl)
	and	$7F			;the motor bit down: the drive runs on for a while
	ld	bc,$0FFC
	out	(c),a
	pop	af
	ret	po
	ei
	ret

; The drive and side selected, the motor on and the heads on the track's cylinder.  Z if all is well.  Uses all.
position:
	ld	a,$0F
	in	a,($FD)			;double density (MFM): reading the port selects it (the X1 turbo; harmless on the others)
	ld	a,$0F
	in	a,($FF)			;a 2D disk's drive: 300 rpm
	ld	a,(drive)
	and	3
	ld	e,a
	ld	a,(track)
	and	1
	rlca
	rlca
	rlca
	rlca				;the side, bit 4
	or	e
	or	$80
	ld	(ctl),a
	ld	bc,$0FFC
	out	(c),a
	ld	hl,0
ready:
	ld	a,$0F
	in	a,($F8)
	rlca				;bit 7: not ready
	jr	nc,ready_ok
	dec	hl
	ld	a,h
	or	l
	jr	nz,ready
	jp	failed			;(never ready: no disk, or no drive)
ready_ok:
	ld	a,(track)
	srl	a
	ld	d,a			;the cylinder
	ld	a,(cyl1)
	or	a
	jr	nz,known
	ld	a,$03			;restore, the slow step rate
	call	fdc_cmd
	call	fdc_wait
	and	$81			;not ready, or still busy (bit 2 is "at track 0")
	jp	nz,failed
	ld	a,1
	ld	(cyl1),a		;(the cylinder plus one: 0 is not known)
known:
	ld	a,(cyl1)
	dec	a
	cp	d
	jr	z,there
	ld	a,d
	ld	bc,$0FFB
	out	(c),a			;the data register is where to go
	ld	a,$13			;seek, the slow step rate (no verify: the sector commands check the IDs)
	call	fdc_cmd
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

; a = the command for the controller
fdc_cmd:
	ld	bc,$0FF8
	out	(c),a
	ret

; Wait for the controller to finish its command (bounded: a seek across the disk takes about a second).  Exit: a = its status; bit 0
; is still set if it never did.  Keeps bc and de.
fdc_wait:
	push	bc
	push	de
	ld	b,12
	ld	de,0
wait_busy:
	ld	a,$0F
	in	a,($F8)
	rrca
	jr	nc,wait_done
	dec	de
	ld	a,d
	or	e
	jr	nz,wait_busy
	djnz	wait_busy
	ld	a,$0F
	in	a,($F8)
	jr	wait_out
wait_done:
	ld	a,$0F
	in	a,($F8)
wait_out:
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
ctl:	defb	0
cyl1:	defb	0			;the cylinder the heads are on, plus one (0: not known)
buf:	defw	0
tries:	defb	0			;the attempts left at this sector
