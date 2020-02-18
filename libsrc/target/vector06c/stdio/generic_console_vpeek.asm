

        MODULE  generic_console_vpeek
        SECTION code_clib
        PUBLIC  generic_console_vpeek

        EXTERN  generic_console_xypos
        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  screendollar
        EXTERN  screendollar_with_count

generic_console_vpeek:
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        push    hl                ;save buffer
	ex	de,hl
	call	generic_console_xypos
        ; hl = screen address, de = buffer
	ld	a,8
loop:	push	af
	ld	b,(hl)	;Plane 0
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)	;Plane 1
	or	b
	ld	b,a
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)	;Plane 2
	or	b
	ld	b,a
	ld	a,h
	sub	$20
	ld	h,a
	ld	a,(hl)	;Plane 3
	or	b
	ld	(de),a
	ld	a,h
	add	$60
	ld	h,a
	dec	l		;Next row
	inc	de
	pop	af
	dec	a
	jr	nz,loop
        pop     de                ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
	pop	bc
	pop	bc
	pop	bc
	pop	bc
        ret
