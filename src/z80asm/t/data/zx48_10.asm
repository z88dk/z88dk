;****************************************
;** Part 10. FLOATING-POINT CALCULATOR **
;****************************************

        PUBLIC L335B
        PUBLIC L33A9
        PUBLIC L33B4
        PUBLIC L33C0
        PUBLIC L3406
        PUBLIC L346E
        PUBLIC L34E9
        PUBLIC L350B

        EXTERN L15E6
        EXTERN L1601
        EXTERN L1615
        EXTERN L1C8A
        EXTERN L1E94
        EXTERN L1E99
        EXTERN L1E9F
        EXTERN L1F05
        EXTERN L24FB
        EXTERN L2AB2
        EXTERN L2BF1
        EXTERN L2C8D
        EXTERN L2D28
        EXTERN L2D2B
        EXTERN L2D4F
        EXTERN L2D7F
        EXTERN L2D8E
        EXTERN L2DD5
        EXTERN L2DE3
        EXTERN L300F
        EXTERN L3014
        EXTERN L30CA
        EXTERN L31AF
        EXTERN L3214
        EXTERN L3297
	
; As a general rule the calculator avoids using the IY register.
; exceptions are val, val$ and str$.
; So an assembly language programmer who has disabled interrupts to use
; IY for other purposes can still use the calculator for mathematical
; purposes.


; ------------------------
; THE 'TABLE OF CONSTANTS'
; ------------------------
;
;

; used 11 times
;; stk-zero                                                 00 00 00 00 00
L32C5:  DEFB    $00             ;;Bytes: 1
        DEFB    $B0             ;;Exponent $00
        DEFB    $00             ;;(+00,+00,+00)

; used 19 times
;; stk-one                                                  00 00 01 00 00
L32C8:  DEFB    $40             ;;Bytes: 2
        DEFB    $B0             ;;Exponent $00
        DEFB    $00,$01         ;;(+00,+00)

; used 9 times
;; stk-half                                                 80 00 00 00 00
L32CC:  DEFB    $30             ;;Exponent: $80, Bytes: 1
        DEFB    $00             ;;(+00,+00,+00)

; used 4 times.
;; stk-pi/2                                                 81 49 0F DA A2
L32CE:  DEFB    $F1             ;;Exponent: $81, Bytes: 4
        DEFB    $49,$0F,$DA,$A2 ;;

; used 3 times.
;; stk-ten                                                  00 00 0A 00 00
L32D3:  DEFB    $40             ;;Bytes: 2
        DEFB    $B0             ;;Exponent $00
        DEFB    $00,$0A         ;;(+00,+00)


; ------------------------
; THE 'TABLE OF ADDRESSES'
; ------------------------
;  "Each problem that I solved became a rule which served afterwards to solve 
;   other problems" - Rene Descartes 1596 - 1650.
;
;   Starts with binary operations which have two operands and one result.
;   Three pseudo binary operations first.

;; tbl-addrs
L32D7:  DEFW    L368F           ; $00 Address: $368F - jump-true
        DEFW    L343C           ; $01 Address: $343C - exchange
        DEFW    L33A1           ; $02 Address: $33A1 - delete

;   True binary operations.

        DEFW    L300F           ; $03 Address: $300F - subtract
        DEFW    L30CA           ; $04 Address: $30CA - multiply
        DEFW    L31AF           ; $05 Address: $31AF - division
        DEFW    L3851           ; $06 Address: $3851 - to-power
        DEFW    L351B           ; $07 Address: $351B - or

        DEFW    L3524           ; $08 Address: $3524 - no-&-no
        DEFW    L353B           ; $09 Address: $353B - no-l-eql
        DEFW    L353B           ; $0A Address: $353B - no-gr-eql
        DEFW    L353B           ; $0B Address: $353B - nos-neql
        DEFW    L353B           ; $0C Address: $353B - no-grtr
        DEFW    L353B           ; $0D Address: $353B - no-less
        DEFW    L353B           ; $0E Address: $353B - nos-eql
        DEFW    L3014           ; $0F Address: $3014 - addition

        DEFW    L352D           ; $10 Address: $352D - str-&-no
        DEFW    L353B           ; $11 Address: $353B - str-l-eql
        DEFW    L353B           ; $12 Address: $353B - str-gr-eql
        DEFW    L353B           ; $13 Address: $353B - strs-neql
        DEFW    L353B           ; $14 Address: $353B - str-grtr
        DEFW    L353B           ; $15 Address: $353B - str-less
        DEFW    L353B           ; $16 Address: $353B - strs-eql
        DEFW    L359C           ; $17 Address: $359C - strs-add

;   Unary follow.

        DEFW    L35DE           ; $18 Address: $35DE - val$
        DEFW    L34BC           ; $19 Address: $34BC - usr-$
        DEFW    L3645           ; $1A Address: $3645 - read-in
        DEFW    L346E           ; $1B Address: $346E - negate

        DEFW    L3669           ; $1C Address: $3669 - code
        DEFW    L35DE           ; $1D Address: $35DE - val
        DEFW    L3674           ; $1E Address: $3674 - len
        DEFW    L37B5           ; $1F Address: $37B5 - sin
        DEFW    L37AA           ; $20 Address: $37AA - cos
        DEFW    L37DA           ; $21 Address: $37DA - tan
        DEFW    L3833           ; $22 Address: $3833 - asn
        DEFW    L3843           ; $23 Address: $3843 - acs
        DEFW    L37E2           ; $24 Address: $37E2 - atn
        DEFW    L3713           ; $25 Address: $3713 - ln
        DEFW    L36C4           ; $26 Address: $36C4 - exp
        DEFW    L36AF           ; $27 Address: $36AF - int
        DEFW    L384A           ; $28 Address: $384A - sqr
        DEFW    L3492           ; $29 Address: $3492 - sgn
        DEFW    L346A           ; $2A Address: $346A - abs
        DEFW    L34AC           ; $2B Address: $34AC - peek
        DEFW    L34A5           ; $2C Address: $34A5 - in
        DEFW    L34B3           ; $2D Address: $34B3 - usr-no
        DEFW    L361F           ; $2E Address: $361F - str$
        DEFW    L35C9           ; $2F Address: $35C9 - chrs
        DEFW    L3501           ; $30 Address: $3501 - not

;   End of true unary.

        DEFW    L33C0           ; $31 Address: $33C0 - duplicate
        DEFW    L36A0           ; $32 Address: $36A0 - n-mod-m
        DEFW    L3686           ; $33 Address: $3686 - jump
        DEFW    L33C6           ; $34 Address: $33C6 - stk-data
        DEFW    L367A           ; $35 Address: $367A - dec-jr-nz
        DEFW    L3506           ; $36 Address: $3506 - less-0
        DEFW    L34F9           ; $37 Address: $34F9 - greater-0
        DEFW    L369B           ; $38 Address: $369B - end-calc
        DEFW    L3783           ; $39 Address: $3783 - get-argt
        DEFW    L3214           ; $3A Address: $3214 - truncate
        DEFW    L33A2           ; $3B Address: $33A2 - fp-calc-2
        DEFW    L2D4F           ; $3C Address: $2D4F - e-to-fp
        DEFW    L3297           ; $3D Address: $3297 - re-stack

;   The following are just the next available slots for the 128 compound 
;   literals which are in range $80 - $FF.

        DEFW    L3449           ;     Address: $3449 - series-xx    $80 - $9F.
        DEFW    L341B           ;     Address: $341B - stk-const-xx $A0 - $BF.
        DEFW    L342D           ;     Address: $342D - st-mem-xx    $C0 - $DF.
        DEFW    L340F           ;     Address: $340F - get-mem-xx   $E0 - $FF.

;   Aside: 3E - 3F are therefore unused calculator literals.
;   If the literal has to be also usable as a function then bits 6 and 7 are 
;   used to show type of arguments and result.

; --------------
; The Calculator
; --------------
;  "A good calculator does not need artificial aids"
;  Lao Tze 604 - 531 B.C.

;; CALCULATE
L335B:  CALL    L35BF           ; routine STK-PNTRS is called to set up the
                                ; calculator stack pointers for a default
                                ; unary operation. HL = last value on stack.
                                ; DE = STKEND first location after stack.

; the calculate routine is called at this point by the series generator...

;; GEN-ENT-1
L335E:  LD      A,B             ; fetch the Z80 B register to A
        LD      ($5C67),A       ; and store value in system variable BREG.
                                ; this will be the counter for dec-jr-nz
                                ; or if used from fp-calc2 the calculator
                                ; instruction.

; ... and again later at this point

;; GEN-ENT-2
L3362:  EXX                     ; switch sets
        EX      (SP),HL         ; and store the address of next instruction,
                                ; the return address, in H'L'.
                                ; If this is a recursive call the H'L'
                                ; of the previous invocation goes on stack.
                                ; c.f. end-calc.
        EXX                     ; switch back to main set

; this is the re-entry looping point when handling a string of literals.

;; RE-ENTRY
L3365:  LD      ($5C65),DE      ; save end of stack in system variable STKEND
        EXX                     ; switch to alt
        LD      A,(HL)          ; get next literal
        INC     HL              ; increase pointer'

; single operation jumps back to here

;; SCAN-ENT
L336C:  PUSH    HL              ; save pointer on stack
        AND     A               ; now test the literal
        JP      P,L3380         ; forward to FIRST-3D if in range $00 - $3D
                                ; anything with bit 7 set will be one of
                                ; 128 compound literals.

; compound literals have the following format.
; bit 7 set indicates compound.
; bits 6-5 the subgroup 0-3.
; bits 4-0 the embedded parameter $00 - $1F.
; The subgroup 0-3 needs to be manipulated to form the next available four
; address places after the simple literals in the address table.

        LD      D,A             ; save literal in D
        AND     $60             ; and with 01100000 to isolate subgroup
        RRCA                    ; rotate bits
        RRCA                    ; 4 places to right
        RRCA                    ; not five as we need offset * 2
        RRCA                    ; 00000xx0
        ADD     A,$7C           ; add ($3E * 2) to give correct offset.
                                ; alter above if you add more literals.
        LD      L,A             ; store in L for later indexing.
        LD      A,D             ; bring back compound literal
        AND     $1F             ; use mask to isolate parameter bits
        JR      L338E           ; forward to ENT-TABLE

; ---

; the branch was here with simple literals.

;; FIRST-3D
L3380:  CP      $18             ; compare with first unary operations.
        JR      NC,L338C        ; to DOUBLE-A with unary operations

; it is binary so adjust pointers.

        EXX                     ;
        LD      BC,$FFFB        ; the value -5
        LD      D,H             ; transfer HL, the last value, to DE.
        LD      E,L             ;
        ADD     HL,BC           ; subtract 5 making HL point to second
                                ; value.
        EXX                     ;

;; DOUBLE-A
L338C:  RLCA                    ; double the literal
        LD      L,A             ; and store in L for indexing

;; ENT-TABLE
L338E:  LD      DE,L32D7        ; Address: tbl-addrs
        LD      H,$00           ; prepare to index
        ADD     HL,DE           ; add to get address of routine
        LD      E,(HL)          ; low byte to E
        INC     HL              ;
        LD      D,(HL)          ; high byte to D
        LD      HL,L3365        ; Address: RE-ENTRY
        EX      (SP),HL         ; goes to stack
        PUSH    DE              ; now address of routine
        EXX                     ; main set
                                ; avoid using IY register.
        LD      BC,($5C66)      ; STKEND_hi
                                ; nothing much goes to C but BREG to B
                                ; and continue into next ret instruction
                                ; which has a dual identity


; ------------------
; Handle delete (02)
; ------------------
; A simple return but when used as a calculator literal this
; deletes the last value from the calculator stack.
; On entry, as always with binary operations,
; HL=first number, DE=second number
; On exit, HL=result, DE=stkend.
; So nothing to do

;; delete
L33A1:  RET                     ; return - indirect jump if from above.

; ---------------------
; Single operation (3B)
; ---------------------
;   This single operation is used, in the first instance, to evaluate most
;   of the mathematical and string functions found in BASIC expressions.

