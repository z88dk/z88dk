;
; 	ANSI Video handling for the Epson PX8
;	By Stefano Bodrato - 2019
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm $
;

	SECTION code_clib

	PUBLIC	ansi_SCROLLUP
	EXTERN	ansi_del_line
	
	EXTERN	subcpu_call
	

.ansi_SCROLLUP

	ld	hl,scroll_pkr
	jp	subcpu_call
	
	
	
	SECTION	data_clib

; master packet for write operation
scroll_pkr:
	defw	sndpkt
packet_sz:
	defw	12		; packet sz (=6+data len)
	defw	foo		; packet addr expected back from the slave CPU (1 byte for return code only, we use the foo position of xcoord)
	defw	1		; size of the expected packet being received (just the return code)

	
sndpkt:
	defb	$26		; slave CPU command to move a graphics block
xcoord:
	defb	0
ycoord:
	defb	8		; 6+2 to center the text vertically
width:
	defb	60
height:
	defb	6*9
xdest:
	defb	0
ydest:
	defb	2		; center the text vertically

foo:
	defb	0
