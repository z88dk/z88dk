;       name...
;               float
;
;       purpose...
;               floating point routines for C programs
;
;       note...
;               This code uses some of the Z-80's UNDOCUMENTED 
;       INSTRUCTIONS. The instructions work because the IX and
;       IY escape bytes are actually a bit more general than
;       Zilog advertises. Note that in the instructions
;               E1      POP HL
;               DD E1   POP IX
;               FD E1   POP IY
;       (which Zilog documents), the opcodes for the IX and IY
;       registers are the same as for the HL register, but are
;       preceded by the escape bytes DD and FD. Similarly,
;               6A      LD L,D
;               DD 6A   LD XL,D         undocumented
;               FD 6A   LD YL,D         undocumented
;       where the new instructions deal with the lower half
;       of the IX and IY registers, respectively. All of the
;       single-byte transfers, and single byte operations such
;       as ADD and INC, involving the H or L registers, can be
;       preceded by escape bytes in this fashion.
;
;       history...
;               The floating point arithmetic routines were
;               written by Neil Colvin and were included in
;               Xitan Disk Basic.  He has consented to release
;               them to the public domain for individual use
;               but not for sale. Disassembly, comments, ifix(),
;               float(), and the interface to c programs were by
;               James R. Van Zandt.
;
;
;       double float(), /* integer to floating point conversion */
;       mod(),          /* mod(x,y) */
;       fabs(),         /* absolute value */
;       floor(),        /* largest integer not greater than */
;       ceil(),         /* smallest integer not less than */
;       rand();         /* random number in range 0...1 */
;       int seed();     /* seed random number generator */
;       int ifix();     /* floating point to integer
;                       (takes floor first) */
;



;Definitions for Z80asm to get the grips with!

        XDEF  DADD
        XDEF  DDIV
        XDEF  DGE
        XDEF  DIV1
        XDEF  DIV17
        XDEF  DMUL
        XDEF  DSWAP
        XDEF  DSUB
        XDEF  DEQ
        XDEF  DGT
        XDEF  DLEq      ;djm 7/10/98
        XDEF  DLT
        XDEF  DNE
        XDEF  FADD
        XDEF  FDIV
        XDEF  FMUL
        XDEF  FSUB
;        XDEF  GRIPE   
        XDEF  PUSHF2
        XDEF  LDBCFA
        XDEF  LDBCHL
        XDEF  LDFABC
        LIB   MINUSFA
        XDEF  NORMA
        LIB  ODD

        XDEF  PUSHFA
        XDEF  SGN
;        XDEF  OFLOW
        XDEF  NORM
        XDEF  COMPARE
        XDEF  INT2
        XDEF  PI
        XDEF  HALFPI






;
.FSUB   CALL    MINUSFA
        JR      FADD
;
;       subtract the floating point accumulator from the value
;       on the stack (under the return address), leave result
;       in the floating point accumulator.
;
.DSUB   CALL    MINUSFA
;
;       add the value on the stack (under the return address)
;       to the floating point accumulator
;
.DADD   POP     HL      ;save return address
        POP     DE
        POP     IX
        POP     BC
        PUSH    HL      ;replace return address
;
;       add bc ix de to floating point accumulator
;
.FADD   LD      A,B
        OR      A
        RET     Z       ;z => number to be added is zero
        LD      A,(FA+5)
        OR      A
        JP      Z,LDFABC ;z => accumulator is zero,
;                               just load number
        SUB     B
        JR      NC,ADD2 ;nc => accumulator has larger number
        NEG             ;reverse accumulator & bc ix de...
        EXX
        PUSH    IX
        CALL    LDBCFA
        EXX
        EX      (SP),IX
        CALL    LDFABC
        EXX
        POP     IX      ;...end of reversing