;; fp-calc-2
L33A2:  POP     AF              ; drop return address.
        LD      A,($5C67)       ; load accumulator from system variable BREG
                                ; value will be literal e.g. 'tan'
        EXX                     ; switch to alt
        JR      L336C           ; back to SCAN-ENT
                                ; next literal will be end-calc at L2758

; ---------------------------------
; THE 'TEST FIVE SPACES' SUBROUTINE
; ---------------------------------
;   This routine is called from MOVE-FP, STK-CONST and STK-STORE to test that 
;   there is enough space between the calculator stack and the machine stack 
;   for another five-byte value.  It returns with BC holding the value 5 ready 
;   for any subsequent LDIR.

;; TEST-5-SP
L33A9:  PUSH    DE              ; save
        PUSH    HL              ; registers
        LD      BC,$0005        ; an overhead of five bytes
        CALL    L1F05           ; routine TEST-ROOM tests free RAM raising
                                ; an error if not.
        POP     HL              ; else restore
        POP     DE              ; registers.
        RET                     ; return with BC set at 5.

; -----------------------------
; THE 'STACK NUMBER' SUBROUTINE
; -----------------------------
;   This routine is called to stack a hidden floating point number found in
;   a BASIC line.  It is also called to stack a numeric variable value, and
;   from BEEP, to stack an entry in the semi-tone table.  It is not part of the
;   calculator suite of routines.  On entry, HL points to the number to be 
;   stacked.

;; STACK-NUM
L33B4:  LD      DE,($5C65)      ; Load destination from STKEND system variable.

        CALL    L33C0           ; Routine MOVE-FP puts on calculator stack 
                                ; with a memory check.
        LD      ($5C65),DE      ; Set STKEND to next free location.

        RET                     ; Return.

; ---------------------------------
; Move a floating point number (31)
; ---------------------------------

; This simple routine is a 5-byte LDIR instruction
; that incorporates a memory check.
; When used as a calculator literal it duplicates the last value on the
; calculator stack.
; Unary so on entry HL points to last value, DE to stkend

;; duplicate
;; MOVE-FP
L33C0:  CALL    L33A9           ; routine TEST-5-SP test free memory
                                ; and sets BC to 5.
        LDIR                    ; copy the five bytes.
        RET                     ; return with DE addressing new STKEND
                                ; and HL addressing new last value.

; -------------------
; Stack literals ($34)
; -------------------
; When a calculator subroutine needs to put a value on the calculator
; stack that is not a regular constant this routine is called with a
; variable number of following data bytes that convey to the routine
; the integer or floating point form as succinctly as is possible.

;; stk-data
L33C6:  LD      H,D             ; transfer STKEND
        LD      L,E             ; to HL for result.

;; STK-CONST
L33C8:  CALL    L33A9           ; routine TEST-5-SP tests that room exists
                                ; and sets BC to $05.

        EXX                     ; switch to alternate set
        PUSH    HL              ; save the pointer to next literal on stack
        EXX                     ; switch back to main set

        EX      (SP),HL         ; pointer to HL, destination to stack.

        PUSH    BC              ; save BC - value 5 from test room ??.

        LD      A,(HL)          ; fetch the byte following 'stk-data'
        AND     $C0             ; isolate bits 7 and 6
        RLCA                    ; rotate
        RLCA                    ; to bits 1 and 0  range $00 - $03.
        LD      C,A             ; transfer to C
        INC     C               ; and increment to give number of bytes
                                ; to read. $01 - $04
        LD      A,(HL)          ; reload the first byte
        AND     $3F             ; mask off to give possible exponent.
        JR      NZ,L33DE        ; forward to FORM-EXP if it was possible to
                                ; include the exponent.

; else byte is just a byte count and exponent comes next.

        INC     HL              ; address next byte and
        LD      A,(HL)          ; pick up the exponent ( - $50).

;; FORM-EXP
L33DE:  ADD     A,$50           ; now add $50 to form actual exponent
        LD      (DE),A          ; and load into first destination byte.
        LD      A,$05           ; load accumulator with $05 and
        SUB     C               ; subtract C to give count of trailing
                                ; zeros plus one.
        INC     HL              ; increment source
        INC     DE              ; increment destination
        LD      B,$00           ; prepare to copy
        LDIR                    ; copy C bytes

        POP     BC              ; restore 5 counter to BC ??.

        EX      (SP),HL         ; put HL on stack as next literal pointer
                                ; and the stack value - result pointer -
                                ; to HL.

        EXX                     ; switch to alternate set.
        POP     HL              ; restore next literal pointer from stack
                                ; to H'L'.
        EXX                     ; switch back to main set.

        LD      B,A             ; zero count to B
        XOR     A               ; clear accumulator

;; STK-ZEROS
L33F1:  DEC     B               ; decrement B counter
        RET     Z               ; return if zero.          >>
                                ; DE points to new STKEND
                                ; HL to new number.

        LD      (DE),A          ; else load zero to destination
        INC     DE              ; increase destination
        JR      L33F1           ; loop back to STK-ZEROS until done.

; -------------------------------
; THE 'SKIP CONSTANTS' SUBROUTINE
; -------------------------------
;   This routine traverses variable-length entries in the table of constants,
;   stacking intermediate, unwanted constants onto a dummy calculator stack,
;   in the first five bytes of ROM.  The destination DE normally points to the
;   end of the calculator stack which might be in the normal place or in the
;   system variables area during E-LINE-NO; INT-TO-FP; stk-ten.  In any case,
;   it would be simpler all round if the routine just shoved unwanted values 
;   where it is going to stick the wanted value.  The instruction LD DE, $0000 
;   can be removed.

;; SKIP-CONS
L33F7:  AND     A               ; test if initially zero.

;; SKIP-NEXT
L33F8:  RET     Z               ; return if zero.          >>

        PUSH    AF              ; save count.
        PUSH    DE              ; and normal STKEND

        LD      DE,$0000        ; dummy value for STKEND at start of ROM
                                ; Note. not a fault but this has to be
                                ; moved elsewhere when running in RAM.
                                ; e.g. with Expandor Systems 'Soft ROM'.
                                ; Better still, write to the normal place.
        CALL    L33C8           ; routine STK-CONST works through variable
                                ; length records.

        POP     DE              ; restore real STKEND
        POP     AF              ; restore count
        DEC     A               ; decrease
        JR      L33F8           ; loop back to SKIP-NEXT

; ------------------------------
; THE 'LOCATE MEMORY' SUBROUTINE
; ------------------------------
;   This routine, when supplied with a base address in HL and an index in A,
;   will calculate the address of the A'th entry, where each entry occupies
;   five bytes.  It is used for reading the semi-tone table and addressing
;   floating-point numbers in the calculator's memory area.
;   It is not possible to use this routine for the table of constants as these
;   six values are held in compressed format.

;; LOC-MEM
L3406:  LD      C,A             ; store the original number $00-$1F.
        RLCA                    ; X2 - double.
        RLCA                    ; X4 - quadruple.
        ADD     A,C             ; X5 - now add original to multiply by five.

        LD      C,A             ; place the result in the low byte.
        LD      B,$00           ; set high byte to zero.
        ADD     HL,BC           ; add to form address of start of number in HL.

        RET                     ; return.

; ------------------------------
; Get from memory area ($E0 etc.)
; ------------------------------
; Literals $E0 to $FF
; A holds $00-$1F offset.
; The calculator stack increases by 5 bytes.

;; get-mem-xx
L340F:  PUSH    DE              ; save STKEND
        LD      HL,($5C68)      ; MEM is base address of the memory cells.
        CALL    L3406           ; routine LOC-MEM so that HL = first byte
        CALL    L33C0           ; routine MOVE-FP moves 5 bytes with memory
                                ; check.
                                ; DE now points to new STKEND.
        POP     HL              ; original STKEND is now RESULT pointer.
        RET                     ; return.

; --------------------------
; Stack a constant (A0 etc.)
; --------------------------
; This routine allows a one-byte instruction to stack up to 32 constants
; held in short form in a table of constants. In fact only 5 constants are
; required. On entry the A register holds the literal ANDed with 1F.
; It isn't very efficient and it would have been better to hold the
; numbers in full, five byte form and stack them in a similar manner
; to that used for semi-tone table values.

;; stk-const-xx
L341B:  LD      H,D             ; save STKEND - required for result
        LD      L,E             ;
        EXX                     ; swap
        PUSH    HL              ; save pointer to next literal
        LD      HL,L32C5        ; Address: stk-zero - start of table of
                                ; constants
        EXX                     ;
        CALL    L33F7           ; routine SKIP-CONS
        CALL    L33C8           ; routine STK-CONST
        EXX                     ;
        POP     HL              ; restore pointer to next literal.
        EXX                     ;
        RET                     ; return.

; --------------------------------
; Store in a memory area ($C0 etc.)
; --------------------------------
; Offsets $C0 to $DF
; Although 32 memory storage locations can be addressed, only six
; $C0 to $C5 are required by the ROM and only the thirty bytes (6*5)
; required for these are allocated. Spectrum programmers who wish to
; use the floating point routines from assembly language may wish to
; alter the system variable MEM to point to 160 bytes of RAM to have 
; use the full range available.
; A holds the derived offset $00-$1F.
; This is a unary operation, so on entry HL points to the last value and DE 
; points to STKEND.

;; st-mem-xx
L342D:  PUSH    HL              ; save the result pointer.
        EX      DE,HL           ; transfer to DE.
        LD      HL,($5C68)      ; fetch MEM the base of memory area.
        CALL    L3406           ; routine LOC-MEM sets HL to the destination.
        EX      DE,HL           ; swap - HL is start, DE is destination.
        CALL    L33C0           ; routine MOVE-FP.
                                ; note. a short ld bc,5; ldir
                                ; the embedded memory check is not required
                                ; so these instructions would be faster.
        EX      DE,HL           ; DE = STKEND
        POP     HL              ; restore original result pointer
        RET                     ; return.

; -------------------------
; THE 'EXCHANGE' SUBROUTINE
; -------------------------
; (offset: $01 'exchange')
;   This routine swaps the last two values on the calculator stack.
;   On entry, as always with binary operations,
;   HL=first number, DE=second number
;   On exit, HL=result, DE=stkend.

;; exchange
L343C:  LD      B,$05           ; there are five bytes to be swapped

; start of loop.

;; SWAP-BYTE
L343E:  LD      A,(DE)          ; each byte of second
        LD      C,(HL)          ; each byte of first
        EX      DE,HL           ; swap pointers
        LD      (DE),A          ; store each byte of first
        LD      (HL),C          ; store each byte of second
        INC     HL              ; advance both
        INC     DE              ; pointers.
        DJNZ    L343E           ; loop back to SWAP-BYTE until all 5 done.

        EX      DE,HL           ; even up the exchanges so that DE addresses 
                                ; STKEND.

        RET                     ; return.

; ------------------------------
; THE 'SERIES GENERATOR' ROUTINE
; ------------------------------
; (offset: $86 'series-06')
; (offset: $88 'series-08')
; (offset: $8C 'series-0C')
;   The Spectrum uses Chebyshev polynomials to generate approximations for
;   SIN, ATN, LN and EXP.  These are named after the Russian mathematician
;   Pafnuty Chebyshev, born in 1821, who did much pioneering work on numerical
;   series.  As far as calculators are concerned, Chebyshev polynomials have an
;   advantage over other series, for example the Taylor series, as they can
;   reach an approximation in just six iterations for SIN, eight for EXP and
;   twelve for LN and ATN.  The mechanics of the routine are interesting but
;   for full treatment of how these are generated with demonstrations in
;   Sinclair BASIC see "The Complete Spectrum ROM Disassembly" by Dr Ian Logan
;   and Dr Frank O'Hara, published 1983 by Melbourne House.

