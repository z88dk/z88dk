;****************************************
;** Part 4. CASSETTE HANDLING ROUTINES **
;****************************************

        PUBLIC L0605

        EXTERN L0C0A
        EXTERN L15D4
        EXTERN L1601
        EXTERN L1655
        EXTERN L19B8
        EXTERN L19E5
        EXTERN L19E8
        EXTERN L1ADF
        EXTERN L1BEE
        EXTERN L1C82
        EXTERN L1C8A
        EXTERN L1C8C
        EXTERN L1CE6
        EXTERN L1E99
        EXTERN L1F05
        EXTERN L2048
        EXTERN L24FB
        EXTERN L2530
        EXTERN L28B2
        EXTERN L2BF1

;   These routines begin with the service routines followed by a single
;   command entry point.
;   The first of these service routines is a curiosity.

; -----------------------
; THE 'ZX81 NAME' ROUTINE
; -----------------------
;   This routine fetches a filename in ZX81 format and is not used by the 
;   cassette handling routines in this ROM.

;; zx81-name
L04AA:  CALL    L24FB           ; routine SCANNING to evaluate expression.
        LD      A,($5C3B)       ; fetch system variable FLAGS.
        ADD     A,A             ; test bit 7 - syntax, bit 6 - result type.
        JP      M,L1C8A         ; to REPORT-C if not string result
                                ; 'Nonsense in BASIC'.

        POP     HL              ; drop return address.
        RET     NC              ; return early if checking syntax.

        PUSH    HL              ; re-save return address.
        CALL    L2BF1           ; routine STK-FETCH fetches string parameters.
        LD      H,D             ; transfer start of filename
        LD      L,E             ; to the HL register.
        DEC     C               ; adjust to point to last character and
        RET     M               ; return if the null string.
                                ; or multiple of 256!

        ADD     HL,BC           ; find last character of the filename.
                                ; and also clear carry.
        SET     7,(HL)          ; invert it.
        RET                     ; return.

; =========================================
;
; PORT 254 ($FE)
;
;                      spk mic { border  }  
;          ___ ___ ___ ___ ___ ___ ___ ___ 
; PORT    |   |   |   |   |   |   |   |   |
; 254     |   |   |   |   |   |   |   |   |
; $FE     |___|___|___|___|___|___|___|___|
;           7   6   5   4   3   2   1   0
;

; ----------------------------------
; Save header and program/data bytes
; ----------------------------------
;   This routine saves a section of data. It is called from SA-CTRL to save the
;   seventeen bytes of header data. It is also the exit route from that routine
;   when it is set up to save the actual data.
;   On entry -
;   HL points to start of data.
;   IX points to descriptor.
;   The accumulator is set to  $00 for a header, $FF for data.

;; SA-BYTES
L04C2:  LD      HL,L053F        ; address: SA/LD-RET
        PUSH    HL              ; is pushed as common exit route.
                                ; however there is only one non-terminal exit 
                                ; point.

        LD      HL,$1F80        ; a timing constant H=$1F, L=$80
                                ; inner and outer loop counters
                                ; a five second lead-in is used for a header.

        BIT     7,A             ; test one bit of accumulator.
                                ; (AND A ?)
        JR      Z,L04D0         ; skip to SA-FLAG if a header is being saved.

;   else is data bytes and a shorter lead-in is used.

        LD      HL,$0C98        ; another timing value H=$0C, L=$98.
                                ; a two second lead-in is used for the data.


;; SA-FLAG
L04D0:  EX      AF,AF'          ; save flag
        INC     DE              ; increase length by one.
        DEC     IX              ; decrease start.

        DI                      ; disable interrupts

        LD      A,$02           ; select red for border, microphone bit on.
        LD      B,A             ; also does as an initial slight counter value.

;; SA-LEADER
L04D8:  DJNZ    L04D8           ; self loop to SA-LEADER for delay.
                                ; after initial loop, count is $A4 (or $A3)

        OUT     ($FE),A         ; output byte $02/$0D to tape port.

        XOR     $0F             ; switch from RED (mic on) to CYAN (mic off).

        LD      B,$A4           ; hold count. also timed instruction.

        DEC     L               ; originally $80 or $98.
                                ; but subsequently cycles 256 times.
        JR      NZ,L04D8        ; back to SA-LEADER until L is zero.

;   the outer loop is counted by H

        DEC     B               ; decrement count
        DEC     H               ; originally  twelve or thirty-one.
        JP      P,L04D8         ; back to SA-LEADER until H becomes $FF

;   now send a sync pulse. At this stage mic is off and A holds value
;   for mic on.
;   A sync pulse is much shorter than the steady pulses of the lead-in.

        LD      B,$2F           ; another short timed delay.

;; SA-SYNC-1
L04EA:  DJNZ    L04EA           ; self loop to SA-SYNC-1

        OUT     ($FE),A         ; switch to mic on and red.
        LD      A,$0D           ; prepare mic off - cyan
        LD      B,$37           ; another short timed delay.

;; SA-SYNC-2
L04F2:  DJNZ    L04F2           ; self loop to SA-SYNC-2

        OUT     ($FE),A         ; output mic off, cyan border.
        LD      BC,$3B0E        ; B=$3B time(*), C=$0E, YELLOW, MIC OFF.

; 

        EX      AF,AF'          ; restore saved flag
                                ; which is 1st byte to be saved.

        LD      L,A             ; and transfer to L.
                                ; the initial parity is A, $FF or $00.
        JP      L0507           ; JUMP forward to SA-START     ->
                                ; the mid entry point of loop.

; -------------------------
;   During the save loop a parity byte is maintained in H.
;   the save loop begins by testing if reduced length is zero and if so
;   the final parity byte is saved reducing count to $FFFF.

;; SA-LOOP
L04FE:  LD      A,D             ; fetch high byte
        OR      E               ; test against low byte.
        JR      Z,L050E         ; forward to SA-PARITY if zero.

        LD      L,(IX+$00)      ; load currently addressed byte to L.

;; SA-LOOP-P
L0505:  LD      A,H             ; fetch parity byte.
        XOR     L               ; exclusive or with new byte.

; -> the mid entry point of loop.

;; SA-START
L0507:  LD      H,A             ; put parity byte in H.
        LD      A,$01           ; prepare blue, mic=on.
        SCF                     ; set carry flag ready to rotate in.
        JP      L0525           ; JUMP forward to SA-8-BITS            -8->

; ---

;; SA-PARITY
L050E:  LD      L,H             ; transfer the running parity byte to L and
        JR      L0505           ; back to SA-LOOP-P 
                                ; to output that byte before quitting normally.

; ---

;   The entry point to save yellow part of bit.
;   A bit consists of a period with mic on and blue border followed by 
;   a period of mic off with yellow border. 
;   Note. since the DJNZ instruction does not affect flags, the zero flag is 
;   used to indicate which of the two passes is in effect and the carry 
;   maintains the state of the bit to be saved.

;; SA-BIT-2
L0511:  LD      A,C             ; fetch 'mic on and yellow' which is 
                                ; held permanently in C.
        BIT     7,B             ; set the zero flag. B holds $3E.

;   The entry point to save 1 entire bit. For first bit B holds $3B(*).
;   Carry is set if saved bit is 1. zero is reset NZ on entry.

;; SA-BIT-1
L0514:  DJNZ    L0514           ; self loop for delay to SA-BIT-1

        JR      NC,L051C        ; forward to SA-OUT if bit is 0.