.ADD2   CP      $29
        RET     NC      ;nc => addition makes no change
        PUSH    AF      ;save difference of exponents
        CALL    UNPACK  ;restore hidden bit & compare signs
        LD      H,A     ;save difference in signs
        POP     AF      ;recall difference of exponents
        CALL    RSHIFT  ;shift  c ix de b  right by (a)
        OR      H
        LD      HL,FA
        JP      P,ADD4  ;p => opposite signs, must subtract
        CALL    FRADD   ;c ix de += FA
        JR      NC,PACK ;nc => adding caused no carry
        INC     HL
        INC     (HL)    ;increment exponent
        ret     z
;        JP      Z,OFLOW
        LD      L,1
        CALL    RSH8    ;shift  c ix de b  right by 1
        JR      PACK    ;round, hide msb, & load into FA
;
.ADD4   XOR     A       ;negate b...
        SUB     B
        LD      B,A
        LD      A,(HL)  ;c ix de -= FA...
        SBC     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        SBC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        SBC     A,L
        DEFB    $DD
        LD      L,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        SBC     A,H
        DEFB    $DD
        LD      H,A
        INC     HL
        LD      A,(HL)
        SBC     A,C
        LD      C,A     ;...end of subtraction, fall into...
;
;       reverse sign if necessary (cy set) and normalize
;       (sign reversal necessary because we're using
;       sign-magnitude representation rather than
;       twos-complement)
;
.NORMA  CALL    C,MINUSBC
;
;       normalize the 48 bit number in c ix de b
;       current exponent is in FA+5
;
;       result loaded into FA
;
.NORM   LD      L,B
        LD      H,E
        XOR     A
.NORM2  LD      B,A
        LD      A,C
        OR      A
        JR      NZ,NORM12  ;nz => 7 or fewer shifts needed
;                       shift c ix d hl  left by one byte
        DEFB    $DD
        LD      C,H
        DEFB    $DD
        LD      A,L
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      L,D
        XOR     A
        LD      D,H
        LD      H,L
        LD      L,A     ;...end of shifting
;
        LD      A,B
        SUB     8       ;adjust exponent
        CP      $D0
        JR      NZ,NORM2
;
.NORM4  XOR     A
.NORM6  LD      (FA+5),A
        RET
;
.NORM8  DEC     B
;                       shift  c ix d hl  left one bit...
        ADD     HL,HL
        RL      D
        EX      AF,AF'
        ADD     IX,IX
        EX      AF,AF'
        JR      NC,NORM10
        INC     IX
.NORM10 EX      AF,AF'
        RL      C       ;...end of shifting
;
.NORM12 JP      P,NORM8 ;p => high order bit still zero
        LD      A,B
;                       move number to  c ix de b
        LD      E,H
        LD      B,L
        OR      A
        JR      Z,PACK  ;z => exponent unchanged
        LD      HL,FA+5         ;update exponent
        ADD     A,(HL)
        LD      (HL),A
        JR      NC,NORM4        ;nc => underflow (set to 0)
        RET     Z               ;z => underflow (leave as 0)
;
.PACK   LD      A,B
.PACK2  LD      HL,FA+5 ;round c ix de b to 40 bits
        OR      A
        CALL    M,INCR
        LD      B,(HL)  ;load exponent
        INC     HL
        LD      A,(HL)  ;recover sign
        AND     $80     ;mask out all but sign
        XOR     C       ;add to high
        LD      C,A     ;   order byte
        JP      LDFABC  ;place answer in FA
;
.INCR   INC     E       ;increment c ix de
        RET     NZ
        INC     D
        RET     NZ
        DEFB    $DD
        INC     L
        RET     NZ
        DEFB    $DD
        INC     H
        RET     NZ
        INC     C
        RET     NZ      ;z => carry
        LD      C,$80   ;set high order bit
        INC     (HL)    ;   and increment exponent
        RET     NZ
        ret
;        JP      OFLOW
;
;       fraction add c ix de += (hl)
;
.FRADD  LD      A,(HL)
        ADD     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        ADC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        ADC     A,L
        DEFB    $DD
        LD      L,A
        INC     HL
        LD      A,(HL)
        DEFB    $DD
        ADC     A,H
        DEFB    $DD
        LD      H,A
        INC     HL
        LD      A,(HL)
        ADC     A,C
        LD      C,A
        RET
