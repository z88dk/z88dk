;
;	OSCA specific routines
;
;	HRG PLOT
;
;	$Id: cplotpixel.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

        SECTION   code_clib
	PUBLIC   cplotpixel
;	EXTERN    y_offset_list
	
	EXTERN    l_cmp

    INCLUDE "osca.def"
    
;x_coord: defw 0
;y_coord: defw 0
;pixel_colour: defb 0

;;cplotpixel:
; plot a pixel at (x_coord), (y_coord) in colour (pixel_colour)
; For clarity, no attempt has been made to optimize this

; in:  hl,de,a'    = (x,y) coordinate of pixel, color

; HIRES PUT PIXEL: hl,de,a' = (x,y) coordinate of pixel, color
 
cplotpixel:
	 
	push hl
	ld h,0
	ld l,e
	xor a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl ; y+*64
	ld d,e ; ..+y*256
	ld e,0
	add hl,de
	adc a,0 ;a = carry
	 
	pop de ;divide x coord by 2 as there are two pixels at each byte location
	ld c,0 ;c = left (0), right (1) nybble select
	srl d
	rr e
	rr c
	add hl,de ;hl = address in VRAM where pixel is to go [15:0]
	adc a,0 ;a = carry
	ld b,h ;convert linear address to 8KB page and offset 0-8191 byte offset
	sla b
	rl a
	sla b
	rl a
	sla b
	rl a
	ld (vreg_vidpage),a ;select relevant 8KB video page
	ld a,h ;adjust pixel location to position of VRAM window in Z80 space ($2000-$3FFF)
	and $1f
	or $20
	ld h,a ;adjust
	 
	ex af,af' ;pixel colour
	bit 7,c
	jr z,leftnyb
	 
	and $0f
	ld c,a ;do right pixel
	ld a,(hl)
	and $f0
	or c
	ld (hl),a
	ret
	 
.leftnyb
	rrca ;do left pixel
	rrca
	rrca
	rrca
	and $f0
	ld c,a
	ld a,(hl)
	and $0f
	or c
	ld (hl),a
	ret

