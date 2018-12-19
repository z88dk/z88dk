
	SECTION		code_clib
	PUBLIC		vpeek_screendollar

	EXTERN		screendollar
	EXTERN		screendollar_with_count
	EXTERN		generic_console_font32
	EXTERN		generic_console_udg32

; Match character in buffer on stack to the font
;
; Entry on stack: address of buffer, 8 bytes of buffer
vpeek_screendollar:
        pop     de              ;the buffer on the stack
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af           ; Save those flags
        ld      hl,8            ; Dump our temporary buffer
        add     hl,sp
        ld      sp,hl
        ex      af,af           ; Flags and parameter back
        ret