;   but if bit is 1 then the mic state is held for longer.

        LD      B,$42           ; set timed delay. (66 decimal)

;; SA-SET
L051A:  DJNZ    L051A           ; self loop to SA-SET 
                                ; (roughly an extra 66*13 clock cycles)

;; SA-OUT
L051C:  OUT     ($FE),A         ; blue and mic on OR  yellow and mic off.

        LD      B,$3E           ; set up delay
        JR      NZ,L0511        ; back to SA-BIT-2 if zero reset NZ (first pass)

;   proceed when the blue and yellow bands have been output.

        DEC     B               ; change value $3E to $3D.
        XOR     A               ; clear carry flag (ready to rotate in).
        INC     A               ; reset zero flag i.e. NZ.

; -8-> 

;; SA-8-BITS
L0525:  RL      L               ; rotate left through carry
                                ; C<76543210<C  
        JP      NZ,L0514        ; JUMP back to SA-BIT-1 
                                ; until all 8 bits done.

;   when the initial set carry is passed out again then a byte is complete.

        DEC     DE              ; decrease length
        INC     IX              ; increase byte pointer
        LD      B,$31           ; set up timing.

        LD      A,$7F           ; test the space key and
        IN      A,($FE)         ; return to common exit (to restore border)
        RRA                     ; if a space is pressed
        RET     NC              ; return to SA/LD-RET.   - - >

;   now test if byte counter has reached $FFFF.

        LD      A,D             ; fetch high byte
        INC     A               ; increment.
        JP      NZ,L04FE        ; JUMP to SA-LOOP if more bytes.

        LD      B,$3B           ; a final delay. 

;; SA-DELAY
L053C:  DJNZ    L053C           ; self loop to SA-DELAY

        RET                     ; return - - >

; ------------------------------
; THE 'SAVE/LOAD RETURN' ROUTINE
; ------------------------------
;   The address of this routine is pushed on the stack prior to any load/save
;   operation and it handles normal completion with the restoration of the
;   border and also abnormal termination when the break key, or to be more
;   precise the space key is pressed during a tape operation.
;
; - - >

;; SA/LD-RET
L053F:  PUSH    AF              ; preserve accumulator throughout.
        LD      A,($5C48)       ; fetch border colour from BORDCR.
        AND     $38             ; mask off paper bits.
        RRCA                    ; rotate
        RRCA                    ; to the
        RRCA                    ; range 0-7.

        OUT     ($FE),A         ; change the border colour.

        LD      A,$7F           ; read from port address $7FFE the
        IN      A,($FE)         ; row with the space key at outside.
 
        RRA                     ; test for space key pressed.
        EI                      ; enable interrupts
        JR      C,L0554         ; forward to SA/LD-END if not


;; REPORT-Da
L0552:  RST     08H             ; ERROR-1
        DEFB    $0C             ; Error Report: BREAK - CONT repeats

; ---

;; SA/LD-END
L0554:  POP     AF              ; restore the accumulator.
        RET                     ; return.

; ------------------------------------
; Load header or block of information
; ------------------------------------
;   This routine is used to load bytes and on entry A is set to $00 for a 
;   header or to $FF for data.  IX points to the start of receiving location 
;   and DE holds the length of bytes to be loaded. If, on entry the carry flag 
;   is set then data is loaded, if reset then it is verified.

;; LD-BYTES
L0556:  INC     D               ; reset the zero flag without disturbing carry.
        EX      AF,AF'          ; preserve entry flags.
        DEC     D               ; restore high byte of length.

        DI                      ; disable interrupts

        LD      A,$0F           ; make the border white and mic off.
        OUT     ($FE),A         ; output to port.

        LD      HL,L053F        ; Address: SA/LD-RET
        PUSH    HL              ; is saved on stack as terminating routine.

;   the reading of the EAR bit (D6) will always be preceded by a test of the 
;   space key (D0), so store the initial post-test state.

        IN      A,($FE)         ; read the ear state - bit 6.
        RRA                     ; rotate to bit 5.
        AND     $20             ; isolate this bit.
        OR      $02             ; combine with red border colour.
        LD      C,A             ; and store initial state long-term in C.
        CP      A               ; set the zero flag.

; 

;; LD-BREAK
L056B:  RET     NZ              ; return if at any time space is pressed.

;; LD-START
L056C:  CALL    L05E7           ; routine LD-EDGE-1
        JR      NC,L056B        ; back to LD-BREAK with time out and no
                                ; edge present on tape.

;   but continue when a transition is found on tape.

        LD      HL,$0415        ; set up 16-bit outer loop counter for 
                                ; approx 1 second delay.

;; LD-WAIT
L0574:  DJNZ    L0574           ; self loop to LD-WAIT (for 256 times)

        DEC     HL              ; decrease outer loop counter.
        LD      A,H             ; test for
        OR      L               ; zero.
        JR      NZ,L0574        ; back to LD-WAIT, if not zero, with zero in B.

;   continue after delay with H holding zero and B also.
;   sample 256 edges to check that we are in the middle of a lead-in section. 

        CALL    L05E3           ; routine LD-EDGE-2
        JR      NC,L056B        ; back to LD-BREAK
                                ; if no edges at all.

;; LD-LEADER
L0580:  LD      B,$9C           ; set timing value.
        CALL    L05E3           ; routine LD-EDGE-2
        JR      NC,L056B        ; back to LD-BREAK if time-out

        LD      A,$C6           ; two edges must be spaced apart.
        CP      B               ; compare
        JR      NC,L056C        ; back to LD-START if too close together for a 
                                ; lead-in.

        INC     H               ; proceed to test 256 edged sample.
        JR      NZ,L0580        ; back to LD-LEADER while more to do.

;   sample indicates we are in the middle of a two or five second lead-in.
;   Now test every edge looking for the terminal sync signal.

;; LD-SYNC
L058F:  LD      B,$C9           ; initial timing value in B.
        CALL    L05E7           ; routine LD-EDGE-1
        JR      NC,L056B        ; back to LD-BREAK with time-out.

        LD      A,B             ; fetch augmented timing value from B.
        CP      $D4             ; compare 
        JR      NC,L058F        ; back to LD-SYNC if gap too big, that is,
                                ; a normal lead-in edge gap.

;   but a short gap will be the sync pulse.
;   in which case another edge should appear before B rises to $FF

        CALL    L05E7           ; routine LD-EDGE-1
        RET     NC              ; return with time-out.

; proceed when the sync at the end of the lead-in is found.
; We are about to load data so change the border colours.

        LD      A,C             ; fetch long-term mask from C
        XOR     $03             ; and make blue/yellow.

        LD      C,A             ; store the new long-term byte.

        LD      H,$00           ; set up parity byte as zero.
        LD      B,$B0           ; timing.
        JR      L05C8           ; forward to LD-MARKER 
                                ; the loop mid entry point with the alternate 
                                ; zero flag reset to indicate first byte 
                                ; is discarded.

; --------------
;   the loading loop loads each byte and is entered at the mid point.

;; LD-LOOP
L05A9:  EX      AF,AF'          ; restore entry flags and type in A.
        JR      NZ,L05B3        ; forward to LD-FLAG if awaiting initial flag
                                ; which is to be discarded.

        JR      NC,L05BD        ; forward to LD-VERIFY if not to be loaded.

        LD      (IX+$00),L      ; place loaded byte at memory location.
        JR      L05C2           ; forward to LD-NEXT

