;
;	OSCA specific routines
;
;	extern void _FASTCALL_ osca_set_palette(char palette[256]);
;	set colour palette
;
;	$Id: osca_set_palette.asm,v 1.2 2012-02-29 07:03:53 stefano Exp $
;


	XLIB	osca_set_palette
	LIB     swapgfxbk
	XREF    swapgfxbk1
	
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
