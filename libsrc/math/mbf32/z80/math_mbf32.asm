; Microsoft 32 bit Maths library
;
; Extracted from Nascom Microsoft Basic V4.7
; Scanned from source published in 80-BUS NEWS from Vol 2, Issue 3 
; (May-June 1983) to Vol 3, Issue 3 (May-June 1984).
;
; (C) 1978 Microsoft
;
; Original source: https://github.com/feilipu/NASCOM_BASIC_4.7
; The 8085 and Z80 instruction tuning are copyright (C) 2021 Phillip Stevens
;
; Base target CPU is 8080, exception code paths for 8085, GBZ80, & Z80.
;

MODULE  mbf32

SECTION code_fp_mbf32

INCLUDE "mbfs.def"

PUBLIC  ARET                    ; A ret instruction

ROUND:  LD      HL,HALF         ; Add 0.5 to FPREG
ADDPHL: CALL    LOADFP          ; Load FP at (HL) to BCDE
        JP      FPADD           ; Add BCDE to FPREG

SUBPHL: CALL    LOADFP          ; FPREG = -FPREG + number at HL
        DEFB    21H             ; Skip "POP BC" and "POP DE"
PSUB:   POP     BC              ; Get FP number from stack
        POP     DE
SUBCDE: CALL    INVSGN          ; Negate FPREG
FPADD:  LD      A,B             ; Get FP exponent
        OR      A               ; Is number zero?
        RET     Z               ; Yes - Nothing to add
        LD      A,(FPEXP)       ; Get exponent of FPREG
        OR      A               ; Is this number zero?
        JP      Z,FPBCDE        ; Yes - Move BCDE to FPREG
        SUB     B               ; BCDE number larger?
        JP      NC,NOSWAP       ; No - Don't swap them
        CPL                     ; Two's complement
        INC     A               ; FP exponent
IF __CPU_GBZ80__
        EX      DE,HL
        CALL    STAKFP          ; Put FPREG on stack
        EX      DE,HL
ELSE
        LD      HL,(FPREG)      ; LSB,NLSB of FPREG
        PUSH    HL              ; Stack them
        LD      HL,(FPREG+2)    ; MSB and exponent of FPREG
        PUSH    HL              ; Stack them
ENDIF
IF __CPU_Z80__
        LD      (FPREG),DE      ; Move BCDE to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Move BCDE to FPREG
ENDIF
        POP     BC              ; Restore number from stack
        POP     DE
NOSWAP: CP      24+1            ; Second number insignificant?
        RET     NC              ; Yes - First number is result
        PUSH    AF              ; Save number of bits to scale
        CALL    SIGNS           ; Set MSBs & sign of result
        LD      H,A             ; Save sign of result
        POP     AF              ; Restore scaling factor
        CALL    SCALE           ; Scale BCDE to same exponent
        OR      H               ; Result to be positive?
        LD      HL,FPREG        ; Point to FPREG
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,MINCDE        ; No - Subtract FPREG from CDE
ELSE
        JP      P,MINCDE        ; No - Subtract FPREG from CDE
ENDIF
        CALL    PLUCDE          ; Add FPREG to CDE
        JP      NC,RONDUP       ; No overflow - Round it up
        INC     HL              ; Point to exponent
        INC     (HL)            ; Increment it
        JP      Z,OVERR         ; Number overflowed - Error
        LD      L,1             ; 1 bit to shift right
        LD      C,A             ; Save MSB of BCDE
        CALL    SHRT1           ; Shift result right
        JP      RONDUP          ; Round it up

MINCDE: XOR     A               ; Clear A and carry
        SUB     B               ; Negate exponent
        LD      B,A             ; Re-save exponent
        LD      A,(HL)          ; Get LSB of FPREG
        SBC     A, E            ; Subtract LSB of BCDE
        LD      E,A             ; Save LSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get NMSB of FPREG
        SBC     A,D             ; Subtract NMSB of BCDE
        LD      D,A             ; Save NMSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get MSB of FPREG
        SBC     A,C             ; Subtract MSB of BCDE
        LD      C,A             ; Save MSB of BCDE
CONPOS: CALL    C,COMPL         ; Overflow - Make it positive

BNORM:  LD      L,B             ; L = Exponent
        LD      H,E             ; H = LSB
        XOR     A
BNRMLP: LD      B,A             ; Save bit count
        LD      A,C             ; Get MSB
        OR      A               ; Is it zero?
        JP      NZ,PNORM        ; No - Do it bit at a time
        LD      C,D             ; MSB = NMSB
        LD      D,H             ; NMSB= LSB
        LD      H,L             ; LSB = VLSB
        LD      L,A             ; VLSB= 0
        LD      A,B             ; Get exponent
        SUB     8               ; Count 8 bits
        CP      -24-8           ; Was number zero?
        JP      NZ,BNRMLP       ; No - Keep normalising
RESZER: XOR     A               ; Result is zero
SAVEXP: LD      (FPEXP),A       ; Save result as zero
        RET

NORMAL: DEC     B               ; Count bits
        ADD     HL,HL           ; Shift HL left
IF __CPU_Z80__
        RL      D               ; Get NMSB, shift left with last bit
        RL      C               ; Get MSB, shift left with last bit
ELSE
        LD      A,D             ; Get NMSB
        RLA                     ; Shift left with last bit
        LD      D,A             ; Save NMSB
        LD      A,C             ; Get MSB
        ADC     A,A             ; Shift left with last bit
        LD      C,A             ; Save MSB
ENDIF
PNORM:
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,NORMAL        ; Not done - Keep going
ELSE
        JP      P,NORMAL        ; Not done - Keep going
ENDIF
        LD      A,B             ; Number of bits shifted
        LD      E,H             ; Save HL in EB
        LD      B,L
        OR      A               ; Any shifting done?
        JP      Z,RONDUP        ; No - Round it up
        LD      HL,FPEXP        ; Point to exponent
        ADD     A,(HL)          ; Add shifted bits
        LD      (HL),A          ; Re-save exponent
        JP      NC,RESZER       ; Underflow - Result is zero
        RET     Z               ; Result is zero
RONDUP: LD      A,B             ; Get VLSB of number
RONDB:  LD      HL,FPEXP        ; Point to exponent
        OR      A               ; Any rounding?
IF __CPU_GBZ80__
        BIT     7,A
        CALL    NZ,FPROND       ; Yes - Round number up
ELSE
        CALL    M,FPROND        ; Yes - Round number up
ENDIF
        LD      B,(HL)          ; B = Exponent
        INC     HL
        LD      A,(HL)          ; Get sign of result
        AND     10000000B       ; Only bit 7 needed
        XOR     C               ; Set correct sign
        LD      C,A             ; Save correct sign in number
IF __CPU_Z80__
FPBCDE: LD      (FPREG),DE      ; Move BCDE to FPREG
        LD      (FPREG+2),BC
        RET
ELSE
        JP      FPBCDE          ; Move BCDE to FPREG
ENDIF

FPROND: INC     E               ; Round LSB
        RET     NZ              ; Return if ok
        INC     D               ; Round NMSB
        RET     NZ              ; Return if ok
        INC     C               ; Round MSB
        RET     NZ              ; Return if ok
        LD      C,80H           ; Set normal value
        INC     (HL)            ; Increment exponent
        RET     NZ              ; Return if ok
        JP      OVERR           ; Overflow error

