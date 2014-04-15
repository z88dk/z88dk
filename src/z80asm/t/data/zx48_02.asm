;*******************************
;** Part 2. KEYBOARD ROUTINES **
;*******************************

        PUBLIC L028E
        PUBLIC L02BF
        PUBLIC L031E
        PUBLIC L0333

        EXTERN L0205
        EXTERN L022C
        EXTERN L0246
        EXTERN L0260
        EXTERN L026A
        EXTERN L0284
	
;   Using shift keys and a combination of modes the Spectrum 40-key keyboard
;   can be mapped to 256 input characters

; ---------------------------------------------------------------------------
;
;         0     1     2     3     4 -Bits-  4     3     2     1     0
; PORT                                                                    PORT
;
; F7FE  [ 1 ] [ 2 ] [ 3 ] [ 4 ] [ 5 ]  |  [ 6 ] [ 7 ] [ 8 ] [ 9 ] [ 0 ]   EFFE
;  ^                                   |                                   v
; FBFE  [ Q ] [ W ] [ E ] [ R ] [ T ]  |  [ Y ] [ U ] [ I ] [ O ] [ P ]   DFFE
;  ^                                   |                                   v
; FDFE  [ A ] [ S ] [ D ] [ F ] [ G ]  |  [ H ] [ J ] [ K ] [ L ] [ ENT ] BFFE
;  ^                                   |                                   v
; FEFE  [SHI] [ Z ] [ X ] [ C ] [ V ]  |  [ B ] [ N ] [ M ] [sym] [ SPC ] 7FFE
;  ^     $27                                                 $18           v
; Start                                                                   End
;        00100111                                            00011000
;
; ---------------------------------------------------------------------------
;   The above map may help in reading.
;   The neat arrangement of ports means that the B register need only be
;   rotated left to work up the left hand side and then down the right
;   hand side of the keyboard. When the reset bit drops into the carry
;   then all 8 half-rows have been read. Shift is the first key to be
;   read. The lower six bits of the shifts are unambiguous.

; -------------------------------
; THE 'KEYBOARD SCANNING' ROUTINE
; -------------------------------
;   From keyboard and s-inkey$
;   Returns 1 or 2 keys in DE, most significant shift first if any
;   key values 0-39 else 255

;; KEY-SCAN
L028E:  LD      L,$2F           ; initial key value
                                ; valid values are obtained by subtracting
                                ; eight five times.
        LD      DE,$FFFF        ; a buffer to receive 2 keys.

        LD      BC,$FEFE        ; the commencing port address
                                ; B holds 11111110 initially and is also
                                ; used to count the 8 half-rows
;; KEY-LINE
L0296:  IN      A,(C)           ; read the port to A - bits will be reset
                                ; if a key is pressed else set.
        CPL                     ; complement - pressed key-bits are now set
        AND     $1F             ; apply 00011111 mask to pick up the
                                ; relevant set bits.

        JR      Z,L02AB         ; forward to KEY-DONE if zero and therefore
                                ; no keys pressed in row at all.

        LD      H,A             ; transfer row bits to H
        LD      A,L             ; load the initial key value to A

;; KEY-3KEYS
L029F:  INC     D               ; now test the key buffer
        RET     NZ              ; if we have collected 2 keys already
                                ; then too many so quit.

;; KEY-BITS
L02A1:  SUB     $08             ; subtract 8 from the key value
                                ; cycling through key values (top = $27)
                                ; e.g. 2F>   27>1F>17>0F>07
                                ;      2E>   26>1E>16>0E>06
        SRL     H               ; shift key bits right into carry.
        JR      NC,L02A1        ; back to KEY-BITS if not pressed
                                ; but if pressed we have a value (0-39d)

        LD      D,E             ; transfer a possible previous key to D
        LD      E,A             ; transfer the new key to E
        JR      NZ,L029F        ; back to KEY-3KEYS if there were more
                                ; set bits - H was not yet zero.

