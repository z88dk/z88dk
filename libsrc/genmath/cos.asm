;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    cos
                LIB     sin
		LIB	hladd

		XREF	__halfpi





;double cos(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack



;
;       transcendental functions: sin, cos, tan
;
.COS    LD      HL,HALFPI	;local copy..
        CALL    HLADD   
        jp      sin

.halfpi	DEFB      $22,$A2,$DA,$0F,$49,$81 ; pi/2





