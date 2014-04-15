;**************************************************
;** Part 5. SCREEN AND PRINTER HANDLING ROUTINES **
;**************************************************

        PUBLIC L09F4
        PUBLIC L0BDB
        PUBLIC L0C0A
        PUBLIC L0D4D
        PUBLIC L0D6B
        PUBLIC L0D6E
        PUBLIC L0DAF
        PUBLIC L0DD9
        PUBLIC L0E44
        PUBLIC L0EAC
        PUBLIC L0ECD
        PUBLIC L0EDF
        PUBLIC L0F2C
        PUBLIC L0F81
        PUBLIC L1097
        PUBLIC L10A8
        PUBLIC L111D
        PUBLIC L11A7

        EXTERN L0095
        EXTERN L03B5
        EXTERN L15D4
        EXTERN L1601
        EXTERN L1615
        EXTERN L1652
        EXTERN L1655
        EXTERN L1695
        EXTERN L1795
        EXTERN L1855
        EXTERN L187D
        EXTERN L18E1
        EXTERN L190F
        EXTERN L191C
        EXTERN L196E
        EXTERN L19E5
        EXTERN L19E8
        EXTERN L1E9F
        EXTERN L1F05
        EXTERN L1F54
        EXTERN L2211

; --------------------------
; THE 'PRINT OUTPUT' ROUTINE
; --------------------------
;   This is the routine most often used by the RST 10 restart although the
;   subroutine is on two occasions called directly when it is known that
;   output will definitely be to the lower screen.

;; PRINT-OUT
L09F4:  CALL    L0B03           ; routine PO-FETCH fetches print position
                                ; to HL register pair.
        CP      $20             ; is character a space or higher ?
        JP      NC,L0AD9        ; jump forward to PO-ABLE if so.

        CP      $06             ; is character in range 00-05 ?
        JR      C,L0A69         ; to PO-QUEST to print '?' if so.

        CP      $18             ; is character in range 24d - 31d ?
        JR      NC,L0A69        ; to PO-QUEST to also print '?' if so.

        LD      HL,L0A11 - 6    ; address 0A0B - the base address of control
                                ; character table - where zero would be.
        LD      E,A             ; control character 06 - 23d
        LD      D,$00           ; is transferred to DE.

        ADD     HL,DE           ; index into table.

        LD      E,(HL)          ; fetch the offset to routine.
        ADD     HL,DE           ; add to make HL the address.
        PUSH    HL              ; push the address.

        JP      L0B03           ; Jump forward to PO-FETCH, 
                                ; as the screen/printer position has been 
                                ; disturbed, and then indirectly to the PO-STORE
                                ; routine on stack.

; -----------------------------
; THE 'CONTROL CHARACTER' TABLE
; -----------------------------
;   For control characters in the range 6 - 23d the following table
;   is indexed to provide an offset to the handling routine that
;   follows the table.

;; ctlchrtab
L0A11:  DEFB    L0A5F - ASMPC       ; 06d offset $4E to Address: PO-COMMA
        DEFB    L0A69 - ASMPC       ; 07d offset $57 to Address: PO-QUEST
        DEFB    L0A23 - ASMPC       ; 08d offset $10 to Address: PO-BACK-1
        DEFB    L0A3D - ASMPC       ; 09d offset $29 to Address: PO-RIGHT
        DEFB    L0A69 - ASMPC       ; 10d offset $54 to Address: PO-QUEST
        DEFB    L0A69 - ASMPC       ; 11d offset $53 to Address: PO-QUEST
        DEFB    L0A69 - ASMPC       ; 12d offset $52 to Address: PO-QUEST
        DEFB    L0A4F - ASMPC       ; 13d offset $37 to Address: PO-ENTER
        DEFB    L0A69 - ASMPC       ; 14d offset $50 to Address: PO-QUEST
        DEFB    L0A69 - ASMPC       ; 15d offset $4F to Address: PO-QUEST
        DEFB    L0A7A - ASMPC       ; 16d offset $5F to Address: PO-1-OPER
        DEFB    L0A7A - ASMPC       ; 17d offset $5E to Address: PO-1-OPER
        DEFB    L0A7A - ASMPC       ; 18d offset $5D to Address: PO-1-OPER
        DEFB    L0A7A - ASMPC       ; 19d offset $5C to Address: PO-1-OPER
        DEFB    L0A7A - ASMPC       ; 20d offset $5B to Address: PO-1-OPER
        DEFB    L0A7A - ASMPC       ; 21d offset $5A to Address: PO-1-OPER
        DEFB    L0A75 - ASMPC       ; 22d offset $54 to Address: PO-2-OPER
        DEFB    L0A75 - ASMPC       ; 23d offset $53 to Address: PO-2-OPER


; -------------------------
; THE 'CURSOR LEFT' ROUTINE
; -------------------------
;   Backspace and up a line if that action is from the left of screen.
;   For ZX printer backspace up to first column but not beyond.

;; PO-BACK-1
L0A23:  INC     C               ; move left one column.
        LD      A,$22           ; value $21 is leftmost column.
        CP      C               ; have we passed ?
        JR      NZ,L0A3A        ; to PO-BACK-3 if not and store new position.

        BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        JR      NZ,L0A38        ; to PO-BACK-2 if so, as we are unable to
                                ; backspace from the leftmost position.


        INC     B               ; move up one screen line
        LD      C,$02           ; the rightmost column position.
        LD      A,$18           ; Note. This should be $19
                                ; credit. Dr. Frank O'Hara, 1982

        CP      B               ; has position moved past top of screen ?
        JR      NZ,L0A3A        ; to PO-BACK-3 if not and store new position.

        DEC     B               ; else back to $18.

;; PO-BACK-2
L0A38:  LD      C,$21           ; the leftmost column position.

;; PO-BACK-3
L0A3A:  JP      L0DD9           ; to CL-SET and PO-STORE to save new
                                ; position in system variables.

; --------------------------
; THE 'CURSOR RIGHT' ROUTINE
; --------------------------
;   This moves the print position to the right leaving a trail in the
;   current background colour.
;   "However the programmer has failed to store the new print position
;   so CHR$ 9 will only work if the next print position is at a newly
;   defined place.
;   e.g. PRINT PAPER 2; CHR$ 9; AT 4,0;
;   does work but is not very helpful"
;   - Dr. Ian Logan, Understanding Your Spectrum, 1982.

;; PO-RIGHT
L0A3D:  LD      A,($5C91)       ; fetch P_FLAG value
        PUSH    AF              ; and save it on stack.

        LD      (IY+$57),$01    ; temporarily set P_FLAG 'OVER 1'.
        LD      A,$20           ; prepare a space.
        CALL    L0B65           ; routine PO-CHAR to print it.
                                ; Note. could be PO-ABLE which would update
                                ; the column position.

        POP     AF              ; restore the permanent flag.
        LD      ($5C91),A       ; and restore system variable P_FLAG

        RET                     ; return without updating column position

; -----------------------
; Perform carriage return
; -----------------------
; A carriage return is 'printed' to screen or printer buffer.

;; PO-ENTER
L0A4F:  BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        JP      NZ,L0ECD        ; to COPY-BUFF if so, to flush buffer and reset
                                ; the print position.

        LD      C,$21           ; the leftmost column position.
        CALL    L0C55           ; routine PO-SCR handles any scrolling required.
        DEC     B               ; to next screen line.
        JP      L0DD9           ; jump forward to CL-SET to store new position.

; -----------
; Print comma
; -----------
; The comma control character. The 32 column screen has two 16 character
; tabstops.  The routine is only reached via the control character table.

;; PO-COMMA
L0A5F:  CALL    L0B03           ; routine PO-FETCH - seems unnecessary.

        LD      A,C             ; the column position. $21-$01
        DEC     A               ; move right. $20-$00
        DEC     A               ; and again   $1F-$00 or $FF if trailing
        AND     $10             ; will be $00 or $10.
        JR      L0AC3           ; forward to PO-FILL

; -------------------
; Print question mark
; -------------------
; This routine prints a question mark which is commonly
; used to print an unassigned control character in range 0-31d.
; there are a surprising number yet to be assigned.

;; PO-QUEST
L0A69:  LD      A,$3F           ; prepare the character '?'.
        JR      L0AD9           ; forward to PO-ABLE.

; --------------------------------
; Control characters with operands
; --------------------------------
; Certain control characters are followed by 1 or 2 operands.
; The entry points from control character table are PO-2-OPER and PO-1-OPER.
; The routines alter the output address of the current channel so that
; subsequent RST $10 instructions take the appropriate action
; before finally resetting the output address back to PRINT-OUT.

;; PO-TV-2
L0A6D:  LD      DE,L0A87        ; address: PO-CONT will be next output routine
        LD      ($5C0F),A       ; store first operand in TVDATA-hi
        JR      L0A80           ; forward to PO-CHANGE >>

; ---

; -> This initial entry point deals with two operands - AT or TAB.

;; PO-2-OPER
L0A75:  LD      DE,L0A6D        ; address: PO-TV-2 will be next output routine
        JR      L0A7D           ; forward to PO-TV-1

; ---

; -> This initial entry point deals with one operand INK to OVER.

;; PO-1-OPER
L0A7A:  LD      DE,L0A87        ; address: PO-CONT will be next output routine

;; PO-TV-1
L0A7D:  LD      ($5C0E),A       ; store control code in TVDATA-lo

;; PO-CHANGE
L0A80:  LD      HL,($5C51)      ; use CURCHL to find current output channel.
        LD      (HL),E          ; make it
        INC     HL              ; the supplied
        LD      (HL),D          ; address from DE.
        RET                     ; return.

; ---

;; PO-CONT
L0A87:  LD      DE,L09F4        ; Address: PRINT-OUT
        CALL    L0A80           ; routine PO-CHANGE to restore normal channel.
        LD      HL,($5C0E)      ; TVDATA gives control code and possible
                                ; subsequent character
        LD      D,A             ; save current character
        LD      A,L             ; the stored control code
        CP      $16             ; was it INK to OVER (1 operand) ?
        JP      C,L2211         ; to CO-TEMP-5

        JR      NZ,L0AC2        ; to PO-TAB if not 22d i.e. 23d TAB.

                                ; else must have been 22d AT.
        LD      B,H             ; line to H   (0-23d)
        LD      C,D             ; column to C (0-31d)
        LD      A,$1F           ; the value 31d
        SUB     C               ; reverse the column number.
        JR      C,L0AAC         ; to PO-AT-ERR if C was greater than 31d.

        ADD     A,$02           ; transform to system range $02-$21
        LD      C,A             ; and place in column register.

        BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        JR      NZ,L0ABF        ; to PO-AT-SET as line can be ignored.

        LD      A,$16           ; 22 decimal
        SUB     B               ; subtract line number to reverse
                                ; 0 - 22 becomes 22 - 0.

;; PO-AT-ERR
L0AAC:  JP      C,L1E9F         ; to REPORT-B if higher than 22 decimal
                                ; Integer out of range.

        INC     A               ; adjust for system range $01-$17
        LD      B,A             ; place in line register
        INC     B               ; adjust to system range  $02-$18
        BIT     0,(IY+$02)      ; TV_FLAG  - Lower screen in use ?
        JP      NZ,L0C55        ; exit to PO-SCR to test for scrolling

        CP      (IY+$31)        ; Compare against DF_SZ
        JP      C,L0C86         ; to REPORT-5 if too low
                                ; Out of screen.

;; PO-AT-SET
L0ABF:  JP      L0DD9           ; print position is valid so exit via CL-SET

; ---

