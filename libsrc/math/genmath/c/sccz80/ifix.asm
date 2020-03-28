;       Small C+ Math Library


        SECTION code_fp
        PUBLIC    ifix
        EXTERN     floor
        EXTERN     l_long_neg

        EXTERN    fa

;
;       convert the floating point number in FA
;       to an integer in hl  (rounds toward negative numbers)
;
;       This routine will need to be rewritten to handle longs

.ifix   CALL    floor          ;take floor first
        LD      HL,0            ;initialize the result
	ld	d,l
	ld	e,l
        LD      A,(fa+5)        ;get the exponent
        LD      B,A             ;  and save it
        OR      A
        RET     Z               ;z => number was zero
        LD      de,(fa+3)       ;get most significant bits
	ld	hl,(fa+1)
        LD      C,d             ;save sign bit (msb)
        LD      A,B             ;get exponent again
        CP      $80+32
        JP      M,IFIX5         ;m => fabs(fa) < 32768

	ret			;
IF 0
        ret     nz		;would be overflow
        LD      A,d
        CP      $80
        ret     nz		;overflow..
        LD      A,L
        OR      A
        RET                     ;return -32768. (overflow)
ENDIF
;
.IFIX5  SET     7,d             ;restore hidden bit
.IFIX6  SRL     d               ;shift right (0 fill)
        rr	e
        rr	h
        RR      L               ;shift right (cy fill)
        INC     A
        CP      32+$80
        JR      NZ,IFIX6        ;nz => haven't shifted enough
        RL      C
        RET     NC              ;nc => positive number
        jp	l_long_neg	;negate
