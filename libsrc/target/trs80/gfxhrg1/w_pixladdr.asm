;
;       HRG1 Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

        SECTION   code_graphics
		
		PUBLIC    w_pixeladdress

        EXTERN    div3_192

		EXTERN   __curbyte

;
;       $Id: w_pixladdr.asm $
;

; ******************************************************************
;
; Get absolute  pixel address in map of virtual (x,y) coordinate.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; out: hl=de    = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ......hl/ixiy same
;  afbcde../.... different
;

.w_pixeladdress




; 00xxxxrr rrcccccc

	; cccc: 0-63 (col. addr)
	; rrrr: 0-15 (char addr)
	; xxxx: 0-11 (char rows)


		
		ld		d,l		; x  LSB

        srl		h		;hl = x / 2
        rr		l
		
		ld		bc,div3_192
		add		hl,bc
		ld		a,(hl)	; a = x/6
		ld		c,a		; (cccccc)
		
		
		
		;  remainder for pixel pos.
		add		a		; *2
		ld		b,a
		add		a		; *4
		add		b		; *6    ..a possible overflow will be dealt by CY, we can ignore it		
		ld		b,a
		
		ld		a,d		; x  LSB
		sub		b		; reminder -> bit position within the target byte
		
	
		ex		af,af	; keep bit position and Z flag



	
		ld		b,e		; y
		ld		d,0

		ld		hl,div3_192
		add		hl,de
		ld		a,(hl)	; a=y/3
		srl		a
		srl		a		; a=y/12

		ld		d,a		; (rrrr)
		
		add		a		; *2
		add		a		; *4
		ld		e,a
		add		a		; *8
		add		e		; *12
		ld		e,a
		ld		a,b		; y
		sub		e
		ld		e,a		; (xxxx)
		



		; target address: [00xxxxrr] rrcccccc
		
		ld	a,c			; 00cccccc
		rlca			; 0cccccc0
		rlca			; cccccc00
		
		rr d
		rra				; [00000rrr] rcccccc-
		rr d
		rra				; [000000rr] rrcccccc
		
		out (2),a		; Set address (LSB)
		

		ld	a,e			; [0000xxxx]
		rlca			; [000xxxx0]
		rlca			; [00xxxx00]
		;and @00111100
		or  d			; [00xxxxrr]
		;and	@00111111
		
		out (3),a		; Set address (MSB)
		
		ex	af,af		; restore bit pos. and Z flag
        ret
        