; Continue here when dealing with TAB.
; Note. In BASIC, TAB is followed by a 16-bit number and was initially
; designed to work with any output device.

;; PO-TAB
L0AC2:  LD      A,H             ; transfer parameter to A
                                ; Losing current character -
                                ; High byte of TAB parameter.


;; PO-FILL
L0AC3:  CALL    L0B03           ; routine PO-FETCH, HL-addr, BC=line/column.
                                ; column 1 (right), $21 (left)
        ADD     A,C             ; add operand to current column
        DEC     A               ; range 0 - 31+
        AND     $1F             ; make range 0 - 31d
        RET     Z               ; return if result zero

        LD      D,A             ; Counter to D
        SET     0,(IY+$01)      ; update FLAGS  - signal suppress leading space.

;; PO-SPACE
L0AD0:  LD      A,$20           ; space character.

        CALL    L0C3B           ; routine PO-SAVE prints the character
                                ; using alternate set (normal output routine)

        DEC     D               ; decrement counter.
        JR      NZ,L0AD0        ; to PO-SPACE until done

        RET                     ; return

; ----------------------
; Printable character(s)
; ----------------------
; This routine prints printable characters and continues into
; the position store routine

;; PO-ABLE
L0AD9:  CALL    L0B24           ; routine PO-ANY
                                ; and continue into position store routine.

; ----------------------------
; THE 'POSITION STORE' ROUTINE
; ----------------------------
;   This routine updates the system variables associated with the main screen, 
;   the lower screen/input buffer or the ZX printer.

;; PO-STORE
L0ADC:  BIT     1,(IY+$01)      ; Test FLAGS - is printer in use ?
        JR      NZ,L0AFC        ; Forward, if so, to PO-ST-PR

        BIT     0,(IY+$02)      ; Test TV_FLAG - is lower screen in use ?
        JR      NZ,L0AF0        ; Forward, if so, to PO-ST-E

;   This section deals with the upper screen.

        LD      ($5C88),BC      ; Update S_POSN - line/column upper screen
        LD      ($5C84),HL      ; Update DF_CC - upper display file address

        RET                     ; Return.

; ---

;   This section deals with the lower screen.

;; PO-ST-E
L0AF0:  LD      ($5C8A),BC      ; Update SPOSNL line/column lower screen
        LD      ($5C82),BC      ; Update ECHO_E line/column input buffer
        LD      ($5C86),HL      ; Update DFCCL  lower screen memory address
        RET                     ; Return.

; ---

;   This section deals with the ZX Printer.

;; PO-ST-PR
L0AFC:  LD      (IY+$45),C      ; Update P_POSN column position printer
        LD      ($5C80),HL      ; Update PR_CC - full printer buffer memory 
                                ; address
        RET                     ; Return.

;   Note. that any values stored in location 23681 will be overwritten with 
;   the value 91 decimal. 
;   Credit April 1983, Dilwyn Jones. "Delving Deeper into your ZX Spectrum".

; ----------------------------
; THE 'POSITION FETCH' ROUTINE
; ----------------------------
;   This routine fetches the line/column and display file address of the upper 
;   and lower screen or, if the printer is in use, the column position and 
;   absolute memory address.
;   Note. that PR-CC-hi (23681) is used by this routine and if, in accordance 
;   with the manual (that says this is unused), the location has been used for 
;   other purposes, then subsequent output to the printer buffer could corrupt 
;   a 256-byte section of memory.

;; PO-FETCH
L0B03:  BIT     1,(IY+$01)      ; Test FLAGS - is printer in use ?
        JR      NZ,L0B1D        ; Forward, if so, to PO-F-PR

;   assume upper screen in use and thus optimize for path that requires speed.

        LD      BC,($5C88)      ; Fetch line/column from S_POSN
        LD      HL,($5C84)      ; Fetch DF_CC display file address

        BIT     0,(IY+$02)      ; Test TV_FLAG - lower screen in use ?
        RET     Z               ; Return if upper screen in use.

;   Overwrite registers with values for lower screen.

        LD      BC,($5C8A)      ; Fetch line/column from SPOSNL
        LD      HL,($5C86)      ; Fetch display file address from DFCCL
        RET                     ; Return.

; ---

;   This section deals with the ZX Printer.

;; PO-F-PR
L0B1D:  LD      C,(IY+$45)      ; Fetch column from P_POSN.
        LD      HL,($5C80)      ; Fetch printer buffer address from PR_CC.
        RET                     ; Return.

; ---------------------------------
; THE 'PRINT ANY CHARACTER' ROUTINE
; ---------------------------------
;   This routine is used to print any character in range 32d - 255d
;   It is only called from PO-ABLE which continues into PO-STORE

;; PO-ANY
L0B24:  CP      $80             ; ASCII ?
        JR      C,L0B65         ; to PO-CHAR is so.

        CP      $90             ; test if a block graphic character.
        JR      NC,L0B52        ; to PO-T&UDG to print tokens and UDGs

; The 16 2*2 mosaic characters 128-143 decimal are formed from
; bits 0-3 of the character.

        LD      B,A             ; save character
        CALL    L0B38           ; routine PO-GR-1 to construct top half
                                ; then bottom half.
        CALL    L0B03           ; routine PO-FETCH fetches print position.
        LD      DE,$5C92        ; MEM-0 is location of 8 bytes of character
        JR      L0B7F           ; to PR-ALL to print to screen or printer

; ---

;; PO-GR-1
L0B38:  LD      HL,$5C92        ; address MEM-0 - a temporary buffer in
                                ; systems variables which is normally used
                                ; by the calculator.
        CALL    L0B3E           ; routine PO-GR-2 to construct top half
                                ; and continue into routine to construct
                                ; bottom half.

;; PO-GR-2
L0B3E:  RR      B               ; rotate bit 0/2 to carry
        SBC     A,A             ; result $00 or $FF
        AND     $0F             ; mask off right hand side
        LD      C,A             ; store part in C
        RR      B               ; rotate bit 1/3 of original chr to carry
        SBC     A,A             ; result $00 or $FF
        AND     $F0             ; mask off left hand side
        OR      C               ; combine with stored pattern
        LD      C,$04           ; four bytes for top/bottom half

;; PO-GR-3
L0B4C:  LD      (HL),A          ; store bit patterns in temporary buffer
        INC     HL              ; next address
        DEC     C               ; jump back to
        JR      NZ,L0B4C        ; to PO-GR-3 until byte is stored 4 times

        RET                     ; return

; ---

; Tokens and User defined graphics are now separated.

;; PO-T&UDG
L0B52:  SUB     $A5             ; the 'RND' character
        JR      NC,L0B5F        ; to PO-T to print tokens

        ADD     A,$15           ; add 21d to restore to 0 - 20
        PUSH    BC              ; save current print position
        LD      BC,($5C7B)      ; fetch UDG to address bit patterns
        JR      L0B6A           ; to PO-CHAR-2 - common code to lay down
                                ; a bit patterned character

; ---

;; PO-T
L0B5F:  CALL    L0C10           ; routine PO-TOKENS prints tokens
        JP      L0B03           ; exit via a JUMP to PO-FETCH as this routine 
                                ; must continue into PO-STORE. 
                                ; A JR instruction could be used.

; This point is used to print ASCII characters  32d - 127d.

;; PO-CHAR
L0B65:  PUSH    BC              ; save print position
        LD      BC,($5C36)      ; address CHARS

; This common code is used to transfer the character bytes to memory.

;; PO-CHAR-2
L0B6A:  EX      DE,HL           ; transfer destination address to DE
        LD      HL,$5C3B        ; point to FLAGS
        RES     0,(HL)          ; allow for leading space
        CP      $20             ; is it a space ?
        JR      NZ,L0B76        ; to PO-CHAR-3 if not

        SET     0,(HL)          ; signal no leading space to FLAGS

;; PO-CHAR-3
L0B76:  LD      H,$00           ; set high byte to 0
        LD      L,A             ; character to A
                                ; 0-21 UDG or 32-127 ASCII.
        ADD     HL,HL           ; multiply
        ADD     HL,HL           ; by
        ADD     HL,HL           ; eight
        ADD     HL,BC           ; HL now points to first byte of character
        POP     BC              ; the source address CHARS or UDG
        EX      DE,HL           ; character address to DE

; ----------------------------------
; THE 'PRINT ALL CHARACTERS' ROUTINE
; ----------------------------------
;   This entry point entered from above to print ASCII and UDGs but also from 
;   earlier to print mosaic characters.
;   HL=destination
;   DE=character source
;   BC=line/column

;; PR-ALL
L0B7F:  LD      A,C             ; column to A
        DEC     A               ; move right
        LD      A,$21           ; pre-load with leftmost position
        JR      NZ,L0B93        ; but if not zero to PR-ALL-1

        DEC     B               ; down one line
        LD      C,A             ; load C with $21
        BIT     1,(IY+$01)      ; test FLAGS  - Is printer in use
        JR      Z,L0B93         ; to PR-ALL-1 if not

        PUSH    DE              ; save source address
        CALL    L0ECD           ; routine COPY-BUFF outputs line to printer
        POP     DE              ; restore character source address
        LD      A,C             ; the new column number ($21) to C

;; PR-ALL-1
L0B93:  CP      C               ; this test is really for screen - new line ?
        PUSH    DE              ; save source

        CALL    Z,L0C55         ; routine PO-SCR considers scrolling

        POP     DE              ; restore source
        PUSH    BC              ; save line/column
        PUSH    HL              ; and destination
        LD      A,($5C91)       ; fetch P_FLAG to accumulator
        LD      B,$FF           ; prepare OVER mask in B.
        RRA                     ; bit 0 set if OVER 1
        JR      C,L0BA4         ; to PR-ALL-2

        INC     B               ; set OVER mask to 0

;; PR-ALL-2
L0BA4:  RRA                     ; skip bit 1 of P_FLAG
        RRA                     ; bit 2 is INVERSE
        SBC     A,A             ; will be FF for INVERSE 1 else zero
        LD      C,A             ; transfer INVERSE mask to C
        LD      A,$08           ; prepare to count 8 bytes
        AND     A               ; clear carry to signal screen
        BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        JR      Z,L0BB6         ; to PR-ALL-3 if screen

        SET     1,(IY+$30)      ; update FLAGS2  - signal printer buffer has 
                                ; been used.
        SCF                     ; set carry flag to signal printer.

;; PR-ALL-3
L0BB6:  EX      DE,HL           ; now HL=source, DE=destination

;; PR-ALL-4
L0BB7:  EX      AF,AF'          ; save printer/screen flag
        LD      A,(DE)          ; fetch existing destination byte
        AND     B               ; consider OVER
        XOR     (HL)            ; now XOR with source
        XOR     C               ; now with INVERSE MASK
        LD      (DE),A          ; update screen/printer
        EX      AF,AF'          ; restore flag
        JR      C,L0BD3         ; to PR-ALL-6 - printer address update

        INC     D               ; gives next pixel line down screen

;; PR-ALL-5
L0BC1:  INC     HL              ; address next character byte
        DEC     A               ; the byte count is decremented
        JR      NZ,L0BB7        ; back to PR-ALL-4 for all 8 bytes

        EX      DE,HL           ; destination to HL
        DEC     H               ; bring back to last updated screen position
        BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        CALL    Z,L0BDB         ; if not, call routine PO-ATTR to update
                                ; corresponding colour attribute.
        POP     HL              ; restore original screen/printer position
        POP     BC              ; and line column
        DEC     C               ; move column to right
        INC     HL              ; increase screen/printer position
        RET                     ; return and continue into PO-STORE
                                ; within PO-ABLE

; ---