; ---

;; LD-FLAG
L05B3:  RL      C               ; preserve carry (verify) flag in long-term
                                ; state byte. Bit 7 can be lost.

        XOR     L               ; compare type in A with first byte in L.
        RET     NZ              ; return if no match e.g. CODE vs. DATA.

;   continue when data type matches.

        LD      A,C             ; fetch byte with stored carry
        RRA                     ; rotate it to carry flag again
        LD      C,A             ; restore long-term port state.

        INC     DE              ; increment length ??
        JR      L05C4           ; forward to LD-DEC.
                                ; but why not to location after ?

; ---
;   for verification the byte read from tape is compared with that in memory.

;; LD-VERIFY
L05BD:  LD      A,(IX+$00)      ; fetch byte from memory.
        XOR     L               ; compare with that on tape
        RET     NZ              ; return if not zero. 

;; LD-NEXT
L05C2:  INC     IX              ; increment byte pointer.

;; LD-DEC
L05C4:  DEC     DE              ; decrement length.
        EX      AF,AF'          ; store the flags.
        LD      B,$B2           ; timing.

;   when starting to read 8 bits the receiving byte is marked with bit at right.
;   when this is rotated out again then 8 bits have been read.

;; LD-MARKER
L05C8:  LD      L,$01           ; initialize as %00000001

;; LD-8-BITS
L05CA:  CALL    L05E3           ; routine LD-EDGE-2 increments B relative to
                                ; gap between 2 edges.
        RET     NC              ; return with time-out.

        LD      A,$CB           ; the comparison byte.
        CP      B               ; compare to incremented value of B.
                                ; if B is higher then bit on tape was set.
                                ; if <= then bit on tape is reset. 

        RL      L               ; rotate the carry bit into L.

        LD      B,$B0           ; reset the B timer byte.
        JP      NC,L05CA        ; JUMP back to LD-8-BITS

;   when carry set then marker bit has been passed out and byte is complete.

        LD      A,H             ; fetch the running parity byte.
        XOR     L               ; include the new byte.
        LD      H,A             ; and store back in parity register.

        LD      A,D             ; check length of
        OR      E               ; expected bytes.
        JR      NZ,L05A9        ; back to LD-LOOP 
                                ; while there are more.

;   when all bytes loaded then parity byte should be zero.

        LD      A,H             ; fetch parity byte.
        CP      $01             ; set carry if zero.
        RET                     ; return
                                ; in no carry then error as checksum disagrees.

; -------------------------
; Check signal being loaded
; -------------------------
;   An edge is a transition from one mic state to another.
;   More specifically a change in bit 6 of value input from port $FE.
;   Graphically it is a change of border colour, say, blue to yellow.
;   The first entry point looks for two adjacent edges. The second entry point
;   is used to find a single edge.
;   The B register holds a count, up to 256, within which the edge (or edges) 
;   must be found. The gap between two edges will be more for a '1' than a '0'
;   so the value of B denotes the state of the bit (two edges) read from tape.

; ->

;; LD-EDGE-2
L05E3:  CALL    L05E7           ; call routine LD-EDGE-1 below.
        RET     NC              ; return if space pressed or time-out.
                                ; else continue and look for another adjacent 
                                ; edge which together represent a bit on the 
                                ; tape.

; -> 
;   this entry point is used to find a single edge from above but also 
;   when detecting a read-in signal on the tape.

;; LD-EDGE-1
L05E7:  LD      A,$16           ; a delay value of twenty two.

;; LD-DELAY
L05E9:  DEC     A               ; decrement counter
        JR      NZ,L05E9        ; loop back to LD-DELAY 22 times.

        AND      A              ; clear carry.

;; LD-SAMPLE
L05ED:  INC     B               ; increment the time-out counter.
        RET     Z               ; return with failure when $FF passed.

        LD      A,$7F           ; prepare to read keyboard and EAR port
        IN      A,($FE)         ; row $7FFE. bit 6 is EAR, bit 0 is SPACE key.
        RRA                     ; test outer key the space. (bit 6 moves to 5)
        RET     NC              ; return if space pressed.  >>>

        XOR     C               ; compare with initial long-term state.
        AND     $20             ; isolate bit 5
        JR      Z,L05ED         ; back to LD-SAMPLE if no edge.

;   but an edge, a transition of the EAR bit, has been found so switch the
;   long-term comparison byte containing both border colour and EAR bit. 

        LD      A,C             ; fetch comparison value.
        CPL                     ; switch the bits
        LD      C,A             ; and put back in C for long-term.

        AND     $07             ; isolate new colour bits.
        OR      $08             ; set bit 3 - MIC off.
        OUT     ($FE),A         ; send to port to effect the change of colour. 

        SCF                     ; set carry flag signaling edge found within
                                ; time allowed.
        RET                     ; return.

; ---------------------------------
; Entry point for all tape commands
; ---------------------------------
;   This is the single entry point for the four tape commands.
;   The routine first determines in what context it has been called by examining
;   the low byte of the Syntax table entry which was stored in T_ADDR.
;   Subtracting $EO (the present arrangement) gives a value of
;   $00 - SAVE
;   $01 - LOAD
;   $02 - VERIFY
;   $03 - MERGE
;   As with all commands the address STMT-RET is on the stack.

;; SAVE-ETC
L0605:  POP     AF              ; discard address STMT-RET.
        LD      A,($5C74)       ; fetch T_ADDR

;   Now reduce the low byte of the Syntax table entry to give command.
;   Note. For ZASM use SUB $E0 as next instruction.

L0609:  SUB     +(L1ADF + 1) % 256 ; subtract the known offset.
                                ; ( is SUB $E0 in standard ROM )

        LD      ($5C74),A       ; and put back in T_ADDR as 0,1,2, or 3
                                ; for future reference.

        CALL    L1C8C           ; routine EXPT-EXP checks that a string
                                ; expression follows and stacks the
                                ; parameters in run-time.

        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L0652         ; forward to SA-DATA if checking syntax.

        LD      BC,$0011        ; presume seventeen bytes for a header.
        LD      A,($5C74)       ; fetch command from T_ADDR.
        AND     A               ; test for zero - SAVE.
        JR      Z,L0621         ; forward to SA-SPACE if so.

        LD      C,$22           ; else double length to thirty four.

;; SA-SPACE
L0621:  RST     30H             ; BC-SPACES creates 17/34 bytes in workspace.

        PUSH    DE              ; transfer the start of new space to
        POP     IX              ; the available index register.

;   ten spaces are required for the default filename but it is simpler to
;   overwrite the first file-type indicator byte as well.

        LD      B,$0B           ; set counter to eleven.
        LD      A,$20           ; prepare a space.

;; SA-BLANK
L0629:  LD      (DE),A          ; set workspace location to space.
        INC     DE              ; next location.
        DJNZ    L0629           ; loop back to SA-BLANK till all eleven done.

        LD      (IX+$01),$FF    ; set first byte of ten character filename
                                ; to $FF as a default to signal null string.

        CALL    L2BF1           ; routine STK-FETCH fetches the filename
                                ; parameters from the calculator stack.
                                ; length of string in BC.
                                ; start of string in DE.

        LD      HL,$FFF6        ; prepare the value minus ten.
        DEC     BC              ; decrement length.
                                ; ten becomes nine, zero becomes $FFFF.
        ADD     HL,BC           ; trial addition.
        INC     BC              ; restore true length.
        JR      NC,L064B        ; forward to SA-NAME if length is one to ten.

