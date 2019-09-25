
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
IF __CPU_GBZ80__
	ld	hl,generic_console_font32
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
        ld      hl,(generic_console_font32)
ENDIF
        call    screendollar
        jr      nc,gotit
IF __CPU_GBZ80__
	ld	hl,generic_console_udg32
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
        ld      hl,(generic_console_udg32)
ENDIF
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
IF __CPU_GBZ80__ | __CPU_INTEL__
	push	af
	pop	bc
ELSE
        ex      af,af           ; Save those flags
ENDIF
        ld      hl,8            ; Dump our temporary buffer
        add     hl,sp
        ld      sp,hl
IF __CPU_GBZ80__ | __CPU_INTEL__
	push	bc
	pop	af
ELSE
        ex      af,af           ; Flags and parameter back
ENDIF
        ret

