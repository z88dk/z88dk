;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void vz_shape(int x, int y, int w, int h, int c, char *data)

SECTION code_clib
PUBLIC vz_shape
PUBLIC _vz_shape
PUBLIC char_shape
EXTERN scrbase

; This one is difficult to ween off the stack so left
; as is for another enterprising person to improve

.vz_shape
._vz_shape
	push	ix		; save callers ix
	ld	ix, 0           ; old compiler had an extra word on stack
	add	ix, sp
	ld	e, (ix+4)	; get *data
	ld	d, (ix+5)
	ld	iy, 0
	add	iy, de		; to IY

	ld	h,(ix+12)	; y coordinate
	ld	l,(ix+14)	; x coordinate

; convert HL to screen offset
	sla	l
	sra	h
	rr	l
	sra	h
        rr      l
	sra	h
        rr      l
	ld	de, (scrbase)
	add	hl, de

	ld	a, (ix+6)	; color
	and	3		; only 0..3 allowed
	ld	c, a
	ld	b, $fc		; pixel mask
        ld      a,(ix+14)        ; x offset
	and	3		; mask lower two bits of x
	xor	3		; flip 3->0, 2->1, 1->2, 0->3
	jr	z, shape1	; offset was 3, done
shape0:
	rlc	c		; shift color left
	rlc	c
	rlc	b		; shift mask left
        rlc     b
	dec	a		; more shifts?
	jr	nz, shape0
shape1:
        ld      a,(ix+12)        ; get y
	or	a		; negative ?
	jp	m, shape8	; next row
	cp	64		; above 64 ?
	jp	nc, shapex	; leave function
	ld	e,(ix+10)	; get width
shape2:
	push	bc		; save mask/color
	push	hl		; save screen offset
shape3:
	ld	d, (iy+0) 	; get data byte
	inc	iy		; increment data pointer
	ld	a, (hl) 	; get screen contents
shape4:
        rlc     d               ; next bit set?
	jr	nc, shape5	; no, skip
        and     b               ; remove old pixel
	or	c		; set new pixel
shape5:
	rrc	c		; rotate color
        rrc     c
	rrc	b		; rotate mask
	rrc	b
	jr	c, shape6	; mask not yet through? skip
	ld	(hl), a 	; store screen contents
        inc     hl              ; increment screen address
	ld	a, (hl) 	; get screen contents
shape6:
	dec	e		; decrement width
	jr	z, shape7	; zero: row done
	bit	0, e
	jr	nz, shape4	; odd count
	bit	1, e
        jr      nz, shape4      ; odd count
	bit	2, e
        jr      nz, shape4      ; odd count
	ld	(hl), a 	; store screen contents
        jr      shape3          ; fetch next datum
shape7:
	ld	(hl), a 	; store screen contents
        pop     hl              ; get back screen offset
        pop     bc              ; get back mask/color
	jr	shape9
shape8:
        ld      e,(ix+10)        ; get width
	ld	d,0
	ld	a,7		; + 7
	add	a,e
	ld	e,a
	ld	a,d
	adc	a,0
	ld	d,a
	sra	d		; / 8
	rr	e
	sra	d
        rr      e
	sra	d
        rr      e
	add	iy,de		; skip data bytes
shape9:
	ld	de, 32	 	; one row down
	add	hl, de
	inc	(ix+12)		; increment y
	dec	(ix+8)		; decrement h
	jp	nz, shape1	; more rows?
shapex:
	pop	ix		; restore callers ix
	ret

	SECTION rodata_clib
