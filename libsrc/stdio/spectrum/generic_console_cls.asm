;
; Clear the screen for the ZX/TS2068 terminal
;
		MODULE	generic_console_cls

		SECTION	code_clib
		PUBLIC	generic_console_cls

		EXTERN	__zx_console_attr
		EXTERN	__ts2068_hrg


generic_console_cls:
	push	de
	push	bc
	ld      hl,16384
        ld      de,16385
        ld      bc,6144
        ld      (hl),l
        ldir
IF FORts2068
        ld      a,(__ts2068_hrg)
        and     a
        jr      nz,cls_hrg
ENDIF
        ld      a,(__zx_console_attr)
        ld      (hl),a
        ld      bc,767
        ldir
	pop	bc
	pop	de
        ret
IF FORts2068
cls_hrg:
        ld      hl,$6000
        ld      de,$6001
        ld      bc,6144
        ld      (hl),l
        ldir
	pop	bc
	pop	de
        ret
ENDIF
