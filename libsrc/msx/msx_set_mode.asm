;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: msx_set_mode.asm $
;

        SECTION code_clib
	PUBLIC	msx_set_mode
	PUBLIC	_msx_set_mode
	
	EXTERN	msxbios

IF FORsvi
    INCLUDE	"msx/vdp.inc"
    INCLUDE "arch/svi/def/svibios.def"
    INCLUDE "arch/svi/def/svibasic.def"
ENDIF

IF FORsc3000
    INCLUDE	"msx/vdp.inc"
	EXTERN     LDIRVM
	EXTERN     FILVRM
ENDIF

msx_set_mode:
_msx_set_mode:

IF FORmsx
	; MSX supports G1 natively
ELSE
	ld	a,h
	or	l
	jr	z,txt32
setmode:
ENDIF
	push	ix
	push	hl
	pop	ix
	call	msxbios
	pop	ix
	ret

IF FORmsx
	; MSX supports G1 natively
ELSE
txt32:
IF FORsc3000
	call  $39E2
	ld		a,64	; change reg#1 on SC3000, keep bit 6 enabled to avoid screen blanking
ELSE
	ld    hl,INIGRP		; (Graphics 2)
	call  setmode
	xor   a			; change reg#0 on SVI
ENDIF
	; Now bend the configuration to Graphics mode 1
IF FORsvi	
	ld    (RG0SAV),a
ENDIF
	di
	out   (VDP_CMD),a
IF FORsc3000
	ld	a,1		; change reg#1 on SC3000
ELSE
	;change reg#0
	nop     ; ..do we have timing constraints ?
ENDIF
	or    $80
	ei
	out   (VDP_CMD),a

IF FORsc3000
	; Bend register #2
	ld	a,$06
	di
	out   (VDP_CMD),a
	ld    a,2  ; reg2
	or    $80
	ei
	out   (VDP_CMD),a
ENDIF

	; Bend register #3
	ld	a,$80
	di
	out   (VDP_CMD),a
	ld    a,3  ; reg3
	or    $80
	ei
	out   (VDP_CMD),a
	
	; Bend register #4
	xor	  a
	di
	out   (VDP_CMD),a
	ld    a,4  ; reg4  -  PT./TXT/MCOL-GEN.TAB.
	or    $80
	ei
	out   (VDP_CMD),a
	
	
	ld	hl,$1800		; SCREEN 1 name table
	ld	bc,32*24
	ld	a,c	; ' '
	ld ix,FILVRM
	call	msxbios

IF FORsvi
	LD A,(FORCLR)
	ADD A,A
	ADD A,A
	ADD A,A
	ADD A,A
	LD HL,BAKCLR
	OR (HL)
ELSE
	ld a,$1F
ENDIF
	ld	hl,$2000		; SCREEN 1 color table
	ld	bc,32
	ld ix,FILVRM
	call	msxbios

IF FORsc3000
	ld	hl,0x10C0		; point to the font in ROM
ELSE
	ld	hl,font
ENDIF
	ld	de,0			; SCREEN 1 character pattern table
	ld	bc,2048
	ld	ix,LDIRVM
	call	msxbios

	ret
	
IF FORsc3000
	; using the ROM font
ELSE
.font
binary "../stdio/ansi/FONT8.BIN"
ENDIF

ENDIF
