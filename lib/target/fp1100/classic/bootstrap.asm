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

