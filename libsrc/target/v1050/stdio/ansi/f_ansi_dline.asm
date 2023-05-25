;
; 	ANSI Video handling for the Visual 1050
;
;	Stefano Bodrato - 2023
;

; in:	A = text row number

        SECTION code_clib
		
        PUBLIC  ansi_del_line
        EXTERN  v1050_sendchar


ansi_del_line:
		ld h,a
		ld l,27
		call v1050_sendchar
		ld l,'='
		call v1050_sendchar
		ld a,32
		add h
		ld l,a
		call v1050_sendchar
		ld l,32
		call v1050_sendchar

		; Delete current line
        ld    l,0x9B		; CSI (equals to "ESC [")
        call  v1050_sendchar
		ld    l,'K'
		jp    v1050_sendchar
