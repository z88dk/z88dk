;*********************************
;** Part 9. ARITHMETIC ROUTINES **
;*********************************

        PUBLIC L2D4F
        PUBLIC L2D7F
        PUBLIC L2D8E
        PUBLIC L2DA2
        PUBLIC L2DD5
        PUBLIC L2DE3
        PUBLIC L300F
        PUBLIC L3014
        PUBLIC L30A9
        PUBLIC L30CA
        PUBLIC L31AD
        PUBLIC L31AF
        PUBLIC L3214
        PUBLIC L3297

        EXTERN L15EF
        EXTERN L1A1B
        EXTERN L2AB6
        EXTERN L346E
        EXTERN L34E9
        EXTERN L350B

; --------------------------
; E-format to floating point
; --------------------------
; This subroutine is used by the PRINT-FP routine and the decimal to FP
; routines to stack a number expressed in exponent format.
; Note. Though not used by the ROM as such, it has also been set up as
; a unary calculator literal but this will not work as the accumulator
; is not available from within the calculator.

; on entry there is a value x on the calculator stack and an exponent of ten
; in A.    The required value is x + 10 ^ A

;; e-to-fp
;; E-TO-FP
L2D4F:  RLCA                    ; this will set the          x.
        RRCA                    ; carry if bit 7 is set

        JR      NC,L2D55        ; to E-SAVE  if positive.

        CPL                     ; make negative positive
        INC     A               ; without altering carry.

;; E-SAVE
L2D55:  PUSH    AF              ; save positive exp and sign in carry

        LD      HL,$5C92        ; address MEM-0

        CALL    L350B           ; routine FP-0/1
                                ; places an integer zero, if no carry,
                                ; else a one in mem-0 as a sign flag

        RST     28H             ;; FP-CALC
        DEFB    $A4             ;;stk-ten                    x, 10.
        DEFB    $38             ;;end-calc

        POP     AF              ; pop the exponent.

; now enter a loop

;; E-LOOP
L2D60:  SRL     A               ; 0>76543210>C

        JR      NC,L2D71        ; forward to E-TST-END if no bit

        PUSH    AF              ; save shifted exponent.

        RST     28H             ;; FP-CALC
        DEFB    $C1             ;;st-mem-1                   x, 10.
        DEFB    $E0             ;;get-mem-0                  x, 10, (0/1).
        DEFB    $00             ;;jump-true

        DEFB    $04             ;;to L2D6D, E-DIVSN

        DEFB    $04             ;;multiply                   x*10.
        DEFB    $33             ;;jump

        DEFB    $02             ;;to L2D6E, E-FETCH

;; E-DIVSN
L2D6D:  DEFB    $05             ;;division                   x/10.

;; E-FETCH
L2D6E:  DEFB    $E1             ;;get-mem-1                  x/10 or x*10, 10.
        DEFB    $38             ;;end-calc                   new x, 10.

        POP     AF              ; restore shifted exponent

; the loop branched to here with no carry

;; E-TST-END
L2D71:  JR      Z,L2D7B         ; forward to E-END  if A emptied of bits

        PUSH    AF              ; re-save shifted exponent

        RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate                  new x, 10, 10.
        DEFB    $04             ;;multiply                   new x, 100.
        DEFB    $38             ;;end-calc

        POP     AF              ; restore shifted exponent
        JR      L2D60           ; back to E-LOOP  until all bits done.

; ---

; although only the first pass is shown it can be seen that for each set bit
; representing a power of two, x is multiplied or divided by the
; corresponding power of ten.

;; E-END
L2D7B:  RST     28H             ;; FP-CALC                   final x, factor.
        DEFB    $02             ;;delete                     final x.
        DEFB    $38             ;;end-calc                   x.

        RET                     ; return




; -------------
; Fetch integer
; -------------
; This routine is called by the mathematical routines - FP-TO-BC, PRINT-FP,
; mult, re-stack and negate to fetch an integer from address HL.
; HL points to the stack or a location in MEM and no deletion occurs.
; If the number is negative then a similar process to that used in INT-STORE
; is used to restore the twos complement number to normal in DE and a sign
; in C.

;; INT-FETCH
L2D7F:  INC     HL              ; skip zero indicator.
        LD      C,(HL)          ; fetch sign to C
        INC     HL              ; address low byte
        LD      A,(HL)          ; fetch to A
        XOR     C               ; two's complement
        SUB     C               ;
        LD      E,A             ; place in E
        INC     HL              ; address high byte
        LD      A,(HL)          ; fetch to A
        ADC     A,C             ; two's complement
        XOR     C               ;
        LD      D,A             ; place in D
        RET                     ; return

; ------------------------
; Store a positive integer
; ------------------------
; This entry point is not used in this ROM but would
; store any integer as positive.

;; p-int-sto
L2D8C:  LD      C,$00           ; make sign byte positive and continue

; -------------
; Store integer
; -------------
; this routine stores an integer in DE at address HL.
; It is called from mult, truncate, negate and sgn.
; The sign byte $00 +ve or $FF -ve is in C.
; If negative, the number is stored in 2's complement form so that it is
; ready to be added.

;; INT-STORE
L2D8E:  PUSH    HL              ; preserve HL

        LD      (HL),$00        ; first byte zero shows integer not exponent
        INC     HL              ;
        LD      (HL),C          ; then store the sign byte
        INC     HL              ;
                                ; e.g.             +1             -1
        LD      A,E             ; fetch low byte   00000001       00000001
        XOR     C               ; xor sign         00000000   or  11111111
                                ; gives            00000001   or  11111110
        SUB     C               ; sub sign         00000000   or  11111111
                                ; gives            00000001>0 or  11111111>C
        LD      (HL),A          ; store 2's complement.
        INC     HL              ;
        LD      A,D             ; high byte        00000000       00000000
        ADC     A,C             ; sign             00000000<0     11111111<C
                                ; gives            00000000   or  00000000
        XOR     C               ; xor sign         00000000       11111111
        LD      (HL),A          ; store 2's complement.
        INC     HL              ;
        LD      (HL),$00        ; last byte always zero for integers.
                                ; is not used and need not be looked at when
                                ; testing for zero but comes into play should
                                ; an integer be converted to fp.
        POP     HL              ; restore HL
        RET                     ; return.


; -----------------------------
; Floating point to BC register
; -----------------------------
; This routine gets a floating point number e.g. 127.4 from the calculator
; stack to the BC register.

;; FP-TO-BC
L2DA2:  RST     28H             ;; FP-CALC            set HL to
        DEFB    $38             ;;end-calc            point to last value.

        LD      A,(HL)          ; get first of 5 bytes
        AND     A               ; and test
        JR      Z,L2DAD         ; forward to FP-DELETE if an integer

; The value is first rounded up and then converted to integer.

        RST     28H             ;; FP-CALC           x.
        DEFB    $A2             ;;stk-half           x. 1/2.
        DEFB    $0F             ;;addition           x + 1/2.
        DEFB    $27             ;;int                int(x + .5)
        DEFB    $38             ;;end-calc

; now delete but leave HL pointing at integer

