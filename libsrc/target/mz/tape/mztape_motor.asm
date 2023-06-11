; int mztape_motor(int onoff)
; CALLER linkage for function pointers

PUBLIC mztape_motor
PUBLIC _mztape_motor

PUBLIC mztape_motor_on
PUBLIC mztape_motor_off


.mztape_motor
._mztape_motor
		xor		a
		or		l
		jr		nz,mztape_motor_on


mztape_motor_off:
        PUSH    AF
        PUSH    BC
        PUSH    DE
        LD      B,0AH
MST1:   LD      A,(0E002h)	;CSTR
        AND     10H
        JR      Z,MST3
        LD      A,06H
        LD      (0E003h),A	;CSTPT
        INC     A
        LD      (0E003h),A	;CSTPT
        DJNZ    MST1
MST3:   
        POP     DE
        POP     BC
        POP     AF
        RET     


mztape_motor_on:
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL

        LD      B,0Ah
MOT1:   LD      A,(0E002h)	;CSTR
        AND     10h
        JR      Z,MOT4

MOT2:   LD      B,0FFh		; 2 SEC DELAY
L06AD:  CALL    DLY12		; 7 MSEC DELAY
        JR      L06B4		; MOTOR ENTRY ADJUST
L06B4:  DJNZ    L06AD

;        XOR     A
MOT7:
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET     


MOT4:   LD      A,06H
        LD      HL,0E003h	;CSTPT
        LD      (HL),A
        INC     A
        LD      (HL),A
        DJNZ    MOT1

        ;CALL    NL
        ;LD      A,D
        ;CP      0D7h		; "W"
        ;JR      Z,MOT8
        ;LD      DE,MSGN1	; PLAY MARK
        ;JR      MOT9

;MOT8:   LD      DE,MSGN3	; "RECORD."
;        RST     18h		; CALL MSGX
;        LD      DE,MSGN2	; "PLAY"
;MOT9:   RST     18H		; CALL MSGX
MOT5:   LD      A,(0E002h)	;CSTR
        AND     10H
        JR      NZ,MOT2
        ;CALL    QBRK
        JR      NZ,MOT5
        SCF     
        JR      MOT7   


;	DLY 7 MSEC
DLY12:  PUSH    BC
        LD      B,15H
L0999:  CALL    DLY3
        DJNZ    L0999
        POP     BC
        RET     

;	320 U SEC DELAY
DLY3:   LD      A,3FH		; 18*63+33
        JP      L0762

DLY2:   LD      A,13H		; 18*19+20
L0762:  DEC     A
        JP      NZ,L0762
        RET     

