;
;	NEC PC-8801: reading and writing sectors, the one path that pc88_disk_read and pc88_disk_write take
;
;	A run of sectors is done in chunks that end at the end of a track (the unit does one track at a time).  For each: the
;	command (read $02, or fast write $11), the four parameters (sectors, drive, track, sector), then a write sends the data
;	and a read asks for it ($12, fast send) and takes it; then the unit says how it went (command 6).
;
;	The C entries set the mode (0 read, 1 write) and jump here.  The arguments are drive, track, sector, count and buf,
;	pushed in that order (__smallc).
;

	MODULE	pc88_disk_run

	SECTION	code_clib
	PUBLIC	asm_pc88_disk_call
	PUBLIC	asm_pc88_disk_call_callee
	PUBLIC	asm_pc88_disk_regs

	EXTERN	asm_pc88_sd_cmd
	EXTERN	asm_pc88_sd_byte
	EXTERN	asm_pc88_sd_pair
	EXTERN	asm_pc88_rd_byte
	EXTERN	asm_pc88_rd_pair

; Entry: a = the mode.  The caller's own return address is on the stack above the arguments.
asm_pc88_disk_call:
	ld	(mode),a
	call	load_args
	jr	run

asm_pc88_disk_call_callee:
	ld	(mode),a
	call	load_args
	pop	bc			;the return address
	pop	de			;and the five arguments
	pop	de
	pop	de
	pop	de
	pop	de
	push	bc

; The same from assembler, with the arguments in registers.
; Entry: a = the mode (0 read, 1 write), e = drive, d = track, c = sector, b = count, hl = buf.  Exit: hl = 0, or 1 on an error.
asm_pc88_disk_regs:
	ld	(mode),a
	ld	a,e
	ld	(drive),a
	ld	a,d
	ld	(track),a
	ld	a,c
	ld	(sector),a
	ld	a,b
	ld	(count),a
	jr	run

; Entry: hl = buf and the variables set.  Exit: hl = 0, or 1 if the unit reported an error.
run:
chunk:
	call	next_chunk
	jr	z,done
	ld	a,(mode)
	or	a
	ld	a,$02			;read
	jr	z,command
	ld	a,$11			;fast write
command:
	call	asm_pc88_sd_cmd
	ld	a,b
	call	asm_pc88_sd_byte	;the sectors,
	ld	a,(drive)
	call	asm_pc88_sd_byte
	ld	a,(track)
	call	asm_pc88_sd_byte
	ld	a,(sector)
	call	asm_pc88_sd_byte
	ld	a,(mode)
	or	a
	jr	nz,write
	ld	a,$12			;fast send to the host
	call	asm_pc88_sd_cmd
read_sector:
	ld	c,128
read_pair:
	call	asm_pc88_rd_pair
	dec	c
	jr	nz,read_pair
	djnz	read_sector
	jr	status
write:
write_sector:
	ld	c,128
write_pair:
	ld	a,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	call	asm_pc88_sd_pair
	dec	c
	jr	nz,write_pair
	djnz	write_sector
status:
	ld	a,6			;(a write is finished by the time the unit takes this)
	call	asm_pc88_sd_cmd
	call	asm_pc88_rd_byte
	rrca				;bit 0 is the unit's error
	jr	c,error
	ld	a,(n)			;on to the next chunk
	ld	c,a
	ld	a,(count)
	sub	c
	ld	(count),a
	ld	a,(sector)
	add	a,c
	ld	(sector),a
	cp	17
	jr	c,chunk
	ld	a,1			;after sector 16: the next track
	ld	(sector),a
	ld	a,(track)
	inc	a
	ld	(track),a
	jr	chunk
done:
	ld	hl,0
	ret
error:
	ld	hl,1
	ret

; The chunk: nz and b = the sectors, up to the end of the track, or z if none are left.  Keeps hl.
next_chunk:
	ld	a,(count)
	or	a
	ret	z
	ld	b,a
	ld	a,(sector)
	ld	e,a
	ld	a,17
	sub	e
	cp	b
	jr	c,sized
	ld	a,b
sized:
	ld	(n),a
	ld	b,a
	or	a
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
n:	defb	0
