;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode - used for MSX and SVI only
;
;	$Id: msx_set_mode.asm $
;

        SECTION code_clib
	PUBLIC	msx_set_mode
	PUBLIC	_msx_set_mode
	
	EXTERN	msxbios

IF FORmsx
	INCLUDE	"target/msx/def/msxbios.def"
ENDIF

IF FORsvi
    INCLUDE	"video/tms9918/vdp.inc"
    INCLUDE "target/svi/def/svibios.def"
    INCLUDE "target/svi/def/svibasic.def"
ENDIF

msx_set_mode:
_msx_set_mode:

	ex	de,hl
	ld	a,e
	ld	hl,INITXT
	and	a
	jr	z,set_mode
IF FORmsx
	ld	hl,INIT32
	dec	a
	jr	z,set_mode
ELSE
	dec	a
	jr	z,txt32
ENDIF
	ld	hl,INIGRP
	dec	a
	jr	z,set_mode
	ld	hl,INIMLT
set_mode:
	push	ix
	push	hl
	pop	ix
	call	msxbios
	pop	ix
	ret

IF FORsvi
txt32:
IF FORsc3000
	call  $39E2
	ld		a,64	; change reg#1 on SC3000, keep bit 6 enabled to avoid screen blanking
ELSE
	ld    hl,INIGRP		; (Graphics 2)
	call  set_mode
	xor   a			; change reg#0 on SVI
ENDIF
	; Now bend the configuration to Graphics mode 1
IF FORsvi	
	ld    (RG0SAV),a
ENDIF
	di
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
IF FORsc3000
	ld	a,1		; change reg#1 on SC3000
ELSE
	;change reg#0
	nop     ; ..do we have timing constraints ?
ENDIF
	or    $80
	ei
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF

IF FORsc3000
	; Bend register #2
	ld	a,$06
	di
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ld    a,2  ; reg2
	or    $80
	ei
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
ENDIF

	; Bend register #3
	ld	a,$80
	di
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ld    a,3  ; reg3
	or    $80
	ei
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	
	; Bend register #4
	xor	  a
	di
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	ld    a,4  ; reg4  -  PT./TXT/MCOL-GEN.TAB.
	or    $80
	ei
IF VDP_CMD < 0
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	
	
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
binary "../../../stdio/ansi/FONT8.BIN"
ENDIF

ENDIF
