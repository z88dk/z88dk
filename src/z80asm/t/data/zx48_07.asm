;***************************************************
;** Part 7. BASIC LINE AND COMMAND INTERPRETATION **
;***************************************************

        PUBLIC L1ADF
        PUBLIC L1B17
        PUBLIC L1B8A
        PUBLIC L1BEE
        PUBLIC L1C2E
        PUBLIC L1C79
        PUBLIC L1C82
        PUBLIC L1C8A
        PUBLIC L1C8C
        PUBLIC L1CDE
        PUBLIC L1CE6
        PUBLIC L1D86
        PUBLIC L1E94
        PUBLIC L1E99
        PUBLIC L1E9F
        PUBLIC L1F05
        PUBLIC L1F15
        PUBLIC L1F54
        PUBLIC L2048
        PUBLIC L2070
        PUBLIC L2211
        PUBLIC L22CB
        PUBLIC L2307

        EXTERN L0055
        EXTERN L0077
        EXTERN L0078
        EXTERN L03F8
        EXTERN L0605
        EXTERN L0BDB
        EXTERN L0D4D
        EXTERN L0D6B
        EXTERN L0D6E
        EXTERN L0DD9
        EXTERN L0EAC
        EXTERN L0F2C
        EXTERN L111D
        EXTERN L11A7
        EXTERN L11B7
        EXTERN L1601
        EXTERN L160E
        EXTERN L1655
        EXTERN L16BF
        EXTERN L16E5
        EXTERN L1736
        EXTERN L1793
        EXTERN L17F5
        EXTERN L17F9
        EXTERN L196E
        EXTERN L198B
        EXTERN L19E5
        EXTERN L19FB
        EXTERN L24FB
        EXTERN L2530
        EXTERN L28B2
        EXTERN L2996
        EXTERN L2AB2
        EXTERN L2AFF
        EXTERN L2BF1
        EXTERN L2C02
        EXTERN L2C8D
        EXTERN L2D28
        EXTERN L2DA2
        EXTERN L2DD5
        EXTERN L2DE3
        EXTERN L34E9

; ----------------
; The offset table
; ----------------
; The BASIC interpreter has found a command code $CE - $FF
; which is then reduced to range $00 - $31 and added to the base address
; of this table to give the address of an offset which, when added to
; the offset therein, gives the location in the following parameter table
; where a list of class codes, separators and addresses relevant to the
; command exists.

;; offst-tbl
L1A48:  DEFB    L1AF9 - ASMPC       ; B1 offset to Address: P-DEF-FN
        DEFB    L1B14 - ASMPC       ; CB offset to Address: P-CAT
        DEFB    L1B06 - ASMPC       ; BC offset to Address: P-FORMAT
        DEFB    L1B0A - ASMPC       ; BF offset to Address: P-MOVE
        DEFB    L1B10 - ASMPC       ; C4 offset to Address: P-ERASE
        DEFB    L1AFC - ASMPC       ; AF offset to Address: P-OPEN
        DEFB    L1B02 - ASMPC       ; B4 offset to Address: P-CLOSE
        DEFB    L1AE2 - ASMPC       ; 93 offset to Address: P-MERGE
        DEFB    L1AE1 - ASMPC       ; 91 offset to Address: P-VERIFY
        DEFB    L1AE3 - ASMPC       ; 92 offset to Address: P-BEEP
        DEFB    L1AE7 - ASMPC       ; 95 offset to Address: P-CIRCLE
        DEFB    L1AEB - ASMPC       ; 98 offset to Address: P-INK
        DEFB    L1AEC - ASMPC       ; 98 offset to Address: P-PAPER
        DEFB    L1AED - ASMPC       ; 98 offset to Address: P-FLASH
        DEFB    L1AEE - ASMPC       ; 98 offset to Address: P-BRIGHT
        DEFB    L1AEF - ASMPC       ; 98 offset to Address: P-INVERSE
        DEFB    L1AF0 - ASMPC       ; 98 offset to Address: P-OVER
        DEFB    L1AF1 - ASMPC       ; 98 offset to Address: P-OUT
        DEFB    L1AD9 - ASMPC       ; 7F offset to Address: P-LPRINT
        DEFB    L1ADC - ASMPC       ; 81 offset to Address: P-LLIST
        DEFB    L1A8A - ASMPC       ; 2E offset to Address: P-STOP
        DEFB    L1AC9 - ASMPC       ; 6C offset to Address: P-READ
        DEFB    L1ACC - ASMPC       ; 6E offset to Address: P-DATA
        DEFB    L1ACF - ASMPC       ; 70 offset to Address: P-RESTORE
        DEFB    L1AA8 - ASMPC       ; 48 offset to Address: P-NEW
        DEFB    L1AF5 - ASMPC       ; 94 offset to Address: P-BORDER
        DEFB    L1AB8 - ASMPC       ; 56 offset to Address: P-CONT
        DEFB    L1AA2 - ASMPC       ; 3F offset to Address: P-DIM
        DEFB    L1AA5 - ASMPC       ; 41 offset to Address: P-REM
        DEFB    L1A90 - ASMPC       ; 2B offset to Address: P-FOR
        DEFB    L1A7D - ASMPC       ; 17 offset to Address: P-GO-TO
        DEFB    L1A86 - ASMPC       ; 1F offset to Address: P-GO-SUB
        DEFB    L1A9F - ASMPC       ; 37 offset to Address: P-INPUT
        DEFB    L1AE0 - ASMPC       ; 77 offset to Address: P-LOAD
        DEFB    L1AAE - ASMPC       ; 44 offset to Address: P-LIST
        DEFB    L1A7A - ASMPC       ; 0F offset to Address: P-LET
        DEFB    L1AC5 - ASMPC       ; 59 offset to Address: P-PAUSE
        DEFB    L1A98 - ASMPC       ; 2B offset to Address: P-NEXT
        DEFB    L1AB1 - ASMPC       ; 43 offset to Address: P-POKE
        DEFB    L1A9C - ASMPC       ; 2D offset to Address: P-PRINT
        DEFB    L1AC1 - ASMPC       ; 51 offset to Address: P-PLOT
        DEFB    L1AAB - ASMPC       ; 3A offset to Address: P-RUN
        DEFB    L1ADF - ASMPC       ; 6D offset to Address: P-SAVE
        DEFB    L1AB5 - ASMPC       ; 42 offset to Address: P-RANDOM
        DEFB    L1A81 - ASMPC       ; 0D offset to Address: P-IF
        DEFB    L1ABE - ASMPC       ; 49 offset to Address: P-CLS
        DEFB    L1AD2 - ASMPC       ; 5C offset to Address: P-DRAW
        DEFB    L1ABB - ASMPC       ; 44 offset to Address: P-CLEAR
        DEFB    L1A8D - ASMPC       ; 15 offset to Address: P-RETURN
        DEFB    L1AD6 - ASMPC       ; 5D offset to Address: P-COPY


; -------------------------------
; The parameter or "Syntax" table
; -------------------------------
; For each command there exists a variable list of parameters.
; If the character is greater than a space it is a required separator.
; If less, then it is a command class in the range 00 - 0B.
; Note that classes 00, 03 and 05 will fetch the addresses from this table.
; Some classes e.g. 07 and 0B have the same address in all invocations
; and the command is re-computed from the low-byte of the parameter address.
; Some e.g. 02 are only called once so a call to the command is made from
; within the class routine rather than holding the address within the table.
; Some class routines check syntax entirely and some leave this task for the
; command itself.
; Others for example CIRCLE (x,y,z) check the first part (x,y) using the
; class routine and the final part (,z) within the command.
; The last few commands appear to have been added in a rush but their syntax
; is rather simple e.g. MOVE "M1","M2"

;; P-LET
L1A7A:  DEFB    $01             ; Class-01 - A variable is required.
        DEFB    $3D             ; Separator:  '='
        DEFB    $02             ; Class-02 - An expression, numeric or string,
                                ; must follow.

;; P-GO-TO
L1A7D:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1E67           ; Address: $1E67; Address: GO-TO

;; P-IF
L1A81:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $CB             ; Separator:  'THEN'
        DEFB    $05             ; Class-05 - Variable syntax checked
                                ; by routine.
        DEFW    L1CF0           ; Address: $1CF0; Address: IF

;; P-GO-SUB
L1A86:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1EED           ; Address: $1EED; Address: GO-SUB

;; P-STOP
L1A8A:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1CEE           ; Address: $1CEE; Address: STOP

;; P-RETURN
L1A8D:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1F23           ; Address: $1F23; Address: RETURN

;; P-FOR
L1A90:  DEFB    $04             ; Class-04 - A single character variable must
                                ; follow.
        DEFB    $3D             ; Separator:  '='
        DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $CC             ; Separator:  'TO'
        DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $05             ; Class-05 - Variable syntax checked
                                ; by routine.
        DEFW    L1D03           ; Address: $1D03; Address: FOR

;; P-NEXT
L1A98:  DEFB    $04             ; Class-04 - A single character variable must
                                ; follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1DAB           ; Address: $1DAB; Address: NEXT

;; P-PRINT
L1A9C:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1FCD           ; Address: $1FCD; Address: PRINT

;; P-INPUT
L1A9F:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L2089           ; Address: $2089; Address: INPUT

;; P-DIM
L1AA2:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L2C02           ; Address: $2C02; Address: DIM

;; P-REM
L1AA5:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1BB2           ; Address: $1BB2; Address: REM

;; P-NEW
L1AA8:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L11B7           ; Address: $11B7; Address: NEW

;; P-RUN
L1AAB:  DEFB    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        DEFW    L1EA1           ; Address: $1EA1; Address: RUN

;; P-LIST
L1AAE:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L17F9           ; Address: $17F9; Address: LIST

;; P-POKE
L1AB1:  DEFB    $08             ; Class-08 - Two comma-separated numeric
                                ; expressions required.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1E80           ; Address: $1E80; Address: POKE

;; P-RANDOM
L1AB5:  DEFB    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        DEFW    L1E4F           ; Address: $1E4F; Address: RANDOMIZE

;; P-CONT
L1AB8:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1E5F           ; Address: $1E5F; Address: CONTINUE

;; P-CLEAR
L1ABB:  DEFB    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        DEFW    L1EAC           ; Address: $1EAC; Address: CLEAR

;; P-CLS
L1ABE:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L0D6B           ; Address: $0D6B; Address: CLS

;; P-PLOT
L1AC1:  DEFB    $09             ; Class-09 - Two comma-separated numeric
                                ; expressions required with optional colour
                                ; items.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L22DC           ; Address: $22DC; Address: PLOT

;; P-PAUSE
L1AC5:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1F3A           ; Address: $1F3A; Address: PAUSE

;; P-READ
L1AC9:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1DED           ; Address: $1DED; Address: READ

;; P-DATA
L1ACC:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1E27           ; Address: $1E27; Address: DATA

;; P-RESTORE
L1ACF:  DEFB    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        DEFW    L1E42           ; Address: $1E42; Address: RESTORE

;; P-DRAW
L1AD2:  DEFB    $09             ; Class-09 - Two comma-separated numeric
                                ; expressions required with optional colour
                                ; items.
        DEFB    $05             ; Class-05 - Variable syntax checked
                                ; by routine.
        DEFW    L2382           ; Address: $2382; Address: DRAW

;; P-COPY
L1AD6:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L0EAC           ; Address: $0EAC; Address: COPY

;; P-LPRINT
L1AD9:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1FC9           ; Address: $1FC9; Address: LPRINT

;; P-LLIST
L1ADC:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L17F5           ; Address: $17F5; Address: LLIST

;; P-SAVE
L1ADF:  DEFB    $0B             ; Class-0B - Offset address converted to tape
                                ; command.

;; P-LOAD
L1AE0:  DEFB    $0B             ; Class-0B - Offset address converted to tape
                                ; command.

;; P-VERIFY
L1AE1:  DEFB    $0B             ; Class-0B - Offset address converted to tape
                                ; command.

;; P-MERGE
L1AE2:  DEFB    $0B             ; Class-0B - Offset address converted to tape
                                ; command.

;; P-BEEP
L1AE3:  DEFB    $08             ; Class-08 - Two comma-separated numeric
                                ; expressions required.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L03F8           ; Address: $03F8; Address: BEEP

;; P-CIRCLE
L1AE7:  DEFB    $09             ; Class-09 - Two comma-separated numeric
                                ; expressions required with optional colour
                                ; items.
        DEFB    $05             ; Class-05 - Variable syntax checked
                                ; by routine.
        DEFW    L2320           ; Address: $2320; Address: CIRCLE

;; P-INK
L1AEB:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-PAPER
L1AEC:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-FLASH
L1AED:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-BRIGHT
L1AEE:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-INVERSE
L1AEF:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-OVER
L1AF0:  DEFB    $07             ; Class-07 - Offset address is converted to
                                ; colour code.

;; P-OUT
L1AF1:  DEFB    $08             ; Class-08 - Two comma-separated numeric
                                ; expressions required.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1E7A           ; Address: $1E7A; Address: OUT

;; P-BORDER
L1AF5:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L2294           ; Address: $2294; Address: BORDER

;; P-DEF-FN
L1AF9:  DEFB    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        DEFW    L1F60           ; Address: $1F60; Address: DEF-FN

;; P-OPEN
L1AFC:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $2C             ; Separator:  ','          see Footnote *
        DEFB    $0A             ; Class-0A - A string expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1736           ; Address: $1736; Address: OPEN

;; P-CLOSE
L1B02:  DEFB    $06             ; Class-06 - A numeric expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L16E5           ; Address: $16E5; Address: CLOSE

;; P-FORMAT
L1B06:  DEFB    $0A             ; Class-0A - A string expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1793           ; Address: $1793; Address: CAT-ETC

;; P-MOVE
L1B0A:  DEFB    $0A             ; Class-0A - A string expression must follow.
        DEFB    $2C             ; Separator:  ','
        DEFB    $0A             ; Class-0A - A string expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1793           ; Address: $1793; Address: CAT-ETC

;; P-ERASE
L1B10:  DEFB    $0A             ; Class-0A - A string expression must follow.
        DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1793           ; Address: $1793; Address: CAT-ETC

;; P-CAT
L1B14:  DEFB    $00             ; Class-00 - No further operands.
        DEFW    L1793           ; Address: $1793; Address: CAT-ETC

; * Note that a comma is required as a separator with the OPEN command
; but the Interface 1 programmers relaxed this allowing ';' as an
; alternative for their channels creating a confusing mixture of
; allowable syntax as it is this ROM which opens or re-opens the
; normal channels.

; -------------------------------
; Main parser (BASIC interpreter)
; -------------------------------
; This routine is called once from MAIN-2 when the BASIC line is to
; be entered or re-entered into the Program area and the syntax
; requires checking.

;; LINE-SCAN
L1B17:  RES     7,(IY+$01)      ; update FLAGS - signal checking syntax
        CALL    L19FB           ; routine E-LINE-NO              >>
                                ; fetches the line number if in range.

        XOR     A               ; clear the accumulator.
        LD      ($5C47),A       ; set statement number SUBPPC to zero.
        DEC     A               ; set accumulator to $FF.
        LD      ($5C3A),A       ; set ERR_NR to 'OK' - 1.
        JR      L1B29           ; forward to continue at STMT-L-1.

; --------------
; Statement loop
; --------------
;
;

;; STMT-LOOP
L1B28:  RST     20H             ; NEXT-CHAR

; -> the entry point from above or LINE-RUN
;; STMT-L-1
L1B29:  CALL    L16BF           ; routine SET-WORK clears workspace etc.

        INC     (IY+$0D)        ; increment statement number SUBPPC
        JP      M,L1C8A         ; to REPORT-C to raise
                                ; 'Nonsense in BASIC' if over 127.

        RST     18H             ; GET-CHAR

        LD      B,$00           ; set B to zero for later indexing.
                                ; early so any other reason ???

        CP      $0D             ; is character carriage return ?
                                ; i.e. an empty statement.
        JR      Z,L1BB3         ; forward to LINE-END if so.

        CP      $3A             ; is it statement end marker ':' ?
                                ; i.e. another type of empty statement.
        JR      Z,L1B28         ; back to STMT-LOOP if so.

        LD      HL,L1B76        ; address: STMT-RET
        PUSH    HL              ; is now pushed as a return address
        LD      C,A             ; transfer the current character to C.

; advance CH_ADD to a position after command and test if it is a command.

        RST     20H             ; NEXT-CHAR to advance pointer
        LD      A,C             ; restore current character
        SUB     $CE             ; subtract 'DEF FN' - first command
        JP      C,L1C8A         ; jump to REPORT-C if less than a command
                                ; raising 
                                ; 'Nonsense in BASIC'

        LD      C,A             ; put the valid command code back in C.
                                ; register B is zero.
        LD      HL,L1A48        ; address: offst-tbl
        ADD     HL,BC           ; index into table with one of 50 commands.
        LD      C,(HL)          ; pick up displacement to syntax table entry.
        ADD     HL,BC           ; add to address the relevant entry.
        JR      L1B55           ; forward to continue at GET-PARAM

; ----------------------
; The main scanning loop
; ----------------------
; not documented properly
;

;; SCAN-LOOP
L1B52:  LD      HL,($5C74)      ; fetch temporary address from T_ADDR
                                ; during subsequent loops.

; -> the initial entry point with HL addressing start of syntax table entry.

;; GET-PARAM
L1B55:  LD      A,(HL)          ; pick up the parameter.
        INC     HL              ; address next one.
        LD      ($5C74),HL      ; save pointer in system variable T_ADDR

        LD      BC,L1B52        ; address: SCAN-LOOP
        PUSH    BC              ; is now pushed on stack as looping address.
        LD      C,A             ; store parameter in C.
        CP      $20             ; is it greater than ' '  ?
        JR      NC,L1B6F        ; forward to SEPARATOR to check that correct
                                ; separator appears in statement if so.

        LD      HL,L1C01        ; address: class-tbl.
        LD      B,$00           ; prepare to index into the class table.
        ADD     HL,BC           ; index to find displacement to routine.
        LD      C,(HL)          ; displacement to BC
        ADD     HL,BC           ; add to address the CLASS routine.
        PUSH    HL              ; push the address on the stack.

        RST     18H             ; GET-CHAR - HL points to place in statement.

        DEC     B               ; reset the zero flag - the initial state
                                ; for all class routines.

        RET                     ; and make an indirect jump to routine
                                ; and then SCAN-LOOP (also on stack).

; Note. one of the class routines will eventually drop the return address
; off the stack breaking out of the above seemingly endless loop.

; -----------------------
; THE 'SEPARATOR' ROUTINE
; -----------------------
;   This routine is called once to verify that the mandatory separator
;   present in the parameter table is also present in the correct
;   location following the command.  For example, the 'THEN' token after
;   the 'IF' token and expression.

;; SEPARATOR
L1B6F:  RST     18H             ; GET-CHAR
        CP      C               ; does it match the character in C ?
        JP      NZ,L1C8A        ; jump forward to REPORT-C if not
                                ; 'Nonsense in BASIC'.

        RST     20H             ; NEXT-CHAR advance to next character
        RET                     ; return.

; ------------------------------
; Come here after interpretation
; ------------------------------
;
;

;; STMT-RET
L1B76:  CALL    L1F54           ; routine BREAK-KEY is tested after every
                                ; statement.
        JR      C,L1B7D         ; step forward to STMT-R-1 if not pressed.

;; REPORT-L
L1B7B:  RST     08H             ; ERROR-1
        DEFB    $14             ; Error Report: BREAK into program

