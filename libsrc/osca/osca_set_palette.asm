;
;	OSCA specific routines
;
;	extern void _FASTCALL_ osca_set_palette(char palette[256]);
;	set colour palette
;
;	$Id: osca_set_palette.asm,v 1.4 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC	osca_set_palette
	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1
	
    INCLUDE "osca.def"


osca_set_palette:
; __FASTCALL__, table ptr already in HL

	call swapgfxbk

	ld a,(vreg_palette_ctrl)
	push af
	ld a,@00000010		; set up OS colour palette 
	ld (vreg_palette_ctrl),a	; ensure palette 0 receives writes

	ld de,palette+2
	ld bc,256*2-2
	ldir

	pop af
	ld	(vreg_palette_ctrl),a

	jp swapgfxbk1