;; KEY-DONE
L02AB:  DEC     L               ; cycles 2F>2E>2D>2C>2B>2A>29>28 for
                                ; each half-row.
        RLC     B               ; form next port address e.g. FEFE > FDFE
        JR      C,L0296         ; back to KEY-LINE if still more rows to do.

        LD      A,D             ; now test if D is still FF ?
        INC     A               ; if it is zero we have at most 1 key
                                ; range now $01-$28  (1-40d)
        RET     Z               ; return if one key or no key.

        CP      $28             ; is it capsshift (was $27) ?
        RET     Z               ; return if so.

        CP      $19             ; is it symbol shift (was $18) ?
        RET     Z               ; return also

        LD      A,E             ; now test E
        LD      E,D             ; but first switch
        LD      D,A             ; the two keys.
        CP      $18             ; is it symbol shift ?
        RET                     ; return (with zero set if it was).
                                ; but with symbol shift now in D

; ----------------------
; THE 'KEYBOARD' ROUTINE
; ----------------------
;   Called from the interrupt 50 times a second.
;

;; KEYBOARD
L02BF:  CALL    L028E           ; routine KEY-SCAN
        RET     NZ              ; return if invalid combinations

;   then decrease the counters within the two key-state maps
;   as this could cause one to become free.
;   if the keyboard has not been pressed during the last five interrupts
;   then both sets will be free.


        LD      HL,$5C00        ; point to KSTATE-0

;; K-ST-LOOP
L02C6:  BIT     7,(HL)          ; is it free ?  (i.e. $FF)
        JR      NZ,L02D1        ; forward to K-CH-SET if so

        INC     HL              ; address the 5-counter
        DEC     (HL)            ; decrease the counter
        DEC     HL              ; step back

        JR      NZ,L02D1        ; forward to K-CH-SET if not at end of count

        LD      (HL),$FF        ; else mark this particular map free.

;; K-CH-SET
L02D1:  LD      A,L             ; make a copy of the low address byte.
        LD      HL,$5C04        ; point to KSTATE-4
                                ; (ld l,$04 would do)
        CP      L               ; have both sets been considered ?
        JR      NZ,L02C6        ; back to K-ST-LOOP to consider this 2nd set

;   now the raw key (0-38d) is converted to a main key (uppercase).

        CALL    L031E           ; routine K-TEST to get main key in A

        RET     NC              ; return if just a single shift

        LD      HL,$5C00        ; point to KSTATE-0
        CP      (HL)            ; does the main key code match ?
        JR      Z,L0310         ; forward to K-REPEAT if so

;   if not consider the second key map.

        EX      DE,HL           ; save kstate-0 in de
        LD      HL,$5C04        ; point to KSTATE-4
        CP      (HL)            ; does the main key code match ?
        JR      Z,L0310         ; forward to K-REPEAT if so

;   having excluded a repeating key we can now consider a new key.
;   the second set is always examined before the first.

        BIT     7,(HL)          ; is the key map free ?
        JR      NZ,L02F1        ; forward to K-NEW if so.

        EX      DE,HL           ; bring back KSTATE-0
        BIT     7,(HL)          ; is it free ?
        RET     Z               ; return if not.
                                ; as we have a key but nowhere to put it yet.

;   continue or jump to here if one of the buffers was free.

;; K-NEW
L02F1:  LD      E,A             ; store key in E
        LD      (HL),A          ; place in free location
        INC     HL              ; advance to the interrupt counter
        LD      (HL),$05        ; and initialize counter to 5
        INC     HL              ; advance to the delay
        LD      A,($5C09)       ; pick up the system variable REPDEL
        LD      (HL),A          ; and insert that for first repeat delay.
        INC     HL              ; advance to last location of state map.

        LD      C,(IY+$07)      ; pick up MODE  (3 bytes)
        LD      D,(IY+$01)      ; pick up FLAGS (3 bytes)
        PUSH    HL              ; save state map location
                                ; Note. could now have used, to avoid IY,
                                ; ld l,$41; ld c,(hl); ld l,$3B; ld d,(hl).
                                ; six and two threes of course.

        CALL    L0333           ; routine K-DECODE

        POP     HL              ; restore map pointer
        LD      (HL),A          ; put the decoded key in last location of map.

;; K-END
L0308:  LD      ($5C08),A       ; update LASTK system variable.
        SET     5,(IY+$01)      ; update FLAGS  - signal a new key.
        RET                     ; return to interrupt routine.