;; STMT-R-1
L1B7D:  BIT     7,(IY+$0A)      ; test NSPPC - will be set if $FF -
                                ; no jump to be made.
        JR      NZ,L1BF4        ; forward to STMT-NEXT if a program line.

        LD      HL,($5C42)      ; fetch line number from NEWPPC
        BIT     7,H             ; will be set if minus two - direct command(s)
        JR      Z,L1B9E         ; forward to LINE-NEW if a jump is to be
                                ; made to a new program line/statement.

; --------------------
; Run a direct command
; --------------------
; A direct command is to be run or, if continuing from above,
; the next statement of a direct command is to be considered.

;; LINE-RUN
L1B8A:  LD      HL,$FFFE        ; The dummy value minus two
        LD      ($5C45),HL      ; is set/reset as line number in PPC.
        LD      HL,($5C61)      ; point to end of line + 1 - WORKSP.
        DEC     HL              ; now point to $80 end-marker.
        LD      DE,($5C59)      ; address the start of line E_LINE.
        DEC     DE              ; now location before - for GET-CHAR.
        LD      A,($5C44)       ; load statement to A from NSPPC.
        JR      L1BD1           ; forward to NEXT-LINE.

; ------------------------------
; Find start address of new line
; ------------------------------
; The branch was to here if a jump is to made to a new line number
; and statement.
; That is the previous statement was a GO TO, GO SUB, RUN, RETURN, NEXT etc..

;; LINE-NEW
L1B9E:  CALL    L196E           ; routine LINE-ADDR gets address of line
                                ; returning zero flag set if line found.
        LD      A,($5C44)       ; fetch new statement from NSPPC
        JR      Z,L1BBF         ; forward to LINE-USE if line matched.

; continue as must be a direct command.

        AND     A               ; test statement which should be zero
        JR      NZ,L1BEC        ; forward to REPORT-N if not.
                                ; 'Statement lost'

; 

        LD      B,A             ; save statement in B.??
        LD      A,(HL)          ; fetch high byte of line number.
        AND     $C0             ; test if using direct command
                                ; a program line is less than $3F
        LD      A,B             ; retrieve statement.
                                ; (we can assume it is zero).
        JR      Z,L1BBF         ; forward to LINE-USE if was a program line

; Alternatively a direct statement has finished correctly.

;; REPORT-0
L1BB0:  RST     08H             ; ERROR-1
        DEFB    $FF             ; Error Report: OK

; -----------------
; THE 'REM' COMMAND
; -----------------
; The REM command routine.
; The return address STMT-RET is dropped and the rest of line ignored.

;; REM
L1BB2:  POP     BC              ; drop return address STMT-RET and
                                ; continue ignoring rest of line.

; ------------
; End of line?
; ------------
;
;

;; LINE-END
L1BB3:  CALL    L2530           ; routine SYNTAX-Z  (UNSTACK-Z?)
        RET     Z               ; return if checking syntax.

        LD      HL,($5C55)      ; fetch NXTLIN to HL.
        LD      A,$C0           ; test against the
        AND     (HL)            ; system limit $3F.
        RET     NZ              ; return if more as must be
                                ; end of program.
                                ; (or direct command)

        XOR     A               ; set statement to zero.

; and continue to set up the next following line and then consider this new one.

; ---------------------
; General line checking
; ---------------------
; The branch was here from LINE-NEW if BASIC is branching.
; or a continuation from above if dealing with a new sequential line.
; First make statement zero number one leaving others unaffected.

;; LINE-USE
L1BBF:  CP      $01             ; will set carry if zero.
        ADC     A,$00           ; add in any carry.

        LD      D,(HL)          ; high byte of line number to D.
        INC     HL              ; advance pointer.
        LD      E,(HL)          ; low byte of line number to E.
        LD      ($5C45),DE      ; set system variable PPC.

        INC     HL              ; advance pointer.
        LD      E,(HL)          ; low byte of line length to E.
        INC     HL              ; advance pointer.
        LD      D,(HL)          ; high byte of line length to D.

        EX      DE,HL           ; swap pointer to DE before
        ADD     HL,DE           ; adding to address the end of line.
        INC     HL              ; advance to start of next line.

; -----------------------------
; Update NEXT LINE but consider
; previous line or edit line.
; -----------------------------
; The pointer will be the next line if continuing from above or to
; edit line end-marker ($80) if from LINE-RUN.

;; NEXT-LINE
L1BD1:  LD      ($5C55),HL      ; store pointer in system variable NXTLIN

        EX      DE,HL           ; bring back pointer to previous or edit line
        LD      ($5C5D),HL      ; and update CH_ADD with character address.

        LD      D,A             ; store statement in D.
        LD      E,$00           ; set E to zero to suppress token searching
                                ; if EACH-STMT is to be called.
        LD      (IY+$0A),$FF    ; set statement NSPPC to $FF signalling
                                ; no jump to be made.
        DEC     D               ; decrement and test statement
        LD      (IY+$0D),D      ; set SUBPPC to decremented statement number.
        JP      Z,L1B28         ; to STMT-LOOP if result zero as statement is
                                ; at start of line and address is known.

        INC     D               ; else restore statement.
        CALL    L198B           ; routine EACH-STMT finds the D'th statement
                                ; address as E does not contain a token.
        JR      Z,L1BF4         ; forward to STMT-NEXT if address found.

;; REPORT-N
L1BEC:  RST     08H             ; ERROR-1
        DEFB    $16             ; Error Report: Statement lost

; -----------------
; End of statement?
; -----------------
; This combination of routines is called from 20 places when
; the end of a statement should have been reached and all preceding
; syntax is in order.

;; CHECK-END
L1BEE:  CALL    L2530           ; routine SYNTAX-Z
        RET     NZ              ; return immediately in runtime

        POP     BC              ; drop address of calling routine.
        POP     BC              ; drop address STMT-RET.
                                ; and continue to find next statement.

; --------------------
; Go to next statement
; --------------------
; Acceptable characters at this point are carriage return and ':'.
; If so go to next statement which in the first case will be on next line.

;; STMT-NEXT
L1BF4:  RST     18H             ; GET-CHAR - ignoring white space etc.

        CP      $0D             ; is it carriage return ?
        JR      Z,L1BB3         ; back to LINE-END if so.

        CP      $3A             ; is it ':' ?
        JP      Z,L1B28         ; jump back to STMT-LOOP to consider
                                ; further statements

        JP      L1C8A           ; jump to REPORT-C with any other character
                                ; 'Nonsense in BASIC'.

; Note. the two-byte sequence 'rst 08; defb $0b' could replace the above jp.

; -------------------
; Command class table
; -------------------
;

;; class-tbl
L1C01:  DEFB    L1C10 - ASMPC       ; 0F offset to Address: CLASS-00
        DEFB    L1C1F - ASMPC       ; 1D offset to Address: CLASS-01
        DEFB    L1C4E - ASMPC       ; 4B offset to Address: CLASS-02
        DEFB    L1C0D - ASMPC       ; 09 offset to Address: CLASS-03
        DEFB    L1C6C - ASMPC       ; 67 offset to Address: CLASS-04
        DEFB    L1C11 - ASMPC       ; 0B offset to Address: CLASS-05
        DEFB    L1C82 - ASMPC       ; 7B offset to Address: CLASS-06
        DEFB    L1C96 - ASMPC       ; 8E offset to Address: CLASS-07
        DEFB    L1C7A - ASMPC       ; 71 offset to Address: CLASS-08
        DEFB    L1CBE - ASMPC       ; B4 offset to Address: CLASS-09
        DEFB    L1C8C - ASMPC       ; 81 offset to Address: CLASS-0A
        DEFB    L1CDB - ASMPC       ; CF offset to Address: CLASS-0B


; --------------------------------
; Command classes---00, 03, and 05
; --------------------------------
; class-03 e.g. RUN or RUN 200   ;  optional operand
; class-00 e.g. CONTINUE         ;  no operand
; class-05 e.g. PRINT            ;  variable syntax checked by routine

;; CLASS-03
L1C0D:  CALL    L1CDE           ; routine FETCH-NUM

;; CLASS-00

L1C10:  CP      A               ; reset zero flag.

; if entering here then all class routines are entered with zero reset.

;; CLASS-05
L1C11:  POP     BC              ; drop address SCAN-LOOP.
        CALL    Z,L1BEE         ; if zero set then call routine CHECK-END >>>
                                ; as should be no further characters.

        EX      DE,HL           ; save HL to DE.
        LD      HL,($5C74)      ; fetch T_ADDR
        LD      C,(HL)          ; fetch low byte of routine
        INC     HL              ; address next.
        LD      B,(HL)          ; fetch high byte of routine.
        EX      DE,HL           ; restore HL from DE
        PUSH    BC              ; push the address
        RET                     ; and make an indirect jump to the command.

; --------------------------------
; Command classes---01, 02, and 04
; --------------------------------
; class-01  e.g. LET A = 2*3     ; a variable is reqd

; This class routine is also called from INPUT and READ to find the
; destination variable for an assignment.

;; CLASS-01
L1C1F:  CALL    L28B2           ; routine LOOK-VARS returns carry set if not
                                ; found in runtime.

; ----------------------
; Variable in assignment
; ----------------------
;
;

;; VAR-A-1
L1C22:  LD      (IY+$37),$00    ; set FLAGX to zero
        JR      NC,L1C30        ; forward to VAR-A-2 if found or checking
                                ; syntax.

        SET     1,(IY+$37)      ; FLAGX  - Signal a new variable
        JR      NZ,L1C46        ; to VAR-A-3 if not assigning to an array
                                ; e.g. LET a$(3,3) = "X"

;; REPORT-2
L1C2E:  RST     08H             ; ERROR-1
        DEFB    $01             ; Error Report: Variable not found

;; VAR-A-2
L1C30:  CALL    Z,L2996         ; routine STK-VAR considers a subscript/slice
        BIT     6,(IY+$01)      ; test FLAGS  - Numeric or string result ?
        JR      NZ,L1C46        ; to VAR-A-3 if numeric

        XOR     A               ; default to array/slice - to be retained.
        CALL    L2530           ; routine SYNTAX-Z
        CALL    NZ,L2BF1        ; routine STK-FETCH is called in runtime
                                ; may overwrite A with 1.
        LD      HL,$5C71        ; address system variable FLAGX
        OR      (HL)            ; set bit 0 if simple variable to be reclaimed
        LD      (HL),A          ; update FLAGX
        EX      DE,HL           ; start of string/subscript to DE

;; VAR-A-3
L1C46:  LD      ($5C72),BC      ; update STRLEN
        LD      ($5C4D),HL      ; and DEST of assigned string.
        RET                     ; return.

; -------------------------------------------------
; class-02 e.g. LET a = 1 + 1   ; an expression must follow

;; CLASS-02
L1C4E:  POP     BC              ; drop return address SCAN-LOOP
        CALL    L1C56           ; routine VAL-FET-1 is called to check
                                ; expression and assign result in runtime
        CALL    L1BEE           ; routine CHECK-END checks nothing else
                                ; is present in statement.
        RET                     ; Return

; -------------
; Fetch a value
; -------------
;
;

;; VAL-FET-1
L1C56:  LD      A,($5C3B)       ; initial FLAGS to A

;; VAL-FET-2
L1C59:  PUSH    AF              ; save A briefly
        CALL    L24FB           ; routine SCANNING evaluates expression.
        POP     AF              ; restore A
        LD      D,(IY+$01)      ; post-SCANNING FLAGS to D
        XOR     D               ; xor the two sets of flags
        AND     $40             ; pick up bit 6 of xored FLAGS should be zero
        JR      NZ,L1C8A        ; forward to REPORT-C if not zero
                                ; 'Nonsense in BASIC' - results don't agree.

        BIT     7,D             ; test FLAGS - is syntax being checked ?
        JP      NZ,L2AFF        ; jump forward to LET to make the assignment
                                ; in runtime.

        RET                     ; but return from here if checking syntax.

; ------------------
; Command class---04
; ------------------
; class-04 e.g. FOR i            ; a single character variable must follow

;; CLASS-04
L1C6C:  CALL    L28B2           ; routine LOOK-VARS
        PUSH    AF              ; preserve flags.
        LD      A,C             ; fetch type - should be 011xxxxx
        OR      $9F             ; combine with 10011111.
        INC     A               ; test if now $FF by incrementing.
        JR      NZ,L1C8A        ; forward to REPORT-C if result not zero.

        POP     AF              ; else restore flags.
        JR      L1C22           ; back to VAR-A-1


; --------------------------------
; Expect numeric/string expression
; --------------------------------
; This routine is used to get the two coordinates of STRING$, ATTR and POINT.
; It is also called from PRINT-ITEM to get the two numeric expressions that
; follow the AT ( in PRINT AT, INPUT AT).

;; NEXT-2NUM
L1C79:  RST     20H             ; NEXT-CHAR advance past 'AT' or '('.

; --------
; class-08 e.g. POKE 65535,2     ; two numeric expressions separated by comma
;; CLASS-08
;; EXPT-2NUM
L1C7A:  CALL    L1C82           ; routine EXPT-1NUM is called for first
                                ; numeric expression
        CP      $2C             ; is character ',' ?
        JR      NZ,L1C8A        ; to REPORT-C if not required separator.
                                ; 'Nonsense in BASIC'.

        RST     20H             ; NEXT-CHAR

; ->
;  class-06  e.g. GOTO a*1000   ; a numeric expression must follow
;; CLASS-06
;; EXPT-1NUM
L1C82:  CALL    L24FB           ; routine SCANNING
        BIT     6,(IY+$01)      ; test FLAGS  - Numeric or string result ?
        RET     NZ              ; return if result is numeric.

;; REPORT-C
L1C8A:  RST     08H             ; ERROR-1
        DEFB    $0B             ; Error Report: Nonsense in BASIC

; ---------------------------------------------------------------
; class-0A e.g. ERASE "????"    ; a string expression must follow.
;                               ; these only occur in unimplemented commands
;                               ; although the routine expt-exp is called
;                               ; from SAVE-ETC

;; CLASS-0A
;; EXPT-EXP
L1C8C:  CALL    L24FB           ; routine SCANNING
        BIT     6,(IY+$01)      ; test FLAGS  - Numeric or string result ?
        RET     Z               ; return if string result.

        JR      L1C8A           ; back to REPORT-C if numeric.

; ---------------------
; Set permanent colours
; class 07
; ---------------------
; class-07 e.g. PAPER 6          ; a single class for a collection of
;                               ; similar commands. Clever.
;
; Note. these commands should ensure that current channel is 'S'

;; CLASS-07
L1C96:  BIT     7,(IY+$01)      ; test FLAGS - checking syntax only ?
                                ; Note. there is a subroutine to do this.
        RES     0,(IY+$02)      ; update TV_FLAG - signal main screen in use
        CALL    NZ,L0D4D        ; routine TEMPS is called in runtime.
        POP     AF              ; drop return address SCAN-LOOP
        LD      A,($5C74)       ; T_ADDR_lo to accumulator.
                                ; points to '$07' entry + 1
                                ; e.g. for INK points to $EC now

; Note if you move alter the syntax table next line may have to be altered.

; Note. For ZASM assembler replace following expression with SUB $13.

L1CA5:  SUB     +(L1AEB-$D8) % 256 ; convert $EB to $D8 ('INK') etc.
                                ; ( is SUB $13 in standard ROM )

        CALL    L21FC           ; routine CO-TEMP-4
        CALL    L1BEE           ; routine CHECK-END check that nothing else
                                ; in statement.

; return here in runtime.

        LD      HL,($5C8F)      ; pick up ATTR_T and MASK_T
        LD      ($5C8D),HL      ; and store in ATTR_P and MASK_P
        LD      HL,$5C91        ; point to P_FLAG.
        LD      A,(HL)          ; pick up in A
        RLCA                    ; rotate to left
        XOR     (HL)            ; combine with HL
        AND     $AA             ; 10101010
        XOR     (HL)            ; only permanent bits affected
        LD      (HL),A          ; reload into P_FLAG.
        RET                     ; return.

; ------------------
; Command class---09
; ------------------
; e.g. PLOT PAPER 0; 128,88     ; two coordinates preceded by optional
;                               ; embedded colour items.
;
; Note. this command should ensure that current channel is actually 'S'.

;; CLASS-09
L1CBE:  CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L1CD6         ; forward to CL-09-1 if checking syntax.

        RES     0,(IY+$02)      ; update TV_FLAG - signal main screen in use
        CALL    L0D4D           ; routine TEMPS is called.
        LD      HL,$5C90        ; point to MASK_T
        LD      A,(HL)          ; fetch mask to accumulator.
        OR      $F8             ; or with 11111000 paper/bright/flash 8
        LD      (HL),A          ; mask back to MASK_T system variable.
        RES     6,(IY+$57)      ; reset P_FLAG  - signal NOT PAPER 9 ?

        RST     18H             ; GET-CHAR

;; CL-09-1
L1CD6:  CALL    L21E2           ; routine CO-TEMP-2 deals with any embedded
                                ; colour items.
        JR      L1C7A           ; exit via EXPT-2NUM to check for x,y.

; Note. if either of the numeric expressions contain STR$ then the flag setting 
; above will be undone when the channel flags are reset during STR$.
; e.g. 
; 10 BORDER 3 : PLOT VAL STR$ 128, VAL STR$ 100
; credit John Elliott.

; ------------------
; Command class---0B
; ------------------
; Again a single class for four commands.
; This command just jumps back to SAVE-ETC to handle the four tape commands.
; The routine itself works out which command has called it by examining the
; address in T_ADDR_lo. Note therefore that the syntax table has to be
; located where these and other sequential command addresses are not split
; over a page boundary.

;; CLASS-0B
L1CDB:  JP      L0605           ; jump way back to SAVE-ETC

; --------------
; Fetch a number
; --------------
; This routine is called from CLASS-03 when a command may be followed by
; an optional numeric expression e.g. RUN. If the end of statement has
; been reached then zero is used as the default.
; Also called from LIST-4.

;; FETCH-NUM
L1CDE:  CP      $0D             ; is character a carriage return ?
        JR      Z,L1CE6         ; forward to USE-ZERO if so

        CP      $3A             ; is it ':' ?
        JR      NZ,L1C82        ; forward to EXPT-1NUM if not.
                                ; else continue and use zero.

; ----------------
; Use zero routine
; ----------------
; This routine is called four times to place the value zero on the
; calculator stack as a default value in runtime.

;; USE-ZERO
L1CE6:  CALL    L2530           ; routine SYNTAX-Z  (UNSTACK-Z?)
        RET     Z               ;

        RST     28H             ;; FP-CALC
        DEFB    $A0             ;;stk-zero       ;0.
        DEFB    $38             ;;end-calc

        RET                     ; return.

; -------------------
; Handle STOP command
; -------------------
; Command Syntax: STOP
; One of the shortest and least used commands. As with 'OK' not an error.

;; REPORT-9
;; STOP
L1CEE:  RST     08H             ; ERROR-1
        DEFB    $08             ; Error Report: STOP statement

; -----------------
; Handle IF command
; -----------------
; e.g. IF score>100 THEN PRINT "You Win"
; The parser has already checked the expression the result of which is on
; the calculator stack. The presence of the 'THEN' separator has also been
; checked and CH-ADD points to the command after THEN.
;