PLUCDE: LD      A,(HL)          ; Get LSB of FPREG
        ADD     A,E             ; Add LSB of BCDE
        LD      E,A             ; Save LSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get NMSB of FPREG
        ADC     A,D             ; Add NMSB of BCDE
        LD      D,A             ; Save NMSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get MSB of FPREG
        ADC     A,C             ; Add MSB of BCDE
        LD      C,A             ; Save MSB of BCDE
        RET

COMPL:  LD      HL,SGNRES       ; Sign of result
        LD      A,(HL)          ; Get sign of result
        CPL                     ; Negate it
        LD      (HL),A          ; Put it back
        XOR     A
        LD      L,A             ; Set L to zero
        SUB     B               ; Negate exponent,set carry
        LD      B,A             ; Re-save exponent
        LD      A,L             ; Load zero
        SBC     A,E             ; Negate LSB
        LD      E,A             ; Re-save LSB
        LD      A,L             ; Load zero
        SBC     A,D             ; Negate NMSB
        LD      D,A             ; Re-save NMSB
        LD      A,L             ; Load zero
        SBC     A,C             ; Negate MSB
        LD      C,A             ; Re-save MSB
        RET

SCALE:  LD      B,0             ; Clear underflow
SCALLP: SUB     8               ; 8 bits (a whole byte)?
        JP      C,SHRITE        ; No - Shift right A bits
        LD      B,E             ; <- Shift
        LD      E,D             ; <- right
        LD      D,C             ; <- eight
        LD      C,0             ; <- bits
        JP      SCALLP          ; More bits to shift

SHRITE: ADD     A,8+1           ; Adjust count
        LD      L,A             ; Save bits to shift
SHRLP:  XOR     A               ; Flag for all done
        DEC     L               ; All shifting done?
        RET     Z               ; Yes - Return
IF _CPU_Z80__
SHRT1:  RR      C               ; Get MSB, shift it right
        RR      D               ; Get NMSB,shift right with last bit
        RR      E               ; Get LSB, shift right with last bit
        RR      B               ; Get underflow, shift right with last bit
ELSE
SHRT1:  LD      A,C             ; Get MSB
        RRA                     ; Shift it right
        LD      C,A             ; Re-save
        LD      A,D             ; Get NMSB
        RRA                     ; Shift right with last bit
        LD      D,A             ; Re-save it
        LD      A,E             ; Get LSB
        RRA                     ; Shift right with last bit
        LD      E,A             ; Re-save it
        LD      A,B             ; Get underflow
        RRA                     ; Shift right with last bit
        LD      B,A             ; Re-save underflow
ENDIF
        JP      SHRLP           ; More bits to do

UNITY:  DEFB    000H,000H,000H,081H     ; 1.00000

LOGTAB: DEFB    3                       ; Table used by LOG
        DEFB    0AAH,056H,019H,080H     ; 0.59898
        DEFB    0F1H,022H,076H,080H     ; 0.96147
        DEFB    045H,0AAH,038H,082H     ; 2.88539

LOG:    CALL    TSTSGN          ; Test sign of value
IF __CPU_GBZ80__
        BIT     7,A
        JP      NZ,FCERR        ; ?FC Error if < zero
ELSE
        OR      A
        JP      PE,FCERR        ; ?FC Error if <= zero
ENDIF
        LD      HL,FPEXP        ; Point to exponent
        LD      A,(HL)          ; Get exponent
        LD      BC,8035H        ; BCDE = SQR(1/2)
        LD      DE,04F3H
        SUB     B               ; Scale value to be < 1
        PUSH    AF              ; Save scale factor
        LD      (HL),B          ; Save new exponent
        PUSH    DE              ; Save SQR(1/2)
        PUSH    BC
        CALL    FPADD           ; Add SQR(1/2) to value
        POP     BC              ; Restore SQR(1/2)
        POP     DE
        INC     B               ; Make it SQR(2)
        CALL    DVBCDE          ; Divide by SQR(2)
        LD      HL,UNITY        ; Point to 1.
        CALL    SUBPHL          ; Subtract FPREG from 1
        LD      HL,LOGTAB       ; Coefficient table
        CALL    SUMSER          ; Evaluate sum of series
        LD      BC,8080H        ; BCDE = -0.5
        LD      DE,0000H
        CALL    FPADD           ; Subtract 0.5 from FPREG
        POP     AF              ; Restore scale factor
        CALL    RSCALE          ; Re-scale number
MULLN2: LD      BC,8031H        ; BCDE = Ln(2)
        LD      DE,7218H
        DEFB    21H             ; Skip "POP BC" and "POP DE"

MULT:   POP     BC              ; Get number from stack
        POP     DE
FPMULT: CALL    TSTSGN          ; Test sign of FPREG
        RET     Z               ; Return zero if zero
        LD      L,0             ; Flag add exponents
        CALL    ADDEXP          ; Add exponents
        LD      A,C             ; Get MSB of multiplier
        LD      (MULVAL),A      ; Save MSB of multiplier
IF __CPU_GBZ80__
        LD      HL,MULVAL+1
        LD      (HL),E          ; Save rest of multiplier
        INC     HL
        LD      (HL),D
ELSE
        EX      DE,HL
        LD      (MULVAL+1),HL   ; Save rest of multiplier
ENDIF
        LD      BC,0            ; Partial product (BCDE) = zero
        LD      DE,BC
        LD      HL,BNORM        ; Address of normalise
        PUSH    HL              ; Save for return
        LD      HL,MULT8        ; Address of 8 bit multiply
        PUSH    HL              ; Save for NMSB,MSB
        PUSH    HL              ; 
        LD      HL,FPREG        ; Point to number
MULT8:  LD      A,(HL)          ; Get LSB of number
        INC     HL              ; Point to NMSB
        OR      A               ; Test LSB
        JP      Z,BYTSFT        ; Zero - shift to next byte
        PUSH    HL              ; Save address of number
        LD      L,8             ; 8 bits to multiply by
MUL8LP: RRA                     ; Shift LSB right
        LD      H,A             ; Save LSB
        LD      A,C             ; Get MSB
        JP      NC,NOMADD       ; Bit was zero - Don't add
        PUSH    HL              ; Save LSB and count
IF __CPU_GBZ80__
        LD      HL,MULVAL+1
        LD      A,(HL+)         ; Get LSB and NMSB
        LD      H,(HL)
        LD      L,A
ELSE
        LD      HL,(MULVAL+1)   ; Get LSB and NMSB
ENDIF
        ADD     HL,DE           ; Add NMSB and LSB
        EX      DE,HL           ; Leave sum in DE
        POP     HL              ; Restore MSB and count
        LD      A,(MULVAL)      ; Get MSB of multiplier
        ADC     A,C             ; Add MSB
NOMADD: RRA                     ; Shift MSB right
        LD      C,A             ; Re-save MSB
        LD      A,D             ; Get NMSB
        RRA                     ; Shift NMSB right
        LD      D,A             ; Re-save NMSB
        LD      A,E             ; Get LSB
        RRA                     ; Shift LSB right
        LD      E,A             ; Re-save LSB
        LD      A,B             ; Get VLSB
        RRA                     ; Shift VLSB right
        LD      B,A             ; Re-save VLSB
        DEC     L               ; Count bits multiplied
        LD      A,H             ; Get LSB of multiplier
        JP      NZ,MUL8LP       ; More - Do it
POPHRT: POP     HL              ; Restore address of number
        RET

BYTSFT: LD      B,E             ; Shift partial product left
        LD      E,D
        LD      D,C
        LD      C,A
        RET

