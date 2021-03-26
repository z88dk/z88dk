;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm $
;


	INCLUDE	"graphics/grafix.inc"


                SECTION         code_graphics
                PUBLIC    getmaxx
                PUBLIC    _getmaxx
                PUBLIC    _gsx_maxx
                PUBLIC    gsx_xscale
                PUBLIC    _gsx_xscale
                PUBLIC    gsx_xoffs
                PUBLIC    _gsx_xoffs
				PUBLIC    _gsx_xscale_factor
				
				EXTERN    l_mult

.getmaxx
._getmaxx
		ld	hl,(_gsx_maxx)
		ret


.gsx_xscale
._gsx_xscale
        ld     de,(_gsx_xscale_factor)
		push   de
		call   l_mult
		pop    de
		srl    d
		rr     e
		add    hl,de
		ret


.gsx_xoffs
._gsx_xoffs
        ld      de,(_gsx_xscale_factor)
		jp   l_mult



	SECTION  bss_graphics
._gsx_maxx
	defw 0

._gsx_xscale_factor
	defw 0
