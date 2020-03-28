;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;
;	Get border colour
;

	SECTION code_clib
	PUBLIC  tvc_get_bordercolor
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        none
; In order to work properly U0 must be mapped in.
;
.tvc_get_bordercolor
._tvc_get_bordercolor
    
    ld      hl,(BORDER);
    ld      h,0

	ret

