

		MODULE		fputc_cons_generic_minimal


                defc            SUPPORT_vt52=1
                ; Extra VT52 codes - clear to end of line + clear to end of screen + underlined
                defc            SUPPORT_vt52x=0
                defc            SUPPORT_zxcodes=1

                SECTION         code_clib
                PUBLIC          fputc_cons_generic_minimal
                PUBLIC          _fputc_cons_generic_minimal

fputc_cons_generic_minimal:
_fputc_cons_generic_minimal:
		INCLUDE		"fputc_cons_generic.inc"

