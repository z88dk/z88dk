;***********************************
;** Part 8. EXPRESSION EVALUATION **
;***********************************

        PUBLIC L24FB
        PUBLIC L2530
        PUBLIC L28B2
        PUBLIC L2996
        PUBLIC L2AB2
        PUBLIC L2AB6
        PUBLIC L2AFF
        PUBLIC L2BF1
        PUBLIC L2C02
        PUBLIC L2C8D
        PUBLIC L2D1B
        PUBLIC L2D28
        PUBLIC L2D2B
        PUBLIC L2D3B

        EXTERN L0018
        EXTERN L0074
        EXTERN L0077
        EXTERN L028E
        EXTERN L031E
        EXTERN L0333
        EXTERN L1655
        EXTERN L16DC
        EXTERN L198B
        EXTERN L19B8
        EXTERN L19E8
        EXTERN L1BEE
        EXTERN L1C2E
        EXTERN L1C79
        EXTERN L1C82
        EXTERN L1C8A
        EXTERN L1D86
        EXTERN L1E99
        EXTERN L1F15
        EXTERN L22CB
        EXTERN L2307
        EXTERN L2D4F
        EXTERN L2DA2
        EXTERN L2DD5
        EXTERN L30A9
        EXTERN L31AD
        EXTERN L33A9
        EXTERN L33B4
        EXTERN L33C0

; It is a this stage of the ROM that the Spectrum ceases altogether to be
; just a colourful novelty. One remarkable feature is that in all previous
; commands when the Spectrum is expecting a number or a string then an
; expression of the same type can be substituted ad infinitum.
; This is the routine that evaluates that expression.
; This is what causes 2 + 2 to give the answer 4.
; That is quite easy to understand. However you don't have to make it much
; more complex to start a remarkable juggling act.
; e.g. PRINT 2 * (VAL "2+2" + TAN 3)
; In fact, provided there is enough free RAM, the Spectrum can evaluate
; an expression of unlimited complexity.
; Apart from a couple of minor glitches, which you can now correct, the
; system is remarkably robust.


; ---------------------------------
; Scan expression or sub-expression
; ---------------------------------
;
;

;; SCANNING
L24FB:  RST     18H             ; GET-CHAR
        LD      B,$00           ; priority marker zero is pushed on stack
                                ; to signify end of expression when it is
                                ; popped off again.
        PUSH    BC              ; put in on stack.
                                ; and proceed to consider the first character
                                ; of the expression.

;; S-LOOP-1
L24FF:  LD      C,A             ; store the character while a look up is done.
        LD      HL,L2596        ; Address: scan-func
        CALL    L16DC           ; routine INDEXER is called to see if it is
                                ; part of a limited range '+', '(', 'ATTR' etc.

        LD      A,C             ; fetch the character back
        JP      NC,L2684        ; jump forward to S-ALPHNUM if not in primary
                                ; operators and functions to consider in the
                                ; first instance a digit or a variable and
                                ; then anything else.                >>>

        LD      B,$00           ; but here if it was found in table so
        LD      C,(HL)          ; fetch offset from table and make B zero.
        ADD     HL,BC           ; add the offset to position found
        JP      (HL)            ; and jump to the routine e.g. S-BIN
                                ; making an indirect exit from there.

; -------------------------------------------------------------------------
; The four service subroutines for routines in the scanning function table
; -------------------------------------------------------------------------