;; FP-DELETE
L2DAD:  RST     28H             ;; FP-CALC
        DEFB    $02             ;;delete
        DEFB    $38             ;;end-calc

        PUSH    HL              ; save pointer.
        PUSH    DE              ; and STKEND.
        EX      DE,HL           ; make HL point to exponent/zero indicator
        LD      B,(HL)          ; indicator to B
        CALL    L2D7F           ; routine INT-FETCH
                                ; gets int in DE sign byte to C
                                ; but meaningless values if a large integer

        XOR     A               ; clear A
        SUB     B               ; subtract indicator byte setting carry
                                ; if not a small integer.

        BIT     7,C             ; test a bit of the sign byte setting zero
                                ; if positive.

        LD      B,D             ; transfer int
        LD      C,E             ; to BC
        LD      A,E             ; low byte to A as a useful return value.

        POP     DE              ; pop STKEND
        POP     HL              ; and pointer to last value
        RET                     ; return
                                ; if carry is set then the number was too big.

; ------------
; LOG(2^A)
; ------------
; This routine is used when printing floating point numbers to calculate
; the number of digits before the decimal point.

; first convert a one-byte signed integer to its five byte form.

;; LOG(2^A)
L2DC1:  LD      D,A             ; store a copy of A in D.
        RLA                     ; test sign bit of A.
        SBC     A,A             ; now $FF if negative or $00
        LD      E,A             ; sign byte to E.
        LD      C,A             ; and to C
        XOR     A               ; clear A
        LD      B,A             ; and B.
        CALL    L2AB6           ; routine STK-STORE stacks number AEDCB

;  so 00 00 XX 00 00 (positive) or 00 FF XX FF 00 (negative).
;  i.e. integer indicator, sign byte, low, high, unused.

; now multiply exponent by log to the base 10 of two.

        RST      28H            ;; FP-CALC

        DEFB    $34             ;;stk-data                      .30103 (log 2)
        DEFB    $EF             ;;Exponent: $7F, Bytes: 4
        DEFB    $1A,$20,$9A,$85 ;;
        DEFB    $04             ;;multiply

        DEFB    $27             ;;int

        DEFB    $38             ;;end-calc

; -------------------
; Floating point to A
; -------------------
; this routine collects a floating point number from the stack into the
; accumulator returning carry set if not in range 0 - 255.
; Not all the calling routines raise an error with overflow so no attempt
; is made to produce an error report here.

;; FP-TO-A
L2DD5:  CALL    L2DA2           ; routine FP-TO-BC returns with C in A also.
        RET     C               ; return with carry set if > 65535, overflow

        PUSH    AF              ; save the value and flags
        DEC     B               ; and test that
        INC     B               ; the high byte is zero.
        JR      Z,L2DE1         ; forward  FP-A-END if zero

; else there has been 8-bit overflow

        POP     AF              ; retrieve the value
        SCF                     ; set carry flag to show overflow
        RET                     ; and return.

; ---

;; FP-A-END
L2DE1:  POP     AF              ; restore value and success flag and
        RET                     ; return.


; -----------------------------
; Print a floating point number
; -----------------------------
; Not a trivial task.
; Begin by considering whether to print a leading sign for negative numbers.

;; PRINT-FP
L2DE3:  RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate
        DEFB    $36             ;;less-0
        DEFB    $00             ;;jump-true

        DEFB    $0B             ;;to L2DF2, PF-NEGTVE

        DEFB    $31             ;;duplicate
        DEFB    $37             ;;greater-0
        DEFB    $00             ;;jump-true

        DEFB    $0D             ;;to L2DF8, PF-POSTVE

; must be zero itself

        DEFB    $02             ;;delete
        DEFB    $38             ;;end-calc

        LD      A,$30           ; prepare the character '0'

        RST     10H             ; PRINT-A
        RET                     ; return.                 ->
; ---

;; PF-NEGTVE
L2DF2:  DEFB    $2A             ;;abs
        DEFB    $38             ;;end-calc

        LD      A,$2D           ; the character '-'

        RST     10H             ; PRINT-A

; and continue to print the now positive number.

        RST     28H             ;; FP-CALC

;; PF-POSTVE
L2DF8:  DEFB    $A0             ;;stk-zero     x,0.     begin by
        DEFB    $C3             ;;st-mem-3     x,0.     clearing a temporary
        DEFB    $C4             ;;st-mem-4     x,0.     output buffer to
        DEFB    $C5             ;;st-mem-5     x,0.     fifteen zeros.
        DEFB    $02             ;;delete       x.
        DEFB    $38             ;;end-calc     x.

        EXX                     ; in case called from 'str$' then save the
        PUSH    HL              ; pointer to whatever comes after
        EXX                     ; str$ as H'L' will be used.

; now enter a loop?

;; PF-LOOP
L2E01:  RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate    x,x.
        DEFB    $27             ;;int          x,int x.
        DEFB    $C2             ;;st-mem-2     x,int x.
        DEFB    $03             ;;subtract     x-int x.     fractional part.
        DEFB    $E2             ;;get-mem-2    x-int x, int x.
        DEFB    $01             ;;exchange     int x, x-int x.
        DEFB    $C2             ;;st-mem-2     int x, x-int x.
        DEFB    $02             ;;delete       int x.
        DEFB    $38             ;;end-calc     int x.
                                ;
                                ; mem-2 holds the fractional part.

; HL points to last value int x

        LD      A,(HL)          ; fetch exponent of int x.
        AND     A               ; test
        JR      NZ,L2E56        ; forward to PF-LARGE if a large integer
                                ; > 65535

; continue with small positive integer components in range 0 - 65535 
; if original number was say .999 then this integer component is zero. 

        CALL    L2D7F           ; routine INT-FETCH gets x in DE
                                ; (but x is not deleted)

        LD      B,$10           ; set B, bit counter, to 16d

        LD      A,D             ; test if
        AND     A               ; high byte is zero
        JR      NZ,L2E1E        ; forward to PF-SAVE if 16-bit integer.

; and continue with integer in range 0 - 255.

        OR      E               ; test the low byte for zero
                                ; i.e. originally just point something or other.
        JR      Z,L2E24         ; forward if so to PF-SMALL 

; 

        LD      D,E             ; transfer E to D
        LD      B,$08           ; and reduce the bit counter to 8.

;; PF-SAVE
L2E1E:  PUSH    DE              ; save the part before decimal point.
        EXX                     ;
        POP     DE              ; and pop in into D'E'
        EXX                     ;
        JR      L2E7B           ; forward to PF-BITS

; ---------------------

; the branch was here when 'int x' was found to be zero as in say 0.5.
; The zero has been fetched from the calculator stack but not deleted and
; this should occur now. This omission leaves the stack unbalanced and while
; that causes no problems with a simple PRINT statement, it will if str$ is
; being used in an expression e.g. "2" + STR$ 0.5 gives the result "0.5"
; instead of the expected result "20.5".
; credit Tony Stratton, 1982.
; A DEFB 02 delete is required immediately on using the calculator.

