;
; Code to work around lack of ix on 808x processors
;

SECTION code_clib

PUBLIC __printf_increment_chars_written
PUBLIC __printf_write_chars_written
PUBLIC __printf_is_padding_zero
PUBLIC __printf_get_fp
PUBLIC __printf_get_print_function
PUBLIC __printf_set_flags
PUBLIC __printf_set_width
PUBLIC __printf_get_base
PUBLIC __printf_set_base
PUBLIC __printf_set_upper
PUBLIC __printf_add_offset
PUBLIC __printf_disable_plus_flag
PUBLIC __printf_get_precision
PUBLIC __printf_set_precision
PUBLIC __printf_check_long_flag
PUBLIC __printf_set_long_flag
PUBLIC __printf_res_long_flag
PUBLIC __printf_get_width
PUBLIC __printf_inc_buffer_length
PUBLIC __printf_get_buffer_length
PUBLIC __printf_issccz80
PUBLIC __printf_check_pad_right
PUBLIC __printf_set_buffer_length
PUBLIC __printf_set_ftoe
PUBLIC __printf_check_ftoe

; Increment the number of characters written
;
; Uses: f
__printf_increment_chars_written:
	push	de
	push	hl
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl		;-1
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	inc	de
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	hl
	pop	de
	ret

; Write the number of characters written
; Entry: hl = address to write to
; Exit:  hl = hl + 1
__printf_write_chars_written:
	push	de
IF __CPU_GBZ80__
	ld	e,l
	ld	d,h
ELSE
	ex	de,hl
ENDIF
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	ld	a,(hl)
	ld	(de),a
	inc	hl
	inc	de
	ld	a,(hl)
	ld	(de),a
IF __CPU_GBZ80__
	ld	l,e
	ld	h,d
ELSE
	ex	de,hl
ENDIF
	pop	de
	ret

; Check whether we should pad out with 0 or space
; Ret: nz = use space, z = 0
; Uses: a
__printf_is_padding_zero:
	push	hl
	push	bc
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-4
	add	hl,bc
	ld	a,(hl)
	and	@00000100
	pop	bc
	pop	hl	
	ret



; Get the file handle
;
; Exit: bc = file handle
; Uses: f
__printf_get_fp:
	push	hl
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,10
	add	hl,bc
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	pop	hl
	ret

; Get the file handle
;
; Exit: hl = calling function
; Uses: f
__printf_get_print_function:
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,8
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
IF __CPU_GBZ80__
	ld	l,e
	ld	h,d
ELSE
	ex	de,hl
ENDIF
	pop	de
	ret

; Set the flags
; Entry: c = flags
__printf_set_flags:
	push	hl
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-4
	add	hl,de
	ld	(hl),c
	pop	de
	pop	hl
	ret

; Set the width
; Entry: de = width
__printf_set_width:
	push	hl
	push	bc
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-5
	add	hl,bc
	ld	(hl),d
	dec	hl
	ld	(hl),e
	pop	bc
	pop	hl
	ret

; Get the base for number conversion
; Entry: 
; Exit: hl = base
__printf_get_base:
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-9
	add	hl,de
	ld	l,(hl)
	ld	h,0
	pop	de
	ret

; Set the character hift for hex printing

; Set the base for number conversion
; Entry: c = base
__printf_set_base:
	push	hl
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-9
	add	hl,de
	ld	(hl),c
	pop	de
	pop	hl
	ret

; Set the character hift for hex printing
; Entry: c = ascii offset
__printf_set_upper:
	push	hl
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	dec	hl
	ld	(hl),c
	pop	hl
	ret

; Add the upper case offset
; Entry: a = original character
; Exit:  a = shifted character
__printf_add_offset:
	push	hl
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	dec	hl
	add	(hl)
	pop	hl
	ret





; Disable the plus flag
__printf_disable_plus_flag:
	push	hl
	push	de
	push	af
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-4
	add	hl,de
	ld	a,(hl)
	and	@11111101
	ld	(hl),a
	pop	af
	pop	de
	pop	hl
	ret


; Get the precision
; Exit: hl = precision
__printf_get_precision:
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-7
	add	hl,de
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
IF __CPU_GBZ80__
	ld	l,e
	ld	h,d
ELSE
	ex	de,hl
ENDIF
	pop	de
	ret


; Set the precision
; Entry: de = precision
__printf_set_precision:
	push	hl
	push	bc
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-7
	add	hl,bc
	ld	(hl),d
	dec	hl
	ld	(hl),e
	pop	bc
	pop	hl
	ret

__printf_check_long_flag:
	push	hl
	push	bc
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-4
	add	hl,bc
	ld	a,(hl)
	and	@01000000
	pop	bc
	pop	hl
	ret


__printf_set_long_flag:
	push	hl
	push	bc
	push	af
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-4
	add	hl,bc
	ld	a,(hl)
	or	@01000000
	ld	(hl),a
	pop	af
	pop	bc
	pop	hl
	ret

__printf_res_long_flag:
	push	hl
	push	bc
	push	af
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	bc,-4
	add	hl,bc
	ld	a,(hl)
	and	@10111111
	ld	(hl),a
	pop	af
	pop	bc
	pop	hl
	ret

; Get the maximum width available
; Exit: hl = width
__printf_get_width:
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-5
	add	hl,de
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
IF __CPU_GBZ80__
	ld	l,e
	ld	h,d
ELSE
	ex	de,hl
ENDIF
	pop	de
	ret

; Increment the length of the temporary buffer
; Exit: None
__printf_inc_buffer_length:
	push	hl
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-10
	add	hl,de
	inc	(hl)
	pop	de
	pop	hl
	ret

; Set the buffer length
; Exit: None
__printf_set_buffer_length:
	ld	a,l
	push	de
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-10
	add	hl,de
	ld	(hl),a
	pop	de
	ret



; Get the length of the temporary buffer
; Exit: de = buffer length
__printf_get_buffer_length:
	push	hl
IF __CPU_GBZ80__
	push	af
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	pop	af
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,-10
	add	hl,de
	ld	e,(hl)
	ld	d,0
	pop	hl
	ret

; Check whether we're working with sccz80 or sdcc
; z = sdcc, nz=sccz80
; Uses af
__printf_issccz80:
	push	hl
	push	de
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	ld	de,6
	add	hl,de
	ld	a,(hl)		
	and	a
	pop	de
	pop	hl
	ret

__printf_check_pad_right:
	push	hl
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	dec	hl
	dec	hl
	ld	a,(hl)
	and	1
	pop	hl
	ret

; Set the ftoe flag
__printf_set_ftoe:
	push	hl
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	dec	hl
	dec	hl
	ld	a,(hl)
	or	@00100000
	ld	(hl),a
	pop	hl
	ret

; Check the ftoe flag
; Exit: nz = use ftoe, z=ftoa
__printf_check_ftoe:
	push	hl
IF __CPU_GBZ80__
	ld	hl,__printf_context
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__printf_context)
ENDIF
	dec	hl
	dec	hl
	dec	hl
	dec	hl
	ld	a,(hl)
	and	@00100000
	pop	hl
	ret







SECTION bss_clib

PUBLIC __printf_context

__printf_context:	defw	0