;; IF
L1CF0:  POP     BC              ; drop return address - STMT-RET
        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L1D00         ; forward to IF-1 if checking syntax
                                ; to check syntax of PRINT "You Win"


        RST     28H             ;; FP-CALC    score>100 (1=TRUE 0=FALSE)
        DEFB    $02             ;;delete      .
        DEFB    $38             ;;end-calc

        EX      DE,HL           ; make HL point to deleted value
        CALL    L34E9           ; routine TEST-ZERO
        JP      C,L1BB3         ; jump to LINE-END if FALSE (0)

;; IF-1
L1D00:  JP      L1B29           ; to STMT-L-1, if true (1) to execute command
                                ; after 'THEN' token.

; ------------------
; Handle FOR command
; ------------------
; e.g. FOR i = 0 TO 1 STEP 0.1
; Using the syntax tables, the parser has already checked for a start and
; limit value and also for the intervening separator.
; the two values v,l are on the calculator stack.
; CLASS-04 has also checked the variable and the name is in STRLEN_lo.
; The routine begins by checking for an optional STEP.

;; FOR
L1D03:  CP      $CD             ; is there a 'STEP' ?
        JR      NZ,L1D10        ; to F-USE-1 if not to use 1 as default.

        RST     20H             ; NEXT-CHAR
        CALL    L1C82           ; routine EXPT-1NUM
        CALL    L1BEE           ; routine CHECK-END
        JR      L1D16           ; to F-REORDER

; ---

;; F-USE-1
L1D10:  CALL    L1BEE           ; routine CHECK-END

        RST     28H             ;; FP-CALC      v,l.
        DEFB    $A1             ;;stk-one       v,l,1=s.
        DEFB    $38             ;;end-calc


;; F-REORDER
L1D16:  RST     28H             ;; FP-CALC       v,l,s.
        DEFB    $C0             ;;st-mem-0       v,l,s.
        DEFB    $02             ;;delete         v,l.
        DEFB    $01             ;;exchange       l,v.
        DEFB    $E0             ;;get-mem-0      l,v,s.
        DEFB    $01             ;;exchange       l,s,v.
        DEFB    $38             ;;end-calc

        CALL    L2AFF           ; routine LET assigns the initial value v to
                                ; the variable altering type if necessary.
        LD      ($5C68),HL      ; The system variable MEM is made to point to
                                ; the variable instead of its normal
                                ; location MEMBOT
        DEC     HL              ; point to single-character name
        LD      A,(HL)          ; fetch name
        SET     7,(HL)          ; set bit 7 at location
        LD      BC,$0006        ; add six to HL
        ADD     HL,BC           ; to address where limit should be.
        RLCA                    ; test bit 7 of original name.
        JR      C,L1D34         ; forward to F-L-S if already a FOR/NEXT
                                ; variable

        LD      C,$0D           ; otherwise an additional 13 bytes are needed.
                                ; 5 for each value, two for line number and
                                ; 1 byte for looping statement.
        CALL    L1655           ; routine MAKE-ROOM creates them.
        INC     HL              ; make HL address limit.

;; F-L-S
L1D34:  PUSH    HL              ; save position.

        RST     28H             ;; FP-CALC         l,s.
        DEFB    $02             ;;delete           l.
        DEFB    $02             ;;delete           .
        DEFB    $38             ;;end-calc
                                ; DE points to STKEND, l.

        POP     HL              ; restore variable position
        EX      DE,HL           ; swap pointers
        LD      C,$0A           ; ten bytes to move
        LDIR                    ; Copy 'deleted' values to variable.
        LD      HL,($5C45)      ; Load with current line number from PPC
        EX      DE,HL           ; exchange pointers.
        LD      (HL),E          ; save the looping line
        INC     HL              ; in the next
        LD      (HL),D          ; two locations.
        LD      D,(IY+$0D)      ; fetch statement from SUBPPC system variable.
        INC     D               ; increment statement.
        INC     HL              ; and pointer
        LD      (HL),D          ; and store the looping statement.
                                ;
        CALL    L1DDA           ; routine NEXT-LOOP considers an initial
        RET     NC              ; iteration. Return to STMT-RET if a loop is
                                ; possible to execute next statement.

; no loop is possible so execution continues after the matching 'NEXT'

        LD      B,(IY+$38)      ; get single-character name from STRLEN_lo
        LD      HL,($5C45)      ; get the current line from PPC
        LD      ($5C42),HL      ; and store it in NEWPPC
        LD      A,($5C47)       ; fetch current statement from SUBPPC
        NEG                     ; Negate as counter decrements from zero
                                ; initially and we are in the middle of a
                                ; line.
        LD      D,A             ; Store result in D.
        LD      HL,($5C5D)      ; get current address from CH_ADD
        LD      E,$F3           ; search will be for token 'NEXT'

;; F-LOOP
L1D64:  PUSH    BC              ; save variable name.
        LD      BC,($5C55)      ; fetch NXTLIN
        CALL    L1D86           ; routine LOOK-PROG searches for 'NEXT' token.
        LD      ($5C55),BC      ; update NXTLIN
        POP     BC              ; and fetch the letter
        JR      C,L1D84         ; forward to REPORT-I if the end of program
                                ; was reached by LOOK-PROG.
                                ; 'FOR without NEXT'

        RST     20H             ; NEXT-CHAR fetches character after NEXT
        OR      $20             ; ensure it is upper-case.
        CP      B               ; compare with FOR variable name
        JR      Z,L1D7C         ; forward to F-FOUND if it matches.

; but if no match i.e. nested FOR/NEXT loops then continue search.

        RST     20H             ; NEXT-CHAR
        JR      L1D64           ; back to F-LOOP

; ---


;; F-FOUND
L1D7C:  RST     20H             ; NEXT-CHAR
        LD      A,$01           ; subtract the negated counter from 1
        SUB     D               ; to give the statement after the NEXT
        LD      ($5C44),A       ; set system variable NSPPC
        RET                     ; return to STMT-RET to branch to new
                                ; line and statement. ->
; ---

;; REPORT-I
L1D84:  RST     08H             ; ERROR-1
        DEFB    $11             ; Error Report: FOR without NEXT

; ---------
; LOOK-PROG
; ---------
; Find DATA, DEF FN or NEXT.
; This routine searches the program area for one of the above three keywords.
; On entry, HL points to start of search area.
; The token is in E, and D holds a statement count, decremented from zero.

;; LOOK-PROG
L1D86:  LD      A,(HL)          ; fetch current character
        CP      $3A             ; is it ':' a statement separator ?
        JR      Z,L1DA3         ; forward to LOOK-P-2 if so.

; The starting point was PROG - 1 or the end of a line.

;; LOOK-P-1
L1D8B:  INC     HL              ; increment pointer to address
        LD      A,(HL)          ; the high byte of line number
        AND     $C0             ; test for program end marker $80 or a
                                ; variable
        SCF                     ; Set Carry Flag
        RET     NZ              ; return with carry set if at end
                                ; of program.           ->

        LD      B,(HL)          ; high byte of line number to B
        INC     HL              ;
        LD      C,(HL)          ; low byte to C.
        LD      ($5C42),BC      ; set system variable NEWPPC.
        INC     HL              ;
        LD      C,(HL)          ; low byte of line length to C.
        INC     HL              ;
        LD      B,(HL)          ; high byte to B.
        PUSH    HL              ; save address
        ADD     HL,BC           ; add length to position.
        LD      B,H             ; and save result
        LD      C,L             ; in BC.
        POP     HL              ; restore address.
        LD      D,$00           ; initialize statement counter to zero.

;; LOOK-P-2
L1DA3:  PUSH    BC              ; save address of next line
        CALL    L198B           ; routine EACH-STMT searches current line.
        POP     BC              ; restore address.
        RET     NC              ; return if match was found. ->

        JR      L1D8B           ; back to LOOK-P-1 for next line.

; -------------------
; Handle NEXT command
; -------------------
; e.g. NEXT i
; The parameter tables have already evaluated the presence of a variable

;; NEXT
L1DAB:  BIT     1,(IY+$37)      ; test FLAGX - handling a new variable ?
        JP      NZ,L1C2E        ; jump back to REPORT-2 if so
                                ; 'Variable not found'

; now test if found variable is a simple variable uninitialized by a FOR.

        LD      HL,($5C4D)      ; load address of variable from DEST
        BIT     7,(HL)          ; is it correct type ?
        JR      Z,L1DD8         ; forward to REPORT-1 if not
                                ; 'NEXT without FOR'

        INC     HL              ; step past variable name
        LD      ($5C68),HL      ; and set MEM to point to three 5-byte values
                                ; value, limit, step.

        RST     28H             ;; FP-CALC     add step and re-store
        DEFB    $E0             ;;get-mem-0    v.
        DEFB    $E2             ;;get-mem-2    v,s.
        DEFB    $0F             ;;addition     v+s.
        DEFB    $C0             ;;st-mem-0     v+s.
        DEFB    $02             ;;delete       .
        DEFB    $38             ;;end-calc

        CALL    L1DDA           ; routine NEXT-LOOP tests against limit.
        RET     C               ; return if no more iterations possible.

        LD      HL,($5C68)      ; find start of variable contents from MEM.
        LD      DE,$000F        ; add 3*5 to
        ADD     HL,DE           ; address the looping line number
        LD      E,(HL)          ; low byte to E
        INC     HL              ;
        LD      D,(HL)          ; high byte to D
        INC     HL              ; address looping statement
        LD      H,(HL)          ; and store in H
        EX      DE,HL           ; swap registers
        JP      L1E73           ; exit via GO-TO-2 to execute another loop.

; ---

;; REPORT-1
L1DD8:  RST     08H             ; ERROR-1
        DEFB    $00             ; Error Report: NEXT without FOR


; -----------------
; Perform NEXT loop
; -----------------
; This routine is called from the FOR command to test for an initial
; iteration and from the NEXT command to test for all subsequent iterations.
; the system variable MEM addresses the variable's contents which, in the
; latter case, have had the step, possibly negative, added to the value.

;; NEXT-LOOP
L1DDA:  RST     28H             ;; FP-CALC
        DEFB    $E1             ;;get-mem-1        l.
        DEFB    $E0             ;;get-mem-0        l,v.
        DEFB    $E2             ;;get-mem-2        l,v,s.
        DEFB    $36             ;;less-0           l,v,(1/0) negative step ?
        DEFB    $00             ;;jump-true        l,v.(1/0)

        DEFB    $02             ;;to L1DE2, NEXT-1 if step negative

        DEFB    $01             ;;exchange         v,l.

;; NEXT-1
L1DE2:  DEFB    $03             ;;subtract         l-v OR v-l.
        DEFB    $37             ;;greater-0        (1/0)
        DEFB    $00             ;;jump-true        .

        DEFB    $04             ;;to L1DE9, NEXT-2 if no more iterations.

        DEFB    $38             ;;end-calc         .

        AND     A               ; clear carry flag signalling another loop.
        RET                     ; return

; ---

;; NEXT-2
L1DE9:  DEFB    $38             ;;end-calc         .

        SCF                     ; set carry flag signalling looping exhausted.
        RET                     ; return


; -------------------
; Handle READ command
; -------------------
; e.g. READ a, b$, c$(1000 TO 3000)
; A list of comma-separated variables is assigned from a list of
; comma-separated expressions.
; As it moves along the first list, the character address CH_ADD is stored
; in X_PTR while CH_ADD is used to read the second list.

;; READ-3
L1DEC:  RST     20H             ; NEXT-CHAR

; -> Entry point.
;; READ
L1DED:  CALL    L1C1F           ; routine CLASS-01 checks variable.
        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L1E1E         ; forward to READ-2 if checking syntax


        RST     18H             ; GET-CHAR
        LD      ($5C5F),HL      ; save character position in X_PTR.
        LD      HL,($5C57)      ; load HL with Data Address DATADD, which is
                                ; the start of the program or the address
                                ; after the last expression that was read or
                                ; the address of the line number of the 
                                ; last RESTORE command.
        LD      A,(HL)          ; fetch character
        CP      $2C             ; is it a comma ?
        JR      Z,L1E0A         ; forward to READ-1 if so.

; else all data in this statement has been read so look for next DATA token

        LD      E,$E4           ; token 'DATA'
        CALL    L1D86           ; routine LOOK-PROG
        JR      NC,L1E0A        ; forward to READ-1 if DATA found

; else report the error.

;; REPORT-E
L1E08:  RST     08H             ; ERROR-1
        DEFB    $0D             ; Error Report: Out of DATA

;; READ-1
L1E0A:  CALL    L0077           ; routine TEMP-PTR1 advances updating CH_ADD
                                ; with new DATADD position.
        CALL    L1C56           ; routine VAL-FET-1 assigns value to variable
                                ; checking type match and adjusting CH_ADD.

        RST     18H             ; GET-CHAR fetches adjusted character position
        LD      ($5C57),HL      ; store back in DATADD
        LD      HL,($5C5F)      ; fetch X_PTR  the original READ CH_ADD
        LD      (IY+$26),$00    ; now nullify X_PTR_hi
        CALL    L0078           ; routine TEMP-PTR2 restores READ CH_ADD

;; READ-2
L1E1E:  RST     18H             ; GET-CHAR
        CP      $2C             ; is it ',' indicating more variables to read ?
        JR      Z,L1DEC         ; back to READ-3 if so

        CALL    L1BEE           ; routine CHECK-END
        RET                     ; return from here in runtime to STMT-RET.

; -------------------
; Handle DATA command
; -------------------
; In runtime this 'command' is passed by but the syntax is checked when such
; a statement is found while parsing a line.
; e.g. DATA 1, 2, "text", score-1, a$(location, room, object), FN r(49),
;         wages - tax, TRUE, The meaning of life

;; DATA
L1E27:  CALL    L2530           ; routine SYNTAX-Z to check status
        JR      NZ,L1E37        ; forward to DATA-2 if in runtime

;; DATA-1
L1E2C:  CALL    L24FB           ; routine SCANNING to check syntax of
                                ; expression
        CP      $2C             ; is it a comma ?
        CALL    NZ,L1BEE        ; routine CHECK-END checks that statement
                                ; is complete. Will make an early exit if
                                ; so. >>>
        RST     20H             ; NEXT-CHAR
        JR      L1E2C           ; back to DATA-1

; ---

;; DATA-2
L1E37:  LD      A,$E4           ; set token to 'DATA' and continue into
                                ; the PASS-BY routine.


; ----------------------------------
; Check statement for DATA or DEF FN
; ----------------------------------
; This routine is used to backtrack to a command token and then
; forward to the next statement in runtime.

;; PASS-BY
L1E39:  LD      B,A             ; Give BC enough space to find token.
        CPDR                    ; Compare decrement and repeat. (Only use).
                                ; Work backwards till keyword is found which
                                ; is start of statement before any quotes.
                                ; HL points to location before keyword.
        LD      DE,$0200        ; count 1+1 statements, dummy value in E to
                                ; inhibit searching for a token.
        JP      L198B           ; to EACH-STMT to find next statement

; -----------------------------------------------------------------------
; A General Note on Invalid Line Numbers.
; =======================================
; One of the revolutionary concepts of Sinclair BASIC was that it supported
; virtual line numbers. That is the destination of a GO TO, RESTORE etc. need
; not exist. It could be a point before or after an actual line number.
; Zero suffices for a before but the after should logically be infinity.
; Since the maximum actual line limit is 9999 then the system limit, 16383
; when variables kick in, would serve fine as a virtual end point.
; However, ironically, only the LOAD command gets it right. It will not
; autostart a program that has been saved with a line higher than 16383.
; All the other commands deal with the limit unsatisfactorily.
; LIST, RUN, GO TO, GO SUB and RESTORE have problems and the latter may
; crash the machine when supplied with an inappropriate virtual line number.
; This is puzzling as very careful consideration must have been given to
; this point when the new variable types were allocated their masks and also
; when the routine NEXT-ONE was successfully re-written to reflect this.
; An enigma.
; -------------------------------------------------------------------------

; ----------------------
; Handle RESTORE command
; ----------------------
; The restore command sets the system variable for the data address to
; point to the location before the supplied line number or first line
; thereafter.
; This alters the position where subsequent READ commands look for data.
; Note. If supplied with inappropriate high numbers the system may crash
; in the LINE-ADDR routine as it will pass the program/variables end-marker
; and then lose control of what it is looking for - variable or line number.
; - observation, Steven Vickers, 1984, Pitman.

;; RESTORE
L1E42:  CALL    L1E99           ; routine FIND-INT2 puts integer in BC.
                                ; Note. B should be checked against limit $3F
                                ; and an error generated if higher.

; this entry point is used from RUN command with BC holding zero

;; REST-RUN
L1E45:  LD      H,B             ; transfer the line
        LD      L,C             ; number to the HL register.
        CALL    L196E           ; routine LINE-ADDR to fetch the address.
        DEC     HL              ; point to the location before the line.
        LD      ($5C57),HL      ; update system variable DATADD.
        RET                     ; return to STMT-RET (or RUN)

; ------------------------
; Handle RANDOMIZE command
; ------------------------
; This command sets the SEED for the RND function to a fixed value.
; With the parameter zero, a random start point is used depending on
; how long the computer has been switched on.

;; RANDOMIZE
L1E4F:  CALL    L1E99           ; routine FIND-INT2 puts parameter in BC.
        LD      A,B             ; test this
        OR      C               ; for zero.
        JR      NZ,L1E5A        ; forward to RAND-1 if not zero.

        LD      BC,($5C78)      ; use the lower two bytes at FRAMES1.

;; RAND-1
L1E5A:  LD      ($5C76),BC      ; place in SEED system variable.
        RET                     ; return to STMT-RET

; -----------------------
; Handle CONTINUE command
; -----------------------
; The CONTINUE command transfers the OLD (but incremented) values of
; line number and statement to the equivalent "NEW VALUE" system variables
; by using the last part of GO TO and exits indirectly to STMT-RET.

;; CONTINUE
L1E5F:  LD      HL,($5C6E)      ; fetch OLDPPC line number.
        LD      D,(IY+$36)      ; fetch OSPPC statement.
        JR      L1E73           ; forward to GO-TO-2

; --------------------
; Handle GO TO command
; --------------------
; The GO TO command routine is also called by GO SUB and RUN routines
; to evaluate the parameters of both commands.
; It updates the system variables used to fetch the next line/statement.
; It is at STMT-RET that the actual change in control takes place.
; Unlike some BASICs the line number need not exist.
; Note. the high byte of the line number is incorrectly compared with $F0
; instead of $3F. This leads to commands with operands greater than 32767
; being considered as having been run from the editing area and the
; error report 'Statement Lost' is given instead of 'OK'.
; - Steven Vickers, 1984.

;; GO-TO
L1E67:  CALL    L1E99           ; routine FIND-INT2 puts operand in BC
        LD      H,B             ; transfer line
        LD      L,C             ; number to HL.
        LD      D,$00           ; set statement to 0 - first.
        LD      A,H             ; compare high byte only
        CP      $F0             ; to $F0 i.e. 61439 in full.
        JR      NC,L1E9F        ; forward to REPORT-B if above.

; This call entry point is used to update the system variables e.g. by RETURN.

;; GO-TO-2
L1E73:  LD      ($5C42),HL      ; save line number in NEWPPC
        LD      (IY+$0A),D      ; and statement in NSPPC
        RET                     ; to STMT-RET (or GO-SUB command)

; ------------------
; Handle OUT command
; ------------------
; Syntax has been checked and the two comma-separated values are on the
; calculator stack.

;; OUT
L1E7A:  CALL    L1E85           ; routine TWO-PARAM fetches values
                                ; to BC and A.
        OUT     (C),A           ; perform the operation.
        RET                     ; return to STMT-RET.

