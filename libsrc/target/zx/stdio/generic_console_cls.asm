;
; Clear the screen for the ZX/TS2068 terminal
;
		MODULE	generic_console_cls

		SECTION	code_clib
		PUBLIC	generic_console_cls

		EXTERN	__zx_console_attr
		EXTERN	__ts2068_hrgmode


generic_console_cls:
	push	de
	push	bc
	ld      hl,16384
        ld      de,16385
IF FORts2068
        ld      a,(__ts2068_hrgmode)
	cp	1
	jr	nz,clear_main_screen
	ld	hl,$6000
	ld	de,$6001
clear_main_screen:
ENDIF
        ld      bc,6144
        ld      (hl),l
        ldir
IF FORts2068
        ld      a,(__ts2068_hrgmode)
	cp	0
	jr	z,clear_attributes
	cp	1
	jr	z,clear_attributes
	cp	2
	jr	z,clear_attribute_hicolour
	; And here we clear the hires screen
	xor	a
clear_screen1:
        ld      hl,$6000
        ld      de,$6001
        ld      bc,6144
        ld      (hl),a
        ldir
	jr	done

clear_attribute_hicolour:
        ld      a,(__zx_console_attr)
	jr	clear_screen1
ENDIF
clear_attributes:
        ld      a,(__zx_console_attr)
        ld      (hl),a
        ld      bc,767
        ldir
done:
	pop	bc
	pop	de
        ret
