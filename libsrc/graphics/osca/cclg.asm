;
;       Init graphics and clear screen
;       Stefano - Sept 2011
;
;
;	$Id: cclg.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

    INCLUDE "flos.def"
    INCLUDE "osca.def"

		SECTION   code_clib
                PUBLIC    cclg
                PUBLIC    _cclg

                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

;	EXTERN y_offset_list
;	EXTERN	base_graphics

;colours:	defw $000,$00f,$f00,$f0f,$0f0,$0ff,$ff0,$fff,$008,$800,$808,$080,$088,$880,$888

cclg:
_cclg:

	ld a,0
	ld (vreg_rasthi),a		; select y window reg
	ld a,$2e
	ld (vreg_window),a		; set y window size/position (256 lines)
	ld a,@00000100
	ld (vreg_rasthi),a		; select x window reg
	ld a,$8c
	ld (vreg_window),a		; set x window size/position (320 pixels)

	xor a
	ld (bitplane0a_loc),a	; Set display window address to VRAM: 0
	ld (bitplane0a_loc+1),a	; Set display window address to VRAM: 0
	ld (bitplane0a_loc+2),a	; Set display window address to VRAM: 0

	xor a			
	ld (bitplane_modulo),a	; no vram data_fetch modulo is required
	;;ld (sys_vram_location),a ; ser VRAM location at $2000

	; a=0 -> planar pixel mode
	ld a,@10000000
	ld (vreg_vidctrl),a		; Set bitmap mode (bit 0 = 0) + chunky pixel mode (bit 7 = 1)	

	ld a,@00001000
	ld (vreg_ext_vidctrl),a	; Enable hi-res mode
	

;-------------------------------------------------------------------------------
	call kjt_wait_vrt		; wait for last line of display
	call swapgfxbk

	xor a ; clear first 128KB of VRAM
	ld d,a
	ld e,a
	ld h,a
	ld l,a
	add	hl,sp

.clrv_lp 

	ld	(vreg_vidpage),a
	ld	sp,$2000+$2000
	ld	b,d	; 256*16*2 = 8192 = $2000
	
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

	inc a
	cp 16
	jr nz,clrv_lp
	ld	sp,hl

	jp swapgfxbk1


