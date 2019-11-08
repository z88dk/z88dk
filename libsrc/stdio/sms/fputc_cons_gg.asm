	SECTION code_clib	
	PUBLIC	fputc_cons_native
	
	INCLUDE "target/sms/sms.hdr"

	EXTERN	VRAMToHL
	PUBLIC	fputc_vdp_offs
	
.fputc_cons_native
	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	de, NameTableAddress
	add	hl, de			; Calculates name table address
	call	VRAMToHL
	
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocrlf

	; Line break
.linebreak
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	a, (fputc_vdp_offs)
	ld	l, a
	and	a, $C0
	ld	l, a			; Calculates start of line
IF FORgamegear
	ld	de, 64+12
ELSE
	ld	de, 64
ENDIF
	add	hl, de			; Calculates address of next line
	ld	a, l
	ld	(fputc_vdp_offs), a
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset
	
	ret				; Nothing more to do

.nocrlf
	cp	12		; CLS ?
	jr	nz,nocls

	; CLS
	ld	hl,196+8
	ld	(fputc_vdp_offs),hl
	; // TODO: CLS implementation
	ret
	

.nocls
	out	($be), a	; Outputs character

	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	inc	hl
	inc	hl			; offset += 2
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset
	ld	a, l
	ld	(fputc_vdp_offs), a
	and 63
	cp	52
	jr	z,linebreak

	ret


IF FORgamegear
	SECTION	data_clib
fputc_vdp_offs:
			defw	196+8
ELSE
	SECTION	bss_clib
fputc_vdp_offs:         defw    0       ;Current character pointer
ENDIF