DIV10:
IF __CPU_GBZ80__
        CALL    STAKFP          ; Save FPREG on stack
ELSE
        LD      HL,(FPREG)      ; LSB,NLSB of FPREG
        PUSH    HL              ; Stack them
        LD      HL,(FPREG+2)    ; MSB and exponent of FPREG
        PUSH    HL              ; Stack them
ENDIF
        LD      BC,8420H        ; BCDE = 10.
        LD      DE,0000H
IF __CPU_Z80__
        LD      (FPREG),DE      ; Move 10 to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Move 10 to FPREG
ENDIF

DIV:    POP     BC              ; Get number from stack
        POP     DE
DVBCDE: CALL    TSTSGN          ; Test sign of FPREG
        JP      Z,DZERR         ; Error if division by zero
        LD      L,-1            ; Flag subtract exponents
        CALL    ADDEXP          ; Subtract exponents
        INC     (HL)            ; Add 2 to exponent to adjust
        INC     (HL)
        DEC     HL              ; Point to MSB
        LD      A,(HL)          ; Get MSB of dividend
        LD      (DIV3),A        ; Save for subtraction
        DEC     HL
        LD      A,(HL)          ; Get NMSB of dividend
        LD      (DIV2),A        ; Save for subtraction
        DEC     HL
        LD      A,(HL)          ; Get LSB of dividend
        LD      (DIV1),A        ; Save for subtraction
        LD      B,C             ; Get MSB
        EX      DE,HL           ; NMSB,LSB to HL
        XOR     A
        LD      C,A             ; Clear MSB of quotient
        LD      D,A             ; Clear NMSB of quotient
        LD      E,A             ; Clear LSB of quotient
        LD      (DIV4),A        ; Clear overflow count
DIVLP:  PUSH    HL              ; Save divisor
        PUSH    BC
        LD      A,L             ; Get LSB of number
        CALL    DIVSUP          ; Subt' divisor from dividend
        SBC     A,0             ; Count for overflows
        CCF
        JP      NC,RESDIV       ; Restore divisor if borrow
        LD      (DIV4),A        ; Re-save overflow count
        POP     AF              ; Scrap divisor
        POP     AF
        SCF                     ; Set carry to
        DEFB    0D2H            ; Skip "POP BC" and "POP HL"

RESDIV: POP     BC              ; Restore divisor
        POP     HL
        LD      A,C             ; Get MSB of quotient
        INC     A
        DEC     A
        RRA                     ; Bit 0 to bit 7
IF __CPU_GBZ80__
        BIT     6,A             ; Need to get the result of the inc/dec
        JP      NZ,RONDB        ; Done - Normalise result
ELSE
        JP      M,RONDB         ; Done - Normalise result
ENDIF
        RLA                     ; Restore carry
IF __CPU_Z80__
        RL      E               ; Get LSB of quotient, double it
        RL      D               ; Get NMSB of quotient, double it
ELIF __CPU_8085__
        RL      DE              ; Get NMSB and LSB of quotient, double them
ELSE
        LD      A,E             ; Get LSB of quotient
        RLA                     ; Double it
        LD      E,A             ; Put it back
        LD      A,D             ; Get NMSB of quotient
        RLA                     ; Double it
        LD      D,A             ; Put it back
ENDIF
IF __CPU_Z80__
        RL      C               ; Get MSB of quotient, double it
ELSE
        LD      A,C             ; Get MSB of quotient
        RLA                     ; Double it
        LD      C,A             ; Put it back
ENDIF
        ADD     HL,HL           ; Double NMSB,LSB of divisor
IF __CPU_Z80__
        RL      B               ; Get MSB of divisor, double it
ELSE
        LD      A,B             ; Get MSB of divisor
        RLA                     ; Double it
        LD      B,A             ; Put it back
ENDIF
        LD      A,(DIV4)        ; Get VLSB of quotient
        RLA                     ; Double it
        LD      (DIV4),A        ; Put it back
        LD      A,C             ; Get MSB of quotient
        OR      D               ; Merge NMSB
        OR      E               ; Merge LSB
        JP      NZ,DIVLP        ; Not done - Keep dividing
        PUSH    HL              ; Save divisor
        LD      HL,FPEXP        ; Point to exponent
        DEC     (HL)            ; Divide by 2
        POP     HL              ; Restore divisor
        JP      NZ,DIVLP        ; Ok - Keep going
        JP      OVERR           ; Overflow error

ADDEXP: LD      A,B             ; Get exponent of dividend
        OR      A               ; Test it
        JP      Z,OVTST3        ; Zero - Result zero
        LD      A,L             ; Get add/subtract flag
        LD      HL,FPEXP        ; Point to exponent
        XOR     (HL)            ; Add or subtract it
        ADD     A,B             ; Add the other exponent
        LD      B,A             ; Save new exponent
        RRA                     ; Test exponent for overflow
        XOR     B
IF __CPU_GBZ80__
        BIT     7,A
ENDIF
        LD      A,B             ; Get exponent
IF __CPU_GBZ80__
        JP      Z,OVTST2        ; Positive - Test for overflow
ELSE
        JP      P,OVTST2        ; Positive - Test for overflow
ENDIF
        ADD     A,80H           ; Add excess 128
        LD      (HL),A          ; Save new exponent
        JP      Z,POPHRT        ; Zero - Result zero
        CALL    SIGNS           ; Set MSBs and sign of result
        LD      (HL),A          ; Save new exponent
        DEC     HL              ; Point to MSB
        RET

OVTST1: CALL    TSTSGN          ; Test sign of FPREG
        CPL                     ; Invert sign
        POP     HL              ; Clean up stack
OVTST2: OR      A               ; Test if new exponent zero
OVTST3: POP     HL              ; Clear off return address
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,RESZER        ; Result zero
ELSE
        JP      P,RESZER        ; Result zero
ENDIF
        JP      OVERR           ; Overflow error

MLSP10:
IF __CPU_Z80__
        LD      DE,(FPREG)      ; Move FPREG to BCDE
        LD      BC,(FPREG+2)
ELSE
        CALL    BCDEFP          ; Move FPREG to BCDE
ENDIF
        LD      A,B             ; Get exponent
        OR      A               ; Is it zero?
        RET     Z               ; Yes - Result is zero
        ADD     A,2             ; Multiply by 4
        JP      C,OVERR         ; Overflow - ?OV Error
        LD      B,A             ; Re-save exponent
        CALL    FPADD           ; Add BCDE to FPREG (Times 5)
        LD      HL,FPEXP        ; Point to exponent
        INC     (HL)            ; Double number (Times 10)
        RET     NZ              ; Ok - Return
        JP      OVERR           ; Overflow error

TSTSGN: LD      A,(FPEXP)       ; Get sign of FPREG
        OR      A
        RET     Z               ; RETurn if number is zero
        LD      A,(FPREG+2)     ; Get MSB of FPREG
        DEFB    0FEH            ; Test sign
RETREL: CPL                     ; Invert sign
        RLA                     ; Sign bit to carry
FLGDIF: SBC     A,A             ; Carry to all bits of A
        RET     NZ              ; Return -1 if negative
        INC     A               ; Bump to +1
        RET                     ; Positive - Return +1

SGN:    CALL    TSTSGN          ; Test sign of FPREG
FLGREL: LD      B,80H+8         ; 8 bit integer in exponent
        LD      DE,0            ; Zero NMSB and LSB
