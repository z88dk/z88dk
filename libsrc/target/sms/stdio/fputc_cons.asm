	SECTION code_clib	
	PUBLIC	fputc_cons_native
	
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts_jp
	INCLUDE "target/sms/sms.hdr"

    EXTERN  CONSOLE_YOFFSET
    EXTERN  CONSOLE_XOFFSET
	PUBLIC	fputc_vdp_offs
	
.fputc_cons_native
	call	l_tms9918_disable_interrupts

	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	de, NameTableAddress
	add	hl, de			; Calculates name table address

	ld		a, l
    out     (__IO_VDP_COMMAND), a
	ld		a, h
    or      VDP_SET_VRAM
    out     (__IO_VDP_COMMAND), a

	ld      hl,4
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
	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	a, l
	and	a, $C0
	ld	l, a			; Calculates start of line
	ld	de, +64 +(CONSOLE_XOFFSET * 2)
	add	hl, de			; Calculates address of next line
	ld	a, l
	ld	(fputc_vdp_offs), a
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset
	
    ; exit through l_tms9918_enable_interrupts_jp
    jp      l_tms9918_enable_interrupts_jp

.nocrlf
	cp	12		; CLS ?
	jr	nz,nocls

	; TODO: Implement CLS
    ld      hl,+(CONSOLE_YOFFSET * 64 + CONSOLE_XOFFSET * 2)
    ld      (fputc_vdp_offs),hl

    ; exit through l_tms9918_enable_interrupts_jp
    jp      l_tms9918_enable_interrupts_jp

.nocls
	out	(__IO_VDP_DATA), a	; Outputs character
	
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
	and	63
	cp	64 - (CONSOLE_XOFFSET * 2)
	jr	z,linebreak

    ; exit through l_tms9918_enable_interrupts_jp
    jp      l_tms9918_enable_interrupts_jp

	SECTION	data_clib

fputc_vdp_offs:         defw    +(CONSOLE_YOFFSET * 64 + CONSOLE_XOFFSET * 2)       ;Current character pointer