;
;       complement FASIGN and negate the fraction c ix de b
;
.MINUSBC LD     HL,FASIGN
        LD      A,(HL)
        CPL
        LD      (HL),A
        XOR     A
        LD      L,A
        LD      H,A
        SUB     B
        LD      B,A
        LD      A,L
        SBC     HL,DE
        EX      DE,HL
        LD      L,A
        DEFB    $DD
        SBC     A,L
        DEFB    $DD
        LD      L,A
        LD      A,L
        DEFB    $DD
        SBC     A,H
        DEFB    $DD
        LD      H,A
        LD      A,L
        SBC     A,C
        LD      C,A
        RET
;
;       shift  c ix de b  right by (a)
;
.RSHIFT LD      B,0
.RSH2   SUB     8
        JR      C,RSH4  ;c => 7 or fewer shifts remain
        LD      B,E     ;shift  c ix de b  right by 8...
        LD      E,D
        DEFB    $DD
        LD      D,L
        EX      AF,AF'
        DEFB    $DD
        LD      A,H
        DEFB    $DD
        LD      L,A
        EX      AF,AF'
        DEFB    $DD
        LD      H,C
        LD      C,0     ;...end of shifting
        JR      RSH2
;
.RSH4   ADD     A,9
        LD      L,A
.RSH6   XOR     A
        DEC     L
        RET     Z       ;z => requested shift is complete
        LD      A,C
.RSH8   RRA             ;shift  c ix de b  right by one...
        LD      C,A
        DEFB    $DD
        LD      A,H
        RRA
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      A,L
        RRA
        DEFB    $DD
        LD      L,A
        RR      D
        RR      E
        RR      B       ;...end of shifting
        JR      RSH6
;
;       multiply the floating point accumulator by the value
;       on the stack (under the return address), leave result
;       in the floating point accumulator.
;
.DMUL   POP     HL      ;return addr
        POP     DE      ;multiplier...
        POP     IX
        POP     BC
        PUSH    HL      ;replace return addr
;
;       multiply floating point accumulator by  bc ix de
;
.FMUL   CALL    SGN
        RET     Z       ; z => accumulator has zero
        LD      L,0     ;"product" flag
        CALL    DIV14   ;find exponent of product
        LD      A,C  ;c' h'l' d'e' (multiplicand) = c ix de...
        PUSH    DE
        EXX
        LD      C,A
        POP     DE
        PUSH    IX
        POP     HL
        EXX             ;...end of multiplicand loading
        LD      BC,0    ; c ix de b (product) = 0...
        LD      D,B
        LD      E,B
        LD      IX,0
        LD      HL,NORM ; push addr of normalize routine
        PUSH    HL
        LD      HL,MULLOOP      ; push addr of top of loop
        PUSH    HL      ; (5 iterations wanted,
        PUSH    HL      ; once per byte of fraction)
        PUSH    HL
        PUSH    HL
        LD      HL,FA   ;point to LSB
.MULLOOP LD     A,(HL)  ;get next byte of multiplier
        INC     HL
        OR      A
        JR      NZ,MUL2 ; z => next 8 bits of multiplier are 0
        LD      B,E     ;shift  c ix de b  right by 8...
        LD      E,D
        DEFB    $DD
        LD      D,L
        EX      AF,AF'
        DEFB    $DD
        LD      A,H
        DEFB    $DD
        LD      L,A
        EX      AF,AF'
        DEFB    $DD
        LD      H,C
        LD      C,A     ;...end of shifting
        RET             ;go to top of loop or NORM
;
.MUL2   PUSH    HL      ;save multiplier pointer
        EX      DE,HL
        LD      E,8     ;8 iterations (once per bit)
