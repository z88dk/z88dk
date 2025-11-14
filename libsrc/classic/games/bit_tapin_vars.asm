
;
; Common parameters for reading tape in Kansas City /CUTS mode
;



    PUBLIC  __LOWLIM
    PUBLIC  __WINWID



; Those two parameters are intitialized by bit_tapion()
; in the leading tone sync phase
;
; They can also be set manually to force a preferred transfer speed
; when the leading tone is too short or missing


    SECTION bss_clib


__LOWLIM:
    DEFB    0

__WINWID:
    DEFB    0