RETINT: LD      HL,FPEXP        ; Point to exponent
        LD      C,A             ; CDE = MSB,NMSB and LSB
        LD      (HL),B          ; Save exponent
        LD      B,0             ; CDE = integer to normalise
        INC     HL              ; Point to sign of result
        LD      (HL),80H        ; Set sign of result
        RLA                     ; Carry = sign of integer
        JP      CONPOS          ; Set sign of result

ABS:    CALL    TSTSGN          ; Test sign of FPREG
IF __CPU_GBZ80__
        BIT     7,A
        RET     Z               ; Return if positive
ELSE
        RET     P               ; Return if positive
ENDIF
INVSGN: LD      HL,FPREG+2      ; Point to MSB
        LD      A,(HL)          ; Get sign of mantissa
        XOR     80H             ; Invert sign of mantissa
        LD      (HL),A          ; Re-save sign of mantissa
        RET

STAKFP: EX      DE,HL           ; Save code string address
IF __CPU_GBZ80__
        GLOBAL  ___mbf32_savea
        LD      (___mbf32_savea),A
        LD      HL,FPREG        ; LSB and NLSB of FPREG
        LD      A,(HL+)
        LD      H,(HL)
        LD      L,A
ELSE
        LD      HL,(FPREG)      ; LSB and NLSB of FPREG
ENDIF
        EX      (SP),HL         ; Stack them,get return
        PUSH    HL              ; Re-save return
IF __CPU_GBZ80__
        LD      HL,FPREG+2      ; MSB and exponent of FPREG
        LD      A,(HL+)
        LD      H,(HL)
        LD      L,A
        LD      A,(___mbf32_savea)
ELSE
        LD      HL,(FPREG+2)    ; MSB and exponent of FPREG
ENDIF
        EX      (SP),HL         ; Stack them,get return
        PUSH    HL              ; Re-save return
        EX      DE,HL           ; Restore code string address
        RET

IF __CPU_Z80__
PHLTFP: LD      DE,FPREG        ; Number at HL to FPREG
        LDI                     ; 4 bytes to move (HL++)->(DE++)
        LDI
        LDI
        LDI
ELSE
PHLTFP: CALL    LOADFP          ; Number at HL to BCDE
FPBCDE: 
IF __CPU_GBZ80__
        PUSH    HL              ; Save code string address
        LD      HL,FPREG
        LD      (HL),E          ; Save LSB and NLSB of number
        INC     HL
        LD      (HL),D
        INC     HL
        LD      (HL),C          ; Save MSB and exponent
        INC     HL
        LD      (hl),B
        POP     HL              ; Restore code string address
ELSE
        EX      DE,HL           ; Save code string address
        LD      (FPREG),HL      ; Save LSB and NLSB of number
        LD      HL,BC           ; Exponent and MSB of number
        LD      (FPREG+2),HL    ; Save MSB and exponent
        EX      DE,HL           ; Restore code string address
ENDIF
ENDIF
        RET

BCDEFP: LD      HL,FPREG        ; Point to FPREG
LOADFP: LD      E,(HL)          ; Get LSB of number
        INC     HL
        LD      D,(HL)          ; Get NMSB of number
        INC     HL
        LD      C,(HL)          ; Get MSB of number
        INC     HL
        LD      B,(HL)          ; Get exponent of number
INCHL:  INC     HL              ; Used for conditional "INC HL"
        RET

FPTHL:  LD      DE,FPREG        ; Point to FPREG
DETHL4: LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destination
        INC     DE              ; Next source
        INC     HL              ; Next destination
        LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destination
        INC     DE              ; Next source
        INC     HL              ; Next destination
        LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destination
        INC     DE              ; Next source
        INC     HL              ; Next destination
        LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destination
        INC     DE              ; Next source
        INC     HL              ; Next destination
        RET

SIGNS:  LD      HL,FPREG+2      ; Point to MSB of FPREG
        LD      A,(HL)          ; Get MSB
        RLCA                    ; Old sign to carry
        SCF                     ; Set MSBit
        RRA                     ; Set MSBit of MSB
        LD      (HL),A          ; Save new MSB
        CCF                     ; Complement sign
        RRA                     ; Old sign to carry
        INC     HL
        INC     HL
        LD      (HL),A          ; Set sign of result SGNRES
        LD      A,C             ; Get MSB
        RLCA                    ; Old sign to carry
        SCF                     ; Set MSBit
        RRA                     ; Set MSBit of MSB
        LD      C,A             ; Save MSB
        RRA
        XOR     (HL)            ; New sign of result
        RET

CMPNUM: LD      A,B             ; Get exponent of number
        OR      A
        JP      Z,TSTSGN        ; Zero - Test sign of FPREG
        LD      HL,RETREL       ; Return relation routine
        PUSH    HL              ; Save for return
        CALL    TSTSGN          ; Test sign of FPREG
        LD      A,C             ; Get MSB of number
        RET     Z               ; FPREG zero - Number's MSB
        LD      HL,FPREG+2      ; MSB of FPREG
        XOR     (HL)            ; Combine signs
IF __CPU_GBZ80__
        BIT     7,A             ; Get MSB of number
ENDIF
        LD      A,C             ; Get MSB of number
IF __CPU_GBZ80__
        RET     NZ              ; Exit if signs different
ELSE
        RET     M               ; Exit if signs different
ENDIF
        CALL    CMPFP           ; Compare FP numbers
        RRA                     ; Get carry to sign
        XOR     C               ; Combine with MSB of number
        RET

CMPFP:  INC     HL              ; Point to exponent
        LD      A,B             ; Get exponent
        CP      (HL)            ; Compare exponents
        RET     NZ              ; Different
        DEC     HL              ; Point to MBS
        LD      A,C             ; Get MSB
        CP      (HL)            ; Compare MSBs
        RET     NZ              ; Different
        DEC     HL              ; Point to NMSB
        LD      A,D             ; Get NMSB
        CP      (HL)            ; Compare NMSBs
        RET     NZ              ; Different
        DEC     HL              ; Point to LSB
        LD      A,E             ; Get LSB
        SUB     (HL)            ; Compare LSBs
        RET     NZ              ; Different
        POP     HL              ; Drop RETurn
        POP     HL              ; Drop another RETurn
        RET

FPINT:  LD      B,A             ; <- Move
        LD      C,A             ; <- exponent
        LD      D,A             ; <- to all
        LD      E,A             ; <- bits
        OR      A               ; Test exponent
        RET     Z               ; Zero - Return zero
        PUSH    HL              ; Save pointer to number
IF __CPU_Z80__
        LD      DE,(FPREG)      ; Move FPREG to BCDE
        LD      BC,(FPREG+2)
ELSE
        CALL    BCDEFP          ; Move FPREG to BCDE
ENDIF
        CALL    SIGNS           ; Set MSBs & sign of result
        XOR     (HL)            ; Combine with sign of FPREG
        LD      H,A             ; Save combined signs
IF __CPU_GBZ80__
        BIT     7,A
        CALL    NZ,DCBCDE       ; Negative - Decrement BCDE
ELSE
        CALL    M,DCBCDE        ; Negative - Decrement BCDE
ENDIF
        LD      A,80H+24        ; 24 bits
        SUB     B               ; Bits to shift
        CALL    SCALE           ; Shift BCDE
        LD      A,H             ; Get combined sign
        RLA                     ; Sign to carry
        CALL    C,FPROND        ; Negative - Round number up
        LD      B,0             ; Zero exponent
        CALL    C,COMPL         ; If negative make positive
        POP     HL              ; Restore pointer to number
        RET

