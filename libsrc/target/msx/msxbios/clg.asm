;
;	MSX specific routines
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
	
	EXTERN	msxbios
	EXTERN	__tms9918_attribute
	EXTERN	__tms9918_screen_mode

IF FORmsx
	INCLUDE	"target/msx/def/msxbios.def"
	INCLUDE	"target/msx/def/msxbasic.def"
ENDIF

IF FORsvi
    INCLUDE "target/svi/def/svibios.def"
    INCLUDE "target/svi/def/svibasic.def"
ENDIF

clg:
_clg:
	push ix
	
	LD A,$0F	; white
	LD (BAKCLR),A
	LD (BDRCLR),A
	;ld    ix,SETBORDER
	;call  msxbios
	LD A,$01	; black
	LD (FORCLR),A

	ld    ix,INIGRP
    call  msxbios
	ld	a,2
	ld	(__tms9918_screen_mode),a
	
	ld    a,$1F   	; black on white attributes
	ld    (__tms9918_attribute),a
    ld    hl,8192    ; set VRAM attribute area
    ld    bc,6144
    push  bc
	ld    ix,FILVRM
    call  msxbios
    pop   bc
    xor   a
    ld    h,a		; clear VRAM graphics page
    ld    l,a
	ld    ix,FILVRM
    call  msxbios
	
	pop	ix
	ret