;   the filename is more than ten characters in length or the null string.

        LD      A,($5C74)       ; fetch command from T_ADDR.
        AND     A               ; test for zero - SAVE.
        JR      NZ,L0644        ; forward to SA-NULL if not the SAVE command.

;   but no more than ten characters are allowed for SAVE.
;   The first ten characters of any other command parameter are acceptable.
;   Weird, but necessary, if saving to sectors.
;   Note. the golden rule that there are no restriction on anything is broken.

;; REPORT-Fa
L0642:  RST     08H             ; ERROR-1
        DEFB    $0E             ; Error Report: Invalid file name

;   continue with LOAD, MERGE, VERIFY and also SAVE within ten character limit.

;; SA-NULL
L0644:  LD      A,B             ; test length of filename
        OR      C               ; for zero.
        JR      Z,L0652         ; forward to SA-DATA if so using the 255 
                                ; indicator followed by spaces.

        LD      BC,$000A        ; else trim length to ten.

;   other paths rejoin here with BC holding length in range 1 - 10.

;; SA-NAME
L064B:  PUSH    IX              ; push start of file descriptor.
        POP     HL              ; and pop into HL.

        INC     HL              ; HL now addresses first byte of filename.
        EX      DE,HL           ; transfer destination address to DE, start
                                ; of string in command to HL.
        LDIR                    ; copy up to ten bytes
                                ; if less than ten then trailing spaces follow.

;   the case for the null string rejoins here.

;; SA-DATA
L0652:  RST     18H             ; GET-CHAR
        CP      $E4             ; is character after filename the token 'DATA' ?
        JR      NZ,L06A0        ; forward to SA-SCR$ to consider SCREEN$ if
                                ; not.

;   continue to consider DATA.

        LD      A,($5C74)       ; fetch command from T_ADDR
        CP      $03             ; is it 'VERIFY' ?
        JP      Z,L1C8A         ; jump forward to REPORT-C if so.
                                ; 'Nonsense in BASIC'
                                ; VERIFY "d" DATA is not allowed.

;   continue with SAVE, LOAD, MERGE of DATA.

        RST     20H             ; NEXT-CHAR
        CALL    L28B2           ; routine LOOK-VARS searches variables area
                                ; returning with carry reset if found or
                                ; checking syntax.
        SET     7,C             ; this converts a simple string to a 
                                ; string array. The test for an array or string
                                ; comes later.
        JR      NC,L0672        ; forward to SA-V-OLD if variable found.

        LD      HL,$0000        ; set destination to zero as not fixed.
        LD      A,($5C74)       ; fetch command from T_ADDR
        DEC     A               ; test for 1 - LOAD
        JR      Z,L0685         ; forward to SA-V-NEW with LOAD DATA.
                                ; to load a new array.

;   otherwise the variable was not found in run-time with SAVE/MERGE.

;; REPORT-2a
L0670:  RST     08H             ; ERROR-1
        DEFB    $01             ; Error Report: Variable not found

;   continue with SAVE/LOAD  DATA

;; SA-V-OLD
L0672:  JP      NZ,L1C8A        ; to REPORT-C if not an array variable.
                                ; or erroneously a simple string.
                                ; 'Nonsense in BASIC'


        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L0692         ; forward to SA-DATA-1 if checking syntax.

        INC     HL              ; step past single character variable name.
        LD      A,(HL)          ; fetch low byte of length.
        LD      (IX+$0B),A      ; place in descriptor.
        INC     HL              ; point to high byte.
        LD      A,(HL)          ; and transfer that
        LD      (IX+$0C),A      ; to descriptor.
        INC     HL              ; increase pointer within variable.

;; SA-V-NEW
L0685:  LD      (IX+$0E),C      ; place character array name in  header.
        LD      A,$01           ; default to type numeric.
        BIT     6,C             ; test result from look-vars.
        JR      Z,L068F         ; forward to SA-V-TYPE if numeric.

        INC     A               ; set type to 2 - string array.

;; SA-V-TYPE
L068F:  LD      (IX+$00),A      ; place type 0, 1 or 2 in descriptor.

;; SA-DATA-1
L0692:  EX      DE,HL           ; save var pointer in DE

        RST     20H             ; NEXT-CHAR
        CP      $29             ; is character ')' ?
        JR      NZ,L0672        ; back if not to SA-V-OLD to report
                                ; 'Nonsense in BASIC'

        RST     20H             ; NEXT-CHAR advances character address.
        CALL    L1BEE           ; routine CHECK-END errors if not end of
                                ; the statement.

        EX      DE,HL           ; bring back variables data pointer.
        JP      L075A           ; jump forward to SA-ALL

; ---
;   the branch was here to consider a 'SCREEN$', the display file.

;; SA-SCR$
L06A0:  CP      $AA             ; is character the token 'SCREEN$' ?
        JR      NZ,L06C3        ; forward to SA-CODE if not.

        LD      A,($5C74)       ; fetch command from T_ADDR
        CP      $03             ; is it MERGE ?
        JP       Z,L1C8A        ; jump to REPORT-C if so.
                                ; 'Nonsense in BASIC'

;   continue with SAVE/LOAD/VERIFY SCREEN$.

        RST     20H             ; NEXT-CHAR
        CALL    L1BEE           ; routine CHECK-END errors if not at end of
                                ; statement.

;   continue in runtime.

        LD      (IX+$0B),$00    ; set descriptor length
        LD      (IX+$0C),$1B    ; to $1b00 to include bitmaps and attributes.

        LD      HL,$4000        ; set start to display file start.
        LD      (IX+$0D),L      ; place start in
        LD      (IX+$0E),H      ; the descriptor.
        JR      L0710           ; forward to SA-TYPE-3

; ---
;   the branch was here to consider CODE.

;; SA-CODE
L06C3:  CP      $AF             ; is character the token 'CODE' ?
        JR      NZ,L0716        ; forward if not to SA-LINE to consider an
                                ; auto-started BASIC program.

        LD      A,($5C74)       ; fetch command from T_ADDR
        CP      $03             ; is it MERGE ?
        JP      Z,L1C8A         ; jump forward to REPORT-C if so.
                                ; 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR advances character address.
        CALL    L2048           ; routine PR-ST-END checks if a carriage
                                ; return or ':' follows.
        JR      NZ,L06E1        ; forward to SA-CODE-1 if there are parameters.

        LD      A,($5C74)       ; else fetch the command from T_ADDR.
        AND     A               ; test for zero - SAVE without a specification.
        JP      Z,L1C8A         ; jump to REPORT-C if so.
                                ; 'Nonsense in BASIC'

;   for LOAD/VERIFY put zero on stack to signify handle at location saved from.

        CALL    L1CE6           ; routine USE-ZERO
        JR      L06F0           ; forward to SA-CODE-2

; ---

;   if there are more characters after CODE expect start and possibly length.

;; SA-CODE-1
L06E1:  CALL    L1C82           ; routine EXPT-1NUM checks for numeric
                                ; expression and stacks it in run-time.

        RST     18H             ; GET-CHAR
        CP      $2C             ; does a comma follow ?
        JR      Z,L06F5         ; forward if so to SA-CODE-3

