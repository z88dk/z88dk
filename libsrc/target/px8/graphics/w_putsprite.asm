;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - nov 2010
;
; Epson PX-8 High Resolution version
;
;
; $Id: w_putsprite.asm $
;

        SECTION   smc_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite
		
		EXTERN    subcpu_call

        ;EXTERN    swapgfxbk
        ;EXTERN    __graphics_end

        INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)



.putsprite
._putsprite
        
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        push    de  		; sprite address

        inc     hl
		ld      a,(hl)
		ld		(ycoord),a
        inc     hl
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ; x and y __gfx_coords
		

		xor		a
		ld		(smc1),a	; reset SMC tricks, they will be updated only for mask operations
		ld		(smc2),a
		ld		(smc3),a
		
        inc     hl
        ld      a,(hl)  ; and/or/xor mode
		
		; 166 - and {10 100 110} -> 1
		; 182 - or  [10 110 110] -> 2
		; 174 - xor [10 101 110] -> 3
		
		ld	e,3
		cp	174	; xor(hl) opcode
		jr	z,setmode
		dec	e
		cp	182	; or(hl) opcode
		jr	z,setmode
		dec	e
		
		ld	a,$2F		; CPL
		ld	(smc1),a
		ld	(smc2),a
		ld	a,$37		; SCF
		ld	(smc3),a
		
.setmode
		ld	a,e
		ld	(operation),a
		

		ld	a,c
		and	7
		ld	(loopcount2+1),a
		
		srl	b               ;hl = x / 8
		rr	c
		srl	b
		rr	c
		srl	b
		rr	c
		ld	a,c
		ld	(xcoord),a

		
		pop		hl  		; sprite address
		ld		a,(hl)		; x size in pixels
		inc		hl
		add	7
		srl a
		srl a
		srl a
		ld	(oloop+1),a		; sprite size in bytes
		
		inc a				; +1 for possible bit shifting !
		ld	(width),a
		ld	e,a				; x size in bytes
		ld	d,0
		ld	a,(hl)			; y size
		ld	(height),a
		
		inc		hl
		push	hl				; sprite data ptr

		
		ld	h,d
		ld	l,d			; hl=0
.multiply
		add	hl,de
		dec	a
		jr	nz,multiply
		ld	(shiftcount+1),hl
		
		ld	de,6
		add	hl,de					; add packet header (command, parameters..) to data size
		ld	(packet_sz),hl		; packet size
		

		ld	a,(height)
		ld	c,a
		
		pop	hl				; <- sprite data
		ld	de,data

.oloop
		ld	b,0
.loopcount
		ld	a,(hl)
.smc1
		nop		; nop/cpl
		ld	(de),a
		inc hl
		inc de
		xor a
		cp	b
		jr	z,noloop
		djnz	loopcount
.noloop
.smc2
		nop		; nop/cpl
		ld	(de),a	; add a blank byte on every row for possible shifting
		inc de
		dec c
		jr	nz,oloop
		
		
		
.loopcount2
		ld	b,0
		xor a
.smc3
		nop		; nop/scf
		push	af
		cp	b
		jr	z,noshift
		
.shiftcount
		ld	de,0
		ld	hl,data
.shiftloop
		pop	af
		ld	a,(hl)
		rra
		ld	(hl),a
		push af
		inc hl
		dec	de
		ld	a,d
		or	e
		jr	nz,shiftloop
		djnz	shiftcount
.noshift
		pop	af
		

		ld	hl,packet_wr
		jp	subcpu_call




		SECTION	data_clib

; master packet for write operation
packet_wr:
	defw	sndpkt
packet_sz:
	defw	7		; packet sz (=6+data len)
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
	defb	1
operation:
	defb	0		; Operation (only in WR mode)
data:
	defs	255		; warning !  picture size is limited, x*y must be <= 255 !