;   This branch is used to update the printer position by 32 places
;   Note. The high byte of the address D remains constant (which it should).

;; PR-ALL-6
L0BD3:  EX      AF,AF'          ; save the flag
        LD      A,$20           ; load A with 32 decimal
        ADD     A,E             ; add this to E
        LD      E,A             ; and store result in E
        EX      AF,AF'          ; fetch the flag
        JR      L0BC1           ; back to PR-ALL-5

; -----------------------------------
; THE 'GET ATTRIBUTE ADDRESS' ROUTINE
; -----------------------------------
;   This routine is entered with the HL register holding the last screen
;   address to be updated by PRINT or PLOT.
;   The Spectrum screen arrangement leads to the L register holding the correct
;   value for the attribute file and it is only necessary to manipulate H to 
;   form the correct colour attribute address.

;; PO-ATTR
L0BDB:  LD       A,H            ; fetch high byte $40 - $57
        RRCA                    ; shift
        RRCA                    ; bits 3 and 4
        RRCA                    ; to right.
        AND     $03             ; range is now 0 - 2
        OR      $58             ; form correct high byte for third of screen
        LD      H,A             ; HL is now correct
        LD      DE,($5C8F)      ; make D hold ATTR_T, E hold MASK-T
        LD      A,(HL)          ; fetch existing attribute
        XOR     E               ; apply masks
        AND     D               ;
        XOR     E               ;
        BIT     6,(IY+$57)      ; test P_FLAG  - is this PAPER 9 ??
        JR      Z,L0BFA         ; skip to PO-ATTR-1 if not.

        AND     $C7             ; set paper
        BIT     2,A             ; to contrast with ink
        JR      NZ,L0BFA        ; skip to PO-ATTR-1

        XOR     $38             ;

;; PO-ATTR-1
L0BFA:  BIT     4,(IY+$57)      ; test P_FLAG  - Is this INK 9 ??
        JR      Z,L0C08         ; skip to PO-ATTR-2 if not

        AND     $F8             ; make ink
        BIT     5,A             ; contrast with paper.
        JR      NZ,L0C08        ; to PO-ATTR-2

        XOR     $07             ;

;; PO-ATTR-2
L0C08:  LD      (HL),A          ; save the new attribute.
        RET                     ; return.

; ---------------------------------
; THE 'MESSAGE PRINTING' SUBROUTINE
; ---------------------------------
;   This entry point is used to print tape, boot-up, scroll? and error messages.
;   On entry the DE register points to an initial step-over byte or the 
;   inverted end-marker of the previous entry in the table.
;   Register A contains the message number, often zero to print first message.
;   (HL has nothing important usually P_FLAG)

;; PO-MSG
L0C0A:  PUSH    HL              ; put hi-byte zero on stack to suppress
        LD      H,$00           ; trailing spaces
        EX      (SP),HL         ; ld h,0; push hl would have done ?.
        JR      L0C14           ; forward to PO-TABLE.

; ---

;   This entry point prints the BASIC keywords, '<>' etc. from alt set

;; PO-TOKENS
L0C10:  LD      DE,L0095        ; address: TKN-TABLE
        PUSH    AF              ; save the token number to control
                                ; trailing spaces - see later *

; ->

;; PO-TABLE
L0C14:  CALL    L0C41           ; routine PO-SEARCH will set carry for
                                ; all messages and function words.

        JR      C,L0C22         ; forward to PO-EACH if not a command, '<>' etc.

        LD      A,$20           ; prepare leading space
        BIT     0,(IY+$01)      ; test FLAGS  - leading space if not set

        CALL    Z,L0C3B         ; routine PO-SAVE to print a space without 
                                ; disturbing registers.

;; PO-EACH
L0C22:  LD      A,(DE)          ; Fetch character from the table.
        AND     $7F             ; Cancel any inverted bit.

        CALL    L0C3B           ; Routine PO-SAVE to print using the alternate
                                ; set of registers.

        LD      A,(DE)          ; Re-fetch character from table.
        INC     DE              ; Address next character in the table.

        ADD     A,A             ; Was character inverted ?
                                ; (this also doubles character)
        JR      NC,L0C22        ; back to PO-EACH if not.

        POP     DE              ; * re-fetch trailing space byte to D 

        CP      $48             ; was the last character '$' ?
        JR      Z,L0C35         ; forward to PO-TR-SP to consider trailing
                                ; space if so.

        CP      $82             ; was it < 'A' i.e. '#','>','=' from tokens
                                ; or ' ','.' (from tape) or '?' from scroll

        RET     C               ; Return if so as no trailing space required.

;; PO-TR-SP
L0C35:  LD      A,D             ; The trailing space flag (zero if an error msg)

        CP      $03             ; Test against RND, INKEY$ and PI which have no
                                ; parameters and therefore no trailing space.

        RET     C               ; Return if no trailing space.

        LD      A,$20           ; Prepare the space character and continue to
                                ; print and make an indirect return.

; -----------------------------------
; THE 'RECURSIVE PRINTING' SUBROUTINE
; -----------------------------------
;   This routine which is part of PRINT-OUT allows RST $10 to be used 
;   recursively to print tokens and the spaces associated with them.
;   It is called on three occasions when the value of DE must be preserved.

;; PO-SAVE
L0C3B:  PUSH    DE              ; Save DE value.
        EXX                     ; Switch in main set

        RST     10H             ; PRINT-A prints using this alternate set.

        EXX                     ; Switch back to this alternate set.
        POP     DE              ; Restore the initial DE value.

        RET                     ; Return.

; ------------
; Table search
; ------------
; This subroutine searches a message or the token table for the
; message number held in A. DE holds the address of the table.

;; PO-SEARCH
L0C41:  PUSH    AF              ; save the message/token number
        EX      DE,HL           ; transfer DE to HL
        INC     A               ; adjust for initial step-over byte

;; PO-STEP
L0C44:  BIT     7,(HL)          ; is character inverted ?
        INC     HL              ; address next
        JR      Z,L0C44         ; back to PO-STEP if not inverted.

        DEC     A               ; decrease counter
        JR      NZ,L0C44        ; back to PO-STEP if not zero

        EX      DE,HL           ; transfer address to DE
        POP     AF              ; restore message/token number
        CP      $20             ; return with carry set
        RET     C               ; for all messages and function tokens

        LD      A,(DE)          ; test first character of token
        SUB     $41             ; and return with carry set
        RET                     ; if it is less that 'A'
                                ; i.e. '<>', '<=', '>='

; ---------------
; Test for scroll
; ---------------
; This test routine is called when printing carriage return, when considering
; PRINT AT and from the general PRINT ALL characters routine to test if
; scrolling is required, prompting the user if necessary.
; This is therefore using the alternate set.
; The B register holds the current line.

;; PO-SCR
L0C55:  BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        RET     NZ              ; return immediately if so.

        LD      DE,L0DD9        ; set DE to address: CL-SET
        PUSH    DE              ; and push for return address.

        LD      A,B             ; transfer the line to A.
        BIT     0,(IY+$02)      ; test TV_FLAG - lower screen in use ?
        JP      NZ,L0D02        ; jump forward to PO-SCR-4 if so.

        CP      (IY+$31)        ; greater than DF_SZ display file size ?
        JR      C,L0C86         ; forward to REPORT-5 if less.
                                ; 'Out of screen'

        RET     NZ              ; return (via CL-SET) if greater

        BIT     4,(IY+$02)      ; test TV_FLAG  - Automatic listing ?
        JR      Z,L0C88         ; forward to PO-SCR-2 if not.

        LD      E,(IY+$2D)      ; fetch BREG - the count of scroll lines to E.
        DEC     E               ; decrease and jump
        JR      Z,L0CD2         ; to PO-SCR-3 if zero and scrolling required.

        LD      A,$00           ; explicit - select channel zero.
        CALL    L1601           ; routine CHAN-OPEN opens it.

        LD      SP,($5C3F)      ; set stack pointer to LIST_SP

        RES     4,(IY+$02)      ; reset TV_FLAG  - signal auto listing finished.
        RET                     ; return ignoring pushed value, CL-SET
                                ; to MAIN or EDITOR without updating
                                ; print position                         >>

; ---


;; REPORT-5
L0C86:  RST     08H             ; ERROR-1
        DEFB    $04             ; Error Report: Out of screen

; continue here if not an automatic listing.

;; PO-SCR-2
L0C88:  DEC     (IY+$52)        ; decrease SCR_CT
        JR      NZ,L0CD2        ; forward to PO-SCR-3 to scroll display if
                                ; result not zero.

; now produce prompt.

        LD      A,$18           ; reset
        SUB     B               ; the
        LD      ($5C8C),A       ; SCR_CT scroll count
        LD      HL,($5C8F)      ; L=ATTR_T, H=MASK_T
        PUSH    HL              ; save on stack
        LD      A,($5C91)       ; P_FLAG
        PUSH    AF              ; save on stack to prevent lower screen
                                ; attributes (BORDCR etc.) being applied.
        LD      A,$FD           ; select system channel 'K'
        CALL    L1601           ; routine CHAN-OPEN opens it
        XOR     A               ; clear to address message directly
        LD      DE,L0CF8        ; make DE address: scrl-mssg
        CALL    L0C0A           ; routine PO-MSG prints to lower screen
        SET     5,(IY+$02)      ; set TV_FLAG  - signal lower screen requires
                                ; clearing
        LD      HL,$5C3B        ; make HL address FLAGS
        SET     3,(HL)          ; signal 'L' mode.
        RES     5,(HL)          ; signal 'no new key'.
        EXX                     ; switch to main set.
                                ; as calling chr input from alternative set.
        CALL    L15D4           ; routine WAIT-KEY waits for new key
                                ; Note. this is the right routine but the
                                ; stream in use is unsatisfactory. From the
                                ; choices available, it is however the best.

        EXX                     ; switch back to alternate set.
        CP      $20             ; space is considered as BREAK
        JR      Z,L0D00         ; forward to REPORT-D if so
                                ; 'BREAK - CONT repeats'

        CP      $E2             ; is character 'STOP' ?
        JR      Z,L0D00         ; forward to REPORT-D if so

        OR      $20             ; convert to lower-case
        CP      $6E             ; is character 'n' ?
        JR      Z,L0D00         ; forward to REPORT-D if so else scroll.

        LD      A,$FE           ; select system channel 'S'
        CALL    L1601           ; routine CHAN-OPEN
        POP     AF              ; restore original P_FLAG
        LD      ($5C91),A       ; and save in P_FLAG.
        POP     HL              ; restore original ATTR_T, MASK_T
        LD      ($5C8F),HL      ; and reset ATTR_T, MASK-T as 'scroll?' has
                                ; been printed.

;; PO-SCR-3
L0CD2:  CALL    L0DFE           ; routine CL-SC-ALL to scroll whole display
        LD      B,(IY+$31)      ; fetch DF_SZ to B
        INC     B               ; increase to address last line of display
        LD      C,$21           ; set C to $21 (was $21 from above routine)
        PUSH    BC              ; save the line and column in BC.

        CALL    L0E9B           ; routine CL-ADDR finds display address.

        LD      A,H             ; now find the corresponding attribute byte
        RRCA                    ; (this code sequence is used twice
        RRCA                    ; elsewhere and is a candidate for
        RRCA                    ; a subroutine.)
        AND     $03             ;
        OR      $58             ;
        LD      H,A             ;

        LD      DE,$5AE0        ; start of last 'line' of attribute area
        LD      A,(DE)          ; get attribute for last line
        LD      C,(HL)          ; transfer to base line of upper part
        LD      B,$20           ; there are thirty two bytes
        EX      DE,HL           ; swap the pointers.