; -------------------
; Handle POKE command
; -------------------
; This routine alters a single byte in the 64K address space.
; Happily no check is made as to whether ROM or RAM is addressed.
; Sinclair BASIC requires no poking of system variables.

;; POKE
L1E80:  CALL    L1E85           ; routine TWO-PARAM fetches values
                                ; to BC and A.
        LD      (BC),A          ; load memory location with A.
        RET                     ; return to STMT-RET.

; ------------------------------------
; Fetch two  parameters from calculator stack
; ------------------------------------
; This routine fetches a byte and word from the calculator stack
; producing an error if either is out of range.

;; TWO-PARAM
L1E85:  CALL    L2DD5           ; routine FP-TO-A
        JR      C,L1E9F         ; forward to REPORT-B if overflow occurred

        JR      Z,L1E8E         ; forward to TWO-P-1 if positive

        NEG                     ; negative numbers are made positive

;; TWO-P-1
L1E8E:  PUSH    AF              ; save the value
        CALL    L1E99           ; routine FIND-INT2 gets integer to BC
        POP     AF              ; restore the value
        RET                     ; return

; -------------
; Find integers
; -------------
; The first of these routines fetches a 8-bit integer (range 0-255) from the
; calculator stack to the accumulator and is used for colours, streams,
; durations and coordinates.
; The second routine fetches 16-bit integers to the BC register pair 
; and is used to fetch command and function arguments involving line numbers
; or memory addresses and also array subscripts and tab arguments.
; ->

;; FIND-INT1
L1E94:  CALL    L2DD5           ; routine FP-TO-A
        JR      L1E9C           ; forward to FIND-I-1 for common exit routine.

; ---

; ->

;; FIND-INT2
L1E99:  CALL    L2DA2           ; routine FP-TO-BC

;; FIND-I-1
L1E9C:  JR      C,L1E9F         ; to REPORT-Bb with overflow.

        RET     Z               ; return if positive.


;; REPORT-Bb
L1E9F:  RST     08H             ; ERROR-1
        DEFB    $0A             ; Error Report: Integer out of range

; ------------------
; Handle RUN command
; ------------------
; This command runs a program starting at an optional line.
; It performs a 'RESTORE 0' then CLEAR

;; RUN
L1EA1:  CALL    L1E67           ; routine GO-TO puts line number in
                                ; system variables.
        LD      BC,$0000        ; prepare to set DATADD to first line.
        CALL    L1E45           ; routine REST-RUN does the 'restore'.
                                ; Note BC still holds zero.
        JR      L1EAF           ; forward to CLEAR-RUN to clear variables
                                ; without disturbing RAMTOP and
                                ; exit indirectly to STMT-RET

; --------------------
; Handle CLEAR command
; --------------------
; This command reclaims the space used by the variables.
; It also clears the screen and the GO SUB stack.
; With an integer expression, it sets the uppermost memory
; address within the BASIC system.
; "Contrary to the manual, CLEAR doesn't execute a RESTORE" -
; Steven Vickers, Pitman Pocket Guide to the Spectrum, 1984.

;; CLEAR
L1EAC:  CALL    L1E99           ; routine FIND-INT2 fetches to BC.

;; CLEAR-RUN
L1EAF:  LD      A,B             ; test for
        OR      C               ; zero.
        JR      NZ,L1EB7        ; skip to CLEAR-1 if not zero.

        LD      BC,($5CB2)      ; use the existing value of RAMTOP if zero.

;; CLEAR-1
L1EB7:  PUSH    BC              ; save ramtop value.

        LD      DE,($5C4B)      ; fetch VARS
        LD      HL,($5C59)      ; fetch E_LINE
        DEC     HL              ; adjust to point at variables end-marker.
        CALL    L19E5           ; routine RECLAIM-1 reclaims the space used by
                                ; the variables.

        CALL    L0D6B           ; routine CLS to clear screen.

        LD      HL,($5C65)      ; fetch STKEND the start of free memory.
        LD      DE,$0032        ; allow for another 50 bytes.
        ADD     HL,DE           ; add the overhead to HL.

        POP     DE              ; restore the ramtop value.
        SBC     HL,DE           ; if HL is greater than the value then jump
        JR      NC,L1EDA        ; forward to REPORT-M
                                ; 'RAMTOP no good'

        LD      HL,($5CB4)      ; now P-RAMT ($7FFF on 16K RAM machine)
        AND     A               ; exact this time.
        SBC     HL,DE           ; new ramtop must be lower or the same.
        JR      NC,L1EDC        ; skip to CLEAR-2 if in actual RAM.

;; REPORT-M
L1EDA:  RST     08H             ; ERROR-1
        DEFB    $15             ; Error Report: RAMTOP no good

;; CLEAR-2
L1EDC:  EX      DE,HL           ; transfer ramtop value to HL.
        LD      ($5CB2),HL      ; update system variable RAMTOP.
        POP     DE              ; pop the return address STMT-RET.
        POP     BC              ; pop the Error Address.
        LD      (HL),$3E        ; now put the GO SUB end-marker at RAMTOP.
        DEC     HL              ; leave a location beneath it.
        LD      SP,HL           ; initialize the machine stack pointer.
        PUSH    BC              ; push the error address.
        LD      ($5C3D),SP      ; make ERR_SP point to location.
        EX      DE,HL           ; put STMT-RET in HL.
        JP      (HL)            ; and go there directly.

; ---------------------
; Handle GO SUB command
; ---------------------
; The GO SUB command diverts BASIC control to a new line number
; in a very similar manner to GO TO but
; the current line number and current statement + 1
; are placed on the GO SUB stack as a RETURN point.

;; GO-SUB
L1EED:  POP     DE              ; drop the address STMT-RET
        LD      H,(IY+$0D)      ; fetch statement from SUBPPC and
        INC     H               ; increment it
        EX      (SP),HL         ; swap - error address to HL,
                                ; H (statement) at top of stack,
                                ; L (unimportant) beneath.
        INC     SP              ; adjust to overwrite unimportant byte
        LD      BC,($5C45)      ; fetch the current line number from PPC
        PUSH    BC              ; and PUSH onto GO SUB stack.
                                ; the empty machine-stack can be rebuilt
        PUSH    HL              ; push the error address.
        LD      ($5C3D),SP      ; make system variable ERR_SP point to it.
        PUSH    DE              ; push the address STMT-RET.
        CALL    L1E67           ; call routine GO-TO to update the system
                                ; variables NEWPPC and NSPPC.
                                ; then make an indirect exit to STMT-RET via
        LD      BC,$0014        ; a 20-byte overhead memory check.

; ----------------------
; Check available memory
; ----------------------
; This routine is used on many occasions when extending a dynamic area
; upwards or the GO SUB stack downwards.

;; TEST-ROOM
L1F05:  LD      HL,($5C65)      ; fetch STKEND
        ADD     HL,BC           ; add the supplied test value
        JR      C,L1F15         ; forward to REPORT-4 if over $FFFF

        EX      DE,HL           ; was less so transfer to DE
        LD      HL,$0050        ; test against another 80 bytes
        ADD     HL,DE           ; anyway
        JR      C,L1F15         ; forward to REPORT-4 if this passes $FFFF

        SBC     HL,SP           ; if less than the machine stack pointer
        RET     C               ; then return - OK.

;; REPORT-4
L1F15:  LD      L,$03           ; prepare 'Out of Memory' 
        JP      L0055           ; jump back to ERROR-3 at $0055
                                ; Note. this error can't be trapped at $0008

; ------------------------------
; THE 'FREE MEMORY' USER ROUTINE
; ------------------------------
; This routine is not used by the ROM but allows users to evaluate
; approximate free memory with PRINT 65536 - USR 7962.

;; free-mem
L1F1A:  LD      BC,$0000        ; allow no overhead.

        CALL    L1F05           ; routine TEST-ROOM.

        LD      B,H             ; transfer the result
        LD      C,L             ; to the BC register.
        RET                     ; the USR function returns value of BC.

; --------------------
; THE 'RETURN' COMMAND
; --------------------
; As with any command, there are two values on the machine stack at the time 
; it is invoked.  The machine stack is below the GOSUB stack.  Both grow 
; downwards, the machine stack by two bytes, the GOSUB stack by 3 bytes. 
; The highest location is a statement byte followed by a two-byte line number.

;; RETURN
L1F23:  POP     BC              ; drop the address STMT-RET.
        POP     HL              ; now the error address.
        POP     DE              ; now a possible BASIC return line.
        LD      A,D             ; the high byte $00 - $27 is 
        CP      $3E             ; compared with the traditional end-marker $3E.
        JR      Z,L1F36         ; forward to REPORT-7 with a match.
                                ; 'RETURN without GOSUB'

; It was not the end-marker so a single statement byte remains at the base of 
; the calculator stack. It can't be popped off.

        DEC     SP              ; adjust stack pointer to create room for two 
                                ; bytes.
        EX      (SP),HL         ; statement to H, error address to base of
                                ; new machine stack.
        EX      DE,HL           ; statement to D,  BASIC line number to HL.
        LD      ($5C3D),SP      ; adjust ERR_SP to point to new stack pointer
        PUSH    BC              ; now re-stack the address STMT-RET
        JP      L1E73           ; to GO-TO-2 to update statement and line
                                ; system variables and exit indirectly to the
                                ; address just pushed on stack.

; ---

;; REPORT-7
L1F36:  PUSH    DE              ; replace the end-marker.
        PUSH    HL              ; now restore the error address
                                ; as will be required in a few clock cycles.

        RST     08H             ; ERROR-1
        DEFB    $06             ; Error Report: RETURN without GOSUB

; --------------------
; Handle PAUSE command
; --------------------
; The pause command takes as its parameter the number of interrupts
; for which to wait. PAUSE 50 pauses for about a second.
; PAUSE 0 pauses indefinitely.
; Both forms can be finished by pressing a key.

;; PAUSE
L1F3A:  CALL    L1E99           ; routine FIND-INT2 puts value in BC

;; PAUSE-1
L1F3D:  HALT                    ; wait for interrupt.
        DEC     BC              ; decrease counter.
        LD      A,B             ; test if
        OR      C               ; result is zero.
        JR      Z,L1F4F         ; forward to PAUSE-END if so.

        LD      A,B             ; test if
        AND     C               ; now $FFFF
        INC     A               ; that is, initially zero.
        JR      NZ,L1F49        ; skip forward to PAUSE-2 if not.

        INC     BC              ; restore counter to zero.

;; PAUSE-2
L1F49:  BIT     5,(IY+$01)      ; test FLAGS - has a new key been pressed ?
        JR      Z,L1F3D         ; back to PAUSE-1 if not.

;; PAUSE-END
L1F4F:  RES     5,(IY+$01)      ; update FLAGS - signal no new key
        RET                     ; and return.

; -------------------
; Check for BREAK key
; -------------------
; This routine is called from COPY-LINE, when interrupts are disabled,
; to test if BREAK (SHIFT - SPACE) is being pressed.
; It is also called at STMT-RET after every statement.

;; BREAK-KEY
L1F54:  LD      A,$7F           ; Input address: $7FFE
        IN      A,($FE)         ; read lower right keys
        RRA                     ; rotate bit 0 - SPACE
        RET     C               ; return if not reset

        LD      A,$FE           ; Input address: $FEFE
        IN      A,($FE)         ; read lower left keys
        RRA                     ; rotate bit 0 - SHIFT
        RET                     ; carry will be set if not pressed.
                                ; return with no carry if both keys
                                ; pressed.

; ---------------------
; Handle DEF FN command
; ---------------------
; e.g. DEF FN r$(a$,a) = a$(a TO )
; this 'command' is ignored in runtime but has its syntax checked
; during line-entry.

;; DEF-FN
L1F60:  CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L1F6A         ; forward to DEF-FN-1 if parsing

        LD      A,$CE           ; else load A with 'DEF FN' and
        JP      L1E39           ; jump back to PASS-BY

; ---

; continue here if checking syntax.

;; DEF-FN-1
L1F6A:  SET      6,(IY+$01)     ; set FLAGS  - Assume numeric result
        CALL    L2C8D           ; call routine ALPHA
        JR      NC,L1F89        ; if not then to DEF-FN-4 to jump to
                                ; 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR
        CP      $24             ; is it '$' ?
        JR      NZ,L1F7D        ; to DEF-FN-2 if not as numeric.

        RES     6,(IY+$01)      ; set FLAGS  - Signal string result

        RST     20H             ; get NEXT-CHAR

;; DEF-FN-2
L1F7D:  CP      $28             ; is it '(' ?
        JR      NZ,L1FBD        ; to DEF-FN-7 'Nonsense in BASIC'


        RST     20H             ; NEXT-CHAR
        CP      $29             ; is it ')' ?
        JR      Z,L1FA6         ; to DEF-FN-6 if null argument

;; DEF-FN-3
L1F86:  CALL    L2C8D           ; routine ALPHA checks that it is the expected
                                ; alphabetic character.

;; DEF-FN-4
L1F89:  JP      NC,L1C8A        ; to REPORT-C  if not
                                ; 'Nonsense in BASIC'.

        EX      DE,HL           ; save pointer in DE

        RST     20H             ; NEXT-CHAR re-initializes HL from CH_ADD
                                ; and advances.
        CP      $24             ; '$' ? is it a string argument.
        JR      NZ,L1F94        ; forward to DEF-FN-5 if not.

        EX      DE,HL           ; save pointer to '$' in DE

        RST     20H             ; NEXT-CHAR re-initializes HL and advances

;; DEF-FN-5
L1F94:  EX      DE,HL           ; bring back pointer.
        LD      BC,$0006        ; the function requires six hidden bytes for
                                ; each parameter passed.
                                ; The first byte will be $0E
                                ; then 5-byte numeric value
                                ; or 5-byte string pointer.

        CALL    L1655           ; routine MAKE-ROOM creates space in program
                                ; area.

        INC     HL              ; adjust HL (set by LDDR)
        INC     HL              ; to point to first location.
        LD      (HL),$0E        ; insert the 'hidden' marker.

; Note. these invisible storage locations hold nothing meaningful for the
; moment. They will be used every time the corresponding function is
; evaluated in runtime.
; Now consider the following character fetched earlier.

        CP      $2C             ; is it ',' ? (more than one parameter)
        JR      NZ,L1FA6        ; to DEF-FN-6 if not


        RST     20H             ; else NEXT-CHAR
        JR      L1F86           ; and back to DEF-FN-3

; ---

;; DEF-FN-6
L1FA6:  CP      $29             ; should close with a ')'
        JR      NZ,L1FBD        ; to DEF-FN-7 if not
                                ; 'Nonsense in BASIC'


        RST     20H             ; get NEXT-CHAR
        CP      $3D             ; is it '=' ?
        JR      NZ,L1FBD        ; to DEF-FN-7 if not 'Nonsense...'


        RST     20H             ; address NEXT-CHAR
        LD      A,($5C3B)       ; get FLAGS which has been set above
        PUSH    AF              ; and preserve

        CALL    L24FB           ; routine SCANNING checks syntax of expression
                                ; and also sets flags.

        POP     AF              ; restore previous flags
        XOR     (IY+$01)        ; xor with FLAGS - bit 6 should be same 
                                ; therefore will be reset.
        AND     $40             ; isolate bit 6.

;; DEF-FN-7
L1FBD:  JP      NZ,L1C8A        ; jump back to REPORT-C if the expected result 
                                ; is not the same type.
                                ; 'Nonsense in BASIC'

        CALL    L1BEE           ; routine CHECK-END will return early if
                                ; at end of statement and move onto next
                                ; else produce error report. >>>

                                ; There will be no return to here.

; -------------------------------
; Returning early from subroutine
; -------------------------------
; All routines are capable of being run in two modes - syntax checking mode
; and runtime mode.  This routine is called often to allow a routine to return 
; early if checking syntax.

;; UNSTACK-Z
L1FC3:  CALL    L2530           ; routine SYNTAX-Z sets zero flag if syntax
                                ; is being checked.

        POP     HL              ; drop the return address.
        RET      Z              ; return to previous call in chain if checking
                                ; syntax.

        JP      (HL)            ; jump to return address as BASIC program is
                                ; actually running.

; ---------------------
; Handle LPRINT command
; ---------------------
; A simple form of 'PRINT #3' although it can output to 16 streams.
; Probably for compatibility with other BASICs particularly ZX81 BASIC.
; An extra UDG might have been better.

;; LPRINT
L1FC9:  LD      A,$03           ; the printer channel
        JR      L1FCF           ; forward to PRINT-1

; ---------------------
; Handle PRINT commands
; ---------------------
; The Spectrum's main stream output command.
; The default stream is stream 2 which is normally the upper screen
; of the computer. However the stream can be altered in range 0 - 15.

;; PRINT
L1FCD:  LD      A,$02           ; the stream for the upper screen.

; The LPRINT command joins here.

;; PRINT-1
L1FCF:  CALL    L2530           ; routine SYNTAX-Z checks if program running
        CALL    NZ,L1601        ; routine CHAN-OPEN if so
        CALL    L0D4D           ; routine TEMPS sets temporary colours.
        CALL    L1FDF           ; routine PRINT-2 - the actual item
        CALL    L1BEE           ; routine CHECK-END gives error if not at end
                                ; of statement
        RET                     ; and return >>>

; ------------------------------------
; this subroutine is called from above
; and also from INPUT.

;; PRINT-2
L1FDF:  RST     18H             ; GET-CHAR gets printable character
        CALL    L2045           ; routine PR-END-Z checks if more printing
        JR      Z,L1FF2         ; to PRINT-4 if not     e.g. just 'PRINT :'

; This tight loop deals with combinations of positional controls and
; print items. An early return can be made from within the loop
; if the end of a print sequence is reached.

;; PRINT-3
L1FE5:  CALL    L204E           ; routine PR-POSN-1 returns zero if more
                                ; but returns early at this point if
                                ; at end of statement!
                                ; 
        JR      Z,L1FE5         ; to PRINT-3 if consecutive positioners

        CALL    L1FFC           ; routine PR-ITEM-1 deals with strings etc.
        CALL    L204E           ; routine PR-POSN-1 for more position codes
        JR      Z,L1FE5         ; loop back to PRINT-3 if so

;; PRINT-4
L1FF2:  CP      $29             ; return now if this is ')' from input-item.
                                ; (see INPUT.)
        RET     Z               ; or continue and print carriage return in
                                ; runtime

; ---------------------
; Print carriage return
; ---------------------
; This routine which continues from above prints a carriage return
; in run-time. It is also called once from PRINT-POSN.

;; PRINT-CR
L1FF5:  CALL    L1FC3           ; routine UNSTACK-Z

        LD      A,$0D           ; prepare a carriage return

        RST     10H             ; PRINT-A
        RET                     ; return


; -----------
; Print items
; -----------
; This routine deals with print items as in
; PRINT AT 10,0;"The value of A is ";a
; It returns once a single item has been dealt with as it is part
; of a tight loop that considers sequences of positional and print items

;; PR-ITEM-1
L1FFC:  RST     18H             ; GET-CHAR
        CP      $AC             ; is character 'AT' ?
        JR      NZ,L200E        ; forward to PR-ITEM-2 if not.

        CALL    L1C79           ; routine NEXT-2NUM  check for two comma 
                                ; separated numbers placing them on the 
                                ; calculator stack in runtime. 
        CALL    L1FC3           ; routine UNSTACK-Z quits if checking syntax.

        CALL    L2307           ; routine STK-TO-BC get the numbers in B and C.
        LD      A,$16           ; prepare the 'at' control.
        JR      L201E           ; forward to PR-AT-TAB to print the sequence.