; -----------------------
; THE 'REPEAT KEY' BRANCH
; -----------------------
;   A possible repeat has been identified. HL addresses the raw key.
;   The last location of the key map holds the decoded key from the first 
;   context.  This could be a keyword and, with the exception of NOT a repeat 
;   is syntactically incorrect and not really desirable.

;; K-REPEAT
L0310:  INC     HL              ; increment the map pointer to second location.
        LD      (HL),$05        ; maintain interrupt counter at 5.
        INC     HL              ; now point to third location.
        DEC     (HL)            ; decrease the REPDEL value which is used to
                                ; time the delay of a repeat key.

        RET     NZ              ; return if not yet zero.

        LD      A,($5C0A)       ; fetch the system variable value REPPER.
        LD      (HL),A          ; for subsequent repeats REPPER will be used.

        INC     HL              ; advance
                                ;
        LD      A,(HL)          ; pick up the key decoded possibly in another
                                ; context.
                                ; Note. should compare with $A5 (RND) and make
                                ; a simple return if this is a keyword.
                                ; e.g. cp $a5; ret nc; (3 extra bytes)
        JR      L0308           ; back to K-END

; ----------------------
; THE 'KEY-TEST' ROUTINE
; ----------------------
;   also called from s-inkey$
;   begin by testing for a shift with no other.

;; K-TEST
L031E:  LD      B,D             ; load most significant key to B
                                ; will be $FF if not shift.
        LD      D,$00           ; and reset D to index into main table
        LD      A,E             ; load least significant key from E
        CP      $27             ; is it higher than 39d   i.e. FF
        RET     NC              ; return with just a shift (in B now)

        CP      $18             ; is it symbol shift ?
        JR      NZ,L032C        ; forward to K-MAIN if not

;   but we could have just symbol shift and no other

        BIT     7,B             ; is other key $FF (ie not shift)
        RET     NZ              ; return with solitary symbol shift


;; K-MAIN
L032C:  LD      HL,L0205        ; address: MAIN-KEYS
        ADD     HL,DE           ; add offset 0-38
        LD      A,(HL)          ; pick up main key value
        SCF                     ; set carry flag
        RET                     ; return    (B has other key still)

; ----------------------------------
; THE 'KEYBOARD DECODING' SUBROUTINE
; ----------------------------------
;   also called from s-inkey$

;; K-DECODE
L0333:  LD      A,E             ; pick up the stored main key
        CP      $3A             ; an arbitrary point between digits and letters
        JR      C,L0367         ; forward to K-DIGIT with digits, space, enter.

        DEC     C               ; decrease MODE ( 0='KLC', 1='E', 2='G')

        JP      M,L034F         ; to K-KLC-LET if was zero

        JR      Z,L0341         ; to K-E-LET if was 1 for extended letters.

;   proceed with graphic codes.
;   Note. should selectively drop return address if code > 'U' ($55).
;   i.e. abort the KEYBOARD call.
;   e.g. cp 'V'; jr c,addit; pop af ;pop af ;;addit etc. (6 extra bytes).
;   (s-inkey$ never gets into graphics mode.)
  
;; addit
        ADD     A,$4F           ; add offset to augment 'A' to graphics A say.
        RET                     ; return.
                                ; Note. ( but [GRAPH] V gives RND, etc ).

; ---

;   the jump was to here with extended mode with uppercase A-Z.

;; K-E-LET
L0341:  LD      HL,L022C-$41    ; base address of E-UNSHIFT L022c.
                                ; ( $01EB in standard ROM ).
        INC     B               ; test B is it empty i.e. not a shift.
        JR      Z,L034A         ; forward to K-LOOK-UP if neither shift.

        LD      HL,L0246-$41    ; Address: $0205 L0246-$41 EXT-SHIFT base

;; K-LOOK-UP
L034A:  LD      D,$00           ; prepare to index.
        ADD     HL,DE           ; add the main key value.
        LD      A,(HL)          ; pick up other mode value.
        RET                     ; return.

; ---

;   the jump was here with mode = 0

;; K-KLC-LET
L034F:  LD      HL,L026A-$41    ; prepare base of sym-codes
        BIT     0,B             ; shift=$27 sym-shift=$18
        JR      Z,L034A         ; back to K-LOOK-UP with symbol-shift

        BIT     3,D             ; test FLAGS is it 'K' mode (from OUT-CURS)
        JR      Z,L0364         ; skip to K-TOKENS if so

        BIT     3,(IY+$30)      ; test FLAGS2 - consider CAPS LOCK ?
        RET     NZ              ; return if so with main code.

        INC     B               ; is shift being pressed ?
                                ; result zero if not
        RET     NZ              ; return if shift pressed.

        ADD     A,$20           ; else convert the code to lower case.
        RET                     ; return.

