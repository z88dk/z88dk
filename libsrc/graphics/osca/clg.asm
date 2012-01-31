;
;       Init graphics and clear screen
;       Stefano - Sept 2011
;
;
;	$Id: clg.asm,v 1.2 2012-01-31 20:58:07 stefano Exp $
;

    INCLUDE "flos.def"
    INCLUDE "osca.def"

                XLIB    clg
                
                LIB     swapgfxbk
                XREF    swapgfxbk1
                XREF	base_graphics

.clg

; Set up a 320x200 pixel, single bitplane
; display window in linear bitmap mode.

	ld a,0
	ld (vreg_rasthi),a		; select y window reg
	;ld a,$5a
	;ld a,$2e
	ld a,64
	ld (vreg_window),a		; set y window size/position (200 lines)
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