;; series-xx
L3449:  LD      B,A             ; parameter $00 - $1F to B counter
        CALL    L335E           ; routine GEN-ENT-1 is called.
                                ; A recursive call to a special entry point
                                ; in the calculator that puts the B register
                                ; in the system variable BREG. The return
                                ; address is the next location and where
                                ; the calculator will expect its first
                                ; instruction - now pointed to by HL'.
                                ; The previous pointer to the series of
                                ; five-byte numbers goes on the machine stack.

; The initialization phase.

        DEFB    $31             ;;duplicate       x,x
        DEFB    $0F             ;;addition        x+x
        DEFB    $C0             ;;st-mem-0        x+x
        DEFB    $02             ;;delete          .
        DEFB    $A0             ;;stk-zero        0
        DEFB    $C2             ;;st-mem-2        0

; a loop is now entered to perform the algebraic calculation for each of
; the numbers in the series

;; G-LOOP
L3453:  DEFB    $31             ;;duplicate       v,v.
        DEFB    $E0             ;;get-mem-0       v,v,x+2
        DEFB    $04             ;;multiply        v,v*x+2
        DEFB    $E2             ;;get-mem-2       v,v*x+2,v
        DEFB    $C1             ;;st-mem-1
        DEFB    $03             ;;subtract
        DEFB    $38             ;;end-calc

; the previous pointer is fetched from the machine stack to H'L' where it
; addresses one of the numbers of the series following the series literal.

        CALL    L33C6           ; routine STK-DATA is called directly to
                                ; push a value and advance H'L'.
        CALL    L3362           ; routine GEN-ENT-2 recursively re-enters
                                ; the calculator without disturbing
                                ; system variable BREG
                                ; H'L' value goes on the machine stack and is
                                ; then loaded as usual with the next address.

        DEFB    $0F             ;;addition
        DEFB    $01             ;;exchange
        DEFB    $C2             ;;st-mem-2
        DEFB    $02             ;;delete

        DEFB    $35             ;;dec-jr-nz
        DEFB    $EE             ;;back to L3453, G-LOOP

; when the counted loop is complete the final subtraction yields the result
; for example SIN X.

        DEFB    $E1             ;;get-mem-1
        DEFB    $03             ;;subtract
        DEFB    $38             ;;end-calc

        RET                     ; return with H'L' pointing to location
                                ; after last number in series.

; ---------------------------------
; THE 'ABSOLUTE MAGNITUDE' FUNCTION
; ---------------------------------
; (offset: $2A 'abs')
;   This calculator literal finds the absolute value of the last value,
;   integer or floating point, on calculator stack.

;; abs
L346A:  LD      B,$FF           ; signal abs
        JR      L3474           ; forward to NEG-TEST

; ---------------------------
; THE 'UNARY MINUS' OPERATION
; ---------------------------
; (offset: $1B 'negate')
;   Unary so on entry HL points to last value, DE to STKEND.

;; NEGATE
;; negate
L346E:  CALL    L34E9           ; call routine TEST-ZERO and
        RET     C               ; return if so leaving zero unchanged.

        LD      B,$00           ; signal negate required before joining
                                ; common code.

;; NEG-TEST
L3474:  LD      A,(HL)          ; load first byte and 
        AND     A               ; test for zero
        JR      Z,L3483         ; forward to INT-CASE if a small integer

; for floating point numbers a single bit denotes the sign.

        INC     HL              ; address the first byte of mantissa.
        LD      A,B             ; action flag $FF=abs, $00=neg.
        AND     $80             ; now         $80      $00
        OR      (HL)            ; sets bit 7 for abs
        RLA                     ; sets carry for abs and if number negative
        CCF                     ; complement carry flag
        RRA                     ; and rotate back in altering sign
        LD      (HL),A          ; put the altered adjusted number back
        DEC     HL              ; HL points to result
        RET                     ; return with DE unchanged

; ---

; for integer numbers an entire byte denotes the sign.

;; INT-CASE
L3483:  PUSH    DE              ; save STKEND.

        PUSH    HL              ; save pointer to the last value/result.

        CALL    L2D7F           ; routine INT-FETCH puts integer in DE
                                ; and the sign in C.

        POP     HL              ; restore the result pointer.

        LD      A,B             ; $FF=abs, $00=neg
        OR      C               ; $FF for abs, no change neg
        CPL                     ; $00 for abs, switched for neg
        LD      C,A             ; transfer result to sign byte.

        CALL    L2D8E           ; routine INT-STORE to re-write the integer.

        POP     DE              ; restore STKEND.
        RET                     ; return.

; ---------------------
; THE 'SIGNUM' FUNCTION
; ---------------------
; (offset: $29 'sgn')
;   This routine replaces the last value on the calculator stack,
;   which may be in floating point or integer form, with the integer values
;   zero if zero, with one if positive and  with -minus one if negative.

;; sgn
L3492:  CALL    L34E9           ; call routine TEST-ZERO and
        RET     C               ; exit if so as no change is required.

        PUSH    DE              ; save pointer to STKEND.

        LD      DE,$0001        ; the result will be 1.
        INC     HL              ; skip over the exponent.
        RL      (HL)            ; rotate the sign bit into the carry flag.
        DEC     HL              ; step back to point to the result.
        SBC     A,A             ; byte will be $FF if negative, $00 if positive.
        LD      C,A             ; store the sign byte in the C register.
        CALL    L2D8E           ; routine INT-STORE to overwrite the last
                                ; value with 0001 and sign.

        POP     DE              ; restore STKEND.
        RET                     ; return.

; -----------------
; THE 'IN' FUNCTION
; -----------------
; (offset: $2C 'in')
;   This function reads a byte from an input port.

;; in
L34A5:  CALL    L1E99           ; Routine FIND-INT2 puts port address in BC.
                                ; All 16 bits are put on the address line.

        IN      A,(C)           ; Read the port.

        JR      L34B0           ; exit to STACK-A (via IN-PK-STK to save a byte 
                                ; of instruction code).

; -------------------
; THE 'PEEK' FUNCTION
; -------------------
; (offset: $2B 'peek')
;   This function returns the contents of a memory address.
;   The entire address space can be peeked including the ROM.

;; peek
L34AC:  CALL    L1E99           ; routine FIND-INT2 puts address in BC.
        LD      A,(BC)          ; load contents into A register.

;; IN-PK-STK
L34B0:  JP      L2D28           ; exit via STACK-A to put the value on the 
                                ; calculator stack.

; ------------------
; THE 'USR' FUNCTION
; ------------------
; (offset: $2d 'usr-no')
;   The USR function followed by a number 0-65535 is the method by which
;   the Spectrum invokes machine code programs. This function returns the
;   contents of the BC register pair.
;   Note. that STACK-BC re-initializes the IY register if a user-written
;   program has altered it.

;; usr-no
L34B3:  CALL    L1E99           ; routine FIND-INT2 to fetch the
                                ; supplied address into BC.

        LD      HL,L2D2B        ; address: STACK-BC is
        PUSH    HL              ; pushed onto the machine stack.
        PUSH    BC              ; then the address of the machine code
                                ; routine.

        RET                     ; make an indirect jump to the routine
                                ; and, hopefully, to STACK-BC also.

; -------------------------
; THE 'USR STRING' FUNCTION
; -------------------------
; (offset: $19 'usr-$')
;   The user function with a one-character string argument, calculates the
;   address of the User Defined Graphic character that is in the string.
;   As an alternative, the ASCII equivalent, upper or lower case,
;   may be supplied. This provides a user-friendly method of redefining
;   the 21 User Definable Graphics e.g.
;   POKE USR "a", BIN 10000000 will put a dot in the top left corner of the
;   character 144.
;   Note. the curious double check on the range. With 26 UDGs the first check
;   only is necessary. With anything less the second check only is required.
;   It is highly likely that the first check was written by Steven Vickers.

;; usr-$
L34BC:  CALL    L2BF1           ; routine STK-FETCH fetches the string
                                ; parameters.
        DEC     BC              ; decrease BC by
        LD      A,B             ; one to test
        OR      C               ; the length.
        JR      NZ,L34E7        ; to REPORT-A if not a single character.

        LD      A,(DE)          ; fetch the character
        CALL    L2C8D           ; routine ALPHA sets carry if 'A-Z' or 'a-z'.
        JR      C,L34D3         ; forward to USR-RANGE if ASCII.

        SUB     $90             ; make UDGs range 0-20d
        JR      C,L34E7         ; to REPORT-A if too low. e.g. usr " ".

        CP      $15             ; Note. this test is not necessary.
        JR      NC,L34E7        ; to REPORT-A if higher than 20.

        INC     A               ; make range 1-21d to match LSBs of ASCII

;; USR-RANGE
L34D3:  DEC     A               ; make range of bits 0-4 start at zero
        ADD     A,A             ; multiply by eight
        ADD     A,A             ; and lose any set bits
        ADD     A,A             ; range now 0 - 25*8
        CP      $A8             ; compare to 21*8
        JR      NC,L34E7        ; to REPORT-A if originally higher 
                                ; than 'U','u' or graphics U.

        LD      BC,($5C7B)      ; fetch the UDG system variable value.
        ADD     A,C             ; add the offset to character
        LD      C,A             ; and store back in register C.
        JR      NC,L34E4        ; forward to USR-STACK if no overflow.

        INC     B               ; increment high byte.

;; USR-STACK
L34E4:  JP      L2D2B           ; jump back and exit via STACK-BC to store

; ---

;; REPORT-A
L34E7:  RST     08H             ; ERROR-1
        DEFB    $09             ; Error Report: Invalid argument

; ------------------------------
; THE 'TEST FOR ZERO' SUBROUTINE
; ------------------------------
;   Test if top value on calculator stack is zero.  The carry flag is set if 
;   the last value is zero but no registers are altered.
;   All five bytes will be zero but first four only need be tested.
;   On entry, HL points to the exponent the first byte of the value.

;; TEST-ZERO
L34E9:  PUSH    HL              ; preserve HL which is used to address.
        PUSH    BC              ; preserve BC which is used as a store.
        LD      B,A             ; preserve A in B.

        LD      A,(HL)          ; load first byte to accumulator
        INC     HL              ; advance.
        OR      (HL)            ; OR with second byte and clear carry.
        INC     HL              ; advance.
        OR      (HL)            ; OR with third byte.
        INC     HL              ; advance.
        OR      (HL)            ; OR with fourth byte.

        LD      A,B             ; restore A without affecting flags.
        POP     BC              ; restore the saved
        POP     HL              ; registers.

        RET     NZ              ; return if not zero and with carry reset.

        SCF                     ; set the carry flag.
        RET                     ; return with carry set if zero.

; --------------------------------
; THE 'GREATER THAN ZERO' OPERATOR
; --------------------------------
; (offset: $37 'greater-0' )
;   Test if the last value on the calculator stack is greater than zero.
;   This routine is also called directly from the end-tests of the comparison 
;   routine.

;; GREATER-0
;; greater-0
L34F9:  CALL    L34E9           ; routine TEST-ZERO
        RET     C               ; return if was zero as this
                                ; is also the Boolean 'false' value.

        LD      A,$FF           ; prepare XOR mask for sign bit
        JR      L3507           ; forward to SIGN-TO-C
                                ; to put sign in carry
                                ; (carry will become set if sign is positive)
                                ; and then overwrite location with 1 or 0 
                                ; as appropriate.

; ------------------
; THE 'NOT' FUNCTION
; ------------------
; (offset: $30 'not')
;   This overwrites the last value with 1 if it was zero else with zero
;   if it was any other value.
;
;   e.g. NOT 0 returns 1, NOT 1 returns 0, NOT -3 returns 0.
;
;   The subroutine is also called directly from the end-tests of the comparison
;   operator.

;; NOT
;; not
L3501:  CALL    L34E9           ; routine TEST-ZERO sets carry if zero

        JR      L350B           ; to FP-0/1 to overwrite operand with
                                ; 1 if carry is set else to overwrite with zero.

; ------------------------------
; THE 'LESS THAN ZERO' OPERATION
; ------------------------------
; (offset: $36 'less-0' )
;   Destructively test if last value on calculator stack is less than zero.
;   Bit 7 of second byte will be set if so.