;; PO-SCR-3A
L0CF0:  LD      (DE),A          ; transfer
        LD      (HL),C          ; attributes.
        INC     DE              ; address next.
        INC     HL              ; address next.
        DJNZ    L0CF0           ; loop back to PO-SCR-3A for all adjacent
                                ; attribute lines.

        POP     BC              ; restore the line/column.
        RET                     ; return via CL-SET (was pushed on stack).

; ---

; The message 'scroll?' appears here with last byte inverted.

;; scrl-mssg
L0CF8:  DEFB    $80             ; initial step-over byte.
        DEFM    "scroll"
        DEFB    '?'+$80

;; REPORT-D
L0D00:  RST     08H             ; ERROR-1
        DEFB    $0C             ; Error Report: BREAK - CONT repeats

; continue here if using lower display - A holds line number.

;; PO-SCR-4
L0D02:  CP      $02             ; is line number less than 2 ?
        JR      C,L0C86         ; to REPORT-5 if so
                                ; 'Out of Screen'.

        ADD     A,(IY+$31)      ; add DF_SZ
        SUB     $19             ;
        RET     NC              ; return if scrolling unnecessary

        NEG                     ; Negate to give number of scrolls required.
        PUSH    BC              ; save line/column
        LD      B,A             ; count to B
        LD      HL,($5C8F)      ; fetch current ATTR_T, MASK_T to HL.
        PUSH    HL              ; and save
        LD      HL,($5C91)      ; fetch P_FLAG
        PUSH    HL              ; and save.
                                ; to prevent corruption by input AT

        CALL    L0D4D           ; routine TEMPS sets to BORDCR etc
        LD      A,B             ; transfer scroll number to A.

;; PO-SCR-4A
L0D1C:  PUSH    AF              ; save scroll number.
        LD      HL,$5C6B        ; address DF_SZ
        LD      B,(HL)          ; fetch old value
        LD      A,B             ; transfer to A
        INC     A               ; and increment
        LD      (HL),A          ; then put back.
        LD      HL,$5C89        ; address S_POSN_hi - line
        CP      (HL)            ; compare
        JR      C,L0D2D         ; forward to PO-SCR-4B if scrolling required

        INC     (HL)            ; else increment S_POSN_hi
        LD      B,$18           ; set count to whole display ??
                                ; Note. should be $17 and the top line will be 
                                ; scrolled into the ROM which is harmless on 
                                ; the standard set up.
                                ; credit P.Giblin 1984.

;; PO-SCR-4B
L0D2D:  CALL    L0E00           ; routine CL-SCROLL scrolls B lines
        POP     AF              ; restore scroll counter.
        DEC     A               ; decrease
        JR      NZ,L0D1C        ; back to PO-SCR-4A until done

        POP     HL              ; restore original P_FLAG.
        LD      (IY+$57),L      ; and overwrite system variable P_FLAG.

        POP     HL              ; restore original ATTR_T/MASK_T.
        LD      ($5C8F),HL      ; and update system variables.

        LD      BC,($5C88)      ; fetch S_POSN to BC.
        RES     0,(IY+$02)      ; signal to TV_FLAG  - main screen in use.
        CALL    L0DD9           ; call routine CL-SET for upper display.

        SET     0,(IY+$02)      ; signal to TV_FLAG  - lower screen in use.
        POP     BC              ; restore line/column
        RET                     ; return via CL-SET for lower display.

; ----------------------
; Temporary colour items
; ----------------------
; This subroutine is called 11 times to copy the permanent colour items
; to the temporary ones.

;; TEMPS
L0D4D:  XOR     A               ; clear the accumulator
        LD      HL,($5C8D)      ; fetch L=ATTR_P and H=MASK_P
        BIT     0,(IY+$02)      ; test TV_FLAG  - is lower screen in use ?
        JR      Z,L0D5B         ; skip to TEMPS-1 if not

        LD      H,A             ; set H, MASK P, to 00000000.
        LD      L,(IY+$0E)      ; fetch BORDCR to L which is used for lower
                                ; screen.

;; TEMPS-1
L0D5B:  LD      ($5C8F),HL      ; transfer values to ATTR_T and MASK_T

; for the print flag the permanent values are odd bits, temporary even bits.

        LD      HL,$5C91        ; address P_FLAG.
        JR      NZ,L0D65        ; skip to TEMPS-2 if lower screen using A=0.

        LD      A,(HL)          ; else pick up flag bits.
        RRCA                    ; rotate permanent bits to temporary bits.

;; TEMPS-2
L0D65:  XOR     (HL)            ;
        AND     $55             ; BIN 01010101
        XOR     (HL)            ; permanent now as original
        LD      (HL),A          ; apply permanent bits to temporary bits.
        RET                     ; and return.

; -----------------
; THE 'CLS' COMMAND 
; -----------------
;    This command clears the display.
;    The routine is also called during initialization and by the CLEAR command.
;    If it's difficult to write it should be difficult to read.

;; CLS
L0D6B:  CALL    L0DAF           ; Routine CL-ALL clears the entire display and
                                ; sets the attributes to the permanent ones
                                ; from ATTR-P.

;   Having cleared all 24 lines of the display area, continue into the 
;   subroutine that clears the lower display area.  Note that at the moment 
;   the attributes for the lower lines are the same as upper ones and have 
;   to be changed to match the BORDER colour.

; --------------------------
; THE 'CLS-LOWER' SUBROUTINE 
; --------------------------
;   This routine is called from INPUT, and from the MAIN execution loop.
;   This is very much a housekeeping routine which clears between 2 and 23
;   lines of the display, setting attributes and correcting situations where
;   errors have occurred while the normal input and output routines have been
;   temporarily diverted to deal with, say colour control codes. 

;; CLS-LOWER
L0D6E:  LD      HL,$5C3C        ; address System Variable TV_FLAG.
        RES     5,(HL)          ; TV_FLAG - signal do not clear lower screen.
        SET     0,(HL)          ; TV_FLAG - signal lower screen in use.

        CALL    L0D4D           ; routine TEMPS applies permanent attributes,
                                ; in this case BORDCR to ATTR_T.
                                ; Note. this seems unnecessary and is repeated 
                                ; within CL-LINE.

        LD      B,(IY+$31)      ; fetch lower screen display file size DF_SZ

        CALL    L0E44           ; routine CL-LINE clears lines to bottom of the
                                ; display and sets attributes from BORDCR while
                                ; preserving the B register.

        LD      HL,$5AC0        ; set initial attribute address to the leftmost 
                                ; cell of second line up.

        LD      A,($5C8D)       ; fetch permanent attribute from ATTR_P.

        DEC     B               ; decrement lower screen display file size.

        JR      L0D8E           ; forward to enter the backfill loop at CLS-3 
                                ; where B is decremented again.

; ---

;   The backfill loop is entered at midpoint and ensures, if more than 2
;   lines have been cleared, that any other lines take the permanent screen
;   attributes.

;; CLS-1
L0D87:  LD      C,$20           ; set counter to 32 character cells per line

;; CLS-2
L0D89:  DEC     HL              ; decrease attribute address.
        LD      (HL),A          ; and place attributes in next line up.
        DEC     C               ; decrease the 32 counter.
        JR      NZ,L0D89        ; loop back to CLS-2 until all 32 cells done.

;; CLS-3
L0D8E:  DJNZ    L0D87           ; decrease B counter and back to CLS-1
                                ; if not zero.

        LD      (IY+$31),$02    ; now set DF_SZ lower screen to 2

; This entry point is also called from CL-ALL below to
; reset the system channel input and output addresses to normal.

;; CL-CHAN
L0D94:  LD      A,$FD           ; select system channel 'K'

        CALL    L1601           ; routine CHAN-OPEN opens it.

        LD      HL,($5C51)      ; fetch CURCHL to HL to address current channel
        LD      DE,L09F4        ; set address to PRINT-OUT for first pass.
        AND     A               ; clear carry for first pass.

;; CL-CHAN-A
L0DA0:  LD      (HL),E          ; Insert the output address on the first pass 
        INC     HL              ; or the input address on the second pass.
        LD      (HL),D          ;
        INC     HL              ;

        LD      DE,L10A8        ; fetch address KEY-INPUT for second pass
        CCF                     ; complement carry flag - will set on pass 1.

        JR      C,L0DA0         ; back to CL-CHAN-A if first pass else done.

        LD      BC,$1721        ; line 23 for lower screen
        JR      L0DD9           ; exit via CL-SET to set column
                                ; for lower display

; ---------------------------
; Clearing whole display area
; ---------------------------
; This subroutine called from CLS, AUTO-LIST and MAIN-3
; clears 24 lines of the display and resets the relevant system variables.
; This routine also recovers from an error situation where, for instance, an 
; invalid colour or position control code has left the output routine addressing
; PO-TV-2 or PO-CONT.

;; CL-ALL
L0DAF:  LD      HL,$0000        ; Initialize plot coordinates.
        LD      ($5C7D),HL      ; Set system variable COORDS to 0,0.

        RES     0,(IY+$30)      ; update FLAGS2  - signal main screen is clear.

        CALL    L0D94           ; routine CL-CHAN makes channel 'K' 'normal'.

        LD      A,$FE           ; select system channel 'S'
        CALL    L1601           ; routine CHAN-OPEN opens it.

        CALL    L0D4D           ; routine TEMPS applies permanent attributes,
                                ; in this case ATTR_P, to ATTR_T. 
                                ; Note. this seems unnecessary.

        LD      B,$18           ; There are 24 lines.

        CALL    L0E44           ; routine CL-LINE clears 24 text lines and sets
                                ; attributes from ATTR-P.
                                ; This routine preserves B and sets C to $21.

        LD      HL,($5C51)      ; fetch CURCHL make HL address output routine.

        LD      DE,L09F4        ; address: PRINT-OUT
        LD      (HL),E          ; is made
        INC     HL              ; the normal
        LD      (HL),D          ; output address.

        LD      (IY+$52),$01    ; set SCR_CT - scroll count - to default.

;   Note. BC already contains $1821.

        LD      BC,$1821        ; reset column and line to 0,0
                                ; and continue into CL-SET, below, exiting
                                ; via PO-STORE (for the upper screen).

; --------------------
; THE 'CL-SET' ROUTINE
; --------------------
; This important subroutine is used to calculate the character output
; address for screens or printer based on the line/column for screens
; or the column for printer.

;; CL-SET
L0DD9:  LD      HL,$5B00        ; the base address of printer buffer
        BIT     1,(IY+$01)      ; test FLAGS  - is printer in use ?
        JR      NZ,L0DF4        ; forward to CL-SET-2 if so.

        LD      A,B             ; transfer line to A.
        BIT     0,(IY+$02)      ; test TV_FLAG  - lower screen in use ?
        JR      Z,L0DEE         ; skip to CL-SET-1 if handling upper part

        ADD     A,(IY+$31)      ; add DF_SZ for lower screen
        SUB     $18             ; and adjust.

;; CL-SET-1
L0DEE:  PUSH    BC              ; save the line/column.
        LD      B,A             ; transfer line to B
                                ; (adjusted if lower screen)

        CALL    L0E9B           ; routine CL-ADDR calculates address at left
                                ; of screen.
        POP     BC              ; restore the line/column.

;; CL-SET-2
L0DF4:  LD      A,$21           ; the column $01-$21 is reversed
        SUB     C               ; to range $00 - $20
        LD      E,A             ; now transfer to DE
        LD      D,$00           ; prepare for addition
        ADD     HL,DE           ; and add to base address

        JP      L0ADC           ; exit via PO-STORE to update the relevant
                                ; system variables.
