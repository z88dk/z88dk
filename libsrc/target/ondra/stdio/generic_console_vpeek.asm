

        MODULE  generic_console_vpeek
        SECTION code_clib
        PUBLIC  generic_console_vpeek

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  screendollar
        EXTERN  screendollar_with_count

generic_console_vpeek:
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        push    hl                ;save buffer

        ; Calculate screen address
        ld      a,c
        cpl
        ld      d,a
        ld      a,b
        add     a
        add     a
        cpl
        ld      e,a

        ld      b,8
loop:
        ld      a,(de)
        ld      (hl),a
        inc     hl
        rlc     e
        dec     e
        rrc     e
        djnz    loop
        pop     de                ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
	pop	bc
	pop	bc
	pop	bc
	pop	bc
        ret
