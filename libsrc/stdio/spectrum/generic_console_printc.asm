;
; Print a character for the ZX/TS2068 screen
;

	MODULE	generic_console_printc
	
	SECTION code_clib
	PUBLIC	generic_console_printc
	PUBLIC	generic_console_calc_screen_addr
		
	EXTERN	__zx_console_attr
	EXTERN	__zx_32col_udgs
	EXTERN	__zx_32col_font
	EXTERN	__zx_64col_font
	EXTERN	__console_w
	EXTERN	generic_console_flags
	EXTERN	__ts2068_hrgmode

; Entry:
;  a = charcter
; hl = expect_flags
handle_controls:
	; Extra codes
	cp	18
	ld	d,1
	jr	z,start_code
	ld	d,2
	cp	19
	jr	z,start_code
	ld	d,16
	cp	1
	jr	z,start_code
	cp	2
	ret	nz
	ld	d,12
start_code:
	ld	a,(hl)
	or	d	
	ld	(hl),a
	ret

set_flash:
	res	0,(hl)
	ld	hl,__zx_console_attr
	res	7,(hl)
	rrca
	ret	nc
	set	7,(hl)
	ret

set_bright:
	res	1,(hl)
	ld	hl,__zx_console_attr
	res	6,(hl)
	rrca
	ret	nc
	set	6,(hl)
	ret

set_switch:
	res	4,(hl)
	ld	hl,print32
	cp	64
	ld	de,$4020
	jr	nz,set_switch1
	ld	hl,print64
	ld	de,$8040
set_switch1:
	ld	(print_routine),hl
IF FORts2068
	ld	a,(__ts2068_hrgmode)
	cp	6
	ld	a,d
	jr	z,set_width
ENDIF
	ld	a,e
set_width:
	ld	(__console_w),a
	ret

set_font_hi:
	res	2,(hl)
	ld	(__zx_32col_font+1),a
	ret
set_font_lo:
	res	3,(hl)
	ld	(__zx_32col_font),a
	ret


; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	rl	e
	jr	c,skip_control_codes
	ld	hl,expect_flags
	bit	0,(hl)
	jr	nz,set_flash
	bit	1,(hl)
	jr	nz,set_bright
	bit	2,(hl)
	jr	nz,set_font_hi
	bit	3,(hl)
	jr	nz,set_font_lo
	bit	4,(hl)
	jr	nz,set_switch
	cp	32
	jr	c,handle_controls
skip_control_codes:
	ld	hl,(print_routine)
	jp	(hl)



print32:
	call	generic_console_calc_screen_addr	; hl = screen address, d preserved
	ex	de,hl
	ld	bc,(__zx_32col_font)
	dec	b
	bit	7,h
	jr	z,handle_characters
	ld	bc,(__zx_32col_udgs)
	res	7,h
handle_characters:
	ld	l,h
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,bc
	ld	a,(generic_console_flags)
	rlca
	sbc	a,a		; ; c = 0/ c = 255
	ld	c,a
	ld	b,8
print32_loop:
	ld	a,(hl)
	xor	c
	ld	(de),a
	inc	d
	inc	hl
	djnz	print32_loop
handle_attributes:
	dec	d
	call	get_attribute_address
	ret	z		;No attributes
	ld	a,(__zx_console_attr)
	ld	(de),a
	ret


get_attribute_address:
IF FORts2068
	ld	a,d
	and	@0100000
	ld	l,a
	ld	a,(__ts2068_hrgmode)
	cp	6
	ret	z
	cp	2
	jr	nz,not_hi_colour
	set	5,d
	ld	a,(__zx_console_attr)
	ld	b,7
hires_set_attr:
	ld	(de),a
	dec	d
	djnz	hires_set_attr
	ret
not_hi_colour:
ENDIF
	ld	a,d
	rrca
	rrca
	rrca
	and	3
	or	88
IF FORts2068
	or	l		;Add in screen 1 bit
ENDIF
	ld	d,a
	ret

print64:
	srl	c	; divide by 2
	ex	af,af	; save the lowest bit
	call	generic_console_calc_screen_addr
	ex	de,hl	; de = screen address
	ex	af,af
	ld	a,0x0f
	jr	c,not_even_column
	ld	a,0xf0
not_even_column:
	; h = character
	; de = screen address
	; a = screen mask
	ld	l,h
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	bc,(__zx_64col_font)
	dec	b
	add	hl,bc
	ld	b,8
	ld	c,a
	ex	de,hl
print64_loop:
	ld	a,c
	cpl
	and	(hl)
	ld	(hl),a
	ld	a,(generic_console_flags)
	rlca
	ld	a,(de)
	jr	nc,print64_noinverse
	cpl
print64_noinverse:
	and	c
	or	(hl)
	ld	(hl),a
	inc	h
	inc	de
	djnz	print64_loop
	ex	de,hl
	jr	handle_attributes

	

; Calculate screen address
; Entry: c = x (0...31) or (0...63 for ts2068/hrgmode)
;        b = y
; Exit: hl = screen address
generic_console_calc_screen_addr:
IF FORts2068
	bit	0,c
        push    af
	ld	a,(__ts2068_hrgmode)
	cp	6
	jr	nz,not_hrgmode
	srl	c
not_hrgmode:
ENDIF
	ld	a,b
	rrca
	rrca
	rrca
	and	248
	or	c
	ld	l,a
	ld	a,b
	and	0x18
	or	0x40
	ld	h,a
IF FORts2068
        ld      a,(__ts2068_hrgmode)
	and	a
	jr	z,dont_use_screen_1
	cp	1		;screen 1
	jr	z,use_screen_1
	cp	2		;high colour
	jr	z,dont_use_screen_1
	; So we're in hires mode
	pop	af
	ret	z		;Even column no need for it
calc_screen1_offset:
	set	5,h
	ret
use_screen_1:
	pop	af
	jr	calc_screen1_offset
dont_use_screen_1:
	pop	af
ENDIF
	ret

	SECTION bss_clib

expect_flags:	defb	0		; bit 0 - expect flash
					; bit 1 - expect bright
					; bit 2 - expect font low
					; bit 3 - expect font high
					; bit 4 - expect switch

	SECTION	data_clib

print_routine:	defw	print64