;; less-0
L3506:  XOR     A               ; set XOR mask to zero
                                ; (carry will become set if sign is negative).

;   transfer sign of mantissa to Carry Flag.

;; SIGN-TO-C
L3507:  INC     HL              ; address 2nd byte.
        XOR     (HL)            ; bit 7 of HL will be set if number is negative.
        DEC     HL              ; address 1st byte again.
        RLCA                    ; rotate bit 7 of A to carry.

; ----------------------------
; THE 'ZERO OR ONE' SUBROUTINE
; ----------------------------
;   This routine places an integer value of zero or one at the addressed 
;   location of the calculator stack or MEM area.  The value one is written if 
;   carry is set on entry else zero.

;; FP-0/1
L350B:  PUSH    HL              ; save pointer to the first byte
        LD      A,$00           ; load accumulator with zero - without
                                ; disturbing flags.
        LD      (HL),A          ; zero to first byte
        INC     HL              ; address next
        LD      (HL),A          ; zero to 2nd byte
        INC     HL              ; address low byte of integer
        RLA                     ; carry to bit 0 of A
        LD      (HL),A          ; load one or zero to low byte.
        RRA                     ; restore zero to accumulator.
        INC     HL              ; address high byte of integer.
        LD      (HL),A          ; put a zero there.
        INC     HL              ; address fifth byte.
        LD      (HL),A          ; put a zero there.
        POP     HL              ; restore pointer to the first byte.
        RET                     ; return.

; -----------------
; THE 'OR' OPERATOR
; -----------------
; (offset: $07 'or' )
; The Boolean OR operator. e.g. X OR Y
; The result is zero if both values are zero else a non-zero value.
;
; e.g.    0 OR 0  returns 0.
;        -3 OR 0  returns -3.
;         0 OR -3 returns 1.
;        -3 OR 2  returns 1.
;
; A binary operation.
; On entry HL points to first operand (X) and DE to second operand (Y).

;; or
L351B:  EX      DE,HL           ; make HL point to second number
        CALL    L34E9           ; routine TEST-ZERO
        EX      DE,HL           ; restore pointers
        RET     C               ; return if result was zero - first operand, 
                                ; now the last value, is the result.

        SCF                     ; set carry flag
        JR      L350B           ; back to FP-0/1 to overwrite the first operand
                                ; with the value 1.


; ---------------------------------
; THE 'NUMBER AND NUMBER' OPERATION
; ---------------------------------
; (offset: $08 'no-&-no')
;   The Boolean AND operator.
;
;   e.g.    -3 AND 2  returns -3.
;           -3 AND 0  returns 0.
;            0 and -2 returns 0.
;            0 and 0  returns 0.
;
;   Compare with OR routine above.

;; no-&-no
L3524:  EX      DE,HL           ; make HL address second operand.

        CALL    L34E9           ; routine TEST-ZERO sets carry if zero.

        EX      DE,HL           ; restore pointers.
        RET     NC              ; return if second non-zero, first is result.

;

        AND     A               ; else clear carry.
        JR      L350B           ; back to FP-0/1 to overwrite first operand
                                ; with zero for return value.

; ---------------------------------
; THE 'STRING AND NUMBER' OPERATION
; ---------------------------------
; (offset: $10 'str-&-no')
;   e.g. "You Win" AND score>99 will return the string if condition is true
;   or the null string if false.

;; str-&-no
L352D:  EX      DE,HL           ; make HL point to the number.
        CALL    L34E9           ; routine TEST-ZERO.
        EX      DE,HL           ; restore pointers. 
        RET     NC              ; return if number was not zero - the string 
                                ; is the result.

;   if the number was zero (false) then the null string must be returned by
;   altering the length of the string on the calculator stack to zero.

        PUSH    DE              ; save pointer to the now obsolete number 
                                ; (which will become the new STKEND)

        DEC     DE              ; point to the 5th byte of string descriptor.
        XOR     A               ; clear the accumulator.
        LD      (DE),A          ; place zero in high byte of length.
        DEC     DE              ; address low byte of length.
        LD      (DE),A          ; place zero there - now the null string.

        POP     DE              ; restore pointer - new STKEND.
        RET                     ; return.

; ---------------------------
; THE 'COMPARISON' OPERATIONS
; ---------------------------
; (offset: $0A 'no-gr-eql')
; (offset: $0B 'nos-neql')
; (offset: $0C 'no-grtr')
; (offset: $0D 'no-less')
; (offset: $0E 'nos-eql')
; (offset: $11 'str-l-eql')
; (offset: $12 'str-gr-eql')
; (offset: $13 'strs-neql')
; (offset: $14 'str-grtr')
; (offset: $15 'str-less')
; (offset: $16 'strs-eql')

;   True binary operations.
;   A single entry point is used to evaluate six numeric and six string
;   comparisons. On entry, the calculator literal is in the B register and
;   the two numeric values, or the two string parameters, are on the 
;   calculator stack.
;   The individual bits of the literal are manipulated to group similar
;   operations although the SUB 8 instruction does nothing useful and merely
;   alters the string test bit.
;   Numbers are compared by subtracting one from the other, strings are 
;   compared by comparing every character until a mismatch, or the end of one
;   or both, is reached.
;
;   Numeric Comparisons.
;   --------------------
;   The 'x>y' example is the easiest as it employs straight-thru logic.
;   Number y is subtracted from x and the result tested for greater-0 yielding
;   a final value 1 (true) or 0 (false). 
;   For 'x<y' the same logic is used but the two values are first swapped on the
;   calculator stack. 
;   For 'x=y' NOT is applied to the subtraction result yielding true if the
;   difference was zero and false with anything else. 
;   The first three numeric comparisons are just the opposite of the last three
;   so the same processing steps are used and then a final NOT is applied.
;
; literal    Test   No  sub 8       ExOrNot  1st RRCA  exch sub  ?   End-Tests
; =========  ====   == ======== === ======== ========  ==== ===  =  === === ===
; no-l-eql   x<=y   09 00000001 dec 00000000 00000000  ---- x-y  ?  --- >0? NOT
; no-gr-eql  x>=y   0A 00000010 dec 00000001 10000000c swap y-x  ?  --- >0? NOT
; nos-neql   x<>y   0B 00000011 dec 00000010 00000001  ---- x-y  ?  NOT --- NOT
; no-grtr    x>y    0C 00000100  -  00000100 00000010  ---- x-y  ?  --- >0? ---
; no-less    x<y    0D 00000101  -  00000101 10000010c swap y-x  ?  --- >0? ---
; nos-eql    x=y    0E 00000110  -  00000110 00000011  ---- x-y  ?  NOT --- ---
;
;                                                           comp -> C/F
;                                                           ====    ===
; str-l-eql  x$<=y$ 11 00001001 dec 00001000 00000100  ---- x$y$ 0  !or >0? NOT
; str-gr-eql x$>=y$ 12 00001010 dec 00001001 10000100c swap y$x$ 0  !or >0? NOT
; strs-neql  x$<>y$ 13 00001011 dec 00001010 00000101  ---- x$y$ 0  !or >0? NOT
; str-grtr   x$>y$  14 00001100  -  00001100 00000110  ---- x$y$ 0  !or >0? ---
; str-less   x$<y$  15 00001101  -  00001101 10000110c swap y$x$ 0  !or >0? ---
; strs-eql   x$=y$  16 00001110  -  00001110 00000111  ---- x$y$ 0  !or >0? ---
;
;   String comparisons are a little different in that the eql/neql carry flag
;   from the 2nd RRCA is, as before, fed into the first of the end tests but
;   along the way it gets modified by the comparison process. The result on the
;   stack always starts off as zero and the carry fed in determines if NOT is 
;   applied to it. So the only time the greater-0 test is applied is if the
;   stack holds zero which is not very efficient as the test will always yield
;   zero. The most likely explanation is that there were once separate end tests
;   for numbers and strings.

;; no-l-eql,etc.
L353B:  LD      A,B             ; transfer literal to accumulator.
        SUB     $08             ; subtract eight - which is not useful. 

        BIT     2,A             ; isolate '>', '<', '='.

        JR      NZ,L3543        ; skip to EX-OR-NOT with these.

        DEC     A               ; else make $00-$02, $08-$0A to match bits 0-2.

;; EX-OR-NOT
L3543:  RRCA                    ; the first RRCA sets carry for a swap. 
        JR      NC,L354E        ; forward to NU-OR-STR with other 8 cases

; for the other 4 cases the two values on the calculator stack are exchanged.

        PUSH    AF              ; save A and carry.
        PUSH    HL              ; save HL - pointer to first operand.
                                ; (DE points to second operand).

        CALL    L343C           ; routine exchange swaps the two values.
                                ; (HL = second operand, DE = STKEND)

        POP     DE              ; DE = first operand
        EX      DE,HL           ; as we were.
        POP     AF              ; restore A and carry.

; Note. it would be better if the 2nd RRCA preceded the string test.
; It would save two duplicate bytes and if we also got rid of that sub 8 
; at the beginning we wouldn't have to alter which bit we test.

;; NU-OR-STR
L354E:  BIT     2,A             ; test if a string comparison.
        JR      NZ,L3559        ; forward to STRINGS if so.

; continue with numeric comparisons.

        RRCA                    ; 2nd RRCA causes eql/neql to set carry.
        PUSH    AF              ; save A and carry

        CALL    L300F           ; routine subtract leaves result on stack.
        JR      L358C           ; forward to END-TESTS

; ---

;; STRINGS
L3559:  RRCA                    ; 2nd RRCA causes eql/neql to set carry.
        PUSH    AF              ; save A and carry.

        CALL    L2BF1           ; routine STK-FETCH gets 2nd string params
        PUSH    DE              ; save start2 *.
        PUSH    BC              ; and the length.

        CALL    L2BF1           ; routine STK-FETCH gets 1st string 
                                ; parameters - start in DE, length in BC.
        POP     HL              ; restore length of second to HL.

; A loop is now entered to compare, by subtraction, each corresponding character
; of the strings. For each successful match, the pointers are incremented and 
; the lengths decreased and the branch taken back to here. If both string 
; remainders become null at the same time, then an exact match exists.

;; BYTE-COMP
L3564:  LD      A,H             ; test if the second string
        OR      L               ; is the null string and hold flags.

        EX      (SP),HL         ; put length2 on stack, bring start2 to HL *.
        LD      A,B             ; hi byte of length1 to A

        JR      NZ,L3575        ; forward to SEC-PLUS if second not null.

        OR      C               ; test length of first string.

;; SECND-LOW
L356B:  POP     BC              ; pop the second length off stack.
        JR      Z,L3572         ; forward to BOTH-NULL if first string is also
                                ; of zero length.

; the true condition - first is longer than second (SECND-LESS)

        POP     AF              ; restore carry (set if eql/neql)
        CCF                     ; complement carry flag.
                                ; Note. equality becomes false.
                                ; Inequality is true. By swapping or applying
                                ; a terminal 'not', all comparisons have been
                                ; manipulated so that this is success path. 
        JR      L3588           ; forward to leave via STR-TEST

; ---
; the branch was here with a match

;; BOTH-NULL
L3572:  POP     AF              ; restore carry - set for eql/neql
        JR      L3588           ; forward to STR-TEST

; ---  
; the branch was here when 2nd string not null and low byte of first is yet
; to be tested.


;; SEC-PLUS
L3575:  OR      C               ; test the length of first string.
        JR      Z,L3585         ; forward to FRST-LESS if length is zero.

; both strings have at least one character left.

        LD      A,(DE)          ; fetch character of first string. 
        SUB     (HL)            ; subtract with that of 2nd string.
        JR      C,L3585         ; forward to FRST-LESS if carry set

        JR      NZ,L356B        ; back to SECND-LOW and then STR-TEST
                                ; if not exact match.

        DEC     BC              ; decrease length of 1st string.
        INC     DE              ; increment 1st string pointer.

        INC     HL              ; increment 2nd string pointer.
        EX      (SP),HL         ; swap with length on stack
        DEC     HL              ; decrement 2nd string length
        JR      L3564           ; back to BYTE-COMP

