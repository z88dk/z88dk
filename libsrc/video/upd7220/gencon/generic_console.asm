;
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__upd7220_attr

		defc		DISPLAY = 0

		INCLUDE		"video/upd7220/upd7220.inc"

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_paper:
	and	7
	rla
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__upd7220_attr)
	and	@00011111
	or	e
	ld	(__upd7220_attr),a
	ret

	
generic_console_set_ink:
	and	15
	ld	e,a
	ld	a,(__upd7220_attr)
	and	@11110000
	or	e
	ld	(__upd7220_attr),a
	ret

generic_console_cls:
	ld	hl, DISPLAY
	call	CURS2
	ld	de, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	hl,(__upd7220_attr - 1)
	ld	l,$20
cls_1:
	call	WDAT2
	dec	de
	ld	a,d
	or	e
	jr	nz,cls_1
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ex	af,af
	call	xypos
	call	CURS2
	ex	af,af
	ld	hl,(__upd7220_attr - 1)
	ld	l,a
	call	WDAT2
	ret

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	call	xypos
	call	CURS2
	call	RDAT
	ld	a,l
	and	a
	ret

xypos:
	ld	hl,0
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	pop	bc
	pop	de
	ret


; Output the CURS commnad
CURS2:
	ld	a,UPD7220_COMMAND_CURS
write_2_command:
	out	(UPD_7220_COMMAND_WRITE),a
	ld	bc,UPD_7220_PARAMETER_WRITE
	out	(c),l
	out	(c),h
	ret

WDAT2:
	ld	a,UPD7220_COMMAND_WDAT
	jr	write_2_command

ckstatus:
	in	a,(UPD_7220_STATUS_READ)
	and	4
	jr	z,ckstatus
	ret

RDAT:
	ld	a,UPD7220_COMMAND_FIGS
	ld	hl,$0102
	call	write_2_command
	ld	a,UPD7220_COMMAND_RDAT
	out	(UPD_7220_COMMAND_WRITE),a
	ld	bc,UPD_7220_FIFO_READ
	call	ckstatus
	in	l,(c)
	call	ckstatus
	in	h,(c)
	ret