;   else allow saved code to be loaded to a specified address.

        LD      A,($5C74)       ; fetch command from T_ADDR.
        AND     A               ; is the command SAVE which requires length ?
        JP      Z,L1C8A         ; jump to REPORT-C if so.
                                ; 'Nonsense in BASIC'

;   the command LOAD code may rejoin here with zero stacked as start.

;; SA-CODE-2
L06F0:  CALL    L1CE6           ; routine USE-ZERO stacks zero for length.
        JR      L06F9           ; forward to SA-CODE-4

; ---
;   the branch was here with SAVE CODE start, 

;; SA-CODE-3
L06F5:  RST     20H             ; NEXT-CHAR advances character address.
        CALL    L1C82           ; routine EXPT-1NUM checks for expression
                                ; and stacks in run-time.

;   paths converge here and nothing must follow.

;; SA-CODE-4
L06F9:  CALL    L1BEE           ; routine CHECK-END errors with extraneous
                                ; characters and quits if checking syntax.

;   in run-time there are two 16-bit parameters on the calculator stack.

        CALL    L1E99           ; routine FIND-INT2 gets length.
        LD      (IX+$0B),C      ; place length 
        LD      (IX+$0C),B      ; in descriptor.
        CALL    L1E99           ; routine FIND-INT2 gets start.
        LD      (IX+$0D),C      ; place start
        LD      (IX+$0E),B      ; in descriptor.
        LD      H,B             ; transfer the
        LD      L,C             ; start to HL also.

;; SA-TYPE-3
L0710:  LD      (IX+$00),$03    ; place type 3 - code in descriptor. 
        JR      L075A           ; forward to SA-ALL.

; ---
;   the branch was here with BASIC to consider an optional auto-start line
;   number.

;; SA-LINE
L0716:  CP      $CA             ; is character the token 'LINE' ?
        JR      Z,L0723         ; forward to SA-LINE-1 if so.

;   else all possibilities have been considered and nothing must follow.

        CALL    L1BEE           ; routine CHECK-END

;   continue in run-time to save BASIC without auto-start.

        LD      (IX+$0E),$80    ; place high line number in descriptor to
                                ; disable auto-start.
        JR      L073A           ; forward to SA-TYPE-0 to save program.

; ---
;   the branch was here to consider auto-start.

;; SA-LINE-1
L0723:  LD      A,($5C74)       ; fetch command from T_ADDR
        AND     A               ; test for SAVE.
        JP      NZ,L1C8A        ; jump forward to REPORT-C with anything else.
                                ; 'Nonsense in BASIC'

; 

        RST     20H             ; NEXT-CHAR
        CALL    L1C82           ; routine EXPT-1NUM checks for numeric
                                ; expression and stacks in run-time.
        CALL    L1BEE           ; routine CHECK-END quits if syntax path.
        CALL    L1E99           ; routine FIND-INT2 fetches the numeric
                                ; expression.
        LD      (IX+$0D),C      ; place the auto-start
        LD      (IX+$0E),B      ; line number in the descriptor.

;   Note. this isn't checked, but is subsequently handled by the system.
;   If the user typed 40000 instead of 4000 then it won't auto-start
;   at line 4000, or indeed, at all.

;   continue to save program and any variables.

;; SA-TYPE-0
L073A:  LD      (IX+$00),$00    ; place type zero - program in descriptor.
        LD      HL,($5C59)      ; fetch E_LINE to HL.
        LD      DE,($5C53)      ; fetch PROG to DE.
        SCF                     ; set carry flag to calculate from end of
                                ; variables E_LINE -1.
        SBC     HL,DE           ; subtract to give total length.

        LD      (IX+$0B),L      ; place total length
        LD      (IX+$0C),H      ; in descriptor.
        LD      HL,($5C4B)      ; load HL from system variable VARS
        SBC     HL,DE           ; subtract to give program length.
        LD      (IX+$0F),L      ; place length of program
        LD      (IX+$10),H      ; in the descriptor.
        EX      DE,HL           ; start to HL, length to DE.

;; SA-ALL
L075A:  LD      A,($5C74)       ; fetch command from T_ADDR
        AND     A               ; test for zero - SAVE.
        JP      Z,L0970         ; jump forward to SA-CONTRL with SAVE  ->

; ---
;   continue with LOAD, MERGE and VERIFY.

        PUSH    HL              ; save start.
        LD      BC,$0011        ; prepare to add seventeen
        ADD     IX,BC           ; to point IX at second descriptor.

;; LD-LOOK-H
L0767:  PUSH    IX              ; save IX
        LD      DE,$0011        ; seventeen bytes
        XOR     A               ; reset zero flag
        SCF                     ; set carry flag
        CALL    L0556           ; routine LD-BYTES loads a header from tape
                                ; to second descriptor.
        POP     IX              ; restore IX.
        JR      NC,L0767        ; loop back to LD-LOOK-H until header found.

        LD      A,$FE           ; select system channel 'S'
        CALL    L1601           ; routine CHAN-OPEN opens it.

        LD      (IY+$52),$03    ; set SCR_CT to 3 lines.

        LD      C,$80           ; C has bit 7 set to indicate type mismatch as
                                ; a default startpoint.

        LD      A,(IX+$00)      ; fetch loaded header type to A
        CP      (IX-$11)        ; compare with expected type.
        JR      NZ,L078A        ; forward to LD-TYPE with mis-match.

        LD      C,$F6           ; set C to minus ten - will count characters
                                ; up to zero.

;; LD-TYPE
L078A:  CP      $04             ; check if type in acceptable range 0 - 3.
        JR      NC,L0767        ; back to LD-LOOK-H with 4 and over.

;   else A indicates type 0-3.

        LD      DE,L09C0        ; address base of last 4 tape messages
        PUSH    BC              ; save BC
        CALL    L0C0A           ; routine PO-MSG outputs relevant message.
                                ; Note. all messages have a leading newline.
        POP     BC              ; restore BC

        PUSH    IX              ; transfer IX,
        POP     DE              ; the 2nd descriptor, to DE.
        LD      HL,$FFF0        ; prepare minus seventeen.
        ADD     HL,DE           ; add to point HL to 1st descriptor.
        LD      B,$0A           ; the count will be ten characters for the
                                ; filename.

        LD      A,(HL)          ; fetch first character and test for 
        INC     A               ; value 255.
        JR      NZ,L07A6        ; forward to LD-NAME if not the wildcard.

;   but if it is the wildcard, then add ten to C which is minus ten for a type
;   match or -128 for a type mismatch. Although characters have to be counted
;   bit 7 of C will not alter from state set here.

        LD      A,C             ; transfer $F6 or $80 to A
        ADD     A,B             ; add $0A
        LD      C,A             ; place result, zero or -118, in C.

;   At this point we have either a type mismatch, a wildcard match or ten
;   characters to be counted. The characters must be shown on the screen.

;; LD-NAME
L07A6:  INC     DE              ; address next input character
        LD      A,(DE)          ; fetch character
        CP      (HL)            ; compare to expected
        INC     HL              ; address next expected character
        JR      NZ,L07AD        ; forward to LD-CH-PR with mismatch

        INC     C               ; increment matched character count

;; LD-CH-PR
L07AD:  RST     10H             ; PRINT-A prints character
        DJNZ    L07A6           ; loop back to LD-NAME for ten characters.

;   if ten characters matched and the types previously matched then C will 
;   now hold zero.

        BIT     7,C             ; test if all matched
        JR      NZ,L0767        ; back to LD-LOOK-H if not