; ---
; the false condition.

;; FRST-LESS
L3585:  POP     BC              ; discard length
        POP     AF              ; pop A
        AND     A               ; clear the carry for false result.

; ---
; exact match and x$>y$ rejoin here

;; STR-TEST
L3588:  PUSH    AF              ; save A and carry

        RST     28H             ;; FP-CALC
        DEFB    $A0             ;;stk-zero      an initial false value.
        DEFB    $38             ;;end-calc

; both numeric and string paths converge here.

;; END-TESTS
L358C:  POP     AF              ; pop carry  - will be set if eql/neql
        PUSH    AF              ; save it again.

        CALL    C,L3501         ; routine NOT sets true(1) if equal(0)
                                ; or, for strings, applies true result.

        POP     AF              ; pop carry and
        PUSH    AF              ; save A

        CALL    NC,L34F9        ; routine GREATER-0 tests numeric subtraction 
                                ; result but also needlessly tests the string 
                                ; value for zero - it must be.

        POP     AF              ; pop A 
        RRCA                    ; the third RRCA - test for '<=', '>=' or '<>'.
        CALL    NC,L3501        ; apply a terminal NOT if so.
        RET                     ; return.

; ------------------------------------
; THE 'STRING CONCATENATION' OPERATION
; ------------------------------------
; (offset: $17 'strs-add')
;   This literal combines two strings into one e.g. LET a$ = b$ + c$
;   The two parameters of the two strings to be combined are on the stack.

;; strs-add
L359C:  CALL    L2BF1           ; routine STK-FETCH fetches string parameters
                                ; and deletes calculator stack entry.
        PUSH    DE              ; save start address.
        PUSH    BC              ; and length.

        CALL    L2BF1           ; routine STK-FETCH for first string
        POP     HL              ; re-fetch first length
        PUSH    HL              ; and save again
        PUSH    DE              ; save start of second string
        PUSH    BC              ; and its length.

        ADD     HL,BC           ; add the two lengths.
        LD      B,H             ; transfer to BC
        LD      C,L             ; and create
        RST     30H             ; BC-SPACES in workspace.
                                ; DE points to start of space.

        CALL    L2AB2           ; routine STK-STO-$ stores parameters
                                ; of new string updating STKEND.

        POP     BC              ; length of first
        POP     HL              ; address of start
        LD      A,B             ; test for
        OR      C               ; zero length.
        JR      Z,L35B7         ; to OTHER-STR if null string

        LDIR                    ; copy string to workspace.

;; OTHER-STR
L35B7:  POP     BC              ; now second length
        POP     HL              ; and start of string
        LD      A,B             ; test this one
        OR      C               ; for zero length
        JR      Z,L35BF         ; skip forward to STK-PNTRS if so as complete.

        LDIR                    ; else copy the bytes.
                                ; and continue into next routine which
                                ; sets the calculator stack pointers.

; -----------------------------------
; THE 'SET STACK POINTERS' SUBROUTINE
; -----------------------------------
;   Register DE is set to STKEND and HL, the result pointer, is set to five 
;   locations below this.
;   This routine is used when it is inconvenient to save these values at the
;   time the calculator stack is manipulated due to other activity on the 
;   machine stack.
;   This routine is also used to terminate the VAL and READ-IN  routines for
;   the same reason and to initialize the calculator stack at the start of
;   the CALCULATE routine.

;; STK-PNTRS
L35BF:  LD      HL,($5C65)      ; fetch STKEND value from system variable.
        LD      DE,$FFFB        ; the value -5
        PUSH    HL              ; push STKEND value.

        ADD     HL,DE           ; subtract 5 from HL.

        POP     DE              ; pop STKEND to DE.
        RET                     ; return.

; -------------------
; THE 'CHR$' FUNCTION
; -------------------
; (offset: $2f 'chr$')
;   This function returns a single character string that is a result of 
;   converting a number in the range 0-255 to a string e.g. CHR$ 65 = "A".

;; chrs
L35C9:  CALL    L2DD5           ; routine FP-TO-A puts the number in A.

        JR      C,L35DC         ; forward to REPORT-Bd if overflow
        JR      NZ,L35DC        ; forward to REPORT-Bd if negative

        PUSH    AF              ; save the argument.

        LD      BC,$0001        ; one space required.
        RST     30H             ; BC-SPACES makes DE point to start

        POP     AF              ; restore the number.

        LD      (DE),A          ; and store in workspace

        CALL    L2AB2           ; routine STK-STO-$ stacks descriptor.

        EX      DE,HL           ; make HL point to result and DE to STKEND.
        RET                     ; return.

; ---

;; REPORT-Bd
L35DC:  RST     08H             ; ERROR-1
        DEFB    $0A             ; Error Report: Integer out of range

; ----------------------------
; THE 'VAL and VAL$' FUNCTIONS
; ----------------------------
; (offset: $1d 'val')
; (offset: $18 'val$')
;   VAL treats the characters in a string as a numeric expression.
;   e.g. VAL "2.3" = 2.3, VAL "2+4" = 6, VAL ("2" + "4") = 24.
;   VAL$ treats the characters in a string as a string expression.
;   e.g. VAL$ (z$+"(2)") = a$(2) if z$ happens to be "a$".

;; val
;; val$
L35DE:  LD      HL,($5C5D)      ; fetch value of system variable CH_ADD
        PUSH    HL              ; and save on the machine stack.
        LD      A,B             ; fetch the literal (either $1D or $18).
        ADD     A,$E3           ; add $E3 to form $00 (setting carry) or $FB.
        SBC     A,A             ; now form $FF bit 6 = numeric result
                                ; or $00 bit 6 = string result.
        PUSH    AF              ; save this mask on the stack

        CALL    L2BF1           ; routine STK-FETCH fetches the string operand
                                ; from calculator stack.

        PUSH    DE              ; save the address of the start of the string.
        INC     BC              ; increment the length for a carriage return.

        RST     30H             ; BC-SPACES creates the space in workspace.
        POP     HL              ; restore start of string to HL.
        LD      ($5C5D),DE      ; load CH_ADD with start DE in workspace.

        PUSH    DE              ; save the start in workspace
        LDIR                    ; copy string from program or variables or
                                ; workspace to the workspace area.
        EX      DE,HL           ; end of string + 1 to HL
        DEC     HL              ; decrement HL to point to end of new area.
        LD      (HL),$0D        ; insert a carriage return at end.
        RES     7,(IY+$01)      ; update FLAGS  - signal checking syntax.
        CALL    L24FB           ; routine SCANNING evaluates string
                                ; expression and result.

        RST     18H             ; GET-CHAR fetches next character.
        CP      $0D             ; is it the expected carriage return ?
        JR      NZ,L360C        ; forward to V-RPORT-C if not
                                ; 'Nonsense in BASIC'.

        POP     HL              ; restore start of string in workspace.
        POP     AF              ; restore expected result flag (bit 6).
        XOR     (IY+$01)        ; xor with FLAGS now updated by SCANNING.
        AND     $40             ; test bit 6 - should be zero if result types
                                ; match.

;; V-RPORT-C
L360C:  JP      NZ,L1C8A        ; jump back to REPORT-C with a result mismatch.

        LD      ($5C5D),HL      ; set CH_ADD to the start of the string again.
        SET     7,(IY+$01)      ; update FLAGS  - signal running program.
        CALL    L24FB           ; routine SCANNING evaluates the string
                                ; in full leaving result on calculator stack.

        POP     HL              ; restore saved character address in program.
        LD      ($5C5D),HL      ; and reset the system variable CH_ADD.

        JR      L35BF           ; back to exit via STK-PNTRS.
                                ; resetting the calculator stack pointers
                                ; HL and DE from STKEND as it wasn't possible 
                                ; to preserve them during this routine.

; -------------------
; THE 'STR$' FUNCTION
; -------------------
; (offset: $2e 'str$')
;   This function produces a string comprising the characters that would appear
;   if the numeric argument were printed.
;   e.g. STR$ (1/10) produces "0.1".

;; str$
L361F:  LD      BC,$0001        ; create an initial byte in workspace
        RST     30H             ; using BC-SPACES restart.

        LD      ($5C5B),HL      ; set system variable K_CUR to new location.
        PUSH    HL              ; and save start on machine stack also.

        LD      HL,($5C51)      ; fetch value of system variable CURCHL
        PUSH    HL              ; and save that too.

        LD      A,$FF           ; select system channel 'R'.
        CALL    L1601           ; routine CHAN-OPEN opens it.
        CALL    L2DE3           ; routine PRINT-FP outputs the number to
                                ; workspace updating K-CUR.

        POP     HL              ; restore current channel.
        CALL    L1615           ; routine CHAN-FLAG resets flags.

        POP     DE              ; fetch saved start of string to DE.
        LD      HL,($5C5B)      ; load HL with end of string from K_CUR.

        AND     A               ; prepare for true subtraction.
        SBC     HL,DE           ; subtract start from end to give length.
        LD      B,H             ; transfer the length to
        LD      C,L             ; the BC register pair.

        CALL    L2AB2           ; routine STK-STO-$ stores string parameters
                                ; on the calculator stack.

        EX      DE,HL           ; HL = last value, DE = STKEND.
        RET                     ; return.

; ------------------------
; THE 'READ-IN' SUBROUTINE
; ------------------------
; (offset: $1a 'read-in')
;   This is the calculator literal used by the INKEY$ function when a '#'
;   is encountered after the keyword.
;   INKEY$ # does not interact correctly with the keyboard, #0 or #1, and
;   its uses are for other channels.

;; read-in
L3645:  CALL    L1E94           ; routine FIND-INT1 fetches stream to A
        CP      $10             ; compare with 16 decimal.
        JP      NC,L1E9F        ; JUMP to REPORT-Bb if not in range 0 - 15.
                                ; 'Integer out of range'
                                ; (REPORT-Bd is within range)

        LD      HL,($5C51)      ; fetch current channel CURCHL
        PUSH    HL              ; save it

        CALL    L1601           ; routine CHAN-OPEN opens channel

        CALL    L15E6           ; routine INPUT-AD - the channel must have an
                                ; input stream or else error here from stream
                                ; stub.
        LD      BC,$0000        ; initialize length of string to zero
        JR      NC,L365F        ; forward to R-I-STORE if no key detected.

        INC     C               ; increase length to one.

        RST     30H             ; BC-SPACES creates space for one character
                                ; in workspace.
        LD      (DE),A          ; the character is inserted.

;; R-I-STORE
L365F:  CALL    L2AB2           ; routine STK-STO-$ stacks the string
                                ; parameters.
        POP     HL              ; restore current channel address

        CALL    L1615           ; routine CHAN-FLAG resets current channel
                                ; system variable and flags.

        JP      L35BF           ; jump back to STK-PNTRS

; -------------------
; THE 'CODE' FUNCTION
; -------------------
; (offset: $1c 'code')
;   Returns the ASCII code of a character or first character of a string
;   e.g. CODE "Aardvark" = 65, CODE "" = 0.

;; code
L3669:  CALL    L2BF1           ; routine STK-FETCH to fetch and delete the
                                ; string parameters.
                                ; DE points to the start, BC holds the length.

        LD      A,B             ; test length
        OR      C               ; of the string.
        JR      Z,L3671         ; skip to STK-CODE with zero if the null string.

        LD      A,(DE)          ; else fetch the first character.

;; STK-CODE
L3671:  JP      L2D28           ; jump back to STACK-A (with memory check)

; ------------------
; THE 'LEN' FUNCTION
; ------------------
; (offset: $1e 'len')
;   Returns the length of a string.
;   In Sinclair BASIC strings can be more than twenty thousand characters long
;   so a sixteen-bit register is required to store the length

;; len
L3674:  CALL    L2BF1           ; Routine STK-FETCH to fetch and delete the
                                ; string parameters from the calculator stack.
                                ; Register BC now holds the length of string.

        JP      L2D2B           ; Jump back to STACK-BC to save result on the
                                ; calculator stack (with memory check).