;; PF-SMALL
L2E24:  RST     28H             ;; FP-CALC       int x = 0.
L2E25:  DEFB    $E2             ;;get-mem-2      int x = 0, x-int x.
        DEFB    $38             ;;end-calc

        LD      A,(HL)          ; fetch exponent of positive fractional number
        SUB     $7E             ; subtract 

        CALL    L2DC1           ; routine LOG(2^A) calculates leading digits.

        LD      D,A             ; transfer count to D
        LD      A,($5CAC)       ; fetch total MEM-5-1
        SUB     D               ;
        LD      ($5CAC),A       ; MEM-5-1
        LD      A,D             ; 
        CALL    L2D4F           ; routine E-TO-FP

        RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate
        DEFB    $27             ;;int
        DEFB    $C1             ;;st-mem-1
        DEFB    $03             ;;subtract
        DEFB    $E1             ;;get-mem-1
        DEFB    $38             ;;end-calc

        CALL    L2DD5           ; routine FP-TO-A

        PUSH    HL              ; save HL
        LD      ($5CA1),A       ; MEM-3-1
        DEC     A               ;
        RLA                     ;
        SBC     A,A             ;
        INC     A               ;

        LD      HL,$5CAB        ; address MEM-5-1 leading digit counter
        LD      (HL),A          ; store counter
        INC     HL              ; address MEM-5-2 total digits
        ADD     A,(HL)          ; add counter to contents
        LD      (HL),A          ; and store updated value
        POP     HL              ; restore HL

        JP      L2ECF           ; JUMP forward to PF-FRACTN

; ---

; Note. while it would be pedantic to comment on every occasion a JP
; instruction could be replaced with a JR instruction, this applies to the
; above, which is useful if you wish to correct the unbalanced stack error
; by inserting a 'DEFB 02 delete' at L2E25, and maintain main addresses.

; the branch was here with a large positive integer > 65535 e.g. 123456789
; the accumulator holds the exponent.

;; PF-LARGE
L2E56:  SUB     $80             ; make exponent positive
        CP      $1C             ; compare to 28
        JR      C,L2E6F         ; to PF-MEDIUM if integer <= 2^27

        CALL    L2DC1           ; routine LOG(2^A)
        SUB     $07             ;
        LD      B,A             ;
        LD      HL,$5CAC        ; address MEM-5-1 the leading digits counter.
        ADD     A,(HL)          ; add A to contents
        LD      (HL),A          ; store updated value.
        LD      A,B             ; 
        NEG                     ; negate
        CALL    L2D4F           ; routine E-TO-FP
        JR      L2E01           ; back to PF-LOOP

; ----------------------------

;; PF-MEDIUM
L2E6F:  EX      DE,HL           ;
        CALL    L2FBA           ; routine FETCH-TWO
        EXX                     ;
        SET     7,D             ;
        LD      A,L             ;
        EXX                     ;
        SUB     $80             ;
        LD      B,A             ;

; the branch was here to handle bits in DE with 8 or 16 in B  if small int
; and integer in D'E', 6 nibbles will accommodate 065535 but routine does
; 32-bit numbers as well from above

;; PF-BITS
L2E7B:  SLA     E               ;  C<xxxxxxxx<0
        RL      D               ;  C<xxxxxxxx<C
        EXX                     ;
        RL      E               ;  C<xxxxxxxx<C
        RL      D               ;  C<xxxxxxxx<C
        EXX                     ;

        LD      HL,$5CAA        ; set HL to mem-4-5th last byte of buffer
        LD      C,$05           ; set byte count to 5 -  10 nibbles

;; PF-BYTES
L2E8A:  LD      A,(HL)          ; fetch 0 or prev value
        ADC     A,A             ; shift left add in carry    C<xxxxxxxx<C

        DAA                     ; Decimal Adjust Accumulator.
                                ; if greater than 9 then the left hand
                                ; nibble is incremented. If greater than
                                ; 99 then adjusted and carry set.
                                ; so if we'd built up 7 and a carry came in
                                ;      0000 0111 < C
                                ;      0000 1111
                                ; daa     1 0101  which is 15 in BCD

        LD      (HL),A          ; put back
        DEC     HL              ; work down thru mem 4
        DEC     C               ; decrease the 5 counter.
        JR      NZ,L2E8A        ; back to PF-BYTES until the ten nibbles rolled

        DJNZ    L2E7B           ; back to PF-BITS until 8 or 16 (or 32) done

; at most 9 digits for 32-bit number will have been loaded with digits
; each of the 9 nibbles in mem 4 is placed into ten bytes in mem-3 and mem 4
; unless the nibble is zero as the buffer is already zero.
; ( or in the case of mem-5 will become zero as a result of RLD instruction )

        XOR     A               ; clear to accept
        LD      HL,$5CA6        ; address MEM-4-0 byte destination.
        LD      DE,$5CA1        ; address MEM-3-0 nibble source.
        LD      B,$09           ; the count is 9 (not ten) as the first 
                                ; nibble is known to be blank.

        RLD                     ; shift RH nibble to left in (HL)
                                ;    A           (HL)
                                ; 0000 0000 < 0000 3210
                                ; 0000 0000   3210 0000
                                ; A picks up the blank nibble


        LD      C,$FF           ; set a flag to indicate when a significant
                                ; digit has been encountered.

;; PF-DIGITS
L2EA1:  RLD                     ; pick up leftmost nibble from (HL)
                                ;    A           (HL)
                                ; 0000 0000 < 7654 3210
                                ; 0000 7654   3210 0000


        JR      NZ,L2EA9        ; to PF-INSERT if non-zero value picked up.

        DEC     C               ; test
        INC     C               ; flag
        JR      NZ,L2EB3        ; skip forward to PF-TEST-2 if flag still $FF
                                ; indicating this is a leading zero.

; but if the zero is a significant digit e.g. 10 then include in digit totals.
; the path for non-zero digits rejoins here.

;; PF-INSERT
L2EA9:  LD      (DE),A          ; insert digit at destination
        INC     DE              ; increase the destination pointer
        INC     (IY+$71)        ; increment MEM-5-1st  digit counter
        INC     (IY+$72)        ; increment MEM-5-2nd  leading digit counter
        LD      C,$00           ; set flag to zero indicating that any 
                                ; subsequent zeros are significant and not 
                                ; leading.

;; PF-TEST-2
L2EB3:  BIT     0,B             ; test if the nibble count is even
        JR      Z,L2EB8         ; skip to PF-ALL-9 if so to deal with the
                                ; other nibble in the same byte

        INC     HL              ; point to next source byte if not

;; PF-ALL-9
L2EB8:  DJNZ    L2EA1           ; decrement the nibble count, back to PF-DIGITS
                                ; if all nine not done.

; For 8-bit integers there will be at most 3 digits.
; For 16-bit integers there will be at most 5 digits. 
; but for larger integers there could be nine leading digits.
; if nine digits complete then the last one is rounded up as the number will
; be printed using E-format notation

        LD      A,($5CAB)       ; fetch digit count from MEM-5-1st
        SUB     $09             ; subtract 9 - max possible
        JR      C,L2ECB         ; forward if less to PF-MORE

        DEC     (IY+$71)        ; decrement digit counter MEM-5-1st to 8
        LD      A,$04           ; load A with the value 4.
        CP      (IY+$6F)        ; compare with MEM-4-4th - the ninth digit
        JR      L2F0C           ; forward to PF-ROUND
                                ; to consider rounding.

; ---------------------------------------
 
; now delete int x from calculator stack and fetch fractional part.

;; PF-MORE
L2ECB:  RST     28H             ;; FP-CALC        int x.
        DEFB    $02             ;;delete          .
        DEFB    $E2             ;;get-mem-2       x - int x = f.
        DEFB    $38             ;;end-calc        f.

;; PF-FRACTN
L2ECF:  EX      DE,HL           ;
        CALL    L2FBA           ; routine FETCH-TWO
        EXX                     ;
        LD      A,$80           ;
        SUB     L               ;
        LD      L,$00           ;
        SET     7,D             ;
        EXX                     ;
        CALL    L2FDD           ; routine SHIFT-FP

