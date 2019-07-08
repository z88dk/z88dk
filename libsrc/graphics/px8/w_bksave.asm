;
;	Fast background save for the PX8
;
;	Space for background data needs be 1 byte bigger than on the TS2068
;
;	$Id: w_bksave.asm $
;

	SECTION	  code_graphics
	PUBLIC    bksave
	PUBLIC    _bksave

	EXTERN    subcpu_call
	;EXTERN    __graphics_end


.bksave
._bksave
	push	ix
	
	ld      hl,4
	add     hl,sp
	ld      e,(hl)
	inc     hl
	ld      d,(hl)  ; sprite address

	push	de

	push	de
	pop	ix

	inc     hl
	ld      a,(hl)  
	ld	(ix+4),a	; store y
	ld	(ycoord),a
	inc     hl
	;ld      d,(hl)  ; y
	;ld	(ix+5),d
	
	inc     hl
	ld      a,(hl)
	inc     hl
	ld      h,(hl)
;	ld		l,a		; x

;	ld	h,d	; current x coordinate
;	ld	l,e	; current y coordinate

	ld	(ix+2),a	; store x
	ld	(ix+3),h
	srl     h               ;hl = x / 8
	rra
	srl     h
	rra
	srl     h
	rra
	ld		(xcoord),a
	
	ld		a,(ix+0)	; Xsize
	ld		b,(ix+1)	; Ysize

	dec		a
	srl		a
	srl		a
	srl		a
	inc		a
	inc		a		; INT ((Xsize-1)/8+2)

	pop		de		; pick sprite struct now to keep the stack balanced
	
	ld		(count),a
	ld		h,0
	ld		l,a
	push	hl		; data size
	inc		hl		; packet size = packet data + 1 for return code (space for background data must be 1 byte bigger)
	ld		(packet_sz),hl
	
	ld		hl,6	; jump over size/coordinates struct
	add		hl,de	; point to background data
	pop		de		; data size
	
.bksaves
	push	bc		; b=Ysize
	push	de		; data size
	
	dec		hl		; 1 extra byte will be sent as "return code"
	ld		a,(hl)	; .. thus, we save the existing byte before being overwritten
	push	af
	ld		(packet_addr),hl	; current data pos
	push	hl
	
	ld		hl,packet_rd
	call	subcpu_call
	ld		hl,ycoord
	inc		(hl)
	
	pop		hl		; current data pos
	pop		af
	ld		(hl),a	; restore data overwritten by "return code"
	inc		hl
	pop		de		; data size
	add		hl,de
	
	pop		bc
	djnz	bksaves

	;jp		__graphics_end
	pop		ix
	ret



	SECTION	data_clib

; master packet for read operation
packet_rd:
	defw	sndpkt
	defw	4		; packet sz
packet_addr:
	defw	0	; addr for packet data expected back from the slave CPU
packet_sz:
	defw	1	; size of the expected packet being received


sndpkt:
	defb	$24		; slave CPU command to read from the graphics memory ($25 = write, with different parameters)
xcoord:
	defb	0
ycoord:
	defb	0
count:
	defb	0