;   else print a terminal carriage return.

        LD      A,$0D           ; prepare carriage return.
        RST     10H             ; PRINT-A outputs it.

;   The various control routines for LOAD, VERIFY and MERGE are executed 
;   during the one-second gap following the header on tape.

        POP     HL              ; restore xx
        LD      A,(IX+$00)      ; fetch incoming type 
        CP      $03             ; compare with CODE
        JR      Z,L07CB         ; forward to VR-CONTRL if it is CODE.

;  type is a program or an array.

        LD      A,($5C74)       ; fetch command from T_ADDR
        DEC     A               ; was it LOAD ?
        JP      Z,L0808         ; JUMP forward to LD-CONTRL if so to 
                                ; load BASIC or variables.

        CP      $02             ; was command MERGE ?
        JP      Z,L08B6         ; jump forward to ME-CONTRL if so.

;   else continue into VERIFY control routine to verify.

; ----------------------------
; THE 'VERIFY CONTROL' ROUTINE
; ----------------------------
;   There are two branches to this routine.
;   1) From above to verify a program or array
;   2) from earlier with no carry to load or verify code.

;; VR-CONTRL
L07CB:  PUSH    HL              ; save pointer to data.
        LD      L,(IX-$06)      ; fetch length of old data 
        LD      H,(IX-$05)      ; to HL.
        LD      E,(IX+$0B)      ; fetch length of new data
        LD      D,(IX+$0C)      ; to DE.
        LD      A,H             ; check length of old
        OR      L               ; for zero.
        JR      Z,L07E9         ; forward to VR-CONT-1 if length unspecified
                                ; e.g. LOAD "x" CODE

;   as opposed to, say, LOAD 'x' CODE 32768,300.

        SBC     HL,DE           ; subtract the two lengths.
        JR      C,L0806         ; forward to REPORT-R if the length on tape is 
                                ; larger than that specified in command.
                                ; 'Tape loading error'

        JR      Z,L07E9         ; forward to VR-CONT-1 if lengths match.

;   a length on tape shorter than expected is not allowed for CODE

        LD      A,(IX+$00)      ; else fetch type from tape.
        CP      $03             ; is it CODE ?
        JR      NZ,L0806        ; forward to REPORT-R if so
                                ; 'Tape loading error'

;; VR-CONT-1
L07E9:  POP     HL              ; pop pointer to data
        LD      A,H             ; test for zero
        OR      L               ; e.g. LOAD 'x' CODE
        JR      NZ,L07F4        ; forward to VR-CONT-2 if destination specified.

        LD      L,(IX+$0D)      ; else use the destination in the header
        LD      H,(IX+$0E)      ; and load code at address saved from.

;; VR-CONT-2
L07F4:  PUSH    HL              ; push pointer to start of data block.
        POP     IX              ; transfer to IX.
        LD      A,($5C74)       ; fetch reduced command from T_ADDR
        CP      $02             ; is it VERIFY ?
        SCF                     ; prepare a set carry flag
        JR      NZ,L0800        ; skip to VR-CONT-3 if not

        AND     A               ; clear carry flag for VERIFY so that 
                                ; data is not loaded.

;; VR-CONT-3
L0800:  LD      A,$FF           ; signal data block to be loaded

; -----------------
; Load a data block
; -----------------
;   This routine is called from 3 places other than above to load a data block.
;   In all cases the accumulator is first set to $FF so the routine could be 
;   called at the previous instruction.

;; LD-BLOCK
L0802:  CALL    L0556           ; routine LD-BYTES
        RET     C               ; return if successful.


;; REPORT-R
L0806:  RST     08H             ; ERROR-1
        DEFB    $1A             ; Error Report: Tape loading error

; --------------------------
; THE 'LOAD CONTROL' ROUTINE
; --------------------------
;   This branch is taken when the command is LOAD with type 0, 1 or 2. 

;; LD-CONTRL
L0808:  LD      E,(IX+$0B)      ; fetch length of found data block 
        LD      D,(IX+$0C)      ; from 2nd descriptor.
        PUSH    HL              ; save destination
        LD      A,H             ; test for zero
        OR      L               ;
        JR      NZ,L0819        ; forward if not to LD-CONT-1

        INC     DE              ; increase length
        INC     DE              ; for letter name
        INC     DE              ; and 16-bit length
        EX      DE,HL           ; length to HL, 
        JR      L0825           ; forward to LD-CONT-2

; ---

;; LD-CONT-1
L0819:  LD      L,(IX-$06)      ; fetch length from 
        LD      H,(IX-$05)      ; the first header.
        EX      DE,HL           ;
        SCF                     ; set carry flag
        SBC     HL,DE           ;
        JR      C,L082E         ; to LD-DATA

;; LD-CONT-2
L0825:  LD      DE,$0005        ; allow overhead of five bytes.
        ADD     HL,DE           ; add in the difference in data lengths.
        LD      B,H             ; transfer to
        LD      C,L             ; the BC register pair
        CALL    L1F05           ; routine TEST-ROOM fails if not enough room.

;; LD-DATA
L082E:  POP     HL              ; pop destination
        LD      A,(IX+$00)      ; fetch type 0, 1 or 2.
        AND     A               ; test for program and variables.
        JR      Z,L0873         ; forward if so to LD-PROG

;   the type is a numeric or string array.

        LD      A,H             ; test the destination for zero
        OR      L               ; indicating variable does not already exist.
        JR      Z,L084C         ; forward if so to LD-DATA-1

;   else the destination is the first dimension within the array structure

        DEC     HL              ; address high byte of total length
        LD      B,(HL)          ; transfer to B.
        DEC     HL              ; address low byte of total length.
        LD      C,(HL)          ; transfer to C.
        DEC     HL              ; point to letter of variable.
        INC     BC              ; adjust length to
        INC     BC              ; include these
        INC     BC              ; three bytes also.
        LD      ($5C5F),IX      ; save header pointer in X_PTR.
        CALL    L19E8           ; routine RECLAIM-2 reclaims the old variable
                                ; sliding workspace including the two headers 
                                ; downwards.
        LD      IX,($5C5F)      ; reload IX from X_PTR which will have been
                                ; adjusted down by POINTERS routine.

;; LD-DATA-1
L084C:  LD      HL,($5C59)      ; address E_LINE
        DEC     HL              ; now point to the $80 variables end-marker.
        LD      C,(IX+$0B)      ; fetch new data length 
        LD      B,(IX+$0C)      ; from 2nd header.
        PUSH    BC              ; * save it.
        INC     BC              ; adjust the 
        INC     BC              ; length to include
        INC     BC              ; letter name and total length.
        LD      A,(IX-$03)      ; fetch letter name from old header.
        PUSH    AF              ; preserve accumulator though not corrupted.

        CALL    L1655           ; routine MAKE-ROOM creates space for variable
                                ; sliding workspace up. IX no longer addresses
                                ; anywhere meaningful.
        INC     HL              ; point to first new location.

        POP     AF              ; fetch back the letter name.
        LD      (HL),A          ; place in first new location.
        POP     DE              ; * pop the data length.
        INC     HL              ; address 2nd location
        LD      (HL),E          ; store low byte of length.
        INC     HL              ; address next.
        LD      (HL),D          ; store high byte.
        INC     HL              ; address start of data.
        PUSH    HL              ; transfer address
        POP     IX              ; to IX register pair.
        SCF                     ; set carry flag indicating load not verify.
        LD      A,$FF           ; signal data not header.
        JP      L0802           ; JUMP back to LD-BLOCK

