;
;	Fast background restore
;
;	Generic version (just a bit slow)
;
;	$Id: w_bkrestore.asm $
;

	SECTION	 code_graphics
	PUBLIC    bkrestore
	PUBLIC    _bkrestore

	EXTERN    subcpu_call
	;EXTERN    __graphics_end

.bkrestore
._bkrestore
	push	ix
; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	push	hl
	pop	ix

	ld	a,(ix+4)	; y
	;ld	d,(ix+5)
	ld	(ycoord),a
	
	ld	a,(ix+2)	; x
	ld	h,(ix+3)
	
	srl     h               ;hl = x / 8
	rra
	srl     h
	rra
	srl     h
	rra
	ld		(xcoord),a
	
	ld		a,(ix+0)	; Xsize
	ld		b,(ix+1)	; Ysize
	
	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)

	ld		c,a		;rowbytes
	ld		(width),a
	add		6
	ld		(packet_sz),a
	
	pop		de
	ld		hl,6	; jump over size/coordinates struct
	add		hl,de	; point to background data

.bkrestores
	push	bc		; b=Ysize, c=rowbytes
	
	ld		de,data
	ld		b,0
	ldir
	push	hl
	
	ld		hl,packet_wr
	call	subcpu_call
	ld		hl,ycoord
	inc		(hl)	; (ycoord)++
	
	pop		hl
	
	pop		bc		; b=Ysize, c=rowbytes
	djnz	bkrestores	; Ysize--

;	jp		__graphics_end
	pop		ix
	ret


		SECTION	data_clib

; master packet for write operation
packet_wr:
	defw	sndpkt
packet_sz:
	defw	7		; packet sz (=6+data len)
	defw	return_code	; packet addr expected back from the slave CPU (1 byte for return code only, we use the foo position of xcoord)
	defw	1		; size of the expected packet being received (just the return code)

return_code:
	defb	0
	
sndpkt:
	defb	$25		; slave CPU command to write to the graphics memory ($25 = write)
xcoord:
	defb	0
ycoord:
	defb	0
width:
	defb	1
height:
	defb	1
operation:
	defb	0		; Operation (0=simply copy data)
data:
	defs	60		; Space for a single graphics row

