;
;       SAM Coupé C Library
;
; 	ANSI Video handling for SAM Coupé
;
; 	Sets the attributes to default
;	
;
;	Frode Tennebø - 29/12/2002
;


	PUBLIC	ansi_default
	
.ansi_default
        ld      a,16            ; INK
        rst     16
        ld      a,7             ; default colour
        rst     16

        ld      a,17            ; PAPER
        rst     16
        xor     a               ; default colour
        rst     16

        ret

