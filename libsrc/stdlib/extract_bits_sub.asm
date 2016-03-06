;
;      Bit unpacking code for SD/MMC card
;
;      Stefano, 2012
;
; unsigned long extract_bits(unsigned char *resp, unsigned int start, unsigned int size)
;
;	HL = position of the byte string
;	DE = bit position (0..65535)
;	BC = size in bits

SECTION code_clib
PUBLIC extract_bits_sub

.extract_bits_sub

	xor a	; divide position by 8, keep reminder in D
	rr d
	rr e
	rr a
	rr d
	rr e
	rr a
	rr d
	rr e
	rr a
	add	hl,de	; gross location shifting
	rlca
	rlca
	rlca
	ld	b,a	; position reminder
	inc b	; add 1 to test if zero easily

	ld	a,32+8
	sub c ; 'size' mask size
	ld c,a

	; reserve space in stack
	ld	de,0
	push de
	push de
	push de
	
	; make a copy of the data chunk to shift and mask it
	push bc
	;ld   de,data1
	ex de,hl
	ld	hl,3
	add hl,sp
	ex de,hl
	
	ld   bc,5
	ldir
	pop bc
	
	; first remove the non-pertaining bits at left (shift left)
	dec b
	jr z,pdone
.ploop
	or  a
	;ld	hl,data5
	ld	hl,5
	add hl,sp

	rl  (hl)
	dec hl
	rl  (hl)
	dec hl
	rl  (hl)
	dec hl
	rl  (hl)
	dec hl
	rl  (hl)
	djnz ploop
.pdone

	; now shift right to align to the rightmost byte in the buffer
	; (32 - bit_size)+8
	ld	b,c
.sloop
	or  a
	;ld	hl,data1
	ld	hl,1
	add hl,sp

	rr  (hl)
	inc hl
	rr  (hl)
	inc hl
	rr  (hl)
	inc hl
	rr  (hl)
	inc hl
	rr  (hl)
	djnz sloop
.done

; done, gather results from stack
	pop bc
	pop bc
	ld	e,b
	ld	d,c
	pop bc
	ld	l,b
	ld	h,c
	
	ret

