; void bordercolor(int c) __z88dk_fastcall;
;
;

        #include    "target/aquarius/def/plus.inc"
        SECTION code_clib
	EXTERN	__aquarius_mode
        PUBLIC  bordercolor
        PUBLIC  _bordercolor

bordercolor:
_bordercolor:
        ld      a, (__aquarius_mode)
        bit     6, a
        jr      nz, col80

        ; Set the color value
        ld      a, l
        ld      (BORDERCLR), a
        ret

col80:
        ld      b, a
        or      VCTRL_TEXT_PAGE
        out     (IO_VCTRL), a

        ; Set the color value
        ld      a, l
        ld      (BORDERCLR), a

        ; Restore original value
        ld      a, b
        out     (IO_VCTRL), a
        ret

