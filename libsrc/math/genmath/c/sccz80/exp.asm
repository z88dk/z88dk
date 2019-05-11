;       Small C+ Math Library
;       exp(x)

; FIXME: norm4


        SECTION code_fp
        PUBLIC    exp

        EXTERN     sgn
        EXTERN     floor
        EXTERN     poly

        EXTERN     fmul
        EXTERN     pushfa
        EXTERN     norm4
        EXTERN    fa
        EXTERN     fsub

;

;       transcendental functions: exp

;

.exp    LD      BC,$8138        ;1.442695041
        LD      IX,$AA3B
        LD      DE,$295C        
        CALL    fmul    
        LD      A,(fa+5)
        CP      $88
        JP      NC,DIV17
        CALL    pushfa  
        CALL    floor  
        POP     BC
        POP     IX
        POP     DE
        PUSH    AF
        CALL    fsub    
        LD      HL,EXPCOEF
        CALL    poly    
        LD      HL,fa+5 
        POP     AF
        OR      A
        JP      M,EXP5  
        ADD     A,(HL)
        DEFB      1       ;"ignore next 2 bytes"
.EXP5   ADD     A,(HL)
        CCF     
        LD      (HL),A
        RET     NC
        JP      DIV17

.DIV17	call	sgn
        cpl
        or      a
        pop     hl
        jp      p,norm4
        ret     ;jp oflow

;
	SECTION rodata_fp
.EXPCOEF 
        defb     10
        defb      $CC,$D5,$45,$56,$15,$6A
        defb      $CF,$37,$A0,$92,$27,$6D
        defb      $F5,$95,$EE,$93,$00,$71
        defb      $D0,$FC,$A7,$78,$21,$74
        defb      $B1,$21,$82,$C4,$2E,$77
        defb      $82,$58,$58,$95,$1D,$7A
        defb      $6D,$CB,$46,$58,$63,$7C
        defb      $E9,$FB,$EF,$FD,$75,$7E
        defb      $D2,$F7,$17,$72,$31,$80
        defb      0,0,0,0,0,$81