; -----------------
;   the branch is here when a program as opposed to an array is to be loaded.

;; LD-PROG
L0873:  EX      DE,HL           ; transfer dest to DE.
        LD      HL,($5C59)      ; address E_LINE
        DEC     HL              ; now variables end-marker.
        LD      ($5C5F),IX      ; place the IX header pointer in X_PTR
        LD      C,(IX+$0B)      ; get new length
        LD      B,(IX+$0C)      ; from 2nd header
        PUSH    BC              ; and save it.

        CALL    L19E5           ; routine RECLAIM-1 reclaims program and vars.
                                ; adjusting X-PTR.

        POP     BC              ; restore new length.
        PUSH    HL              ; * save start
        PUSH    BC              ; ** and length.

        CALL    L1655           ; routine MAKE-ROOM creates the space.

        LD      IX,($5C5F)      ; reload IX from adjusted X_PTR
        INC     HL              ; point to start of new area.
        LD      C,(IX+$0F)      ; fetch length of BASIC on tape
        LD      B,(IX+$10)      ; from 2nd descriptor
        ADD     HL,BC           ; add to address the start of variables.
        LD      ($5C4B),HL      ; set system variable VARS

        LD      H,(IX+$0E)      ; fetch high byte of autostart line number.
        LD      A,H             ; transfer to A
        AND     $C0             ; test if greater than $3F.
        JR      NZ,L08AD        ; forward to LD-PROG-1 if so with no autostart.

        LD      L,(IX+$0D)      ; else fetch the low byte.
        LD      ($5C42),HL      ; set system variable to line number NEWPPC
        LD      (IY+$0A),$00    ; set statement NSPPC to zero.

;; LD-PROG-1
L08AD:  POP     DE              ; ** pop the length
        POP     IX              ; * and start.
        SCF                     ; set carry flag
        LD      A,$FF           ; signal data as opposed to a header.
        JP      L0802           ; jump back to LD-BLOCK

; ---------------------------
; THE 'MERGE CONTROL' ROUTINE
; ---------------------------
;   the branch was here to merge a program and its variables or an array.
;

;; ME-CONTRL
L08B6:  LD      C,(IX+$0B)      ; fetch length
        LD      B,(IX+$0C)      ; of data block on tape.
        PUSH    BC              ; save it.
        INC     BC              ; one for the pot.

        RST     30H             ; BC-SPACES creates room in workspace.
                                ; HL addresses last new location.
        LD      (HL),$80        ; place end-marker at end.
        EX      DE,HL           ; transfer first location to HL.
        POP     DE              ; restore length to DE.
        PUSH    HL              ; save start.

        PUSH    HL              ; and transfer it
        POP     IX              ; to IX register.
        SCF                     ; set carry flag to load data on tape.
        LD      A,$FF           ; signal data not a header.
        CALL    L0802           ; routine LD-BLOCK loads to workspace.
        POP     HL              ; restore first location in workspace to HL.
X08CE:  LD      DE,($5C53)      ; set DE from system variable PROG.

;   now enter a loop to merge the data block in workspace with the program and 
;   variables. 

;; ME-NEW-LP
L08D2:  LD      A,(HL)          ; fetch next byte from workspace.
        AND     $C0             ; compare with $3F.
        JR      NZ,L08F0        ; forward to ME-VAR-LP if a variable or 
                                ; end-marker.

;   continue when HL addresses a BASIC line number.

;; ME-OLD-LP
L08D7:  LD      A,(DE)          ; fetch high byte from program area.
        INC     DE              ; bump prog address.
        CP      (HL)            ; compare with that in workspace.
        INC     HL              ; bump workspace address.
        JR      NZ,L08DF        ; forward to ME-OLD-L1 if high bytes don't match

        LD      A,(DE)          ; fetch the low byte of program line number.
        CP      (HL)            ; compare with that in workspace.

;; ME-OLD-L1
L08DF:  DEC     DE              ; point to start of
        DEC     HL              ; respective lines again.
        JR      NC,L08EB        ; forward to ME-NEW-L2 if line number in 
                                ; workspace is less than or equal to current
                                ; program line as has to be added to program.

        PUSH    HL              ; else save workspace pointer. 
        EX      DE,HL           ; transfer prog pointer to HL
        CALL    L19B8           ; routine NEXT-ONE finds next line in DE.
        POP     HL              ; restore workspace pointer
        JR      L08D7           ; back to ME-OLD-LP until destination position 
                                ; in program area found.

; ---
;   the branch was here with an insertion or replacement point.

;; ME-NEW-L2
L08EB:  CALL    L092C           ; routine ME-ENTER enters the line
        JR      L08D2           ; loop back to ME-NEW-LP.

; ---
;   the branch was here when the location in workspace held a variable.

;; ME-VAR-LP
L08F0:  LD      A,(HL)          ; fetch first byte of workspace variable.
        LD      C,A             ; copy to C also.
        CP      $80             ; is it the end-marker ?
        RET     Z               ; return if so as complete.  >>>>>

        PUSH    HL              ; save workspace area pointer.
        LD      HL,($5C4B)      ; load HL with VARS - start of variables area.

;; ME-OLD-VP
L08F9:  LD      A,(HL)          ; fetch first byte.
        CP      $80             ; is it the end-marker ?
        JR      Z,L0923         ; forward if so to ME-VAR-L2 to add
                                ; variable at end of variables area.

        CP      C               ; compare with variable in workspace area.
        JR      Z,L0909         ; forward to ME-OLD-V2 if a match to replace.

;   else entire variables area has to be searched.

;; ME-OLD-V1
L0901:  PUSH    BC              ; save character in C.
        CALL    L19B8           ; routine NEXT-ONE gets following variable 
                                ; address in DE.
        POP     BC              ; restore character in C
        EX      DE,HL           ; transfer next address to HL.
        JR      L08F9           ; loop back to ME-OLD-VP

; --- 
;   the branch was here when first characters of name matched. 

;; ME-OLD-V2
L0909:  AND     $E0             ; keep bits 11100000
        CP      $A0             ; compare   10100000 - a long-named variable.

        JR      NZ,L0921        ; forward to ME-VAR-L1 if just one-character.

;   but long-named variables have to be matched character by character.

        POP     DE              ; fetch workspace 1st character pointer
        PUSH    DE              ; and save it on the stack again.
        PUSH    HL              ; save variables area pointer on stack.

;; ME-OLD-V3
L0912:  INC     HL              ; address next character in vars area.
        INC     DE              ; address next character in workspace area.
        LD      A,(DE)          ; fetch workspace character.
        CP      (HL)            ; compare to variables character.
        JR      NZ,L091E        ; forward to ME-OLD-V4 with a mismatch.

        RLA                     ; test if the terminal inverted character.
        JR      NC,L0912        ; loop back to ME-OLD-V3 if more to test.

;   otherwise the long name matches in its entirety.

        POP     HL              ; restore pointer to first character of variable
        JR      L0921           ; forward to ME-VAR-L1

; ---
;   the branch is here when two characters don't match

;; ME-OLD-V4
L091E:  POP     HL              ; restore the prog/vars pointer.
        JR      L0901           ; back to ME-OLD-V1 to resume search.

; ---
;   branch here when variable is to replace an existing one

