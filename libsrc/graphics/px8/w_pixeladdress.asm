;
;	PX-8 graphics  routines
;	by Stefano Bodrato, 2019
;
;	This function transfers data from the VRAM into a memory buffer
;	1 byte pointed by coordinates HL,DE
;
;	Screen rez:  480x64 = 60x64 = 3840 bytes
;
;	$Id: w_pixeladdress.asm $
;

	SECTION	code_clib
	PUBLIC	w_pixeladdress
	
	EXTERN subcpu_call
	
w_pixeladdress:

	push bc
	
	ld	a,e
	ld	(ycoord),a
	
	ld	a,l
	and     7             ;a = x mod 8
	push af

	srl     h               ;hl = x / 8
	rr      l
	srl     h
	rr      l
	srl     h
	rr      l
	
	ld	a,l
	ld	(xcoord),a

	ld	hl,packet
	
	call subcpu_call
	
	pop	af
	
	xor     7
	
	ld	de,dmabuf

	pop bc
	ret



	SECTION	data_clib
	
packet:
	defw	sndpkt
	defw	4		; packet sz
	defw	rcvpkt	; packet addr expected back from the slave CPU
	defw	2		; size of the expected packet being received ('bytes'+1)

sndpkt:
	defb	$24		; slave CPU command to read from the graphics memory
xcoord:
	defb	0
ycoord:
	defb	0
;bytes:
	defb	1		; number of data bytes to be received

rcvpkt:
	defb	0		; return code from slave CPU
dmabuf:
	defs	1		; 'bytes' stream