; ----------------
; Handle scrolling
; ----------------
; The routine CL-SC-ALL is called once from PO to scroll all the display
; and from the routine CL-SCROLL, once, to scroll part of the display.

;; CL-SC-ALL
L0DFE:  LD      B,$17           ; scroll 23 lines, after 'scroll?'.

;; CL-SCROLL
L0E00:  CALL    L0E9B           ; routine CL-ADDR gets screen address in HL.
        LD      C,$08           ; there are 8 pixel lines to scroll.

;; CL-SCR-1
L0E05:  PUSH    BC              ; save counters.
        PUSH    HL              ; and initial address.
        LD      A,B             ; get line count.
        AND     $07             ; will set zero if all third to be scrolled.
        LD      A,B             ; re-fetch the line count.
        JR      NZ,L0E19        ; forward to CL-SCR-3 if partial scroll.

; HL points to top line of third and must be copied to bottom of previous 3rd.
; ( so HL = $4800 or $5000 ) ( but also sometimes $4000 )

;; CL-SCR-2
L0E0D:  EX      DE,HL           ; copy HL to DE.
        LD      HL,$F8E0        ; subtract $08 from H and add $E0 to L -
        ADD     HL,DE           ; to make destination bottom line of previous
                                ; third.
        EX      DE,HL           ; restore the source and destination.
        LD      BC,$0020        ; thirty-two bytes are to be copied.
        DEC     A               ; decrement the line count.
        LDIR                    ; copy a pixel line to previous third.

;; CL-SCR-3
L0E19:  EX      DE,HL           ; save source in DE.
        LD      HL,$FFE0        ; load the value -32.
        ADD     HL,DE           ; add to form destination in HL.
        EX      DE,HL           ; switch source and destination
        LD      B,A             ; save the count in B.
        AND     $07             ; mask to find count applicable to current
        RRCA                    ; third and
        RRCA                    ; multiply by
        RRCA                    ; thirty two (same as 5 RLCAs)

        LD      C,A             ; transfer byte count to C ($E0 at most)
        LD      A,B             ; store line count to A
        LD      B,$00           ; make B zero
        LDIR                    ; copy bytes (BC=0, H incremented, L=0)
        LD      B,$07           ; set B to 7, C is zero.
        ADD     HL,BC           ; add 7 to H to address next third.
        AND     $F8             ; has last third been done ?
        JR      NZ,L0E0D        ; back to CL-SCR-2 if not.

        POP     HL              ; restore topmost address.
        INC     H               ; next pixel line down.
        POP     BC              ; restore counts.
        DEC     C               ; reduce pixel line count.
        JR      NZ,L0E05        ; back to CL-SCR-1 if all eight not done.

        CALL    L0E88           ; routine CL-ATTR gets address in attributes
                                ; from current 'ninth line', count in BC.

        LD      HL,$FFE0        ; set HL to the 16-bit value -32.
        ADD     HL,DE           ; and add to form destination address.
        EX      DE,HL           ; swap source and destination addresses.
        LDIR                    ; copy bytes scrolling the linear attributes.
        LD      B,$01           ; continue to clear the bottom line.

; ------------------------------
; THE 'CLEAR TEXT LINES' ROUTINE
; ------------------------------
; This subroutine, called from CL-ALL, CLS-LOWER and AUTO-LIST and above,
; clears text lines at bottom of display.
; The B register holds on entry the number of lines to be cleared 1-24.

;; CL-LINE
L0E44:  PUSH    BC              ; save line count
        CALL    L0E9B           ; routine CL-ADDR gets top address
        LD      C,$08           ; there are eight screen lines to a text line.

;; CL-LINE-1
L0E4A:  PUSH    BC              ; save pixel line count
        PUSH    HL              ; and save the address
        LD      A,B             ; transfer the line to A (1-24).

;; CL-LINE-2
L0E4D:  AND     $07             ; mask 0-7 to consider thirds at a time
        RRCA                    ; multiply
        RRCA                    ; by 32  (same as five RLCA instructions)
        RRCA                    ; now 32 - 256(0)
        LD      C,A             ; store result in C
        LD      A,B             ; save line in A (1-24)
        LD      B,$00           ; set high byte to 0, prepare for ldir.
        DEC     C               ; decrement count 31-255.
        LD      D,H             ; copy HL
        LD      E,L             ; to DE.
        LD      (HL),$00        ; blank the first byte.
        INC     DE              ; make DE point to next byte.
        LDIR                    ; ldir will clear lines.
        LD      DE,$0701        ; now address next third adjusting
        ADD     HL,DE           ; register E to address left hand side
        DEC     A               ; decrease the line count.
        AND     $F8             ; will be 16, 8 or 0  (AND $18 will do).
        LD      B,A             ; transfer count to B.
        JR      NZ,L0E4D        ; back to CL-LINE-2 if 16 or 8 to do
                                ; the next third.

        POP     HL              ; restore start address.
        INC     H               ; address next line down.
        POP     BC              ; fetch counts.
        DEC     C               ; decrement pixel line count
        JR      NZ,L0E4A        ; back to CL-LINE-1 till all done.

        CALL    L0E88           ; routine CL-ATTR gets attribute address
                                ; in DE and B * 32 in BC.

        LD      H,D             ; transfer the address
        LD      L,E             ; to HL.

        INC     DE              ; make DE point to next location.

        LD      A,($5C8D)       ; fetch ATTR_P - permanent attributes
        BIT     0,(IY+$02)      ; test TV_FLAG  - lower screen in use ?
        JR      Z,L0E80         ; skip to CL-LINE-3 if not.

        LD      A,($5C48)       ; else lower screen uses BORDCR as attribute.

;; CL-LINE-3
L0E80:  LD      (HL),A          ; put attribute in first byte.
        DEC     BC              ; decrement the counter.
        LDIR                    ; copy bytes to set all attributes.
        POP     BC              ; restore the line $01-$24.
        LD      C,$21           ; make column $21. (No use is made of this)
        RET                     ; return to the calling routine.

; ------------------
; Attribute handling
; ------------------
; This subroutine is called from CL-LINE or CL-SCROLL with the HL register
; pointing to the 'ninth' line and H needs to be decremented before or after
; the division. Had it been done first then either present code or that used
; at the start of PO-ATTR could have been used.
; The Spectrum screen arrangement leads to the L register already holding 
; the correct value for the attribute file and it is only necessary
; to manipulate H to form the correct colour attribute address.

;; CL-ATTR
L0E88:  LD      A,H             ; fetch H to A - $48, $50, or $58.
        RRCA                    ; divide by
        RRCA                    ; eight.
        RRCA                    ; $09, $0A or $0B.
        DEC     A               ; $08, $09 or $0A.
        OR      $50             ; $58, $59 or $5A.
        LD      H,A             ; save high byte of attributes.

        EX      DE,HL           ; transfer attribute address to DE
        LD      H,C             ; set H to zero - from last LDIR.
        LD      L,B             ; load L with the line from B.
        ADD     HL,HL           ; multiply
        ADD     HL,HL           ; by
        ADD     HL,HL           ; thirty two
        ADD     HL,HL           ; to give count of attribute
        ADD     HL,HL           ; cells to the end of display.

        LD      B,H             ; transfer the result
        LD      C,L             ; to register BC.

        RET                     ; return.

; -------------------------------
; Handle display with line number
; -------------------------------
; This subroutine is called from four places to calculate the address
; of the start of a screen character line which is supplied in B.

;; CL-ADDR
L0E9B:  LD      A,$18           ; reverse the line number
        SUB     B               ; to range $00 - $17.
        LD      D,A             ; save line in D for later.
        RRCA                    ; multiply
        RRCA                    ; by
        RRCA                    ; thirty-two.

        AND     $E0             ; mask off low bits to make
        LD      L,A             ; L a multiple of 32.

        LD      A,D             ; bring back the line to A.

        AND     $18             ; now $00, $08 or $10.

        OR      $40             ; add the base address of screen.

        LD      H,A             ; HL now has the correct address.
        RET                     ; return.

; -------------------
; Handle COPY command
; -------------------
; This command copies the top 176 lines to the ZX Printer
; It is popular to call this from machine code at point
; L0EAF with B holding 192 (and interrupts disabled) for a full-screen
; copy. This particularly applies to 16K Spectrums as time-critical
; machine code routines cannot be written in the first 16K of RAM as
; it is shared with the ULA which has precedence over the Z80 chip.

;; COPY
L0EAC:  DI                      ; disable interrupts as this is time-critical.

        LD      B,$B0           ; top 176 lines.
L0EAF:  LD      HL,$4000        ; address start of the display file.

; now enter a loop to handle each pixel line.

;; COPY-1
L0EB2:  PUSH    HL              ; save the screen address.
        PUSH    BC              ; and the line counter.

        CALL    L0EF4           ; routine COPY-LINE outputs one line.

        POP     BC              ; restore the line counter.
        POP     HL              ; and display address.
        INC     H               ; next line down screen within 'thirds'.
        LD      A,H             ; high byte to A.
        AND     $07             ; result will be zero if we have left third.
        JR      NZ,L0EC9        ; forward to COPY-2 if not to continue loop.

        LD      A,L             ; consider low byte first.
        ADD     A,$20           ; increase by 32 - sets carry if back to zero.
        LD      L,A             ; will be next group of 8.
        CCF                     ; complement - carry set if more lines in
                                ; the previous third.
        SBC     A,A             ; will be FF, if more, else 00.
        AND     $F8             ; will be F8 (-8) or 00.
        ADD     A,H             ; that is subtract 8, if more to do in third.
        LD      H,A             ; and reset address.

;; COPY-2
L0EC9:  DJNZ    L0EB2           ; back to COPY-1 for all lines.

        JR      L0EDA           ; forward to COPY-END to switch off the printer
                                ; motor and enable interrupts.
                                ; Note. Nothing else is required.

; ------------------------------
; Pass printer buffer to printer
; ------------------------------
; This routine is used to copy 8 text lines from the printer buffer
; to the ZX Printer. These text lines are mapped linearly so HL does
; not need to be adjusted at the end of each line.

;; COPY-BUFF
L0ECD:  DI                      ; disable interrupts
        LD      HL,$5B00        ; the base address of the Printer Buffer.
        LD      B,$08           ; set count to 8 lines of 32 bytes.

;; COPY-3
L0ED3:  PUSH    BC              ; save counter.

        CALL    L0EF4           ; routine COPY-LINE outputs 32 bytes

        POP     BC              ; restore counter.
        DJNZ    L0ED3           ; loop back to COPY-3 for all 8 lines.
                                ; then stop motor and clear buffer.

; Note. the COPY command rejoins here, essentially to execute the next
; three instructions.

;; COPY-END
L0EDA:  LD      A,$04           ; output value 4 to port
        OUT     ($FB),A         ; to stop the slowed printer motor.
        EI                      ; enable interrupts.

; --------------------
; Clear Printer Buffer
; --------------------
; This routine clears an arbitrary 256 bytes of memory.
; Note. The routine seems designed to clear a buffer that follows the
; system variables.
; The routine should check a flag or HL address and simply return if COPY
; is in use.
; As a consequence of this omission the buffer will needlessly
; be cleared when COPY is used and the screen/printer position may be set to
; the start of the buffer and the line number to 0 (B)
; giving an 'Out of Screen' error.
; There seems to have been an unsuccessful attempt to circumvent the use
; of PR_CC_hi.

;; CLEAR-PRB
L0EDF:  LD      HL,$5B00        ; the location of the buffer.
        LD      (IY+$46),L      ; update PR_CC_lo - set to zero - superfluous.
        XOR     A               ; clear the accumulator.
        LD      B,A             ; set count to 256 bytes.

