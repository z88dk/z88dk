;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    cos
                LIB     sin
		LIB	hladd


                XREF    halfpi



;double cos(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack



;
;       transcendental functions: sin, cos, tan
;
.COS    LD      HL,HALFPI
        CALL    HLADD   
        jp      sin

