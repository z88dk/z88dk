

	MODULE	generic_console_vpeek
	SECTION	code_clib
	EXTERN	generic_console_calc_screen_address
	PUBLIC	generic_console_vpeek

	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__cpc_mode
	EXTERN	screendollar
	EXTERN	screendollar_with_count

generic_console_vpeek:
	call	generic_console_calc_screen_address
	; hl = screen address
	ex	de,hl
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;save buffer
	ld	a,(__cpc_mode)
	cp	2
	jr	z,handle_mode_2
	and	a
	jr	z,handle_mode_0

handle_mode_1:
	 ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
	ld	b,8
handle_mode_1_per_line:
	push	bc
	push	hl	;save buffer
	ld	h,@10000000
	ld	c,0	;resulting byte
	ld	a,2	;we need to do this loop twice
handle_mode1_nibble:
	push	af
	ld	l,@10001000
	ld	b,4	;4 pixels in a byte
handle_mode_1_0:
	ld	a,(de)
	and	l
	jr	z,not_set
	ld	a,c
	or	h
	ld	c,a
not_set:
	srl	h
	srl	l
	djnz	handle_mode_1_0
	inc	de
	pop	af
	dec	a
	jr	nz,handle_mode1_nibble
	pop	hl		;buffer
	ld	(hl),c
	inc	hl
	dec	de
	dec	de
	ld	a,d
	add	8
	ld	d,a
	pop	bc
	djnz	handle_mode_1_per_line
	jr	do_screendollar

	

        ; b7    b6    b5    b4    b3    b2    b1    b0
        ; p0-b0 p1-b0 p0-b2 p1-b2 p0-b1 p1-b1 p0-b3 p1-b3
handle_mode_0:
	ld	b,8		;number of rows
handle_mode_0_0:
	push	bc
	ld	c,0		;final byte
	push	hl		;save buffer
	ld	h,@10000000
	ld	a,4
handle_mode_0_1:
	push	af
	; 4 bytes in total
 	; 2x for each byte	
	ld	l,@10101010
	ld	b,2
handle_mode_0_2:
	ld	a,(de)
	and	l
	jr	z,not_set_mode_0
	ld	a,c
	or	h
	ld	c,a
not_set_mode_0:
	srl	l
	srl	h
	djnz 	handle_mode_0_2
	inc	de
	pop	af
	dec	a
	jr	nz,handle_mode_0_1
	pop	hl
	ld	(hl),c
	inc	hl
	dec	de
	dec	de
	dec	de
	dec	de
	ld	a,d
	add	8
	ld	d,a
	pop	bc
	djnz	handle_mode_0_0
	jr	do_screendollar

handle_mode_2:
	ld	b,8
handle_mode_2_1:
	ld	a,(de)
	ld	(hl),a
	inc	hl
	ld	a,d	
	add	8
	ld	d,a
	djnz	handle_mode_2_1
do_screendollar:
        pop     de              ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar	;exits with de = buffer
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        ex      af,af
	ret
