;
;       Init graphics and clear screen
;       Stefano - Sept 2011
;
;
;	$Id: clg.asm,v 1.5 2016-06-22 22:40:19 dom Exp $
;

    INCLUDE "flos.def"
    INCLUDE "osca.def"

                SECTION   code_clib
                PUBLIC    clg
                PUBLIC    _clg
                
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1
                EXTERN	base_graphics

.clg
._clg

; Set up a 320x200 pixel, single bitplane
; display window in linear bitmap mode.

	ld a,0
	ld (vreg_rasthi),a		; select y window reg

	ld e,90			; y display settings for PAL display: 200 lines
	;ld e,61			; y display settings for PAL display: 240 lines
	in a,(sys_vreg_read)
	bit 5,a
	jr z,paltv
	ld e,56	; y display settings for non-PAL display: 200 lines
	;ld e,27 ; I'm only guessing this one for 240 lines
.paltv
	ld	a,e
	ld (vreg_window),a		; set y window size/position (200 lines in docs, but I hope to get to 240)
	
	;ld a,$5a
	;ld a,$2e
	;ld a,64
	;ld (vreg_window),a		; set y window size/position (200 lines)

	ld a,@00000100
	ld (vreg_rasthi),a		; select x window reg
	ld a,$8c
	ld (vreg_window),a		; set x window size/position (320 pixels)
	
	ld a,0
	ld (vreg_yhws_bplcount),a	; set 1 bitplane display
		
	ld a,0
	ld (vreg_vidctrl),a		; set bitmap mode + normal border + video enabled

	ld a,0
	ld (vreg_vidpage),a		; read / writes to VRAM page 0

	ld hl,0
	ld (bitplane0a_loc),hl	; start address of video datafetch for window [15:0]
	ld a,0
	ld (bitplane0a_loc+2),a	; start address of video datafetch for window [18:16]

	
;---------Set up palette -----------------------------------------------------


	ld hl,palette		; background = black, colour 1 = white
	ld (hl),$ff
	inc hl
	ld (hl),$0f
	inc hl
	ld (hl),0
	inc hl
	ld (hl),0


;--------- Clear VRAM --------------------


	call kjt_wait_vrt		; wait for last line of display
	call swapgfxbk
	
	ld	hl,$2000
	ld	(base_graphics),hl
		
	ld	hl,0
	ld	d,h
	ld	e,h
	ld	b,h
	di
	add	hl,sp
	ld	sp,$2000+$2000
.clgloop
	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	djnz	clgloop

	ld	sp,hl

	jp swapgfxbk1
