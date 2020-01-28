;
; 	ANSI Video handling for the Epson PX8
;	By Stefano Bodrato - 2019
;
; 	Handles Attributes INVERSE, BOLD + UNDERLINED
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;


	SECTION smc_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	subcpu_call
	
	EXTERN	ansifont
	EXTERN	__console_y
	EXTERN	__console_x
	
	PUBLIC	INVRS
	PUBLIC	BOLD
	PUBLIC	UNDRLN



.ansi_CHAR
		ld	hl,data+5
		ld	(hl),255	; underline the character by default, then ovverride if not necessary
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	d,h
		ld	e,l
		add hl,hl
		add hl,de
		;ld	de,font8x6-192
		ld	de,ansifont-192
		add	hl,de
		ld	de,data
.UNDRLN
		ld	b,6		; 5 (underlined) or 6
		
.copyloop
		ld	a,(hl)
.BOLD
		nop	;	rla
		nop	;	or (hl)
.INVRS
		nop			; set to CPL to enable INVERSE
		ld	(de),a
		inc hl
		inc de
		djnz	copyloop
		
		
		ld	a,(__console_x)
		ld	(xcoord),a
		ld	a,(__console_y)
		add a		; *2
		ld	e,a
		add a		; *4
		add e		; *6
		add 2		; center the text vertically
		ld	(ycoord),a

		ld	hl,packet_wr
		jp	subcpu_call




		SECTION	data_clib

; master packet for write operation
packet_wr:
	defw	sndpkt
packet_sz:
	defw	12		; packet sz (=6+data len)
	defw	xcoord	; packet addr expected back from the slave CPU (1 byte for return code only, we use the foo position of xcoord)
	defw	1		; size of the expected packet being received (just the return code)

	
sndpkt:
	defb	$25		; slave CPU command to write to the graphics memory ($25 = write)
xcoord:
	defb	0
ycoord:
	defb	0
width:
	defb	1
height:
	defb	6
operation:
	defb	0		; Operation (0=store)
data:
	defs	6