; PRINT """Hooray!"" he cried."

;; S-QUOTE-S
L250F:  CALL    L0074           ; routine CH-ADD+1 points to next character
                                ; and fetches that character.
        INC     BC              ; increase length counter.
        CP      $0D             ; is it carriage return ?
                                ; inside a quote.
        JP      Z,L1C8A         ; jump back to REPORT-C if so.
                                ; 'Nonsense in BASIC'.

        CP      $22             ; is it a quote '"' ?
        JR      NZ,L250F        ; back to S-QUOTE-S if not for more.

        CALL    L0074           ; routine CH-ADD+1
        CP      $22             ; compare with possible adjacent quote
        RET                     ; return. with zero set if two together.

; ---

; This subroutine is used to get two coordinate expressions for the three
; functions SCREEN$, ATTR and POINT that have two fixed parameters and
; therefore require surrounding braces.

;; S-2-COORD
L2522:  RST     20H             ; NEXT-CHAR
        CP      $28             ; is it the opening '(' ?
        JR      NZ,L252D        ; forward to S-RPORT-C if not
                                ; 'Nonsense in BASIC'.

        CALL    L1C79           ; routine NEXT-2NUM gets two comma-separated
                                ; numeric expressions. Note. this could cause
                                ; many more recursive calls to SCANNING but
                                ; the parent function will be evaluated fully
                                ; before rejoining the main juggling act.

        RST     18H             ; GET-CHAR
        CP      $29             ; is it the closing ')' ?

;; S-RPORT-C
L252D:  JP      NZ,L1C8A        ; jump back to REPORT-C if not.
                                ; 'Nonsense in BASIC'.

; ------------
; Check syntax
; ------------
; This routine is called on a number of occasions to check if syntax is being
; checked or if the program is being run. To test the flag inline would use
; four bytes of code, but a call instruction only uses 3 bytes of code.

;; SYNTAX-Z
L2530:  BIT     7,(IY+$01)      ; test FLAGS  - checking syntax only ?
        RET                     ; return.

; ----------------
; Scanning SCREEN$
; ----------------
; This function returns the code of a bit-mapped character at screen
; position at line C, column B. It is unable to detect the mosaic characters
; which are not bit-mapped but detects the ASCII 32 - 127 range.
; The bit-mapped UDGs are ignored which is curious as it requires only a
; few extra bytes of code. As usual, anything to do with CHARS is weird.
; If no match is found a null string is returned.
; No actual check on ranges is performed - that's up to the BASIC programmer.
; No real harm can come from SCREEN$(255,255) although the BASIC manual
; says that invalid values will be trapped.
; Interestingly, in the Pitman pocket guide, 1984, Vickers says that the
; range checking will be performed. 

;; S-SCRN$-S
L2535:  CALL    L2307           ; routine STK-TO-BC.
        LD      HL,($5C36)      ; fetch address of CHARS.
        LD      DE,$0100        ; fetch offset to chr$ 32
        ADD     HL,DE           ; and find start of bitmaps.
                                ; Note. not inc h. ??
        LD      A,C             ; transfer line to A.
        RRCA                    ; multiply
        RRCA                    ; by
        RRCA                    ; thirty-two.
        AND     $E0             ; and with 11100000
        XOR     B               ; combine with column $00 - $1F
        LD      E,A             ; to give the low byte of top line
        LD      A,C             ; column to A range 00000000 to 00011111
        AND     $18             ; and with 00011000
        XOR     $40             ; xor with 01000000 (high byte screen start)
        LD      D,A             ; register DE now holds start address of cell.
        LD      B,$60           ; there are 96 characters in ASCII set.

;; S-SCRN-LP
L254F:  PUSH    BC              ; save count
        PUSH    DE              ; save screen start address
        PUSH    HL              ; save bitmap start
        LD      A,(DE)          ; first byte of screen to A
        XOR     (HL)            ; xor with corresponding character byte
        JR      Z,L255A         ; forward to S-SC-MTCH if they match
                                ; if inverse result would be $FF
                                ; if any other then mismatch

        INC     A               ; set to $00 if inverse
        JR      NZ,L2573        ; forward to S-SCR-NXT if a mismatch

        DEC     A               ; restore $FF

; a match has been found so seven more to test.

;; S-SC-MTCH
L255A:  LD      C,A             ; load C with inverse mask $00 or $FF
        LD      B,$07           ; count seven more bytes

;; S-SC-ROWS
L255D:  INC     D               ; increment screen address.
        INC     HL              ; increment bitmap address.
        LD      A,(DE)          ; byte to A
        XOR     (HL)            ; will give $00 or $FF (inverse)
        XOR     C               ; xor with inverse mask
        JR      NZ,L2573        ; forward to S-SCR-NXT if no match.

        DJNZ    L255D           ; back to S-SC-ROWS until all eight matched.

; continue if a match of all eight bytes was found

        POP     BC              ; discard the
        POP     BC              ; saved
        POP     BC              ; pointers
        LD      A,$80           ; the endpoint of character set
        SUB     B               ; subtract the counter
                                ; to give the code 32-127
        LD      BC,$0001        ; make one space in workspace.

        RST     30H             ; BC-SPACES creates the space sliding
                                ; the calculator stack upwards.
        LD      (DE),A          ; start is addressed by DE, so insert code
        JR      L257D           ; forward to S-SCR-STO

; ---

; the jump was here if no match and more bitmaps to test.

;; S-SCR-NXT
L2573:  POP     HL              ; restore the last bitmap start
        LD      DE,$0008        ; and prepare to add 8.
        ADD     HL,DE           ; now addresses next character bitmap.
        POP     DE              ; restore screen address
        POP     BC              ; and character counter in B
        DJNZ    L254F           ; back to S-SCRN-LP if more characters.

        LD      C,B             ; B is now zero, so BC now zero.

;; S-SCR-STO
L257D:  JP      L2AB2           ; to STK-STO-$ to store the string in
                                ; workspace or a string with zero length.
                                ; (value of DE doesn't matter in last case)

; Note. this exit seems correct but the general-purpose routine S-STRING
; that calls this one will also stack any of its string results so this
; leads to a double storing of the result in this case.
; The instruction at L257D should just be a RET.
; credit Stephen Kelly and others, 1982.

; -------------
; Scanning ATTR
; -------------
; This function subroutine returns the attributes of a screen location -
; a numeric result.
; Again it's up to the BASIC programmer to supply valid values of line/column.

;; S-ATTR-S
L2580:  CALL    L2307           ; routine STK-TO-BC fetches line to C,
                                ; and column to B.
        LD      A,C             ; line to A $00 - $17   (max 00010111)
        RRCA                    ; rotate
        RRCA                    ; bits
        RRCA                    ; left.
        LD      C,A             ; store in C as an intermediate value.

        AND     $E0             ; pick up bits 11100000 ( was 00011100 )
        XOR     B               ; combine with column $00 - $1F
        LD      L,A             ; low byte now correct.

        LD      A,C             ; bring back intermediate result from C
        AND     $03             ; mask to give correct third of
                                ; screen $00 - $02
        XOR     $58             ; combine with base address.
        LD      H,A             ; high byte correct.
        LD      A,(HL)          ; pick up the colour attribute.
        JP      L2D28           ; forward to STACK-A to store result
                                ; and make an indirect exit.

; -----------------------
; Scanning function table
; -----------------------
; This table is used by INDEXER routine to find the offsets to
; four operators and eight functions. e.g. $A8 is the token 'FN'.
; This table is used in the first instance for the first character of an
; expression or by a recursive call to SCANNING for the first character of
; any sub-expression. It eliminates functions that have no argument or
; functions that can have more than one argument and therefore require
; braces. By eliminating and dealing with these now it can later take a
; simplistic approach to all other functions and assume that they have
; one argument.
; Similarly by eliminating BIN and '.' now it is later able to assume that
; all numbers begin with a digit and that the presence of a number or
; variable can be detected by a call to ALPHANUM.
; By default all expressions are positive and the spurious '+' is eliminated
; now as in print +2. This should not be confused with the operator '+'.
; Note. this does allow a degree of nonsense to be accepted as in
; PRINT +"3 is the greatest.".
; An acquired programming skill is the ability to include brackets where
; they are not necessary.
; A bracket at the start of a sub-expression may be spurious or necessary
; to denote that the contained expression is to be evaluated as an entity.
; In either case this is dealt with by recursive calls to SCANNING.
; An expression that begins with a quote requires special treatment.

;; scan-func
L2596:  DEFB    $22, L25B3-ASMPC-1  ; $1C offset to S-QUOTE
        DEFB    '(', L25E8-ASMPC-1  ; $4F offset to S-BRACKET
        DEFB    '.', L268D-ASMPC-1  ; $F2 offset to S-DECIMAL
        DEFB    '+', L25AF-ASMPC-1  ; $12 offset to S-U-PLUS

        DEFB    $A8, L25F5-ASMPC-1  ; $56 offset to S-FN
        DEFB    $A5, L25F8-ASMPC-1  ; $57 offset to S-RND
        DEFB    $A7, L2627-ASMPC-1  ; $84 offset to S-PI
        DEFB    $A6, L2634-ASMPC-1  ; $8F offset to S-INKEY$
        DEFB    $C4, L268D-ASMPC-1  ; $E6 offset to S-BIN
        DEFB    $AA, L2668-ASMPC-1  ; $BF offset to S-SCREEN$
        DEFB    $AB, L2672-ASMPC-1  ; $C7 offset to S-ATTR
        DEFB    $A9, L267B-ASMPC-1  ; $CE offset to S-POINT

        DEFB    $00             ; zero end marker

; --------------------------
; Scanning function routines
; --------------------------
; These are the 11 subroutines accessed by the above table.
; S-BIN and S-DECIMAL are the same
; The 1-byte offset limits their location to within 255 bytes of their
; entry in the table.

; ->
;; S-U-PLUS
L25AF:  RST     20H             ; NEXT-CHAR just ignore
        JP      L24FF           ; to S-LOOP-1

; ---

; ->
;; S-QUOTE
L25B3:  RST     18H             ; GET-CHAR
        INC     HL              ; address next character (first in quotes)
        PUSH    HL              ; save start of quoted text.
        LD      BC,$0000        ; initialize length of string to zero.
        CALL    L250F           ; routine S-QUOTE-S
        JR      NZ,L25D9        ; forward to S-Q-PRMS if

;; S-Q-AGAIN
L25BE:  CALL    L250F           ; routine S-QUOTE-S copies string until a
                                ; quote is encountered
        JR      Z,L25BE         ; back to S-Q-AGAIN if two quotes WERE
                                ; together.

; but if just an isolated quote then that terminates the string.

        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L25D9         ; forward to S-Q-PRMS if checking syntax.


        RST     30H             ; BC-SPACES creates the space for true
                                ; copy of string in workspace.
        POP     HL              ; re-fetch start of quoted text.
        PUSH    DE              ; save start in workspace.

;; S-Q-COPY
L25CB:  LD      A,(HL)          ; fetch a character from source.
        INC     HL              ; advance source address.
        LD      (DE),A          ; place in destination.
        INC     DE              ; advance destination address.
        CP      $22             ; was it a '"' just copied ?
        JR      NZ,L25CB        ; back to S-Q-COPY to copy more if not

        LD      A,(HL)          ; fetch adjacent character from source.
        INC     HL              ; advance source address.
        CP      $22             ; is this '"' ? - i.e. two quotes together ?
        JR      Z,L25CB         ; to S-Q-COPY if so including just one of the
                                ; pair of quotes.

; proceed when terminating quote encountered.

;; S-Q-PRMS
L25D9:  DEC     BC              ; decrease count by 1.
        POP     DE              ; restore start of string in workspace.

;; S-STRING
L25DB:  LD      HL,$5C3B        ; Address FLAGS system variable.
        RES     6,(HL)          ; signal string result.
        BIT     7,(HL)          ; is syntax being checked.
        CALL    NZ,L2AB2        ; routine STK-STO-$ is called in runtime.
        JP      L2712           ; jump forward to S-CONT-2          ===>

; ---

; ->
;; S-BRACKET
L25E8:  RST     20H             ; NEXT-CHAR
        CALL    L24FB           ; routine SCANNING is called recursively.
        CP      $29             ; is it the closing ')' ?
        JP      NZ,L1C8A        ; jump back to REPORT-C if not
                                ; 'Nonsense in BASIC'

        RST     20H             ; NEXT-CHAR
        JP      L2712           ; jump forward to S-CONT-2          ===>

; ---

; ->
;; S-FN
L25F5:  JP      L27BD           ; jump forward to S-FN-SBRN.

; --------------------------------------------------------------------
;
;   RANDOM THEORY from the ZX81 manual by Steven Vickers
;
;   (same algorithm as the ZX Spectrum).
; 
;   Chapter 5. Exercise 6. (For mathematicians only.)
;
;   Let p be a [large] prime, & let a be a primitive root modulo p.
;   Then if b_i is the residue of a^i modulo p (1<=b_i<p-1), the 
;   sequence             
;   
;                           (b_i-1)/(p-1)
;               
;   is a cyclical sequence of p-1 distinct numbers in the range 0 to 1
;   (excluding 1). By choosing a suitably, these can be made to look 
;   fairly random.
;
;     65537 is a Mersenne prime 2^16-1. Note.
;
;   Use this, & Gauss' law of quadratic reciprocity, to show that 75 
;   is a primitive root modulo 65537.
;
;     The ZX81 uses p=65537 & a=75, & stores some b_i-1 in memory. 
;   The function RND involves replacing b_i-1 in memory by b_(i+1)-1, 
;   & yielding the result (b_(i+1)-1)/(p-1). RAND n (with 1<=n<=65535)
;   makes b_i equal to n+1.
;
; --------------------------------------------------------------------
;
; Steven Vickers writing in comp.sys.sinclair on 20-DEC-1993
; 
;   Note. (Of course, 65537 is 2^16 + 1, not -1.)
;
;   Consider arithmetic modulo a prime p. There are p residue classes, and the
;   non-zero ones are all invertible. Hence under multiplication they form a
;   group (Fp*, say) of order p-1; moreover (and not so obvious) Fp* is cyclic.
;   Its generators are the "primitive roots". The "quadratic residues modulo p"
;   are the squares in Fp*, and the "Legendre symbol" (d/p) is defined (when p
;   does not divide d) as +1 or -1, according as d is or is not a quadratic
;   residue mod p.
;
;   In the case when p = 65537, we can show that d is a primitive root if and
;   only if it's not a quadratic residue. For let w be a primitive root, d
;   congruent to w^r (mod p). If d is not primitive, then its order is a proper
;   factor of 65536: hence w^{32768*r} = 1 (mod p), so 65536 divides 32768*r,
;   and hence r is even and d is a square (mod p). Conversely, the squares in
;   Fp* form a subgroup of (Fp*)^2 of index 2, and so cannot be generators.
;
;   Hence to check whether 75 is primitive mod 65537, we want to calculate that
;   (75/65537) = -1. There is a multiplicative formula (ab/p) = (a/p)(b/p) (mod
;   p), so (75/65537) = (5/65537)^2 * (3/65537) = (3/65537). Now the law of
;   quadratic reciprocity says that if p and q are distinct odd primes, then
;
;    (p/q)(q/p) = (-1)^{(p-1)(q-1)/4}
;
;   Hence (3/65537) = (65537/3) * (-1)^{65536*2/4} = (65537/3)
;            = (2/3)  (because 65537 = 2 mod 3)
;            = -1
;
;   (I referred to Pierre Samuel's "Algebraic Theory of Numbers".)
;
; ->

;; S-RND
L25F8:  CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L2625         ; forward to S-RND-END if checking syntax.

        LD      BC,($5C76)      ; fetch system variable SEED
        CALL    L2D2B           ; routine STACK-BC places on calculator stack

        RST     28H             ;; FP-CALC           ;s.
        DEFB    $A1             ;;stk-one            ;s,1.
        DEFB    $0F             ;;addition           ;s+1.
        DEFB    $34             ;;stk-data           ;
        DEFB    $37             ;;Exponent: $87,
                                ;;Bytes: 1
        DEFB    $16             ;;(+00,+00,+00)      ;s+1,75.
        DEFB    $04             ;;multiply           ;(s+1)*75 = v
        DEFB    $34             ;;stk-data           ;v.
        DEFB    $80             ;;Bytes: 3
        DEFB    $41             ;;Exponent $91
        DEFB    $00,$00,$80     ;;(+00)              ;v,65537.
        DEFB    $32             ;;n-mod-m            ;remainder, result.
        DEFB    $02             ;;delete             ;remainder.
        DEFB    $A1             ;;stk-one            ;remainder, 1.
        DEFB    $03             ;;subtract           ;remainder - 1. = rnd
        DEFB    $31             ;;duplicate          ;rnd,rnd.
        DEFB    $38             ;;end-calc

        CALL    L2DA2           ; routine FP-TO-BC
        LD      ($5C76),BC      ; store in SEED for next starting point.
        LD      A,(HL)          ; fetch exponent
        AND     A               ; is it zero ?
        JR      Z,L2625         ; forward if so to S-RND-END

        SUB     $10             ; reduce exponent by 2^16
        LD      (HL),A          ; place back

;; S-RND-END
L2625:  JR      L2630           ; forward to S-PI-END

; ---

; the number PI 3.14159...

; ->
;; S-PI
L2627:  CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L2630         ; to S-PI-END if checking syntax.

        RST     28H             ;; FP-CALC
        DEFB    $A3             ;;stk-pi/2                          pi/2.
        DEFB    $38             ;;end-calc

        INC     (HL)            ; increment the exponent leaving pi
                                ; on the calculator stack.

;; S-PI-END
L2630:  RST     20H             ; NEXT-CHAR
        JP      L26C3           ; jump forward to S-NUMERIC

; ---

; ->
;; S-INKEY$
L2634:  LD      BC,$105A        ; priority $10, operation code $1A ('read-in')
                                ; +$40 for string result, numeric operand.
                                ; set this up now in case we need to use the
                                ; calculator.
        RST     20H             ; NEXT-CHAR
        CP      $23             ; '#' ?
        JP      Z,L270D         ; to S-PUSH-PO if so to use the calculator
                                ; single operation
                                ; to read from network/RS232 etc. .

; else read a key from the keyboard.

        LD      HL,$5C3B        ; fetch FLAGS
        RES     6,(HL)          ; signal string result.
        BIT     7,(HL)          ; checking syntax ?
        JR      Z,L2665         ; forward to S-INK$-EN if so

        CALL    L028E           ; routine KEY-SCAN key in E, shift in D.
        LD      C,$00           ; the length of an empty string
        JR      NZ,L2660        ; to S-IK$-STK to store empty string if
                                ; no key returned.

        CALL    L031E           ; routine K-TEST get main code in A
        JR      NC,L2660        ; to S-IK$-STK to stack null string if
                                ; invalid

        DEC     D               ; D is expected to be FLAGS so set bit 3 $FF
                                ; 'L' Mode so no keywords.
        LD      E,A             ; main key to A
                                ; C is MODE 0 'KLC' from above still.
        CALL    L0333           ; routine K-DECODE
        PUSH    AF              ; save the code
        LD      BC,$0001        ; make room for one character

        RST     30H             ; BC-SPACES
        POP     AF              ; bring the code back
        LD      (DE),A          ; put the key in workspace
        LD      C,$01           ; set C length to one

;; S-IK$-STK
L2660:  LD      B,$00           ; set high byte of length to zero
        CALL    L2AB2           ; routine STK-STO-$

;; S-INK$-EN
L2665:  JP      L2712           ; to S-CONT-2            ===>

; ---

; ->
;; S-SCREEN$
L2668:  CALL    L2522           ; routine S-2-COORD
        CALL    NZ,L2535        ; routine S-SCRN$-S

        RST     20H             ; NEXT-CHAR
        JP      L25DB           ; forward to S-STRING to stack result

; ---

; ->
;; S-ATTR
L2672:  CALL    L2522           ; routine S-2-COORD
        CALL    NZ,L2580        ; routine S-ATTR-S

        RST     20H             ; NEXT-CHAR
        JR      L26C3           ; forward to S-NUMERIC

; ---

; ->
;; S-POINT
L267B:  CALL    L2522           ; routine S-2-COORD
        CALL    NZ,L22CB        ; routine POINT-SUB

        RST     20H             ; NEXT-CHAR
        JR      L26C3           ; forward to S-NUMERIC

; -----------------------------

; ==> The branch was here if not in table.

;; S-ALPHNUM
L2684:  CALL    L2C88           ; routine ALPHANUM checks if variable or
                                ; a digit.
        JR      NC,L26DF        ; forward to S-NEGATE if not to consider
                                ; a '-' character then functions.

        CP      $41             ; compare 'A'
        JR      NC,L26C9        ; forward to S-LETTER if alpha       ->
                                ; else must have been numeric so continue
                                ; into that routine.

; This important routine is called during runtime and from LINE-SCAN
; when a BASIC line is checked for syntax. It is this routine that
; inserts, during syntax checking, the invisible floating point numbers
; after the numeric expression. During runtime it just picks these
; numbers up. It also handles BIN format numbers.

; ->
;; S-BIN
;; S-DECIMAL
L268D:  CALL    L2530           ; routine SYNTAX-Z
        JR      NZ,L26B5        ; to S-STK-DEC in runtime

; this route is taken when checking syntax.

        CALL    L2C9B           ; routine DEC-TO-FP to evaluate number

        RST     18H             ; GET-CHAR to fetch HL
        LD      BC,$0006        ; six locations required
        CALL    L1655           ; routine MAKE-ROOM
        INC     HL              ; to first new location
        LD      (HL),$0E        ; insert number marker
        INC     HL              ; address next
        EX      DE,HL           ; make DE destination.
        LD      HL,($5C65)      ; STKEND points to end of stack.
        LD      C,$05           ; result is five locations lower
        AND     A               ; prepare for true subtraction
        SBC     HL,BC           ; point to start of value.
        LD      ($5C65),HL      ; update STKEND as we are taking number.
        LDIR                    ; Copy five bytes to program location
        EX      DE,HL           ; transfer pointer to HL
        DEC     HL              ; adjust
        CALL    L0077           ; routine TEMP-PTR1 sets CH-ADD
        JR      L26C3           ; to S-NUMERIC to record nature of result

; ---

; branch here in runtime.

;; S-STK-DEC
L26B5:  RST     18H             ; GET-CHAR positions HL at digit.

;; S-SD-SKIP
L26B6:  INC     HL              ; advance pointer
        LD      A,(HL)          ; until we find
        CP      $0E             ; chr 14d - the number indicator
        JR      NZ,L26B6        ; to S-SD-SKIP until a match
                                ; it has to be here.

        INC     HL              ; point to first byte of number
        CALL    L33B4           ; routine STACK-NUM stacks it
        LD      ($5C5D),HL      ; update system variable CH_ADD

;; S-NUMERIC
L26C3:  SET     6,(IY+$01)      ; update FLAGS  - Signal numeric result
        JR      L26DD           ; forward to S-CONT-1               ===>
                                ; actually S-CONT-2 is destination but why
                                ; waste a byte on a jump when a JR will do.
                                ; Actually a JR L2712 can be used. Rats.

; end of functions accessed from scanning functions table.

; --------------------------
; Scanning variable routines
; --------------------------
;
;

;; S-LETTER
L26C9:  CALL    L28B2           ; routine LOOK-VARS

        JP      C,L1C2E         ; jump back to REPORT-2 if variable not found
                                ; 'Variable not found'
                                ; but a variable is always 'found' if syntax
                                ; is being checked.

        CALL    Z,L2996         ; routine STK-VAR considers a subscript/slice
        LD      A,($5C3B)       ; fetch FLAGS value
        CP      $C0             ; compare 11000000
        JR      C,L26DD         ; step forward to S-CONT-1 if string  ===>

        INC     HL              ; advance pointer
        CALL    L33B4           ; routine STACK-NUM

;; S-CONT-1
L26DD:  JR      L2712           ; forward to S-CONT-2                 ===>

; ----------------------------------------
; -> the scanning branch was here if not alphanumeric.
; All the remaining functions will be evaluated by a single call to the
; calculator. The correct priority for the operation has to be placed in
; the B register and the operation code, calculator literal in the C register.
; the operation code has bit 7 set if result is numeric and bit 6 is
; set if operand is numeric. so
; $C0 = numeric result, numeric operand.            e.g. 'sin'
; $80 = numeric result, string operand.             e.g. 'code'
; $40 = string result, numeric operand.             e.g. 'str$'
; $00 = string result, string operand.              e.g. 'val$'

;; S-NEGATE
L26DF:  LD      BC,$09DB        ; prepare priority 09, operation code $C0 + 
                                ; 'negate' ($1B) - bits 6 and 7 set for numeric
                                ; result and numeric operand.

        CP      $2D             ; is it '-' ?
        JR      Z,L270D         ; forward if so to S-PUSH-PO

        LD      BC,$1018        ; prepare priority $10, operation code 'val$' -
                                ; bits 6 and 7 reset for string result and
                                ; string operand.
        
        CP      $AE             ; is it 'VAL$' ?
        JR      Z,L270D         ; forward if so to S-PUSH-PO

        SUB     $AF             ; subtract token 'CODE' value to reduce
                                ; functions 'CODE' to 'NOT' although the
                                ; upper range is, as yet, unchecked.
                                ; valid range would be $00 - $14.

        JP      C,L1C8A         ; jump back to REPORT-C with anything else
                                ; 'Nonsense in BASIC'

        LD      BC,$04F0        ; prepare priority $04, operation $C0 + 
                                ; 'not' ($30)

        CP      $14             ; is it 'NOT'
        JR      Z,L270D         ; forward to S-PUSH-PO if so

        JP      NC,L1C8A        ; to REPORT-C if higher
                                ; 'Nonsense in BASIC'

        LD      B,$10           ; priority $10 for all the rest
        ADD     A,$DC           ; make range $DC - $EF
                                ; $C0 + 'code'($1C) thru 'chr$' ($2F)

        LD      C,A             ; transfer 'function' to C
        CP      $DF             ; is it 'sin' ?
        JR      NC,L2707        ; forward to S-NO-TO-$  with 'sin' through
                                ; 'chr$' as operand is numeric.

; all the rest 'cos' through 'chr$' give a numeric result except 'str$'
; and 'chr$'.

        RES     6,C             ; signal string operand for 'code', 'val' and
                                ; 'len'.

;; S-NO-TO-$
L2707:  CP      $EE             ; compare 'str$'
        JR      C,L270D         ; forward to S-PUSH-PO if lower as result
                                ; is numeric.

        RES     7,C             ; reset bit 7 of op code for 'str$', 'chr$'
                                ; as result is string.

; >> This is where they were all headed for.

;; S-PUSH-PO
L270D:  PUSH    BC              ; push the priority and calculator operation
                                ; code.

        RST     20H             ; NEXT-CHAR
        JP      L24FF           ; jump back to S-LOOP-1 to go round the loop
                                ; again with the next character.

; --------------------------------

; ===>  there were many branches forward to here

;   An important step after the evaluation of an expression is to test for
;   a string expression and allow it to be sliced.  If a numeric expression is 
;   followed by a '(' then the numeric expression is complete.
;   Since a string slice can itself be sliced then loop repeatedly 
;   e.g. (STR$ PI) (3 TO) (TO 2)    or "nonsense" (4 TO )

;; S-CONT-2
L2712:  RST     18H             ; GET-CHAR

;; S-CONT-3
L2713:  CP      $28             ; is it '(' ?
        JR      NZ,L2723        ; forward, if not, to S-OPERTR 

        BIT     6,(IY+$01)      ; test FLAGS - numeric or string result ?
        JR      NZ,L2734        ; forward, if numeric, to S-LOOP

;   if a string expression preceded the '(' then slice it.

        CALL    L2A52           ; routine SLICING

        RST     20H             ; NEXT-CHAR
        JR      L2713           ; loop back to S-CONT-3

; ---------------------------

;   the branch was here when possibility of a '(' has been excluded.

;; S-OPERTR
L2723:  LD      B,$00           ; prepare to add
        LD      C,A             ; possible operator to C
        LD      HL,L2795        ; Address: $2795 - tbl-of-ops
        CALL    L16DC           ; routine INDEXER
        JR      NC,L2734        ; forward to S-LOOP if not in table

;   but if found in table the priority has to be looked up.

        LD      C,(HL)          ; operation code to C ( B is still zero )
        LD      HL,L27B0 - $C3  ; $26ED is base of table
        ADD     HL,BC           ; index into table.
        LD      B,(HL)          ; priority to B.

; ------------------
; Scanning main loop
; ------------------
; the juggling act

;; S-LOOP
L2734:  POP     DE              ; fetch last priority and operation
        LD      A,D             ; priority to A
        CP      B               ; compare with this one
        JR      C,L2773         ; forward to S-TIGHTER to execute the
                                ; last operation before this one as it has
                                ; higher priority.

; the last priority was greater or equal this one.

        AND     A               ; if it is zero then so is this
        JP      Z,L0018         ; jump to exit via get-char pointing at
                                ; next character.
                                ; This may be the character after the
                                ; expression or, if exiting a recursive call,
                                ; the next part of the expression to be
                                ; evaluated.

        PUSH    BC              ; save current priority/operation
                                ; as it has lower precedence than the one
                                ; now in DE.

; the 'USR' function is special in that it is overloaded to give two types
; of result.

        LD      HL,$5C3B        ; address FLAGS
        LD      A,E             ; new operation to A register
        CP      $ED             ; is it $C0 + 'usr-no' ($2D)  ?
        JR      NZ,L274C        ; forward to S-STK-LST if not

        BIT     6,(HL)          ; string result expected ?
                                ; (from the lower priority operand we've
                                ; just pushed on stack )
        JR      NZ,L274C        ; forward to S-STK-LST if numeric
                                ; as operand bits match.

        LD      E,$99           ; reset bit 6 and substitute $19 'usr-$'
                                ; for string operand.

;; S-STK-LST
L274C:  PUSH    DE              ; now stack this priority/operation
        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L275B         ; forward to S-SYNTEST if checking syntax.

        LD      A,E             ; fetch the operation code
        AND     $3F             ; mask off the result/operand bits to leave
                                ; a calculator literal.
        LD      B,A             ; transfer to B register

; now use the calculator to perform the single operation - operand is on
; the calculator stack.
; Note. although the calculator is performing a single operation most
; functions e.g. TAN are written using other functions and literals and
; these in turn are written using further strings of calculator literals so
; another level of magical recursion joins the juggling act for a while
; as the calculator too is calling itself.

        RST     28H             ;; FP-CALC
        DEFB    $3B             ;;fp-calc-2
L2758:  DEFB    $38             ;;end-calc

        JR      L2764           ; forward to S-RUNTEST

; ---

; the branch was here if checking syntax only. 

;; S-SYNTEST
L275B:  LD      A,E             ; fetch the operation code to accumulator
        XOR     (IY+$01)        ; compare with bits of FLAGS
        AND     $40             ; bit 6 will be zero now if operand
                                ; matched expected result.

;; S-RPORT-C2
L2761:  JP      NZ,L1C8A        ; to REPORT-C if mismatch
                                ; 'Nonsense in BASIC'
                                ; else continue to set flags for next

; the branch is to here in runtime after a successful operation.

;; S-RUNTEST
L2764:  POP     DE              ; fetch the last operation from stack
        LD      HL,$5C3B        ; address FLAGS
        SET     6,(HL)          ; set default to numeric result in FLAGS
        BIT     7,E             ; test the operational result
        JR      NZ,L2770        ; forward to S-LOOPEND if numeric

        RES     6,(HL)          ; reset bit 6 of FLAGS to show string result.

;; S-LOOPEND
L2770:  POP     BC              ; fetch the previous priority/operation
        JR      L2734           ; back to S-LOOP to perform these

; ---

; the branch was here when a stacked priority/operator had higher priority
; than the current one.

;; S-TIGHTER
L2773:  PUSH    DE              ; save high priority op on stack again
        LD      A,C             ; fetch lower priority operation code
        BIT     6,(IY+$01)      ; test FLAGS - Numeric or string result ?
        JR      NZ,L2790        ; forward to S-NEXT if numeric result

; if this is lower priority yet has string then must be a comparison.
; Since these can only be evaluated in context and were defaulted to
; numeric in operator look up they must be changed to string equivalents.

        AND     $3F             ; mask to give true calculator literal
        ADD     A,$08           ; augment numeric literals to string
                                ; equivalents.
                                ; 'no-&-no'  => 'str-&-no'
                                ; 'no-l-eql' => 'str-l-eql'
                                ; 'no-gr-eq' => 'str-gr-eq'
                                ; 'nos-neql' => 'strs-neql'
                                ; 'no-grtr'  => 'str-grtr'
                                ; 'no-less'  => 'str-less'
                                ; 'nos-eql'  => 'strs-eql'
                                ; 'addition' => 'strs-add'
        LD      C,A             ; put modified comparison operator back
        CP      $10             ; is it now 'str-&-no' ?
        JR      NZ,L2788        ; forward to S-NOT-AND  if not.

        SET     6,C             ; set numeric operand bit
        JR      L2790           ; forward to S-NEXT

; ---

;; S-NOT-AND
L2788:  JR      C,L2761         ; back to S-RPORT-C2 if less
                                ; 'Nonsense in BASIC'.
                                ; e.g. a$ * b$

        CP      $17             ; is it 'strs-add' ?
        JR      Z,L2790         ; forward to S-NEXT if so
                                ; (bit 6 and 7 are reset)

        SET     7,C             ; set numeric (Boolean) result for all others

;; S-NEXT
L2790:  PUSH    BC              ; now save this priority/operation on stack

        RST     20H             ; NEXT-CHAR
        JP      L24FF           ; jump back to S-LOOP-1

; ------------------
; Table of operators
; ------------------
; This table is used to look up the calculator literals associated with
; the operator character. The thirteen calculator operations $03 - $0F
; have bits 6 and 7 set to signify a numeric result.
; Some of these codes and bits may be altered later if the context suggests
; a string comparison or operation.
; that is '+', '=', '>', '<', '<=', '>=' or '<>'.

;; tbl-of-ops
L2795:  DEFB    '+', $CF        ;        $C0 + 'addition'
        DEFB    '-', $C3        ;        $C0 + 'subtract'
        DEFB    '*', $C4        ;        $C0 + 'multiply'
        DEFB    '/', $C5        ;        $C0 + 'division'
        DEFB    '^', $C6        ;        $C0 + 'to-power'
        DEFB    '=', $CE        ;        $C0 + 'nos-eql'
        DEFB    '>', $CC        ;        $C0 + 'no-grtr'
        DEFB    '<', $CD        ;        $C0 + 'no-less'

        DEFB    $C7, $C9        ; '<='   $C0 + 'no-l-eql'
        DEFB    $C8, $CA        ; '>='   $C0 + 'no-gr-eql'
        DEFB    $C9, $CB        ; '<>'   $C0 + 'nos-neql'
        DEFB    $C5, $C7        ; 'OR'   $C0 + 'or'
        DEFB    $C6, $C8        ; 'AND'  $C0 + 'no-&-no'

        DEFB    $00             ; zero end-marker.


; -------------------
; Table of priorities
; -------------------
; This table is indexed with the operation code obtained from the above
; table $C3 - $CF to obtain the priority for the respective operation.

;; tbl-priors
L27B0:  DEFB    $06             ; '-'   opcode $C3
        DEFB    $08             ; '*'   opcode $C4
        DEFB    $08             ; '/'   opcode $C5
        DEFB    $0A             ; '^'   opcode $C6
        DEFB    $02             ; 'OR'  opcode $C7
        DEFB    $03             ; 'AND' opcode $C8
        DEFB    $05             ; '<='  opcode $C9
        DEFB    $05             ; '>='  opcode $CA
        DEFB    $05             ; '<>'  opcode $CB
        DEFB    $05             ; '>'   opcode $CC
        DEFB    $05             ; '<'   opcode $CD
        DEFB    $05             ; '='   opcode $CE
        DEFB    $06             ; '+'   opcode $CF

; ----------------------
; Scanning function (FN)
; ----------------------
; This routine deals with user-defined functions.
; The definition can be anywhere in the program area but these are best
; placed near the start of the program as we shall see.
; The evaluation process is quite complex as the Spectrum has to parse two
; statements at the same time. Syntax of both has been checked previously
; and hidden locations have been created immediately after each argument
; of the DEF FN statement. Each of the arguments of the FN function is
; evaluated by SCANNING and placed in the hidden locations. Then the
; expression to the right of the DEF FN '=' is evaluated by SCANNING and for
; any variables encountered, a search is made in the DEF FN variable list
; in the program area before searching in the normal variables area.
;
; Recursion is not allowed: i.e. the definition of a function should not use
; the same function, either directly or indirectly ( through another function).
; You'll normally get error 4, ('Out of memory'), although sometimes the system
; will crash. - Vickers, Pitman 1984.
;
; As the definition is just an expression, there would seem to be no means
; of breaking out of such recursion.
; However, by the clever use of string expressions and VAL, such recursion is
; possible.
; e.g. DEF FN a(n) = VAL "n+FN a(n-1)+0" ((n<1) * 10 + 1 TO )
; will evaluate the full 11-character expression for all values where n is
; greater than zero but just the 11th character, "0", when n drops to zero
; thereby ending the recursion producing the correct result.
; Recursive string functions are possible using VAL$ instead of VAL and the
; null string as the final addend.
; - from a turn of the century newsgroup discussion initiated by Mike Wynne.

;; S-FN-SBRN
L27BD:  CALL    L2530           ; routine SYNTAX-Z
        JR      NZ,L27F7        ; forward to SF-RUN in runtime


        RST     20H             ; NEXT-CHAR
        CALL    L2C8D           ; routine ALPHA check for letters A-Z a-z
        JP      NC,L1C8A        ; jump back to REPORT-C if not
                                ; 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR
        CP      $24             ; is it '$' ?
        PUSH    AF              ; save character and flags
        JR      NZ,L27D0        ; forward to SF-BRKT-1 with numeric function


        RST     20H             ; NEXT-CHAR

;; SF-BRKT-1
L27D0:  CP      $28             ; is '(' ?
        JR      NZ,L27E6        ; forward to SF-RPRT-C if not
                                ; 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR
        CP      $29             ; is it ')' ?
        JR      Z,L27E9         ; forward to SF-FLAG-6 if no arguments.

;; SF-ARGMTS
L27D9:  CALL    L24FB           ; routine SCANNING checks each argument
                                ; which may be an expression.

        RST     18H             ; GET-CHAR
        CP      $2C             ; is it a ',' ?
        JR      NZ,L27E4        ; forward if not to SF-BRKT-2 to test bracket


        RST     20H             ; NEXT-CHAR if a comma was found
        JR      L27D9           ; back to SF-ARGMTS to parse all arguments.

; ---

;; SF-BRKT-2
L27E4:  CP      $29             ; is character the closing ')' ?

;; SF-RPRT-C
L27E6:  JP      NZ,L1C8A        ; jump to REPORT-C
                                ; 'Nonsense in BASIC'

; at this point any optional arguments have had their syntax checked.

;; SF-FLAG-6
L27E9:  RST     20H             ; NEXT-CHAR
        LD      HL,$5C3B        ; address system variable FLAGS
        RES     6,(HL)          ; signal string result
        POP     AF              ; restore test against '$'.
        JR      Z,L27F4         ; forward to SF-SYN-EN if string function.

        SET     6,(HL)          ; signal numeric result

;; SF-SYN-EN
L27F4:  JP      L2712           ; jump back to S-CONT-2 to continue scanning.

; ---

; the branch was here in runtime.

;; SF-RUN
L27F7:  RST     20H             ; NEXT-CHAR fetches name
        AND     $DF             ; AND 11101111 - reset bit 5 - upper-case.
        LD      B,A             ; save in B

        RST     20H             ; NEXT-CHAR
        SUB     $24             ; subtract '$'
        LD      C,A             ; save result in C
        JR      NZ,L2802        ; forward if not '$' to SF-ARGMT1

        RST     20H             ; NEXT-CHAR advances to bracket

;; SF-ARGMT1
L2802:  RST     20H             ; NEXT-CHAR advances to start of argument
        PUSH    HL              ; save address
        LD      HL,($5C53)      ; fetch start of program area from PROG
        DEC     HL              ; the search starting point is the previous
                                ; location.

;; SF-FND-DF
L2808:  LD      DE,$00CE        ; search is for token 'DEF FN' in E,
                                ; statement count in D.
        PUSH    BC              ; save C the string test, and B the letter.
        CALL    L1D86           ; routine LOOK-PROG will search for token.
        POP     BC              ; restore BC.
        JR      NC,L2814        ; forward to SF-CP-DEF if a match was found.


;; REPORT-P
L2812:  RST     08H             ; ERROR-1
        DEFB    $18             ; Error Report: FN without DEF

;; SF-CP-DEF
L2814:  PUSH    HL              ; save address of DEF FN
        CALL    L28AB           ; routine FN-SKPOVR skips over white-space etc.
                                ; without disturbing CH-ADD.
        AND     $DF             ; make fetched character upper-case.
        CP      B               ; compare with FN name
        JR      NZ,L2825        ; forward to SF-NOT-FD if no match.

; the letters match so test the type.

        CALL    L28AB           ; routine FN-SKPOVR skips white-space
        SUB     $24             ; subtract '$' from fetched character
        CP      C               ; compare with saved result of same operation
                                ; on FN name.
        JR      Z,L2831         ; forward to SF-VALUES with a match.

; the letters matched but one was string and the other numeric.

;; SF-NOT-FD
L2825:  POP     HL              ; restore search point.
        DEC     HL              ; make location before
        LD      DE,$0200        ; the search is to be for the end of the
                                ; current definition - 2 statements forward.
        PUSH    BC              ; save the letter/type
        CALL    L198B           ; routine EACH-STMT steps past rejected
                                ; definition.
        POP     BC              ; restore letter/type
        JR      L2808           ; back to SF-FND-DF to continue search

; ---

; Success!
; the branch was here with matching letter and numeric/string type.

;; SF-VALUES
L2831:  AND     A               ; test A ( will be zero if string '$' - '$' )

        CALL    Z,L28AB         ; routine FN-SKPOVR advances HL past '$'.

        POP     DE              ; discard pointer to 'DEF FN'.
        POP     DE              ; restore pointer to first FN argument.
        LD      ($5C5D),DE      ; save in CH_ADD

        CALL    L28AB           ; routine FN-SKPOVR advances HL past '('
        PUSH    HL              ; save start address in DEF FN  ***
        CP      $29             ; is character a ')' ?
        JR      Z,L2885         ; forward to SF-R-BR-2 if no arguments.

;; SF-ARG-LP
L2843:  INC     HL              ; point to next character.
        LD      A,(HL)          ; fetch it.
        CP      $0E             ; is it the number marker
        LD      D,$40           ; signal numeric in D.
        JR      Z,L2852         ; forward to SF-ARG-VL if numeric.

        DEC     HL              ; back to letter
        CALL    L28AB           ; routine FN-SKPOVR skips any white-space
        INC     HL              ; advance past the expected '$' to 
                                ; the 'hidden' marker.
        LD      D,$00           ; signal string.

;; SF-ARG-VL
L2852:  INC     HL              ; now address first of 5-byte location.
        PUSH    HL              ; save address in DEF FN statement
        PUSH    DE              ; save D - result type

        CALL    L24FB           ; routine SCANNING evaluates expression in
                                ; the FN statement setting FLAGS and leaving
                                ; result as last value on calculator stack.

        POP     AF              ; restore saved result type to A

        XOR     (IY+$01)        ; xor with FLAGS
        AND     $40             ; and with 01000000 to test bit 6
        JR      NZ,L288B        ; forward to REPORT-Q if type mismatch.
                                ; 'Parameter error'

        POP     HL              ; pop the start address in DEF FN statement
        EX      DE,HL           ; transfer to DE ?? pop straight into de ?

        LD      HL,($5C65)      ; set HL to STKEND location after value
        LD      BC,$0005        ; five bytes to move
        SBC     HL,BC           ; decrease HL by 5 to point to start.
        LD      ($5C65),HL      ; set STKEND 'removing' value from stack.

        LDIR                    ; copy value into DEF FN statement
        EX      DE,HL           ; set HL to location after value in DEF FN
        DEC     HL              ; step back one
        CALL    L28AB           ; routine FN-SKPOVR gets next valid character
        CP      $29             ; is it ')' end of arguments ?
        JR      Z,L2885         ; forward to SF-R-BR-2 if so.

; a comma separator has been encountered in the DEF FN argument list.

        PUSH    HL              ; save position in DEF FN statement

        RST     18H             ; GET-CHAR from FN statement
        CP      $2C             ; is it ',' ?
        JR      NZ,L288B        ; forward to REPORT-Q if not
                                ; 'Parameter error'

        RST     20H             ; NEXT-CHAR in FN statement advances to next
                                ; argument.

        POP     HL              ; restore DEF FN pointer
        CALL    L28AB           ; routine FN-SKPOVR advances to corresponding
                                ; argument.

        JR      L2843           ; back to SF-ARG-LP looping until all
                                ; arguments are passed into the DEF FN
                                ; hidden locations.

; ---

; the branch was here when all arguments passed.

;; SF-R-BR-2
L2885:  PUSH    HL              ; save location of ')' in DEF FN

        RST     18H             ; GET-CHAR gets next character in FN
        CP      $29             ; is it a ')' also ?
        JR      Z,L288D         ; forward to SF-VALUE if so.


;; REPORT-Q
L288B:  RST     08H             ; ERROR-1
        DEFB    $19             ; Error Report: Parameter error

;; SF-VALUE
L288D:  POP     DE              ; location of ')' in DEF FN to DE.
        EX      DE,HL           ; now to HL, FN ')' pointer to DE.
        LD      ($5C5D),HL      ; initialize CH_ADD to this value.

; At this point the start of the DEF FN argument list is on the machine stack.
; We also have to consider that this defined function may form part of the
; definition of another defined function (though not itself).
; As this defined function may be part of a hierarchy of defined functions
; currently being evaluated by recursive calls to SCANNING, then we have to
; preserve the original value of DEFADD and not assume that it is zero.

        LD      HL,($5C0B)      ; get original DEFADD address
        EX      (SP),HL         ; swap with DEF FN address on stack ***
        LD      ($5C0B),HL      ; set DEFADD to point to this argument list
                                ; during scanning.

        PUSH    DE              ; save FN ')' pointer.

        RST     20H             ; NEXT-CHAR advances past ')' in define

        RST     20H             ; NEXT-CHAR advances past '=' to expression

        CALL    L24FB           ; routine SCANNING evaluates but searches
                                ; initially for variables at DEFADD

        POP     HL              ; pop the FN ')' pointer
        LD      ($5C5D),HL      ; set CH_ADD to this
        POP     HL              ; pop the original DEFADD value
        LD      ($5C0B),HL      ; and re-insert into DEFADD system variable.

        RST     20H             ; NEXT-CHAR advances to character after ')'
        JP      L2712           ; to S-CONT-2 - to continue current
                                ; invocation of scanning

; --------------------
; Used to parse DEF FN
; --------------------
; e.g. DEF FN     s $ ( x )     =  b     $ (  TO  x  ) : REM exaggerated
;
; This routine is used 10 times to advance along a DEF FN statement
; skipping spaces and colour control codes. It is similar to NEXT-CHAR
; which is, at the same time, used to skip along the corresponding FN function
; except the latter has to deal with AT and TAB characters in string
; expressions. These cannot occur in a program area so this routine is
; simpler as both colour controls and their parameters are less than space.

;; FN-SKPOVR
L28AB:  INC     HL              ; increase pointer
        LD      A,(HL)          ; fetch addressed character
        CP      $21             ; compare with space + 1
        JR      C,L28AB         ; back to FN-SKPOVR if less

        RET                     ; return pointing to a valid character.

; ---------
; LOOK-VARS
; ---------
;
;

;; LOOK-VARS
L28B2:  SET     6,(IY+$01)      ; update FLAGS - presume numeric result

        RST     18H             ; GET-CHAR
        CALL    L2C8D           ; routine ALPHA tests for A-Za-z
        JP      NC,L1C8A        ; jump to REPORT-C if not.
                                ; 'Nonsense in BASIC'

        PUSH    HL              ; save pointer to first letter       ^1
        AND     $1F             ; mask lower bits, 1 - 26 decimal     000xxxxx
        LD      C,A             ; store in C.

        RST     20H             ; NEXT-CHAR
        PUSH    HL              ; save pointer to second character   ^2
        CP      $28             ; is it '(' - an array ?
        JR      Z,L28EF         ; forward to V-RUN/SYN if so.

        SET     6,C             ; set 6 signaling string if solitary  010
        CP      $24             ; is character a '$' ?
        JR      Z,L28DE         ; forward to V-STR-VAR

        SET     5,C             ; signal numeric                       011
        CALL    L2C88           ; routine ALPHANUM sets carry if second
                                ; character is alphanumeric.
        JR      NC,L28E3        ; forward to V-TEST-FN if just one character

; It is more than one character but re-test current character so that 6 reset
; This loop renders the similar loop at V-PASS redundant.

;; V-CHAR
L28D4:  CALL    L2C88           ; routine ALPHANUM
        JR      NC,L28EF        ; to V-RUN/SYN when no more

        RES     6,C             ; make long named type                 001

        RST     20H             ; NEXT-CHAR
        JR      L28D4           ; loop back to V-CHAR

; ---


;; V-STR-VAR
L28DE:  RST     20H             ; NEXT-CHAR advances past '$'
        RES     6,(IY+$01)      ; update FLAGS - signal string result.

;; V-TEST-FN
L28E3:  LD      A,($5C0C)       ; load A with DEFADD_hi
        AND     A               ; and test for zero.
        JR      Z,L28EF         ; forward to V-RUN/SYN if a defined function
                                ; is not being evaluated.

; Note.

        CALL    L2530           ; routine SYNTAX-Z
        JP      NZ,L2951        ; JUMP to STK-F-ARG in runtime and then
                                ; back to this point if no variable found.

;; V-RUN/SYN
L28EF:  LD      B,C             ; save flags in B
        CALL    L2530           ; routine SYNTAX-Z
        JR      NZ,L28FD        ; to V-RUN to look for the variable in runtime

; if checking syntax the letter is not returned

        LD      A,C             ; copy letter/flags to A
        AND     $E0             ; and with 11100000 to get rid of the letter
        SET     7,A             ; use spare bit to signal checking syntax.
        LD      C,A             ; and transfer to C.
        JR      L2934           ; forward to V-SYNTAX

; ---

; but in runtime search for the variable.

;; V-RUN
L28FD:  LD      HL,($5C4B)      ; set HL to start of variables from VARS

;; V-EACH
L2900:  LD      A,(HL)          ; get first character
        AND     $7F             ; and with 01111111
                                ; ignoring bit 7 which distinguishes
                                ; arrays or for/next variables.

        JR      Z,L2932         ; to V-80-BYTE if zero as must be 10000000
                                ; the variables end-marker.

        CP      C               ; compare with supplied value.
        JR      NZ,L292A        ; forward to V-NEXT if no match.

        RLA                     ; destructively test
        ADD     A,A             ; bits 5 and 6 of A
                                ; jumping if bit 5 reset or 6 set

        JP      P,L293F         ; to V-FOUND-2  strings and arrays

        JR      C,L293F         ; to V-FOUND-2  simple and for next

; leaving long name variables.

        POP     DE              ; pop pointer to 2nd. char
        PUSH    DE              ; save it again
        PUSH    HL              ; save variable first character pointer

;; V-MATCHES
L2912:  INC     HL              ; address next character in vars area

;; V-SPACES
L2913:  LD      A,(DE)          ; pick up letter from prog area
        INC     DE              ; and advance address
        CP      $20             ; is it a space
        JR      Z,L2913         ; back to V-SPACES until non-space

        OR      $20             ; convert to range 1 - 26.
        CP      (HL)            ; compare with addressed variables character
        JR      Z,L2912         ; loop back to V-MATCHES if a match on an
                                ; intermediate letter.

        OR      $80             ; now set bit 7 as last character of long
                                ; names are inverted.
        CP      (HL)            ; compare again
        JR      NZ,L2929        ; forward to V-GET-PTR if no match

; but if they match check that this is also last letter in prog area

        LD      A,(DE)          ; fetch next character
        CALL    L2C88           ; routine ALPHANUM sets carry if not alphanum
        JR      NC,L293E        ; forward to V-FOUND-1 with a full match.

;; V-GET-PTR
L2929:  POP     HL              ; pop saved pointer to char 1

;; V-NEXT
L292A:  PUSH    BC              ; save flags
        CALL    L19B8           ; routine NEXT-ONE gets next variable in DE
        EX      DE,HL           ; transfer to HL.
        POP     BC              ; restore the flags
        JR      L2900           ; loop back to V-EACH
                                ; to compare each variable

; ---

;; V-80-BYTE
L2932:  SET     7,B             ; will signal not found

; the branch was here when checking syntax

;; V-SYNTAX
L2934:  POP     DE              ; discard the pointer to 2nd. character  v2
                                ; in BASIC line/workspace.

        RST     18H             ; GET-CHAR gets character after variable name.
        CP      $28             ; is it '(' ?
        JR      Z,L2943         ; forward to V-PASS
                                ; Note. could go straight to V-END ?

        SET     5,B             ; signal not an array
        JR      L294B           ; forward to V-END

; ---------------------------

; the jump was here when a long name matched and HL pointing to last character
; in variables area.

;; V-FOUND-1
L293E:  POP     DE              ; discard pointer to first var letter

; the jump was here with all other matches HL points to first var char.

;; V-FOUND-2
L293F:  POP     DE              ; discard pointer to 2nd prog char       v2
        POP     DE              ; drop pointer to 1st prog char          v1
        PUSH    HL              ; save pointer to last char in vars

        RST     18H             ; GET-CHAR

;; V-PASS
L2943:  CALL    L2C88           ; routine ALPHANUM
        JR      NC,L294B        ; forward to V-END if not

; but it never will be as we advanced past long-named variables earlier.

        RST     20H             ; NEXT-CHAR
        JR      L2943           ; back to V-PASS

; ---

;; V-END
L294B:  POP     HL              ; pop the pointer to first character in
                                ; BASIC line/workspace.
        RL      B               ; rotate the B register left
                                ; bit 7 to carry
        BIT     6,B             ; test the array indicator bit.
        RET                     ; return

; -----------------------
; Stack function argument
; -----------------------
; This branch is taken from LOOK-VARS when a defined function is currently
; being evaluated.
; Scanning is evaluating the expression after the '=' and the variable
; found could be in the argument list to the left of the '=' or in the
; normal place after the program. Preference will be given to the former.
; The variable name to be matched is in C.

;; STK-F-ARG
L2951:  LD      HL,($5C0B)      ; set HL to DEFADD
        LD      A,(HL)          ; load the first character
        CP      $29             ; is it ')' ?
        JP      Z,L28EF         ; JUMP back to V-RUN/SYN, if so, as there are
                                ; no arguments.

; but proceed to search argument list of defined function first if not empty.

;; SFA-LOOP
L295A:  LD      A,(HL)          ; fetch character again.
        OR      $60             ; or with 01100000 presume a simple variable.
        LD      B,A             ; save result in B.
        INC     HL              ; address next location.
        LD      A,(HL)          ; pick up byte.
        CP      $0E             ; is it the number marker ?
        JR      Z,L296B         ; forward to SFA-CP-VR if so.

; it was a string. White-space may be present but syntax has been checked.

        DEC     HL              ; point back to letter.
        CALL    L28AB           ; routine FN-SKPOVR skips to the '$'
        INC     HL              ; now address the hidden marker.
        RES     5,B             ; signal a string variable.

;; SFA-CP-VR
L296B:  LD      A,B             ; transfer found variable letter to A.
        CP      C               ; compare with expected.
        JR      Z,L2981         ; forward to SFA-MATCH with a match.

        INC     HL              ; step
        INC     HL              ; past
        INC     HL              ; the
        INC     HL              ; five
        INC     HL              ; bytes.

        CALL    L28AB           ; routine FN-SKPOVR skips to next character
        CP      $29             ; is it ')' ?
        JP      Z,L28EF         ; jump back if so to V-RUN/SYN to look in
                                ; normal variables area.

        CALL    L28AB           ; routine FN-SKPOVR skips past the ','
                                ; all syntax has been checked and these
                                ; things can be taken as read.
        JR      L295A           ; back to SFA-LOOP while there are more
                                ; arguments.

; ---

;; SFA-MATCH
L2981:  BIT     5,C             ; test if numeric
        JR      NZ,L2991        ; to SFA-END if so as will be stacked
                                ; by scanning

        INC     HL              ; point to start of string descriptor
        LD      DE,($5C65)      ; set DE to STKEND
        CALL    L33C0           ; routine MOVE-FP puts parameters on stack.
        EX      DE,HL           ; new free location to HL.
        LD      ($5C65),HL      ; use it to set STKEND system variable.

;; SFA-END
L2991:  POP     DE              ; discard
        POP     DE              ; pointers.
        XOR     A               ; clear carry flag.
        INC     A               ; and zero flag.
        RET                     ; return.

; ------------------------
; Stack variable component
; ------------------------
; This is called to evaluate a complex structure that has been found, in
; runtime, by LOOK-VARS in the variables area.
; In this case HL points to the initial letter, bits 7-5
; of which indicate the type of variable.
; 010 - simple string, 110 - string array, 100 - array of numbers.
;
; It is called from CLASS-01 when assigning to a string or array including
; a slice.
; It is called from SCANNING to isolate the required part of the structure.
;
; An important part of the runtime process is to check that the number of
; dimensions of the variable match the number of subscripts supplied in the
; BASIC line.
;
; If checking syntax,
; the B register, which counts dimensions is set to zero (256) to allow
; the loop to continue till all subscripts are checked. While doing this it
; is reading dimension sizes from some arbitrary area of memory. Although
; these are meaningless it is of no concern as the limit is never checked by
; int-exp during syntax checking.
;
; The routine is also called from the syntax path of DIM command to check the
; syntax of both string and numeric arrays definitions except that bit 6 of C
; is reset so both are checked as numeric arrays. This ruse avoids a terminal
; slice being accepted as part of the DIM command.
; All that is being checked is that there are a valid set of comma-separated
; expressions before a terminal ')', although, as above, it will still go
; through the motions of checking dummy dimension sizes.

;; STK-VAR
L2996:  XOR     A               ; clear A
        LD      B,A             ; and B, the syntax dimension counter (256)
        BIT     7,C             ; checking syntax ?
        JR      NZ,L29E7        ; forward to SV-COUNT if so.

; runtime evaluation.

        BIT     7,(HL)          ; will be reset if a simple string.
        JR      NZ,L29AE        ; forward to SV-ARRAYS otherwise

        INC     A               ; set A to 1, simple string.

;; SV-SIMPLE$
L29A1:  INC     HL              ; address length low
        LD      C,(HL)          ; place in C
        INC     HL              ; address length high
        LD      B,(HL)          ; place in B
        INC     HL              ; address start of string
        EX      DE,HL           ; DE = start now.
        CALL    L2AB2           ; routine STK-STO-$ stacks string parameters
                                ; DE start in variables area,
                                ; BC length, A=1 simple string

; the only thing now is to consider if a slice is required.

        RST     18H             ; GET-CHAR puts character at CH_ADD in A
        JP      L2A49           ; jump forward to SV-SLICE? to test for '('

; --------------------------------------------------------

; the branch was here with string and numeric arrays in runtime.

;; SV-ARRAYS
L29AE:  INC     HL              ; step past
        INC     HL              ; the total length
        INC     HL              ; to address Number of dimensions.
        LD      B,(HL)          ; transfer to B overwriting zero.
        BIT     6,C             ; a numeric array ?
        JR      Z,L29C0         ; forward to SV-PTR with numeric arrays

        DEC     B               ; ignore the final element of a string array
                                ; the fixed string size.

        JR      Z,L29A1         ; back to SV-SIMPLE$ if result is zero as has
                                ; been created with DIM a$(10) for instance
                                ; and can be treated as a simple string.

; proceed with multi-dimensioned string arrays in runtime.

        EX      DE,HL           ; save pointer to dimensions in DE

        RST     18H             ; GET-CHAR looks at the BASIC line
        CP      $28             ; is character '(' ?
        JR      NZ,L2A20        ; to REPORT-3 if not
                                ; 'Subscript wrong'

        EX      DE,HL           ; dimensions pointer to HL to synchronize
                                ; with next instruction.

; runtime numeric arrays path rejoins here.

;; SV-PTR
L29C0:  EX      DE,HL           ; save dimension pointer in DE
        JR      L29E7           ; forward to SV-COUNT with true no of dims 
                                ; in B. As there is no initial comma the 
                                ; loop is entered at the midpoint.

; ----------------------------------------------------------
; the dimension counting loop which is entered at mid-point.

;; SV-COMMA
L29C3:  PUSH    HL              ; save counter

        RST     18H             ; GET-CHAR

        POP     HL              ; pop counter
        CP      $2C             ; is character ',' ?
        JR      Z,L29EA         ; forward to SV-LOOP if so

; in runtime the variable definition indicates a comma should appear here

        BIT     7,C             ; checking syntax ?
        JR      Z,L2A20         ; forward to REPORT-3 if not
                                ; 'Subscript error'

; proceed if checking syntax of an array?

        BIT     6,C             ; array of strings
        JR      NZ,L29D8        ; forward to SV-CLOSE if so

; an array of numbers.

        CP      $29             ; is character ')' ?
        JR      NZ,L2A12        ; forward to SV-RPT-C if not
                                ; 'Nonsense in BASIC'

        RST     20H             ; NEXT-CHAR moves CH-ADD past the statement
        RET                     ; return ->

; ---

; the branch was here with an array of strings.

;; SV-CLOSE
L29D8:  CP      $29             ; as above ')' could follow the expression
        JR      Z,L2A48         ; forward to SV-DIM if so

        CP      $CC             ; is it 'TO' ?
        JR      NZ,L2A12        ; to SV-RPT-C with anything else
                                ; 'Nonsense in BASIC'

; now backtrack CH_ADD to set up for slicing routine.
; Note. in a BASIC line we can safely backtrack to a colour parameter.

;; SV-CH-ADD
L29E0:  RST     18H             ; GET-CHAR
        DEC     HL              ; backtrack HL
        LD      ($5C5D),HL      ; to set CH_ADD up for slicing routine
        JR      L2A45           ; forward to SV-SLICE and make a return
                                ; when all slicing complete.

; ----------------------------------------
; -> the mid-point entry point of the loop

;; SV-COUNT
L29E7:  LD      HL,$0000        ; initialize data pointer to zero.

;; SV-LOOP
L29EA:  PUSH    HL              ; save the data pointer.

        RST     20H             ; NEXT-CHAR in BASIC area points to an
                                ; expression.

        POP     HL              ; restore the data pointer.
        LD      A,C             ; transfer name/type to A.
        CP      $C0             ; is it 11000000 ?
                                ; Note. the letter component is absent if
                                ; syntax checking.
        JR      NZ,L29FB        ; forward to SV-MULT if not an array of
                                ; strings.

; proceed to check string arrays during syntax.

        RST     18H             ; GET-CHAR
        CP      $29             ; ')'  end of subscripts ?
        JR      Z,L2A48         ; forward to SV-DIM to consider further slice

        CP      $CC             ; is it 'TO' ?
        JR      Z,L29E0         ; back to SV-CH-ADD to consider a slice.
                                ; (no need to repeat get-char at L29E0)

; if neither, then an expression is required so rejoin runtime loop ??
; registers HL and DE only point to somewhere meaningful in runtime so 
; comments apply to that situation.

;; SV-MULT
L29FB:  PUSH    BC              ; save dimension number.
        PUSH    HL              ; push data pointer/rubbish.
                                ; DE points to current dimension.
        CALL    L2AEE           ; routine DE,(DE+1) gets next dimension in DE
                                ; and HL points to it.
        EX      (SP),HL         ; dim pointer to stack, data pointer to HL (*)
        EX      DE,HL           ; data pointer to DE, dim size to HL.

        CALL    L2ACC           ; routine INT-EXP1 checks integer expression
                                ; and gets result in BC in runtime.
        JR      C,L2A20         ; to REPORT-3 if > HL
                                ; 'Subscript out of range'

        DEC     BC              ; adjust returned result from 1-x to 0-x
        CALL    L2AF4           ; routine GET-HL*DE multiplies data pointer by
                                ; dimension size.
        ADD     HL,BC           ; add the integer returned by expression.
        POP     DE              ; pop the dimension pointer.                              ***
        POP     BC              ; pop dimension counter.
        DJNZ    L29C3           ; back to SV-COMMA if more dimensions
                                ; Note. during syntax checking, unless there
                                ; are more than 256 subscripts, the branch
                                ; back to SV-COMMA is always taken.

        BIT     7,C             ; are we checking syntax ?
                                ; then we've got a joker here.

;; SV-RPT-C
L2A12:  JR      NZ,L2A7A        ; forward to SL-RPT-C if so
                                ; 'Nonsense in BASIC'
                                ; more than 256 subscripts in BASIC line.

; but in runtime the number of subscripts are at least the same as dims

        PUSH    HL              ; save data pointer.
        BIT     6,C             ; is it a string array ?
        JR      NZ,L2A2C        ; forward to SV-ELEM$ if so.

; a runtime numeric array subscript.

        LD      B,D             ; register DE has advanced past all dimensions
        LD      C,E             ; and points to start of data in variable.
                                ; transfer it to BC.

        RST     18H             ; GET-CHAR checks BASIC line
        CP      $29             ; must be a ')' ?
        JR      Z,L2A22         ; skip to SV-NUMBER if so

; else more subscripts in BASIC line than the variable definition.

;; REPORT-3
L2A20:  RST     08H             ; ERROR-1
        DEFB    $02             ; Error Report: Subscript wrong

; continue if subscripts matched the numeric array.

;; SV-NUMBER
L2A22:  RST     20H             ; NEXT-CHAR moves CH_ADD to next statement
                                ; - finished parsing.

        POP     HL              ; pop the data pointer.
        LD      DE,$0005        ; each numeric element is 5 bytes.
        CALL    L2AF4           ; routine GET-HL*DE multiplies.
        ADD     HL,BC           ; now add to start of data in the variable.

        RET                     ; return with HL pointing at the numeric
                                ; array subscript.                       ->

; ---------------------------------------------------------------

; the branch was here for string subscripts when the number of subscripts
; in the BASIC line was one less than in variable definition.

;; SV-ELEM$
L2A2C:  CALL    L2AEE           ; routine DE,(DE+1) gets final dimension
                                ; the length of strings in this array.
        EX      (SP),HL         ; start pointer to stack, data pointer to HL.
        CALL    L2AF4           ; routine GET-HL*DE multiplies by element
                                ; size.
        POP     BC              ; the start of data pointer is added
        ADD     HL,BC           ; in - now points to location before.
        INC     HL              ; point to start of required string.
        LD      B,D             ; transfer the length (final dimension size)
        LD      C,E             ; from DE to BC.
        EX      DE,HL           ; put start in DE.
        CALL    L2AB1           ; routine STK-ST-0 stores the string parameters
                                ; with A=0 - a slice or subscript.

; now check that there were no more subscripts in the BASIC line.

        RST     18H             ; GET-CHAR
        CP      $29             ; is it ')' ?
        JR      Z,L2A48         ; forward to SV-DIM to consider a separate
                                ; subscript or/and a slice.

        CP      $2C             ; a comma is allowed if the final subscript
                                ; is to be sliced e.g. a$(2,3,4 TO 6).
        JR      NZ,L2A20        ; to REPORT-3 with anything else
                                ; 'Subscript error'

;; SV-SLICE
L2A45:  CALL    L2A52           ; routine SLICING slices the string.

; but a slice of a simple string can itself be sliced.

;; SV-DIM
L2A48:  RST     20H             ; NEXT-CHAR

;; SV-SLICE?
L2A49:  CP      $28             ; is character '(' ?
        JR      Z,L2A45         ; loop back if so to SV-SLICE

        RES     6,(IY+$01)      ; update FLAGS  - Signal string result
        RET                     ; and return.

; ---

; The above section deals with the flexible syntax allowed.
; DIM a$(3,3,10) can be considered as two dimensional array of ten-character
; strings or a 3-dimensional array of characters.
; a$(1,1) will return a 10-character string as will a$(1,1,1 TO 10)
; a$(1,1,1) will return a single character.
; a$(1,1) (1 TO 6) is the same as a$(1,1,1 TO 6)
; A slice can itself be sliced ad infinitum
; b$ () () () () () () (2 TO 10) (2 TO 9) (3) is the same as b$(5)



; -------------------------
; Handle slicing of strings
; -------------------------
; The syntax of string slicing is very natural and it is as well to reflect
; on the permutations possible.
; a$() and a$( TO ) indicate the entire string although just a$ would do
; and would avoid coming here.
; h$(16) indicates the single character at position 16.
; a$( TO 32) indicates the first 32 characters.
; a$(257 TO) indicates all except the first 256 characters.
; a$(19000 TO 19999) indicates the thousand characters at position 19000.
; Also a$(9 TO 5) returns a null string not an error.
; This enables a$(2 TO) to return a null string if the passed string is
; of length zero or 1.
; A string expression in brackets can be sliced. e.g. (STR$ PI) (3 TO )
; We arrived here from SCANNING with CH-ADD pointing to the initial '('
; or from above.

;; SLICING
L2A52:  CALL    L2530           ; routine SYNTAX-Z
        CALL    NZ,L2BF1        ; routine STK-FETCH fetches parameters of
                                ; string at runtime, start in DE, length 
                                ; in BC. This could be an array subscript.

        RST     20H             ; NEXT-CHAR
        CP      $29             ; is it ')' ?     e.g. a$()
        JR      Z,L2AAD         ; forward to SL-STORE to store entire string.

        PUSH    DE              ; else save start address of string

        XOR     A               ; clear accumulator to use as a running flag.
        PUSH    AF              ; and save on stack before any branching.

        PUSH    BC              ; save length of string to be sliced.
        LD      DE,$0001        ; default the start point to position 1.

        RST     18H             ; GET-CHAR

        POP     HL              ; pop length to HL as default end point
                                ; and limit.

        CP      $CC             ; is it 'TO' ?    e.g. a$( TO 10000)
        JR      Z,L2A81         ; to SL-SECOND to evaluate second parameter.

        POP     AF              ; pop the running flag.

        CALL    L2ACD           ; routine INT-EXP2 fetches first parameter.

        PUSH    AF              ; save flag (will be $FF if parameter>limit)

        LD      D,B             ; transfer the start
        LD      E,C             ; to DE overwriting 0001.
        PUSH    HL              ; save original length.

        RST     18H             ; GET-CHAR
        POP     HL              ; pop the limit length.
        CP      $CC             ; is it 'TO' after a start ?
        JR      Z,L2A81         ; to SL-SECOND to evaluate second parameter

        CP      $29             ; is it ')' ?       e.g. a$(365)

;; SL-RPT-C
L2A7A:  JP      NZ,L1C8A        ; jump to REPORT-C with anything else
                                ; 'Nonsense in BASIC'

        LD      H,D             ; copy start
        LD      L,E             ; to end - just a one character slice.
        JR      L2A94           ; forward to SL-DEFINE.

; ---------------------

;; SL-SECOND
L2A81:  PUSH    HL              ; save limit length.

        RST     20H             ; NEXT-CHAR

        POP     HL              ; pop the length.

        CP      $29             ; is character ')' ?        e.g. a$(7 TO )
        JR      Z,L2A94         ; to SL-DEFINE using length as end point.

        POP     AF              ; else restore flag.
        CALL    L2ACD           ; routine INT-EXP2 gets second expression.

        PUSH    AF              ; save the running flag.

        RST     18H             ; GET-CHAR

        LD      H,B             ; transfer second parameter
        LD      L,C             ; to HL.              e.g. a$(42 to 99)
        CP      $29             ; is character a ')' ?
        JR      NZ,L2A7A        ; to SL-RPT-C if not
                                ; 'Nonsense in BASIC'

; we now have start in DE and an end in HL.

;; SL-DEFINE
L2A94:  POP     AF              ; pop the running flag.
        EX      (SP),HL         ; put end point on stack, start address to HL
        ADD     HL,DE           ; add address of string to the start point.
        DEC     HL              ; point to first character of slice.
        EX      (SP),HL         ; start address to stack, end point to HL (*)
        AND     A               ; prepare to subtract.
        SBC     HL,DE           ; subtract start point from end point.
        LD      BC,$0000        ; default the length result to zero.
        JR      C,L2AA8         ; forward to SL-OVER if start > end.

        INC     HL              ; increment the length for inclusive byte.

        AND     A               ; now test the running flag.
        JP      M,L2A20         ; jump back to REPORT-3 if $FF.
                                ; 'Subscript out of range'

        LD      B,H             ; transfer the length
        LD      C,L             ; to BC.

;; SL-OVER
L2AA8:  POP     DE              ; restore start address from machine stack ***
        RES     6,(IY+$01)      ; update FLAGS - signal string result for
                                ; syntax.

;; SL-STORE
L2AAD:  CALL    L2530           ; routine SYNTAX-Z  (UNSTACK-Z?)
        RET     Z               ; return if checking syntax.
                                ; but continue to store the string in runtime.

; ------------------------------------
; other than from above, this routine is called from STK-VAR to stack
; a known string array element.
; ------------------------------------

;; STK-ST-0
L2AB1:  XOR     A               ; clear to signal a sliced string or element.

; -------------------------
; this routine is called from chr$, scrn$ etc. to store a simple string result.
; --------------------------

;; STK-STO-$
L2AB2:  RES     6,(IY+$01)      ; update FLAGS - signal string result.
                                ; and continue to store parameters of string.

; ---------------------------------------
; Pass five registers to calculator stack
; ---------------------------------------
; This subroutine puts five registers on the calculator stack.

;; STK-STORE
L2AB6:  PUSH    BC              ; save two registers
        CALL    L33A9           ; routine TEST-5-SP checks room and puts 5 
                                ; in BC.
        POP     BC              ; fetch the saved registers.
        LD      HL,($5C65)      ; make HL point to first empty location STKEND
        LD      (HL),A          ; place the 5 registers.
        INC     HL              ;
        LD      (HL),E          ;
        INC     HL              ;
        LD      (HL),D          ;
        INC     HL              ;
        LD      (HL),C          ;
        INC     HL              ;
        LD      (HL),B          ;
        INC     HL              ;
        LD      ($5C65),HL      ; update system variable STKEND.
        RET                     ; and return.

; -------------------------------------------
; Return result of evaluating next expression
; -------------------------------------------
; This clever routine is used to check and evaluate an integer expression
; which is returned in BC, setting A to $FF, if greater than a limit supplied
; in HL. It is used to check array subscripts, parameters of a string slice
; and the arguments of the DIM command. In the latter case, the limit check
; is not required and H is set to $FF. When checking optional string slice
; parameters, it is entered at the second entry point so as not to disturb
; the running flag A, which may be $00 or $FF from a previous invocation.

;; INT-EXP1
L2ACC:  XOR     A               ; set result flag to zero.

; -> The entry point is here if A is used as a running flag.

;; INT-EXP2
L2ACD:  PUSH    DE              ; preserve DE register throughout.
        PUSH    HL              ; save the supplied limit.
        PUSH    AF              ; save the flag.

        CALL    L1C82           ; routine EXPT-1NUM evaluates expression
                                ; at CH_ADD returning if numeric result,
                                ; with value on calculator stack.

        POP     AF              ; pop the flag.
        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L2AEB         ; forward to I-RESTORE if checking syntax so
                                ; avoiding a comparison with supplied limit.

        PUSH    AF              ; save the flag.

        CALL    L1E99           ; routine FIND-INT2 fetches value from
                                ; calculator stack to BC producing an error
                                ; if too high.

        POP     DE              ; pop the flag to D.
        LD      A,B             ; test value for zero and reject
        OR      C               ; as arrays and strings begin at 1.
        SCF                     ; set carry flag.
        JR      Z,L2AE8         ; forward to I-CARRY if zero.

        POP     HL              ; restore the limit.
        PUSH    HL              ; and save.
        AND     A               ; prepare to subtract.
        SBC     HL,BC           ; subtract value from limit.

;; I-CARRY
L2AE8:  LD      A,D             ; move flag to accumulator $00 or $FF.
        SBC     A,$00           ; will set to $FF if carry set.

;; I-RESTORE
L2AEB:  POP     HL              ; restore the limit.
        POP     DE              ; and DE register.
        RET                     ; return.


; -----------------------
; LD DE,(DE+1) Subroutine
; -----------------------
; This routine just loads the DE register with the contents of the two
; locations following the location addressed by DE.
; It is used to step along the 16-bit dimension sizes in array definitions.
; Note. Such code is made into subroutines to make programs easier to
; write and it would use less space to include the five instructions in-line.
; However, there are so many exchanges going on at the places this is invoked
; that to implement it in-line would make the code hard to follow.
; It probably had a zippier label though as the intention is to simplify the
; program.

;; DE,(DE+1)
L2AEE:  EX      DE,HL           ;
        INC     HL              ;
        LD      E,(HL)          ;
        INC     HL              ;
        LD      D,(HL)          ;
        RET                     ;

; -------------------
; HL=HL*DE Subroutine
; -------------------
; This routine calls the mathematical routine to multiply HL by DE in runtime.
; It is called from STK-VAR and from DIM. In the latter case syntax is not
; being checked so the entry point could have been at the second CALL
; instruction to save a few clock-cycles.

;; GET-HL*DE
L2AF4:  CALL    L2530           ; routine SYNTAX-Z.
        RET     Z               ; return if checking syntax.

        CALL    L30A9           ; routine HL-HL*DE.
        JP      C,L1F15         ; jump back to REPORT-4 if over 65535.

        RET                     ; else return with 16-bit result in HL.

; -----------------
; THE 'LET' COMMAND
; -----------------
; Sinclair BASIC adheres to the ANSI-78 standard and a LET is required in
; assignments e.g. LET a = 1  :   LET h$ = "hat".
;
; Long names may contain spaces but not colour controls (when assigned).
; a substring can appear to the left of the equals sign.

; An earlier mathematician Lewis Carroll may have been pleased that
; 10 LET Babies cannot manage crocodiles = Babies are illogical AND
;    Nobody is despised who can manage a crocodile AND Illogical persons
;    are despised
; does not give the 'Nonsense..' error if the three variables exist.
; I digress.

;; LET
L2AFF:  LD      HL,($5C4D)      ; fetch system variable DEST to HL.
        BIT     1,(IY+$37)      ; test FLAGX - handling a new variable ?
        JR      Z,L2B66         ; forward to L-EXISTS if not.

; continue for a new variable. DEST points to start in BASIC line.
; from the CLASS routines.

        LD      BC,$0005        ; assume numeric and assign an initial 5 bytes

;; L-EACH-CH
L2B0B:  INC     BC              ; increase byte count for each relevant
                                ; character

;; L-NO-SP
L2B0C:  INC     HL              ; increase pointer.
        LD      A,(HL)          ; fetch character.
        CP      $20             ; is it a space ?
        JR      Z,L2B0C         ; back to L-NO-SP is so.

        JR      NC,L2B1F        ; forward to L-TEST-CH if higher.

        CP      $10             ; is it $00 - $0F ?
        JR      C,L2B29         ; forward to L-SPACES if so.

        CP      $16             ; is it $16 - $1F ?
        JR      NC,L2B29        ; forward to L-SPACES if so.

; it was $10 - $15  so step over a colour code.

        INC     HL              ; increase pointer.
        JR      L2B0C           ; loop back to L-NO-SP.

; ---

; the branch was to here if higher than space.

;; L-TEST-CH
L2B1F:  CALL    L2C88           ; routine ALPHANUM sets carry if alphanumeric
        JR      C,L2B0B         ; loop back to L-EACH-CH for more if so.

        CP      $24             ; is it '$' ?
        JP      Z,L2BC0         ; jump forward if so, to L-NEW$
                                ; with a new string.

;; L-SPACES
L2B29:  LD      A,C             ; save length lo in A.
        LD      HL,($5C59)      ; fetch E_LINE to HL.
        DEC     HL              ; point to location before, the variables
                                ; end-marker.
        CALL    L1655           ; routine MAKE-ROOM creates BC spaces
                                ; for name and numeric value.
        INC     HL              ; advance to first new location.
        INC     HL              ; then to second.
        EX      DE,HL           ; set DE to second location.
        PUSH    DE              ; save this pointer.
        LD      HL,($5C4D)      ; reload HL with DEST.
        DEC     DE              ; point to first.
        SUB     $06             ; subtract six from length_lo.
        LD      B,A             ; save count in B.
        JR      Z,L2B4F         ; forward to L-SINGLE if it was just
                                ; one character.

; HL points to start of variable name after 'LET' in BASIC line.

;; L-CHAR
L2B3E:  INC     HL              ; increase pointer.
        LD      A,(HL)          ; pick up character.
        CP      $21             ; is it space or higher ?
        JR      C,L2B3E         ; back to L-CHAR with space and less.

        OR      $20             ; make variable lower-case.
        INC     DE              ; increase destination pointer.
        LD      (DE),A          ; and load to edit line.
        DJNZ    L2B3E           ; loop back to L-CHAR until B is zero.

        OR      $80             ; invert the last character.
        LD      (DE),A          ; and overwrite that in edit line.

; now consider first character which has bit 6 set

        LD      A,$C0           ; set A 11000000 is xor mask for a long name.
                                ; %101      is xor/or  result

; single character numerics rejoin here with %00000000 in mask.
;                                            %011      will be xor/or result

;; L-SINGLE
L2B4F:  LD      HL,($5C4D)      ; fetch DEST - HL addresses first character.
        XOR     (HL)            ; apply variable type indicator mask (above).
        OR      $20             ; make lowercase - set bit 5.
        POP     HL              ; restore pointer to 2nd character.
        CALL    L2BEA           ; routine L-FIRST puts A in first character.
                                ; and returns with HL holding
                                ; new E_LINE-1  the $80 vars end-marker.

;; L-NUMERIC
L2B59:  PUSH    HL              ; save the pointer.

; the value of variable is deleted but remains after calculator stack.

        RST     28H             ;; FP-CALC
        DEFB    $02             ;;delete      ; delete variable value
        DEFB    $38             ;;end-calc

; DE (STKEND) points to start of value.

        POP     HL              ; restore the pointer.
        LD      BC,$0005        ; start of number is five bytes before.
        AND     A               ; prepare for true subtraction.
        SBC     HL,BC           ; HL points to start of value.
        JR      L2BA6           ; forward to L-ENTER  ==>

; ---


; the jump was to here if the variable already existed.

;; L-EXISTS
L2B66:  BIT     6,(IY+$01)      ; test FLAGS - numeric or string result ?
        JR      Z,L2B72         ; skip forward to L-DELETE$   -*->
                                ; if string result.

; A numeric variable could be simple or an array element.
; They are treated the same and the old value is overwritten.

        LD      DE,$0006        ; six bytes forward points to loc past value.
        ADD     HL,DE           ; add to start of number.
        JR      L2B59           ; back to L-NUMERIC to overwrite value.

; ---

; -*-> the branch was here if a string existed.

;; L-DELETE$
L2B72:  LD      HL,($5C4D)      ; fetch DEST to HL.
                                ; (still set from first instruction)
        LD      BC,($5C72)      ; fetch STRLEN to BC.
        BIT     0,(IY+$37)      ; test FLAGX - handling a complete simple
                                ; string ?
        JR      NZ,L2BAF        ; forward to L-ADD$ if so.

; must be a string array or a slice in workspace.
; Note. LET a$(3 TO 6) = h$   will assign "hat " if h$ = "hat"
;                                  and    "hats" if h$ = "hatstand".
;
; This is known as Procrustean lengthening and shortening after a
; character Procrustes in Greek legend who made travellers sleep in his bed,
; cutting off their feet or stretching them so they fitted the bed perfectly.
; The bloke was hatstand and slain by Theseus.

        LD      A,B             ; test if length
        OR      C               ; is zero and
        RET     Z               ; return if so.

        PUSH    HL              ; save pointer to start.

        RST     30H             ; BC-SPACES creates room.
        PUSH    DE              ; save pointer to first new location.
        PUSH    BC              ; and length            (*)
        LD      D,H             ; set DE to point to last location.
        LD      E,L             ;
        INC     HL              ; set HL to next location.
        LD      (HL),$20        ; place a space there.
        LDDR                    ; copy bytes filling with spaces.

        PUSH    HL              ; save pointer to start.
        CALL    L2BF1           ; routine STK-FETCH start to DE,
                                ; length to BC.
        POP     HL              ; restore the pointer.
        EX      (SP),HL         ; (*) length to HL, pointer to stack.
        AND     A               ; prepare for true subtraction.
        SBC     HL,BC           ; subtract old length from new.
        ADD     HL,BC           ; and add back.
        JR      NC,L2B9B        ; forward if it fits to L-LENGTH.

        LD      B,H             ; otherwise set
        LD      C,L             ; length to old length.
                                ; "hatstand" becomes "hats"

;; L-LENGTH
L2B9B:  EX      (SP),HL         ; (*) length to stack, pointer to HL.
        EX      DE,HL           ; pointer to DE, start of string to HL.
        LD      A,B             ; is the length zero ?
        OR      C               ;
        JR      Z,L2BA3         ; forward to L-IN-W/S if so
                                ; leaving prepared spaces.

        LDIR                    ; else copy bytes overwriting some spaces.

;; L-IN-W/S
L2BA3:  POP     BC              ; pop the new length.  (*)
        POP     DE              ; pop pointer to new area.
        POP     HL              ; pop pointer to variable in assignment.
                                ; and continue copying from workspace
                                ; to variables area.

; ==> branch here from  L-NUMERIC

;; L-ENTER
L2BA6:  EX      DE,HL           ; exchange pointers HL=STKEND DE=end of vars.
        LD      A,B             ; test the length
        OR      C               ; and make a 
        RET     Z               ; return if zero (strings only).

        PUSH    DE              ; save start of destination.
        LDIR                    ; copy bytes.
        POP     HL              ; address the start.
        RET                     ; and return.

; ---

; the branch was here from L-DELETE$ if an existing simple string.
; register HL addresses start of string in variables area.

;; L-ADD$
L2BAF:  DEC     HL              ; point to high byte of length.
        DEC     HL              ; to low byte.
        DEC     HL              ; to letter.
        LD      A,(HL)          ; fetch masked letter to A.
        PUSH    HL              ; save the pointer on stack.
        PUSH    BC              ; save new length.
        CALL    L2BC6           ; routine L-STRING adds new string at end
                                ; of variables area.
                                ; if no room we still have old one.
        POP     BC              ; restore length.
        POP     HL              ; restore start.
        INC     BC              ; increase
        INC     BC              ; length by three
        INC     BC              ; to include character and length bytes.
        JP      L19E8           ; jump to indirect exit via RECLAIM-2
                                ; deleting old version and adjusting pointers.

; ---

; the jump was here with a new string variable.

;; L-NEW$
L2BC0:  LD      A,$DF           ; indicator mask %11011111 for
                                ;                %010xxxxx will be result
        LD      HL,($5C4D)      ; address DEST first character.
        AND     (HL)            ; combine mask with character.

;; L-STRING
L2BC6:  PUSH    AF              ; save first character and mask.
        CALL    L2BF1           ; routine STK-FETCH fetches parameters of
                                ; the string.
        EX      DE,HL           ; transfer start to HL.
        ADD     HL,BC           ; add to length.
        PUSH    BC              ; save the length.
        DEC     HL              ; point to end of string.
        LD      ($5C4D),HL      ; save pointer in DEST.
                                ; (updated by POINTERS if in workspace)
        INC     BC              ; extra byte for letter.
        INC     BC              ; two bytes
        INC     BC              ; for the length of string.
        LD      HL,($5C59)      ; address E_LINE.
        DEC     HL              ; now end of VARS area.
        CALL    L1655           ; routine MAKE-ROOM makes room for string.
                                ; updating pointers including DEST.
        LD      HL,($5C4D)      ; pick up pointer to end of string from DEST.
        POP     BC              ; restore length from stack.
        PUSH    BC              ; and save again on stack.
        INC     BC              ; add a byte.
        LDDR                    ; copy bytes from end to start.
        EX      DE,HL           ; HL addresses length low
        INC     HL              ; increase to address high byte
        POP     BC              ; restore length to BC
        LD      (HL),B          ; insert high byte
        DEC     HL              ; address low byte location
        LD      (HL),C          ; insert that byte
        POP     AF              ; restore character and mask

;; L-FIRST
L2BEA:  DEC     HL              ; address variable name
        LD      (HL),A          ; and insert character.
        LD      HL,($5C59)      ; load HL with E_LINE.
        DEC     HL              ; now end of VARS area.
        RET                     ; return

; ------------------------------------
; Get last value from calculator stack
; ------------------------------------
;
;

;; STK-FETCH
L2BF1:  LD      HL,($5C65)      ; STKEND
        DEC     HL              ;
        LD      B,(HL)          ;
        DEC     HL              ;
        LD      C,(HL)          ;
        DEC     HL              ;
        LD      D,(HL)          ;
        DEC     HL              ;
        LD      E,(HL)          ;
        DEC     HL              ;
        LD      A,(HL)          ;
        LD      ($5C65),HL      ; STKEND
        RET                     ;

; ------------------
; Handle DIM command
; ------------------
; e.g. DIM a(2,3,4,7): DIM a$(32) : DIM b$(20,2,768) : DIM c$(20000)
; the only limit to dimensions is memory so, for example,
; DIM a(2,2,2,2,2,2,2,2,2,2,2,2,2) is possible and creates a multi-
; dimensional array of zeros. String arrays are initialized to spaces.
; It is not possible to erase an array, but it can be re-dimensioned to
; a minimal size of 1, after use, to free up memory.

;; DIM
L2C02:  CALL    L28B2           ; routine LOOK-VARS

;; D-RPORT-C
L2C05:  JP      NZ,L1C8A        ; jump to REPORT-C if a long-name variable.
                                ; DIM lottery numbers(49) doesn't work.

        CALL    L2530           ; routine SYNTAX-Z
        JR      NZ,L2C15        ; forward to D-RUN in runtime.

        RES     6,C             ; signal 'numeric' array even if string as
                                ; this simplifies the syntax checking.

        CALL    L2996           ; routine STK-VAR checks syntax.
        CALL    L1BEE           ; routine CHECK-END performs early exit ->

; the branch was here in runtime.

;; D-RUN
L2C15:  JR      C,L2C1F         ; skip to D-LETTER if variable did not exist.
                                ; else reclaim the old one.

        PUSH    BC              ; save type in C.
        CALL    L19B8           ; routine NEXT-ONE find following variable
                                ; or position of $80 end-marker.
        CALL    L19E8           ; routine RECLAIM-2 reclaims the 
                                ; space between.
        POP     BC              ; pop the type.

;; D-LETTER
L2C1F:  SET     7,C             ; signal array.
        LD      B,$00           ; initialize dimensions to zero and
        PUSH    BC              ; save with the type.
        LD      HL,$0001        ; make elements one character presuming string
        BIT     6,C             ; is it a string ?
        JR      NZ,L2C2D        ; forward to D-SIZE if so.

        LD      L,$05           ; make elements 5 bytes as is numeric.

;; D-SIZE
L2C2D:  EX      DE,HL           ; save the element size in DE.

; now enter a loop to parse each of the integers in the list.

;; D-NO-LOOP
L2C2E:  RST     20H             ; NEXT-CHAR
        LD      H,$FF           ; disable limit check by setting HL high
        CALL    L2ACC           ; routine INT-EXP1
        JP      C,L2A20         ; to REPORT-3 if > 65280 and then some
                                ; 'Subscript out of range'

        POP     HL              ; pop dimension counter, array type
        PUSH    BC              ; save dimension size                     ***
        INC     H               ; increment the dimension counter
        PUSH    HL              ; save the dimension counter
        LD      H,B             ; transfer size
        LD      L,C             ; to HL
        CALL    L2AF4           ; routine GET-HL*DE multiplies dimension by
                                ; running total of size required initially
                                ; 1 or 5.
        EX      DE,HL           ; save running total in DE

        RST     18H             ; GET-CHAR
        CP      $2C             ; is it ',' ?
        JR      Z,L2C2E         ; loop back to D-NO-LOOP until all dimensions
                                ; have been considered

; when loop complete continue.

        CP      $29             ; is it ')' ?
        JR      NZ,L2C05        ; to D-RPORT-C with anything else
                                ; 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR advances to next statement/CR

        POP     BC              ; pop dimension counter/type
        LD      A,C             ; type to A

; now calculate space required for array variable

        LD      L,B             ; dimensions to L since these require 16 bits
                                ; then this value will be doubled
        LD      H,$00           ; set high byte to zero

; another four bytes are required for letter(1), total length(2), number of
; dimensions(1) but since we have yet to double allow for two

        INC     HL              ; increment
        INC     HL              ; increment

        ADD     HL,HL           ; now double giving 4 + dimensions * 2

        ADD     HL,DE           ; add to space required for array contents

        JP      C,L1F15         ; to REPORT-4 if > 65535
                                ; 'Out of memory'

        PUSH    DE              ; save data space
        PUSH    BC              ; save dimensions/type
        PUSH    HL              ; save total space
        LD      B,H             ; total space
        LD      C,L             ; to BC
        LD      HL,($5C59)      ; address E_LINE - first location after
                                ; variables area
        DEC     HL              ; point to location before - the $80 end-marker
        CALL    L1655           ; routine MAKE-ROOM creates the space if
                                ; memory is available.

        INC     HL              ; point to first new location and
        LD      (HL),A          ; store letter/type

        POP     BC              ; pop total space
        DEC     BC              ; exclude name
        DEC     BC              ; exclude the 16-bit
        DEC     BC              ; counter itself
        INC     HL              ; point to next location the 16-bit counter
        LD      (HL),C          ; insert low byte
        INC     HL              ; address next
        LD      (HL),B          ; insert high byte

        POP     BC              ; pop the number of dimensions.
        LD      A,B             ; dimensions to A
        INC     HL              ; address next
        LD      (HL),A          ; and insert "No. of dims"

        LD      H,D             ; transfer DE space + 1 from make-room
        LD      L,E             ; to HL
        DEC     DE              ; set DE to next location down.
        LD      (HL),$00        ; presume numeric and insert a zero
        BIT     6,C             ; test bit 6 of C. numeric or string ?
        JR      Z,L2C7C         ; skip to DIM-CLEAR if numeric

        LD      (HL),$20        ; place a space character in HL

;; DIM-CLEAR
L2C7C:  POP     BC              ; pop the data length

        LDDR                    ; LDDR sets to zeros or spaces

; The number of dimensions is still in A.
; A loop is now entered to insert the size of each dimension that was pushed
; during the D-NO-LOOP working downwards from position before start of data.

;; DIM-SIZES
L2C7F:  POP     BC              ; pop a dimension size                    ***
        LD      (HL),B          ; insert high byte at position
        DEC     HL              ; next location down
        LD      (HL),C          ; insert low byte
        DEC     HL              ; next location down
        DEC     A               ; decrement dimension counter
        JR      NZ,L2C7F        ; back to DIM-SIZES until all done.

        RET                     ; return.

; -----------------------------
; Check whether digit or letter
; -----------------------------
; This routine checks that the character in A is alphanumeric
; returning with carry set if so.

;; ALPHANUM
L2C88:  CALL    L2D1B           ; routine NUMERIC will reset carry if so.
        CCF                     ; Complement Carry Flag
        RET     C               ; Return if numeric else continue into
                                ; next routine.

; This routine checks that the character in A is alphabetic

;; ALPHA
L2C8D:  CP      $41             ; less than 'A' ?
        CCF                     ; Complement Carry Flag
        RET     NC              ; return if so

        CP      $5B             ; less than 'Z'+1 ?
        RET     C               ; is within first range

        CP      $61             ; less than 'a' ?
        CCF                     ; Complement Carry Flag
        RET     NC              ; return if so.

        CP      $7B             ; less than 'z'+1 ?
        RET                     ; carry set if within a-z.

; -------------------------
; Decimal to floating point
; -------------------------
; This routine finds the floating point number represented by an expression
; beginning with BIN, '.' or a digit.
; Note that BIN need not have any '0's or '1's after it.
; BIN is really just a notational symbol and not a function.

;; DEC-TO-FP
L2C9B:  CP      $C4             ; 'BIN' token ?
        JR      NZ,L2CB8        ; to NOT-BIN if not

        LD      DE,$0000        ; initialize 16 bit buffer register.

;; BIN-DIGIT
L2CA2:  RST     20H             ; NEXT-CHAR
        SUB     $31             ; '1'
        ADC     A,$00           ; will be zero if '1' or '0'
                                ; carry will be set if was '0'
        JR      NZ,L2CB3        ; forward to BIN-END if result not zero

        EX      DE,HL           ; buffer to HL
        CCF                     ; Carry now set if originally '1'
        ADC     HL,HL           ; shift the carry into HL
        JP      C,L31AD         ; to REPORT-6 if overflow - too many digits
                                ; after first '1'. There can be an unlimited
                                ; number of leading zeros.
                                ; 'Number too big' - raise an error

        EX      DE,HL           ; save the buffer
        JR      L2CA2           ; back to BIN-DIGIT for more digits

; ---

;; BIN-END
L2CB3:  LD      B,D             ; transfer 16 bit buffer
        LD      C,E             ; to BC register pair.
        JP      L2D2B           ; JUMP to STACK-BC to put on calculator stack

; ---

; continue here with .1,  42, 3.14, 5., 2.3 E -4

;; NOT-BIN
L2CB8:  CP      $2E             ; '.' - leading decimal point ?
        JR      Z,L2CCB         ; skip to DECIMAL if so.

        CALL    L2D3B           ; routine INT-TO-FP to evaluate all digits
                                ; This number 'x' is placed on stack.
        CP      $2E             ; '.' - mid decimal point ?

        JR      NZ,L2CEB        ; to E-FORMAT if not to consider that format

        RST     20H             ; NEXT-CHAR
        CALL    L2D1B           ; routine NUMERIC returns carry reset if 0-9

        JR      C,L2CEB         ; to E-FORMAT if not a digit e.g. '1.'

        JR      L2CD5           ; to DEC-STO-1 to add the decimal part to 'x'

; ---

; a leading decimal point has been found in a number.

;; DECIMAL
L2CCB:  RST     20H             ; NEXT-CHAR
        CALL    L2D1B           ; routine NUMERIC will reset carry if digit

;; DEC-RPT-C
L2CCF:  JP      C,L1C8A         ; to REPORT-C if just a '.'
                                ; raise 'Nonsense in BASIC'

; since there is no leading zero put one on the calculator stack.

        RST     28H             ;; FP-CALC
        DEFB    $A0             ;;stk-zero  ; 0.
        DEFB    $38             ;;end-calc

; If rejoining from earlier there will be a value 'x' on stack.
; If continuing from above the value zero.
; Now store 1 in mem-0.
; Note. At each pass of the digit loop this will be divided by ten.

;; DEC-STO-1
L2CD5:  RST     28H             ;; FP-CALC
        DEFB    $A1             ;;stk-one   ;x or 0,1.
        DEFB    $C0             ;;st-mem-0  ;x or 0,1.
        DEFB    $02             ;;delete    ;x or 0.
        DEFB    $38             ;;end-calc


;; NXT-DGT-1
L2CDA:  RST     18H             ; GET-CHAR
        CALL    L2D22           ; routine STK-DIGIT stacks single digit 'd'
        JR      C,L2CEB         ; exit to E-FORMAT when digits exhausted  >


        RST     28H             ;; FP-CALC   ;x or 0,d.           first pass.
        DEFB    $E0             ;;get-mem-0  ;x or 0,d,1.
        DEFB    $A4             ;;stk-ten    ;x or 0,d,1,10.
        DEFB    $05             ;;division   ;x or 0,d,1/10.
        DEFB    $C0             ;;st-mem-0   ;x or 0,d,1/10.
        DEFB    $04             ;;multiply   ;x or 0,d/10.
        DEFB    $0F             ;;addition   ;x or 0 + d/10.
        DEFB    $38             ;;end-calc   last value.

        RST     20H             ; NEXT-CHAR  moves to next character
        JR      L2CDA           ; back to NXT-DGT-1

; ---

; although only the first pass is shown it can be seen that at each pass
; the new less significant digit is multiplied by an increasingly smaller
; factor (1/100, 1/1000, 1/10000 ... ) before being added to the previous
; last value to form a new last value.

; Finally see if an exponent has been input.

;; E-FORMAT
L2CEB:  CP      $45             ; is character 'E' ?
        JR      Z,L2CF2         ; to SIGN-FLAG if so

        CP      $65             ; 'e' is acceptable as well.
        RET     NZ              ; return as no exponent.

;; SIGN-FLAG
L2CF2:  LD      B,$FF           ; initialize temporary sign byte to $FF

        RST     20H             ; NEXT-CHAR
        CP      $2B             ; is character '+' ?
        JR      Z,L2CFE         ; to SIGN-DONE

        CP      $2D             ; is character '-' ?
        JR      NZ,L2CFF        ; to ST-E-PART as no sign

        INC     B               ; set sign to zero

; now consider digits of exponent.
; Note. incidentally this is the only occasion in Spectrum BASIC when an
; expression may not be used when a number is expected.

;; SIGN-DONE
L2CFE:  RST     20H             ; NEXT-CHAR

;; ST-E-PART
L2CFF:  CALL    L2D1B           ; routine NUMERIC
        JR      C,L2CCF         ; to DEC-RPT-C if not
                                ; raise 'Nonsense in BASIC'.

        PUSH    BC              ; save sign (in B)
        CALL    L2D3B           ; routine INT-TO-FP places exponent on stack
        CALL    L2DD5           ; routine FP-TO-A  transfers it to A
        POP     BC              ; restore sign
        JP      C,L31AD         ; to REPORT-6 if overflow (over 255)
                                ; raise 'Number too big'.

        AND     A               ; set flags
        JP      M,L31AD         ; to REPORT-6 if over '127'.
                                ; raise 'Number too big'.
                                ; 127 is still way too high and it is
                                ; impossible to enter an exponent greater
                                ; than 39 from the keyboard. The error gets
                                ; raised later in E-TO-FP so two different
                                ; error messages depending how high A is.

        INC     B               ; $FF to $00 or $00 to $01 - expendable now.
        JR      Z,L2D18         ; forward to E-FP-JUMP if exponent positive

        NEG                     ; Negate the exponent.

;; E-FP-JUMP
L2D18:  JP      L2D4F           ; JUMP forward to E-TO-FP to assign to
                                ; last value x on stack x * 10 to power A
                                ; a relative jump would have done.

; ---------------------
; Check for valid digit
; ---------------------
; This routine checks that the ASCII character in A is numeric
; returning with carry reset if so.

;; NUMERIC
L2D1B:  CP      $30             ; '0'
        RET     C               ; return if less than zero character.

        CP      $3A             ; The upper test is '9'
        CCF                     ; Complement Carry Flag
        RET                     ; Return - carry clear if character '0' - '9'

; -----------
; Stack Digit
; -----------
; This subroutine is called from INT-TO-FP and DEC-TO-FP to stack a digit
; on the calculator stack.

;; STK-DIGIT
L2D22:  CALL    L2D1B           ; routine NUMERIC
        RET     C               ; return if not numeric character

        SUB     $30             ; convert from ASCII to digit

; -----------------
; Stack accumulator
; -----------------
;
;

;; STACK-A
L2D28:  LD      C,A             ; transfer to C
        LD      B,$00           ; and make B zero

; ----------------------
; Stack BC register pair
; ----------------------
;

;; STACK-BC
L2D2B:  LD      IY,$5C3A        ; re-initialize ERR_NR

        XOR     A               ; clear to signal small integer
        LD      E,A             ; place in E for sign
        LD      D,C             ; LSB to D
        LD      C,B             ; MSB to C
        LD      B,A             ; last byte not used
        CALL    L2AB6           ; routine STK-STORE

        RST     28H             ;; FP-CALC
        DEFB    $38             ;;end-calc  make HL = STKEND-5

        AND     A               ; clear carry
        RET                     ; before returning

; -------------------------
; Integer to floating point
; -------------------------
; This routine places one or more digits found in a BASIC line
; on the calculator stack multiplying the previous value by ten each time
; before adding in the new digit to form a last value on calculator stack.

;; INT-TO-FP
L2D3B:  PUSH    AF              ; save first character

        RST     28H             ;; FP-CALC
        DEFB    $A0             ;;stk-zero    ; v=0. initial value
        DEFB    $38             ;;end-calc

        POP     AF              ; fetch first character back.

;; NXT-DGT-2
L2D40:  CALL    L2D22           ; routine STK-DIGIT puts 0-9 on stack
        RET     C               ; will return when character is not numeric >

        RST     28H             ;; FP-CALC    ; v, d.
        DEFB    $01             ;;exchange    ; d, v.
        DEFB    $A4             ;;stk-ten     ; d, v, 10.
        DEFB    $04             ;;multiply    ; d, v*10.
        DEFB    $0F             ;;addition    ; d + v*10 = newvalue
        DEFB    $38             ;;end-calc    ; v.

        CALL    L0074           ; routine CH-ADD+1 get next character
        JR      L2D40           ; back to NXT-DGT-2 to process as a digit
