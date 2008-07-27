;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    pi

		LIB	ldfabc


;double pi()

;Just the greek PI constant


.PI
        LD      BC,$8249       ; 3,1415...
        LD      IX,$0FDA
        LD      DE,$A222
        
        JP      LDFABC  