; ---

;; PR-ITEM-2
L200E:  CP      $AD             ; is character 'TAB' ?
        JR      NZ,L2024        ; to PR-ITEM-3 if not


        RST     20H             ; NEXT-CHAR to address next character
        CALL    L1C82           ; routine EXPT-1NUM
        CALL    L1FC3           ; routine UNSTACK-Z quits if checking syntax.

        CALL    L1E99           ; routine FIND-INT2 puts integer in BC.
        LD      A,$17           ; prepare the 'tab' control.

;; PR-AT-TAB
L201E:  RST     10H             ; PRINT-A outputs the control

        LD      A,C             ; first value to A
        RST     10H             ; PRINT-A outputs it.

        LD      A,B             ; second value
        RST     10H             ; PRINT-A

        RET                     ; return - item finished >>>

; ---

; Now consider paper 2; #2; a$

;; PR-ITEM-3
L2024:  CALL    L21F2           ; routine CO-TEMP-3 will print any colour
        RET     NC              ; items - return if success.

        CALL    L2070           ; routine STR-ALTER considers new stream
        RET     NC              ; return if altered.

        CALL    L24FB           ; routine SCANNING now to evaluate expression
        CALL    L1FC3           ; routine UNSTACK-Z if not runtime.

        BIT     6,(IY+$01)      ; test FLAGS  - Numeric or string result ?
        CALL    Z,L2BF1         ; routine STK-FETCH if string.
                                ; note no flags affected.
        JP      NZ,L2DE3        ; to PRINT-FP to print if numeric >>>

; It was a string expression - start in DE, length in BC
; Now enter a loop to print it

;; PR-STRING
L203C:  LD      A,B             ; this tests if the
        OR      C               ; length is zero and sets flag accordingly.
        DEC     BC              ; this doesn't but decrements counter.
        RET     Z               ; return if zero.

        LD      A,(DE)          ; fetch character.
        INC     DE              ; address next location.

        RST     10H             ; PRINT-A.

        JR      L203C           ; loop back to PR-STRING.

; ---------------
; End of printing
; ---------------
; This subroutine returns zero if no further printing is required
; in the current statement.
; The first terminator is found in  escaped input items only,
; the others in print_items.

;; PR-END-Z
L2045:  CP      $29             ; is character a ')' ?
        RET     Z               ; return if so -        e.g. INPUT (p$); a$

;; PR-ST-END
L2048:  CP      $0D             ; is it a carriage return ?
        RET     Z               ; return also -         e.g. PRINT a

        CP      $3A             ; is character a ':' ?
        RET                     ; return - zero flag will be set if so.
                                ;                       e.g. PRINT a :

