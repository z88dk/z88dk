;
; 	ANSI Video handling for the Sanyo computers
;
;	Stefano Bodrato - 2023
;

; in:	A = text row number

        SECTION code_clib
		
        PUBLIC  ansi_del_line
        EXTERN    mbc_sendchar


ansi_del_line:
		ld h,a
		ld l,27
		call mbc_sendchar
		ld l,'='
		call mbc_sendchar
		ld a,32
		add h
		ld l,a
		call mbc_sendchar
		ld l,32
		call mbc_sendchar
		; Delete current line
		ld l,27
		call mbc_sendchar
		ld l,'T'
		jp mbc_sendchar
