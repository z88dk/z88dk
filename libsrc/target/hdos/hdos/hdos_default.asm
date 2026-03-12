;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_default.asm $
;

    SECTION data_clib
    PUBLIC  hdos_default
    PUBLIC  _hdos_default

hdos_default:
_hdos_default:
    defm   "SY1XXX"
    defb   0
