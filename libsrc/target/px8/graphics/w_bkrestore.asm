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
; __FASTCALL__ : sprite ptr in HL
	inc hl
	inc hl
	ld	e,(hl)
	inc hl
	ld	d,(hl)
	inc hl
	ld	(packet_sz),de
	ld	(packet_wr),hl
	
	ld	hl,packet_wr
	jp	subcpu_call
	


		SECTION	data_clib

; master packet for write operation
packet_wr:
	defw	0		; sndpkt_wr, copied to top of bagkground data
packet_sz:
	defw	7		; packet sz (=6+data len)
	defw	return_code	; packet addr expected back from the slave CPU (1 byte for return code only, we use the foo position of xcoord)
	defw	1		; size of the expected packet being received (just the return code)

return_code:
	defb	0
	
