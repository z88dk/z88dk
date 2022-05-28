;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Set pen position to X;Y (BC;DE)
;

	SECTION code_clib
    public setpos_callee
    public _setpos_callee
    public setpos
    public _setpos
    INCLUDE "target/tvc/def/tvc.def"



.setpos_callee
._setpos_callee    
    pop     hl    ; ret addr
    pop     de
    pop     bc
    push    hl    ; ret addr

.setpos
._setpos

    ld      hl,ROM_RESY-1 ; y=959-y
    xor     a
    sbc     hl,de
    ex      de,hl

    rst     $30
    defb    BABS ; GRAPHICS - SET CURSOR TO ABS POSITION
	ret
