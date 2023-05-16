;
; 	ANSI Video handling for the Sanyo computers

; in:	A = text row number

        SECTION code_clib
		
		EXTERN __console_h
        EXTERN    mbc_sendchar

        PUBLIC  ansi_del_line

ansi_del_line:
		; place cursor at the bottom row..
		ld l,27
		call mbc_sendchar
		ld l,'='
		call mbc_sendchar
		ld a,(__console_h)
		add 32
		ld l,a
		call mbc_sendchar
		ld l,32
		call mbc_sendchar
		; Delete current line
		ld l,27
		call mbc_sendchar
		ld l,'T'
		jp mbc_sendchar