;; PF-FRN-LP
L2EDF:  LD      A,(IY+$71)      ; MEM-5-1st
        CP      $08             ;
        JR      C,L2EEC         ; to PF-FR-DGT

        EXX                     ;
        RL      D               ;
        EXX                     ;
        JR      L2F0C           ; to PF-ROUND

; ---

;; PF-FR-DGT
L2EEC:  LD      BC,$0200        ;

;; PF-FR-EXX
L2EEF:  LD      A,E             ;
        CALL    L2F8B           ; routine CA-10*A+C
        LD      E,A             ;
        LD      A,D             ;
        CALL    L2F8B           ; routine CA-10*A+C
        LD      D,A             ;
        PUSH    BC              ;
        EXX                     ;
        POP     BC              ;
        DJNZ    L2EEF           ; to PF-FR-EXX

        LD      HL,$5CA1        ; MEM-3
        LD      A,C             ;
        LD      C,(IY+$71)      ; MEM-5-1st
        ADD     HL,BC           ;
        LD      (HL),A          ;
        INC     (IY+$71)        ; MEM-5-1st
        JR      L2EDF           ; to PF-FRN-LP

; ----------------

; 1) with 9 digits but 8 in mem-5-1 and A holding 4, carry set if rounding up.
; e.g. 
;      999999999 is printed as 1E+9
;      100000001 is printed as 1E+8
;      100000009 is printed as 1.0000001E+8

;; PF-ROUND
L2F0C:  PUSH    AF              ; save A and flags
        LD      HL,$5CA1        ; address MEM-3 start of digits
        LD      C,(IY+$71)      ; MEM-5-1st No. of digits to C
        LD      B,$00           ; prepare to add
        ADD     HL,BC           ; address last digit + 1
        LD      B,C             ; No. of digits to B counter
        POP     AF              ; restore A and carry flag from comparison.

;; PF-RND-LP
L2F18:  DEC     HL              ; address digit at rounding position.
        LD      A,(HL)          ; fetch it
        ADC     A,$00           ; add carry from the comparison
        LD      (HL),A          ; put back result even if $0A.
        AND     A               ; test A
        JR      Z,L2F25         ; skip to PF-R-BACK if ZERO?

        CP      $0A             ; compare to 'ten' - overflow
        CCF                     ; complement carry flag so that set if ten.
        JR      NC,L2F2D        ; forward to PF-COUNT with 1 - 9.

;; PF-R-BACK
L2F25:  DJNZ    L2F18           ; loop back to PF-RND-LP

; if B counts down to zero then we've rounded right back as in 999999995.
; and the first 8 locations all hold $0A.


        LD      (HL),$01        ; load first location with digit 1.
        INC     B               ; make B hold 1 also.
                                ; could save an instruction byte here.
        INC     (IY+$72)        ; make MEM-5-2nd hold 1.
                                ; and proceed to initialize total digits to 1.

;; PF-COUNT
L2F2D:  LD      (IY+$71),B      ; MEM-5-1st

; now balance the calculator stack by deleting  it

        RST     28H             ;; FP-CALC
        DEFB    $02             ;;delete
        DEFB    $38             ;;end-calc

; note if used from str$ then other values may be on the calculator stack.
; we can also restore the next literal pointer from its position on the
; machine stack.

        EXX                     ;
        POP     HL              ; restore next literal pointer.
        EXX                     ;

        LD      BC,($5CAB)      ; set C to MEM-5-1st digit counter.
                                ; set B to MEM-5-2nd leading digit counter.
        LD      HL,$5CA1        ; set HL to start of digits at MEM-3-1
        LD      A,B             ;
        CP      $09             ;
        JR      C,L2F46         ; to PF-NOT-E

        CP      $FC             ;
        JR      C,L2F6C         ; to PF-E-FRMT

;; PF-NOT-E
L2F46:  AND     A               ; test for zero leading digits as in .123

        CALL    Z,L15EF         ; routine OUT-CODE prints a zero e.g. 0.123

;; PF-E-SBRN
L2F4A:  XOR     A               ;
        SUB     B               ;
        JP      M,L2F52         ; skip forward to PF-OUT-LP if originally +ve

        LD      B,A             ; else negative count now +ve
        JR      L2F5E           ; forward to PF-DC-OUT       ->

; ---

;; PF-OUT-LP
L2F52:  LD      A,C             ; fetch total digit count
        AND     A               ; test for zero
        JR      Z,L2F59         ; forward to PF-OUT-DT if so

        LD      A,(HL)          ; fetch digit
        INC     HL              ; address next digit
        DEC     C               ; decrease total digit counter

;; PF-OUT-DT
L2F59:  CALL    L15EF           ; routine OUT-CODE outputs it.
        DJNZ    L2F52           ; loop back to PF-OUT-LP until B leading 
                                ; digits output.

;; PF-DC-OUT
L2F5E:  LD      A,C             ; fetch total digits and
        AND     A               ; test if also zero
        RET     Z               ; return if so              -->

; 

        INC     B               ; increment B
        LD      A,$2E           ; prepare the character '.'

;; PF-DEC-0S
L2F64:  RST     10H             ; PRINT-A outputs the character '.' or '0'

        LD      A,$30           ; prepare the character '0'
                                ; (for cases like .000012345678)
        DJNZ    L2F64           ; loop back to PF-DEC-0S for B times.

        LD      B,C             ; load B with now trailing digit counter.
        JR      L2F52           ; back to PF-OUT-LP

; ---------------------------------

; the branch was here for E-format printing e.g. 123456789 => 1.2345679e+8

;; PF-E-FRMT
L2F6C:  LD      D,B             ; counter to D
        DEC     D               ; decrement
        LD      B,$01           ; load B with 1.

        CALL    L2F4A           ; routine PF-E-SBRN above

        LD      A,$45           ; prepare character 'e'
        RST     10H             ; PRINT-A

        LD      C,D             ; exponent to C
        LD      A,C             ; and to A
        AND     A               ; test exponent
        JP      P,L2F83         ; to PF-E-POS if positive

        NEG                     ; negate
        LD      C,A             ; positive exponent to C
        LD      A,$2D           ; prepare character '-'
        JR      L2F85           ; skip to PF-E-SIGN

; ---

;; PF-E-POS
L2F83:  LD      A,$2B           ; prepare character '+'

;; PF-E-SIGN
L2F85:  RST     10H             ; PRINT-A outputs the sign

        LD      B,$00           ; make the high byte zero.
        JP      L1A1B           ; exit via OUT-NUM-1 to print exponent in BC

; ------------------------------
; Handle printing floating point
; ------------------------------
; This subroutine is called twice from above when printing floating-point
; numbers. It returns 10*A +C in registers C and A

;; CA-10*A+C
L2F8B:  PUSH    DE              ; preserve DE.
        LD      L,A             ; transfer A to L
        LD      H,$00           ; zero high byte.
        LD      E,L             ; copy HL
        LD      D,H             ; to DE.
        ADD     HL,HL           ; double (*2)
        ADD     HL,HL           ; double (*4)
        ADD     HL,DE           ; add DE (*5)
        ADD     HL,HL           ; double (*10)
        LD      E,C             ; copy C to E    (D is 0)
        ADD     HL,DE           ; and add to give required result.
        LD      C,H             ; transfer to
        LD      A,L             ; destination registers.
        POP     DE              ; restore DE
        RET                     ; return with result.

