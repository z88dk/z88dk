

	MODULE		conio_vars

	INCLUDE		"target/cpm/def/tiki100.def"

	SECTION		data_himem
	PUBLIC		__MODE2_attr
	PUBLIC		__MODE3_attr


__MODE2_attr:   defb    @00000011, 0
__MODE3_attr:   defb    @00001111, 0


	SECTION		code_clib
	PUBLIC		generic_console_setup_mode
	EXTERN		__console_w
	EXTERN		gr_setpalette
	EXTERN		generic_console_get_mode


; Entry: a = mode
generic_console_setup_mode:
        ld      c, 128
        ld      de,2
        ld      hl,palette_MODE1
        and     a
        jr      z,set_columns   ;0
        dec     a
        jr      z,set_columns   ;1
        ld      hl,palette
        ld      de,16
        ld      c,64
        dec     a
        jr      z,set_columns   ;2
        ld      c,32            ;3
set_columns:
        ld      a,c
        ld      (__console_w),a
        push    de      ;number of colours
        push    hl      ;palette
        call    gr_setpalette
        pop     bc
        pop     bc
        ret

	SECTION		rodata_clib

palette_MODE1:
        defb    0, 255

palette:
        ;        RRRGGGBB
        defb    @00000000       ;BLACK
        defb    @00000010       ;BLUE
        defb    @00010100       ;GREEN
        defb    @00010110       ;CYAN
        defb    @10000000       ;RED
        defb    @10000011       ;MAGENTA
        defb    @10100100       ;BROWN?
        defb    @11011001       ;LIGHT GREY
        defb    @00101001       ;DARK GREY
        defb    @00000011       ;LIGHT BLUE
        defb    @00011100       ;LIGHT GREEN
        defb    @00011111       ;LIGHT CYAN
        defb    @11100000       ;LIGHT RED
        defb    @11100011       ;LIGHT MAGENTA
        defb    @11111100       ;YELLOW
        defb    @11111111       ;WHITE

        SECTION code_crt_init

        call	generic_console_get_mode
        call    generic_console_setup_mode
        ld      a,201
        ld      (CURSOR_BLINK_VECTOR),a
