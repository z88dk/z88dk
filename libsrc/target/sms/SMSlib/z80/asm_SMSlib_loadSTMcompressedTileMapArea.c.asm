; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_loadSTMcompressedTileMapArea

asm_SMSlib_loadSTMcompressedTileMapArea:

   ; void SMS_loadSTMcompressedTileMapArea (unsigned char x, unsigned char y, unsigned char *src, unsigned char width)
   ; compiled from c

	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl,-15
	add	hl,sp
	ld	sp,hl
	ld	a,0x00
	ld	(ix-10),a
	ld	(ix-9),a
	ld	hl,0x0000
	ex	(sp), hl
	ld	l,(ix+5)
	xor	a,a
	ld	h,a
	srl	h
	rr	l
	rra
	srl	h
	rr	l
	rra
	ld	h,l
	ld	l,a
	ld	a,h
	or	a,0x78
	ld	c,l
	ld	b,a
	ld	l,(ix+4)
	ld	h,0x00
	add	hl, hl
	ld	a,c
	or	a, l
	ld	e,a
	ld	a,b
	or	a, h
	ld	d,a
	ld	a,(ix+8)
	ld	(ix-7),a
	ld	(ix-13),a
	ld	(ix-11),0x00
	ld	l, e
	ld	h, d
	INCLUDE "SMS_CRT0_RST08.inc"
l_SMS_loadSTMcompressedTileMapArea_00134:
	ld	c,(ix+6)
	ld	b,(ix+7)
	ld	a,(bc)
	ld	(ix-12),a
	inc	bc
	ld	(ix+6),c
	ld	(ix+7),b
	ld	(ix-5),c
	ld	(ix-4),b
	ld	a,(ix-12)
	and	a,0x02
	ld	(ix-8),a
	ld	a,(ix-12)
	rrca
	rrca
	and	a,0x3f
	ld	(ix-6),a
	bit	0,(ix-12)
	jp	Z,l_SMS_loadSTMcompressedTileMapArea_00129
	ld	(ix-3),0x00
	ld	a,(ix-9)
	ld	(ix-2),a
	ld	c,(ix-5)
	ld	b,(ix-4)
	inc	bc
	ld	l,(ix-5)
	ld	h,(ix-4)
	ld	l,(hl)
	ld	a,(ix-6)
	add	a,0x02
	ld	(ix-1),a
	ld	h,0x00
	ld	a,l
	or	a,(ix-3)
	ld	l,a
	ld	a,h
	or	a,(ix-2)
	ld	h,a
	ld	a,(ix-8)
	or	a, a
	jr	Z,l_SMS_loadSTMcompressedTileMapArea_00114
	ld	(ix+6),c
	ld	(ix+7),b
	ld	a,(ix-1)
	ld	(ix-3),a
	ld	c,l
	ld	b,h
l_SMS_loadSTMcompressedTileMapArea_00105:
	ld	a,(ix-3)
	or	a, a
	jp	Z,l_SMS_loadSTMcompressedTileMapArea_00156
	ld	l, c
	ld	h, b
	INCLUDE "SMS_CRT0_RST18.inc"
	dec	(ix-13)
	ld	a,(ix-13)
	or	a, a
	jr	NZ,l_SMS_loadSTMcompressedTileMapArea_00102
	ld	hl,0x0040
	add	hl,de
	ex	de,hl
	push	bc
	ld	l, e
	ld	h, d
	INCLUDE "SMS_CRT0_RST08.inc"
	pop	bc
	ld	a,(ix-7)
	ld	(ix-13),a
l_SMS_loadSTMcompressedTileMapArea_00102:
	ld	a,0x01
	sub	a,(ix-3)
	jr	NC,l_SMS_loadSTMcompressedTileMapArea_00104
	inc	bc
l_SMS_loadSTMcompressedTileMapArea_00104:
	dec	(ix-3)
	jr	l_SMS_loadSTMcompressedTileMapArea_00105
l_SMS_loadSTMcompressedTileMapArea_00114:
	ld	(ix+6),c
	ld	(ix+7),b
	ld	(ix-10),l
	ld	(ix-9),h
	ld	b,(ix-1)
