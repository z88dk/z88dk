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
				PUBLIC    _gsx_xscale_factor
				
				EXTERN    l_mult
				EXTERN    l_neg

.getmaxx
._getmaxx
		ld	hl,(_gsx_maxx)
		ret


.gsx_xscale
._gsx_xscale
        ld      de,(_gsx_xscale_factor)
        call    l_mult
		jp      l_neg



	SECTION  bss_graphics
._gsx_maxx
	defw 0

._gsx_xscale_factor
	defw 0
