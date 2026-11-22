    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics

cleargraphics:
_cleargraphics:
    ld      a, ' '
IF FORg850
    ld      b, 24*6
ELSE
    ld      b, 24*4
ENDIF
    ld      de, 0
    call      $bfee

IF FORg850

busy_check:
    in      a, (0x40)
    and     0x80
    jp      nz, busy_check
    ld		a,0x40
    out     (0x40), a

ELSE

IF FORg815
busy_check_0:
    in      a, (0x55)
    and     0x80
    jp      nz, busy_check_0
    ld      a, 0xc0                     ; set scroll startline to 0
	out     (0x54), a
ENDIF

busy_check:
    in      a, (0x59)
    and     0x80
    jp      nz, busy_check
    ld      a, 0xc0                     ; set scroll startline to 0
	out     (0x58), a

ENDIF

	ret
