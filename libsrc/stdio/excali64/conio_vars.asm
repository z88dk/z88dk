;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_graphics

		PUBLIC		__excali64_attr
		PUBLIC		__excali64_inverse_attr
		PUBLIC		__excali64_mode
		PUBLIC		__excali64_font32
		PUBLIC		__excali64_udg32

.__excali64_attr	defb	$70	; White on Black
.__excali64_inverse_attr	defb @00001110	;Black on white
.__excali64_mode	defb	$0	;80x25 text

.__excali64_font32	defw	CRT_FONT
.__excali64_udg32	defw	0


        SECTION code_crt_init
        EXTERN  __BSS_END_tail
        EXTERN  __HIMEM_head
        EXTERN  __HIMEM_END_tail

        ld      hl,__BSS_END_tail
        ld      de,__HIMEM_head
        ld      bc,__HIMEM_END_tail - __HIMEM_head
        ldir

; If compiled with a font option then set it up
	EXTERN	copy_font
	EXTERN	CRT_FONT
	EXTERN	loadudg6
        ld      bc,CRT_FONT
        ld      a,b
        or      c
	ld	hl,$6020
	call	nz,copy_font
	call	loadudg6
