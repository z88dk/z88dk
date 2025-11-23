

    MODULE  fputc_cons_generic_full


    defc    SUPPORT_vt52=1
    ; Extra VT52 codes - clear to end of line + clear to end of screen + underlined
    defc    SUPPORT_vt52x=1
    defc    SUPPORT_zxcodes=1

    SECTION code_clib
    PUBLIC  fputc_cons_generic
    PUBLIC  _fputc_cons_generic

fputc_cons_generic:
_fputc_cons_generic:
    INCLUDE "fputc_cons_generic.inc"
