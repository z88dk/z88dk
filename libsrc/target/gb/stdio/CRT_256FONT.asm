                SECTION         rodata_clib

                PUBLIC          CRT_256FONT

		EXTERN		_font_ibm_fixed_tiles


		; The font used for graphical writing - compatibility with gbdk
                defc            CRT_256FONT = _font_ibm_fixed_tiles
