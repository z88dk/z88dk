;       Small C+ Maths Routines
;
;       transcendental floating point routines
;

                XLIB    atan
                LIB     evenpol
		LIB	hlsub


                XREF    sgn
                XREF    odd
                XREF    fdiv
                XREF    halfpi
		XREF	fa

                XDEF    atncoef


;double atan(double val)

;Looks odd, but don't worry..value is already in FA - no need for stack


.ATAN   CALL    SGN     
        CALL    M,ODD           ;negate argument & answer
        LD      A,(FA+5)
        CP      $81
        JR      C,ATAN5         ;c => argument less than 1
        LD      BC,$8100        ;1.0
        LD      IX,0
        LD      D,C
        LD      E,C
        CALL    FDIV    
        LD      HL,HLSUB
        PUSH    HL      ;will subtract answer from pi/2
.ATAN5  LD      HL,ATNCOEF
        CALL    EVENPOL
        LD      HL,HALFPI      ;may use for subtraction
        RET     
;
.ATNCOEF 
        defb     13               ;hmmm? $13?

        defb      $14, $7,$BA,$FE,$62,$75
        defb      $51,$16,$CE,$D8,$D6,$78
        defb      $4C,$BD,$7D,$D1,$3E,$7A
        defb      $1, $CB,$23,$C4,$D7,$7B
        defb      $DC,$3A,$A, $17,$34,$7C
        defb      $36,$C1,$A3,$81,$F7,$7C
        defb      $EB,$16,$61,$AE,$19,$7D
        defb      $5D,$78,$8F,$60,$B9,$7D
        defb      $A2,$44,$12,$72,$63,$7D
        defb      $16,$62,$FB,$47,$92,$7E
        defb      $C0,$F0,$BF,$CC,$4C,$7E
        defb      $7E,$8E,$AA,$AA,$AA,$7F
        defb      $F6,$FF,$FF,$FF,$7F,$80

