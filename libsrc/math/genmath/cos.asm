;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

        SECTION code_fp
        PUBLIC    cos
        EXTERN     sin
	EXTERN	hladd

	EXTERN	__halfpi





;double cos(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack



;
;       transcendental functions: sin, cos, tan
;
.cos    LD      HL,halfpi	;local copy..
        CALL    hladd   
        jp      sin

.halfpi	DEFB      $22,$A2,$DA,$0F,$49,$81 ; pi/2





