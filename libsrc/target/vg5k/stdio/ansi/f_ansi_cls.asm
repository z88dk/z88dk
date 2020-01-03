

	MODULE	ansi_cls
	PUBLIC	ansi_cls

	defc	DISPLAY = 0x4000
	EXTERN	__vg5k_attr
	EXTERN	CONSOLE_ROWS
	EXTERN	CONSOLE_COLUMNS


ansi_cls:
        ld      a,(__vg5k_attr)
        ld      c,CONSOLE_ROWS
        ld      hl, DISPLAY
cls0:
        ld      (hl),0x00
        inc     hl
	or	128
        ld      (hl),a
        inc     hl
        and     7
        ld      b,CONSOLE_COLUMNS
cls1:   ld      (hl),32
        inc     hl
        ld      (hl),a
        inc     hl
        djnz    cls1
        dec     c
        jr      nz,cls0
        set     0,(iy+1)                ;iy -> ix, trigger interrupt to redraw screen
        ld      (iy+0),1                ;force an immediate redraw
        ret