; -------------------------------------
; THE 'DECREASE THE COUNTER' SUBROUTINE
; -------------------------------------
; (offset: $35 'dec-jr-nz')
;   The calculator has an instruction that decrements a single-byte
;   pseudo-register and makes consequential relative jumps just like
;   the Z80's DJNZ instruction.

;; dec-jr-nz
L367A:  EXX                     ; switch in set that addresses code

        PUSH    HL              ; save pointer to offset byte
        LD      HL,$5C67        ; address BREG in system variables
        DEC     (HL)            ; decrement it
        POP     HL              ; restore pointer

        JR      NZ,L3687        ; to JUMP-2 if not zero

        INC     HL              ; step past the jump length.
        EXX                     ; switch in the main set.
        RET                     ; return.

; Note. as a general rule the calculator avoids using the IY register
; otherwise the cumbersome 4 instructions in the middle could be replaced by
; dec (iy+$2d) - three bytes instead of six.


; ---------------------
; THE 'JUMP' SUBROUTINE
; ---------------------
; (offset: $33 'jump')
;   This enables the calculator to perform relative jumps just like the Z80 
;   chip's JR instruction.

;; jump
;; JUMP
L3686:  EXX                     ; switch in pointer set

;; JUMP-2
L3687:  LD      E,(HL)          ; the jump byte 0-127 forward, 128-255 back.
        LD      A,E             ; transfer to accumulator.
        RLA                     ; if backward jump, carry is set.
        SBC     A,A             ; will be $FF if backward or $00 if forward.
        LD      D,A             ; transfer to high byte.
        ADD     HL,DE           ; advance calculator pointer forward or back.

        EXX                     ; switch back.
        RET                     ; return.

; --------------------------
; THE 'JUMP-TRUE' SUBROUTINE
; --------------------------
; (offset: $00 'jump-true')
;   This enables the calculator to perform conditional relative jumps dependent
;   on whether the last test gave a true result.

;; jump-true
L368F:  INC     DE              ; Collect the 
        INC     DE              ; third byte
        LD      A,(DE)          ; of the test
        DEC     DE              ; result and
        DEC     DE              ; backtrack.

        AND     A               ; Is result 0 or 1 ? 
        JR      NZ,L3686        ; Back to JUMP if true (1).

        EXX                     ; Else switch in the pointer set.
        INC     HL              ; Step past the jump length.
        EXX                     ; Switch in the main set.
        RET                     ; Return.

; -------------------------
; THE 'END-CALC' SUBROUTINE
; -------------------------
; (offset: $38 'end-calc')
;   The end-calc literal terminates a mini-program written in the Spectrum's
;   internal language.

;; end-calc
L369B:  POP     AF              ; Drop the calculator return address RE-ENTRY
        EXX                     ; Switch to the other set.

        EX      (SP),HL         ; Transfer H'L' to machine stack for the
                                ; return address.
                                ; When exiting recursion, then the previous
                                ; pointer is transferred to H'L'.

        EXX                     ; Switch back to main set.
        RET                     ; Return.


; ------------------------
; THE 'MODULUS' SUBROUTINE 
; ------------------------
; (offset: $32 'n-mod-m')
; (n1,n2 -- r,q)  
;   Similar to FORTH's 'divide mod' /MOD
;   On the Spectrum, this is only used internally by the RND function and could
;   have been implemented inline.  On the ZX81, this calculator routine was also
;   used by PRINT-FP.

;; n-mod-m
L36A0:  RST     28H             ;; FP-CALC          17, 3.
        DEFB    $C0             ;;st-mem-0          17, 3.
        DEFB    $02             ;;delete            17.
        DEFB    $31             ;;duplicate         17, 17.
        DEFB    $E0             ;;get-mem-0         17, 17, 3.
        DEFB    $05             ;;division          17, 17/3.
        DEFB    $27             ;;int               17, 5.
        DEFB    $E0             ;;get-mem-0         17, 5, 3.
        DEFB    $01             ;;exchange          17, 3, 5.
        DEFB    $C0             ;;st-mem-0          17, 3, 5.
        DEFB    $04             ;;multiply          17, 15.
        DEFB    $03             ;;subtract          2.
        DEFB    $E0             ;;get-mem-0         2, 5.
        DEFB    $38             ;;end-calc          2, 5.

        RET                     ; return.


; ------------------
; THE 'INT' FUNCTION
; ------------------
; (offset $27: 'int' )
; This function returns the integer of x, which is just the same as truncate
; for positive numbers. The truncate literal truncates negative numbers
; upwards so that -3.4 gives -3 whereas the BASIC INT function has to
; truncate negative numbers down so that INT -3.4 is -4.
; It is best to work through using, say, +-3.4 as examples.

;; int
L36AF:  RST     28H             ;; FP-CALC              x.    (= 3.4 or -3.4).
        DEFB    $31             ;;duplicate             x, x.
        DEFB    $36             ;;less-0                x, (1/0)
        DEFB    $00             ;;jump-true             x, (1/0)
        DEFB    $04             ;;to L36B7, X-NEG

        DEFB    $3A             ;;truncate              trunc 3.4 = 3.
        DEFB    $38             ;;end-calc              3.

        RET                     ; return with + int x on stack.

; ---


;; X-NEG
L36B7:  DEFB    $31             ;;duplicate             -3.4, -3.4.
        DEFB    $3A             ;;truncate              -3.4, -3.
        DEFB    $C0             ;;st-mem-0              -3.4, -3.
        DEFB    $03             ;;subtract              -.4
        DEFB    $E0             ;;get-mem-0             -.4, -3.
        DEFB    $01             ;;exchange              -3, -.4.
        DEFB    $30             ;;not                   -3, (0).
        DEFB    $00             ;;jump-true             -3.
        DEFB    $03             ;;to L36C2, EXIT        -3.

        DEFB    $A1             ;;stk-one               -3, 1.
        DEFB    $03             ;;subtract              -4.

;; EXIT
L36C2:  DEFB    $38             ;;end-calc              -4.

        RET                     ; return.


; ------------------
; THE 'EXP' FUNCTION
; ------------------
; (offset $26: 'exp')
;   The exponential function EXP x is equal to e^x, where e is the mathematical
;   name for a number approximated to 2.718281828.
;   ERROR 6 if argument is more than about 88.

;; EXP
;; exp
L36C4:  RST     28H             ;; FP-CALC
        DEFB    $3D             ;;re-stack      (not required - mult will do)
        DEFB    $34             ;;stk-data
        DEFB    $F1             ;;Exponent: $81, Bytes: 4
        DEFB    $38,$AA,$3B,$29 ;;
        DEFB    $04             ;;multiply
        DEFB    $31             ;;duplicate
        DEFB    $27             ;;int
        DEFB    $C3             ;;st-mem-3
        DEFB    $03             ;;subtract
        DEFB    $31             ;;duplicate
        DEFB    $0F             ;;addition
        DEFB    $A1             ;;stk-one
        DEFB    $03             ;;subtract
        DEFB    $88             ;;series-08
        DEFB    $13             ;;Exponent: $63, Bytes: 1
        DEFB    $36             ;;(+00,+00,+00)
        DEFB    $58             ;;Exponent: $68, Bytes: 2
        DEFB    $65,$66         ;;(+00,+00)
        DEFB    $9D             ;;Exponent: $6D, Bytes: 3
        DEFB    $78,$65,$40     ;;(+00)
        DEFB    $A2             ;;Exponent: $72, Bytes: 3
        DEFB    $60,$32,$C9     ;;(+00)
        DEFB    $E7             ;;Exponent: $77, Bytes: 4
        DEFB    $21,$F7,$AF,$24 ;;
        DEFB    $EB             ;;Exponent: $7B, Bytes: 4
        DEFB    $2F,$B0,$B0,$14 ;;
        DEFB    $EE             ;;Exponent: $7E, Bytes: 4
        DEFB    $7E,$BB,$94,$58 ;;
        DEFB    $F1             ;;Exponent: $81, Bytes: 4
        DEFB    $3A,$7E,$F8,$CF ;;
        DEFB    $E3             ;;get-mem-3
        DEFB    $38             ;;end-calc

        CALL    L2DD5           ; routine FP-TO-A
        JR      NZ,L3705        ; to N-NEGTV

        JR      C,L3703         ; to REPORT-6b
                                ; 'Number too big'

        ADD     A,(HL)          ;
        JR      NC,L370C        ; to RESULT-OK


;; REPORT-6b
L3703:  RST     08H             ; ERROR-1
        DEFB    $05             ; Error Report: Number too big

; ---

;; N-NEGTV
L3705:  JR      C,L370E         ; to RSLT-ZERO

        SUB     (HL)            ;
        JR      NC,L370E        ; to RSLT-ZERO

        NEG                     ; Negate

;; RESULT-OK
L370C:  LD      (HL),A          ;
        RET                     ; return.

; ---


;; RSLT-ZERO
L370E:  RST     28H             ;; FP-CALC
        DEFB    $02             ;;delete
        DEFB    $A0             ;;stk-zero
        DEFB    $38             ;;end-calc

        RET                     ; return.


; --------------------------------
; THE 'NATURAL LOGARITHM' FUNCTION 
; --------------------------------
; (offset $25: 'ln')
;   Function to calculate the natural logarithm (to the base e ). 
;   Natural logarithms were devised in 1614 by well-traveled Scotsman John 
;   Napier who noted
;   "Nothing doth more molest and hinder calculators than the multiplications,
;    divisions, square and cubical extractions of great numbers".
;
;   Napier's logarithms enabled the above operations to be accomplished by 
;   simple addition and subtraction simplifying the navigational and 
;   astronomical calculations which beset his age.
;   Napier's logarithms were quickly overtaken by logarithms to the base 10
;   devised, in conjunction with Napier, by Henry Briggs a Cambridge-educated 
;   professor of Geometry at Oxford University. These simplified the layout
;   of the tables enabling humans to easily scale calculations.
;
;   It is only recently with the introduction of pocket calculators and machines
;   like the ZX Spectrum that natural logarithms are once more at the fore,
;   although some computers retain logarithms to the base ten.
;
;   'Natural' logarithms are powers to the base 'e', which like 'pi' is a 
;   naturally occurring number in branches of mathematics.
;   Like 'pi' also, 'e' is an irrational number and starts 2.718281828...
;
;   The tabular use of logarithms was that to multiply two numbers one looked
;   up their two logarithms in the tables, added them together and then looked 
;   for the result in a table of antilogarithms to give the desired product.
;
;   The EXP function is the BASIC equivalent of a calculator's 'antiln' function 
;   and by picking any two numbers, 1.72 and 6.89 say,
;     10 PRINT EXP ( LN 1.72 + LN 6.89 ) 
;   will give just the same result as
;     20 PRINT 1.72 * 6.89.
;   Division is accomplished by subtracting the two logs.
;
;   Napier also mentioned "square and cubicle extractions". 
;   To raise a number to the power 3, find its 'ln', multiply by 3 and find the 
;   'antiln'.  e.g. PRINT EXP( LN 4 * 3 )  gives 64.
;   Similarly to find the n'th root divide the logarithm by 'n'.
;   The ZX81 ROM used PRINT EXP ( LN 9 / 2 ) to find the square root of the 
;   number 9. The Napieran square root function is just a special case of 
;   the 'to_power' function. A cube root or indeed any root/power would be just
;   as simple.

;   First test that the argument to LN is a positive, non-zero number.
;   Error A if the argument is 0 or negative.

;; ln
L3713:  RST     28H             ;; FP-CALC
        DEFB    $3D             ;;re-stack
        DEFB    $31             ;;duplicate
        DEFB    $37             ;;greater-0
        DEFB    $00             ;;jump-true
        DEFB    $04             ;;to L371C, VALID

        DEFB    $38             ;;end-calc


;; REPORT-Ab
L371A:  RST     08H             ; ERROR-1
        DEFB    $09             ; Error Report: Invalid argument