;; PRB-BYTES
L0EE7:  LD      (HL),A          ; set addressed location to zero.
        INC     HL              ; address next byte - Note. not INC L.
        DJNZ    L0EE7           ; back to PRB-BYTES. repeat for 256 bytes.

        RES     1,(IY+$30)      ; set FLAGS2 - signal printer buffer is clear.
        LD      C,$21           ; set the column position .
        JP      L0DD9           ; exit via CL-SET and then PO-STORE.

; -----------------
; Copy line routine
; -----------------
; This routine is called from COPY and COPY-BUFF to output a line of
; 32 bytes to the ZX Printer.
; Output to port $FB -
; bit 7 set - activate stylus.
; bit 7 low - deactivate stylus.
; bit 2 set - stops printer.
; bit 2 reset - starts printer
; bit 1 set - slows printer.
; bit 1 reset - normal speed.

;; COPY-LINE
L0EF4:  LD      A,B             ; fetch the counter 1-8 or 1-176
        CP      $03             ; is it 01 or 02 ?.
        SBC     A,A             ; result is $FF if so else $00.
        AND     $02             ; result is 02 now else 00.
                                ; bit 1 set slows the printer.
        OUT     ($FB),A         ; slow the printer for the
                                ; last two lines.
        LD      D,A             ; save the mask to control the printer later.

;; COPY-L-1
L0EFD:  CALL    L1F54           ; call BREAK-KEY to read keyboard immediately.
        JR      C,L0F0C         ; forward to COPY-L-2 if 'break' not pressed.

        LD      A,$04           ; else stop the
        OUT     ($FB),A         ; printer motor.
        EI                      ; enable interrupts.
        CALL    L0EDF           ; call routine CLEAR-PRB.
                                ; Note. should not be cleared if COPY in use.

;; REPORT-Dc
L0F0A:  RST     08H             ; ERROR-1
        DEFB    $0C             ; Error Report: BREAK - CONT repeats

;; COPY-L-2
L0F0C:  IN      A,($FB)         ; test now to see if
        ADD     A,A             ; a printer is attached.
        RET     M               ; return if not - but continue with parent
                                ; command.

        JR      NC,L0EFD        ; back to COPY-L-1 if stylus of printer not
                                ; in position.

        LD      C,$20           ; set count to 32 bytes.

;; COPY-L-3
L0F14:  LD      E,(HL)          ; fetch a byte from line.
        INC     HL              ; address next location. Note. not INC L.
        LD      B,$08           ; count the bits.

;; COPY-L-4
L0F18:  RL      D               ; prepare mask to receive bit.
        RL      E               ; rotate leftmost print bit to carry
        RR      D               ; and back to bit 7 of D restoring bit 1

;; COPY-L-5
L0F1E:  IN      A,($FB)         ; read the port.
        RRA                     ; bit 0 to carry.
        JR      NC,L0F1E        ; back to COPY-L-5 if stylus not in position.

        LD      A,D             ; transfer command bits to A.
        OUT     ($FB),A         ; and output to port.
        DJNZ    L0F18           ; loop back to COPY-L-4 for all 8 bits.

        DEC     C               ; decrease the byte count.
        JR      NZ,L0F14        ; back to COPY-L-3 until 256 bits done.

        RET                     ; return to calling routine COPY/COPY-BUFF.


; ----------------------------------
; Editor routine for BASIC and INPUT
; ----------------------------------
; The editor is called to prepare or edit a BASIC line.
; It is also called from INPUT to input a numeric or string expression.
; The behaviour and options are quite different in the various modes
; and distinguished by bit 5 of FLAGX.
;
; This is a compact and highly versatile routine.

;; EDITOR
L0F2C:  LD      HL,($5C3D)      ; fetch ERR_SP
        PUSH    HL              ; save on stack

;; ED-AGAIN
L0F30:  LD      HL,L107F        ; address: ED-ERROR
        PUSH    HL              ; save address on stack and
        LD      ($5C3D),SP      ; make ERR_SP point to it.

; Note. While in editing/input mode should an error occur then RST 08 will
; update X_PTR to the location reached by CH_ADD and jump to ED-ERROR
; where the error will be cancelled and the loop begin again from ED-AGAIN
; above. The position of the error will be apparent when the lower screen is
; reprinted. If no error then the re-iteration is to ED-LOOP below when
; input is arriving from the keyboard.

;; ED-LOOP
L0F38:  CALL    L15D4           ; routine WAIT-KEY gets key possibly
                                ; changing the mode.
        PUSH    AF              ; save key.
        LD      D,$00           ; and give a short click based
        LD      E,(IY-$01)      ; on PIP value for duration.
        LD      HL,$00C8        ; and pitch.
        CALL    L03B5           ; routine BEEPER gives click - effective
                                ; with rubber keyboard.
        POP     AF              ; get saved key value.
        LD      HL,L0F38        ; address: ED-LOOP is loaded to HL.
        PUSH    HL              ; and pushed onto stack.

; At this point there is a looping return address on the stack, an error
; handler and an input stream set up to supply characters.
; The character that has been received can now be processed.

        CP      $18             ; range 24 to 255 ?
        JR      NC,L0F81        ; forward to ADD-CHAR if so.

        CP      $07             ; lower than 7 ?
        JR      C,L0F81         ; forward to ADD-CHAR also.
                                ; Note. This is a 'bug' and chr$ 6, the comma
                                ; control character, should have had an
                                ; entry in the ED-KEYS table.
                                ; Steven Vickers, 1984, Pitman.

        CP      $10             ; less than 16 ?
        JR      C,L0F92         ; forward to ED-KEYS if editing control
                                ; range 7 to 15 dealt with by a table

        LD      BC,$0002        ; prepare for ink/paper etc.
        LD      D,A             ; save character in D
        CP      $16             ; is it ink/paper/bright etc. ?
        JR      C,L0F6C         ; forward to ED-CONTR if so

                                ; leaves 22d AT and 23d TAB
                                ; which can't be entered via KEY-INPUT.
                                ; so this code is never normally executed
                                ; when the keyboard is used for input.

        INC     BC              ; if it was AT/TAB - 3 locations required
        BIT     7,(IY+$37)      ; test FLAGX  - Is this INPUT LINE ?
        JP      Z,L101E         ; jump to ED-IGNORE if not, else 

        CALL    L15D4           ; routine WAIT-KEY - input address is KEY-NEXT
                                ; but is reset to KEY-INPUT
        LD      E,A             ; save first in E

;; ED-CONTR
L0F6C:  CALL    L15D4           ; routine WAIT-KEY for control.
                                ; input address will be key-next.

        PUSH    DE              ; saved code/parameters
        LD      HL,($5C5B)      ; fetch address of keyboard cursor from K_CUR
        RES     0,(IY+$07)      ; set MODE to 'L'

        CALL    L1655           ; routine MAKE-ROOM makes 2/3 spaces at cursor

        POP     BC              ; restore code/parameters
        INC     HL              ; address first location
        LD      (HL),B          ; place code (ink etc.)
        INC     HL              ; address next
        LD      (HL),C          ; place possible parameter. If only one
                                ; then DE points to this location also.
        JR      L0F8B           ; forward to ADD-CH-1

; ------------------------
; Add code to current line
; ------------------------
; this is the branch used to add normal non-control characters
; with ED-LOOP as the stacked return address.
; it is also the OUTPUT service routine for system channel 'R'.

;; ADD-CHAR
L0F81:  RES     0,(IY+$07)      ; set MODE to 'L'

X0F85:  LD      HL,($5C5B)      ; fetch address of keyboard cursor from K_CUR

        CALL    L1652           ; routine ONE-SPACE creates one space.

; either a continuation of above or from ED-CONTR with ED-LOOP on stack.

;; ADD-CH-1
L0F8B:  LD      (DE),A          ; load current character to last new location.
        INC     DE              ; address next
        LD      ($5C5B),DE      ; and update K_CUR system variable.
        RET                     ; return - either a simple return
                                ; from ADD-CHAR or to ED-LOOP on stack.

; ---

; a branch of the editing loop to deal with control characters
; using a look-up table.

;; ED-KEYS
L0F92:  LD      E,A             ; character to E.
        LD      D,$00           ; prepare to add.
        LD      HL,L0FA0 - 7    ; base address of editing keys table. $0F99
        ADD     HL,DE           ; add E
        LD      E,(HL)          ; fetch offset to E
        ADD     HL,DE           ; add offset for address of handling routine.
        PUSH    HL              ; push the address on machine stack.
        LD      HL,($5C5B)      ; load address of cursor from K_CUR.
        RET                     ; Make an indirect jump forward to routine.

; ------------------
; Editing keys table
; ------------------
; For each code in the range $07 to $0F this table contains a
; single offset byte to the routine that services that code.
; Note. for what was intended there should also have been an
; entry for chr$ 6 with offset to ed-symbol.

;; ed-keys-t
L0FA0:  DEFB    L0FA9 - ASMPC  ; 07d offset $09 to Address: ED-EDIT
        DEFB    L1007 - ASMPC  ; 08d offset $66 to Address: ED-LEFT
        DEFB    L100C - ASMPC  ; 09d offset $6A to Address: ED-RIGHT
        DEFB    L0FF3 - ASMPC  ; 10d offset $50 to Address: ED-DOWN
        DEFB    L1059 - ASMPC  ; 11d offset $B5 to Address: ED-UP
        DEFB    L1015 - ASMPC  ; 12d offset $70 to Address: ED-DELETE
        DEFB    L1024 - ASMPC  ; 13d offset $7E to Address: ED-ENTER
        DEFB    L1076 - ASMPC  ; 14d offset $CF to Address: ED-SYMBOL
        DEFB    L107C - ASMPC  ; 15d offset $D4 to Address: ED-GRAPH

; ---------------
; Handle EDIT key
; ---------------
; The user has pressed SHIFT 1 to bring edit line down to bottom of screen.
; Alternatively the user wishes to clear the input buffer and start again.
; Alternatively ...

;; ED-EDIT
L0FA9:  LD      HL,($5C49)      ; fetch E_PPC the last line number entered.
                                ; Note. may not exist and may follow program.
        BIT     5,(IY+$37)      ; test FLAGX  - input mode ?
        JP      NZ,L1097        ; jump forward to CLEAR-SP if not in editor.

        CALL    L196E           ; routine LINE-ADDR to find address of line
                                ; or following line if it doesn't exist.
        CALL    L1695           ; routine LINE-NO will get line number from
                                ; address or previous line if at end-marker.
        LD      A,D             ; if there is no program then DE will
        OR      E               ; contain zero so test for this.
        JP      Z,L1097         ; jump to CLEAR-SP if so.

