;
;	PX-8 graphics  routines
;	by Stefano Bodrato, 2019
;
;	This function transfers 1 data byte from the VRAM into a memory buffer
;	pointed by pixel coordinates HL,DE
;	Data in (dmabuf) can then be altered and stored back in VRAM with pix_return
;
;	Screen rez:  480x64 = 60x64 = 3840 bytes
;
;	$Id: w_pixeladdress.asm $
;

	SECTION	code_clib
	PUBLIC	w_pixeladdress
	PUBLIC	pix_return
	
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
	
	ld	hl,sndpkt
	res	0,(hl)		; alter slave CPU command to 'read'

	ld	hl,packet
	
	call subcpu_call
	
	pop	af
	
	xor     7
	
	ld	de,dmabuf

	pop bc
	ret


.pix_return
	ld	hl,sndpkt
	inc (hl)		; alter slave CPU command to 'write'
	ld	a,(dmabuf)	; pick altered data..
	ld	(data),a	; ..and copy it to the packet being sent
	ld	hl,packet_wr
	jp	subcpu_call



	SECTION	data_clib

; master packet for read operation
packet:
	defw	sndpkt
	defw	4		; packet sz (=7 when writing)
	defw	rcvpkt	; packet addr expected back from the slave CPU
	defw	2		; size of the expected packet being received ('bytes'+1)

; master packet for write operation
packet_wr:
	defw	sndpkt
	defw	7		; packet sz (=7 when writing)
	defw	rcvpkt	; packet addr expected back from the slave CPU
	defw	1		; size of the expected packet being received (just the return code)

	
sndpkt:
	defb	$24		; slave CPU command to read from the graphics memory ($25 = write)
xcoord:
	defb	0
ycoord:
	defb	0
; Number of data bytes to be received (when reading) / height (when writing)..  always 1
	defb	1
; Extra bytes used in the 'write' command only
	defb	1		; width (used only in wr operation)
	defb	0		; Operation (only in WR mode)
data:
	defb	0

	
rcvpkt:
	defb	0		; return code from slave CPU
dmabuf:
	defs	1		; 'bytes' stream, (only 1 byte long)