;; VALID
L371C:  DEFB    $A0             ;;stk-zero              Note. not 
        DEFB    $02             ;;delete                necessary.
        DEFB    $38             ;;end-calc
        LD      A,(HL)          ;

        LD      (HL),$80        ;
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC
        DEFB    $34             ;;stk-data
        DEFB    $38             ;;Exponent: $88, Bytes: 1
        DEFB    $00             ;;(+00,+00,+00)
        DEFB    $03             ;;subtract
        DEFB    $01             ;;exchange
        DEFB    $31             ;;duplicate
        DEFB    $34             ;;stk-data
        DEFB    $F0             ;;Exponent: $80, Bytes: 4
        DEFB    $4C,$CC,$CC,$CD ;;
        DEFB    $03             ;;subtract
        DEFB    $37             ;;greater-0
        DEFB    $00             ;;jump-true
        DEFB    $08             ;;to L373D, GRE.8

        DEFB    $01             ;;exchange
        DEFB    $A1             ;;stk-one
        DEFB    $03             ;;subtract
        DEFB    $01             ;;exchange
        DEFB    $38             ;;end-calc

        INC     (HL)            ;

        RST     28H             ;; FP-CALC

;; GRE.8
L373D:  DEFB    $01             ;;exchange
        DEFB    $34             ;;stk-data
        DEFB    $F0             ;;Exponent: $80, Bytes: 4
        DEFB    $31,$72,$17,$F8 ;;
        DEFB    $04             ;;multiply
        DEFB    $01             ;;exchange
        DEFB    $A2             ;;stk-half
        DEFB    $03             ;;subtract
        DEFB    $A2             ;;stk-half
        DEFB    $03             ;;subtract
        DEFB    $31             ;;duplicate
        DEFB    $34             ;;stk-data
        DEFB    $32             ;;Exponent: $82, Bytes: 1
        DEFB    $20             ;;(+00,+00,+00)
        DEFB    $04             ;;multiply
        DEFB    $A2             ;;stk-half
        DEFB    $03             ;;subtract
        DEFB    $8C             ;;series-0C
        DEFB    $11             ;;Exponent: $61, Bytes: 1
        DEFB    $AC             ;;(+00,+00,+00)
        DEFB    $14             ;;Exponent: $64, Bytes: 1
        DEFB    $09             ;;(+00,+00,+00)
        DEFB    $56             ;;Exponent: $66, Bytes: 2
        DEFB    $DA,$A5         ;;(+00,+00)
        DEFB    $59             ;;Exponent: $69, Bytes: 2
        DEFB    $30,$C5         ;;(+00,+00)
        DEFB    $5C             ;;Exponent: $6C, Bytes: 2
        DEFB    $90,$AA         ;;(+00,+00)
        DEFB    $9E             ;;Exponent: $6E, Bytes: 3
        DEFB    $70,$6F,$61     ;;(+00)
        DEFB    $A1             ;;Exponent: $71, Bytes: 3
        DEFB    $CB,$DA,$96     ;;(+00)
        DEFB    $A4             ;;Exponent: $74, Bytes: 3
        DEFB    $31,$9F,$B4     ;;(+00)
        DEFB    $E7             ;;Exponent: $77, Bytes: 4
        DEFB    $A0,$FE,$5C,$FC ;;
        DEFB    $EA             ;;Exponent: $7A, Bytes: 4
        DEFB    $1B,$43,$CA,$36 ;;
        DEFB    $ED             ;;Exponent: $7D, Bytes: 4
        DEFB    $A7,$9C,$7E,$5E ;;
        DEFB    $F0             ;;Exponent: $80, Bytes: 4
        DEFB    $6E,$23,$80,$93 ;;
        DEFB    $04             ;;multiply
        DEFB    $0F             ;;addition
        DEFB    $38             ;;end-calc

        RET                     ; return.


; -----------------------------
; THE 'TRIGONOMETRIC' FUNCTIONS
; -----------------------------
; Trigonometry is rocket science. It is also used by carpenters and pyramid
; builders. 
; Some uses can be quite abstract but the principles can be seen in simple
; right-angled triangles. Triangles have some special properties -
;
; 1) The sum of the three angles is always PI radians (180 degrees).
;    Very helpful if you know two angles and wish to find the third.
; 2) In any right-angled triangle the sum of the squares of the two shorter
;    sides is equal to the square of the longest side opposite the right-angle.
;    Very useful if you know the length of two sides and wish to know the
;    length of the third side.
; 3) Functions sine, cosine and tangent enable one to calculate the length 
;    of an unknown side when the length of one other side and an angle is 
;    known.
; 4) Functions arcsin, arccosine and arctan enable one to calculate an unknown
;    angle when the length of two of the sides is known.

; --------------------------------
; THE 'REDUCE ARGUMENT' SUBROUTINE
; --------------------------------
; (offset $39: 'get-argt')
;
; This routine performs two functions on the angle, in radians, that forms
; the argument to the sine and cosine functions.
; First it ensures that the angle 'wraps round'. That if a ship turns through 
; an angle of, say, 3*PI radians (540 degrees) then the net effect is to turn 
; through an angle of PI radians (180 degrees).
; Secondly it converts the angle in radians to a fraction of a right angle,
; depending within which quadrant the angle lies, with the periodicity 
; resembling that of the desired sine value.
; The result lies in the range -1 to +1.              
;
;                     90 deg.
; 
;                     (pi/2)
;              II       +1        I
;                       |
;        sin+      |\   |   /|    sin+
;        cos-      | \  |  / |    cos+
;        tan-      |  \ | /  |    tan+
;                  |   \|/)  |           
; 180 deg. (pi) 0 -|----+----|-- 0  (0)   0 degrees
;                  |   /|\   |
;        sin-      |  / | \  |    sin-
;        cos-      | /  |  \ |    cos+
;        tan+      |/   |   \|    tan-
;                       |
;              III      -1       IV
;                     (3pi/2)
;
;                     270 deg.
;

;; get-argt
L3783:  RST     28H             ;; FP-CALC      X.
        DEFB    $3D             ;;re-stack      (not rquired done by mult)
        DEFB    $34             ;;stk-data
        DEFB    $EE             ;;Exponent: $7E, 
                                ;;Bytes: 4
        DEFB    $22,$F9,$83,$6E ;;              X, 1/(2*PI)
        DEFB    $04             ;;multiply      X/(2*PI) = fraction
        DEFB    $31             ;;duplicate
        DEFB    $A2             ;;stk-half
        DEFB    $0F             ;;addition
        DEFB    $27             ;;int

        DEFB    $03             ;;subtract      now range -.5 to .5

        DEFB    $31             ;;duplicate
        DEFB    $0F             ;;addition      now range -1 to 1.
        DEFB    $31             ;;duplicate
        DEFB    $0F             ;;addition      now range -2 to +2.

; quadrant I (0 to +1) and quadrant IV (-1 to 0) are now correct.
; quadrant II ranges +1 to +2.
; quadrant III ranges -2 to -1.

        DEFB    $31             ;;duplicate     Y, Y.
        DEFB    $2A             ;;abs           Y, abs(Y).    range 1 to 2
        DEFB    $A1             ;;stk-one       Y, abs(Y), 1.
        DEFB    $03             ;;subtract      Y, abs(Y)-1.  range 0 to 1
        DEFB    $31             ;;duplicate     Y, Z, Z.
        DEFB    $37             ;;greater-0     Y, Z, (1/0).

        DEFB    $C0             ;;st-mem-0         store as possible sign 
                                ;;                 for cosine function.

        DEFB    $00             ;;jump-true
        DEFB    $04             ;;to L37A1, ZPLUS  with quadrants II and III.

; else the angle lies in quadrant I or IV and value Y is already correct.

        DEFB    $02             ;;delete        Y.   delete the test value.
        DEFB    $38             ;;end-calc      Y.

        RET                     ; return.       with Q1 and Q4           >>>

; ---

; the branch was here with quadrants II (0 to 1) and III (1 to 0).
; Y will hold -2 to -1 if this is quadrant III.

;; ZPLUS
L37A1:  DEFB    $A1             ;;stk-one         Y, Z, 1.
        DEFB    $03             ;;subtract        Y, Z-1.       Q3 = 0 to -1
        DEFB    $01             ;;exchange        Z-1, Y.
        DEFB    $36             ;;less-0          Z-1, (1/0).
        DEFB    $00             ;;jump-true       Z-1.
        DEFB    $02             ;;to L37A8, YNEG
                                ;;if angle in quadrant III

; else angle is within quadrant II (-1 to 0)

        DEFB    $1B             ;;negate          range +1 to 0.

;; YNEG
L37A8:  DEFB    $38             ;;end-calc        quadrants II and III correct.

        RET                     ; return.


; ---------------------
; THE 'COSINE' FUNCTION
; ---------------------
; (offset $20: 'cos')
; Cosines are calculated as the sine of the opposite angle rectifying the 
; sign depending on the quadrant rules. 
;
;
;           /|
;        h /y|
;         /  |o
;        /x  |
;       /----|    
;         a
;
; The cosine of angle x is the adjacent side (a) divided by the hypotenuse 1.
; However if we examine angle y then a/h is the sine of that angle.
; Since angle x plus angle y equals a right-angle, we can find angle y by 
; subtracting angle x from pi/2.
; However it's just as easy to reduce the argument first and subtract the
; reduced argument from the value 1 (a reduced right-angle).
; It's even easier to subtract 1 from the angle and rectify the sign.
; In fact, after reducing the argument, the absolute value of the argument
; is used and rectified using the test result stored in mem-0 by 'get-argt'
; for that purpose.
;

;; cos
L37AA:  RST     28H             ;; FP-CALC              angle in radians.
        DEFB    $39             ;;get-argt              X     reduce -1 to +1 

        DEFB    $2A             ;;abs                   ABS X.   0 to 1
        DEFB    $A1             ;;stk-one               ABS X, 1.
        DEFB    $03             ;;subtract              now opposite angle
                                ;;                      although sign is -ve.

        DEFB    $E0             ;;get-mem-0             fetch the sign indicator
        DEFB    $00             ;;jump-true
        DEFB    $06             ;;fwd to L37B7, C-ENT
                                ;;forward to common code if in QII or QIII.

        DEFB    $1B             ;;negate                else make sign +ve.
        DEFB    $33             ;;jump
        DEFB    $03             ;;fwd to L37B7, C-ENT
                                ;; with quadrants I and IV.

; -------------------
; THE 'SINE' FUNCTION
; -------------------
; (offset $1F: 'sin')
; This is a fundamental transcendental function from which others such as cos
; and tan are directly, or indirectly, derived.
; It uses the series generator to produce Chebyshev polynomials.
;
;
;           /|
;        1 / |
;         /  |x
;        /a  |
;       /----|    
;         y
;
; The 'get-argt' function is designed to modify the angle and its sign 
; in line with the desired sine value and afterwards it can launch straight
; into common code.

;; sin
L37B5:  RST     28H             ;; FP-CALC      angle in radians
        DEFB    $39             ;;get-argt      reduce - sign now correct.

;; C-ENT
L37B7:  DEFB    $31             ;;duplicate
        DEFB    $31             ;;duplicate
        DEFB    $04             ;;multiply
        DEFB    $31             ;;duplicate
        DEFB    $0F             ;;addition
        DEFB    $A1             ;;stk-one
        DEFB    $03             ;;subtract

        DEFB    $86             ;;series-06
        DEFB    $14             ;;Exponent: $64, Bytes: 1
        DEFB    $E6             ;;(+00,+00,+00)
        DEFB    $5C             ;;Exponent: $6C, Bytes: 2
        DEFB    $1F,$0B         ;;(+00,+00)
        DEFB    $A3             ;;Exponent: $73, Bytes: 3
        DEFB    $8F,$38,$EE     ;;(+00)
        DEFB    $E9             ;;Exponent: $79, Bytes: 4
        DEFB    $15,$63,$BB,$23 ;;
        DEFB    $EE             ;;Exponent: $7E, Bytes: 4
        DEFB    $92,$0D,$CD,$ED ;;
        DEFB    $F1             ;;Exponent: $81, Bytes: 4
        DEFB    $23,$5D,$1B,$EA ;;
        DEFB    $04             ;;multiply
        DEFB    $38             ;;end-calc

        RET                     ; return.

