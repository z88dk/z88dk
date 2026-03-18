;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_posit_callee.asm $
;

;   This function goes through the sector chain in a file up to the desired sector count.
;   

; uint16_t hdos_posit(int channel, int sector);

    SECTION code_clib
    PUBLIC  hdos_posit_callee
    PUBLIC  _hdos_posit_callee

    PUBLIC    asm_hdos_posit

    INCLUDE "target/hdos/def/hdos.def"

hdos_posit_callee:
_hdos_posit_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_posit:
    ld     a,l
    rst    38h
    defb   POSIT
    ld     h,b
	ld     l,c
    ret