; Note. at this point we have a validated line number, not just an
; approximation and it would be best to update E_PPC with the true
; cursor line value which would enable the line cursor to be suppressed
; in all situations - see shortly.

        PUSH    HL              ; save address of line.
        INC     HL              ; address low byte of length.
        LD      C,(HL)          ; transfer to C
        INC     HL              ; next to high byte
        LD      B,(HL)          ; transfer to B.
        LD      HL,$000A        ; an overhead of ten bytes
        ADD     HL,BC           ; is added to length.
        LD      B,H             ; transfer adjusted value
        LD      C,L             ; to BC register.
        CALL    L1F05           ; routine TEST-ROOM checks free memory.
        CALL    L1097           ; routine CLEAR-SP clears editing area.
        LD      HL,($5C51)      ; address CURCHL
        EX      (SP),HL         ; swap with line address on stack
        PUSH    HL              ; save line address underneath

        LD      A,$FF           ; select system channel 'R'
        CALL    L1601           ; routine CHAN-OPEN opens it

        POP     HL              ; drop line address
        DEC     HL              ; make it point to first byte of line num.
        DEC     (IY+$0F)        ; decrease E_PPC_lo to suppress line cursor.
                                ; Note. ineffective when E_PPC is one
                                ; greater than last line of program perhaps
                                ; as a result of a delete.
                                ; credit. Paul Harrison 1982.

        CALL    L1855           ; routine OUT-LINE outputs the BASIC line
                                ; to the editing area.
        INC     (IY+$0F)        ; restore E_PPC_lo to the previous value.
        LD      HL,($5C59)      ; address E_LINE in editing area.
        INC     HL              ; advance
        INC     HL              ; past space
        INC     HL              ; and digit characters
        INC     HL              ; of line number.

        LD      ($5C5B),HL      ; update K_CUR to address start of BASIC.
        POP     HL              ; restore the address of CURCHL.
        CALL    L1615           ; routine CHAN-FLAG sets flags for it.

        RET                     ; RETURN to ED-LOOP.

; -------------------
; Cursor down editing
; -------------------
;   The BASIC lines are displayed at the top of the screen and the user
;   wishes to move the cursor down one line in edit mode.
;   With INPUT LINE, this key must be used instead of entering STOP.

;; ED-DOWN
L0FF3:  BIT     5,(IY+$37)      ; test FLAGX  - Input Mode ?
        JR      NZ,L1001        ; skip to ED-STOP if so

        LD      HL,$5C49        ; address E_PPC - 'current line'
        CALL    L190F           ; routine LN-FETCH fetches number of next
                                ; line or same if at end of program.
        JR      L106E           ; forward to ED-LIST to produce an
                                ; automatic listing.

; ---

;; ED-STOP
L1001:  LD      (IY+$00),$10    ; set ERR_NR to 'STOP in INPUT' code
        JR      L1024           ; forward to ED-ENTER to produce error.

; -------------------
; Cursor left editing
; -------------------
; This acts on the cursor in the lower section of the screen in both
; editing and input mode.

;; ED-LEFT
L1007:  CALL    L1031           ; routine ED-EDGE moves left if possible
        JR      L1011           ; forward to ED-CUR to update K-CUR
                                ; and return to ED-LOOP.

; --------------------
; Cursor right editing
; --------------------
; This acts on the cursor in the lower screen in both editing and input
; mode and moves it to the right.

;; ED-RIGHT
L100C:  LD      A,(HL)          ; fetch addressed character.
        CP      $0D             ; is it carriage return ?
        RET     Z               ; return if so to ED-LOOP

        INC     HL              ; address next character

;; ED-CUR
L1011:  LD      ($5C5B),HL      ; update K_CUR system variable
        RET                     ; return to ED-LOOP

; --------------
; DELETE editing
; --------------
; This acts on the lower screen and deletes the character to left of
; cursor. If control characters are present these are deleted first
; leaving the naked parameter (0-7) which appears as a '?' except in the
; case of chr$ 6 which is the comma control character. It is not mandatory
; to delete these second characters.

;; ED-DELETE
L1015:  CALL    L1031           ; routine ED-EDGE moves cursor to left.
        LD      BC,$0001        ; of character to be deleted.
        JP      L19E8           ; to RECLAIM-2 reclaim the character.

; ------------------------------------------
; Ignore next 2 codes from key-input routine
; ------------------------------------------
; Since AT and TAB cannot be entered this point is never reached
; from the keyboard. If inputting from a tape device or network then
; the control and two following characters are ignored and processing
; continues as if a carriage return had been received.
; Here, perhaps, another Spectrum has said print #15; AT 0,0; "This is yellow"
; and this one is interpreting input #15; a$.

;; ED-IGNORE
L101E:  CALL    L15D4           ; routine WAIT-KEY to ignore keystroke.
        CALL    L15D4           ; routine WAIT-KEY to ignore next key.

; -------------
; Enter/newline
; -------------
; The enter key has been pressed to have BASIC line or input accepted.

;; ED-ENTER
L1024:  POP     HL              ; discard address ED-LOOP
        POP     HL              ; drop address ED-ERROR

;; ED-END
L1026:  POP     HL              ; the previous value of ERR_SP
        LD      ($5C3D),HL      ; is restored to ERR_SP system variable
        BIT     7,(IY+$00)      ; is ERR_NR $FF (= 'OK') ?
        RET     NZ              ; return if so

        LD      SP,HL           ; else put error routine on stack
        RET                     ; and make an indirect jump to it.

; -----------------------------
; Move cursor left when editing
; -----------------------------
; This routine moves the cursor left. The complication is that it must
; not position the cursor between control codes and their parameters.
; It is further complicated in that it deals with TAB and AT characters
; which are never present from the keyboard.
; The method is to advance from the beginning of the line each time,
; jumping one, two, or three characters as necessary saving the original
; position at each jump in DE. Once it arrives at the cursor then the next
; legitimate leftmost position is in DE.

;; ED-EDGE
L1031:  SCF                     ; carry flag must be set to call the nested
        CALL    L1195           ; subroutine SET-DE.
                                ; if input   then DE=WORKSP
                                ; if editing then DE=E_LINE
        SBC     HL,DE           ; subtract address from start of line
        ADD     HL,DE           ; and add back.
        INC     HL              ; adjust for carry.
        POP     BC              ; drop return address
        RET     C               ; return to ED-LOOP if already at left
                                ; of line.

        PUSH    BC              ; resave return address - ED-LOOP.
        LD      B,H             ; transfer HL - cursor address
        LD      C,L             ; to BC register pair.
                                ; at this point DE addresses start of line.

;; ED-EDGE-1
L103E:  LD      H,D             ; transfer DE - leftmost pointer
        LD      L,E             ; to HL
        INC     HL              ; address next leftmost character to
                                ; advance position each time.
        LD      A,(DE)          ; pick up previous in A
        AND     $F0             ; lose the low bits
        CP      $10             ; is it INK to TAB $10-$1F ?
                                ; that is, is it followed by a parameter ?
        JR      NZ,L1051        ; to ED-EDGE-2 if not
                                ; HL has been incremented once

        INC     HL              ; address next as at least one parameter.

; in fact since 'tab' and 'at' cannot be entered the next section seems
; superfluous.
; The test will always fail and the jump to ED-EDGE-2 will be taken.

        LD      A,(DE)          ; reload leftmost character
        SUB     $17             ; decimal 23 ('tab')
        ADC     A,$00           ; will be 0 for 'tab' and 'at'.
        JR      NZ,L1051        ; forward to ED-EDGE-2 if not
                                ; HL has been incremented twice

        INC     HL              ; increment a third time for 'at'/'tab'

;; ED-EDGE-2
L1051:  AND     A               ; prepare for true subtraction
        SBC     HL,BC           ; subtract cursor address from pointer
        ADD     HL,BC           ; and add back
                                ; Note when HL matches the cursor position BC,
                                ; there is no carry and the previous
                                ; position is in DE.
        EX      DE,HL           ; transfer result to DE if looping again.
                                ; transfer DE to HL to be used as K-CUR
                                ; if exiting loop.
        JR      C,L103E         ; back to ED-EDGE-1 if cursor not matched.

        RET                     ; return.

; -----------------
; Cursor up editing
; -----------------
; The main screen displays part of the BASIC program and the user wishes
; to move up one line scrolling if necessary.
; This has no alternative use in input mode.

;; ED-UP
L1059:  BIT     5,(IY+$37)      ; test FLAGX  - input mode ?
        RET     NZ              ; return if not in editor - to ED-LOOP.

        LD      HL,($5C49)      ; get current line from E_PPC
        CALL    L196E           ; routine LINE-ADDR gets address
        EX      DE,HL           ; and previous in DE
        CALL    L1695           ; routine LINE-NO gets prev line number
        LD      HL,$5C4A        ; set HL to E_PPC_hi as next routine stores
                                ; top first.
        CALL    L191C           ; routine LN-STORE loads DE value to HL
                                ; high byte first - E_PPC_lo takes E

; this branch is also taken from ed-down.

;; ED-LIST
L106E:  CALL    L1795           ; routine AUTO-LIST lists to upper screen
                                ; including adjusted current line.
        LD      A,$00           ; select lower screen again
        JP      L1601           ; exit via CHAN-OPEN to ED-LOOP

; --------------------------------
; Use of symbol and graphics codes
; --------------------------------
; These will not be encountered with the keyboard but would be handled
; otherwise as follows.
; As noted earlier, Vickers says there should have been an entry in
; the KEYS table for chr$ 6 which also pointed here.
; If, for simplicity, two Spectrums were both using #15 as a bi-directional
; channel connected to each other:-
; then when the other Spectrum has said PRINT #15; x, y
; input #15; i ; j  would treat the comma control as a newline and the
; control would skip to input j.
; You can get round the missing chr$ 6 handler by sending multiple print
; items separated by a newline '.

; chr$14 would have the same functionality.

; This is chr$ 14.
;; ED-SYMBOL
L1076:  BIT     7,(IY+$37)      ; test FLAGX - is this INPUT LINE ?
        JR      Z,L1024         ; back to ED-ENTER if not to treat as if
                                ; enter had been pressed.
                                ; else continue and add code to buffer.

; Next is chr$ 15
; Note that ADD-CHAR precedes the table so we can't offset to it directly.

;; ED-GRAPH
L107C:  JP      L0F81           ; jump back to ADD-CHAR

; --------------------
; Editor error routine
; --------------------
; If an error occurs while editing, or inputting, then ERR_SP
; points to the stack location holding address ED_ERROR.

;; ED-ERROR
L107F:  BIT     4,(IY+$30)      ; test FLAGS2  - is K channel in use ?
        JR      Z,L1026         ; back to ED-END if not.

; but as long as we're editing lines or inputting from the keyboard, then
; we've run out of memory so give a short rasp.

        LD      (IY+$00),$FF    ; reset ERR_NR to 'OK'.
        LD      D,$00           ; prepare for beeper.
        LD      E,(IY-$02)      ; use RASP value.
        LD      HL,$1A90        ; set the pitch - or tone period.
        CALL    L03B5           ; routine BEEPER emits a warning rasp.
        JP      L0F30           ; to ED-AGAIN to re-stack address of
                                ; this routine and make ERR_SP point to it.

; ---------------------
; Clear edit/work space
; ---------------------
; The editing area or workspace is cleared depending on context.
; This is called from ED-EDIT to clear workspace if edit key is
; used during input, to clear editing area if no program exists
; and to clear editing area prior to copying the edit line to it.
; It is also used by the error routine to clear the respective
; area depending on FLAGX.

;; CLEAR-SP
L1097:  PUSH    HL              ; preserve HL
        CALL    L1190           ; routine SET-HL
                                ; if in edit   HL = WORKSP-1, DE = E_LINE
                                ; if in input  HL = STKBOT,   DE = WORKSP
        DEC     HL              ; adjust
        CALL    L19E5           ; routine RECLAIM-1 reclaims space
        LD      ($5C5B),HL      ; set K_CUR to start of empty area
        LD      (IY+$07),$00    ; set MODE to 'KLC'
        POP     HL              ; restore HL.
        RET                     ; return.

; ----------------------------
; THE 'KEYBOARD INPUT' ROUTINE
; ----------------------------
; This is the service routine for the input stream of the keyboard channel 'K'.