;; ME-VAR-L1
L0921:  LD      A,$FF           ; indicate a replacement.

;   this entry point is when A holds $80 indicating a new variable.

;; ME-VAR-L2
L0923:  POP     DE              ; pop workspace pointer.
        EX      DE,HL           ; now make HL workspace pointer, DE vars pointer
        INC     A               ; zero flag set if replacement.
        SCF                     ; set carry flag indicating a variable not a
                                ; program line.
        CALL    L092C           ; routine ME-ENTER copies variable in.
        JR      L08F0           ; loop back to ME-VAR-LP

; ------------------------
; Merge a Line or Variable
; ------------------------
;   A BASIC line or variable is inserted at the current point. If the line 
;   number or variable names match (zero flag set) then a replacement takes 
;   place.

;; ME-ENTER
L092C:  JR      NZ,L093E        ; forward to ME-ENT-1 for insertion only.

;   but the program line or variable matches so old one is reclaimed.

        EX      AF,AF'          ; save flag??
        LD      ($5C5F),HL      ; preserve workspace pointer in dynamic X_PTR
        EX      DE,HL           ; transfer program dest pointer to HL.
        CALL    L19B8           ; routine NEXT-ONE finds following location
                                ; in program or variables area.
        CALL    L19E8           ; routine RECLAIM-2 reclaims the space between.
        EX      DE,HL           ; transfer program dest pointer back to DE.
        LD      HL,($5C5F)      ; fetch adjusted workspace pointer from X_PTR
        EX      AF,AF'          ; restore flags.

;   now the new line or variable is entered.

;; ME-ENT-1
L093E:  EX      AF,AF'          ; save or re-save flags.
        PUSH    DE              ; save dest pointer in prog/vars area.
        CALL    L19B8           ; routine NEXT-ONE finds next in workspace.
                                ; gets next in DE, difference in BC.
                                ; prev addr in HL
        LD      ($5C5F),HL      ; store pointer in X_PTR
        LD      HL,($5C53)      ; load HL from system variable PROG
        EX      (SP),HL         ; swap with prog/vars pointer on stack. 
        PUSH    BC              ; ** save length of new program line/variable.
        EX      AF,AF'          ; fetch flags back.
        JR      C,L0955         ; skip to ME-ENT-2 if variable

        DEC     HL              ; address location before pointer
        CALL    L1655           ; routine MAKE-ROOM creates room for BASIC line
        INC     HL              ; address next.
        JR      L0958           ; forward to ME-ENT-3

; ---

;; ME-ENT-2
L0955:  CALL    L1655           ; routine MAKE-ROOM creates room for variable.

;; ME-ENT-3
L0958:  INC     HL              ; address next?

        POP     BC              ; ** pop length
        POP     DE              ; * pop value for PROG which may have been 
                                ; altered by POINTERS if first line.
        LD      ($5C53),DE      ; set PROG to original value.
        LD      DE,($5C5F)      ; fetch adjusted workspace pointer from X_PTR
        PUSH    BC              ; save length
        PUSH    DE              ; and workspace pointer
        EX      DE,HL           ; make workspace pointer source, prog/vars
                                ; pointer the destination
        LDIR                    ; copy bytes of line or variable into new area.
        POP     HL              ; restore workspace pointer.
        POP     BC              ; restore length.
        PUSH    DE              ; save new prog/vars pointer.
        CALL    L19E8           ; routine RECLAIM-2 reclaims the space used
                                ; by the line or variable in workspace block
                                ; as no longer required and space could be 
                                ; useful for adding more lines.
        POP     DE              ; restore the prog/vars pointer
        RET                     ; return.

; --------------------------
; THE 'SAVE CONTROL' ROUTINE
; --------------------------
;   A branch from the main SAVE-ETC routine at SAVE-ALL.
;   First the header data is saved. Then after a wait of 1 second
;   the data itself is saved.
;   HL points to start of data.
;   IX points to start of descriptor.

;; SA-CONTRL
L0970:  PUSH    HL              ; save start of data

        LD      A,$FD           ; select system channel 'S'
        CALL    L1601           ; routine CHAN-OPEN

        XOR     A               ; clear to address table directly
        LD      DE,L09A1        ; address: tape-msgs
        CALL    L0C0A           ; routine PO-MSG -
                                ; 'Start tape then press any key.'

        SET     5,(IY+$02)      ; TV_FLAG  - Signal lower screen requires
                                ; clearing
        CALL    L15D4           ; routine WAIT-KEY

        PUSH    IX              ; save pointer to descriptor.
        LD      DE,$0011        ; there are seventeen bytes.
        XOR     A               ; signal a header.
        CALL    L04C2           ; routine SA-BYTES

        POP     IX              ; restore descriptor pointer.

        LD      B,$32           ; wait for a second - 50 interrupts.

;; SA-1-SEC
L0991:  HALT                    ; wait for interrupt
        DJNZ    L0991           ; back to SA-1-SEC until pause complete.

        LD      E,(IX+$0B)      ; fetch length of bytes from the
        LD      D,(IX+$0C)      ; descriptor.

        LD      A,$FF           ; signal data bytes.

        POP     IX              ; retrieve pointer to start
        JP      L04C2           ; jump back to SA-BYTES


;   Arrangement of two headers in workspace.
;   Originally IX addresses first location and only one header is required
;   when saving.
;
;   OLD     NEW         PROG   DATA  DATA  CODE 
;   HEADER  HEADER             num   chr          NOTES.
;   ------  ------      ----   ----  ----  ----   -----------------------------
;   IX-$11  IX+$00      0      1     2     3      Type.
;   IX-$10  IX+$01      x      x     x     x      F  ($FF if filename is null).
;   IX-$0F  IX+$02      x      x     x     x      i
;   IX-$0E  IX+$03      x      x     x     x      l
;   IX-$0D  IX+$04      x      x     x     x      e
;   IX-$0C  IX+$05      x      x     x     x      n
;   IX-$0B  IX+$06      x      x     x     x      a
;   IX-$0A  IX+$07      x      x     x     x      m
;   IX-$09  IX+$08      x      x     x     x      e
;   IX-$08  IX+$09      x      x     x     x      .
;   IX-$07  IX+$0A      x      x     x     x      (terminal spaces).
;   IX-$06  IX+$0B      lo     lo    lo    lo     Total  
;   IX-$05  IX+$0C      hi     hi    hi    hi     Length of datablock.
;   IX-$04  IX+$0D      Auto   -     -     Start  Various
;   IX-$03  IX+$0E      Start  a-z   a-z   addr   ($80 if no autostart).
;   IX-$02  IX+$0F      lo     -     -     -      Length of Program 
;   IX-$01  IX+$10      hi     -     -     -      only i.e. without variables.
;


; ------------------------
; Canned cassette messages
; ------------------------
;   The last-character-inverted Cassette messages.
;   Starts with normal initial step-over byte.

;; tape-msgs
L09A1:  DEFB    $80
        DEFM    "Start tape, then press any key"
L09C0:  DEFB    '.'+$80
        DEFB    $0D
        DEFM    "Program:"
        DEFB    ' '+$80
        DEFB    $0D
        DEFM    "Number array:"
        DEFB    ' '+$80
        DEFB    $0D
        DEFM    "Character array:"
        DEFB    ' '+$80
        DEFB    $0D
        DEFM    "Bytes:"
        DEFB    ' '+$80