; --------------
; Prepare to add
; --------------
; This routine is called twice by addition to prepare the two numbers. The
; exponent is picked up in A and the location made zero. Then the sign bit
; is tested before being set to the implied state. Negative numbers are twos
; complemented.

;; PREP-ADD
L2F9B:  LD      A,(HL)          ; pick up exponent
        LD      (HL),$00        ; make location zero
        AND     A               ; test if number is zero
        RET     Z               ; return if so

        INC     HL              ; address mantissa
        BIT     7,(HL)          ; test the sign bit
        SET     7,(HL)          ; set it to implied state
        DEC     HL              ; point to exponent
        RET     Z               ; return if positive number.

        PUSH    BC              ; preserve BC
        LD      BC,$0005        ; length of number
        ADD     HL,BC           ; point HL past end
        LD      B,C             ; set B to 5 counter
        LD      C,A             ; store exponent in C
        SCF                     ; set carry flag

;; NEG-BYTE
L2FAF:  DEC     HL              ; work from LSB to MSB
        LD      A,(HL)          ; fetch byte
        CPL                     ; complement
        ADC     A,$00           ; add in initial carry or from prev operation
        LD      (HL),A          ; put back
        DJNZ    L2FAF           ; loop to NEG-BYTE till all 5 done

        LD      A,C             ; stored exponent to A
        POP     BC              ; restore original BC
        RET                     ; return

; -----------------
; Fetch two numbers
; -----------------
; This routine is called twice when printing floating point numbers and also
; to fetch two numbers by the addition, multiply and division routines.
; HL addresses the first number, DE addresses the second number.
; For arithmetic only, A holds the sign of the result which is stored in
; the second location. 

;; FETCH-TWO
L2FBA:  PUSH    HL              ; save pointer to first number, result if math.
        PUSH    AF              ; save result sign.

        LD      C,(HL)          ;
        INC     HL              ;

        LD      B,(HL)          ;
        LD      (HL),A          ; store the sign at correct location in 
                                ; destination 5 bytes for arithmetic only.
        INC     HL              ;

        LD      A,C             ;
        LD      C,(HL)          ;
        PUSH    BC              ;
        INC     HL              ;
        LD      C,(HL)          ;
        INC     HL              ;
        LD      B,(HL)          ;
        EX      DE,HL           ;
        LD      D,A             ;
        LD      E,(HL)          ;
        PUSH    DE              ;
        INC     HL              ;
        LD      D,(HL)          ;
        INC     HL              ;
        LD      E,(HL)          ;
        PUSH    DE              ;
        EXX                     ;
        POP     DE              ;
        POP     HL              ;
        POP     BC              ;
        EXX                     ;
        INC     HL              ;
        LD      D,(HL)          ;
        INC     HL              ;
        LD      E,(HL)          ;

        POP     AF              ; restore possible result sign.
        POP     HL              ; and pointer to possible result.
        RET                     ; return.

; ---------------------------------
; Shift floating point number right
; ---------------------------------
;
;

;; SHIFT-FP
L2FDD:  AND     A               ;
        RET     Z               ;

        CP      $21             ;
        JR      NC,L2FF9        ; to ADDEND-0

        PUSH    BC              ;
        LD      B,A             ;

;; ONE-SHIFT
L2FE5:  EXX                     ;
        SRA     L               ;
        RR      D               ;
        RR      E               ;
        EXX                     ;
        RR      D               ;
        RR      E               ;
        DJNZ    L2FE5           ; to ONE-SHIFT

        POP     BC              ;
        RET     NC              ;

        CALL    L3004           ; routine ADD-BACK
        RET     NZ              ;

;; ADDEND-0
L2FF9:  EXX                     ;
        XOR     A               ;

;; ZEROS-4/5
L2FFB:  LD      L,$00           ;
        LD      D,A             ;
        LD      E,L             ;
        EXX                     ;
        LD      DE,$0000        ;
        RET                     ;

; ------------------
; Add back any carry
; ------------------
;
;

;; ADD-BACK
L3004:  INC     E               ;
        RET     NZ              ;

        INC      D              ;
        RET     NZ              ;

        EXX                     ;
        INC     E               ;
        JR      NZ,L300D        ; to ALL-ADDED

        INC     D               ;

;; ALL-ADDED
L300D:  EXX                     ;
        RET                     ;

; -----------------------
; Handle subtraction (03)
; -----------------------
; Subtraction is done by switching the sign byte/bit of the second number
; which may be integer of floating point and continuing into addition.

;; subtract
L300F:  EX      DE,HL           ; address second number with HL

        CALL    L346E           ; routine NEGATE switches sign

        EX      DE,HL           ; address first number again
                                ; and continue.

; --------------------
; Handle addition (0F)
; --------------------
; HL points to first number, DE to second.
; If they are both integers, then go for the easy route.

;; addition
L3014:  LD      A,(DE)          ; fetch first byte of second
        OR      (HL)            ; combine with first byte of first
        JR      NZ,L303E        ; forward to FULL-ADDN if at least one was
                                ; in floating point form.

; continue if both were small integers.

        PUSH    DE              ; save pointer to lowest number for result.

        INC     HL              ; address sign byte and
        PUSH    HL              ; push the pointer.

        INC     HL              ; address low byte
        LD      E,(HL)          ; to E
        INC     HL              ; address high byte
        LD      D,(HL)          ; to D
        INC     HL              ; address unused byte

        INC     HL              ; address known zero indicator of 1st number
        INC     HL              ; address sign byte

        LD      A,(HL)          ; sign to A, $00 or $FF

        INC     HL              ; address low byte
        LD      C,(HL)          ; to C
        INC     HL              ; address high byte
        LD      B,(HL)          ; to B

        POP     HL              ; pop result sign pointer
        EX      DE,HL           ; integer to HL

        ADD     HL,BC           ; add to the other one in BC
                                ; setting carry if overflow.

        EX      DE,HL           ; save result in DE bringing back sign pointer

        ADC     A,(HL)          ; if pos/pos A=01 with overflow else 00
                                ; if neg/neg A=FF with overflow else FE
                                ; if mixture A=00 with overflow else FF

        RRCA                    ; bit 0 to (C)

        ADC     A,$00           ; both acceptable signs now zero

        JR      NZ,L303C        ; forward to ADDN-OFLW if not

        SBC     A,A             ; restore a negative result sign

        LD      (HL),A          ;
        INC     HL              ;
        LD      (HL),E          ;
        INC     HL              ;
        LD      (HL),D          ;
        DEC     HL              ;
        DEC     HL              ;
        DEC     HL              ;

        POP     DE              ; STKEND
        RET                     ;

; ---

;; ADDN-OFLW
L303C:  DEC     HL              ;
        POP     DE              ;

;; FULL-ADDN
L303E:  CALL    L3293           ; routine RE-ST-TWO
        EXX                     ;
        PUSH    HL              ;
        EXX                     ;
        PUSH    DE              ;
        PUSH    HL              ;
        CALL    L2F9B           ; routine PREP-ADD
        LD      B,A             ;
        EX      DE,HL           ;
        CALL    L2F9B           ; routine PREP-ADD
        LD       C,A            ;
        CP      B               ;
        JR      NC,L3055        ; to SHIFT-LEN

        LD      A,B             ;
        LD      B,C             ;
        EX      DE,HL           ;

