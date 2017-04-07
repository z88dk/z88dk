;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _lineHandler
	.globl _UNSAFE_SMS_copySpritestoSAT
	.globl _SMS_setLineCounter
	.globl _SMS_setLineInterruptHandler
	.globl _SMS_loadSpritePalette
	.globl _SMS_loadBGPalette
	.globl _SMS_finalizeSprites
	.globl _SMS_updateSpritePosition
	.globl _SMS_addSprite
	.globl _SMS_initSprites
	.globl _SMS_loadSTMcompressedTileMapArea
	.globl _SMS_loadPSGaidencompressedTiles
	.globl _SMS_waitForVBlank
	.globl _SMS_setSpriteMode
	.globl _SMS_setBGScrollX
	.globl _SMS_VDPturnOffFeature
	.globl _SMS_VDPturnOnFeature
	.globl _pole_x
	.globl _lineCnt
	.globl _offs
	.globl _SMS_SRAM
	.globl _SRAM_bank_to_be_mapped_on_slot2
	.globl _ROM_bank_to_be_mapped_on_slot2
	.globl _shft
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ROM_bank_to_be_mapped_on_slot2	=	0xffff
_SRAM_bank_to_be_mapped_on_slot2	=	0xfffc
_SMS_SRAM	=	0x8000
_offs::
	.ds 96
_lineCnt::
	.ds 1
_pole_x::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:42: void lineHandler(void) {
;	---------------------------------
; Function lineHandler
; ---------------------------------
_lineHandler::
;main.c:43: SMS_setBGScrollX (offs[lineCnt++]);
	ld	iy,#_lineCnt
	ld	c,0 (iy)
	inc	0 (iy)
	ld	hl,#_offs
	ld	b,#0x00
	add	hl, bc
	ld	l,(hl)
	jp  _SMS_setBGScrollX
_shft:
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x0a	; 10
	.db #0x0b	; 11
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x0e	; 14
	.db #0x0f	; 15
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.db #0x17	; 23
;main.c:46: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:50: SMS_loadPSGaidencompressedTiles (grass_reduced__tiles__psgcompr,0);
	ld	hl,#0x0000
	push	hl
	ld	hl,#_grass_reduced__tiles__psgcompr
	push	hl
	call	_SMS_loadPSGaidencompressedTiles
	pop	af
;main.c:51: SMS_loadSTMcompressedTileMap (0, 0, grass_reduced__tilemap__stmcompr);
	ld	h,#0x20
	ex	(sp),hl
	inc	sp
	ld	hl,#_grass_reduced__tilemap__stmcompr
	push	hl
	ld	hl,#0x0000
	push	hl
	call	_SMS_loadSTMcompressedTileMapArea
	pop	af
	pop	af
	inc	sp
;main.c:52: SMS_loadBGPalette (grass_reduced__palette__bin);
	ld	hl,#_grass_reduced__palette__bin
	call	_SMS_loadBGPalette
;main.c:53: SMS_loadPSGaidencompressedTiles (pole__tiles__psgcompr,HOLEINSAT);
	ld	hl,#0x01fa
	push	hl
	ld	hl,#_pole__tiles__psgcompr
	push	hl
	call	_SMS_loadPSGaidencompressedTiles
	pop	af
	pop	af
;main.c:54: SMS_loadSpritePalette (pole__palette__bin);
	ld	hl,#_pole__palette__bin
	call	_SMS_loadSpritePalette
;main.c:57: SMS_setLineInterruptHandler(&lineHandler);
	ld	hl,#_lineHandler
	push	hl
	call	_SMS_setLineInterruptHandler
;main.c:58: SMS_setLineCounter(1);    /* we're updating every 2 scanlines... */
	ld	h,#0x01
	ex	(sp),hl
	inc	sp
	call	_SMS_setLineCounter
	inc	sp
;main.c:59: SMS_enableLineInterrupt();
	ld	hl,#0x0010
	call	_SMS_VDPturnOnFeature
;main.c:62: SMS_initSprites();
	call	_SMS_initSprites
;main.c:63: for (i=0;i<5;i++)
	ld	c,#0x00
00107$:
;main.c:64: SMS_addSprite(0,0,HOLEINSAT);
	push	bc
	ld	hl,#0xfa00
	push	hl
	xor	a, a
	push	af
	inc	sp
	call	_SMS_addSprite
	pop	af
	inc	sp
	pop	bc
;main.c:63: for (i=0;i<5;i++)
	inc	c
	ld	a,c
	sub	a, #0x05
	jr	C,00107$
;main.c:65: SMS_finalizeSprites();
	call	_SMS_finalizeSprites
;main.c:68: SMS_VDPturnOnFeature(VDPFEATURE_LEFTCOLBLANK);
	ld	hl,#0x0020
	call	_SMS_VDPturnOnFeature
;main.c:69: SMS_setSpriteMode(SPRITEMODE_TALL);
	ld	l,#0x01
	call	_SMS_setSpriteMode
;main.c:70: SMS_displayOn();
	ld	hl,#0x0140
	call	_SMS_VDPturnOnFeature
00111$:
;main.c:72: SMS_waitForVBlank ();
	call	_SMS_waitForVBlank
;main.c:73: SMS_disableLineInterrupt();
	ld	hl,#0x0010
	call	_SMS_VDPturnOffFeature
;main.c:74: UNSAFE_SMS_copySpritestoSAT();
	call	_UNSAFE_SMS_copySpritestoSAT
;main.c:75: offs[0]+=shft[0];
	ld	hl, #_offs + 0
	ld	c,(hl)
	ld	hl, #_shft + 0
	ld	b,(hl)
	ld	a,c
	add	a, b
	ld	c,a
	ld	hl,#_offs
	ld	(hl),c
;main.c:76: SMS_setBGScrollX (offs[0]);
	ld	l,c
	call	_SMS_setBGScrollX
;main.c:78: do {
	ld	c,#0x01
00102$:
;main.c:80: offs[i]+=shft[i];
	ld	a,#<(_offs)
	add	a, c
	ld	e,a
	ld	a,#>(_offs)
	adc	a, #0x00
	ld	d,a
	ld	a,(de)
	ld	b,a
	ld	a,#<(_shft)
	add	a, c
	ld	l,a
	ld	a,#>(_shft)
	adc	a, #0x00
	ld	h,a
	ld	l,(hl)
	ld	a,b
	add	a, l
	ld	(de),a
;main.c:81: i++;
	inc	c
;main.c:82: } while (i<(192/2));
	ld	a,c
	sub	a, #0x60
	jr	C,00102$
;main.c:83: lineCnt=1;
	ld	hl,#_lineCnt + 0
	ld	(hl), #0x01
;main.c:87: for (i=0;i<5;i++) {
	ld	bc,#0x0034
00109$:
;main.c:88: SMS_updateSpritePosition(i,pole_x,pole_y);
	push	bc
	ld	a,c
	push	af
	inc	sp
	ld	a,(_pole_x)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_SMS_updateSpritePosition
	pop	af
	inc	sp
	pop	bc
;main.c:89: pole_y+=16;
	ld	a,c
	add	a, #0x10
	ld	c,a
;main.c:87: for (i=0;i<5;i++) {
	inc	b
	ld	a,b
	sub	a, #0x05
	jr	C,00109$
;main.c:91: pole_x+=5;
	ld	hl,#_pole_x
	ld	a,(hl)
	add	a, #0x05
	ld	(hl),a
;main.c:92: SMS_enableLineInterrupt();
	ld	hl,#0x0010
	call	_SMS_VDPturnOnFeature
	jr	00111$
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
