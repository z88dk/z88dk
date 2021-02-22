;
;       HRG1 Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - nov 2010
;
;
; $Id: w_putsprite.asm $
;

        SECTION   smc_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite

        INCLUDE "graphics/grafix.inc"

        EXTERN    div3_192

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)



.putsprite
._putsprite
        
		push ix
		
        ld      hl,4
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ; sprite address
        push    de
        pop     ix

        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ; x and y __gfx_coords

        inc     hl
        ld      a,(hl)  ; and/or/xor mode
		;xor		7		; alter opcode  "and/or/xor (hl)" -> "and/or/xor e"
        ld      (ortype2+1),a   ; Self modifying code

        inc     hl
        ld      a,(hl)
        ld      (ortype2),a     ; Self modifying code

        ;call    swapgfxbk
        ; @@@@@@@@@@@@
        ld      h,b
        ld      l,c
		
        ;call    w_pixeladdress


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
		sub		b		; remainder -> bit position within the target byte
		

		;ld		b,a
		;ld		a,5
		;sub		b
		
	
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
		
		out		(2),a		; Set address (LSB)
		ld		(lsb_sv),a

		ld	a,e			; [0000xxxx]
		rlca			; [000xxxx0]
		rlca			; [00xxxx00]
		;and @00111100
		or  d			; [00xxxxrr]
		;and	@00111111
		
		out (3),a		; Set address (MSB)
		ld		(msb_sv),a
		
		in		a,(4)
		ld		(curbyte),a

		ex	af,af		; restore bit pos. and Z flag
		
        ; @@@@@@@@@@@@
         ld       hl,offsets_table
         ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (wsmc1+1),a
         ;ld       (wsmc2+1),a

		ld		a,(lsb_sv)
		ex		af,af

        ;ld      h,d
        ;ld      l,e                 ; display location from pixeladdress
		ld		hl,curbyte

        ld      a,(ix+0)			; sprite width

.putspritew
         ld       d,a
         ld       b,(ix+1)        
.woloop  push     de
         push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         ld       d,8				;pixel-in-byte counter
         inc      ix
.wsmc1   ld       a,1               ;Load pixel mask
.wiloop  sla      c                 ;Test leftmost pixel
         jp       nc,wnoplot         ;See if a plot is needed

         ld       e,a

.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a

         ld       a,e

.wnoplot rlca
         cp 64
         jp       nz,wnotedge        ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
        ; push     de
		 ;ld       e,a
		 ld       a,(hl)
		 out      (5),a

 		 ex       af,af
		 inc      a
		 out      (2),a		; Set address (LSB)
		 ex       af,af

		 in       a,(4)
		 ld       (hl),a
		 ;ld       a,e
		 ;rlca		; trim the bit marker to 6 bits
		 ;rlca
 		 ld		a,1
        ; pop      de
        ;@@@@@@@@@@

.wnotedge

;.wsmc2   cp       1
;         jp       z,wover_1
		 dec d
         jp       z,wover_1

         djnz     wiloop

.nextline

        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
        ; push   de
		 ;ld       e,a
		 ld       a,(hl)
		 out      (5),a
		 
         call     hrg1_sprite_saddrpdown

		 in       a,(4)
		 ld       (hl),a
		 ;ld       a,e
        ; pop     de
        ;@@@@@@@@@@
         pop      bc                ;Restore data
		 pop      de
         djnz     woloop

         ;jp       __graphics_end
		 pop      ix
		 ret
        

.wover_1 ld       c,(ix+2)
         ld       d,8               ;pixel-in-byte counter
         inc      ix
         djnz     wiloop
         dec      ix
		 
		 jp nextline



; 00xxxxrr rrcccccc

	; cccc: 0-63 (col. addr)
	; rrrr: 0-15 (char addr)
	; xxxx: 0-11 (char rows)

;bc are usable
.hrg1_sprite_saddrpdown

		ld	a,(msb_sv)
		ld	c,a
		and	@00111100
		cp	@00101100	; 11
		jp	nz,incrow
		
		ld	a,(lsb_sv)
		ld	b,a
		rla
		rl c
		rla
		rl c
		ld	b,a
		ld	a,1
		add c
		rra
		rr b
		rra
		rr b
		and @00000011
		ld	(msb_sv),a
		out	(3),a
		ld a,b
		ld	(lsb_sv),a
		out	(2),a
		ex	af,af
		ret

.incrow
		ld	a,c
		add @00000100
		ld	(msb_sv),a
		out	(3),a
		ld	a,(lsb_sv)
		out	(2),a
		ex	af,af
		ret



	SECTION  bss_graphics
.lsb_sv
         defb   0
.msb_sv
         defb   0
.curbyte
         defb   0


	SECTION	rodata_graphics
.offsets_table
     defb   1,2,4,8,16,32
     

		 