DCBCDE: DEC     DE              ; Decrement BCDE
IF __CPU_8085__
        JP      NK,$+4          ; Exit if LSBs not FFFF
ELSE
        LD      A,D             ; Test LSBs
        AND     E
        INC     A
        RET     NZ              ; Exit if LSBs not FFFF
ENDIF
        DEC     BC              ; Decrement MSBs
        RET

INT:    LD      HL,FPEXP        ; Point to exponent
        LD      A,(HL)          ; Get exponent
        CP      80H+24          ; Integer accuracy only?
        LD      A,(FPREG)       ; Get LSB
        RET     NC              ; Yes - Already integer
        LD      A,(HL)          ; Get exponent
        CALL    FPINT           ; F.P to integer
        LD      (HL),80H+24     ; Save 24 bit integer
        LD      A,E             ; Get LSB of number
        PUSH    AF              ; Save LSB
        LD      A,C             ; Get MSB of number
        RLA                     ; Sign to carry
        CALL    CONPOS          ; Set sign of result
        POP     AF              ; Restore LSB of number
        RET

MLDEBC:                         ; Multiply DE by BC to HL
        LD      HL,0            ; Clear partial product
        LD      A,B             ; Test multiplier
        OR      C
        RET     Z               ; Return zero if zero
IF __CPU_Z80__
        LD      A,B
        LD      B,16            ; 16 bits (iterations)
ELSE
        LD      A,16            ; 16 bits (iterations)
ENDIF
MLDBLP: ADD     HL,HL           ; Shift partial product left
        JP      C,BSERR         ; ?BS Error if overflow
IF __CPU_Z80__
        SLA     C               ; Shift multiplier left
        RLA
ELIF __CPU_8085__
        RL      DE              ; Shift (rotate) multiplier left
ELSE
        EX      DE,HL
        ADD     HL,HL           ; Shift multiplier left
        EX      DE,HL
ENDIF
        JP      NC,NOMLAD       ; Bit was zero - No add
IF __CPU_Z80__
        ADD     HL,DE
        JP      C,BSERR         ; ?BS Error if overflow
NOMLAD: DJNZ    MLDBLP
ELSE
        ADD     HL,BC           ; Add multiplicand
        JP      C,BSERR         ; ?BS Error if overflow
NOMLAD: DEC     A               ; Count bits
        JP      NZ,MLDBLP       ; More
ENDIF
        RET

IF NOT_NEEDED
ASCTFP: CP      '-'             ; Negative?
        PUSH    AF              ; Save it and flags
        JP      Z,CNVNUM        ; Yes - Convert number
        CP      '+'             ; Positive?
        JP      Z,CNVNUM        ; Yes - Convert number
        DEC     HL              ; DEC 'cos GETCHR INCs
CNVNUM: CALL    RESZER          ; Set result to zero
        LD      B,A             ; Digits after point counter
        LD      D,A             ; Sign of exponent
        LD      E,A             ; Exponent of ten
        CPL
        LD      C,A             ; Before or after point flag
MANLP:  CALL    GETCHR          ; Get next character
        JP      C,ADDIG         ; Digit - Add to number
        CP      '.'
        JP      Z,DPOINT        ; "." - Flag point
        CP      'E'
        JP      NZ,CONEXP       ; Not "E" - Scale number
        CALL    GETCHR          ; Get next character
        CALL    SGNEXP          ; Get sign of exponent
EXPLP:  CALL    GETCHR          ; Get next character
        JP      C,EDIGIT        ; Digit - Add to exponent
        INC     D               ; Is sign negative?
        JP      NZ,CONEXP       ; No - Scale number
        XOR     A
        SUB     E               ; Negate exponent
        LD      E,A             ; And re-save it
        INC     C               ; Flag end of number
DPOINT: INC     C               ; Flag point passed
        JP      Z,MANLP         ; Zero - Get another digit
CONEXP: PUSH    HL              ; Save code string address
        LD      A,E             ; Get exponent
        SUB     B               ; Subtract digits after point
SCALMI: 
IF __CPU_GBZ80__
        BIT     7,A
        CALL    Z,SCALPL        ; Positive - Multiply number
        BIT     7,A
        JP      Z,ENDCON        ; Positive - All done
ELSE
        CALL    P,SCALPL        ; Positive - Multiply number
        JP      P,ENDCON        ; Positive - All done
ENDIF
        PUSH    AF              ; Save number of times to /10
        CALL    DIV10           ; Divide by 10
        POP     AF              ; Restore count
        INC     A               ; Count divides

ENDCON: JP      NZ,SCALMI       ; More to do
        POP     DE              ; Restore code string address
        POP     AF              ; Restore sign of number
        CALL    Z,INVSGN        ; Negative - Negate number
        EX      DE,HL           ; Code string address to HL
        RET

SCALPL: RET     Z               ; Exit if no scaling needed
MULTEN: PUSH    AF              ; Save count
        CALL    MLSP10          ; Multiply number by 10
        POP     AF              ; Restore count
        DEC     A               ; Count multiplies
        RET

ADDIG:  PUSH    DE              ; Save sign of exponent
        LD      D,A             ; Save digit
        LD      A,B             ; Get digits after point
        ADC     A,C             ; Add one if after point
        LD      B,A             ; Re-save counter
        PUSH    BC              ; Save point flags
        PUSH    HL              ; Save code string address
        PUSH    DE              ; Save digit
        CALL    MLSP10          ; Multiply number by 10
        POP     AF              ; Restore digit
        SUB     '0'             ; Make it absolute
        CALL    RSCALE          ; Re-scale number
        POP     HL              ; Restore code string address
        POP     BC              ; Restore point flags
        POP     DE              ; Restore sign of exponent
        JP      MANLP           ; Get another digit
ENDIF

RSCALE:
IF __CPU_GBZ80__
        CALL    STAKFP          ; Put number on stack
ELSE
        LD      HL,(FPREG)      ; LSB and NLSB of FPREG
        PUSH    HL              ; Stack them
        LD      HL,(FPREG+2)    ; MSB and exponent of FPREG
        PUSH    HL              ; Stack them
ENDIF
        CALL    FLGREL          ; Digit to add to FPREG
PADD:   POP     BC              ; Restore number
        POP     DE
        JP      FPADD           ; Add BCDE to FPREG and return

IF NOT_NEEDED
EDIGIT: LD      A,E             ; Get digit
        RLCA                    ; Times 2
        RLCA                    ; Times 4
        ADD     A,E             ; Times 5
        RLCA                    ; Times 10
        ADD     A,(HL)          ; Add next digit
        SUB     '0'             ; Make it absolute
        LD      E,A             ; Save new digit
        JP      EXPLP           ; Look for another digit

LINEIN: PUSH    HL              ; Save code string address
        LD      HL,INMSG        ; Output " in "
        CALL    PRS             ; Output string at HL
        POP     HL              ; Restore code string address
PRNTHL: EX      DE,HL           ; Code string address to DE
        XOR     A
        LD      B,80H+24        ; 24 bits
        CALL    RETINT          ; Return the integer
        LD      HL,PRNUMS       ; Print number string
        PUSH    HL              ; Save for return
NUMASC: LD      HL,PBUFF        ; Convert number to ASCII
        PUSH    HL              ; Save for return
        CALL    TSTSGN          ; Test sign of FPREG
        LD      (HL),' '        ; Space at start
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,SPCFST        ; Positive - Space to start
ELSE
        JP      P,SPCFST        ; Positive - Space to start
ENDIF
        LD      (HL),'-'        ; "-" sign at start
