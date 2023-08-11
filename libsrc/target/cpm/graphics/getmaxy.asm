;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm $
;


	INCLUDE	"graphics/grafix.inc"


                SECTION         code_graphics
                PUBLIC    getmaxy
                PUBLIC    _getmaxy
                PUBLIC    _gsx_maxy
                PUBLIC    gsx_yscale
                PUBLIC    _gsx_yscale
                PUBLIC    gsx_yoffs
                PUBLIC    _gsx_yoffs
				PUBLIC    _gsx_yscale_factor

				EXTERN    l_mult
				EXTERN    l_neg

.getmaxy
._getmaxy
		ld	hl,(_gsx_maxy)
		ret


.gsx_yscale
._gsx_yscale
        ld      de,(_gsx_yscale_factor)
		push   de
		call   l_mult
		pop    de
IF __CPU_INTEL__
                ld      a,d
                and     a
                rra
                ld      d,a
                ld      a,e
                rra
                ld      e,a
ELSE
		srl    d
		rr     e
ENDIF
		add    hl,de

		ld      de,32767
        ex      de,hl
        and     a
        sbc     hl,de
		ret


.gsx_yoffs
._gsx_yoffs
        ld      de,(_gsx_yscale_factor)
		call   l_mult
		jp     l_neg


	SECTION  bss_graphics
._gsx_maxy
	defw 0

._gsx_yscale_factor
	defw 0