.MUL4   RRA             ;rotate a multiplier bit into cy
        LD      D,A
        LD      A,C
        JR      NC,MUL6 ; nc => no addition needed
        PUSH    HL      ; c ix hl (product)  +=
        EXX             ;       c' h'l' d'e' (multiplicand)
        EX      (SP),HL
        ADD     HL,DE
        EX      (SP),HL
        EX      DE,HL
        PUSH    IX
        EX      (SP),HL
        ADC     HL,DE
        EX      (SP),HL
        POP     IX
        EX      DE,HL
        ADC     A,C
        EXX
        POP     HL
;
.MUL6   RRA        ;shift  c ix hl b (product)  right by 1...
        LD      C,A
        DEFB    $DD
        LD      A,H
        RRA
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      A,L
        RRA
        DEFB    $DD
        LD      L,A
        RR      H
        RR      L
        RR      B               ;...end of shifting
        DEC     E
        LD      A,D
        JR      NZ,MUL4         ; z => 8 iterations complete
        EX      DE,HL
.MUL8   POP     HL              ;recover multiplier pointer
        RET                     ;go to top of loop or NORM
;
.DIV1   POP     BC
        POP     IX
        POP     DE
        JR      FDIV
;
;       divide the value on the stack (under the return
;       address) by the floating point accumulator, leave
;       result in the floating point accumulator.
;
.DDIV   POP     HL      ;save return address
        POP     DE
        POP     IX
        POP     BC
        PUSH    HL      ;replace return address
;
;       divide  bc ix de  by FA, leave result in FA
;
.FDIV   CALL    SGN
        ret     z
;        JP      Z,DIVZERO ; z => attempting to divide by 0
        LD      L,$FF  ;"quotient" flag
        CALL    DIV14   ;find quotient exponent
        PUSH    IY
        INC     (HL)
        INC     (HL)
        DEC     HL
        PUSH    HL      ; c' h'l' d'e' (divisor) = FA...
        EXX
        POP     HL
        LD      C,(HL)
        DEC     HL
        LD      D,(HL)
        DEC     HL
        LD      E,(HL)
        DEC     HL
        LD      A,(HL)
        DEC     HL
        LD      L,(HL)
        LD      H,A
        EX      DE,HL
        EXX
        LD      B,C     ; b iy hl (dividend) = c ix de...
        EX      DE,HL
        PUSH    IX
        POP     IY
        XOR     A       ; c ix de (quotient) = 0...
        LD      C,A
        LD      D,A
        LD      E,A
        LD      IX,0
        LD      (EXTRA),A
.DIV2   PUSH    HL      ;save b iy hl in case the subtraction
        PUSH    IY      ; proves to be unnecessary
        PUSH    BC
        PUSH    HL      ; EXTRA b iy hl (dividend)  -=
        LD      A,B     ;       c' h'l' d'e' (divisor)...
        EXX
        EX      (SP),HL
        OR      A
        SBC     HL,DE
        EX      (SP),HL
        EX      DE,HL
        PUSH    IY
        EX      (SP),HL
        SBC     HL,DE
        EX      (SP),HL
        POP     IY
        EX      DE,HL
        SBC     A,C
        EXX
        POP     HL
        LD      B,A
        LD      A,(EXTRA)
        SBC     A,0
        CCF
        JR      NC,DIV4 ; nc => subtraction caused carry
        LD      (EXTRA),A
        POP     AF      ;discard saved value of dividend...
        POP     AF
        POP     AF
        SCF
        JR      DIV6
.DIV4   POP     BC      ;restore dividend...
        POP     IY
        POP     HL
;
.DIV6   INC     C
        DEC     C
        RRA
        JP      M,DIV12
        RLA       ;shift  c ix de a (quotient)  left by 1...
        RL      E
        RL      D
        EX      AF,AF'  ;(these 6 lines are  adc ix,ix...)
        ADD     IX,IX
        EX      AF,AF'
        JR      NC,DIV8
        INC     IX
.DIV8   EX      AF,AF'
        RL      C       ;...end of  c ix de a  shifting
        ADD     HL,HL   ;shift  EXTRA b iy hl  left by 1...
        EX      AF,AF'
        ADD     IY,IY
        EX      AF,AF'
        JR      NC,DIV9
        INC     IY
