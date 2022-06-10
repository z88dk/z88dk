;
;   Videoton TV Computer asm stub
;   Sandor Vass - 2022
;
;	Fills the screen from the given x,y coordinate
;


	SECTION code_clib
	PUBLIC fill
    PUBLIC _fill
    EXTERN pen_up
    EXTERN pen_down
    EXTERN setpos 
    INCLUDE "target/tvc/def/tvc.def"

.fill
._fill
    call pen_up
    ld hl,2
    add hl,sp
    ld e,(hl)
    inc hl 
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    
    call setpos

    rst     $30
    defb    FILL ; GRAPHICS - FILL
	ret