; ---

;   the jump was here for tokens

;; K-TOKENS
L0364:  ADD     A,$A5           ; add offset to main code so that 'A'
                                ; becomes 'NEW' etc.

        RET                     ; return.

; ---

;   the jump was here with digits, space, enter and symbol shift (< $xx)

;; K-DIGIT
L0367:  CP      $30             ; is it '0' or higher ?
        RET     C               ; return with space, enter and symbol-shift

        DEC     C               ; test MODE (was 0='KLC', 1='E', 2='G')
        JP      M,L039D         ; jump to K-KLC-DGT if was 0.

        JR      NZ,L0389        ; forward to K-GRA-DGT if mode was 2.

;   continue with extended digits 0-9.

        LD      HL,L0284-$30    ; $0254 - base of E-DIGITS
        BIT     5,B             ; test - shift=$27 sym-shift=$18
        JR      Z,L034A         ; to K-LOOK-UP if sym-shift

        CP      $38             ; is character '8' ?
        JR      NC,L0382        ; to K-8-&-9 if greater than '7'

        SUB     $20             ; reduce to ink range $10-$17
        INC     B               ; shift ?
        RET     Z               ; return if not.

        ADD     A,$08           ; add 8 to give paper range $18 - $1F
        RET                     ; return

; ---

;   89

;; K-8-&-9
L0382:  SUB     $36             ; reduce to 02 and 03  bright codes
        INC     B               ; test if shift pressed.
        RET     Z               ; return if not.

        ADD     A,$FE           ; subtract 2 setting carry
        RET                     ; to give 0 and 1    flash codes.

; ---

;   graphics mode with digits

;; K-GRA-DGT
L0389:  LD      HL,L0260-$30    ; $0230 base address of CTL-CODES

        CP      $39             ; is key '9' ?
        JR      Z,L034A         ; back to K-LOOK-UP - changed to $0F, GRAPHICS.

        CP      $30             ; is key '0' ?
        JR      Z,L034A         ; back to K-LOOK-UP - changed to $0C, delete.

;   for keys '0' - '7' we assign a mosaic character depending on shift.

        AND     $07             ; convert character to number. 0 - 7.
        ADD     A,$80           ; add offset - they start at $80

        INC     B               ; destructively test for shift
        RET     Z               ; and return if not pressed.

        XOR     $0F             ; toggle bits becomes range $88-$8F
        RET                     ; return.

; ---

;   now digits in 'KLC' mode

;; K-KLC-DGT
L039D:  INC     B               ; return with digit codes if neither
        RET     Z               ; shift key pressed.

        BIT     5,B             ; test for caps shift.

        LD      HL,L0260-$30    ; prepare base of table CTL-CODES.
        JR      NZ,L034A        ; back to K-LOOK-UP if shift pressed.

;   must have been symbol shift

        SUB     $10             ; for ASCII most will now be correct
                                ; on a standard typewriter.

        CP      $22             ; but '@' is not - see below.
        JR      Z,L03B2         ; forward to K-@-CHAR if so

        CP      $20             ; '_' is the other one that fails
        RET     NZ              ; return if not.

        LD      A,$5F           ; substitute ASCII '_'
        RET                     ; return.

; ---

;; K-@-CHAR
L03B2:  LD      A,$40           ; substitute ASCII '@'
        RET                     ; return.


; ------------------------------------------------------------------------
;   The Spectrum Input character keys. One or two are abbreviated.
;   From $00 Flash 0 to $FF COPY. The routine above has decoded all these.

