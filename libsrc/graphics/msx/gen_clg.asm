;
;	z88dk library: Generic VDP support code
;
;
;	$Id: gen_clg.asm,v 1.4 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
        PUBLIC  clg
        PUBLIC  _clg
        
        EXTERN	msx_set_mode
        EXTERN	msx_color
        EXTERN	FILVRM

.clg
._clg
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
	
	ld bc,6144	; set VRAM attribute area
	ld a,$1F
	ld hl,8192
	push bc
	call FILVRM
	pop bc		; clear VRAM picture area
	xor a
	ld	h,a
	ld	l,a
	jp	FILVRM
