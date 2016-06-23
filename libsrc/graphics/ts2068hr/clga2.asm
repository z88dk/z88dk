
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clga2.asm,v 1.3 2016-06-23 19:41:02 dom Exp $
;


;Usage: clga(struct *pixels)


	INCLUDE	"graphics/grafix.inc"
	SECTION code_clib
	PUBLIC    clga
	PUBLIC    _clga
	EXTERN	w_pixeladdress

.clga
._clga
		push	ix	;save callers
		ld	ix,2
		add	ix,sp
		ld	h,(ix+9); x
		ld	a,1
		cp	h
		jr	c,clga_exit
		ld	e,(ix+6); y
		ld	a,maxy
		cp	e
		jr	c,clga_exit

		ld	a,(ix+2); height
		ld	c,(ix+4); width
		ld	b,(ix+5); width
		ld	d,0; 
		ld	l,(ix+8); x

		ld	ixl,a ; ix forgotten
		ld	d,0

		push	bc
		call	w_pixeladdress
		ld	b,a
		ld	a,1
		jr	z,next
.loop
		rlca
		djnz	loop
.next
		cpl
		ld	l,a
		pop	bc
.outer_loop
		push	bc            ; 1
		push	de            ; 2
		ld	a,l
		ld	h,l
		cp	127
		jr	z,fill1
.inner_loop0
		ld	a,(de)
		and	h
		ld	(de),a
		dec	bc
		rrc	h
		jr	nc,fill
		ld	a,b
		or	c
		jr	nz,inner_loop0
.fill
		call	INC_X
		jr	c,wypad
.fill1
		push	bc
		srl	b ; >> 3
		rr	c
		srl	c
		srl	c
		ld	a,c
		or	c
		ld	b,c
		jr	z,last

.inner_loop1
		xor	a
		ld	(de),a
		call	INC_X
		jr	c,wypad
		djnz	inner_loop1

.last
		pop	bc           ; 3
		ld	a,c
		and	7
		jr	z,wypad
		ld	b,a
.inner_loop2
		ld	a,(de)
		and	h
		ld	(de),a
		rrc	h
		jr	nc,wypad
		djnz	inner_loop2

.wypad
		pop	de ; 2
		pop	bc ; 1
		dec	ixl
		jr	z,clga_exit
		call	incy
		jr	c,clga_exit
		jr	outer_loop
.clga_exit
		pop	ix
		ret
; (hl) mask
; de - screen address
.INC_X
		bit 5,d
		jr nz,first
		set 5,d
		or a
		ret
.first
		res 5,d
		inc e
		ld a,e
		and $1f
		ret nz
		scf
		ret

.incy
		inc d
		ld a,d
		and $07
		ret nz

		ld a,d
		sub $08
		ld d,a
		ld a,e
		add a,$20
		ld e,a
		ret nc

		ld a,d
		add a,$08
		ld d,a

		and 95
		cp $58
		ccf
		ret
