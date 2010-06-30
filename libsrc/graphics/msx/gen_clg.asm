;
;	z88dk library: Generic VDP support code
;
;
;	$Id: gen_clg.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

        XLIB  clg
        
        LIB	msx_set_mode
        LIB	msx_color
        LIB	FILVRM

.clg
	ld    hl,2		; set graphics mode
	call  msx_set_mode

	ld	hl,15
	push hl		; border
	push hl		; paper
	ld	hl,0	; ink
	push hl
	call msx_color
	pop hl
	pop hl
	pop hl
	
	ld bc,6144
	ld a,$1F
	ld hl,8192
	jp FILVRM
