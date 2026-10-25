;
;	NEC PC-8801: the host side of the disk unit's protocol
;
;	The disk unit has a Z80 of its own, joined to the host by a pair of 8255s wired in cross (port $FD out, $FC in,
;	$FE status, $FF control).  The host sends a command (ATN, then the byte), parameters and data with a handshake
;	for each byte, and takes the answer back with the mirror of it.  The bootstrap does the same for reading.
;
;	asm_pc88_sd_cmd	a = the command byte (with ATN)
;	asm_pc88_sd_byte	a = a byte for the unit
;	asm_pc88_sd_pair	a, e = two bytes with one handshake (the fast write)
;	asm_pc88_rd_byte	a = a byte from the unit
;	asm_pc88_rd_pair	(hl) = two bytes from the unit, hl goes on (the fast send)
;
;	All keep the other registers.
;

	MODULE	pc88_disk_io

	SECTION	code_clib
	PUBLIC	asm_pc88_sd_cmd
	PUBLIC	asm_pc88_sd_byte
	PUBLIC	asm_pc88_sd_pair
	PUBLIC	asm_pc88_rd_byte
	PUBLIC	asm_pc88_rd_pair

asm_pc88_sd_cmd:
	push	af
	ld	a,%00001111		;ATN = 1
	out	($ff),a
wait_ready:
	in	a,($fe)
	bit	1,a			;ready for data?
	jr	z,wait_ready
	ld	a,%00001110		;ATN = 0
	out	($ff),a
	jr	send

asm_pc88_sd_byte:
	push	af
wait_byte:
	in	a,($fe)
	bit	1,a
	jr	z,wait_byte
send:
	pop	af
	out	($fd),a
	ld	a,%00001001		;data valid
	out	($ff),a
wait_accepted:
	in	a,($fe)
	bit	2,a			;data accepted?
	jr	z,wait_accepted
	ld	a,%00001000		;data valid off
	out	($ff),a
wait_done:
	in	a,($fe)
	bit	2,a
	jr	nz,wait_done
	ret

; The unit takes the second byte of a pair when valid goes off, so it is on the port before that
asm_pc88_sd_pair:
	push	af
wait_pair:
	in	a,($fe)
	bit	1,a
	jr	z,wait_pair
	pop	af
	out	($fd),a
	ld	a,%00001001
	out	($ff),a
wait_first:
	in	a,($fe)
	bit	2,a
	jr	z,wait_first
	ld	a,e
	out	($fd),a
	ld	a,%00001000
	out	($ff),a
wait_second:
	in	a,($fe)
	bit	2,a
	jr	nz,wait_second
	ret

asm_pc88_rd_byte:
	ld	a,%00001011		;ready for data
	out	($ff),a
wait_valid:
	in	a,($fe)
	rrca				;data valid?
	jr	nc,wait_valid
	ld	a,%00001010		;ready off
	out	($ff),a
	in	a,($fc)
	push	af
	ld	a,%00001101		;data accepted
	out	($ff),a
wait_drop:
	in	a,($fe)
	rrca
	jr	c,wait_drop
	ld	a,%00001100		;accepted off
	out	($ff),a
	pop	af
	ret

asm_pc88_rd_pair:
	push	af
	ld	a,%00001011
	out	($ff),a
wait_v1:
	in	a,($fe)
	rrca
	jr	nc,wait_v1
	ld	a,%00001010
	out	($ff),a
	in	a,($fc)
	ld	(hl),a
	inc	hl
	ld	a,%00001101
	out	($ff),a
wait_v2:
	in	a,($fe)
	rrca
	jr	c,wait_v2
	in	a,($fc)
	ld	(hl),a
	inc	hl
	ld	a,%00001100
	out	($ff),a
	pop	af
	ret
