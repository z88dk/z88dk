
	MODULE	scrollup_MODE1

	PUBLIC	scrollup_MODE1

	EXTERN	generic_console_printc
	EXTERN	__console_w


scrollup_MODE1:
        ld      hl,($2a6a)
	ld	bc,$20
	add	hl,bc
        ld      d,h
        ld      e,l
	ex	de,hl
        inc     h
        ld      bc,32 * 200
        ldir
        ld      bc,(__console_w)
        dec     b
        ld      a,c             ;console_w
        ld      c,0
clear_last_row:
        push    af
        push    bc
        ld      a,32
        ld      d,a
        ld      e,0
        call    generic_console_printc
        pop     bc
        inc     c
        pop     af
        dec     a
        jr      nz,clear_last_row
        pop     bc
        pop     de
        ret