;; SHIFT-LEN
L3055:  PUSH    AF              ;
        SUB     B               ;
        CALL    L2FBA           ; routine FETCH-TWO
        CALL    L2FDD           ; routine SHIFT-FP
        POP     AF              ;
        POP     HL              ;
        LD      (HL),A          ;
        PUSH    HL              ;
        LD      L,B             ;
        LD      H,C             ;
        ADD     HL,DE           ;
        EXX                     ;
        EX      DE,HL           ;
        ADC     HL,BC           ;
        EX      DE,HL           ;
        LD      A,H             ;
        ADC     A,L             ;
        LD      L,A             ;
        RRA                     ;
        XOR     L               ;
        EXX                     ;
        EX      DE,HL           ;
        POP     HL              ;
        RRA                     ;
        JR      NC,L307C        ; to TEST-NEG

        LD      A,$01           ;
        CALL    L2FDD           ; routine SHIFT-FP
        INC     (HL)            ;
        JR      Z,L309F         ; to ADD-REP-6

;; TEST-NEG
L307C:  EXX                     ;
        LD      A,L             ;
        AND     $80             ;
        EXX                     ;
        INC     HL              ;
        LD      (HL),A          ;
        DEC     HL              ;
        JR      Z,L30A5         ; to GO-NC-MLT

        LD      A,E             ;
        NEG                     ; Negate
        CCF                     ; Complement Carry Flag
        LD      E,A             ;
        LD      A,D             ;
        CPL                     ;
        ADC     A,$00           ;
        LD      D,A             ;
        EXX                     ;
        LD      A,E             ;
        CPL                     ;
        ADC     A,$00           ;
        LD      E,A             ;
        LD      A,D             ;
        CPL                     ;
        ADC     A,$00           ;
        JR      NC,L30A3        ; to END-COMPL

        RRA                     ;
        EXX                     ;
        INC     (HL)            ;

;; ADD-REP-6
L309F:  JP      Z,L31AD         ; to REPORT-6

        EXX                     ;

;; END-COMPL
L30A3:  LD      D,A             ;
        EXX                     ;

;; GO-NC-MLT
L30A5:  XOR     A               ;
        JP      L3155           ; to TEST-NORM

; -----------------------------
; Used in 16 bit multiplication
; -----------------------------
; This routine is used, in the first instance, by the multiply calculator
; literal to perform an integer multiplication in preference to
; 32-bit multiplication to which it will resort if this overflows.
;
; It is also used by STK-VAR to calculate array subscripts and by DIM to
; calculate the space required for multi-dimensional arrays.

;; HL-HL*DE
L30A9:  PUSH    BC              ; preserve BC throughout
        LD      B,$10           ; set B to 16
        LD      A,H             ; save H in A high byte
        LD      C,L             ; save L in C low byte
        LD      HL,$0000        ; initialize result to zero

; now enter a loop.

;; HL-LOOP
L30B1:  ADD     HL,HL           ; double result
        JR      C,L30BE         ; to HL-END if overflow

        RL      C               ; shift AC left into carry
        RLA                     ;
        JR      NC,L30BC        ; to HL-AGAIN to skip addition if no carry

        ADD     HL,DE           ; add in DE
        JR      C,L30BE         ; to HL-END if overflow

;; HL-AGAIN
L30BC:  DJNZ    L30B1           ; back to HL-LOOP for all 16 bits

;; HL-END
L30BE:  POP     BC              ; restore preserved BC
        RET                     ; return with carry reset if successful
                                ; and result in HL.

; ----------------------------------------------
; THE 'PREPARE TO MULTIPLY OR DIVIDE' SUBROUTINE
; ----------------------------------------------
;   This routine is called in succession from multiply and divide to prepare
;   two mantissas by setting the leftmost bit that is used for the sign.
;   On the first call A holds zero and picks up the sign bit. On the second
;   call the two bits are XORed to form the result sign - minus * minus giving
;   plus etc. If either number is zero then this is flagged.
;   HL addresses the exponent.

;; PREP-M/D
L30C0:  CALL    L34E9           ; routine TEST-ZERO  preserves accumulator.
        RET     C               ; return carry set if zero

        INC     HL              ; address first byte of mantissa
        XOR     (HL)            ; pick up the first or xor with first.
        SET     7,(HL)          ; now set to give true 32-bit mantissa
        DEC     HL              ; point to exponent
        RET                     ; return with carry reset

; ----------------------
; THE 'MULTIPLY' ROUTINE     
; ----------------------
; (offset: $04 'multiply')
;
;
;   "He said go forth and something about mathematics, I wasn't really 
;    listening" - overheard conversation between two unicorns.
;    [ The Odd Streak ].

;; multiply
L30CA:  LD      A,(DE)          ;
        OR      (HL)            ;
        JR      NZ,L30F0        ; to MULT-LONG

        PUSH    DE              ;
        PUSH    HL              ;
        PUSH    DE              ;
        CALL    L2D7F           ; routine INT-FETCH
        EX      DE,HL           ;
        EX      (SP),HL         ;
        LD      B,C             ;
        CALL    L2D7F           ; routine INT-FETCH
        LD      A,B             ;
        XOR     C               ;
        LD      C,A             ;
        POP     HL              ;
        CALL    L30A9           ; routine HL-HL*DE
        EX      DE,HL           ;
        POP     HL              ;
        JR      C,L30EF         ; to MULT-OFLW

        LD      A,D             ;
        OR      E               ;
        JR      NZ,L30EA        ; to MULT-RSLT

        LD      C,A             ;

;; MULT-RSLT
L30EA:  CALL    L2D8E           ; routine INT-STORE
        POP      DE             ;
        RET                     ;

; ---

;; MULT-OFLW
L30EF:  POP     DE              ;

;; MULT-LONG
L30F0:  CALL    L3293           ; routine RE-ST-TWO
        XOR     A               ;
        CALL    L30C0           ; routine PREP-M/D
        RET     C               ;

        EXX                     ;
        PUSH    HL              ;
        EXX                     ;
        PUSH    DE              ;
        EX      DE,HL           ;
        CALL    L30C0           ; routine PREP-M/D
        EX      DE,HL           ;
        JR      C,L315D         ; to ZERO-RSLT

        PUSH    HL              ;
        CALL    L2FBA           ; routine FETCH-TWO
        LD      A,B             ;
        AND     A               ;
        SBC     HL,HL           ;
        EXX                     ;
        PUSH    HL              ;
        SBC     HL,HL           ;
        EXX                     ;
        LD      B,$21           ;
        JR      L3125           ; to STRT-MLT

; ---

;; MLT-LOOP
L3114:  JR      NC,L311B        ; to NO-ADD

        ADD     HL,DE           ;
        EXX                     ;
        ADC     HL,DE           ;
        EXX                     ;

;; NO-ADD
L311B:  EXX                     ;
        RR      H               ;
        RR      L               ;
        EXX                     ;
        RR      H               ;
        RR      L               ;

;; STRT-MLT
L3125:  EXX                     ;
        RR      B               ;
        RR      C               ;
        EXX                     ;
        RR      C               ;
        RRA                     ;
        DJNZ    L3114           ; to MLT-LOOP

        EX      DE,HL           ;
        EXX                     ;
        EX      DE,HL           ;
        EXX                     ;
        POP     BC              ;
        POP     HL              ;
        LD      A,B             ;
        ADD     A,C             ;
        JR      NZ,L313B        ; to MAKE-EXPT

        AND     A               ;