;; KEY-INPUT
L10A8:  BIT     3,(IY+$02)      ; test TV_FLAG  - has a key been pressed in
                                ; editor ?

        CALL    NZ,L111D        ; routine ED-COPY, if so, to reprint the lower
                                ; screen at every keystroke/mode change.

        AND     A               ; clear carry flag - required exit condition.

        BIT     5,(IY+$01)      ; test FLAGS  - has a new key been pressed ?
        RET     Z               ; return if not.                        >>

        LD      A,($5C08)       ; system variable LASTK will hold last key -
                                ; from the interrupt routine.

        RES     5,(IY+$01)      ; update FLAGS  - reset the new key flag.
        PUSH    AF              ; save the input character.

        BIT     5,(IY+$02)      ; test TV_FLAG  - clear lower screen ?

        CALL    NZ,L0D6E        ; routine CLS-LOWER if so.

        POP     AF              ; restore the character code.

        CP      $20             ; if space or higher then
        JR      NC,L111B        ; forward to KEY-DONE2 and return with carry
                                ; set to signal key-found.

        CP      $10             ; with 16d INK and higher skip
        JR      NC,L10FA        ; forward to KEY-CONTR.

        CP      $06             ; for 6 - 15d
        JR      NC,L10DB        ; skip forward to KEY-M-CL to handle Modes
                                ; and CapsLock.

; that only leaves 0-5, the flash bright inverse switches.

        LD      B,A             ; save character in B
        AND     $01             ; isolate the embedded parameter (0/1).
        LD      C,A             ; and store in C
        LD      A,B             ; re-fetch copy (0-5)
        RRA                     ; halve it 0, 1 or 2.
        ADD     A,$12           ; add 18d gives 'flash', 'bright'
                                ; and 'inverse'.
        JR      L1105           ; forward to KEY-DATA with the 
                                ; parameter (0/1) in C.

; ---

; Now separate capslock 06 from modes 7-15.

;; KEY-M-CL
L10DB:  JR      NZ,L10E6        ; forward to KEY-MODE if not 06 (capslock)

        LD      HL,$5C6A        ; point to FLAGS2
        LD      A,$08           ; value 00001000
        XOR     (HL)            ; toggle BIT 3 of FLAGS2 the capslock bit
        LD      (HL),A          ; and store result in FLAGS2 again.
        JR      L10F4           ; forward to KEY-FLAG to signal no-key.

; ---

;; KEY-MODE
L10E6:  CP      $0E             ; compare with chr 14d
        RET     C               ; return with carry set "key found" for
                                ; codes 7 - 13d leaving 14d and 15d
                                ; which are converted to mode codes.

        SUB     $0D             ; subtract 13d leaving 1 and 2
                                ; 1 is 'E' mode, 2 is 'G' mode.
        LD      HL,$5C41        ; address the MODE system variable.
        CP      (HL)            ; compare with existing value before
        LD      (HL),A          ; inserting the new value.
        JR      NZ,L10F4        ; forward to KEY-FLAG if it has changed.

        LD      (HL),$00        ; else make MODE zero - KLC mode
                                ; Note. while in Extended/Graphics mode,
                                ; the Extended Mode/Graphics key is pressed
                                ; again to get out.

;; KEY-FLAG
L10F4:  SET     3,(IY+$02)      ; update TV_FLAG  - show key state has changed
        CP      A               ; clear carry and reset zero flags -
                                ; no actual key returned.
        RET                     ; make the return.

; ---

; now deal with colour controls - 16-23 ink, 24-31 paper

;; KEY-CONTR
L10FA:  LD      B,A             ; make a copy of character.
        AND     $07             ; mask to leave bits 0-7
        LD      C,A             ; and store in C.
        LD      A,$10           ; initialize to 16d - INK.
        BIT     3,B             ; was it paper ?
        JR      NZ,L1105        ; forward to KEY-DATA with INK 16d and
                                ; colour in C.

        INC     A               ; else change from INK to PAPER (17d) if so.

;; KEY-DATA
L1105:  LD      (IY-$2D),C      ; put the colour (0-7)/state(0/1) in KDATA
        LD      DE,L110D        ; address: KEY-NEXT will be next input stream
        JR      L1113           ; forward to KEY-CHAN to change it ...

; ---

; ... so that INPUT_AD directs control to here at next call to WAIT-KEY

;; KEY-NEXT
L110D:  LD      A,($5C0D)       ; pick up the parameter stored in KDATA.
        LD      DE,L10A8        ; address: KEY-INPUT will be next input stream
                                ; continue to restore default channel and
                                ; make a return with the control code.

;; KEY-CHAN
L1113:  LD      HL,($5C4F)      ; address start of CHANNELS area using CHANS
                                ; system variable.
                                ; Note. One might have expected CURCHL to
                                ; have been used.
        INC     HL              ; step over the
        INC     HL              ; output address
        LD      (HL),E          ; and update the input
        INC     HL              ; routine address for
        LD      (HL),D          ; the next call to WAIT-KEY.

;; KEY-DONE2
L111B:  SCF                     ; set carry flag to show a key has been found
        RET                     ; and return.

; --------------------
; Lower screen copying
; --------------------
; This subroutine is called whenever the line in the editing area or
; input workspace is required to be printed to the lower screen.
; It is by calling this routine after any change that the cursor, for
; instance, appears to move to the left.
; Remember the edit line will contain characters and tokens
; e.g. "1000 LET a=1" is 8 characters.

;; ED-COPY
L111D:  CALL    L0D4D           ; routine TEMPS sets temporary attributes.
        RES     3,(IY+$02)      ; update TV_FLAG  - signal no change in mode
        RES     5,(IY+$02)      ; update TV_FLAG  - signal don't clear lower
                                ; screen.
        LD      HL,($5C8A)      ; fetch SPOSNL
        PUSH    HL              ; and save on stack.

        LD      HL,($5C3D)      ; fetch ERR_SP
        PUSH    HL              ; and save also
        LD      HL,L1167        ; address: ED-FULL
        PUSH    HL              ; is pushed as the error routine
        LD      ($5C3D),SP      ; and ERR_SP made to point to it.

        LD      HL,($5C82)      ; fetch ECHO_E
        PUSH    HL              ; and push also

        SCF                     ; set carry flag to control SET-DE
        CALL    L1195           ; call routine SET-DE
                                ; if in input DE = WORKSP
                                ; if in edit  DE = E_LINE
        EX      DE,HL           ; start address to HL

        CALL    L187D           ; routine OUT-LINE2 outputs entire line up to
                                ; carriage return including initial
                                ; characterized line number when present.
        EX      DE,HL           ; transfer new address to DE
        CALL    L18E1           ; routine OUT-CURS considers a
                                ; terminating cursor.

        LD      HL,($5C8A)      ; fetch updated SPOSNL
        EX      (SP),HL         ; exchange with ECHO_E on stack
        EX      DE,HL           ; transfer ECHO_E to DE
        CALL    L0D4D           ; routine TEMPS to re-set attributes
                                ; if altered.

; the lower screen was not cleared, at the outset, so if deleting then old
; text from a previous print may follow this line and requires blanking.

;; ED-BLANK
L1150:  LD      A,($5C8B)       ; fetch SPOSNL_hi is current line
        SUB     D               ; compare with old
        JR      C,L117C         ; forward to ED-C-DONE if no blanking

        JR      NZ,L115E        ; forward to ED-SPACES if line has changed

        LD      A,E             ; old column to A
        SUB     (IY+$50)        ; subtract new in SPOSNL_lo
        JR      NC,L117C        ; forward to ED-C-DONE if no backfilling.

;; ED-SPACES
L115E:  LD      A,$20           ; prepare a space.
        PUSH    DE              ; save old line/column.
        CALL    L09F4           ; routine PRINT-OUT prints a space over
                                ; any text from previous print.
                                ; Note. Since the blanking only occurs when
                                ; using $09F4 to print to the lower screen,
                                ; there is no need to vector via a RST 10
                                ; and we can use this alternate set.
        POP     DE              ; restore the old line column.
        JR      L1150           ; back to ED-BLANK until all old text blanked.

; -------------------------------
; THE 'EDITOR-FULL' ERROR ROUTINE
; -------------------------------
;   This is the error routine addressed by ERR_SP.  This is not for the out of
;   memory situation as we're just printing.  The pitch and duration are exactly
;   the same as used by ED-ERROR from which this has been augmented.  The
;   situation is that the lower screen is full and a rasp is given to suggest
;   that this is perhaps not the best idea you've had that day.

;; ED-FULL
L1167:  LD      D,$00           ; prepare to moan.
        LD      E,(IY-$02)      ; fetch RASP value.
        LD      HL,$1A90        ; set pitch or tone period.

        CALL    L03B5           ; routine BEEPER.

        LD      (IY+$00),$FF    ; clear ERR_NR.
        LD      DE,($5C8A)      ; fetch SPOSNL.
        JR      L117E           ; forward to ED-C-END

; -------

; the exit point from line printing continues here.

;; ED-C-DONE
L117C:  POP     DE              ; fetch new line/column.
        POP     HL              ; fetch the error address.

; the error path rejoins here.

;; ED-C-END
L117E:  POP     HL              ; restore the old value of ERR_SP.
        LD      ($5C3D),HL      ; update the system variable ERR_SP

        POP     BC              ; old value of SPOSN_L
        PUSH    DE              ; save new value

        CALL    L0DD9           ; routine CL-SET and PO-STORE
                                ; update ECHO_E and SPOSN_L from BC

        POP     HL              ; restore new value
        LD      ($5C82),HL      ; and overwrite ECHO_E

        LD      (IY+$26),$00    ; make error pointer X_PTR_hi out of bounds

        RET                     ; return

; -----------------------------------------------
; Point to first and last locations of work space
; -----------------------------------------------
;   These two nested routines ensure that the appropriate pointers are
;   selected for the editing area or workspace. The routines that call
;   these routines are designed to work on either area.

; this routine is called once

;; SET-HL
L1190:  LD      HL,($5C61)      ; fetch WORKSP to HL.
        DEC     HL              ; point to last location of editing area.
        AND     A               ; clear carry to limit exit points to first
                                ; or last.

; this routine is called with carry set and exits at a conditional return.

;; SET-DE
L1195:  LD      DE,($5C59)      ; fetch E_LINE to DE
        BIT     5,(IY+$37)      ; test FLAGX  - Input Mode ?
        RET     Z               ; return now if in editing mode

        LD      DE,($5C61)      ; fetch WORKSP to DE
        RET     C               ; return if carry set ( entry = set-de)

        LD      HL,($5C63)      ; fetch STKBOT to HL as well
        RET                     ; and return  (entry = set-hl (in input))

; -----------------------------------
; THE 'REMOVE FLOATING POINT' ROUTINE
; -----------------------------------
;   When a BASIC LINE or the INPUT BUFFER is parsed any numbers will have
;   an invisible chr 14d inserted after them and the 5-byte integer or
;   floating point form inserted after that.  Similar invisible value holders
;   are also created after the numeric and string variables in a DEF FN list.
;   This routine removes these 'compiled' numbers from the edit line or
;   input workspace.

;; REMOVE-FP
L11A7:  LD      A,(HL)          ; fetch character
        CP      $0E             ; is it the CHR$ 14 number marker ?
        LD      BC,$0006        ; prepare to strip six bytes

        CALL    Z,L19E8         ; routine RECLAIM-2 reclaims bytes if CHR$ 14.

        LD      A,(HL)          ; reload next (or same) character
        INC     HL              ; and advance address
        CP      $0D             ; end of line or input buffer ?
        JR      NZ,L11A7        ; back to REMOVE-FP until entire line done.

        RET                     ; return.