; --------------
; Print position
; --------------
; This routine considers a single positional character ';', ',', '''

;; PR-POSN-1
L204E:  RST     18H             ; GET-CHAR
        CP      $3B             ; is it ';' ?             
                                ; i.e. print from last position.
        JR      Z,L2067         ; forward to PR-POSN-3 if so.
                                ; i.e. do nothing.

        CP      $2C             ; is it ',' ?
                                ; i.e. print at next tabstop.
        JR      NZ,L2061        ; forward to PR-POSN-2 if anything else.

        CALL    L2530           ; routine SYNTAX-Z
        JR      Z,L2067         ; forward to PR-POSN-3 if checking syntax.

        LD      A,$06           ; prepare the 'comma' control character.

        RST     10H             ; PRINT-A  outputs to current channel in
                                ; run-time.

        JR      L2067           ; skip to PR-POSN-3.

; ---

; check for newline.

;; PR-POSN-2
L2061:  CP      $27             ; is character a "'" ? (newline)
        RET     NZ              ; return if no match              >>>

        CALL    L1FF5           ; routine PRINT-CR outputs a carriage return
                                ; in runtime only.

;; PR-POSN-3
L2067:  RST     20H             ; NEXT-CHAR to A.
        CALL    L2045           ; routine PR-END-Z checks if at end.
        JR      NZ,L206E        ; to PR-POSN-4 if not.

        POP     BC              ; drop return address if at end.

;; PR-POSN-4
L206E:  CP      A               ; reset the zero flag.
        RET                     ; and return to loop or quit.

; ------------
; Alter stream
; ------------
; This routine is called from PRINT ITEMS above, and also LIST as in
; LIST #15

;; STR-ALTER
L2070:  CP      $23             ; is character '#' ?
        SCF                     ; set carry flag.
        RET     NZ              ; return if no match.


        RST      20H            ; NEXT-CHAR
        CALL    L1C82           ; routine EXPT-1NUM gets stream number
        AND     A               ; prepare to exit early with carry reset
        CALL    L1FC3           ; routine UNSTACK-Z exits early if parsing
        CALL    L1E94           ; routine FIND-INT1 gets number off stack
        CP      $10             ; must be range 0 - 15 decimal.
        JP      NC,L160E        ; jump back to REPORT-Oa if not
                                ; 'Invalid stream'.

        CALL    L1601           ; routine CHAN-OPEN
        AND     A               ; clear carry - signal item dealt with.
        RET                     ; return

; -------------------
; THE 'INPUT' COMMAND 
; -------------------
; This command is mysterious.
;

;; INPUT
L2089:  CALL    L2530           ; routine SYNTAX-Z to check if in runtime.

        JR      Z,L2096         ; forward to INPUT-1 if checking syntax.

        LD      A,$01           ; select channel 'K' the keyboard for input.
        CALL    L1601           ; routine CHAN-OPEN opens the channel and sets
                                ; bit 0 of TV_FLAG.

;   Note. As a consequence of clearing the lower screen channel 0 is made 
;   the current channel so the above two instructions are superfluous.

        CALL    L0D6E           ; routine CLS-LOWER clears the lower screen
                                ; and sets DF_SZ to two and TV_FLAG to $01.

;; INPUT-1
L2096:  LD      (IY+$02),$01    ; update TV_FLAG - signal lower screen in use
                                ; ensuring that the correct set of system 
                                ; variables are updated and that the border 
                                ; colour is used. 

;   Note. The Complete Spectrum ROM Disassembly incorrectly names DF-SZ as the
;   system variable that is updated above and if, as some have done, you make 
;   this unnecessary alteration then there will be two blank lines between the
;   lower screen and the upper screen areas which will also scroll wrongly.

        CALL    L20C1           ; routine IN-ITEM-1 to handle the input.

        CALL    L1BEE           ; routine CHECK-END will make an early exit
                                ; if checking syntax. >>>

;   Keyboard input has been made and it remains to adjust the upper
;   screen in case the lower two lines have been extended upwards.

        LD      BC,($5C88)      ; fetch S_POSN current line/column of
                                ; the upper screen.
        LD      A,($5C6B)       ; fetch DF_SZ the display file size of
                                ; the lower screen.
        CP      B               ; test that lower screen does not overlap
        JR      C,L20AD         ; forward to INPUT-2 if not.

; the two screens overlap so adjust upper screen.

        LD      C,$21           ; set column of upper screen to leftmost.
        LD      B,A             ; and line to one above lower screen.
                                ; continue forward to update upper screen
                                ; print position.

;; INPUT-2
L20AD:  LD      ($5C88),BC      ; set S_POSN update upper screen line/column.
        LD      A,$19           ; subtract from twenty five
        SUB     B               ; the new line number.
        LD      ($5C8C),A       ; and place result in SCR_CT - scroll count.
        RES     0,(IY+$02)      ; update TV_FLAG - signal main screen in use.

        CALL    L0DD9           ; routine CL-SET sets the print position
                                ; system variables for the upper screen.

        JP      L0D6E           ; jump back to CLS-LOWER and make
                                ; an indirect exit >>.

; ---------------------
; INPUT ITEM subroutine
; ---------------------
;   This subroutine deals with the input items and print items.
;   from  the current input channel.
;   It is only called from the above INPUT routine but was obviously
;   once called from somewhere else in another context.

;; IN-ITEM-1
L20C1:  CALL    L204E           ; routine PR-POSN-1 deals with a single
                                ; position item at each call.
        JR      Z,L20C1         ; back to IN-ITEM-1 until no more in a
                                ; sequence.

        CP      $28             ; is character '(' ?
        JR      NZ,L20D8        ; forward to IN-ITEM-2 if not.

;   any variables within braces will be treated as part, or all, of the prompt
;   instead of being used as destination variables.

        RST     20H             ; NEXT-CHAR
        CALL    L1FDF           ; routine PRINT-2 to output the dynamic
                                ; prompt.

        RST     18H             ; GET-CHAR
        CP      $29             ; is character a matching ')' ?
        JP      NZ,L1C8A        ; jump back to REPORT-C if not.
                                ; 'Nonsense in BASIC'.

        RST     20H             ; NEXT-CHAR
        JP      L21B2           ; forward to IN-NEXT-2

; ---

;; IN-ITEM-2
L20D8:  CP      $CA             ; is the character the token 'LINE' ?
        JR      NZ,L20ED        ; forward to IN-ITEM-3 if not.

        RST     20H             ; NEXT-CHAR - variable must come next.
        CALL    L1C1F           ; routine CLASS-01 returns destination
                                ; address of variable to be assigned.
                                ; or generates an error if no variable
                                ; at this position.

        SET     7,(IY+$37)      ; update FLAGX  - signal handling INPUT LINE
        BIT     6,(IY+$01)      ; test FLAGS  - numeric or string result ?
        JP      NZ,L1C8A        ; jump back to REPORT-C if not string
                                ; 'Nonsense in BASIC'.

        JR      L20FA           ; forward to IN-PROMPT to set up workspace.

; ---

;   the jump was here for other variables.

;; IN-ITEM-3
L20ED:  CALL     L2C8D          ; routine ALPHA checks if character is
                                ; a suitable variable name.
        JP      NC,L21AF        ; forward to IN-NEXT-1 if not

        CALL    L1C1F           ; routine CLASS-01 returns destination
                                ; address of variable to be assigned.
        RES     7,(IY+$37)      ; update FLAGX  - signal not INPUT LINE.

;; IN-PROMPT
L20FA:  CALL    L2530           ; routine SYNTAX-Z
        JP      Z,L21B2         ; forward to IN-NEXT-2 if checking syntax.

        CALL    L16BF           ; routine SET-WORK clears workspace.
        LD      HL,$5C71        ; point to system variable FLAGX
        RES     6,(HL)          ; signal string result.
        SET     5,(HL)          ; signal in Input Mode for editor.
        LD      BC,$0001        ; initialize space required to one for
                                ; the carriage return.
        BIT     7,(HL)          ; test FLAGX - INPUT LINE in use ?
        JR      NZ,L211C        ; forward to IN-PR-2 if so as that is
                                ; all the space that is required.

        LD      A,($5C3B)       ; load accumulator from FLAGS
        AND     $40             ; mask to test BIT 6 of FLAGS and clear
                                ; the other bits in A.
                                ; numeric result expected ?
        JR      NZ,L211A        ; forward to IN-PR-1 if so

        LD      C,$03           ; increase space to three bytes for the
                                ; pair of surrounding quotes.

;; IN-PR-1
L211A:  OR      (HL)            ; if numeric result, set bit 6 of FLAGX.
        LD      (HL),A          ; and update system variable

;; IN-PR-2
L211C:  RST     30H             ; BC-SPACES opens 1 or 3 bytes in workspace
        LD      (HL),$0D        ; insert carriage return at last new location.
        LD      A,C             ; fetch the length, one or three.
        RRCA                    ; lose bit 0.
        RRCA                    ; test if quotes required.
        JR      NC,L2129        ; forward to IN-PR-3 if not.

        LD      A,$22           ; load the '"' character
        LD      (DE),A          ; place quote in first new location at DE.
        DEC     HL              ; decrease HL - from carriage return.
        LD      (HL),A          ; and place a quote in second location.

;; IN-PR-3
L2129:  LD      ($5C5B),HL      ; set keyboard cursor K_CUR to HL
        BIT     7,(IY+$37)      ; test FLAGX  - is this INPUT LINE ??
        JR      NZ,L215E        ; forward to IN-VAR-3 if so as input will
                                ; be accepted without checking its syntax.

        LD      HL,($5C5D)      ; fetch CH_ADD
        PUSH    HL              ; and save on stack.
        LD      HL,($5C3D)      ; fetch ERR_SP
        PUSH    HL              ; and save on stack

;; IN-VAR-1
L213A:  LD      HL,L213A        ; address: IN-VAR-1 - this address
        PUSH    HL              ; is saved on stack to handle errors.
        BIT     4,(IY+$30)      ; test FLAGS2  - is K channel in use ?
        JR      Z,L2148         ; forward to IN-VAR-2 if not using the
                                ; keyboard for input. (??)

        LD      ($5C3D),SP      ; set ERR_SP to point to IN-VAR-1 on stack.

;; IN-VAR-2
L2148:  LD      HL,($5C61)      ; set HL to WORKSP - start of workspace.
        CALL    L11A7           ; routine REMOVE-FP removes floating point
                                ; forms when looping in error condition.
        LD      (IY+$00),$FF    ; set ERR_NR to 'OK' cancelling the error.
                                ; but X_PTR causes flashing error marker
                                ; to be displayed at each call to the editor.
        CALL    L0F2C           ; routine EDITOR allows input to be entered
                                ; or corrected if this is second time around.

; if we pass to next then there are no system errors

        RES     7,(IY+$01)      ; update FLAGS  - signal checking syntax
        CALL    L21B9           ; routine IN-ASSIGN checks syntax using
                                ; the VAL-FET-2 and powerful SCANNING routines.
                                ; any syntax error and its back to IN-VAR-1.
                                ; but with the flashing error marker showing
                                ; where the error is.
                                ; Note. the syntax of string input has to be
                                ; checked as the user may have removed the
                                ; bounding quotes or escaped them as with
                                ; "hat" + "stand" for example.
; proceed if syntax passed.

        JR      L2161           ; jump forward to IN-VAR-4

; ---

; the jump was to here when using INPUT LINE.

;; IN-VAR-3
L215E:  CALL    L0F2C           ; routine EDITOR is called for input

; when ENTER received rejoin other route but with no syntax check.

; INPUT and INPUT LINE converge here.

;; IN-VAR-4
L2161:  LD      (IY+$22),$00    ; set K_CUR_hi to a low value so that the cursor
                                ; no longer appears in the input line.

        CALL    L21D6           ; routine IN-CHAN-K tests if the keyboard
                                ; is being used for input.
        JR      NZ,L2174        ; forward to IN-VAR-5 if using another input 
                                ; channel.

; continue here if using the keyboard.

        CALL    L111D           ; routine ED-COPY overprints the edit line
                                ; to the lower screen. The only visible
                                ; affect is that the cursor disappears.
                                ; if you're inputting more than one item in
                                ; a statement then that becomes apparent.

        LD      BC,($5C82)      ; fetch line and column from ECHO_E
        CALL    L0DD9           ; routine CL-SET sets S-POSNL to those
                                ; values.

; if using another input channel rejoin here.

;; IN-VAR-5
L2174:  LD      HL,$5C71        ; point HL to FLAGX
        RES     5,(HL)          ; signal not in input mode
        BIT     7,(HL)          ; is this INPUT LINE ?
        RES     7,(HL)          ; cancel the bit anyway.
        JR      NZ,L219B        ; forward to IN-VAR-6 if INPUT LINE.

        POP     HL              ; drop the looping address
        POP     HL              ; drop the address of previous
                                ; error handler.
        LD      ($5C3D),HL      ; set ERR_SP to point to it.
        POP     HL              ; drop original CH_ADD which points to
                                ; INPUT command in BASIC line.
        LD      ($5C5F),HL      ; save in X_PTR while input is assigned.
        SET     7,(IY+$01)      ; update FLAGS - Signal running program
        CALL    L21B9           ; routine IN-ASSIGN is called again
                                ; this time the variable will be assigned
                                ; the input value without error.
                                ; Note. the previous example now
                                ; becomes "hatstand"

        LD      HL,($5C5F)      ; fetch stored CH_ADD value from X_PTR.
        LD      (IY+$26),$00    ; set X_PTR_hi so that iy is no longer relevant.
        LD      ($5C5D),HL      ; put restored value back in CH_ADD
        JR      L21B2           ; forward to IN-NEXT-2 to see if anything
                                ; more in the INPUT list.

; ---

; the jump was to here with INPUT LINE only

;; IN-VAR-6
L219B:  LD      HL,($5C63)      ; STKBOT points to the end of the input.
        LD      DE,($5C61)      ; WORKSP points to the beginning.
        SCF                     ; prepare for true subtraction.
        SBC     HL,DE           ; subtract to get length
        LD      B,H             ; transfer it to
        LD      C,L             ; the BC register pair.
        CALL    L2AB2           ; routine STK-STO-$ stores parameters on
                                ; the calculator stack.
        CALL    L2AFF           ; routine LET assigns it to destination.
        JR      L21B2           ; forward to IN-NEXT-2 as print items
                                ; not allowed with INPUT LINE.
                                ; Note. that "hat" + "stand" will, for
                                ; example, be unchanged as also would
                                ; 'PRINT "Iris was here"'.

; ---

; the jump was to here when ALPHA found more items while looking for
; a variable name.

;; IN-NEXT-1
L21AF:  CALL    L1FFC           ; routine PR-ITEM-1 considers further items.

;; IN-NEXT-2
L21B2:  CALL    L204E           ; routine PR-POSN-1 handles a position item.
        JP      Z,L20C1         ; jump back to IN-ITEM-1 if the zero flag
                                ; indicates more items are present.

        RET                     ; return.

; ---------------------------
; INPUT ASSIGNMENT Subroutine
; ---------------------------
; This subroutine is called twice from the INPUT command when normal
; keyboard input is assigned. On the first occasion syntax is checked
; using SCANNING. The final call with the syntax flag reset is to make
; the assignment.

;; IN-ASSIGN
L21B9:  LD      HL,($5C61)      ; fetch WORKSP start of input
        LD      ($5C5D),HL      ; set CH_ADD to first character

        RST     18H             ; GET-CHAR ignoring leading white-space.
        CP      $E2             ; is it 'STOP'
        JR      Z,L21D0         ; forward to IN-STOP if so.

        LD      A,($5C71)       ; load accumulator from FLAGX
        CALL    L1C59           ; routine VAL-FET-2 makes assignment
                                ; or goes through the motions if checking
                                ; syntax. SCANNING is used.

        RST     18H             ; GET-CHAR
        CP      $0D             ; is it carriage return ?
        RET     Z               ; return if so
                                ; either syntax is OK
                                ; or assignment has been made.

; if another character was found then raise an error.
; User doesn't see report but the flashing error marker
; appears in the lower screen.

;; REPORT-Cb
L21CE:  RST     08H             ; ERROR-1
        DEFB    $0B             ; Error Report: Nonsense in BASIC

;; IN-STOP
L21D0:  CALL    L2530           ; routine SYNTAX-Z (UNSTACK-Z?)
        RET     Z               ; return if checking syntax
                                ; as user wouldn't see error report.
                                ; but generate visible error report
                                ; on second invocation.

;; REPORT-H
L21D4:  RST     08H             ; ERROR-1
        DEFB    $10             ; Error Report: STOP in INPUT

; -----------------------------------
; THE 'TEST FOR CHANNEL K' SUBROUTINE
; -----------------------------------
;   This subroutine is called once from the keyboard INPUT command to check if 
;   the input routine in use is the one for the keyboard.

;; IN-CHAN-K
L21D6:  LD      HL,($5C51)      ; fetch address of current channel CURCHL
        INC     HL              ;
        INC     HL              ; advance past
        INC     HL              ; input and
        INC     HL              ; output streams
        LD      A,(HL)          ; fetch the channel identifier.
        CP      $4B             ; test for 'K'
        RET                     ; return with zero set if keyboard is use.

; --------------------
; Colour Item Routines
; --------------------
;
; These routines have 3 entry points -
; 1) CO-TEMP-2 to handle a series of embedded Graphic colour items.
; 2) CO-TEMP-3 to handle a single embedded print colour item.
; 3) CO TEMP-4 to handle a colour command such as FLASH 1
;
; "Due to a bug, if you bring in a peripheral channel and later use a colour
;  statement, colour controls will be sent to it by mistake." - Steven Vickers
;  Pitman Pocket Guide, 1984.
;
; To be fair, this only applies if the last channel was other than 'K', 'S'
; or 'P', which are all that are supported by this ROM, but if that last
; channel was a microdrive file, network channel etc. then
; PAPER 6; CLS will not turn the screen yellow and
; CIRCLE INK 2; 128,88,50 will not draw a red circle.
;
; This bug does not apply to embedded PRINT items as it is quite permissible
; to mix stream altering commands and colour items.
; The fix therefore would be to ensure that CLASS-07 and CLASS-09 make
; channel 'S' the current channel when not checking syntax.
; -----------------------------------------------------------------

;; CO-TEMP-1
L21E1:  RST     20H             ; NEXT-CHAR

; -> Entry point from CLASS-09. Embedded Graphic colour items.
; e.g. PLOT INK 2; PAPER 8; 128,88
; Loops till all colour items output, finally addressing the coordinates.

;; CO-TEMP-2
L21E2:  CALL    L21F2           ; routine CO-TEMP-3 to output colour control.
        RET     C               ; return if nothing more to output. ->


        RST     18H             ; GET-CHAR
        CP      $2C             ; is it ',' separator ?
        JR      Z,L21E1         ; back if so to CO-TEMP-1

        CP      $3B             ; is it ';' separator ?
        JR      Z,L21E1         ; back to CO-TEMP-1 for more.

        JP      L1C8A           ; to REPORT-C (REPORT-Cb is within range)
                                ; 'Nonsense in BASIC'

; -------------------
; CO-TEMP-3
; -------------------
; -> this routine evaluates and outputs a colour control and parameter.
; It is called from above and also from PR-ITEM-3 to handle a single embedded
; print item e.g. PRINT PAPER 6; "Hi". In the latter case, the looping for
; multiple items is within the PR-ITEM routine.
; It is quite permissible to send these to any stream.

;; CO-TEMP-3
L21F2:  CP      $D9             ; is it 'INK' ?
        RET     C               ; return if less.

        CP      $DF             ; compare with 'OUT'
        CCF                     ; Complement Carry Flag
        RET     C               ; return if greater than 'OVER', $DE.

        PUSH    AF              ; save the colour token.

        RST     20H             ; address NEXT-CHAR
        POP     AF              ; restore token and continue.

; -> this entry point used by CLASS-07. e.g. the command PAPER 6.

;; CO-TEMP-4
L21FC:  SUB     $C9             ; reduce to control character $10 (INK)
                                ; thru $15 (OVER).
        PUSH    AF              ; save control.
        CALL    L1C82           ; routine EXPT-1NUM stacks addressed
                                ; parameter on calculator stack.
        POP     AF              ; restore control.
        AND     A               ; clear carry

        CALL    L1FC3           ; routine UNSTACK-Z returns if checking syntax.

        PUSH    AF              ; save again
        CALL    L1E94           ; routine FIND-INT1 fetches parameter to A.
        LD      D,A             ; transfer now to D
        POP     AF              ; restore control.

        RST     10H             ; PRINT-A outputs the control to current
                                ; channel.
        LD      A,D             ; transfer parameter to A.

        RST     10H             ; PRINT-A outputs parameter.
        RET                     ; return. ->

; -------------------------------------------------------------------------
;
;         {fl}{br}{   paper   }{  ink    }    The temporary colour attributes
;          ___ ___ ___ ___ ___ ___ ___ ___    system variable.
; ATTR_T  |   |   |   |   |   |   |   |   |
;         |   |   |   |   |   |   |   |   |
; 23695   |___|___|___|___|___|___|___|___|
;           7   6   5   4   3   2   1   0
;
;
;         {fl}{br}{   paper   }{  ink    }    The temporary mask used for
;          ___ ___ ___ ___ ___ ___ ___ ___    transparent colours. Any bit
; MASK_T  |   |   |   |   |   |   |   |   |   that is 1 shows that the
;         |   |   |   |   |   |   |   |   |   corresponding attribute is
; 23696   |___|___|___|___|___|___|___|___|   taken not from ATTR-T but from
;           7   6   5   4   3   2   1   0     what is already on the screen.
;
;
;         {paper9 }{ ink9 }{ inv1 }{ over1}   The print flags. Even bits are
;          ___ ___ ___ ___ ___ ___ ___ ___    temporary flags. The odd bits
; P_FLAG  |   |   |   |   |   |   |   |   |   are the permanent flags.
;         | p | t | p | t | p | t | p | t |
; 23697   |___|___|___|___|___|___|___|___|
;           7   6   5   4   3   2   1   0
;
; -----------------------------------------------------------------------

; ------------------------------------
;  The colour system variable handler.
; ------------------------------------
; This is an exit branch from PO-1-OPER, PO-2-OPER
; A holds control $10 (INK) to $15 (OVER)
; D holds parameter 0-9 for ink/paper 0,1 or 8 for bright/flash,
; 0 or 1 for over/inverse.

;; CO-TEMP-5
L2211:  SUB     $11             ; reduce range $FF-$04
        ADC     A,$00           ; add in carry if INK
        JR      Z,L2234         ; forward to CO-TEMP-7 with INK and PAPER.

        SUB     $02             ; reduce range $FF-$02
        ADC     A,$00           ; add carry if FLASH
        JR      Z,L2273         ; forward to CO-TEMP-C with FLASH and BRIGHT.

        CP      $01             ; is it 'INVERSE' ?
        LD      A,D             ; fetch parameter for INVERSE/OVER
        LD      B,$01           ; prepare OVER mask setting bit 0.
        JR      NZ,L2228        ; forward to CO-TEMP-6 if OVER

        RLCA                    ; shift bit 0
        RLCA                    ; to bit 2
        LD      B,$04           ; set bit 2 of mask for inverse.

;; CO-TEMP-6
L2228:  LD      C,A             ; save the A
        LD      A,D             ; re-fetch parameter
        CP      $02             ; is it less than 2
        JR      NC,L2244        ; to REPORT-K if not 0 or 1.
                                ; 'Invalid colour'.

        LD      A,C             ; restore A
        LD      HL,$5C91        ; address system variable P_FLAG
        JR      L226C           ; forward to exit via routine CO-CHANGE

; ---

; the branch was here with INK/PAPER and carry set for INK.

;; CO-TEMP-7
L2234:  LD      A,D             ; fetch parameter
        LD      B,$07           ; set ink mask 00000111
        JR      C,L223E         ; forward to CO-TEMP-8 with INK

        RLCA                    ; shift bits 0-2
        RLCA                    ; to
        RLCA                    ; bits 3-5
        LD      B,$38           ; set paper mask 00111000

; both paper and ink rejoin here

;; CO-TEMP-8
L223E:  LD      C,A             ; value to C
        LD      A,D             ; fetch parameter
        CP      $0A             ; is it less than 10d ?
        JR      C,L2246         ; forward to CO-TEMP-9 if so.

; ink 10 etc. is not allowed.

;; REPORT-K
L2244:  RST     08H             ; ERROR-1
        DEFB    $13             ; Error Report: Invalid colour

;; CO-TEMP-9
L2246:  LD      HL,$5C8F        ; address system variable ATTR_T initially.
        CP      $08             ; compare with 8
        JR      C,L2258         ; forward to CO-TEMP-B with 0-7.

        LD      A,(HL)          ; fetch temporary attribute as no change.
        JR      Z,L2257         ; forward to CO-TEMP-A with INK/PAPER 8

; it is either ink 9 or paper 9 (contrasting)

        OR      B               ; or with mask to make white
        CPL                     ; make black and change other to dark
        AND     $24             ; 00100100
        JR      Z,L2257         ; forward to CO-TEMP-A if black and
                                ; originally light.

        LD      A,B             ; else just use the mask (white)

;; CO-TEMP-A
L2257:  LD      C,A             ; save A in C

;; CO-TEMP-B
L2258:  LD      A,C             ; load colour to A
        CALL    L226C           ; routine CO-CHANGE addressing ATTR-T

        LD      A,$07           ; put 7 in accumulator
        CP      D               ; compare with parameter
        SBC     A,A             ; $00 if 0-7, $FF if 8
        CALL    L226C           ; routine CO-CHANGE addressing MASK-T
                                ; mask returned in A.

; now consider P-FLAG.

        RLCA                    ; 01110000 or 00001110
        RLCA                    ; 11100000 or 00011100
        AND     $50             ; 01000000 or 00010000  (AND 01010000)
        LD      B,A             ; transfer to mask
        LD      A,$08           ; load A with 8
        CP      D               ; compare with parameter
        SBC     A,A             ; $FF if was 9,  $00 if 0-8
                                ; continue while addressing P-FLAG
                                ; setting bit 4 if ink 9
                                ; setting bit 6 if paper 9

; -----------------------
; Handle change of colour
; -----------------------
; This routine addresses a system variable ATTR_T, MASK_T or P-FLAG in HL.
; colour value in A, mask in B.

;; CO-CHANGE
L226C:  XOR     (HL)            ; impress bits specified
        AND     B               ; by mask
        XOR     (HL)            ; on system variable.
        LD      (HL),A          ; update system variable.
        INC     HL              ; address next location.
        LD      A,B             ; put current value of mask in A
        RET                     ; return.

; ---

; the branch was here with flash and bright

;; CO-TEMP-C
L2273:  SBC     A,A             ; set zero flag for bright.
        LD      A,D             ; fetch original parameter 0,1 or 8
        RRCA                    ; rotate bit 0 to bit 7
        LD      B,$80           ; mask for flash 10000000
        JR      NZ,L227D        ; forward to CO-TEMP-D if flash

        RRCA                    ; rotate bit 7 to bit 6
        LD      B,$40           ; mask for bright 01000000

;; CO-TEMP-D
L227D:  LD      C,A             ; store value in C
        LD      A,D             ; fetch parameter
        CP      $08             ; compare with 8
        JR      Z,L2287         ; forward to CO-TEMP-E if 8

        CP      $02             ; test if 0 or 1
        JR      NC,L2244        ; back to REPORT-K if not
                                ; 'Invalid colour'

;; CO-TEMP-E
L2287:  LD      A,C             ; value to A
        LD      HL,$5C8F        ; address ATTR_T
        CALL    L226C           ; routine CO-CHANGE addressing ATTR_T
        LD      A,C             ; fetch value
        RRCA                    ; for flash8/bright8 complete
        RRCA                    ; rotations to put set bit in
        RRCA                    ; bit 7 (flash) bit 6 (bright)
        JR      L226C           ; back to CO-CHANGE addressing MASK_T
                                ; and indirect return.

; ---------------------
; Handle BORDER command
; ---------------------
; Command syntax example: BORDER 7
; This command routine sets the border to one of the eight colours.
; The colours used for the lower screen are based on this.

;; BORDER
L2294:  CALL    L1E94           ; routine FIND-INT1
        CP      $08             ; must be in range 0 (black) to 7 (white)
        JR      NC,L2244        ; back to REPORT-K if not
                                ; 'Invalid colour'.

        OUT     ($FE),A         ; outputting to port effects an immediate
                                ; change.
        RLCA                    ; shift the colour to
        RLCA                    ; the paper bits setting the
        RLCA                    ; ink colour black.
        BIT     5,A             ; is the number light coloured ?
                                ; i.e. in the range green to white.
        JR      NZ,L22A6        ; skip to BORDER-1 if so

        XOR     $07             ; make the ink white.

;; BORDER-1
L22A6:  LD      ($5C48),A       ; update BORDCR with new paper/ink
        RET                     ; return.

; -----------------
; Get pixel address
; -----------------
;
;

;; PIXEL-ADD
L22AA:  LD      A,$AF           ; load with 175 decimal.
        SUB     B               ; subtract the y value.
        JP      C,L24F9         ; jump forward to REPORT-Bc if greater.
                                ; 'Integer out of range'

; the high byte is derived from Y only.
; the first 3 bits are always 010
; the next 2 bits denote in which third of the screen the byte is.
; the last 3 bits denote in which of the 8 scan lines within a third
; the byte is located. There are 24 discrete values.


        LD      B,A             ; the line number from top of screen to B.
        AND     A               ; clear carry (already clear)
        RRA                     ;                     0xxxxxxx
        SCF                     ; set carry flag
        RRA                     ;                     10xxxxxx
        AND     A               ; clear carry flag
        RRA                     ;                     010xxxxx

        XOR     B               ;
        AND     $F8             ; keep the top 5 bits 11111000
        XOR     B               ;                     010xxbbb
        LD      H,A             ; transfer high byte to H.

; the low byte is derived from both X and Y.

        LD      A,C             ; the x value 0-255.
        RLCA                    ;
        RLCA                    ;
        RLCA                    ;
        XOR     B               ; the y value
        AND     $C7             ; apply mask             11000111
        XOR     B               ; restore unmasked bits  xxyyyxxx
        RLCA                    ; rotate to              xyyyxxxx
        RLCA                    ; required position.     yyyxxxxx
        LD      L,A             ; low byte to L.

; finally form the pixel position in A.

        LD      A,C             ; x value to A
        AND     $07             ; mod 8
        RET                     ; return

; ----------------
; Point Subroutine
; ----------------
; The point subroutine is called from s-point via the scanning functions
; table.

;; POINT-SUB
L22CB:  CALL    L2307           ; routine STK-TO-BC
        CALL    L22AA           ; routine PIXEL-ADD finds address of pixel.
        LD      B,A             ; pixel position to B, 0-7.
        INC     B               ; increment to give rotation count 1-8.
        LD      A,(HL)          ; fetch byte from screen.

;; POINT-LP
L22D4:  RLCA                    ; rotate and loop back
        DJNZ    L22D4           ; to POINT-LP until pixel at right.

        AND      $01            ; test to give zero or one.
        JP      L2D28           ; jump forward to STACK-A to save result.

; -------------------
; Handle PLOT command
; -------------------
; Command Syntax example: PLOT 128,88
;

;; PLOT
L22DC:  CALL    L2307           ; routine STK-TO-BC
        CALL    L22E5           ; routine PLOT-SUB
        JP      L0D4D           ; to TEMPS

; -------------------
; The Plot subroutine
; -------------------
; A screen byte holds 8 pixels so it is necessary to rotate a mask
; into the correct position to leave the other 7 pixels unaffected.
; However all 64 pixels in the character cell take any embedded colour
; items.
; A pixel can be reset (inverse 1), toggled (over 1), or set ( with inverse
; and over switches off). With both switches on, the byte is simply put
; back on the screen though the colours may change.

;; PLOT-SUB
L22E5:  LD      ($5C7D),BC      ; store new x/y values in COORDS
        CALL    L22AA           ; routine PIXEL-ADD gets address in HL,
                                ; count from left 0-7 in B.
        LD      B,A             ; transfer count to B.
        INC     B               ; increase 1-8.
        LD      A,$FE           ; 11111110 in A.

;; PLOT-LOOP
L22F0:  RRCA                    ; rotate mask.
        DJNZ    L22F0           ; to PLOT-LOOP until B circular rotations.

        LD      B,A             ; load mask to B
        LD      A,(HL)          ; fetch screen byte to A

        LD      C,(IY+$57)      ; P_FLAG to C
        BIT     0,C             ; is it to be OVER 1 ?
        JR      NZ,L22FD        ; forward to PL-TST-IN if so.

; was over 0

        AND     B               ; combine with mask to blank pixel.

;; PL-TST-IN
L22FD:  BIT     2,C             ; is it inverse 1 ?
        JR      NZ,L2303        ; to PLOT-END if so.

        XOR     B               ; switch the pixel
        CPL                     ; restore other 7 bits

;; PLOT-END
L2303:  LD      (HL),A          ; load byte to the screen.
        JP      L0BDB           ; exit to PO-ATTR to set colours for cell.

; ------------------------------
; Put two numbers in BC register
; ------------------------------
;
;

;; STK-TO-BC
L2307:  CALL    L2314           ; routine STK-TO-A
        LD      B,A             ;
        PUSH    BC              ;
        CALL    L2314           ; routine STK-TO-A
        LD      E,C             ;
        POP     BC              ;
        LD      D,C             ;
        LD      C,A             ;
        RET                     ;

; -----------------------
; Put stack in A register
; -----------------------
; This routine puts the last value on the calculator stack into the accumulator
; deleting the last value.

;; STK-TO-A
L2314:  CALL    L2DD5           ; routine FP-TO-A compresses last value into
                                ; accumulator. e.g. PI would become 3. 
                                ; zero flag set if positive.
        JP      C,L24F9         ; jump forward to REPORT-Bc if >= 255.5.

        LD      C,$01           ; prepare a positive sign byte.
        RET     Z               ; return if FP-TO-BC indicated positive.

        LD      C,$FF           ; prepare negative sign byte and
        RET                     ; return.


; --------------------
; THE 'CIRCLE' COMMAND
; --------------------
;   "Goe not Thou about to Square eyther circle" -
;   - John Donne, Cambridge educated theologian, 1624
;
;   The CIRCLE command draws a circle as a series of straight lines.
;   In some ways it can be regarded as a polygon, but the first line is drawn 
;   as a tangent, taking the radius as its distance from the centre.
;
;   Both the CIRCLE algorithm and the ARC drawing algorithm make use of the
;   'ROTATION FORMULA' (see later).  It is only necessary to work out where 
;   the first line will be drawn and how long it is and then the rotation 
;   formula takes over and calculates all other rotated points.
;
;   All Spectrum circles consist of two vertical lines at each side and two 
;   horizontal lines at the top and bottom. The number of lines is calculated
;   from the radius of the circle and is always divisible by 4. For complete 
;   circles it will range from 4 for a square circle to 32 for a circle of 
;   radius 87. The Spectrum can attempt larger circles e.g. CIRCLE 0,14,255
;   but these will error as they go off-screen after four lines are drawn.
;   At the opposite end, CIRCLE 128,88,1.23 will draw a circle as a perfect 3x3
;   square using 4 straight lines although very small circles are just drawn as 
;   a dot on the screen.
;
;   The first chord drawn is the vertical chord on the right of the circle.
;   The starting point is at the base of this chord which is drawn upwards and
;   the circle continues in an anti-clockwise direction. As noted earlier the 
;   x-coordinate of this point measured from the centre of the circle is the 
;   radius. 
;
;   The CIRCLE command makes extensive use of the calculator and as part of
;   process of drawing a large circle, free memory is checked 1315 times.
;   When drawing a large arc, free memory is checked 928 times.
;   A single call to 'sin' involves 63 memory checks and so values of sine 
;   and cosine are pre-calculated and held in the mem locations. As a 
;   clever trick 'cos' is derived from 'sin' using simple arithmetic operations
;   instead of the more expensive 'cos' function.
;
;   Initially, the syntax has been partly checked using the class for the DRAW 
;   command which stacks the origin of the circle (X,Y).

;; CIRCLE
L2320:  RST     18H             ; GET-CHAR              x, y.
        CP      $2C             ; Is character the required comma ?
        JP      NZ,L1C8A        ; Jump, if not, to REPORT-C
                                ; 'Nonsense in basic'

        RST     20H             ; NEXT-CHAR advances the parsed character address.
        CALL    L1C82           ; routine EXPT-1NUM stacks radius in runtime.
        CALL    L1BEE           ; routine CHECK-END will return here in runtime
                                ; if nothing follows the command.

;   Now make the radius positive and ensure that it is in floating point form 
;   so that the exponent byte can be accessed for quick testing.

        RST     28H             ;; FP-CALC              x, y, r.
        DEFB    $2A             ;;abs                   x, y, r.
        DEFB    $3D             ;;re-stack              x, y, r.
        DEFB    $38             ;;end-calc              x, y, r.

        LD      A,(HL)          ; Fetch first, floating-point, exponent byte.
        CP      $81             ; Compare to one.
        JR      NC,L233B        ; Forward to C-R-GRE-1 
                                ; if circle radius is greater than one.

;    The circle is no larger than a single pixel so delete the radius from the
;    calculator stack and plot a point at the centre.

        RST     28H             ;; FP-CALC              x, y, r.
        DEFB    $02             ;;delete                x, y.                  
        DEFB    $38             ;;end-calc              x, y.

        JR      L22DC           ; back to PLOT routine to just plot x,y.

; ---

;   Continue when the circle's radius measures greater than one by forming 
;   the angle 2 * PI radians which is 360 degrees.

;; C-R-GRE-1
L233B:  RST     28H             ;; FP-CALC      x, y, r
        DEFB    $A3             ;;stk-pi/2      x, y, r, pi/2.
        DEFB    $38             ;;end-calc      x, y, r, pi/2.

;   Change the exponent of pi/2 from $81 to $83 giving 2*PI the central angle.
;   This is quicker than multiplying by four.

        LD      (HL),$83        ;               x, y, r, 2*PI.

;   Now store this important constant in mem-5 and delete so that other 
;   parameters can be derived from it, by a routine shared with DRAW.

        RST     28H             ;; FP-CALC      x, y, r, 2*PI.
        DEFB    $C5             ;;st-mem-5      store 2*PI in mem-5
        DEFB    $02             ;;delete        x, y, r.
        DEFB    $38             ;;end-calc      x, y, r.

;   The parameters derived from mem-5 (A) and from the radius are set up in 
;   four of the other mem locations by the CIRCLE DRAW PARAMETERS routine which 
;   also returns the number of straight lines in the B register.

        CALL    L247D           ; routine CD-PRMS1

                                ; mem-0 ; A/No of lines (=a)            unused  
                                ; mem-1 ; sin(a/2)  will be moving x    var
                                ; mem-2 ; -         will be moving y    var
                                ; mem-3 ; cos(a)                        const
                                ; mem-4 ; sin(a)                        const
                                ; mem-5 ; Angle of rotation (A) (2*PI)  const
                                ; B     ; Number of straight lines.

        PUSH    BC              ; Preserve the number of lines in B.

;   Next calculate the length of half a chord by multiplying the sine of half 
;   the central angle by the radius of the circle.

        RST     28H             ;; FP-CALC      x, y, r.
        DEFB    $31             ;;duplicate     x, y, r, r.
        DEFB    $E1             ;;get-mem-1     x, y, r, r, sin(a/2).
        DEFB    $04             ;;multiply      x, y, r, half-chord.
        DEFB    $38             ;;end-calc      x, y, r, half-chord.

        LD      A,(HL)          ; fetch exponent  of the half arc to A.
        CP      $80             ; compare to a half pixel
        JR      NC,L235A        ; forward, if greater than .5, to C-ARC-GE1

;   If the first line is less than .5 then 4 'lines' would be drawn on the same 
;   spot so tidy the calculator stack and machine stack and plot the centre.

        RST     28H             ;; FP-CALC      x, y, r, hc.
        DEFB    $02             ;;delete        x, y, r.
        DEFB    $02             ;;delete        x, y.
        DEFB    $38             ;;end-calc      x, y.

        POP     BC              ; Balance machine stack by taking chord-count.

        JP      L22DC           ; JUMP to PLOT

; ---

;   The arc is greater than 0.5 so the circle can be drawn.

;; C-ARC-GE1
L235A:  RST     28H             ;; FP-CALC      x, y, r, hc.
        DEFB    $C2             ;;st-mem-2      x, y, r, half chord to mem-2.
        DEFB    $01             ;;exchange      x, y, hc, r.
        DEFB    $C0             ;;st-mem-0      x, y, hc, r.
        DEFB    $02             ;;delete        x, y, hc.

;   Subtract the length of the half-chord from the absolute y coordinate to
;   give the starting y coordinate sy. 
;   Note that for a circle this is also the end coordinate.

        DEFB    $03             ;;subtract      x, y-hc.  (The start y-coord)
        DEFB    $01             ;;exchange      sy, x.

;   Next simply add the radius to the x coordinate to give a fuzzy x-coordinate.
;   Strictly speaking, the radius should be multiplied by cos(a/2) first but
;   doing it this way makes the circle slightly larger.

        DEFB    $E0             ;;get-mem-0     sy, x, r.
        DEFB    $0F             ;;addition      sy, x+r.  (The start x-coord)

;   We now want three copies of this pair of values on the calculator stack.
;   The first pair remain on the stack throughout the circle routine and are 
;   the end points. The next pair will be the moving absolute values of x and y
;   that are updated after each line is drawn. The final pair will be loaded 
;   into the COORDS system variable so that the first vertical line starts at 
;   the right place.

        DEFB    $C0             ;;st-mem-0      sy, sx.
        DEFB    $01             ;;exchange      sx, sy.
        DEFB    $31             ;;duplicate     sx, sy, sy.
        DEFB    $E0             ;;get-mem-0     sx, sy, sy, sx.
        DEFB    $01             ;;exchange      sx, sy, sx, sy.
        DEFB    $31             ;;duplicate     sx, sy, sx, sy, sy.
        DEFB    $E0             ;;get-mem-0     sx, sy, sx, sy, sy, sx.

;   Locations mem-1 and mem-2 are the relative x and y values which are updated
;   after each line is drawn. Since we are drawing a vertical line then the rx
;   value in mem-1 is zero and the ry value in mem-2 is the full chord.

        DEFB    $A0             ;;stk-zero      sx, sy, sx, sy, sy, sx, 0.
        DEFB    $C1             ;;st-mem-1      sx, sy, sx, sy, sy, sx, 0.
        DEFB    $02             ;;delete        sx, sy, sx, sy, sy, sx.

;   Although the three pairs of x/y values are the same for a circle, they 
;   will be labelled terminating, absolute and start coordinates.

        DEFB    $38             ;;end-calc      tx, ty, ax, ay, sy, sx.

;   Use the exponent manipulating trick again to double the value of mem-2.

        INC     (IY+$62)        ; Increment MEM-2-1st doubling half chord.

;   Note. this first vertical chord is drawn at the radius so circles are
;   slightly displaced to the right.
;   It is only necessary to place the values (sx) and (sy) in the system 
;   variable COORDS to ensure that drawing commences at the correct pixel.
;   Note. a couple of LD (COORDS),A instructions would have been quicker, and 
;   simpler, than using LD (COORDS),HL.

        CALL    L1E94           ; routine FIND-INT1 fetches sx from stack to A.

        LD      L,A             ; place X value in L.
        PUSH    HL              ; save the holding register.

        CALL    L1E94           ; routine FIND-INT1 fetches sy to A

        POP     HL              ; restore the holding register.
        LD      H,A             ; and place y value in high byte.

        LD      ($5C7D),HL      ; Update the COORDS system variable.
                                ;
                                ;               tx, ty, ax, ay.

        POP     BC              ; restore the chord count  
                                ; values 4,8,12,16,20,24,28 or 32.

        JP      L2420           ; forward to DRW-STEPS
                                ;               tx, ty, ax, ay.

;   Note. the jump to DRW-STEPS is just to decrement B and jump into the 
;   middle of the arc-drawing loop. The arc count which includes the first 
;   vertical arc draws one less than the perceived number of arcs. 
;   The final arc offsets are obtained by subtracting the final COORDS value
;   from the initial sx and sy values which are kept at the base of the
;   calculator stack throughout the arc loop. 
;   This ensures that the final line finishes exactly at the starting pixel 
;   removing the possibility of any inaccuracy.
;   Since the initial sx and sy values are not required until the final arc
;   is drawn, they are not shown until then.
;   As the calculator stack is quite busy, only the active parts are shown in 
;   each section.


; ------------------
; THE 'DRAW' COMMAND
; ------------------
;   The Spectrum's DRAW command is overloaded and can take two parameters sets.
;
;   With two parameters, it simply draws an approximation to a straight line
;   at offset x,y using the LINE-DRAW routine.
;
;   With three parameters, an arc is drawn to the point at offset x,y turning 
;   through an angle, in radians, supplied by the third parameter.
;   The arc will consist of 4 to 252 straight lines each one of which is drawn 
;   by calls to the DRAW-LINE routine.

;; DRAW
L2382:  RST     18H             ; GET-CHAR
        CP      $2C             ; is it the comma character ?
        JR      Z,L238D         ; forward, if so, to DR-3-PRMS

;   There are two parameters e.g. DRAW 255,175

        CALL    L1BEE           ; routine CHECK-END

        JP      L2477           ; jump forward to LINE-DRAW

; ---

;    There are three parameters e.g. DRAW 255, 175, .5
;    The first two are relative coordinates and the third is the angle of 
;    rotation in radians (A).

;; DR-3-PRMS
L238D:  RST     20H             ; NEXT-CHAR skips over the 'comma'.

        CALL    L1C82           ; routine EXPT-1NUM stacks the rotation angle.

        CALL    L1BEE           ; routine CHECK-END

;   Now enter the calculator and store the complete rotation angle in mem-5 

        RST     28H             ;; FP-CALC      x, y, A.
        DEFB    $C5             ;;st-mem-5      x, y, A.

;   Test the angle for the special case of 360 degrees.

        DEFB    $A2             ;;stk-half      x, y, A, 1/2.
        DEFB    $04             ;;multiply      x, y, A/2.
        DEFB    $1F             ;;sin           x, y, sin(A/2).
        DEFB    $31             ;;duplicate     x, y, sin(A/2),sin(A/2)
        DEFB    $30             ;;not           x, y, sin(A/2), (0/1).
        DEFB    $30             ;;not           x, y, sin(A/2), (1/0).
        DEFB    $00             ;;jump-true     x, y, sin(A/2).

        DEFB    $06             ;;forward to L23A3, DR-SIN-NZ
                                ; if sin(r/2) is not zero.

;   The third parameter is 2*PI (or a multiple of 2*PI) so a 360 degrees turn
;   would just be a straight line.  Eliminating this case here prevents 
;   division by zero at later stage.

        DEFB    $02             ;;delete        x, y.
        DEFB    $38             ;;end-calc      x, y.

        JP      L2477           ; forward to LINE-DRAW

; ---

;   An arc can be drawn.

;; DR-SIN-NZ
L23A3:  DEFB    $C0             ;;st-mem-0      x, y, sin(A/2).   store mem-0
        DEFB    $02             ;;delete        x, y.

;   The next step calculates (roughly) the diameter of the circle of which the 
;   arc will form part.  This value does not have to be too accurate as it is
;   only used to evaluate the number of straight lines and then discarded.
;   After all for a circle, the radius is used. Consequently, a circle of 
;   radius 50 will have 24 straight lines but an arc of radius 50 will have 20
;   straight lines - when drawn in any direction.
;   So that simple arithmetic can be used, the length of the chord can be 
;   calculated as X+Y rather than by Pythagoras Theorem and the sine of the
;   nearest angle within reach is used.

        DEFB    $C1             ;;st-mem-1      x, y.             store mem-1
        DEFB    $02             ;;delete        x.

        DEFB    $31             ;;duplicate     x, x.
        DEFB    $2A             ;;abs           x, x (+ve).
        DEFB    $E1             ;;get-mem-1     x, X, y.
        DEFB    $01             ;;exchange      x, y, X.
        DEFB    $E1             ;;get-mem-1     x, y, X, y.
        DEFB    $2A             ;;abs           x, y, X, Y (+ve).
        DEFB    $0F             ;;addition      x, y, X+Y.
        DEFB    $E0             ;;get-mem-0     x, y, X+Y, sin(A/2).
        DEFB    $05             ;;division      x, y, X+Y/sin(A/2).
        DEFB    $2A             ;;abs           x, y, X+Y/sin(A/2) = D.

;    Bring back sin(A/2) from mem-0 which will shortly get trashed.
;    Then bring D to the top of the stack again.

        DEFB    $E0             ;;get-mem-0     x, y, D, sin(A/2).
        DEFB    $01             ;;exchange      x, y, sin(A/2), D.

;   Note. that since the value at the top of the stack has arisen as a result
;   of division then it can no longer be in integer form and the next re-stack
;   is unnecessary. Only the Sinclair ZX80 had integer division.

        DEFB    $3D             ;;re-stack      (unnecessary)

        DEFB    $38             ;;end-calc      x, y, sin(A/2), D.

;   The next test avoids drawing 4 straight lines when the start and end pixels
;   are adjacent (or the same) but is probably best dispensed with.

        LD      A,(HL)          ; fetch exponent byte of D.
        CP      $81             ; compare to 1
        JR      NC,L23C1        ; forward, if > 1,  to DR-PRMS

;   else delete the top two stack values and draw a simple straight line.

        RST     28H             ;; FP-CALC
        DEFB    $02             ;;delete
        DEFB    $02             ;;delete
        DEFB    $38             ;;end-calc      x, y.

        JP      L2477           ; to LINE-DRAW

; ---

;   The ARC will consist of multiple straight lines so call the CIRCLE-DRAW
;   PARAMETERS ROUTINE to pre-calculate sine values from the angle (in mem-5)
;   and determine also the number of straight lines from that value and the
;   'diameter' which is at the top of the calculator stack.

;; DR-PRMS
L23C1:  CALL    L247D           ; routine CD-PRMS1

                                ; mem-0 ; (A)/No. of lines (=a) (step angle)
                                ; mem-1 ; sin(a/2) 
                                ; mem-2 ; -
                                ; mem-3 ; cos(a)                        const
                                ; mem-4 ; sin(a)                        const
                                ; mem-5 ; Angle of rotation (A)         in
                                ; B     ; Count of straight lines - max 252.

        PUSH    BC              ; Save the line count on the machine stack.

;   Remove the now redundant diameter value D.

        RST     28H             ;; FP-CALC      x, y, sin(A/2), D.
        DEFB    $02             ;;delete        x, y, sin(A/2).

;   Dividing the sine of the step angle by the sine of the total angle gives
;   the length of the initial chord on a unary circle. This factor f is used
;   to scale the coordinates of the first line which still points in the 
;   direction of the end point and may be larger.

        DEFB    $E1             ;;get-mem-1     x, y, sin(A/2), sin(a/2)
        DEFB    $01             ;;exchange      x, y, sin(a/2), sin(A/2)
        DEFB    $05             ;;division      x, y, sin(a/2)/sin(A/2)
        DEFB    $C1             ;;st-mem-1      x, y. f.
        DEFB    $02             ;;delete        x, y.

;   With the factor stored, scale the x coordinate first.

        DEFB    $01             ;;exchange      y, x.
        DEFB    $31             ;;duplicate     y, x, x.
        DEFB    $E1             ;;get-mem-1     y, x, x, f.
        DEFB    $04             ;;multiply      y, x, x*f    (=xx)
        DEFB    $C2             ;;st-mem-2      y, x, xx.
        DEFB    $02             ;;delete        y. x.

;   Now scale the y coordinate.

        DEFB    $01             ;;exchange      x, y.
        DEFB    $31             ;;duplicate     x, y, y.
        DEFB    $E1             ;;get-mem-1     x, y, y, f
        DEFB    $04             ;;multiply      x, y, y*f    (=yy)

;   Note. 'sin' and 'cos' trash locations mem-0 to mem-2 so fetch mem-2 to the 
;   calculator stack for safe keeping.

        DEFB    $E2             ;;get-mem-2     x, y, yy, xx.

;   Once we get the coordinates of the first straight line then the 'ROTATION
;   FORMULA' used in the arc loop will take care of all other points, but we
;   now use a variation of that formula to rotate the first arc through (A-a)/2
;   radians. 
;   
;       xRotated = y * sin(angle) + x * cos(angle)
;       yRotated = y * cos(angle) - x * sin(angle)
;
 
        DEFB    $E5             ;;get-mem-5     x, y, yy, xx, A.
        DEFB    $E0             ;;get-mem-0     x, y, yy, xx, A, a.
        DEFB    $03             ;;subtract      x, y, yy, xx, A-a.
        DEFB    $A2             ;;stk-half      x, y, yy, xx, A-a, 1/2.
        DEFB    $04             ;;multiply      x, y, yy, xx, (A-a)/2. (=angle)
        DEFB    $31             ;;duplicate     x, y, yy, xx, angle, angle.
        DEFB    $1F             ;;sin           x, y, yy, xx, angle, sin(angle)
        DEFB    $C5             ;;st-mem-5      x, y, yy, xx, angle, sin(angle)
        DEFB    $02             ;;delete        x, y, yy, xx, angle

        DEFB    $20             ;;cos           x, y, yy, xx, cos(angle).

;   Note. mem-0, mem-1 and mem-2 can be used again now...

        DEFB    $C0             ;;st-mem-0      x, y, yy, xx, cos(angle).
        DEFB    $02             ;;delete        x, y, yy, xx.

        DEFB    $C2             ;;st-mem-2      x, y, yy, xx.
        DEFB    $02             ;;delete        x, y, yy.

        DEFB    $C1             ;;st-mem-1      x, y, yy.
        DEFB    $E5             ;;get-mem-5     x, y, yy, sin(angle)
        DEFB    $04             ;;multiply      x, y, yy*sin(angle).
        DEFB    $E0             ;;get-mem-0     x, y, yy*sin(angle), cos(angle)
        DEFB    $E2             ;;get-mem-2     x, y, yy*sin(angle), cos(angle), xx.
        DEFB    $04             ;;multiply      x, y, yy*sin(angle), xx*cos(angle).
        DEFB    $0F             ;;addition      x, y, xRotated.
        DEFB    $E1             ;;get-mem-1     x, y, xRotated, yy.
        DEFB    $01             ;;exchange      x, y, yy, xRotated.
        DEFB    $C1             ;;st-mem-1      x, y, yy, xRotated.
        DEFB    $02             ;;delete        x, y, yy.

        DEFB    $E0             ;;get-mem-0     x, y, yy, cos(angle).
        DEFB    $04             ;;multiply      x, y, yy*cos(angle).
        DEFB    $E2             ;;get-mem-2     x, y, yy*cos(angle), xx.
        DEFB    $E5             ;;get-mem-5     x, y, yy*cos(angle), xx, sin(angle).
        DEFB    $04             ;;multiply      x, y, yy*cos(angle), xx*sin(angle).
        DEFB    $03             ;;subtract      x, y, yRotated.
        DEFB    $C2             ;;st-mem-2      x, y, yRotated.

;   Now the initial x and y coordinates are made positive and summed to see 
;   if they measure up to anything significant.

        DEFB    $2A             ;;abs           x, y, yRotated'.
        DEFB    $E1             ;;get-mem-1     x, y, yRotated', xRotated.
        DEFB    $2A             ;;abs           x, y, yRotated', xRotated'.
        DEFB    $0F             ;;addition      x, y, yRotated+xRotated.
        DEFB    $02             ;;delete        x, y. 

        DEFB    $38             ;;end-calc      x, y. 

;   Although the test value has been deleted it is still above the calculator
;   stack in memory and conveniently DE which points to the first free byte
;   addresses the exponent of the test value.

        LD      A,(DE)          ; Fetch exponent of the length indicator.
        CP      $81             ; Compare to that for 1

        POP     BC              ; Balance the machine stack

        JP      C,L2477         ; forward, if the coordinates of first line
                                ; don't add up to more than 1, to LINE-DRAW 

;   Continue when the arc will have a discernable shape.

        PUSH    BC              ; Restore line counter to the machine stack.

;   The parameters of the DRAW command were relative and they are now converted 
;   to absolute coordinates by adding to the coordinates of the last point 
;   plotted. The first two values on the stack are the terminal tx and ty 
;   coordinates.  The x-coordinate is converted first but first the last point 
;   plotted is saved as it will initialize the moving ax, value. 

        RST     28H             ;; FP-CALC      x, y.
        DEFB    $01             ;;exchange      y, x.
        DEFB    $38             ;;end-calc      y, x.

        LD      A,($5C7D)       ; Fetch System Variable COORDS-x
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      y, x, last-x.

;   Store the last point plotted to initialize the moving ax value.

        DEFB    $C0             ;;st-mem-0      y, x, last-x.
        DEFB    $0F             ;;addition      y, absolute x.
        DEFB    $01             ;;exchange      tx, y.
        DEFB    $38             ;;end-calc      tx, y.

        LD      A,($5C7E)       ; Fetch System Variable COORDS-y
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      tx, y, last-y.

;   Store the last point plotted to initialize the moving ay value.

        DEFB    $C5             ;;st-mem-5      tx, y, last-y.
        DEFB    $0F             ;;addition      tx, ty.

;   Fetch the moving ax and ay to the calculator stack.

        DEFB    $E0             ;;get-mem-0     tx, ty, ax.
        DEFB    $E5             ;;get-mem-5     tx, ty, ax, ay.
        DEFB    $38             ;;end-calc      tx, ty, ax, ay.

        POP     BC              ; Restore the straight line count.

; -----------------------------------
; THE 'CIRCLE/DRAW CONVERGENCE POINT'
; -----------------------------------
;   The CIRCLE and ARC-DRAW commands converge here. 
;
;   Note. for both the CIRCLE and ARC commands the minimum initial line count 
;   is 4 (as set up by the CD_PARAMS routine) and so the zero flag will never 
;   be set and the loop is always entered.  The first test is superfluous and
;   the jump will always be made to ARC-START.

;; DRW-STEPS
L2420:  DEC     B               ; decrement the arc count (4,8,12,16...).            

        JR      Z,L245F         ; forward, if zero (not possible), to ARC-END

        JR      L2439           ; forward to ARC-START

; --------------
; THE 'ARC LOOP'
; --------------
;
;   The arc drawing loop will draw up to 31 straight lines for a circle and up 
;   251 straight lines for an arc between two points. In both cases the final
;   closing straight line is drawn at ARC_END, but it otherwise loops back to 
;   here to calculate the next coordinate using the ROTATION FORMULA where (a)
;   is the previously calculated, constant CENTRAL ANGLE of the arcs.
;
;       Xrotated = x * cos(a) - y * sin(a)
;       Yrotated = x * sin(a) + y * cos(a)
;
;   The values cos(a) and sin(a) are pre-calculated and held in mem-3 and mem-4 
;   for the duration of the routine.
;   Memory location mem-1 holds the last relative x value (rx) and mem-2 holds
;   the last relative y value (ry) used by DRAW.
;
;   Note. that this is a very clever twist on what is after all a very clever,
;   well-used formula.  Normally the rotation formula is used with the x and y
;   coordinates from the centre of the circle (or arc) and a supplied angle to 
;   produce two new x and y coordinates in an anticlockwise direction on the 
;   circumference of the circle.
;   What is being used here, instead, is the relative X and Y parameters from
;   the last point plotted that are required to get to the current point and 
;   the formula returns the next relative coordinates to use. 

;; ARC-LOOP
L2425:  RST     28H             ;; FP-CALC      
        DEFB    $E1             ;;get-mem-1     rx.
        DEFB    $31             ;;duplicate     rx, rx.
        DEFB    $E3             ;;get-mem-3     cos(a)
        DEFB    $04             ;;multiply      rx, rx*cos(a).
        DEFB    $E2             ;;get-mem-2     rx, rx*cos(a), ry.
        DEFB    $E4             ;;get-mem-4     rx, rx*cos(a), ry, sin(a). 
        DEFB    $04             ;;multiply      rx, rx*cos(a), ry*sin(a).
        DEFB    $03             ;;subtract      rx, rx*cos(a) - ry*sin(a)
        DEFB    $C1             ;;st-mem-1      rx, new relative x rotated.
        DEFB    $02             ;;delete        rx.

        DEFB    $E4             ;;get-mem-4     rx, sin(a).
        DEFB    $04             ;;multiply      rx*sin(a)
        DEFB    $E2             ;;get-mem-2     rx*sin(a), ry.
        DEFB    $E3             ;;get-mem-3     rx*sin(a), ry, cos(a).
        DEFB    $04             ;;multiply      rx*sin(a), ry*cos(a).
        DEFB    $0F             ;;addition      rx*sin(a) + ry*cos(a).
        DEFB    $C2             ;;st-mem-2      new relative y rotated.
        DEFB    $02             ;;delete        .
        DEFB    $38             ;;end-calc      .  

;   Note. the calculator stack actually holds   tx, ty, ax, ay
;   and the last absolute values of x and y 
;   are now brought into play.
;
;   Magically, the two new rotated coordinates rx and ry are all that we would
;   require to draw a circle or arc - on paper!
;   The Spectrum DRAW routine draws to the rounded x and y coordinate and so 
;   repetitions of values like 3.49 would mean that the fractional parts 
;   would be lost until eventually the draw coordinates might differ from the 
;   floating point values used above by several pixels.
;   For this reason the accurate offsets calculated above are added to the 
;   accurate, absolute coordinates maintained in ax and ay and these new 
;   coordinates have the integer coordinates of the last plot position 
;   ( from System Variable COORDS ) subtracted from them to give the relative 
;   coordinates required by the DRAW routine.

;   The mid entry point.

;; ARC-START
L2439:  PUSH    BC              ; Preserve the arc counter on the machine stack.

;   Store the absolute ay in temporary variable mem-0 for the moment.

        RST     28H             ;; FP-CALC      ax, ay.
        DEFB    $C0             ;;st-mem-0      ax, ay.
        DEFB    $02             ;;delete        ax.

;   Now add the fractional relative x coordinate to the fractional absolute
;   x coordinate to obtain a new fractional x-coordinate.

        DEFB    $E1             ;;get-mem-1     ax, xr.
        DEFB    $0F             ;;addition      ax+xr (= new ax).  
        DEFB    $31             ;;duplicate     ax, ax.
        DEFB    $38             ;;end-calc      ax, ax. 

        LD      A,($5C7D)       ; COORDS-x      last x    (integer ix 0-255)
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      ax, ax, ix.
        DEFB    $03             ;;subtract      ax, ax-ix  = relative DRAW Dx.

;   Having calculated the x value for DRAW do the same for the y value.

        DEFB    $E0             ;;get-mem-0     ax, Dx, ay.
        DEFB    $E2             ;;get-mem-2     ax, Dx, ay, ry.
        DEFB    $0F             ;;addition      ax, Dx, ay+ry (= new ay).
        DEFB    $C0             ;;st-mem-0      ax, Dx, ay.
        DEFB    $01             ;;exchange      ax, ay, Dx,
        DEFB    $E0             ;;get-mem-0     ax, ay, Dx, ay.
        DEFB    $38             ;;end-calc      ax, ay, Dx, ay.

        LD      A,($5C7E)       ; COORDS-y      last y (integer iy 0-175)
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      ax, ay, Dx, ay, iy.
        DEFB    $03             ;;subtract      ax, ay, Dx, ay-iy ( = Dy).
        DEFB    $38             ;;end-calc      ax, ay, Dx, Dy.

        CALL    L24B7           ; Routine DRAW-LINE draws (Dx,Dy) relative to
                                ; the last pixel plotted leaving absolute x 
                                ; and y on the calculator stack.
                                ;               ax, ay.

        POP     BC              ; Restore the arc counter from the machine stack.

        DJNZ    L2425           ; Decrement and loop while > 0 to ARC-LOOP

; -------------
; THE 'ARC END'
; -------------

;   To recap the full calculator stack is       tx, ty, ax, ay.

;   Just as one would do if drawing the curve on paper, the final line would
;   be drawn by joining the last point plotted to the initial start point 
;   in the case of a CIRCLE or to the calculated end point in the case of 
;   an ARC.
;   The moving absolute values of x and y are no longer required and they
;   can be deleted to expose the closing coordinates.

;; ARC-END
L245F:  RST     28H             ;; FP-CALC      tx, ty, ax, ay.
        DEFB    $02             ;;delete        tx, ty, ax.
        DEFB    $02             ;;delete        tx, ty.
        DEFB    $01             ;;exchange      ty, tx.
        DEFB    $38             ;;end-calc      ty, tx.

;   First calculate the relative x coordinate to the end-point.

        LD      A,($5C7D)       ; COORDS-x
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      ty, tx, coords_x.
        DEFB    $03             ;;subtract      ty, rx.

;   Next calculate the relative y coordinate to the end-point.

        DEFB    $01             ;;exchange      rx, ty.
        DEFB    $38             ;;end-calc      rx, ty.

        LD      A,($5C7E)       ; COORDS-y
        CALL    L2D28           ; routine STACK-A

        RST     28H             ;; FP-CALC      rx, ty, coords_y
        DEFB    $03             ;;subtract      rx, ry.
        DEFB    $38             ;;end-calc      rx, ry.

;   Finally draw the last straight line.

;; LINE-DRAW
L2477:  CALL    L24B7           ; routine DRAW-LINE draws to the relative 
                                ; coordinates (rx, ry).

        JP      L0D4D           ; jump back and exit via TEMPS          >>>


; --------------------------------------------
; THE 'INITIAL CIRCLE/DRAW PARAMETERS' ROUTINE
; --------------------------------------------
;   Begin by calculating the number of chords which will be returned in B.
;   A rule of thumb is employed that uses a value z which for a circle is the
;   radius and for an arc is the diameter with, as it happens, a pinch more if 
;   the arc is on a slope.
;
;   NUMBER OF STRAIGHT LINES = ANGLE OF ROTATION * SQUARE ROOT ( Z ) / 2

;; CD-PRMS1
L247D:  RST     28H             ;; FP-CALC      z.
        DEFB    $31             ;;duplicate     z, z.
        DEFB    $28             ;;sqr           z, sqr(z).
        DEFB    $34             ;;stk-data      z, sqr(z), 2.
        DEFB    $32             ;;Exponent: $82, Bytes: 1
        DEFB    $00             ;;(+00,+00,+00)
        DEFB    $01             ;;exchange      z, 2, sqr(z).
        DEFB    $05             ;;division      z, 2/sqr(z).
        DEFB    $E5             ;;get-mem-5     z, 2/sqr(z), ANGLE.
        DEFB    $01             ;;exchange      z, ANGLE, 2/sqr (z)
        DEFB    $05             ;;division      z, ANGLE*sqr(z)/2 (= No. of lines)
        DEFB    $2A             ;;abs           (for arc only)
        DEFB    $38             ;;end-calc      z, number of lines.

;    As an example for a circle of radius 87 the number of lines will be 29.

        CALL    L2DD5           ; routine FP-TO-A

;    The value is compressed into A register, no carry with valid circle.

        JR      C,L2495         ; forward, if over 256, to USE-252

;    now make a multiple of 4 e.g. 29 becomes 28

        AND     $FC             ; AND 252

;    Adding 4 could set carry for arc, for the circle example, 28 becomes 32.

        ADD     A,$04           ; adding 4 could set carry if result is 256.
        
        JR      NC,L2497        ; forward if less than 256 to DRAW-SAVE

;    For an arc, a limit of 252 is imposed.

;; USE-252
L2495:  LD      A,$FC           ; Use a value of 252 (for arc).


;   For both arcs and circles, constants derived from the central angle are
;   stored in the 'mem' locations.  Some are not relevant for the circle.

;; DRAW-SAVE
L2497:  PUSH    AF              ; Save the line count (A) on the machine stack.

        CALL    L2D28           ; Routine STACK-A stacks the modified count(A).

        RST     28H             ;; FP-CALC      z, A.
        DEFB    $E5             ;;get-mem-5     z, A, ANGLE.
        DEFB    $01             ;;exchange      z, ANGLE, A.
        DEFB    $05             ;;division      z, ANGLE/A. (Angle/count = a)
        DEFB    $31             ;;duplicate     z, a, a. 

;  Note. that cos (a) could be formed here directly using 'cos' and stored in 
;  mem-3 but that would spoil a good story and be slightly slower, as also 
;  would using square roots to form cos (a) from sin (a).

        DEFB    $1F             ;;sin           z, a, sin(a)
        DEFB    $C4             ;;st-mem-4      z, a, sin(a)
        DEFB    $02             ;;delete        z, a.
        DEFB    $31             ;;duplicate     z, a, a.            
        DEFB    $A2             ;;stk-half      z, a, a, 1/2.
        DEFB    $04             ;;multiply      z, a, a/2.
        DEFB    $1F             ;;sin           z, a, sin(a/2).

;   Note. after second sin, mem-0 and mem-1 become free.

        DEFB    $C1             ;;st-mem-1      z, a, sin(a/2).
        DEFB    $01             ;;exchange      z, sin(a/2), a.
        DEFB    $C0             ;;st-mem-0      z, sin(a/2), a.  (for arc only)

;   Now form cos(a) from sin(a/2) using the 'DOUBLE ANGLE FORMULA'.

        DEFB    $02             ;;delete        z, sin(a/2).
        DEFB    $31             ;;duplicate     z, sin(a/2), sin(a/2).
        DEFB    $04             ;;multiply      z, sin(a/2)*sin(a/2).
        DEFB    $31             ;;duplicate     z, sin(a/2)*sin(a/2),
                                ;;                           sin(a/2)*sin(a/2).
        DEFB    $0F             ;;addition      z, 2*sin(a/2)*sin(a/2).
        DEFB    $A1             ;;stk-one       z, 2*sin(a/2)*sin(a/2), 1.
        DEFB    $03             ;;subtract      z, 2*sin(a/2)*sin(a/2)-1.

        DEFB    $1B             ;;negate        z, 1-2*sin(a/2)*sin(a/2).  

        DEFB    $C3             ;;st-mem-3      z, cos(a).
        DEFB    $02             ;;delete        z.
        DEFB    $38             ;;end-calc      z.

;   The radius/diameter is left on the calculator stack.

        POP     BC              ; Restore the line count to the B register.

        RET                     ; Return.

; --------------------------
; THE 'DOUBLE ANGLE FORMULA'
; --------------------------
;   This formula forms cos(a) from sin(a/2) using simple arithmetic.
;
;   THE GEOMETRIC PROOF OF FORMULA   cos (a) = 1 - 2 * sin(a/2) * sin(a/2)
;                                                                    
;                                                                   
;                                            A                     
;                                                                 
;                                         . /|\                      
;                                     .    / | \                     
;                                  .      /  |  \                    
;                               .        /   |a/2\                   
;                            .          /    |    \                  
;                         .          1 /     |     \                 
;                      .              /      |      \                
;                   .                /       |       \               
;                .                  /        |        \              
;             .  a/2             D / a      E|-+       \             
;          B ---------------------/----------+-+--------\ C
;            <-         1       -><-       1           ->           
;
;   cos a = 1 - 2 * sin(a/2) * sin(a/2)
;
;   The figure shows a right triangle that inscribes a circle of radius 1 with
;   centre, or origin, D.  Line BC is the diameter of length 2 and A is a point 
;   on the circle. The periphery angle BAC is therefore a right angle by the 
;   Rule of Thales.
;   Line AC is a chord touching two points on the circle and the angle at the 
;   centre is (a).
;   Since the vertex of the largest triangle B touches the circle, the 
;   inscribed angle (a/2) is half the central angle (a).
;   The cosine of (a) is the length DE as the hypotenuse is of length 1.
;   This can also be expressed as 1-length CE.  Examining the triangle at the
;   right, the top angle is also (a/2) as angle BAE and EBA add to give a right
;   angle as do BAE and EAC.
;   So cos (a) = 1 - AC * sin(a/2) 
;   Looking at the largest triangle, side AC can be expressed as 
;   AC = 2 * sin(a/2)   and so combining these we get 
;   cos (a) = 1 - 2 * sin(a/2) * sin(a/2).
;
;   "I will be sufficiently rewarded if when telling it to others, you will 
;    not claim the discovery as your own, but will say it is mine."
;   - Thales, 640 - 546 B.C.
;
; --------------------------
; THE 'LINE DRAWING' ROUTINE
; --------------------------
;
;

;; DRAW-LINE
L24B7:  CALL    L2307           ; routine STK-TO-BC
        LD      A,C             ;
        CP      B               ;
        JR      NC,L24C4        ; to DL-X-GE-Y

        LD      L,C             ;
        PUSH    DE              ;
        XOR     A               ;
        LD      E,A             ;
        JR      L24CB           ; to DL-LARGER

; ---

;; DL-X-GE-Y
L24C4:  OR      C               ;
        RET     Z               ;

        LD      L,B             ;
        LD      B,C             ;
        PUSH    DE              ;
        LD      D,$00           ;

;; DL-LARGER
L24CB:  LD      H,B             ;
        LD      A,B             ;
        RRA                     ;

;; D-L-LOOP
L24CE:  ADD     A,L             ;
        JR      C,L24D4         ; to D-L-DIAG

        CP      H               ;
        JR      C,L24DB         ; to D-L-HR-VT

;; D-L-DIAG
L24D4:  SUB     H               ;
        LD      C,A             ;
        EXX                     ;
        POP     BC              ;
        PUSH    BC              ;
        JR      L24DF           ; to D-L-STEP

; ---

;; D-L-HR-VT
L24DB:  LD      C,A             ;
        PUSH    DE              ;
        EXX                     ;
        POP     BC              ;

;; D-L-STEP
L24DF:  LD      HL,($5C7D)      ; COORDS
        LD      A,B             ;
        ADD     A,H             ;
        LD      B,A             ;
        LD      A,C             ;
        INC     A               ;
        ADD     A,L             ;
        JR      C,L24F7         ; to D-L-RANGE

        JR      Z,L24F9         ; to REPORT-Bc

;; D-L-PLOT
L24EC:  DEC     A               ;
        LD      C,A             ;
        CALL    L22E5           ; routine PLOT-SUB
        EXX                     ;
        LD      A,C             ;
        DJNZ    L24CE           ; to D-L-LOOP

        POP     DE              ;
        RET                     ;

; ---

;; D-L-RANGE
L24F7:  JR      Z,L24EC         ; to D-L-PLOT


;; REPORT-Bc
L24F9:  RST     08H             ; ERROR-1
        DEFB    $0A             ; Error Report: Integer out of range