;; MAKE-EXPT
L313B:  DEC     A               ;
        CCF                     ; Complement Carry Flag

;; DIVN-EXPT
L313D:  RLA                     ;
        CCF                     ; Complement Carry Flag
        RRA                     ;
        JP      P,L3146         ; to OFLW1-CLR

        JR      NC,L31AD        ; to REPORT-6

        AND     A               ;

;; OFLW1-CLR
L3146:  INC     A               ;
        JR      NZ,L3151        ; to OFLW2-CLR

        JR      C,L3151         ; to OFLW2-CLR

        EXX                     ;
        BIT     7,D             ;
        EXX                     ;
        JR      NZ,L31AD        ; to REPORT-6

;; OFLW2-CLR
L3151:  LD      (HL),A          ;
        EXX                     ;
        LD      A,B             ;
        EXX                     ;

;; TEST-NORM
L3155:  JR      NC,L316C        ; to NORMALISE

        LD      A,(HL)          ;
        AND     A               ;

;; NEAR-ZERO
L3159:  LD      A,$80           ;
        JR      Z,L315E         ; to SKIP-ZERO

;; ZERO-RSLT
L315D:  XOR     A               ;

;; SKIP-ZERO
L315E:  EXX                     ;
        AND     D               ;
        CALL    L2FFB           ; routine ZEROS-4/5
        RLCA                    ;
        LD      (HL),A          ;
        JR      C,L3195         ; to OFLOW-CLR

        INC     HL              ;
        LD      (HL),A          ;
        DEC     HL              ;
        JR      L3195           ; to OFLOW-CLR

; ---

;; NORMALISE
L316C:  LD      B,$20           ;

;; SHIFT-ONE
L316E:  EXX                     ;
        BIT     7,D             ;
        EXX                     ;
        JR      NZ,L3186        ; to NORML-NOW

        RLCA                    ;
        RL      E               ;
        RL      D               ;
        EXX                     ;
        RL      E               ;
        RL      D               ;
        EXX                     ;
        DEC     (HL)            ;
        JR      Z,L3159         ; to NEAR-ZERO

        DJNZ    L316E           ; to SHIFT-ONE

        JR      L315D           ; to ZERO-RSLT

; ---

;; NORML-NOW
L3186:  RLA                     ;
        JR      NC,L3195        ; to OFLOW-CLR

        CALL    L3004           ; routine ADD-BACK
        JR      NZ,L3195        ; to OFLOW-CLR

        EXX                     ;
        LD       D,$80          ;
        EXX                     ;
        INC     (HL)            ;
        JR      Z,L31AD         ; to REPORT-6

;; OFLOW-CLR
L3195:  PUSH    HL              ;
        INC     HL              ;
        EXX                     ;
        PUSH    DE              ;
        EXX                     ;
        POP     BC              ;
        LD      A,B             ;
        RLA                     ;
        RL      (HL)            ;
        RRA                     ;
        LD      (HL),A          ;
        INC     HL              ;
        LD      (HL),C          ;
        INC     HL              ;
        LD      (HL),D          ;
        INC     HL              ;
        LD      (HL),E          ;
        POP     HL              ;
        POP     DE              ;
        EXX                     ;
        POP     HL              ;
        EXX                     ;
        RET                     ;

; ---

;; REPORT-6
L31AD:  RST     08H             ; ERROR-1
        DEFB    $05             ; Error Report: Number too big

; ----------------------
; THE 'DIVISION' ROUTINE
; ----------------------
; (offset: $05 'division')
;
;   "He who can properly define and divide is to be considered a god"
;   - Plato,  429 - 347 B.C.

;; division
L31AF:  CALL    L3293           ; routine RE-ST-TWO
        EX      DE,HL           ;
        XOR     A               ;
        CALL    L30C0           ; routine PREP-M/D
        JR      C,L31AD         ; to REPORT-6

        EX      DE,HL           ;
        CALL    L30C0           ; routine PREP-M/D
        RET     C               ;

        EXX                     ;
        PUSH    HL              ;
        EXX                     ;
        PUSH    DE              ;
        PUSH    HL              ;
        CALL    L2FBA           ; routine FETCH-TWO
        EXX                     ;
        PUSH    HL              ;
        LD      H,B             ;
        LD      L,C             ;
        EXX                     ;
        LD      H,C             ;
        LD      L,B             ;
        XOR     A               ;
        LD      B,$DF           ;
        JR      L31E2           ; to DIV-START

; ---

;; DIV-LOOP
L31D2:  RLA                     ;
        RL      C               ;
        EXX                     ;
        RL      C               ;
        RL      B               ;
        EXX                     ;

;; div-34th
L31DB:  ADD     HL,HL           ;
        EXX                     ;
        ADC     HL,HL           ;
        EXX                     ;
        JR      C,L31F2         ; to SUBN-ONLY

;; DIV-START
L31E2:  SBC     HL,DE           ;
        EXX                     ;
        SBC     HL,DE           ;
        EXX                     ;
        JR      NC,L31F9        ; to NO-RSTORE

        ADD     HL,DE           ;
        EXX                     ;
        ADC     HL,DE           ;
        EXX                     ;
        AND     A               ;
        JR      L31FA           ; to COUNT-ONE

; ---

;; SUBN-ONLY
L31F2:  AND     A               ;
        SBC     HL,DE           ;
        EXX                     ;
        SBC     HL,DE           ;
        EXX                     ;

;; NO-RSTORE
L31F9:  SCF                     ; Set Carry Flag

;; COUNT-ONE
L31FA:  INC     B               ;
        JP      M,L31D2         ; to DIV-LOOP

        PUSH    AF              ;
        JR      Z,L31E2         ; to DIV-START

;
;
;
;

        LD      E,A             ;
        LD      D,C             ;
        EXX                     ;
        LD      E,C             ;
        LD      D,B             ;
        POP     AF              ;
        RR      B               ;
        POP     AF              ;
        RR      B               ;
        EXX                     ;
        POP     BC              ;
        POP     HL              ;
        LD      A,B             ;
        SUB     C               ;
        JP      L313D           ; jump back to DIVN-EXPT

; ------------------------------------
; Integer truncation towards zero ($3A)
; ------------------------------------
;
;

;; truncate
L3214:  LD      A,(HL)          ;
        AND     A               ;
        RET     Z               ;

        CP      $81             ;
        JR      NC,L3221        ; to T-GR-ZERO

        LD      (HL),$00        ;
        LD      A,$20           ;
        JR      L3272           ; to NIL-BYTES

; ---

;; T-GR-ZERO
L3221:  CP      $91             ;
        JR      NZ,L323F        ; to T-SMALL

        INC     HL              ;
        INC     HL              ;
        INC     HL              ;
        LD      A,$80           ;
        AND     (HL)            ;
        DEC     HL              ;
        OR      (HL)            ;
        DEC     HL              ;
        JR      NZ,L3233        ; to T-FIRST

        LD      A,$80           ;
        XOR     (HL)            ;

;; T-FIRST
L3233:  DEC     HL              ;
        JR      NZ,L326C        ; to T-EXPNENT

        LD      (HL),A          ;
        INC     HL              ;
        LD      (HL),$FF        ;
        DEC     HL              ;
        LD      A,$18           ;
        JR      L3272           ; to NIL-BYTES

; ---