SPCFST: INC     HL              ; First byte of number
        LD      (HL),'0'        ; "0" if zero
        JP      Z,JSTZER        ; Return "0" if zero
        PUSH    HL              ; Save buffer address
IF __CPU_GBZ80__
        BIT     7,A
        CALL    NZ,INVSGN       ; Negate FPREG if negative
ELSE
        CALL    M,INVSGN        ; Negate FPREG if negative
ENDIF
        XOR     A               ; Zero A
        PUSH    AF              ; Save it
        CALL    RNGTST          ; Test number is in range
SIXDIG: LD      BC,9143H        ; BCDE - 99999.9
        LD      DE,4FF8H
        CALL    CMPNUM          ; Compare numbers
        OR      A
        JP      PO,INRNG        ; > 99999.9 - Sort it out
        POP     AF              ; Restore count
        CALL    MULTEN          ; Multiply by ten
        PUSH    AF              ; Re-save count
        JP      SIXDIG          ; Test it again

GTSIXD: CALL    DIV10           ; Divide by 10
        POP     AF              ; Get count
        INC     A               ; Count divides
        PUSH    AF              ; Re-save count
        CALL    RNGTST          ; Test number is in range
INRNG:  CALL    ROUND           ; Add 0.5 to FPREG
        INC     A
        CALL    FPINT           ; F.P to integer
IF _CPU_Z80__
        LD      (FPREG),DE      ; Move BCDE to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Move BCDE to FPREG
ENDIF
        LD      BC,0306H        ; 1E+06 to 1E-03 range
        POP     AF              ; Restore count
        ADD     A,C             ; 6 digits before point
        INC     A               ; Add one
IF __CPU_GBZ80__
        BIT     7,A
        JP      NZ,MAKNUM       ; Do it in "E" form if < 1E-02
ELSE
        JP      M,MAKNUM        ; Do it in "E" form if < 1E-02
ENDIF
        CP      6+1+1           ; More than 999999 ?
        JP      NC,MAKNUM       ; Yes - Do it in "E" form
        INC     A               ; Adjust for exponent
        LD      B,A             ; Exponent of number
        LD      A,2             ; Make it zero after

MAKNUM: DEC     A               ; Adjust for digits to do
        DEC     A
        POP     HL              ; Restore buffer address
        PUSH    AF              ; Save count
        LD      DE,POWERS       ; Powers of ten
        DEC     B               ; Count digits before point
        JP      NZ,DIGTXT       ; Not zero - Do number
        LD      (HL),'.'        ; Save point
        INC     HL              ; Move on
        LD      (HL),'0'        ; Save zero
        INC     HL              ; Move on
DIGTXT: DEC     B               ; Count digits before point
        LD      (HL),'.'        ; Save point in case
        CALL    Z,INCHL         ; Last digit - move on
        PUSH    BC              ; Save digits before point
        PUSH    HL              ; Save buffer address
IF __CPU_Z80__
        EX      DE,HL           ; Save powers of ten table
        LD      DE,(FPREG)      ; Move FPREG to BCDE
        LD      BC,(FPREG+2)
ELSE
        PUSH    DE              ; Save powers of ten
        CALL    BCDEFP          ; Move FPREG to BCDE
        POP     HL              ; Powers of ten table
ENDIF
        LD      B,'0'-1         ; ASCII "0" - 1
TRYAGN: INC     B               ; Count subtractions
        LD      A,E             ; Get LSB
        SUB     (HL)            ; Subtract LSB
        LD      E,A             ; Save LSB
        INC     HL
        LD      A,D             ; Get NMSB
        SBC     A,(HL)          ; Subtract NMSB
        LD      D,A             ; Save NMSB
        INC     HL
        LD      A,C             ; Get MSB
        SBC     A,(HL)          ; Subtract MSB
        LD      C,A             ; Save MSB
        DEC     HL              ; Point back to start
        DEC     HL
        JP      NC,TRYAGN       ; No overflow - Try again
        CALL    PLUCDE          ; Restore number
        INC     HL              ; Start of next number
IF __CPU_Z80__
        LD      (FPREG),DE      ; Angle to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Move BCDE to FPREG
ENDIF
        EX      DE,HL           ; Save point in table
        POP     HL              ; Restore buffer address
        LD      (HL),B          ; Save digit in buffer
        INC     HL              ; And move on
        POP     BC              ; Restore digit count
        DEC     C               ; Count digits
        JP      NZ,DIGTXT       ; More - Do them
        DEC     B               ; Any decimal part?
        JP      Z,DOEBIT        ; No - Do "E" bit
SUPTLZ: DEC     HL              ; Move back through buffer
        LD      A,(HL)          ; Get character
        CP      '0'             ; "0" character?
        JP      Z,SUPTLZ        ; Yes - Look back for more
        CP      '.'             ; A decimal point?
        CALL    NZ,INCHL        ; Move back over digit

DOEBIT: POP     AF              ; Get "E" flag
        JP      Z,NOENED        ; No "E" needed - End buffer
        LD      (HL),'E'        ; Put "E" in buffer
        INC     HL              ; And move on
        LD      (HL),'+'        ; Put '+' in buffer
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,OUTEXP
ELSE
        JP      P,OUTEXP        ; Positive - Output exponent
ENDIF
        LD      (HL),'-'        ; Put "-" in buffer
        CPL                     ; Negate exponent
        INC     A
OUTEXP: LD      B,'0'-1         ; ASCII "0" - 1
EXPTEN: INC     B               ; Count subtractions
        SUB     10              ; Tens digit
        JP      NC,EXPTEN       ; More to do
        ADD     A,'0'+10        ; Restore and make ASCII
        INC     HL              ; Move on
        LD      (HL),B          ; Save MSB of exponent
JSTZER: INC     HL              ;
        LD      (HL),A          ; Save LSB of exponent
        INC     HL
NOENED: LD      (HL),C          ; Mark end of buffer
        POP     HL              ; Restore code string address
        RET

RNGTST: LD      BC,9474H        ; BCDE = 999999.
        LD      DE,23F7H
        CALL    CMPNUM          ; Compare numbers
        OR      A
        POP     HL              ; Return address to HL
        JP      PO,GTSIXD       ; Too big - Divide by ten
        JP      (HL)            ; Otherwise return to caller
ENDIF

HALF:   DEFB    00H,00H,00H,80H ; 0.5

POWERS: DEFB    0A0H,086H,001H  ; 100000
        DEFB    010H,027H,000H  ;  10000
        DEFB    0E8H,003H,000H  ;   1000
        DEFB    064H,000H,000H  ;    100
        DEFB    00AH,000H,000H  ;     10
        DEFB    001H,000H,000H  ;      1

NEGAFT: LD      HL,INVSGN       ; Negate result
        EX      (SP),HL         ; To be done after caller
        JP      (HL)            ; Return to caller

SQR:    CALL    STAKFP          ; Put value on stack
        LD      HL,HALF         ; Set power to 1/2
IF __CPU_Z80__
        LD      DE,FPREG        ; Move 1/2 to FPREG
        LDI                     ; 4 bytes to move (HL++)->(DE++)
        LDI
        LDI
        LDI
ELSE
        CALL    PHLTFP          ; Move 1/2 to FPREG
ENDIF

POWER:  POP     BC              ; Get base from stack
        POP     DE
        CALL    TSTSGN          ; Test sign of power
IF __CPU_GBZ80__
        JP      NZ,POWER_SKIP1
