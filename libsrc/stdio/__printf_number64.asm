

	MODULE	__printf_number64
	SECTION	code_clib
	PUBLIC	__printf_number64

	EXTERN	__printf_print_to_buf
	EXTERN	__printf_print_the_buffer
	EXTERN	__printf_get_buffer_address
	EXTERN	l_load_64_dehldehl_mbc
	EXTERN	l_neg_64_mhl
	EXTERN	asm1_ulltoa
	EXTERN	strlen

; Print a number
; Entry: hl = fmt (character after format)
;        de = ap
;         c = 1 = signed, 0 = unsigned
__printf_number64:
	push	hl		;save fmt
        ; Picking up a long sdcc style
	ld	l,e		;hl=de = where to get from
	ld	h,d
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	push	hl		;save ap for next argument
	ex	de,hl		;hl = pointer to int64 c: 1=signed 0=unsigned


; Entry:        c = flag (0=unsigned, 1 = signed)
;		hl = pointer to number
;
	push	hl		;save number pointer
	ld	a,c
	and	a
	jr	z,noneg	
	bit	7,(hl)		
	jr	z,noneg
	call	l_neg_64_mhl	;make positive

        ld      a,'-'
printsign:
        call    __printf_print_to_buf
        jr      number64_start_process


noneg:
        ld      a,' '
        bit     3,(ix-4)
        jr      nz,printsign
        ld      a,'+'
        bit     1,(ix-4)                ;do we force a +
        jr      nz,printsign
        bit     4,(ix-4)                ;# indicator
        jr      z,number64_start_process
        ld      a,(ix-9)                ;get base/radix
        cp      10
        jr      z,number64_start_process
        ex      af,af
        ld      a,'0'
        call    __printf_print_to_buf
        ex      af,af
        cp      16
        jr      nz,number64_start_process
        ld      a,'x'
        add     (ix-3)
        call    __printf_print_to_buf

number64_start_process:
	; on stack we have:
	;   pointer to start of 64 bit number
	;   ap
	;   fmt

	; Get the buffer of where to print to
	call    __printf_get_buffer_address
        ld      c,(ix-10)
        ld      b,0
        add     hl,bc		;hl = buffer address
	ld	e,(ix-9)	;base
	ld	d,0
	pop	bc		;bc = address of 64bit variable

	push	ix		;save the printf context
	push	de		;save radix
	push	hl		;save buffer

	call	l_load_64_dehldehl_mbc	; dehl'dehl=num

	pop	ix		;buffer
	pop	bc		;radix

	call	asm1_ulltoa

	pop	ix		;get the printf context back
        call    __printf_get_buffer_address
        call    strlen          ;get the length of it
        ld      (ix-10),l
	jp	__printf_print_the_buffer