;  | 00 Fl0| 01 Fl1| 02 Br0| 03 Br1| 04 In0| 05 In1| 06 CAP| 07 EDT|
;  | 08 LFT| 09 RIG| 0A DWN| 0B UP | 0C DEL| 0D ENT| 0E SYM| 0F GRA|
;  | 10 Ik0| 11 Ik1| 12 Ik2| 13 Ik3| 14 Ik4| 15 Ik5| 16 Ik6| 17 Ik7|
;  | 18 Pa0| 19 Pa1| 1A Pa2| 1B Pa3| 1C Pa4| 1D Pa5| 1E Pa6| 1F Pa7|
;  | 20 SP | 21  ! | 22  " | 23  # | 24  $ | 25  % | 26  & | 27  ' |
;  | 28  ( | 29  ) | 2A  * | 2B  + | 2C  , | 2D  - | 2E  . | 2F  / |
;  | 30  0 | 31  1 | 32  2 | 33  3 | 34  4 | 35  5 | 36  6 | 37  7 |
;  | 38  8 | 39  9 | 3A  : | 3B  ; | 3C  < | 3D  = | 3E  > | 3F  ? |
;  | 40  @ | 41  A | 42  B | 43  C | 44  D | 45  E | 46  F | 47  G |
;  | 48  H | 49  I | 4A  J | 4B  K | 4C  L | 4D  M | 4E  N | 4F  O |
;  | 50  P | 51  Q | 52  R | 53  S | 54  T | 55  U | 56  V | 57  W |
;  | 58  X | 59  Y | 5A  Z | 5B  [ | 5C  \ | 5D  ] | 5E  ^ | 5F  _ |
;  | 60  £ | 61  a | 62  b | 63  c | 64  d | 65  e | 66  f | 67  g |
;  | 68  h | 69  i | 6A  j | 6B  k | 6C  l | 6D  m | 6E  n | 6F  o |
;  | 70  p | 71  q | 72  r | 73  s | 74  t | 75  u | 76  v | 77  w |
;  | 78  x | 79  y | 7A  z | 7B  { | 7C  | | 7D  } | 7E  ~ | 7F  © |
;  | 80 128| 81 129| 82 130| 83 131| 84 132| 85 133| 86 134| 87 135|
;  | 88 136| 89 137| 8A 138| 8B 139| 8C 140| 8D 141| 8E 142| 8F 143|
;  | 90 [A]| 91 [B]| 92 [C]| 93 [D]| 94 [E]| 95 [F]| 96 [G]| 97 [H]|
;  | 98 [I]| 99 [J]| 9A [K]| 9B [L]| 9C [M]| 9D [N]| 9E [O]| 9F [P]|
;  | A0 [Q]| A1 [R]| A2 [S]| A3 [T]| A4 [U]| A5 RND| A6 IK$| A7 PI |
;  | A8 FN | A9 PNT| AA SC$| AB ATT| AC AT | AD TAB| AE VL$| AF COD|
;  | B0 VAL| B1 LEN| B2 SIN| B3 COS| B4 TAN| B5 ASN| B6 ACS| B7 ATN|
;  | B8 LN | B9 EXP| BA INT| BB SQR| BC SGN| BD ABS| BE PEK| BF IN |
;  | C0 USR| C1 ST$| C2 CH$| C3 NOT| C4 BIN| C5 OR | C6 AND| C7 <= |
;  | C8 >= | C9 <> | CA LIN| CB THN| CC TO | CD STP| CE DEF| CF CAT|
;  | D0 FMT| D1 MOV| D2 ERS| D3 OPN| D4 CLO| D5 MRG| D6 VFY| D7 BEP|
;  | D8 CIR| D9 INK| DA PAP| DB FLA| DC BRI| DD INV| DE OVR| DF OUT|
;  | E0 LPR| E1 LLI| E2 STP| E3 REA| E4 DAT| E5 RES| E6 NEW| E7 BDR|
;  | E8 CON| E9 DIM| EA REM| EB FOR| EC GTO| ED GSB| EE INP| EF LOA|
;  | F0 LIS| F1 LET| F2 PAU| F3 NXT| F4 POK| F5 PRI| F6 PLO| F7 RUN|
;  | F8 SAV| F9 RAN| FA IF | FB CLS| FC DRW| FD CLR| FE RET| FF CPY|

;   Note that for simplicity, Sinclair have located all the control codes
;   below the space character.
;   ASCII DEL, $7F, has been made a copyright symbol.
;   Also $60, '`', not used in BASIC but used in other languages, has been
;   allocated the local currency symbol for the relevant country -
;    £  in most Spectrums.

; ------------------------------------------------------------------------
