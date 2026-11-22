IF FP1100_ALLRAM
;
; Boot sector bootstrap for an all-RAM FP-1100 program (CRT_ORG_CODE below $9000: the program is loaded over the ROM's own routines, which are RAM copies at $0000-$8FFF).
;
; The ROM reads this sector (track 0, sector 1) to $9000 and jumps to it.  The ROM's sector read (at $0356) is still there to use, but the program will overwrite it, so this reads
; only the loader, to the top of RAM, and the loader (BOOTSTRAP2: it has its own copy of the polled disk driver) loads the program and runs it.  The disc layout (appmake +fp1100):
; sector 0 this, sectors 1 to 8 the loader, the program from sector 9, then the program's own data if it has any.  Sectors are 256 bytes, interleaved 1, 9, 2, 10, ...
;

	SECTION	BOOTSTRAP
	EXTERN	__DATA_END_tail
	org	0x9000

	jp	boot
boot:	ld	sp,$9000
	ld	hl,banner
	call	print_banner
	ld	hl,LOADER_ORG
	ld	bc,$0100		;sector 1 (index 1), track 0
	ld	de,0
	ld	a,LOADER_SECTORS
load_loop:
	push	af
	call	$0356
	inc	h
	inc	b
	pop	af
	dec	a
	jr	nz,load_loop
	jp	LOADER_ORG

print_banner:
	ld	a,(hl)
	and	a
	ret	z
	inc	hl
	call	$074f
	jr	print_banner

banner:
	defb	"z88dk FP-1100 Bootstrap - Loading"
	defb	13
	defb	0

;
; The loader: at the top of RAM, where the program (below it) cannot reach.  Sector 9 on is the program.
;
	defc	LOADER_ORG = $F800
	defc	LOADER_SECTORS = 8

	SECTION	BOOTSTRAP2
	org	LOADER_ORG

loader:	di
	ld	sp,LOADER_ORG
	xor	a			; read
	ld	e,0			; unit 0
	ld	d,0			; track 0
	ld	c,LOADER_SECTORS + 2	; the sector after the loader: sector id 10
	ld	b,+((__DATA_END_tail - CRT_ORG_CODE + 255) / 256)
	ld	hl,CRT_ORG_CODE
	call	fd_regs
	ld	a,h
	or	l
	jr	nz,failed
	jp	CRT_ORG_CODE
failed:	halt				; (the screen is the sub-CPU's, and the program has not taken it over)
	jr	failed

	INCLUDE	"target/fp1100/classic/fp1100_disk.inc"

ELSE
;
; Boot sector bootstrap for FP-1100
;
; After CP/M version
;
;
; 256 byte sectors:
;
; Sector interleave:
;
; 1, 9, 2, a, 3, b, 4, c, 5, d, 6, e, 7, f, 8, 10

	SECTION	BOOTSTRAP
	EXTERN	__DATA_END_tail
	org	0x9000

	jp	$9003
	ld	hl,banner
	call	print_banner
	; Total number of sector to load
	ld	a, +((__DATA_END_tail - CRT_ORG_CODE ) / 256) + 1
	ld	d,0		;???
	ld	e,0		;???
	ld	hl,CRT_ORG_CODE	;TODO: Load lower
	ld	bc,$0100	;sector 1, track 0
load_loop:
	push	af
	call	print_dot
	call	$0356
	inc	h
	inc	b
	pop	af
	dec	a
	jr	z,load_complete
	ex	af,af
	ld	a,b
	cp	$10		;End of track (head 0)
	jr	z,increment_track
	ex	af,af
	jr	load_loop
increment_track:
	ld	b,0
	inc	c		;Now, bump the track
	ex	af,af
	jr	load_loop
load_complete:
	; The load is complete here, lets jump
	jp	CRT_ORG_CODE

print_dot:
	push	de
	push	bc
	push	hl
	ld	a,'.'
	call	$074f
	pop	hl
	pop	bc
	pop	de
	ret


print_banner:
	ld	a,(hl)
	and	a
	ret	z
	inc	hl
	call	$074f
	jr	print_banner

banner:
	defb	"z88dk FP-1100 Bootstrap - Loading"
	defb	13
	defb	0


ENDIF
