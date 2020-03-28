;
;	TMS9918 generic variant
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern clg();
;
;	Init and clear graphics screen
;
;	$Id: clg.asm $
;

	SECTION code_clib

	PUBLIC	clg
	PUBLIC	_clg
	
	EXTERN	msx_set_border
	EXTERN	msx_set_mode
	EXTERN	FILVRM
	EXTERN	__tms9918_attribute

clg:
_clg:

	ld	hl,2
	call msx_set_mode
	
	ld a,$1F   	; black on white attributes
	ld (__tms9918_attribute),a
    ld    hl,8192    ; set VRAM attribute area
    ld    bc,6144
    push  bc
    call  FILVRM
    pop   bc
    xor   a
    ld    h,a		; clear VRAM graphics page
    ld    l,a
    call    FILVRM
	
	ld	l,$0F
	call msx_set_border

	ret
