;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

        SECTION code_fp
        PUBLIC    pi

	EXTERN	ldfabc


;double pi()

;Just the greek PI constant


.pi
        LD      BC,$8249       ; 3,1415...
        LD      IX,$0FDA
        LD      DE,$A222
        
        JP      ldfabc  
