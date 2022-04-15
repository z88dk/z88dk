;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Move pen to dX;dY (BC;DE) relatively
;

	SECTION code_clib
	PUBLIC move
    INCLUDE "target/tvc/def/tvc.def"



.move
._move

    ld      hl,2
    add     hl,sp
    ld      e,(hl)  ; getting dY
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)  ; getting dX
    inc     hl
    ld      b,(hl)

    ld      hl,0 ; y=-y
    xor     a
    sbc     hl,de
    ex      de,hl


    rst     $30
    defb    BREL ; GRAPHICS - MOVE CURSOR RELATIVE
	ret