.DIV9   EX      AF,AF'
        RL      B
        LD      A,(EXTRA)
        RLA
        LD      (EXTRA),A  ;...end of  EXTRA b iy hl  shifting
        LD      A,C     ;test  c ix de...
        OR      D
        OR      E
        DEFB    $DD
        OR      H
        DEFB    $DD
        OR      L       ;...end of  c ix de  testing
        JR      NZ,DIV2 ;nz => dividend nonzero
        PUSH    HL
        LD      HL,FA+5
        DEC     (HL)
        POP     HL
        JR      NZ,DIV2
        ret
;        JR      OFLOW2
;
.DIV12  POP     IY
        JP      PACK2
;
;       find exponent for product (L=0) or quotient (L=ff)
;
.DIV14  LD      A,B
        OR      A
        JR      Z,DIV20
        LD      A,L     ;get product/quotient flag
        LD      HL,FA+5
        XOR     (HL)    ;get +-FA exponent
        ADD     A,B     ;find and...
        LD      B,A     ;...load new exponent
        RRA
        XOR     B
        LD      A,B
        JP      P,DIV18
        ADD     A,$80
        LD      (HL),A
        JP      Z,MUL8
        CALL    UNPACK  ;restore hidden bits & compare signs
        LD      (HL),A  ;save difference of signs
        DEC     HL      ;point to MSB of fraction
        RET
;
.DIV17  CALL    SGN
        CPL
        OR      A
        DEFB    $21     ;"ignore next 2 bytes"
.DIV18  OR      A
.DIV20  POP     HL
        JP      P,NORM4
        ret
;.OFLOW2 JP      OFLOW
;
;       set z & s flags per FA
;

.SGN    LD      A,(FA+5)
        OR      A
        RET     Z
        LD      A,(FA+4)
        DEFB    $FE    ;"ignore next byte"
.SETFLGS
        CPL
        RLA
        SBC     A,A
        RET     NZ
        INC     A
        RET
;
;       Double precision comparisons
;
;       each compares top of stack
;       (under two return addresses) to FA
;
;TOS >= FA?
.DGE    CALL    DCOMPAR
        JR      Z,YES   ;z => equal
        JR      DG      ;remaining tests are shared
;
;TOS > FA?
.DGT    CALL    DCOMPAR
        JR      Z,NO    ;z => equal
.DG     JP      P,NO    ;p => not greater than
.YES    LD      HL,1    ;load "true"
        scf
        RET
;
;TOS <= FA?
.DLEq   CALL    DCOMPAR
        JR      Z,YES
        JR      DL
;
;TOS < FA?
.DLT    CALL    DCOMPAR
        JR      Z,NO
.DL     JP      P,YES   ;p => less than
.NO     LD      HL,0    ;load "false"
        and     a
        RET
;
;TOS == FA?
.DEQ    CALL    DCOMPAR
        JR      Z,YES
        JR      NO
;
;TOS != FA?
.DNE    CALL    DCOMPAR
        JR      NZ,YES
        JR      NO
;
;common routine to perform double precision comparisons
.DCOMPAR POP    HL      ;save 1st return addr
        POP     IY      ;save 2nd return addr
        POP     DE      ;get number to compare
        POP     IX
        POP     BC
        PUSH    IY      ;replace 2nd addr
        PUSH    HL      ;replace 1st addr, fall into...
;
;       sets flags per FA - (bc ix de)
;
.COMPARE LD     A,B
        OR      A
        JR      Z,SGN           ;bc ix de = 0, so
;                               sign of FA is result

        CALL    SGN
        LD      A,C
        JR      Z,SETFLGS       ;FA = 0, so sign of
;                               -(bc ix de) is result
        LD      HL,FA+4
        XOR     (HL)
        LD      A,C
        JP      M,SETFLGS       ;operands have opposite
;                               signs, so result is sign
;                               of -(bc ix de)

        CALL    CPFRAC
        RRA                     ;recover cy bit
        XOR     C       ;reverse sign if numbers are negative
        JR      SETFLGS