ENDIF
        LD      A,B             ; Get exponent of base
        JP      Z,EXP           ; Make result 1 if zero
IF __CPU_GBZ80__
POWER_SKIP1:
        BIT     7,A
        LD      A,B             ; Get exponent of base
        JP      Z,POWER1        ; Positive base - Ok
ELSE
        JP      P,POWER1        ; Positive base - Ok
ENDIF
        OR      A               ; Zero to negative power?
        JP      Z,DZERR         ; Yes - ?/0 Error
POWER1: OR      A               ; Base zero?
        JP      Z,SAVEXP        ; Yes - Return zero
        PUSH    DE              ; Save base
        PUSH    BC
        LD      A,C             ; Get MSB of base
        OR      01111111B       ; Get sign status
IF __CPU_Z80__
        LD      DE,(FPREG)      ; Move power to BCDE
        LD      BC,(FPREG+2)
ELSE
        CALL    BCDEFP          ; Move power to BCDE
ENDIF
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,POWER2        ; Positive base - Ok
ELSE
        JP      P,POWER2        ; Positive base - Ok
ENDIF
        PUSH    DE              ; Save power
        PUSH    BC
        CALL    INT             ; Get integer of power
        POP     BC              ; Restore power
        POP     DE
        PUSH    AF              ; MSB of base
        CALL    CMPNUM          ; Power an integer?
        POP     HL              ; Restore MSB of base
        LD      A,H             ; but don't affect flags
        RRA                     ; Exponent odd or even?
POWER2: 
        POP     HL              ; Restore MSB and exponent
IF __CPU_GBZ80__
        OR      $7f             ; Restore sign back
        LD      (___mbf32_savea),a
        LD      A,L
        LD      (FPREG+2),A
        LD      A,H
        LD      (FPREG+3),A
        POP     HL
        LD      A,L
        LD      (FPREG),A
        LD      A,H
        LD      (FPREG+1),A
        LD      A,(___mbf32_savea)
ELSE
        LD      (FPREG+2),HL    ; Save base in FPREG
        POP     HL              ; LSBs of base
        LD      (FPREG),HL      ; Save in FPREG
ENDIF
        CALL    C,NEGAFT        ; Odd power - Negate result
        CALL    Z,INVSGN        ; Negative base - Negate it
        PUSH    DE              ; Save power
        PUSH    BC
        CALL    LOG             ; Get LOG of base
        POP     BC              ; Restore power
        POP     DE
        CALL    FPMULT          ; Multiply LOG by power

EXP:    CALL    STAKFP          ; Put value on stack
        LD      BC,08138H       ; BCDE = 1/Ln(2)
        LD      DE,0AA3BH
        CALL    FPMULT          ; Multiply value by 1/LN(2)
        LD      A,(FPEXP)       ; Get exponent
        CP      80H+8           ; Is it in range?
        JP      NC,OVTST1       ; No - Test for overflow
        CALL    INT             ; Get INT of FPREG
        ADD     A,80H           ; For excess 128
        ADD     A,2             ; Exponent > 126?
        JP      C,OVTST1        ; Yes - Test for overflow
        PUSH    AF              ; Save scaling factor
        LD      HL,UNITY        ; Point to 1.
        CALL    ADDPHL          ; Add 1 to FPREG
        CALL    MULLN2          ; Multiply by LN(2)
        POP     AF              ; Restore scaling factor
        POP     BC              ; Restore exponent
        POP     DE
        PUSH    AF              ; Save scaling factor
        CALL    SUBCDE          ; Subtract exponent from FPREG
        CALL    INVSGN          ; Negate result
        LD      HL,EXPTAB       ; Coefficient table
        CALL    SMSER1          ; Sum the series
        LD      DE,0            ; Zero LSBs
        POP     BC              ; Scaling factor
        LD      C,D             ; Zero MSB
        JP      FPMULT          ; Scale result to correct value

EXPTAB: DEFB    8                       ; Table used by EXP
        DEFB    040H,02EH,094H,074H     ; -1/7! (-1/5040)
        DEFB    070H,04FH,02EH,077H     ;  1/6! ( 1/720)
        DEFB    06EH,002H,088H,07AH     ; -1/5! (-1/120)
        DEFB    0E6H,0A0H,02AH,07CH     ;  1/4! ( 1/24)
        DEFB    050H,0AAH,0AAH,07EH     ; -1/3! (-1/6)
        DEFB    0FFH,0FFH,07FH,07FH     ;  1/2! ( 1/2)
        DEFB    000H,000H,080H,081H     ; -1/1! (-1/1)
        DEFB    000H,000H,000H,081H     ;  1/0! ( 1/1)

SUMSER: CALL    STAKFP          ; Put FPREG on stack
        LD      DE,MULT         ; Multiply by "X"
        PUSH    DE              ; To be done after
        PUSH    HL              ; Save address of table
IF __CPU_Z80__
        LD      DE,(FPREG)      ; Move FPREG to BCDE
        LD      BC,(FPREG+2)
ELSE
        CALL    BCDEFP          ; Move FPREG to BCDE
ENDIF
        CALL    FPMULT          ; Square the value
        POP     HL              ; Restore address of table
SMSER1: CALL    STAKFP          ; Put value on stack
        LD      A,(HL)          ; Get number of coefficients
        INC     HL              ; Point to start of table
IF __CPU_Z80_
        LD      DE,FPREG        ; Move coefficient to FPREG
        LDI                     ; 4 bytes to move (HL++)->(DE++)
        LDI
        LDI
        LDI
ELSE
        CALL    PHLTFP          ; Move coefficient to FPREG
ENDIF
        DEFB    06H             ; Skip "POP AF"
SUMLP:  POP     AF              ; Restore count
        POP     BC              ; Restore number
        POP     DE
        DEC     A               ; Cont coefficients
        RET     Z               ; All done
        PUSH    DE              ; Save number
        PUSH    BC
        PUSH    AF              ; Save count
        PUSH    HL              ; Save address in table
        CALL    FPMULT          ; Multiply FPREG by BCDE
        POP     HL              ; Restore address in table
        CALL    LOADFP          ; Number at HL to BCDE
        PUSH    HL              ; Save address in table
        CALL    FPADD           ; Add coefficient to FPREG
        POP     HL              ; Restore address in table
        JP      SUMLP           ; More coefficients

RND:    CALL    TSTSGN          ; Test sign of FPREG
        LD      HL,SEED+2       ; Random number seed
IF __CPU_GBZ80__
        BIT     7,A
        JP      NZ,RESEED       ; Negative - Re-seed
ELSE
        JP      M,RESEED        ; Negative - Re-seed
ENDIF
        LD      HL,LSTRND       ; Last random number
IF __CPU_Z80__
        LD      DE,FPREG        ; Move last RND to FPREG
        LDI                     ; 4 bytes to move (HL++)->(DE++)
        LDI
        LDI
        LDI
ELSE
        CALL    PHLTFP          ; Move last RND to FPREG