char_shape:
	defb $00,$00,$00,$00,$00	; space
	defb $20,$20,$20,$00,$20	; !
	defb $50,$50,$00,$00,$00	; "
	defb $50,$f8,$50,$f8,$50	; #
	defb $78,$a0,$70,$28,$f0	; $
	defb $c8,$d0,$20,$58,$98	; %
	defb $40,$a0,$68,$90,$68	; &
	defb $20,$20,$40,$00,$00	; '
	defb $30,$40,$40,$40,$30	; (
	defb $60,$10,$10,$10,$60	; )
	defb $a8,$70,$f8,$70,$a8	; *
	defb $20,$20,$f8,$20,$20	; +
	defb $00,$00,$20,$20,$40	; ,
	defb $00,$00,$f8,$00,$00	; -
	defb $00,$00,$00,$60,$60	; .
	defb $08,$10,$20,$40,$80	; /
	defb $70,$88,$a8,$88,$70	; 0
	defb $20,$60,$20,$20,$70	; 1
	defb $f0,$08,$70,$80,$f8	; 2
	defb $f8,$10,$70,$08,$f0	; 3
	defb $10,$30,$50,$f8,$10	; 4
	defb $f8,$80,$f0,$08,$f0	; 5
	defb $70,$80,$f0,$88,$70	; 6
	defb $f8,$10,$20,$40,$80	; 7
	defb $70,$88,$70,$88,$70	; 8
	defb $70,$88,$78,$08,$70	; 9
	defb $00,$20,$00,$20,$00	; :
	defb $00,$20,$00,$20,$40	; ;
	defb $10,$20,$40,$20,$10	; <
	defb $00,$f8,$00,$f8,$00	; =
	defb $40,$20,$10,$20,$40	; >
	defb $70,$88,$30,$00,$20	; ?
	defb $70,$88,$b8,$80,$70	; @
	defb $70,$88,$f8,$88,$88	; A
	defb $f0,$88,$f0,$88,$f0	; B
	defb $70,$88,$80,$88,$70	; C
	defb $e0,$90,$88,$90,$e0	; D
	defb $f8,$80,$f0,$80,$f8	; E
	defb $f8,$80,$f0,$80,$80	; F
	defb $78,$80,$b8,$88,$78	; G
	defb $88,$88,$f8,$88,$88	; H
	defb $70,$20,$20,$20,$70	; I
	defb $f8,$08,$08,$88,$70	; J
	defb $88,$90,$e0,$90,$88	; K
	defb $80,$80,$80,$80,$f8	; L
	defb $88,$d8,$a8,$88,$88	; M
	defb $88,$c8,$a8,$98,$88	; N
	defb $70,$88,$88,$88,$70	; O
	defb $f0,$88,$f0,$80,$80	; P
	defb $70,$88,$a8,$90,$68	; Q
	defb $f0,$88,$f0,$90,$88	; R
	defb $78,$80,$70,$08,$f0	; S
	defb $f8,$20,$20,$20,$20	; T
	defb $88,$88,$88,$88,$70	; U
	defb $88,$88,$88,$50,$20	; V
	defb $88,$88,$a8,$d8,$88	; W
	defb $88,$50,$20,$50,$88	; X
	defb $88,$50,$20,$20,$20	; Y
	defb $f8,$10,$20,$40,$f8	; Z
	defb $78,$60,$60,$60,$78	; [
	defb $80,$40,$20,$10,$08	; \ 
	defb $f0,$30,$30,$30,$f0	; ]
	defb $20,$70,$a8,$20,$20	; ^
	defb $00,$00,$00,$00,$f8	; _
	defb $20,$20,$10,$00,$00	; `
	defb $00,$78,$88,$88,$78	; a
	defb $80,$f0,$88,$88,$f0	; b
	defb $00,$70,$80,$80,$78	; c
	defb $08,$78,$88,$88,$78	; d
	defb $00,$70,$f8,$80,$70	; e
	defb $18,$20,$78,$20,$20	; f
	defb $00,$78,$f8,$08,$70	; g
	defb $80,$f0,$88,$88,$88	; h
	defb $20,$60,$20,$20,$70	; i
	defb $08,$18,$08,$08,$38	; j
	defb $80,$90,$e0,$90,$88	; k
	defb $60,$20,$20,$20,$70	; l
	defb $00,$d0,$a8,$88,$88	; m
	defb $00,$f0,$88,$88,$88	; n
	defb $00,$70,$88,$88,$70	; o
	defb $00,$f0,$88,$f0,$80	; p
	defb $00,$78,$88,$78,$08	; q
	defb $00,$f0,$88,$80,$80	; r
	defb $00,$78,$e0,$38,$f0	; s
	defb $20,$78,$20,$20,$18	; t
	defb $00,$88,$88,$88,$78	; u
	defb $00,$88,$88,$50,$20	; v
	defb $00,$88,$a8,$d8,$88	; w
	defb $00,$88,$70,$88,$88	; x
	defb $00,$88,$78,$08,$70	; y
	defb $00,$f8,$20,$40,$f8	; z
	defb $18,$20,$c0,$20,$18	; {
	defb $20,$20,$20,$20,$20	; |
	defb $c0,$20,$18,$20,$c0	; }
	defb $68,$b0,$00,$00,$00	; ~
        defb $f8,$f8,$f8,$f8,$f8  ; block