;
.CPFRAC INC     HL      ;compare  bc ix de  to (HL)
        LD      A,B
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,C
        CP      (HL)
        RET     NZ
        DEC     HL
        DEFB    $DD
        LD      A,H
        CP      (HL)
        RET     NZ
        DEC     HL
        DEFB    $DD
        LD      A,L
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,D
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,E
        SUB     (HL)
        RET     NZ
        POP     HL      ;return zero to program
        RET             ;that called "COMPARE"

;
.PUSHFA EX      DE,HL
.PUSHF2 LD      HL,(FA)
        EX      (SP),HL
        PUSH    HL
        LD      HL,(FA+2)
        EX      (SP),HL
        PUSH    HL
        LD      HL,(FA+4)
        EX      (SP),HL
        PUSH    HL
        EX      DE,HL
        RET
;
; Useful constants in C, pi and pi/2
;
.PI    DEFW    $A222  ;3.1415926535 = pi
        DEFW    $0FDA
        DEFW    $8249
.HALFPI        
        DEFB      $22,$A2,$DA,$0F,$49,$81 ; pi/2
;
;       exchange floating point accumulator with
;       top of stack (under return address)
;
.DSWAP  POP     HL      ;return addr
        POP     DE
        POP     IX
        POP     BC
        EXX             ;protect the values
        CALL    DPUSH   ;push FA
        EXX             ;recover the values
        PUSH    HL      ;replace return addr, fall into...
;
;       FA = bc ix de
;
.LDFABC LD      (FA),DE
        LD      (FA+2),IX
        LD      (FA+4),BC
        RET
;
;       bc ix de = FA
;
.LDBCFA LD      DE,(FA)
        LD      IX,(FA+2)
        LD      BC,(FA+4)
        RET
;
;       bc ix de = (hl)
;
.LDBCHL LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      C,(HL)
        DEFB    $DD
        LD      L,C
        INC     HL
        LD      C,(HL)
        DEFB    $DD
        LD      H,C
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
        RET

;
.UNPACK LD      HL,FA+4
        LD      A,(HL)  ;get MSB of fraction
        RLCA            ;rotate sign bit into lsb
        SCF             ;set carry
        RRA             ;rotate sign bit into cy, cy into msb
        LD      (HL),A  ;restore MSB (with hidden bit restored)
        CCF             ;complement sign bit...
        RRA
        INC     HL
        INC     HL
        LD      (HL),A  ;...and save in msb of FASIGN
        LD      A,C     ;similarly, get sign bit of bc ix de...
        RLCA
        SCF
        RRA
        LD      C,A     ;...restore hidden bit...
        RRA
        XOR     (HL)    ;...and compare with sign of FA.
        RET
;
.INT2   LD      B,A     ;if a==0, return with  bc ix de = 0...
        LD      C,A
        LD      D,A
        LD      E,A
        DEFB    $DD
        LD      H,A
        DEFB    $DD
        LD      L,A
        OR      A
        RET     Z
        PUSH    HL
        CALL    LDBCFA  ;copy FA into bc ix de,
        CALL    UNPACK  ; restore hidden bits
        XOR     (HL)
        LD      H,A     ;put sign in msb of h
        JP      P,INT4 ;p => positive number
        DEC     DE      ;decrement c ix de...
        LD      A,D
        AND     E
        INC     A
        JR      NZ,INT4
        DEC     IX
        DEFB    $DD
        LD      A,H
        DEFB    $DD
        AND     L
        INC     A
        JR      NZ,INT4
        DEC     C       ;...end of c ix de decrementing
;
.INT4   LD      A,$A8  ;shift  c ix de  right so bits to
        SUB     B       ; the right of the binary point
        CALL    RSHIFT  ; are discarded
        LD      A,H
        RLA
        CALL    C,INCR  ;c => negative, increment  c ix de
        LD      B,0
        CALL    C,MINUSBC ;negate the fraction c ix de
        POP     HL
        RET