; ----------------------
; THE 'TANGENT' FUNCTION
; ----------------------
; (offset $21: 'tan')
;
; Evaluates tangent x as    sin(x) / cos(x).
;
;
;           /|
;        h / |
;         /  |o
;        /x  |
;       /----|    
;         a
;
; the tangent of angle x is the ratio of the length of the opposite side 
; divided by the length of the adjacent side. As the opposite length can 
; be calculates using sin(x) and the adjacent length using cos(x) then 
; the tangent can be defined in terms of the previous two functions.

; Error 6 if the argument, in radians, is too close to one like pi/2
; which has an infinite tangent. e.g. PRINT TAN (PI/2)  evaluates as 1/0.
; Similarly PRINT TAN (3*PI/2), TAN (5*PI/2) etc.

;; tan
L37DA:  RST     28H             ;; FP-CALC          x.
        DEFB    $31             ;;duplicate         x, x.
        DEFB    $1F             ;;sin               x, sin x.
        DEFB    $01             ;;exchange          sin x, x.
        DEFB    $20             ;;cos               sin x, cos x.
        DEFB    $05             ;;division          sin x/cos x (= tan x).
        DEFB    $38             ;;end-calc          tan x.

        RET                     ; return.

; ---------------------
; THE 'ARCTAN' FUNCTION
; ---------------------
; (Offset $24: 'atn')
; the inverse tangent function with the result in radians.
; This is a fundamental transcendental function from which others such as asn
; and acs are directly, or indirectly, derived.
; It uses the series generator to produce Chebyshev polynomials.

;; atn
L37E2:  CALL    L3297           ; routine re-stack
        LD      A,(HL)          ; fetch exponent byte.
        CP      $81             ; compare to that for 'one'
        JR      C,L37F8         ; forward, if less, to SMALL

        RST     28H             ;; FP-CALC
        DEFB    $A1             ;;stk-one
        DEFB    $1B             ;;negate
        DEFB    $01             ;;exchange
        DEFB    $05             ;;division
        DEFB    $31             ;;duplicate
        DEFB    $36             ;;less-0
        DEFB    $A3             ;;stk-pi/2
        DEFB    $01             ;;exchange
        DEFB    $00             ;;jump-true
        DEFB    $06             ;;to L37FA, CASES

        DEFB    $1B             ;;negate
        DEFB    $33             ;;jump
        DEFB    $03             ;;to L37FA, CASES

;; SMALL
L37F8:  RST     28H             ;; FP-CALC
        DEFB    $A0             ;;stk-zero

;; CASES
L37FA:  DEFB    $01             ;;exchange
        DEFB    $31             ;;duplicate
        DEFB    $31             ;;duplicate
        DEFB    $04             ;;multiply
        DEFB    $31             ;;duplicate
        DEFB    $0F             ;;addition
        DEFB    $A1             ;;stk-one
        DEFB    $03             ;;subtract
        DEFB    $8C             ;;series-0C
        DEFB    $10             ;;Exponent: $60, Bytes: 1
        DEFB    $B2             ;;(+00,+00,+00)
        DEFB    $13             ;;Exponent: $63, Bytes: 1
        DEFB    $0E             ;;(+00,+00,+00)
        DEFB    $55             ;;Exponent: $65, Bytes: 2
        DEFB    $E4,$8D         ;;(+00,+00)
        DEFB    $58             ;;Exponent: $68, Bytes: 2
        DEFB    $39,$BC         ;;(+00,+00)
        DEFB    $5B             ;;Exponent: $6B, Bytes: 2
        DEFB    $98,$FD         ;;(+00,+00)
        DEFB    $9E             ;;Exponent: $6E, Bytes: 3
        DEFB    $00,$36,$75     ;;(+00)
        DEFB    $A0             ;;Exponent: $70, Bytes: 3
        DEFB    $DB,$E8,$B4     ;;(+00)
        DEFB    $63             ;;Exponent: $73, Bytes: 2
        DEFB    $42,$C4         ;;(+00,+00)
        DEFB    $E6             ;;Exponent: $76, Bytes: 4
        DEFB    $B5,$09,$36,$BE ;;
        DEFB    $E9             ;;Exponent: $79, Bytes: 4
        DEFB    $36,$73,$1B,$5D ;;
        DEFB    $EC             ;;Exponent: $7C, Bytes: 4
        DEFB    $D8,$DE,$63,$BE ;;
        DEFB    $F0             ;;Exponent: $80, Bytes: 4
        DEFB    $61,$A1,$B3,$0C ;;
        DEFB    $04             ;;multiply
        DEFB    $0F             ;;addition
        DEFB    $38             ;;end-calc

        RET                     ; return.


; ---------------------
; THE 'ARCSIN' FUNCTION
; ---------------------
; (Offset $22: 'asn')
;   The inverse sine function with result in radians.
;   Derived from arctan function above.
;   Error A unless the argument is between -1 and +1 inclusive.
;   Uses an adaptation of the formula asn(x) = atn(x/sqr(1-x*x))
;
;
;                 /|
;                / |
;              1/  |x
;              /a  |
;             /----|    
;               y
;
;   e.g. We know the opposite side (x) and hypotenuse (1) 
;   and we wish to find angle a in radians.
;   We can derive length y by Pythagoras and then use ATN instead. 
;   Since y*y + x*x = 1*1 (Pythagoras Theorem) then
;   y=sqr(1-x*x)                         - no need to multiply 1 by itself.
;   So, asn(a) = atn(x/y)
;   or more fully,
;   asn(a) = atn(x/sqr(1-x*x))

;   Close but no cigar.

;   While PRINT ATN (x/SQR (1-x*x)) gives the same results as PRINT ASN x,
;   it leads to division by zero when x is 1 or -1.
;   To overcome this, 1 is added to y giving half the required angle and the 
;   result is then doubled. 
;   That is, PRINT ATN (x/(SQR (1-x*x) +1)) *2
;
;   GEOMETRIC PROOF.
;
;
;               . /|
;            .  c/ |
;         .     /1 |x
;      . c   b /a  |
;    ---------/----|    
;      1      y
;
;   By creating an isosceles triangle with two equal sides of 1, angles c and 
;   c are also equal. If b+c+c = 180 degrees and b+a = 180 degrees then c=a/2.
;
;   A value higher than 1 gives the required error as attempting to find  the
;   square root of a negative number generates an error in Sinclair BASIC.

;; asn
L3833:  RST     28H             ;; FP-CALC      x.
        DEFB    $31             ;;duplicate     x, x.
        DEFB    $31             ;;duplicate     x, x, x.
        DEFB    $04             ;;multiply      x, x*x.
        DEFB    $A1             ;;stk-one       x, x*x, 1.
        DEFB    $03             ;;subtract      x, x*x-1.
        DEFB    $1B             ;;negate        x, 1-x*x.
        DEFB    $28             ;;sqr           x, sqr(1-x*x) = y
        DEFB    $A1             ;;stk-one       x, y, 1.
        DEFB    $0F             ;;addition      x, y+1.
        DEFB    $05             ;;division      x/y+1.
        DEFB    $24             ;;atn           a/2       (half the angle)
        DEFB    $31             ;;duplicate     a/2, a/2.
        DEFB    $0F             ;;addition      a.
        DEFB    $38             ;;end-calc      a.

        RET                     ; return.


; ---------------------
; THE 'ARCCOS' FUNCTION
; ---------------------
; (Offset $23: 'acs')
; the inverse cosine function with the result in radians.
; Error A unless the argument is between -1 and +1.
; Result in range 0 to pi.
; Derived from asn above which is in turn derived from the preceding atn.
; It could have been derived directly from atn using acs(x) = atn(sqr(1-x*x)/x).
; However, as sine and cosine are horizontal translations of each other,
; uses acs(x) = pi/2 - asn(x)

; e.g. the arccosine of a known x value will give the required angle b in 
; radians.
; We know, from above, how to calculate the angle a using asn(x). 
; Since the three angles of any triangle add up to 180 degrees, or pi radians,
; and the largest angle in this case is a right-angle (pi/2 radians), then
; we can calculate angle b as pi/2 (both angles) minus asn(x) (angle a).
; 
;
;           /|
;        1 /b|
;         /  |x
;        /a  |
;       /----|    
;         y
;

;; acs
L3843:  RST     28H             ;; FP-CALC      x.
        DEFB    $22             ;;asn           asn(x).
        DEFB    $A3             ;;stk-pi/2      asn(x), pi/2.
        DEFB    $03             ;;subtract      asn(x) - pi/2.
        DEFB    $1B             ;;negate        pi/2 -asn(x)  =  acs(x).
        DEFB    $38             ;;end-calc      acs(x).

        RET                     ; return.


; --------------------------
; THE 'SQUARE ROOT' FUNCTION
; --------------------------
; (Offset $28: 'sqr')
; This routine is remarkable for its brevity - 7 bytes.
; It wasn't written here but in the ZX81 where the programmers had to squeeze
; a bulky operating system into an 8K ROM. It simply calculates 
; the square root by stacking the value .5 and continuing into the 'to-power'
; routine. With more space available the much faster Newton-Raphson method
; could have been used as on the Jupiter Ace.

;; sqr
L384A:  RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate
        DEFB    $30             ;;not
        DEFB    $00             ;;jump-true
        DEFB    $1E             ;;to L386C, LAST

        DEFB    $A2             ;;stk-half
        DEFB    $38             ;;end-calc


; ------------------------------
; THE 'EXPONENTIATION' OPERATION
; ------------------------------
; (Offset $06: 'to-power')
; This raises the first number X to the power of the second number Y.
; As with the ZX80,
; 0 ^ 0 = 1.
; 0 ^ +n = 0.
; 0 ^ -n = arithmetic overflow.
;

;; to-power
L3851:  RST     28H             ;; FP-CALC              X, Y.
        DEFB    $01             ;;exchange              Y, X.
        DEFB    $31             ;;duplicate             Y, X, X.
        DEFB    $30             ;;not                   Y, X, (1/0).
        DEFB    $00             ;;jump-true
        DEFB    $07             ;;to L385D, XIS0   if X is zero.

;   else X is non-zero. Function 'ln' will catch a negative value of X.

        DEFB    $25             ;;ln                    Y, LN X.
        DEFB    $04             ;;multiply              Y * LN X.
        DEFB    $38             ;;end-calc

        JP      L36C4           ; jump back to EXP routine   ->

; ---

;   these routines form the three simple results when the number is zero.
;   begin by deleting the known zero to leave Y the power factor.

;; XIS0
L385D:  DEFB    $02             ;;delete                Y.
        DEFB    $31             ;;duplicate             Y, Y.
        DEFB    $30             ;;not                   Y, (1/0).
        DEFB    $00             ;;jump-true
        DEFB    $09             ;;to L386A, ONE         if Y is zero.

        DEFB    $A0             ;;stk-zero              Y, 0.
        DEFB    $01             ;;exchange              0, Y.
        DEFB    $37             ;;greater-0             0, (1/0).
        DEFB    $00             ;;jump-true             0.
        DEFB    $06             ;;to L386C, LAST        if Y was any positive 
                                ;;                      number.

;   else force division by zero thereby raising an Arithmetic overflow error.
;   There are some one and two-byte alternatives but perhaps the most formal
;   might have been to use end-calc; rst 08; defb 05.

        DEFB    $A1             ;;stk-one               0, 1.
        DEFB    $01             ;;exchange              1, 0.
        DEFB    $05             ;;division              1/0        ouch!

; ---

;; ONE
L386A:  DEFB    $02             ;;delete                .
        DEFB    $A1             ;;stk-one               1.

;; LAST
L386C:  DEFB    $38             ;;end-calc              last value is 1 or 0.

        RET                     ; return.               

;   "Everything should be made as simple as possible, but not simpler"
;   - Albert Einstein, 1879-1955.