l_SMS_loadSTMcompressedTileMapArea_00110:
	ld	a,b
	or	a, a
	jp	Z,l_SMS_loadSTMcompressedTileMapArea_00157
	ld	l,(ix-10)
	ld	h,(ix-9)
	INCLUDE "SMS_CRT0_RST18.inc"
	dec	(ix-13)
	ld	a,(ix-13)
	or	a, a
	jr	NZ,l_SMS_loadSTMcompressedTileMapArea_00109
	ld	hl,0x0040
	add	hl,de
	ld	e,l
	ld	d,h
	INCLUDE "SMS_CRT0_RST08.inc"
	ld	a,(ix-7)
	ld	(ix-13),a
l_SMS_loadSTMcompressedTileMapArea_00109:
	dec	b
	jr	l_SMS_loadSTMcompressedTileMapArea_00110
l_SMS_loadSTMcompressedTileMapArea_00129:
	ld	a,(ix-8)
	or	a, a
	jr	Z,l_SMS_loadSTMcompressedTileMapArea_00126
	bit	2,(ix-12)
	jr	Z,l_SMS_loadSTMcompressedTileMapArea_00117
	ld	a,(ix-10)
	ld	(ix-15),a
	ld	a,(ix-9)
	ld	(ix-14),a
	ld	(ix-11),0x01
l_SMS_loadSTMcompressedTileMapArea_00117:
	ld	c,(ix-12)
	srl	c
	srl	c
	srl	c
	ld	(ix-9),c
	ld	(ix-10),0x00
	jp	l_SMS_loadSTMcompressedTileMapArea_00134
l_SMS_loadSTMcompressedTileMapArea_00126:
	ld	l,(ix-6)
	ld	a,l
	or	a, a
	jr	Z,l_SMS_loadSTMcompressedTileMapArea_00138
	ld	a,(ix-9)
	ld	(ix-3),a
	ld	(ix-2),0x00
	ld	c,(ix-5)
	ld	b,(ix-4)
	ld	(ix-1),l
l_SMS_loadSTMcompressedTileMapArea_00122:
	ld	a,(ix-1)
	or	a, a
	jr	Z,l_SMS_loadSTMcompressedTileMapArea_00158
	ld	a,(bc)
	out	(VDPDataPort),a
	inc	bc
	nop	
	nop 
	nop 
	ld	a,(ix-3)
	out	(VDPDataPort),a
	dec	(ix-13)
	ld	a,(ix-13)
	or	a, a
	jr	NZ,l_SMS_loadSTMcompressedTileMapArea_00121
	ld	hl,0x0040
	add	hl,de
	ex	de,hl
	push	bc
	ld	l, e
	ld	h, d
	INCLUDE "SMS_CRT0_RST08.inc"
	pop	bc
	ld	a,(ix-7)
	ld	(ix-13),a
l_SMS_loadSTMcompressedTileMapArea_00121:
	dec	(ix-1)
	jr	l_SMS_loadSTMcompressedTileMapArea_00122
l_SMS_loadSTMcompressedTileMapArea_00156:
	ld	(ix-10),c
	ld	(ix-9),b
	jr	l_SMS_loadSTMcompressedTileMapArea_00130
l_SMS_loadSTMcompressedTileMapArea_00157:
	jr	l_SMS_loadSTMcompressedTileMapArea_00130
l_SMS_loadSTMcompressedTileMapArea_00158:
	ld	(ix+6),c
	ld	(ix+7),b
l_SMS_loadSTMcompressedTileMapArea_00130:
	bit	0,(ix-11)
	jp	Z,l_SMS_loadSTMcompressedTileMapArea_00134
	ld	a,(ix-15)
	ld	(ix-10),a
	ld	a,(ix-14)
	ld	(ix-9),a
	ld	(ix-11),0x00
	jp	l_SMS_loadSTMcompressedTileMapArea_00134
l_SMS_loadSTMcompressedTileMapArea_00138:
	ld	sp, ix
	pop	ix
	ret