ENDIF
        LD      HL,SEED+2       ; Random number seed
        RET     Z               ; Return if RND(0)
        ADD     A,(HL)          ; Add (SEED)+2)
        AND     00000111B       ; 0 to 7
        LD      B,0
        LD      (HL),A          ; Re-save seed
        INC     HL              ; Move to coefficient table
        ADD     A,A             ; 4 bytes
        ADD     A,A             ; per entry
        LD      C,A             ; BC = Offset into table
        ADD     HL,BC           ; Point to coefficient
        CALL    LOADFP          ; Coefficient to BCDE
        CALL    FPMULT          ; Multiply FPREG by coefficient
        LD      A,(SEED+1)      ; Get (SEED+1)
        INC     A               ; Add 1
        AND     00000011B       ; 0 to 3
        LD      B,0
        CP      1               ; Is it zero?
        ADC     A,B             ; Yes - Make it 1
        LD      (SEED+1),A      ; Re-save seed
        LD      HL,RNDTAB-4     ; Addition table
        ADD     A,A             ; 4 bytes
        ADD     A,A             ; per entry
        LD      C,A             ; BC = Offset into table
        ADD     HL,BC           ; Point to value
        CALL    ADDPHL          ; Add value to FPREG
RND1:
IF __CPU_Z80__
        LD      DE,(FPREG)      ; Move FPREG to BCDE
        LD      BC,(FPREG+2)
ELSE
        CALL    BCDEFP          ; Move FPREG to BCDE
ENDIF
        LD      A,E             ; Get LSB
        LD      E,C             ; LSB = MSB
        XOR     01001111B       ; Fiddle around
        LD      C,A             ; New MSB
IF __CPU_Z80__
        LD      HL,SGNRES       ; HL is pointing to SGNRES
ENDIF
        LD      (HL),80H        ; Set saved signed bit to positive
        DEC     HL              ; Point to Exponent
        LD      B,(HL)          ; Get Exponent to BCDE
        LD      (HL),80H        ; Makes Exponent 1
        LD      HL,SEED         ; Random number seed
        INC     (HL)            ; Count seed
        LD      A,(HL)          ; Get seed
        SUB     171             ; Do it modulo 171
        JP      NZ,RND2         ; Non-zero - Ok
        LD      (HL),A          ; Zero seed
        INC     C               ; Fillde about
        DEC     D               ; with the
        INC     E               ; number
RND2:   CALL    BNORM           ; Normalise number
IF __CPU_Z80__
        LD      DE,LSTRND       ; Save random number
        LD      HL,FPREG        ; Move FPREG to last and return
        LDI                     ; 4 bytes to move (HL++)->(DE++)
        LDI
        LDI
        LDI
        RET
ELSE
        LD      HL,LSTRND       ; Save random number
        JP      FPTHL           ; Move FPREG to last and return
ENDIF

RESEED: LD      (HL),A          ; Re-seed random numbers
        DEC     HL
        LD      (HL),A
        DEC     HL
        LD      (HL),A
        JP      RND1            ; Return RND seed

RNDTAB: DEFB    068H,0B1H,046H,068H ; Table used by RND
        DEFB    099H,0E9H,092H,069H
        DEFB    010H,0D1H,075H,068H

COS:    LD      HL,HALFPI       ; Point to PI/2
        CALL    ADDPHL          ; Add it to FPREG
SIN:    CALL    STAKFP          ; Put angle on stack
        LD      BC,8349H        ; BCDE = 2 PI
        LD      DE,0FDBH
IF __CPU_Z80__
        LD      (FPREG),DE      ; Move 2 PI to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Move 2 PI to FPREG
ENDIF
        POP     BC              ; Restore angle
        POP     DE
        CALL    DVBCDE          ; Divide angle by 2 PI
        CALL    STAKFP          ; Put it on stack
        CALL    INT             ; Get INT of result
        POP     BC              ; Restore number
        POP     DE
        CALL    SUBCDE          ; Make it 0 <= value < 1
        LD      HL,QUARTR       ; Point to 0.25
        CALL    SUBPHL          ; Subtract value from 0.25
        CALL    TSTSGN          ; Test sign of value
        SCF                     ; Flag positive
IF __CPU_GBZ80__
        BIT     7,A
        JP      Z,SIN1          ; Positive - Ok
ELSE
        JP      P,SIN1          ; Positive - Ok
ENDIF
        CALL    ROUND           ; Add 0.5 to value
        CALL    TSTSGN          ; Test sign of value
        OR      A               ; Flag negative
SIN1:   PUSH    AF              ; Save sign
IF __CPU_GBZ80__
        BIT     7,A
        CALL    Z,INVSGN        ; Negate value if positive
ELSE
        CALL    P,INVSGN        ; Negate value if positive
ENDIF
        LD      HL,QUARTR       ; Point to 0.25
        CALL    ADDPHL          ; Add 0.25 to value
        POP     AF              ; Restore sign
        CALL    NC,INVSGN       ; Negative - Make positive
        LD      HL,SINTAB       ; Coefficient table
        JP      SUMSER          ; Evaluate sum of series

HALFPI: DEFB    0DBH,00FH,049H,081H     ; 1.5708 (PI/2)

QUARTR: DEFB    000H,000H,000H,07FH     ; 0.25

SINTAB: DEFB    5                       ; Table used by SIN
        DEFB    0BAH,0D7H,01EH,086H     ; 39.711
        DEFB    064H,026H,099H,087H     ;-76.575
        DEFB    058H,034H,023H,087H     ; 81.602
        DEFB    0E0H,05DH,0A5H,086H     ;-41.342
        DEFB    0DAH,00FH,049H,083H     ;  6.2832

TAN:    CALL    STAKFP          ; Put angle on stack
        CALL    SIN             ; Get SIN of angle
        POP     BC              ; Restore angle
        POP     HL
        CALL    STAKFP          ; Save SIN of angle
        EX      DE,HL           ; BCDE = Angle
IF __CPU_Z80__
        LD      (FPREG),DE      ; Angle to FPREG
        LD      (FPREG+2),BC
ELSE
        CALL    FPBCDE          ; Angle to FPREG
ENDIF
        CALL    COS             ; Get COS of angle
        JP      DIV             ; TAN = SIN / COS

ATN:    CALL    TSTSGN          ; Test sign of value
IF __CPU_GBZ80__
        BIT     7,A
        CALL    NZ,NEGAFT       ; Negate result after if -ve
        BIT     7,A
        CALL    NZ,INVSGN       ; Negate value if -ve
ELSE
        CALL    M,NEGAFT        ; Negate result after if -ve
        CALL    M,INVSGN        ; Negate value if -ve
ENDIF
        LD      A,(FPEXP)       ; Get exponent
        CP      81H             ; Number less than 1?
        JP      C,ATN1          ; Yes - Get arc tangnt
        LD      BC,8100H        ; BCDE = 1
        LD      D,C
        LD      E,C
        CALL    DVBCDE          ; Get reciprocal of number
        LD      HL,SUBPHL       ; Sub angle from PI/2
        PUSH    HL              ; Save for angle > 1
ATN1:   LD      HL,ATNTAB       ; Coefficient table
        CALL    SUMSER          ; Evaluate sum of series
        LD      HL,HALFPI       ; PI/2 - angle in case > 1
ARET:
        RET                     ; Number > 1 - Sub from PI/2

ATNTAB: DEFB    9                       ; Table used by ATN
        DEFB    04AH,0D7H,03BH,078H     ; 1/17
        DEFB    002H,06EH,084H,07BH     ;-1/15
        DEFB    0FEH,0C1H,02FH,07CH     ; 1/13
        DEFB    074H,031H,09AH,07DH     ;-1/11
        DEFB    084H,03DH,05AH,07DH     ; 1/9
        DEFB    0C8H,07FH,091H,07EH     ;-1/7
        DEFB    0E4H,0BBH,04CH,07EH     ; 1/5
        DEFB    06CH,0AAH,0AAH,07FH     ;-1/3
        DEFB    000H,000H,000H,081H     ; 1/1