;; T-SMALL
L323F:  JR      NC,L326D        ; to X-LARGE

        PUSH    DE              ;
        CPL                     ;
        ADD     A,$91           ;
        INC     HL              ;
        LD      D,(HL)          ;
        INC     HL              ;
        LD      E,(HL)          ;
        DEC     HL              ;
        DEC     HL              ;
        LD      C,$00           ;
        BIT     7,D             ;
        JR      Z,L3252         ; to T-NUMERIC

        DEC     C               ;

;; T-NUMERIC
L3252:  SET     7,D             ;
        LD      B,$08           ;
        SUB     B               ;
        ADD     A,B             ;
        JR      C,L325E         ; to T-TEST

        LD      E,D             ;
        LD      D,$00           ;
        SUB     B               ;

;; T-TEST
L325E:  JR      Z,L3267         ; to T-STORE

        LD      B,A             ;

;; T-SHIFT
L3261:  SRL     D               ;
        RR      E               ;
        DJNZ    L3261           ; to T-SHIFT

;; T-STORE
L3267:  CALL    L2D8E           ; routine INT-STORE
        POP     DE              ;
        RET                     ;

; ---

;; T-EXPNENT
L326C:  LD      A,(HL)          ;

;; X-LARGE
L326D:  SUB     $A0             ;
        RET     P               ;

        NEG                     ; Negate

;; NIL-BYTES
L3272:  PUSH    DE              ;
        EX      DE,HL           ;
        DEC     HL              ;
        LD      B,A             ;
        SRL     B               ;
        SRL     B               ;
        SRL     B               ;
        JR      Z,L3283         ; to BITS-ZERO

;; BYTE-ZERO
L327E:  LD      (HL),$00        ;
        DEC     HL              ;
        DJNZ    L327E           ; to BYTE-ZERO

;; BITS-ZERO
L3283:  AND     $07             ;
        JR      Z,L3290         ; to IX-END

        LD      B,A             ;
        LD      A,$FF           ;

;; LESS-MASK
L328A:  SLA     A               ;
        DJNZ    L328A           ; to LESS-MASK

        AND     (HL)            ;
        LD      (HL),A          ;

;; IX-END
L3290:  EX      DE,HL           ;
        POP     DE              ;
        RET                     ;

; ----------------------------------
; Storage of numbers in 5 byte form.
; ==================================
; Both integers and floating-point numbers can be stored in five bytes.
; Zero is a special case stored as 5 zeros.
; For integers the form is
; Byte 1 - zero,
; Byte 2 - sign byte, $00 +ve, $FF -ve.
; Byte 3 - Low byte of integer.
; Byte 4 - High byte
; Byte 5 - unused but always zero.
;
; it seems unusual to store the low byte first but it is just as easy either
; way. Statistically it just increases the chances of trailing zeros which
; is an advantage elsewhere in saving ROM code.
;
;             zero     sign     low      high    unused
; So +1 is  00000000 00000000 00000001 00000000 00000000
;
; and -1 is 00000000 11111111 11111111 11111111 00000000
;
; much of the arithmetic found in BASIC lines can be done using numbers
; in this form using the Z80's 16 bit register operation ADD.
; (multiplication is done by a sequence of additions).
;
; Storing -ve integers in two's complement form, means that they are ready for
; addition and you might like to add the numbers above to prove that the
; answer is zero. If, as in this case, the carry is set then that denotes that
; the result is positive. This only applies when the signs don't match.
; With positive numbers a carry denotes the result is out of integer range.
; With negative numbers a carry denotes the result is within range.
; The exception to the last rule is when the result is -65536
;
; Floating point form is an alternative method of storing numbers which can
; be used for integers and larger (or fractional) numbers.
;
; In this form 1 is stored as
;           10000001 00000000 00000000 00000000 00000000
;
; When a small integer is converted to a floating point number the last two
; bytes are always blank so they are omitted in the following steps
;
; first make exponent +1 +16d  (bit 7 of the exponent is set if positive)

; 10010001 00000000 00000001
; 10010000 00000000 00000010 <-  now shift left and decrement exponent
; ...
; 10000010 01000000 00000000 <-  until a 1 abuts the imaginary point
; 10000001 10000000 00000000     to the left of the mantissa.
;
; however since the leftmost bit of the mantissa is always set then it can
; be used to denote the sign of the mantissa and put back when needed by the
; PREP routines which gives
;
; 10000001 00000000 00000000

; ----------------------------------------------
; THE 'RE-STACK TWO "SMALL" INTEGERS' SUBROUTINE
; ----------------------------------------------
;   This routine is called to re-stack two numbers in full floating point form
;   e.g. from mult when integer multiplication has overflowed.

;; RE-ST-TWO
L3293:  CALL    L3296           ; routine RESTK-SUB  below and continue
                                ; into the routine to do the other one.

;; RESTK-SUB
L3296:  EX      DE,HL           ; swap pointers

; ---------------------------------------------
; THE 'RE-STACK ONE "SMALL" INTEGER' SUBROUTINE
; ---------------------------------------------
; (offset: $3D 're-stack')
;   This routine re-stacks an integer, usually on the calculator stack, in full 
;   floating point form.  HL points to first byte.

;; re-stack
L3297:  LD      A,(HL)          ; Fetch Exponent byte to A
        AND     A               ; test it
        RET     NZ              ; return if not zero as already in full
                                ; floating-point form.

        PUSH    DE              ; preserve DE.
        CALL    L2D7F           ; routine INT-FETCH
                                ; integer to DE, sign to C.

; HL points to 4th byte.

        XOR     A               ; clear accumulator.
        INC     HL              ; point to 5th.
        LD      (HL),A          ; and blank.
        DEC     HL              ; point to 4th.
        LD      (HL),A          ; and blank.

        LD      B,$91           ; set exponent byte +ve $81
                                ; and imaginary dec point 16 bits to right
                                ; of first bit.

;   we could skip to normalize now but it's quicker to avoid normalizing 
;   through an empty D.

        LD      A,D             ; fetch the high byte D
        AND     A               ; is it zero ?
        JR      NZ,L32B1        ; skip to RS-NRMLSE if not.

        OR      E               ; low byte E to A and test for zero
        LD      B,D             ; set B exponent to 0
        JR      Z,L32BD         ; forward to RS-STORE if value is zero.

        LD      D,E             ; transfer E to D
        LD      E,B             ; set E to 0
        LD      B,$89           ; reduce the initial exponent by eight.


;; RS-NRMLSE
L32B1:  EX      DE,HL           ; integer to HL, addr of 4th byte to DE.

;; RSTK-LOOP
L32B2:  DEC     B               ; decrease exponent
        ADD     HL,HL           ; shift DE left
        JR      NC,L32B2        ; loop back to RSTK-LOOP
                                ; until a set bit pops into carry

        RRC     C               ; now rotate the sign byte $00 or $FF
                                ; into carry to give a sign bit

        RR      H               ; rotate the sign bit to left of H
        RR      L               ; rotate any carry into L

        EX      DE,HL           ; address 4th byte, normalized int to DE

;; RS-STORE
L32BD:  DEC     HL              ; address 3rd byte
        LD      (HL),E          ; place E
        DEC     HL              ; address 2nd byte
        LD      (HL),D          ; place D
        DEC     HL              ; address 1st byte
        LD      (HL),B          ; store the exponent

        POP     DE              ; restore initial DE.
        RET                     ; return.
