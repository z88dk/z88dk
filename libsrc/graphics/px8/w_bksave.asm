;
;	Fast background save for the PX8
;
;	Space for background data needs to be 8 bytes bigger than on the TS2068
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
	;push	ix
	
	ld      hl,2
	add     hl,sp
	ld      e,(hl)
	inc     hl
	ld      d,(hl)

	ld		a,(de)
	ld		c,a		; Xsize
	inc		de
	ld		a,(de)
	ld		b,a		; Ysize
	inc		de

	push	de  ; sprite address


	inc     hl
	ld      a,(hl)	; Y (lsb)
	;ld	(ix+4),a	; store y
	ld	(ycoord),a
	ld	(ycoord_wr),a
	inc     hl
	;ld      d,(hl)  ; Y (msb)
	;ld	(ix+5),d
	
	inc     hl
	ld      a,(hl)  ; X (lsb)
	inc     hl
	ld      h,(hl)  ; X (msb)


	srl     h               ;hl = x / 8
	rra
	srl     h
	rra
	srl     h
	rra
	ld		(xcoord),a
	ld		(xcoord_wr),a
	
	;ld		a,(ix+0)	; Xsize
	ld		a,c	; Xsize
	;ld		b,(ix+1)	; Ysize
	ld		hl,height
	ld		(hl),b

	dec		a
	srl		a
	srl		a
	srl		a
	inc		a
	inc		a		; INT ((Xsize-1)/8+2)

	
	ld		(count),a
	dec		hl		; width
	ld		(hl),a
	ld		h,0
	ld		l,a
	push	hl	; keep for data size
	
	ld		l,h		; hl=0
	ld		d,h
	ld		e,b
.multiply
	add		hl,de
	dec		a
	jr		nz,multiply
	ld		e,6
	add		hl,de
	ld		(bk_packet_sz),hl
	
	
	pop		hl
	pop		de		; pick sprite struct now to keep the stack balanced
	
	push	hl		; data size
	inc		hl		; packet size = packet data + 1 for return code (space for background data must be 1 byte bigger)
	ld		(packet_sz),hl


	push	bc
	ld		hl,bk_packet_sz
	ld		bc,8	; copy the packet leader just built with background coordinates and sizes
	ldir
	ex		de,hl	; hl=sprite data addr
	pop		bc
	

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
	;pop		ix
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


;----------------------
bk_packet_sz:
	defw	0
;----------------------
;-  -  -  -  -  -  -  -
sndpkt_wr:
	defb	$25		; slave CPU command to write to the graphics memory ($25 = write)
xcoord_wr:
	defb	0
ycoord_wr:
	defb	0
width:
	defb	1
height:
	defb	1
	defb	0		; Operation (0=simply copy data)
;-  -  -  -  -  -  -  -

