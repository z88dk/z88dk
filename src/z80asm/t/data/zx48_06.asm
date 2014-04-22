; *********************************
; ** Part 6. EXECUTIVE ROUTINES  **
; *********************************

        PUBLIC L11B7
        PUBLIC L11CB
        PUBLIC L15D4
        PUBLIC L15E6
        PUBLIC L15EF
        PUBLIC L15F2
        PUBLIC L1601
        PUBLIC L160E
        PUBLIC L1615
        PUBLIC L1652
        PUBLIC L1655
        PUBLIC L1695
        PUBLIC L169E
        PUBLIC L16BF
        PUBLIC L16C5
        PUBLIC L16DC
        PUBLIC L16E5
        PUBLIC L1736
        PUBLIC L1793
        PUBLIC L1795
        PUBLIC L17F5
        PUBLIC L17F9
        PUBLIC L1855
        PUBLIC L187D
        PUBLIC L18E1
        PUBLIC L190F
        PUBLIC L191C
        PUBLIC L196E
        PUBLIC L198B
        PUBLIC L19B8
        PUBLIC L19E5
        PUBLIC L19E8
        PUBLIC L19FB
        PUBLIC L1A1B

        EXTERN L09F4
        EXTERN L0C0A
        EXTERN L0D4D
        EXTERN L0D6B
        EXTERN L0D6E
        EXTERN L0DAF
        EXTERN L0E44
        EXTERN L0ECD
        EXTERN L0EDF
        EXTERN L0F2C
        EXTERN L0F81
        EXTERN L1097
        EXTERN L10A8
        EXTERN L11A7
        EXTERN L1B17
        EXTERN L1B8A
        EXTERN L1BEE
        EXTERN L1C82
        EXTERN L1C8A
        EXTERN L1CDE
        EXTERN L1CE6
        EXTERN L1E94
        EXTERN L1E99
        EXTERN L1F05
        EXTERN L2070
        EXTERN L2530
        EXTERN L2BF1
        EXTERN L2D1B
        EXTERN L2D3B
        EXTERN L2DA2
	

; The memory.
;
; +---------+-----------+------------+--------------+-------------+--
; | BASIC   |  Display  | Attributes | ZX Printer   |    System   | 
; |  ROM    |   File    |    File    |   Buffer     |  Variables  | 
; +---------+-----------+------------+--------------+-------------+--
; ^         ^           ^            ^              ^             ^
; $0000   $4000       $5800        $5B00          $5C00         $5CB6 = CHANS 
;
;
;  --+----------+---+---------+-----------+---+------------+--+---+--
;    | Channel  |$80|  BASIC  | Variables |$80| Edit Line  |NL|$80|
;    |   Info   |   | Program |   Area    |   | or Command |  |   |
;  --+----------+---+---------+-----------+---+------------+--+---+--
;    ^              ^         ^               ^                   ^
;  CHANS           PROG      VARS           E_LINE              WORKSP
;
;
;                             ---5-->         <---2---  <--3---
;  --+-------+--+------------+-------+-------+---------+-------+-+---+------+
;    | INPUT |NL| Temporary  | Calc. | Spare | Machine | GOSUB |?|$3E| UDGs |
;    | data  |  | Work Space | Stack |       |  Stack  | Stack | |   |      |
;  --+-------+--+------------+-------+-------+---------+-------+-+---+------+
;    ^                       ^       ^       ^                   ^   ^      ^
;  WORKSP                  STKBOT  STKEND   sp               RAMTOP UDG  P_RAMT
;                                                                         

; -----------------
; THE 'NEW' COMMAND
; -----------------
;   The NEW command is about to set all RAM below RAMTOP to zero and then
;   re-initialize the system.  All RAM above RAMTOP should, and will be,
;   preserved.
;   There is nowhere to store values in RAM or on the stack which becomes
;   inoperable. Similarly PUSH and CALL instructions cannot be used to store
;   values or section common code. The alternate register set is the only place
;   available to store 3 persistent 16-bit system variables.

;; NEW
L11B7:  DI                      ; Disable Interrupts - machine stack will be
                                ; cleared.
        LD      A,$FF           ; Flag coming from NEW.
        LD      DE,($5CB2)      ; Fetch RAMTOP as top value.
        EXX                     ; Switch in alternate set.
        LD      BC,($5CB4)      ; Fetch P-RAMT differs on 16K/48K machines.
        LD      DE,($5C38)      ; Fetch RASP/PIP.
        LD      HL,($5C7B)      ; Fetch UDG    differs on 16K/48K machines.
        EXX                     ; Switch back to main set and continue into...

; ----------------------
; THE 'START-NEW' BRANCH     
; ----------------------
;   This branch is taken from above and from RST 00h.
;   The common code tests RAM and sets it to zero re-initializing all the 
;   non-zero system variables and channel information.  The A register flags 
;   if coming from START or NEW.

;; START-NEW
L11CB:  LD      B,A             ; Save the flag to control later branching.

        LD      A,$07           ; Select a white border
        OUT     ($FE),A         ; and set it now by writing to a port.

        LD      A,$3F           ; Load the accumulator with last page in ROM.
        LD      I,A             ; Set the I register - this remains constant
                                ; and can't be in the range $40 - $7F as 'snow'
                                ; appears on the screen.

        NOP                     ; These seem unnecessary.
        NOP                     ;
        NOP                     ;
        NOP                     ;
        NOP                     ;
        NOP                     ;

; -----------------------
; THE 'RAM CHECK' SECTION
; -----------------------
;   Typically, a Spectrum will have 16K or 48K of RAM and this code will test
;   it all till it finds an unpopulated location or, less likely, a faulty 
;   location.  Usually it stops when it reaches the top $FFFF, or in the case 
;   of NEW the supplied top value.  The entire screen turns black with 
;   sometimes red stripes on black paper just visible.

;; ram-check
L11DA:  LD      H,D             ; Transfer the top value to the HL register
        LD      L,E             ; pair.

;; RAM-FILL
L11DC:  LD      (HL),$02        ; Load memory with $02 - red ink on black paper.
        DEC     HL              ; Decrement memory address.
        CP      H               ; Have we reached ROM - $3F ?
        JR      NZ,L11DC        ; Back to RAM-FILL if not.

;; RAM-READ
L11E2:  AND     A               ; Clear carry - prepare to subtract.
        SBC     HL,DE           ; subtract and add back setting
        ADD     HL,DE           ; carry when back at start.
        INC     HL              ; and increment for next iteration.
        JR      NC,L11EF        ; forward to RAM-DONE if we've got back to
                                ; starting point with no errors.

        DEC     (HL)            ; decrement to 1.
        JR      Z,L11EF         ; forward to RAM-DONE if faulty.

        DEC     (HL)            ; decrement to zero.
        JR      Z,L11E2         ; back to RAM-READ if zero flag was set.

;; RAM-DONE
L11EF:  DEC     HL              ; step back to last valid location.
        EXX                     ; regardless of state, set up possibly
                                ; stored system variables in case from NEW.
        LD      ($5CB4),BC      ; insert P-RAMT.
        LD      ($5C38),DE      ; insert RASP/PIP.
        LD      ($5C7B),HL      ; insert UDG.
        EXX                     ; switch in main set.
        INC     B               ; now test if we arrived here from NEW.
        JR      Z,L1219         ; forward to RAM-SET if we did.

;   This section applies to START only.

        LD      ($5CB4),HL      ; set P-RAMT to the highest working RAM
                                ; address.
        LD      DE,$3EAF        ; address of last byte of 'U' bitmap in ROM.
        LD      BC,$00A8        ; there are 21 user defined graphics.
        EX      DE,HL           ; switch pointers and make the UDGs a
        LDDR                    ; copy of the standard characters A - U.
        EX      DE,HL           ; switch the pointer to HL.
        INC     HL              ; update to start of 'A' in RAM.
        LD      ($5C7B),HL      ; make UDG system variable address the first
                                ; bitmap.
        DEC     HL              ; point at RAMTOP again.

        LD      BC,$0040        ; set the values of
        LD      ($5C38),BC      ; the PIP and RASP system variables.

;   The NEW command path rejoins here.

;; RAM-SET
L1219:  LD      ($5CB2),HL      ; set system variable RAMTOP to HL.

;   
;   Note. this entry point is a disabled Warm Restart that was almost certainly
;   once pointed to by the System Variable NMIADD.  It would be essential that
;   any NMI Handler would perform the tasks from here to the EI instruction 
;   below.

;; NMI_VECT
L121C:
        LD      HL,$3C00        ; a strange place to set the pointer to the 
        LD      ($5C36),HL      ; character set, CHARS - as no printing yet.

        LD      HL,($5CB2)      ; fetch RAMTOP to HL again as we've lost it.

        LD      (HL),$3E        ; top of user ram holds GOSUB end marker
                                ; an impossible line number - see RETURN.
                                ; no significance in the number $3E. It has
                                ; been traditional since the ZX80.

        DEC     HL              ; followed by empty byte (not important).
        LD      SP,HL           ; set up the machine stack pointer.
        DEC     HL              ;
        DEC     HL              ;
        LD      ($5C3D),HL      ; ERR_SP is where the error pointer is
                                ; at moment empty - will take address MAIN-4
                                ; at the call preceding that address,
                                ; although interrupts and calls will make use
                                ; of this location in meantime.

        IM      1               ; select interrupt mode 1.

        LD      IY,$5C3A        ; set IY to ERR_NR. IY can reach all standard
                                ; system variables but shadow ROM system
                                ; variables will be mostly out of range.

        EI                      ; enable interrupts now that we have a stack.

;   If, as suggested above, the NMI service routine pointed to this section of
;   code then a decision would have to be made at this point to jump forward, 
;   in a Warm Restart scenario, to produce a report code, leaving any program 
;   intact.

        LD      HL,$5CB6        ; The address of the channels - initially
                                ; following system variables.
        LD      ($5C4F),HL      ; Set the CHANS system variable.

        LD      DE,L15AF        ; Address: init-chan in ROM.
        LD      BC,$0015        ; There are 21 bytes of initial data in ROM.
        EX      DE,HL           ; swap the pointers.
        LDIR                    ; Copy the bytes to RAM.

        EX      DE,HL           ; Swap pointers. HL points to program area.
        DEC     HL              ; Decrement address.
        LD      ($5C57),HL      ; Set DATADD to location before program area.
        INC     HL              ; Increment again.

        LD      ($5C53),HL      ; Set PROG the location where BASIC starts.
        LD      ($5C4B),HL      ; Set VARS to same location with a
        LD      (HL),$80        ; variables end-marker.
        INC     HL              ; Advance address.
        LD      ($5C59),HL      ; Set E_LINE, where the edit line
                                ; will be created.
                                ; Note. it is not strictly necessary to
                                ; execute the next fifteen bytes of code
                                ; as this will be done by the call to SET-MIN.
                                ; --
        LD      (HL),$0D        ; initially just has a carriage return
        INC     HL              ; followed by
        LD      (HL),$80        ; an end-marker.
        INC     HL              ; address the next location.
        LD      ($5C61),HL      ; set WORKSP - empty workspace.
        LD      ($5C63),HL      ; set STKBOT - bottom of the empty stack.
        LD      ($5C65),HL      ; set STKEND to the end of the empty stack.
                                ; --
        LD      A,$38           ; the colour system is set to white paper,
                                ; black ink, no flash or bright.
        LD      ($5C8D),A       ; set ATTR_P permanent colour attributes.
        LD      ($5C8F),A       ; set ATTR_T temporary colour attributes.
        LD      ($5C48),A       ; set BORDCR the border colour/lower screen
                                ; attributes.

        LD      HL,$0523        ; The keyboard repeat and delay values are 
        LD      ($5C09),HL      ; loaded to REPDEL and REPPER.

        DEC     (IY-$3A)        ; set KSTATE-0 to $FF - keyboard map available.
        DEC     (IY-$36)        ; set KSTATE-4 to $FF - keyboard map available.

        LD      HL,L15C6        ; set source to ROM Address: init-strm
        LD      DE,$5C10        ; set destination to system variable STRMS-FD
        LD      BC,$000E        ; copy the 14 bytes of initial 7 streams data
        LDIR                    ; from ROM to RAM.

        SET     1,(IY+$01)      ; update FLAGS  - signal printer in use.
        CALL    L0EDF           ; call routine CLEAR-PRB to initialize system
                                ; variables associated with printer.
                                ; The buffer is clear.

        LD      (IY+$31),$02    ; set DF_SZ the lower screen display size to
                                ; two lines
        CALL    L0D6B           ; call routine CLS to set up system
                                ; variables associated with screen and clear
                                ; the screen and set attributes.
        XOR     A               ; clear accumulator so that we can address
        LD      DE,L1539 - 1    ; the message table directly.
        CALL    L0C0A           ; routine PO-MSG puts
                                ; ' ©  1982 Sinclair Research Ltd'
                                ; at bottom of display.
        SET     5,(IY+$02)      ; update TV_FLAG  - signal lower screen will
                                ; require clearing.

        JR      L12A9           ; forward to MAIN-1

; -------------------------
; THE 'MAIN EXECUTION LOOP'
; -------------------------
;
;

;; MAIN-EXEC
L12A2:  LD      (IY+$31),$02    ; set DF_SZ lower screen display file size to 
                                ; two lines.
        CALL    L1795           ; routine AUTO-LIST

;; MAIN-1
L12A9:  CALL    L16B0           ; routine SET-MIN clears work areas.

;; MAIN-2
L12AC:  LD      A,$00           ; select channel 'K' the keyboard

        CALL    L1601           ; routine CHAN-OPEN opens it

        CALL    L0F2C           ; routine EDITOR is called.
                                ; Note the above routine is where the Spectrum
                                ; waits for user-interaction. Perhaps the
                                ; most common input at this stage
                                ; is LOAD "".

        CALL    L1B17           ; routine LINE-SCAN scans the input.

        BIT     7,(IY+$00)      ; test ERR_NR - will be $FF if syntax is OK.
        JR      NZ,L12CF        ; forward, if correct, to MAIN-3.

; 

        BIT     4,(IY+$30)      ; test FLAGS2 - K channel in use ?
        JR      Z,L1303         ; forward to MAIN-4 if not.

;

        LD      HL,($5C59)      ; an editing error so address E_LINE.
        CALL    L11A7           ; routine REMOVE-FP removes the hidden
                                ; floating-point forms.
        LD      (IY+$00),$FF    ; system variable ERR_NR is reset to 'OK'.
        JR      L12AC           ; back to MAIN-2 to allow user to correct.

; ---

; the branch was here if syntax has passed test.

;; MAIN-3
L12CF:  LD      HL,($5C59)      ; fetch the edit line address from E_LINE.

        LD      ($5C5D),HL      ; system variable CH_ADD is set to first
                                ; character of edit line.
                                ; Note. the above two instructions are a little
                                ; inadequate. 
                                ; They are repeated with a subtle difference 
                                ; at the start of the next subroutine and are 
                                ; therefore not required above.

        CALL    L19FB           ; routine E-LINE-NO will fetch any line
                                ; number to BC if this is a program line.

        LD      A,B             ; test if the number of
        OR      C               ; the line is non-zero.
        JP      NZ,L155D        ; jump forward to MAIN-ADD if so to add the 
                                ; line to the BASIC program.

; Has the user just pressed the ENTER key ?

        RST     18H             ; GET-CHAR gets character addressed by CH_ADD.
        CP      $0D             ; is it a carriage return ?
        JR      Z,L12A2         ; back to MAIN-EXEC if so for an automatic
                                ; listing.

; this must be a direct command.

        BIT     0,(IY+$30)      ; test FLAGS2 - clear the main screen ?

        CALL    NZ,L0DAF        ; routine CL-ALL, if so, e.g. after listing.

        CALL    L0D6E           ; routine CLS-LOWER anyway.

        LD      A,$19           ; compute scroll count as 25 minus
        SUB     (IY+$4F)        ; value of S_POSN_hi.
        LD      ($5C8C),A       ; update SCR_CT system variable.
        SET     7,(IY+$01)      ; update FLAGS - signal running program.
        LD      (IY+$00),$FF    ; set ERR_NR to 'OK'.
        LD      (IY+$0A),$01    ; set NSPPC to one for first statement.
        CALL    L1B8A           ; call routine LINE-RUN to run the line.
                                ; sysvar ERR_SP therefore addresses MAIN-4

; Examples of direct commands are RUN, CLS, LOAD "", PRINT USR 40000,
; LPRINT "A"; etc..
; If a user written machine-code program disables interrupts then it
; must enable them to pass the next step. We also jumped to here if the
; keyboard was not being used.

;; MAIN-4
L1303:  HALT                    ; wait for interrupt the only routine that can
                                ; set bit 5 of FLAGS.

        RES     5,(IY+$01)      ; update bit 5 of FLAGS - signal no new key.

        BIT     1,(IY+$30)      ; test FLAGS2 - is printer buffer clear ?
        CALL    NZ,L0ECD        ; call routine COPY-BUFF if not.
                                ; Note. the programmer has neglected
                                ; to set bit 1 of FLAGS first.

        LD      A,($5C3A)       ; fetch ERR_NR
        INC     A               ; increment to give true code.

; Now deal with a runtime error as opposed to an editing error.
; However if the error code is now zero then the OK message will be printed.

;; MAIN-G
L1313:  PUSH    AF              ; save the error number.

        LD      HL,$0000        ; prepare to clear some system variables.
        LD      (IY+$37),H      ; clear all the bits of FLAGX.
        LD      (IY+$26),H      ; blank X_PTR_hi to suppress error marker.
        LD      ($5C0B),HL      ; blank DEFADD to signal that no defined
                                ; function is currently being evaluated.

        LD      HL,$0001        ; explicit - inc hl would do.
        LD      ($5C16),HL      ; ensure STRMS-00 is keyboard.

        CALL    L16B0           ; routine SET-MIN clears workspace etc.
        RES     5,(IY+$37)      ; update FLAGX - signal in EDIT not INPUT mode.
                                ; Note. all the bits were reset earlier.

        CALL    L0D6E           ; call routine CLS-LOWER.

        SET     5,(IY+$02)      ; update TV_FLAG - signal lower screen
                                ; requires clearing.

        POP     AF              ; bring back the true error number
        LD      B,A             ; and make a copy in B.
        CP      $0A             ; is it a print-ready digit ?
        JR      C,L133C         ; forward to MAIN-5 if so.

        ADD     A,$07           ; add ASCII offset to letters.

;; MAIN-5
L133C:  CALL    L15EF           ; call routine OUT-CODE to print the code.

        LD      A,$20           ; followed by a space.
        RST     10H             ; PRINT-A

        LD      A,B             ; fetch stored report code.
        LD      DE,L1391        ; address: rpt-mesgs.

        CALL    L0C0A           ; call routine PO-MSG to print the message.

X1349:  XOR     A               ; clear accumulator to directly
        LD      DE,L1537 - 1    ; address the comma and space message.  

        CALL    L0C0A           ; routine PO-MSG prints ', ' although it would
                                ; be more succinct to use RST $10.

        LD      BC,($5C45)      ; fetch PPC the current line number.
        CALL    L1A1B           ; routine OUT-NUM-1 will print that

        LD      A,$3A           ; then a ':' character.
        RST     10H             ; PRINT-A

        LD      C,(IY+$0D)      ; then SUBPPC for statement
        LD      B,$00           ; limited to 127
        CALL    L1A1B           ; routine OUT-NUM-1 prints BC.

        CALL    L1097           ; routine CLEAR-SP clears editing area which 
                                ; probably contained 'RUN'.

        LD      A,($5C3A)       ; fetch ERR_NR again
        INC     A               ; test for no error originally $FF.
        JR      Z,L1386         ; forward to MAIN-9 if no error.

        CP      $09             ; is code Report 9 STOP ?
        JR      Z,L1373         ; forward to MAIN-6 if so

        CP      $15             ; is code Report L Break ?
        JR      NZ,L1376        ; forward to MAIN-7 if not

; Stop or Break was encountered so consider CONTINUE.

;; MAIN-6
L1373:  INC     (IY+$0D)        ; increment SUBPPC to next statement.

;; MAIN-7
L1376:  LD      BC,$0003        ; prepare to copy 3 system variables to
        LD      DE,$5C70        ; address OSPPC - statement for CONTINUE.
                                ; also updating OLDPPC line number below.

        LD      HL,$5C44        ; set source top to NSPPC next statement.
        BIT     7,(HL)          ; did BREAK occur before the jump ?
                                ; e.g. between GO TO and next statement.
        JR      Z,L1384         ; skip forward to MAIN-8, if not, as set-up
                                ; is correct.

        ADD     HL,BC           ; set source to SUBPPC number of current
                                ; statement/line which will be repeated.

;; MAIN-8
L1384:  LDDR                    ; copy PPC to OLDPPC and SUBPPC to OSPCC
                                ; or NSPPC to OLDPPC and NEWPPC to OSPCC

;; MAIN-9
L1386:  LD      (IY+$0A),$FF    ; update NSPPC - signal 'no jump'.
        RES     3,(IY+$01)      ; update FLAGS - signal use 'K' mode for
                                ; the first character in the editor and

        JP      L12AC           ; jump back to MAIN-2.


; ----------------------
; Canned report messages
; ----------------------
; The Error reports with the last byte inverted. The first entry
; is a dummy entry. The last, which begins with $7F, the Spectrum
; character for copyright symbol, is placed here for convenience
; as is the preceding comma and space.
; The report line must accommodate a 4-digit line number and a 3-digit
; statement number which limits the length of the message text to twenty 
; characters.
; e.g.  "B Integer out of range, 1000:127"

;; rpt-mesgs
L1391:  DEFB    $80
        DEFB    'O','K'+$80                             ; 0
        DEFM    "NEXT without FO"
        DEFB    'R'+$80                                 ; 1
        DEFM    "Variable not foun"
        DEFB    'd'+$80                                 ; 2
        DEFM    "Subscript wron"
        DEFB    'g'+$80                                 ; 3
        DEFM    "Out of memor"
        DEFB    'y'+$80                                 ; 4
        DEFM    "Out of scree"
        DEFB    'n'+$80                                 ; 5
        DEFM    "Number too bi"
        DEFB    'g'+$80                                 ; 6
        DEFM    "RETURN without GOSU"
        DEFB    'B'+$80                                 ; 7
        DEFM    "End of fil"
        DEFB    'e'+$80                                 ; 8
        DEFM    "STOP statemen"
        DEFB    't'+$80                                 ; 9
        DEFM    "Invalid argumen"
        DEFB    't'+$80                                 ; A
        DEFM    "Integer out of rang"
        DEFB    'e'+$80                                 ; B
        DEFM    "Nonsense in BASI"
        DEFB    'C'+$80                                 ; C
        DEFM    "BREAK - CONT repeat"
        DEFB    's'+$80                                 ; D
        DEFM    "Out of DAT"
        DEFB    'A'+$80                                 ; E
        DEFM    "Invalid file nam"
        DEFB    'e'+$80                                 ; F
        DEFM    "No room for lin"
        DEFB    'e'+$80                                 ; G
        DEFM    "STOP in INPU"
        DEFB    'T'+$80                                 ; H
        DEFM    "FOR without NEX"
        DEFB    'T'+$80                                 ; I
        DEFM    "Invalid I/O devic"
        DEFB    'e'+$80                                 ; J
        DEFM    "Invalid colou"
        DEFB    'r'+$80                                 ; K
        DEFM    "BREAK into progra"
        DEFB    'm'+$80                                 ; L
        DEFM    "RAMTOP no goo"
        DEFB    'd'+$80                                 ; M
        DEFM    "Statement los"
        DEFB    't'+$80                                 ; N
        DEFM    "Invalid strea"
        DEFB    'm'+$80                                 ; O
        DEFM    "FN without DE"
        DEFB    'F'+$80                                 ; P
        DEFM    "Parameter erro"
        DEFB    'r'+$80                                 ; Q
        DEFM    "Tape loading erro"
        DEFB    'r'+$80                                 ; R
;; comma-sp   
L1537:  DEFB    ',',' '+$80                             ; used in report line.
;; copyright
L1539:  DEFB    $7F                                     ; copyright
        DEFM    " 1982 Sinclair Research Lt"
        DEFB    'd'+$80


; -------------
; REPORT-G
; -------------
; Note ERR_SP points here during line entry which allows the
; normal 'Out of Memory' report to be augmented to the more
; precise 'No Room for line' report.

;; REPORT-G
; No Room for line
L1555:  LD      A,$10           ; i.e. 'G' -$30 -$07
        LD      BC,$0000        ; this seems unnecessary.
        JP      L1313           ; jump back to MAIN-G

; -----------------------------
; Handle addition of BASIC line
; -----------------------------
; Note this is not a subroutine but a branch of the main execution loop.
; System variable ERR_SP still points to editing error handler.
; A new line is added to the BASIC program at the appropriate place.
; An existing line with same number is deleted first.
; Entering an existing line number deletes that line.
; Entering a non-existent line allows the subsequent line to be edited next.

;; MAIN-ADD
L155D:  LD      ($5C49),BC      ; set E_PPC to extracted line number.
        LD      HL,($5C5D)      ; fetch CH_ADD - points to location after the
                                ; initial digits (set in E_LINE_NO).
        EX      DE,HL           ; save start of BASIC in DE.

        LD      HL,L1555        ; Address: REPORT-G
        PUSH    HL              ; is pushed on stack and addressed by ERR_SP.
                                ; the only error that can occur is
                                ; 'Out of memory'.

        LD      HL,($5C61)      ; fetch WORKSP - end of line.
        SCF                     ; prepare for true subtraction.
        SBC     HL,DE           ; find length of BASIC and
        PUSH    HL              ; save it on stack.
        LD      H,B             ; transfer line number
        LD      L,C             ; to HL register.
        CALL    L196E           ; routine LINE-ADDR will see if
                                ; a line with the same number exists.
        JR      NZ,L157D        ; forward if no existing line to MAIN-ADD1.

        CALL    L19B8           ; routine NEXT-ONE finds the existing line.
        CALL    L19E8           ; routine RECLAIM-2 reclaims it.

;; MAIN-ADD1
L157D:  POP     BC              ; retrieve the length of the new line.
        LD      A,C             ; and test if carriage return only
        DEC     A               ; i.e. one byte long.
        OR      B               ; result would be zero.
        JR      Z,L15AB         ; forward to MAIN-ADD2 is so.

        PUSH    BC              ; save the length again.
        INC     BC              ; adjust for inclusion
        INC     BC              ; of line number (two bytes)
        INC     BC              ; and line length
        INC     BC              ; (two bytes).
        DEC     HL              ; HL points to location before the destination

        LD      DE,($5C53)      ; fetch the address of PROG
        PUSH    DE              ; and save it on the stack
        CALL    L1655           ; routine MAKE-ROOM creates BC spaces in
                                ; program area and updates pointers.
        POP     HL              ; restore old program pointer.
        LD      ($5C53),HL      ; and put back in PROG as it may have been
                                ; altered by the POINTERS routine.

        POP     BC              ; retrieve BASIC length
        PUSH    BC              ; and save again.

        INC     DE              ; points to end of new area.
        LD      HL,($5C61)      ; set HL to WORKSP - location after edit line.
        DEC     HL              ; decrement to address end marker.
        DEC     HL              ; decrement to address carriage return.
        LDDR                    ; copy the BASIC line back to initial command.

        LD      HL,($5C49)      ; fetch E_PPC - line number.
        EX      DE,HL           ; swap it to DE, HL points to last of
                                ; four locations.
        POP     BC              ; retrieve length of line.
        LD      (HL),B          ; high byte last.
        DEC     HL              ;
        LD      (HL),C          ; then low byte of length.
        DEC     HL              ;
        LD      (HL),E          ; then low byte of line number.
        DEC     HL              ;
        LD      (HL),D          ; then high byte range $0 - $27 (1-9999).

;; MAIN-ADD2
L15AB:  POP     AF              ; drop the address of Report G
        JP      L12A2           ; and back to MAIN-EXEC producing a listing
                                ; and to reset ERR_SP in EDITOR.


; ---------------------------------
; THE 'INITIAL CHANNEL' INFORMATION
; ---------------------------------
;   This initial channel information is copied from ROM to RAM, during 
;   initialization.  It's new location is after the system variables and is 
;   addressed by the system variable CHANS which means that it can slide up and
;   down in memory.  The table is never searched, by this ROM, and the last 
;   character, which could be anything other than a comma, provides a 
;   convenient resting place for DATADD.

;; init-chan
L15AF:  DEFW    L09F4           ; PRINT-OUT
        DEFW    L10A8           ; KEY-INPUT
        DEFB    $4B             ; 'K'
        DEFW    L09F4           ; PRINT-OUT
        DEFW    L15C4           ; REPORT-J
        DEFB    $53             ; 'S'
        DEFW    L0F81           ; ADD-CHAR
        DEFW    L15C4           ; REPORT-J
        DEFB    $52             ; 'R'
        DEFW    L09F4           ; PRINT-OUT
        DEFW    L15C4           ; REPORT-J
        DEFB    $50             ; 'P'

        DEFB    $80             ; End Marker

;; REPORT-J
L15C4:  RST     08H             ; ERROR-1
        DEFB    $12             ; Error Report: Invalid I/O device


; -------------------------
; THE 'INITIAL STREAM' DATA
; -------------------------
;   This is the initial stream data for the seven streams $FD - $03 that is
;   copied from ROM to the STRMS system variables area during initialization.
;   There are reserved locations there for another 12 streams.  Each location 
;   contains an offset to the second byte of a channel.  The first byte of a 
;   channel can't be used as that would result in an offset of zero for some 
;   and zero is used to denote that a stream is closed.

;; init-strm
L15C6:  DEFB    $01, $00        ; stream $FD offset to channel 'K'
        DEFB    $06, $00        ; stream $FE offset to channel 'S'
        DEFB    $0B, $00        ; stream $FF offset to channel 'R'

        DEFB    $01, $00        ; stream $00 offset to channel 'K'
        DEFB    $01, $00        ; stream $01 offset to channel 'K'
        DEFB    $06, $00        ; stream $02 offset to channel 'S'
        DEFB    $10, $00        ; stream $03 offset to channel 'P'

; ------------------------------
; THE 'INPUT CONTROL' SUBROUTINE
; ------------------------------
;

;; WAIT-KEY
L15D4:  BIT     5,(IY+$02)      ; test TV_FLAG - clear lower screen ?
        JR      NZ,L15DE        ; forward to WAIT-KEY1 if so.

        SET     3,(IY+$02)      ; update TV_FLAG - signal reprint the edit
                                ; line to the lower screen.

;; WAIT-KEY1
L15DE:  CALL    L15E6           ; routine INPUT-AD is called.

        RET     C               ; return with acceptable keys.

        JR      Z,L15DE         ; back to WAIT-KEY1 if no key is pressed
                                ; or it has been handled within INPUT-AD.

;   Note. When inputting from the keyboard all characters are returned with
;   above conditions so this path is never taken.

;; REPORT-8
L15E4:  RST     08H             ; ERROR-1
        DEFB    $07             ; Error Report: End of file

; ---------------------------
; THE 'INPUT ADDRESS' ROUTINE
; ---------------------------
;   This routine fetches the address of the input stream from the current 
;   channel area using the system variable CURCHL.

;; INPUT-AD
L15E6:  EXX                     ; switch in alternate set.
        PUSH    HL              ; save HL register
        LD      HL,($5C51)      ; fetch address of CURCHL - current channel.
        INC     HL              ; step over output routine
        INC     HL              ; to point to low byte of input routine.
        JR      L15F7           ; forward to CALL-SUB.

; -------------------------
; THE 'CODE OUTPUT' ROUTINE
; -------------------------
;   This routine is called on five occasions to print the ASCII equivalent of 
;   a value 0-9.

;; OUT-CODE
L15EF:  LD      E,$30           ; add 48 decimal to give the ASCII character 
        ADD     A,E             ; '0' to '9' and continue into the main output
                                ; routine.

; -------------------------
; THE 'MAIN OUTPUT' ROUTINE
; -------------------------
;   PRINT-A-2 is a continuation of the RST 10 restart that prints any character.
;   The routine prints to the current channel and the printing of control codes
;   may alter that channel to divert subsequent RST 10 instructions to temporary
;   routines. The normal channel is $09F4.

;; PRINT-A-2
L15F2:  EXX                     ; switch in alternate set
        PUSH    HL              ; save HL register
        LD      HL,($5C51)      ; fetch CURCHL the current channel.

; input-ad rejoins here also.

;; CALL-SUB
L15F7:  LD      E,(HL)          ; put the low byte in E.
        INC     HL              ; advance address.
        LD      D,(HL)          ; put the high byte to D.
        EX      DE,HL           ; transfer the stream to HL.
        CALL    L162C           ; use routine CALL-JUMP.
                                ; in effect CALL (HL).

        POP     HL              ; restore saved HL register.
        EXX                     ; switch back to the main set and
        RET                     ; return.

; --------------------------
; THE 'OPEN CHANNEL' ROUTINE
; --------------------------
;   This subroutine is used by the ROM to open a channel 'K', 'S', 'R' or 'P'.
;   This is either for its own use or in response to a user's request, for
;   example, when '#' is encountered with output - PRINT, LIST etc.
;   or with input - INPUT, INKEY$ etc.
;   It is entered with a system stream $FD - $FF, or a user stream $00 - $0F
;   in the accumulator.

;; CHAN-OPEN
L1601:  ADD     A,A             ; double the stream ($FF will become $FE etc.)
        ADD     A,$16           ; add the offset to stream 0 from $5C00
        LD      L,A             ; result to L
        LD      H,$5C           ; now form the address in STRMS area.
        LD      E,(HL)          ; fetch low byte of CHANS offset
        INC     HL              ; address next
        LD      D,(HL)          ; fetch high byte of offset
        LD      A,D             ; test that the stream is open.
        OR      E               ; zero if closed.
        JR      NZ,L1610        ; forward to CHAN-OP-1 if open.

;; REPORT-Oa
L160E:  RST     08H             ; ERROR-1
        DEFB    $17             ; Error Report: Invalid stream

; continue here if stream was open. Note that the offset is from CHANS
; to the second byte of the channel.

;; CHAN-OP-1
L1610:  DEC     DE              ; reduce offset so it points to the channel.
        LD      HL,($5C4F)      ; fetch CHANS the location of the base of
                                ; the channel information area
        ADD     HL,DE           ; and add the offset to address the channel.
                                ; and continue to set flags.

; -----------------
; Set channel flags
; -----------------
; This subroutine is used from ED-EDIT, str$ and read-in to reset the
; current channel when it has been temporarily altered.

;; CHAN-FLAG
L1615:  LD      ($5C51),HL      ; set CURCHL system variable to the
                                ; address in HL
        RES     4,(IY+$30)      ; update FLAGS2  - signal K channel not in use.
                                ; Note. provide a default for channel 'R'.
        INC     HL              ; advance past
        INC     HL              ; output routine.
        INC     HL              ; advance past
        INC     HL              ; input routine.
        LD      C,(HL)          ; pick up the letter.
        LD      HL,L162D        ; address: chn-cd-lu
        CALL    L16DC           ; routine INDEXER finds offset to a
                                ; flag-setting routine.

        RET     NC              ; but if the letter wasn't found in the
                                ; table just return now. - channel 'R'.

        LD      D,$00           ; prepare to add
        LD      E,(HL)          ; offset to E
        ADD     HL,DE           ; add offset to location of offset to form
                                ; address of routine

;; CALL-JUMP
L162C:  JP      (HL)            ; jump to the routine

; Footnote. calling any location that holds JP (HL) is the equivalent to
; a pseudo Z80 instruction CALL (HL). The ROM uses the instruction above.

; --------------------------
; Channel code look-up table
; --------------------------
; This table is used by the routine above to find one of the three
; flag setting routines below it.
; A zero end-marker is required as channel 'R' is not present.

;; chn-cd-lu
L162D:  DEFB    'K', L1634-ASMPC-1  ; offset $06 to CHAN-K
        DEFB    'S', L1642-ASMPC-1  ; offset $12 to CHAN-S
        DEFB    'P', L164D-ASMPC-1  ; offset $1B to CHAN-P

        DEFB    $00             ; end marker.

; --------------
; Channel K flag
; --------------
; routine to set flags for lower screen/keyboard channel.

;; CHAN-K
L1634:  SET     0,(IY+$02)      ; update TV_FLAG  - signal lower screen in use
        RES     5,(IY+$01)      ; update FLAGS    - signal no new key
        SET     4,(IY+$30)      ; update FLAGS2   - signal K channel in use
        JR      L1646           ; forward to CHAN-S-1 for indirect exit

; --------------
; Channel S flag
; --------------
; routine to set flags for upper screen channel.

;; CHAN-S
L1642:  RES     0,(IY+$02)      ; TV_FLAG  - signal main screen in use

;; CHAN-S-1
L1646:  RES     1,(IY+$01)      ; update FLAGS  - signal printer not in use
        JP      L0D4D           ; jump back to TEMPS and exit via that
                                ; routine after setting temporary attributes.
; --------------
; Channel P flag
; --------------
; This routine sets a flag so that subsequent print related commands
; print to printer or update the relevant system variables.
; This status remains in force until reset by the routine above.

;; CHAN-P
L164D:  SET     1,(IY+$01)      ; update FLAGS  - signal printer in use
        RET                     ; return

; --------------------------
; THE 'ONE SPACE' SUBROUTINE
; --------------------------
; This routine is called once only to create a single space
; in workspace by ADD-CHAR. 

;; ONE-SPACE
L1652:  LD      BC,$0001        ; create space for a single character.

; ---------
; Make Room
; ---------
; This entry point is used to create BC spaces in various areas such as
; program area, variables area, workspace etc..
; The entire free RAM is available to each BASIC statement.
; On entry, HL addresses where the first location is to be created.
; Afterwards, HL will point to the location before this.

;; MAKE-ROOM
L1655:  PUSH    HL              ; save the address pointer.
        CALL    L1F05           ; routine TEST-ROOM checks if room
                                ; exists and generates an error if not.
        POP     HL              ; restore the address pointer.
        CALL    L1664           ; routine POINTERS updates the
                                ; dynamic memory location pointers.
                                ; DE now holds the old value of STKEND.
        LD      HL,($5C65)      ; fetch new STKEND the top destination.

        EX      DE,HL           ; HL now addresses the top of the area to
                                ; be moved up - old STKEND.
        LDDR                    ; the program, variables, etc are moved up.
        RET                     ; return with new area ready to be populated.
                                ; HL points to location before new area,
                                ; and DE to last of new locations.

; -----------------------------------------------
; Adjust pointers before making or reclaiming room
; -----------------------------------------------
; This routine is called by MAKE-ROOM to adjust upwards and by RECLAIM to
; adjust downwards the pointers within dynamic memory.
; The fourteen pointers to dynamic memory, starting with VARS and ending 
; with STKEND, are updated adding BC if they are higher than the position
; in HL.  
; The system variables are in no particular order except that STKEND, the first
; free location after dynamic memory must be the last encountered.

;; POINTERS
L1664:  PUSH    AF              ; preserve accumulator.
        PUSH    HL              ; put pos pointer on stack.
        LD      HL,$5C4B        ; address VARS the first of the
        LD      A,$0E           ; fourteen variables to consider.

;; PTR-NEXT
L166B:  LD      E,(HL)          ; fetch the low byte of the system variable.
        INC     HL              ; advance address.
        LD      D,(HL)          ; fetch high byte of the system variable.
        EX      (SP),HL         ; swap pointer on stack with the variable
                                ; pointer.
        AND     A               ; prepare to subtract.
        SBC     HL,DE           ; subtract variable address
        ADD     HL,DE           ; and add back
        EX      (SP),HL         ; swap pos with system variable pointer
        JR      NC,L167F        ; forward to PTR-DONE if var before pos

        PUSH    DE              ; save system variable address.
        EX      DE,HL           ; transfer to HL
        ADD     HL,BC           ; add the offset
        EX      DE,HL           ; back to DE
        LD      (HL),D          ; load high byte
        DEC     HL              ; move back
        LD      (HL),E          ; load low byte
        INC     HL              ; advance to high byte
        POP     DE              ; restore old system variable address.

;; PTR-DONE
L167F:  INC     HL              ; address next system variable.
        DEC     A               ; decrease counter.
        JR      NZ,L166B        ; back to PTR-NEXT if more.
        EX      DE,HL           ; transfer old value of STKEND to HL.
                                ; Note. this has always been updated.
        POP     DE              ; pop the address of the position.

        POP     AF              ; pop preserved accumulator.
        AND     A               ; clear carry flag preparing to subtract.

        SBC     HL,DE           ; subtract position from old stkend 
        LD      B,H             ; to give number of data bytes
        LD      C,L             ; to be moved.
        INC     BC              ; increment as we also copy byte at old STKEND.
        ADD     HL,DE           ; recompute old stkend.
        EX      DE,HL           ; transfer to DE.
        RET                     ; return.



; -------------------
; Collect line number
; -------------------
; This routine extracts a line number, at an address that has previously
; been found using LINE-ADDR, and it is entered at LINE-NO. If it encounters
; the program 'end-marker' then the previous line is used and if that
; should also be unacceptable then zero is used as it must be a direct
; command. The program end-marker is the variables end-marker $80, or
; if variables exist, then the first character of any variable name.

;; LINE-ZERO
L168F:  DEFB    $00, $00        ; dummy line number used for direct commands


;; LINE-NO-A
L1691:  EX      DE,HL           ; fetch the previous line to HL and set
        LD      DE,L168F        ; DE to LINE-ZERO should HL also fail.

; -> The Entry Point.

;; LINE-NO
L1695:  LD      A,(HL)          ; fetch the high byte - max $2F
        AND     $C0             ; mask off the invalid bits.
        JR      NZ,L1691        ; to LINE-NO-A if an end-marker.

        LD      D,(HL)          ; reload the high byte.
        INC     HL              ; advance address.
        LD      E,(HL)          ; pick up the low byte.
        RET                     ; return from here.

; -------------------
; Handle reserve room
; -------------------
; This is a continuation of the restart BC-SPACES

;; RESERVE
L169E:  LD      HL,($5C63)      ; STKBOT first location of calculator stack
        DEC     HL              ; make one less than new location
        CALL    L1655           ; routine MAKE-ROOM creates the room.
        INC     HL              ; address the first new location
        INC     HL              ; advance to second
        POP     BC              ; restore old WORKSP
        LD      ($5C61),BC      ; system variable WORKSP was perhaps
                                ; changed by POINTERS routine.
        POP     BC              ; restore count for return value.
        EX      DE,HL           ; switch. DE = location after first new space
        INC     HL              ; HL now location after new space
        RET                     ; return.

; ---------------------------
; Clear various editing areas
; ---------------------------
; This routine sets the editing area, workspace and calculator stack
; to their minimum configurations as at initialization and indeed this
; routine could have been relied on to perform that task.
; This routine uses HL only and returns with that register holding
; WORKSP/STKBOT/STKEND though no use is made of this. The routines also
; reset MEM to its usual place in the systems variable area should it
; have been relocated to a FOR-NEXT variable. The main entry point
; SET-MIN is called at the start of the MAIN-EXEC loop and prior to
; displaying an error.

;; SET-MIN
L16B0:  LD      HL,($5C59)      ; fetch E_LINE
        LD      (HL),$0D        ; insert carriage return
        LD      ($5C5B),HL      ; make K_CUR keyboard cursor point there.
        INC     HL              ; next location
        LD      (HL),$80        ; holds end-marker $80
        INC     HL              ; next location becomes
        LD      ($5C61),HL      ; start of WORKSP

; This entry point is used prior to input and prior to the execution,
; or parsing, of each statement.

;; SET-WORK
L16BF:  LD      HL,($5C61)      ; fetch WORKSP value
        LD      ($5C63),HL      ; and place in STKBOT

; This entry point is used to move the stack back to its normal place
; after temporary relocation during line entry and also from ERROR-3

;; SET-STK
L16C5:  LD      HL,($5C63)      ; fetch STKBOT value 
        LD      ($5C65),HL      ; and place in STKEND.

        PUSH    HL              ; perhaps an obsolete entry point.
        LD      HL,$5C92        ; normal location of MEM-0
        LD      ($5C68),HL      ; is restored to system variable MEM.
        POP     HL              ; saved value not required.
        RET                     ; return.

; ------------------
; Reclaim edit-line?
; ------------------
; This seems to be legacy code from the ZX80/ZX81 as it is 
; not used in this ROM.
; That task, in fact, is performed here by the dual-area routine CLEAR-SP.
; This routine is designed to deal with something that is known to be in the
; edit buffer and not workspace.
; On entry, HL must point to the end of the something to be deleted.

;; REC-EDIT
L16D4:  LD      DE,($5C59)      ; fetch start of edit line from E_LINE.
        JP      L19E5           ; jump forward to RECLAIM-1.

; --------------------------
; The Table INDEXING routine
; --------------------------
; This routine is used to search two-byte hash tables for a character
; held in C, returning the address of the following offset byte.
; if it is known that the character is in the table e.g. for priorities,
; then the table requires no zero end-marker. If this is not known at the
; outset then a zero end-marker is required and carry is set to signal
; success.

;; INDEXER-1
L16DB:  INC     HL              ; address the next pair of values.

; -> The Entry Point.

;; INDEXER
L16DC:  LD      A,(HL)          ; fetch the first byte of pair
        AND     A               ; is it the end-marker ?
        RET     Z               ; return with carry reset if so.

        CP      C               ; is it the required character ?
        INC     HL              ; address next location.
        JR      NZ,L16DB        ; back to INDEXER-1 if no match.

        SCF                     ; else set the carry flag.
        RET                     ; return with carry set

; --------------------------------
; The Channel and Streams Routines
; --------------------------------
; A channel is an input/output route to a hardware device
; and is identified to the system by a single letter e.g. 'K' for
; the keyboard. A channel can have an input and output route
; associated with it in which case it is bi-directional like
; the keyboard. Others like the upper screen 'S' are output
; only and the input routine usually points to a report message.
; Channels 'K' and 'S' are system channels and it would be inappropriate
; to close the associated streams so a mechanism is provided to
; re-attach them. When the re-attachment is no longer required, then
; closing these streams resets them as at initialization.
; Early adverts said that the network and RS232 were in this ROM. 
; Channels 'N' and 'B' are user channels and have been removed successfully 
; if, as seems possible, they existed.
; Ironically the tape streamer is not accessed through streams and
; channels.
; Early demonstrations of the Spectrum showed a single microdrive being
; controlled by the main ROM.

; ---------------------
; THE 'CLOSE #' COMMAND
; ---------------------
;   This command allows streams to be closed after use.
;   Any temporary memory areas used by the stream would be reclaimed and
;   finally flags set or reset if necessary.

;; CLOSE
L16E5:  CALL    L171E           ; routine STR-DATA fetches parameter
                                ; from calculator stack and gets the
                                ; existing STRMS data pointer address in HL
                                ; and stream offset from CHANS in BC.

                                ; Note. this offset could be zero if the
                                ; stream is already closed. A check for this
                                ; should occur now and an error should be
                                ; generated, for example,
                                ; Report S 'Stream status closed'.

        CALL    L1701           ; routine CLOSE-2 would perform any actions
                                ; peculiar to that stream without disturbing
                                ; data pointer to STRMS entry in HL.

        LD      BC,$0000        ; the stream is to be blanked.
        LD      DE,$A3E2        ; the number of bytes from stream 4, $5C1E,
                                ; to $10000
        EX      DE,HL           ; transfer offset to HL, STRMS data pointer
                                ; to DE.
        ADD     HL,DE           ; add the offset to the data pointer.  
        JR      C,L16FC         ; forward to CLOSE-1 if a non-system stream.
                                ; i.e. higher than 3. 

; proceed with a negative result.

        LD      BC,L15C6 + 14   ; prepare the address of the byte after
                                ; the initial stream data in ROM. ($15D4)
        ADD     HL,BC           ; index into the data table with negative value.
        LD      C,(HL)          ; low byte to C
        INC     HL              ; address next.
        LD      B,(HL)          ; high byte to B.

;   and for streams 0 - 3 just enter the initial data back into the STRMS entry
;   streams 0 - 2 can't be closed as they are shared by the operating system.
;   -> for streams 4 - 15 then blank the entry.

;; CLOSE-1
L16FC:  EX      DE,HL           ; address of stream to HL.
        LD      (HL),C          ; place zero (or low byte).
        INC     HL              ; next address.
        LD      (HL),B          ; place zero (or high byte).
        RET                     ; return.

; ------------------------
; THE 'CLOSE-2' SUBROUTINE
; ------------------------
;   There is not much point in coming here.
;   The purpose was once to find the offset to a special closing routine,
;   in this ROM and within 256 bytes of the close stream look up table that
;   would reclaim any buffers associated with a stream. At least one has been
;   removed.
;   Any attempt to CLOSE streams $00 to $04, without first opening the stream,
;   will lead to either a system restart or the production of a strange report.
;   credit: Martin Wren-Hilton 1982.

;; CLOSE-2
L1701:  PUSH    HL              ; * save address of stream data pointer
                                ; in STRMS on the machine stack.
        LD      HL,($5C4F)      ; fetch CHANS address to HL
        ADD     HL,BC           ; add the offset to address the second
                                ; byte of the output routine hopefully.
        INC     HL              ; step past
        INC     HL              ; the input routine.

;    Note. When the Sinclair Interface1 is fitted then an instruction fetch 
;    on the next address pages this ROM out and the shadow ROM in.

;; ROM_TRAP
L1708:  INC     HL              ; to address channel's letter
        LD      C,(HL)          ; pick it up in C.
                                ; Note. but if stream is already closed we
                                ; get the value $10 (the byte preceding 'K').

        EX      DE,HL           ; save the pointer to the letter in DE.

;   Note. The string pointer is saved but not used!!

        LD      HL,L1716        ; address: cl-str-lu in ROM.
        CALL    L16DC           ; routine INDEXER uses the code to get 
                                ; the 8-bit offset from the current point to
                                ; the address of the closing routine in ROM.
                                ; Note. it won't find $10 there!

        LD      C,(HL)          ; transfer the offset to C.
        LD      B,$00           ; prepare to add.
        ADD     HL,BC           ; add offset to point to the address of the
                                ; routine that closes the stream.
                                ; (and presumably removes any buffers that
                                ; are associated with it.)
        JP      (HL)            ; jump to that routine.

; --------------------------------
; THE 'CLOSE STREAM LOOK-UP' TABLE
; --------------------------------
;   This table contains an entry for a letter found in the CHANS area.
;   followed by an 8-bit displacement, from that byte's address in the
;   table to the routine that performs any ancillary actions associated
;   with closing the stream of that channel.
;   The table doesn't require a zero end-marker as the letter has been
;   picked up from a channel that has an open stream.

;; cl-str-lu
L1716:  DEFB    'K', L171C-ASMPC-1  ; offset 5 to CLOSE-STR
        DEFB    'S', L171C-ASMPC-1  ; offset 3 to CLOSE-STR
        DEFB    'P', L171C-ASMPC-1  ; offset 1 to CLOSE-STR


; ------------------------------
; THE 'CLOSE STREAM' SUBROUTINES
; ------------------------------
; The close stream routines in fact have no ancillary actions to perform
; which is not surprising with regard to 'K' and 'S'.

;; CLOSE-STR                    
L171C:  POP     HL              ; * now just restore the stream data pointer
        RET                     ; in STRMS and return.

; -----------
; Stream data
; -----------
; This routine finds the data entry in the STRMS area for the specified
; stream which is passed on the calculator stack. It returns with HL
; pointing to this system variable and BC holding a displacement from
; the CHANS area to the second byte of the stream's channel. If BC holds
; zero, then that signifies that the stream is closed.

;; STR-DATA
L171E:  CALL    L1E94           ; routine FIND-INT1 fetches parameter to A
        CP      $10             ; is it less than 16d ?
        JR      C,L1727         ; skip forward to STR-DATA1 if so.

;; REPORT-Ob
L1725:  RST     08H             ; ERROR-1
        DEFB    $17             ; Error Report: Invalid stream

;; STR-DATA1
L1727:  ADD     A,$03           ; add the offset for 3 system streams.
                                ; range 00 - 15d becomes 3 - 18d.
        RLCA                    ; double as there are two bytes per 
                                ; stream - now 06 - 36d
        LD      HL,$5C10        ; address STRMS - the start of the streams
                                ; data area in system variables.
        LD      C,A             ; transfer the low byte to A.
        LD      B,$00           ; prepare to add offset.
        ADD     HL,BC           ; add to address the data entry in STRMS.

; the data entry itself contains an offset from CHANS to the address of the
; stream

        LD      C,(HL)          ; low byte of displacement to C.
        INC     HL              ; address next.
        LD      B,(HL)          ; high byte of displacement to B.
        DEC     HL              ; step back to leave HL pointing to STRMS
                                ; data entry.
        RET                     ; return with CHANS displacement in BC
                                ; and address of stream data entry in HL.

; --------------------
; Handle OPEN# command
; --------------------
; Command syntax example: OPEN #5,"s"
; On entry the channel code entry is on the calculator stack with the next
; value containing the stream identifier. They have to swapped.

;; OPEN
L1736:  RST     28H             ;; FP-CALC    ;s,c.
        DEFB    $01             ;;exchange    ;c,s.
        DEFB    $38             ;;end-calc

        CALL    L171E           ; routine STR-DATA fetches the stream off
                                ; the stack and returns with the CHANS
                                ; displacement in BC and HL addressing 
                                ; the STRMS data entry.
        LD      A,B             ; test for zero which
        OR      C               ; indicates the stream is closed.
        JR      Z,L1756         ; skip forward to OPEN-1 if so.

; if it is a system channel then it can re-attached.

        EX      DE,HL           ; save STRMS address in DE.
        LD      HL,($5C4F)      ; fetch CHANS.
        ADD     HL,BC           ; add the offset to address the second 
                                ; byte of the channel.
        INC     HL              ; skip over the
        INC     HL              ; input routine.
        INC     HL              ; and address the letter.
        LD      A,(HL)          ; pick up the letter.
        EX      DE,HL           ; save letter pointer and bring back
                                ; the STRMS pointer.

        CP      $4B             ; is it 'K' ?
        JR      Z,L1756         ; forward to OPEN-1 if so

        CP      $53             ; is it 'S' ?
        JR      Z,L1756         ; forward to OPEN-1 if so

        CP      $50             ; is it 'P' ?
        JR      NZ,L1725        ; back to REPORT-Ob if not.
                                ; to report 'Invalid stream'.

; continue if one of the upper-case letters was found.
; and rejoin here from above if stream was closed.

;; OPEN-1
L1756:  CALL    L175D           ; routine OPEN-2 opens the stream.

; it now remains to update the STRMS variable.

        LD      (HL),E          ; insert or overwrite the low byte.
        INC     HL              ; address high byte in STRMS.
        LD      (HL),D          ; insert or overwrite the high byte.
        RET                     ; return.

; -----------------
; OPEN-2 Subroutine
; -----------------
; There is some point in coming here as, as well as once creating buffers,
; this routine also sets flags.

;; OPEN-2
L175D:  PUSH    HL              ; * save the STRMS data entry pointer.
        CALL    L2BF1           ; routine STK-FETCH now fetches the
                                ; parameters of the channel string.
                                ; start in DE, length in BC.

        LD      A,B             ; test that it is not
        OR      C               ; the null string.
        JR      NZ,L1767        ; skip forward to OPEN-3 with 1 character
                                ; or more!

;; REPORT-Fb
L1765:  RST     08H             ; ERROR-1
        DEFB    $0E             ; Error Report: Invalid file name

;; OPEN-3
L1767:  PUSH    BC              ; save the length of the string.
        LD      A,(DE)          ; pick up the first character.
                                ; Note. There can be more than one character.
        AND     $DF             ; make it upper-case.
        LD      C,A             ; place it in C.
        LD      HL,L177A        ; address: op-str-lu is loaded.
        CALL    L16DC           ; routine INDEXER will search for letter.
        JR      NC,L1765        ; back to REPORT-F if not found
                                ; 'Invalid filename'

        LD      C,(HL)          ; fetch the displacement to opening routine.
        LD      B,$00           ; prepare to add.
        ADD     HL,BC           ; now form address of opening routine.
        POP     BC              ; restore the length of string.
        JP      (HL)            ; now jump forward to the relevant routine.

; -------------------------
; OPEN stream look-up table
; -------------------------
; The open stream look-up table consists of matched pairs.
; The channel letter is followed by an 8-bit displacement to the
; associated stream-opening routine in this ROM.
; The table requires a zero end-marker as the letter has been
; provided by the user and not the operating system.

;; op-str-lu
L177A:  DEFB    'K', L1781-ASMPC-1  ; $06 offset to OPEN-K
        DEFB    'S', L1785-ASMPC-1  ; $08 offset to OPEN-S
        DEFB    'P', L1789-ASMPC-1  ; $0A offset to OPEN-P

        DEFB    $00             ; end-marker.

; ----------------------------
; The Stream Opening Routines.
; ----------------------------
; These routines would have opened any buffers associated with the stream
; before jumping forward to OPEN-END with the displacement value in E
; and perhaps a modified value in BC. The strange pathing does seem to
; provide for flexibility in this respect.
;
; There is no need to open the printer buffer as it is there already
; even if you are still saving up for a ZX Printer or have moved onto
; something bigger. In any case it would have to be created after
; the system variables but apart from that it is a simple task
; and all but one of the ROM routines can handle a buffer in that position.
; (PR-ALL-6 would require an extra 3 bytes of code).
; However it wouldn't be wise to have two streams attached to the ZX Printer
; as you can now, so one assumes that if PR_CC_hi was non-zero then
; the OPEN-P routine would have refused to attach a stream if another
; stream was attached.

; Something of significance is being passed to these ghost routines in the
; second character. Strings 'RB', 'RT' perhaps or a drive/station number.
; The routine would have to deal with that and exit to OPEN_END with BC
; containing $0001 or more likely there would be an exit within the routine.
; Anyway doesn't matter, these routines are long gone.

; -----------------
; OPEN-K Subroutine
; -----------------
; Open Keyboard stream.

;; OPEN-K
L1781:  LD      E,$01           ; 01 is offset to second byte of channel 'K'.
        JR      L178B           ; forward to OPEN-END

; -----------------
; OPEN-S Subroutine
; -----------------
; Open Screen stream.

;; OPEN-S
L1785:  LD      E,$06           ; 06 is offset to 2nd byte of channel 'S'
        JR      L178B           ; to OPEN-END

; -----------------
; OPEN-P Subroutine
; -----------------
; Open Printer stream.

;; OPEN-P
L1789:  LD      E,$10           ; 16d is offset to 2nd byte of channel 'P'

;; OPEN-END
L178B:  DEC     BC              ; the stored length of 'K','S','P' or
                                ; whatever is now tested. ??
        LD      A,B             ; test now if initial or residual length
        OR      C               ; is one character.
        JR      NZ,L1765        ; to REPORT-Fb 'Invalid file name' if not.

        LD      D,A             ; load D with zero to form the displacement
                                ; in the DE register.
        POP     HL              ; * restore the saved STRMS pointer.
        RET                     ; return to update STRMS entry thereby 
                                ; signaling stream is open.

; ----------------------------------------
; Handle CAT, ERASE, FORMAT, MOVE commands
; ----------------------------------------
; These just generate an error report as the ROM is 'incomplete'.
;
; Luckily this provides a mechanism for extending these in a shadow ROM
; but without the powerful mechanisms set up in this ROM.
; An instruction fetch on $0008 may page in a peripheral ROM,
; e.g. the Sinclair Interface 1 ROM, to handle these commands.
; However that wasn't the plan.
; Development of this ROM continued for another three months until the cost
; of replacing it and the manual became unfeasible.
; The ultimate power of channels and streams died at birth.

;; CAT-ETC
L1793:  JR      L1725           ; to REPORT-Ob

; -----------------
; Perform AUTO-LIST
; -----------------
; This produces an automatic listing in the upper screen.

;; AUTO-LIST
L1795:  LD      ($5C3F),SP      ; save stack pointer in LIST_SP
        LD      (IY+$02),$10    ; update TV_FLAG set bit 3
        CALL    L0DAF           ; routine CL-ALL.
        SET     0,(IY+$02)      ; update TV_FLAG  - signal lower screen in use

        LD      B,(IY+$31)      ; fetch DF_SZ to B.
        CALL    L0E44           ; routine CL-LINE clears lower display
                                ; preserving B.
        RES     0,(IY+$02)      ; update TV_FLAG  - signal main screen in use
        SET     0,(IY+$30)      ; update FLAGS2 - signal will be necessary to
                                ; clear main screen.
        LD      HL,($5C49)      ; fetch E_PPC current edit line to HL.
        LD      DE,($5C6C)      ; fetch S_TOP to DE, the current top line
                                ; (initially zero)
        AND     A               ; prepare for true subtraction.
        SBC     HL,DE           ; subtract and
        ADD     HL,DE           ; add back.
        JR      C,L17E1         ; to AUTO-L-2 if S_TOP higher than E_PPC
                                ; to set S_TOP to E_PPC

        PUSH    DE              ; save the top line number.
        CALL    L196E           ; routine LINE-ADDR gets address of E_PPC.
        LD      DE,$02C0        ; prepare known number of characters in
                                ; the default upper screen.
        EX      DE,HL           ; offset to HL, program address to DE.
        SBC     HL,DE           ; subtract high value from low to obtain
                                ; negated result used in addition.
        EX      (SP),HL         ; swap result with top line number on stack.
        CALL    L196E           ; routine LINE-ADDR  gets address of that
                                ; top line in HL and next line in DE.
        POP     BC              ; restore the result to balance stack.

;; AUTO-L-1
L17CE:  PUSH    BC              ; save the result.
        CALL    L19B8           ; routine NEXT-ONE gets address in HL of
                                ; line after auto-line (in DE).
        POP     BC              ; restore result.
        ADD     HL,BC           ; compute back.
        JR      C,L17E4         ; to AUTO-L-3 if line 'should' appear

        EX      DE,HL           ; address of next line to HL.
        LD      D,(HL)          ; get line
        INC     HL              ; number
        LD      E,(HL)          ; in DE.
        DEC     HL              ; adjust back to start.
        LD      ($5C6C),DE      ; update S_TOP.
        JR      L17CE           ; to AUTO-L-1 until estimate reached.

; ---

; the jump was to here if S_TOP was greater than E_PPC

;; AUTO-L-2
L17E1:  LD      ($5C6C),HL      ; make S_TOP the same as E_PPC.

; continue here with valid starting point from above or good estimate
; from computation

;; AUTO-L-3
L17E4:  LD      HL,($5C6C)      ; fetch S_TOP line number to HL.
        CALL    L196E           ; routine LINE-ADDR gets address in HL.
                                ; address of next in DE.
        JR      Z,L17ED         ; to AUTO-L-4 if line exists.

        EX      DE,HL           ; else use address of next line.

;; AUTO-L-4
L17ED:  CALL    L1833           ; routine LIST-ALL                >>>

; The return will be to here if no scrolling occurred

        RES     4,(IY+$02)      ; update TV_FLAG  - signal no auto listing.
        RET                     ; return.

; ------------
; Handle LLIST
; ------------
; A short form of LIST #3. The listing goes to stream 3 - default printer.

;; LLIST
L17F5:  LD      A,$03           ; the usual stream for ZX Printer
        JR      L17FB           ; forward to LIST-1

; -----------
; Handle LIST
; -----------
; List to any stream.
; Note. While a starting line can be specified it is
; not possible to specify an end line.
; Just listing a line makes it the current edit line.

;; LIST
L17F9:  LD      A,$02           ; default is stream 2 - the upper screen.

;; LIST-1
L17FB:  LD      (IY+$02),$00    ; the TV_FLAG is initialized with bit 0 reset
                                ; indicating upper screen in use.
        CALL    L2530           ; routine SYNTAX-Z - checking syntax ?
        CALL    NZ,L1601        ; routine CHAN-OPEN if in run-time.

        RST     18H             ; GET-CHAR
        CALL    L2070           ; routine STR-ALTER will alter if '#'.
        JR      C,L181F         ; forward to LIST-4 not a '#' .


        RST     18H             ; GET-CHAR
        CP      $3B             ; is it ';' ?
        JR      Z,L1814         ; skip to LIST-2 if so.

        CP      $2C             ; is it ',' ?
        JR      NZ,L181A        ; forward to LIST-3 if neither separator.

; we have, say,  LIST #15, and a number must follow the separator.

;; LIST-2
L1814:  RST     20H             ; NEXT-CHAR
        CALL    L1C82           ; routine EXPT-1NUM
        JR      L1822           ; forward to LIST-5

; ---

; the branch was here with just LIST #3 etc.

;; LIST-3
L181A:  CALL    L1CE6           ; routine USE-ZERO
        JR      L1822           ; forward to LIST-5

; ---

; the branch was here with LIST

;; LIST-4
L181F:  CALL    L1CDE           ; routine FETCH-NUM checks if a number 
                                ; follows else uses zero.

;; LIST-5
L1822:  CALL    L1BEE           ; routine CHECK-END quits if syntax OK >>>

        CALL    L1E99           ; routine FIND-INT2 fetches the number
                                ; from the calculator stack in run-time.
        LD      A,B             ; fetch high byte of line number and
        AND     $3F             ; make less than $40 so that NEXT-ONE
                                ; (from LINE-ADDR) doesn't lose context.
                                ; Note. this is not satisfactory and the typo
                                ; LIST 20000 will list an entirely different
                                ; section than LIST 2000. Such typos are not
                                ; available for checking if they are direct
                                ; commands.

        LD      H,A             ; transfer the modified
        LD      L,C             ; line number to HL.
        LD      ($5C49),HL      ; update E_PPC to new line number.
        CALL    L196E           ; routine LINE-ADDR gets the address of the
                                ; line.

; This routine is called from AUTO-LIST

;; LIST-ALL
L1833:  LD      E,$01           ; signal current line not yet printed

;; LIST-ALL-2
L1835:  CALL    L1855           ; routine OUT-LINE outputs a BASIC line
                                ; using PRINT-OUT and makes an early return
                                ; when no more lines to print. >>>

        RST     10H             ; PRINT-A prints the carriage return (in A)

        BIT     4,(IY+$02)      ; test TV_FLAG  - automatic listing ?
        JR      Z,L1835         ; back to LIST-ALL-2 if not
                                ; (loop exit is via OUT-LINE)

; continue here if an automatic listing required.

        LD      A,($5C6B)       ; fetch DF_SZ lower display file size.
        SUB     (IY+$4F)        ; subtract S_POSN_hi ithe current line number.
        JR      NZ,L1835        ; back to LIST-ALL-2 if upper screen not full.

        XOR     E               ; A contains zero, E contains one if the
                                ; current edit line has not been printed
                                ; or zero if it has (from OUT-LINE).
        RET     Z               ; return if the screen is full and the line
                                ; has been printed.

; continue with automatic listings if the screen is full and the current
; edit line is missing. OUT-LINE will scroll automatically.

        PUSH    HL              ; save the pointer address.
        PUSH    DE              ; save the E flag.
        LD      HL,$5C6C        ; fetch S_TOP the rough estimate.
        CALL    L190F           ; routine LN-FETCH updates S_TOP with
                                ; the number of the next line.
        POP     DE              ; restore the E flag.
        POP     HL              ; restore the address of the next line.
        JR      L1835           ; back to LIST-ALL-2.

; ------------------------
; Print a whole BASIC line
; ------------------------
; This routine prints a whole BASIC line and it is called
; from LIST-ALL to output the line to current channel
; and from ED-EDIT to 'sprint' the line to the edit buffer.

;; OUT-LINE
L1855:  LD      BC,($5C49)      ; fetch E_PPC the current line which may be
                                ; unchecked and not exist.
        CALL    L1980           ; routine CP-LINES finds match or line after.
        LD      D,$3E           ; prepare cursor '>' in D.
        JR      Z,L1865         ; to OUT-LINE1 if matched or line after.

        LD      DE,$0000        ; put zero in D, to suppress line cursor.
        RL      E               ; pick up carry in E if line before current
                                ; leave E zero if same or after.

;; OUT-LINE1
L1865:  LD      (IY+$2D),E      ; save flag in BREG which is spare.
        LD      A,(HL)          ; get high byte of line number.
        CP      $40             ; is it too high ($2F is maximum possible) ?
        POP     BC              ; drop the return address and
        RET     NC              ; make an early return if so >>>

        PUSH    BC              ; save return address
        CALL    L1A28           ; routine OUT-NUM-2 to print addressed number
                                ; with leading space.
        INC     HL              ; skip low number byte.
        INC     HL              ; and the two
        INC     HL              ; length bytes.
        RES     0,(IY+$01)      ; update FLAGS - signal leading space required.
        LD      A,D             ; fetch the cursor.
        AND     A               ; test for zero.
        JR      Z,L1881         ; to OUT-LINE3 if zero.


        RST     10H             ; PRINT-A prints '>' the current line cursor.

; this entry point is called from ED-COPY

;; OUT-LINE2
L187D:  SET     0,(IY+$01)      ; update FLAGS - suppress leading space.

;; OUT-LINE3
L1881:  PUSH    DE              ; save flag E for a return value.
        EX      DE,HL           ; save HL address in DE.
        RES     2,(IY+$30)      ; update FLAGS2 - signal NOT in QUOTES.

        LD      HL,$5C3B        ; point to FLAGS.
        RES     2,(HL)          ; signal 'K' mode. (starts before keyword)
        BIT     5,(IY+$37)      ; test FLAGX - input mode ?
        JR      Z,L1894         ; forward to OUT-LINE4 if not.

        SET     2,(HL)          ; signal 'L' mode. (used for input)

;; OUT-LINE4
L1894:  LD      HL,($5C5F)      ; fetch X_PTR - possibly the error pointer
                                ; address.
        AND     A               ; clear the carry flag.
        SBC     HL,DE           ; test if an error address has been reached.
        JR      NZ,L18A1        ; forward to OUT-LINE5 if not.

        LD      A,$3F           ; load A with '?' the error marker.
        CALL    L18C1           ; routine OUT-FLASH to print flashing marker.

;; OUT-LINE5
L18A1:  CALL    L18E1           ; routine OUT-CURS will print the cursor if
                                ; this is the right position.
        EX      DE,HL           ; restore address pointer to HL.
        LD      A,(HL)          ; fetch the addressed character.
        CALL    L18B6           ; routine NUMBER skips a hidden floating 
                                ; point number if present.
        INC     HL              ; now increment the pointer.
        CP      $0D             ; is character end-of-line ?
        JR      Z,L18B4         ; to OUT-LINE6, if so, as line is finished.

        EX      DE,HL           ; save the pointer in DE.
        CALL    L1937           ; routine OUT-CHAR to output character/token.

        JR      L1894           ; back to OUT-LINE4 until entire line is done.

; ---

;; OUT-LINE6
L18B4:  POP     DE              ; bring back the flag E, zero if current
                                ; line printed else 1 if still to print.
        RET                     ; return with A holding $0D

; -------------------------
; Check for a number marker
; -------------------------
; this subroutine is called from two processes. while outputting BASIC lines
; and while searching statements within a BASIC line.
; during both, this routine will pass over an invisible number indicator
; and the five bytes floating-point number that follows it.
; Note that this causes floating point numbers to be stripped from
; the BASIC line when it is fetched to the edit buffer by OUT_LINE.
; the number marker also appears after the arguments of a DEF FN statement
; and may mask old 5-byte string parameters.

;; NUMBER
L18B6:  CP      $0E             ; character fourteen ?
        RET     NZ              ; return if not.

        INC     HL              ; skip the character
        INC     HL              ; and five bytes
        INC     HL              ; following.
        INC     HL              ;
        INC     HL              ;
        INC     HL              ;
        LD      A,(HL)          ; fetch the following character
        RET                     ; for return value.

; --------------------------
; Print a flashing character
; --------------------------
; This subroutine is called from OUT-LINE to print a flashing error
; marker '?' or from the next routine to print a flashing cursor e.g. 'L'.
; However, this only gets called from OUT-LINE when printing the edit line
; or the input buffer to the lower screen so a direct call to $09F4 can
; be used, even though out-line outputs to other streams.
; In fact the alternate set is used for the whole routine.

;; OUT-FLASH
L18C1:  EXX                     ; switch in alternate set

        LD      HL,($5C8F)      ; fetch L = ATTR_T, H = MASK-T
        PUSH    HL              ; save masks.
        RES     7,H             ; reset flash mask bit so active. 
        SET     7,L             ; make attribute FLASH.
        LD      ($5C8F),HL      ; resave ATTR_T and MASK-T

        LD      HL,$5C91        ; address P_FLAG
        LD      D,(HL)          ; fetch to D
        PUSH    DE              ; and save.
        LD      (HL),$00        ; clear inverse, over, ink/paper 9

        CALL    L09F4           ; routine PRINT-OUT outputs character
                                ; without the need to vector via RST 10.

        POP     HL              ; pop P_FLAG to H.
        LD      (IY+$57),H      ; and restore system variable P_FLAG.
        POP     HL              ; restore temporary masks
        LD      ($5C8F),HL      ; and restore system variables ATTR_T/MASK_T

        EXX                     ; switch back to main set
        RET                     ; return

; ----------------
; Print the cursor
; ----------------
; This routine is called before any character is output while outputting
; a BASIC line or the input buffer. This includes listing to a printer
; or screen, copying a BASIC line to the edit buffer and printing the
; input buffer or edit buffer to the lower screen. It is only in the
; latter two cases that it has any relevance and in the last case it
; performs another very important function also.

;; OUT-CURS
L18E1:  LD      HL,($5C5B)      ; fetch K_CUR the current cursor address
        AND     A               ; prepare for true subtraction.
        SBC     HL,DE           ; test against pointer address in DE and
        RET     NZ              ; return if not at exact position.

; the value of MODE, maintained by KEY-INPUT, is tested and if non-zero
; then this value 'E' or 'G' will take precedence.

        LD      A,($5C41)       ; fetch MODE  0='KLC', 1='E', 2='G'.
        RLC     A               ; double the value and set flags.
        JR      Z,L18F3         ; to OUT-C-1 if still zero ('KLC').

        ADD     A,$43           ; add 'C' - will become 'E' if originally 1
                                ; or 'G' if originally 2.
        JR      L1909           ; forward to OUT-C-2 to print.

; ---

; If mode was zero then, while printing a BASIC line, bit 2 of flags has been
; set if 'THEN' or ':' was encountered as a main character and reset otherwise.
; This is now used to determine if the 'K' cursor is to be printed but this
; transient state is also now transferred permanently to bit 3 of FLAGS
; to let the interrupt routine know how to decode the next key.

;; OUT-C-1
L18F3:  LD      HL,$5C3B        ; Address FLAGS
        RES     3,(HL)          ; signal 'K' mode initially.
        LD      A,$4B           ; prepare letter 'K'.
        BIT     2,(HL)          ; test FLAGS - was the
                                ; previous main character ':' or 'THEN' ?
        JR      Z,L1909         ; forward to OUT-C-2 if so to print.

        SET     3,(HL)          ; signal 'L' mode to interrupt routine.
                                ; Note. transient bit has been made permanent.
        INC     A               ; augment from 'K' to 'L'.

        BIT     3,(IY+$30)      ; test FLAGS2 - consider caps lock ?
                                ; which is maintained by KEY-INPUT.
        JR      Z,L1909         ; forward to OUT-C-2 if not set to print.

        LD      A,$43           ; alter 'L' to 'C'.

;; OUT-C-2
L1909:  PUSH    DE              ; save address pointer but OK as OUT-FLASH
                                ; uses alternate set without RST 10.

        CALL    L18C1           ; routine OUT-FLASH to print.

        POP     DE              ; restore and
        RET                     ; return.

; ----------------------------
; Get line number of next line
; ----------------------------
; These two subroutines are called while editing.
; This entry point is from ED-DOWN with HL addressing E_PPC
; to fetch the next line number.
; Also from AUTO-LIST with HL addressing S_TOP just to update S_TOP
; with the value of the next line number. It gets fetched but is discarded.
; These routines never get called while the editor is being used for input.

;; LN-FETCH
L190F:  LD      E,(HL)          ; fetch low byte
        INC     HL              ; address next
        LD      D,(HL)          ; fetch high byte.
        PUSH    HL              ; save system variable hi pointer.
        EX      DE,HL           ; line number to HL,
        INC     HL              ; increment as a starting point.
        CALL    L196E           ; routine LINE-ADDR gets address in HL.
        CALL    L1695           ; routine LINE-NO gets line number in DE.
        POP     HL              ; restore system variable hi pointer.

; This entry point is from the ED-UP with HL addressing E_PPC_hi

;; LN-STORE
L191C:  BIT     5,(IY+$37)      ; test FLAGX - input mode ?
        RET     NZ              ; return if so.
                                ; Note. above already checked by ED-UP/ED-DOWN.

        LD      (HL),D          ; save high byte of line number.
        DEC     HL              ; address lower
        LD      (HL),E          ; save low byte of line number.
        RET                     ; return.

; -----------------------------------------
; Outputting numbers at start of BASIC line
; -----------------------------------------
; This routine entered at OUT-SP-NO is used to compute then output the first
; three digits of a 4-digit BASIC line printing a space if necessary.
; The line number, or residual part, is held in HL and the BC register
; holds a subtraction value -1000, -100 or -10.
; Note. for example line number 200 -
; space(out_char), 2(out_code), 0(out_char) final number always out-code.

;; OUT-SP-2
L1925:  LD      A,E             ; will be space if OUT-CODE not yet called.
                                ; or $FF if spaces are suppressed.
                                ; else $30 ('0').
                                ; (from the first instruction at OUT-CODE)
                                ; this guy is just too clever.
        AND     A               ; test bit 7 of A.
        RET     M               ; return if $FF, as leading spaces not
                                ; required. This is set when printing line
                                ; number and statement in MAIN-5.

        JR      L1937           ; forward to exit via OUT-CHAR.

; ---

; -> the single entry point.

;; OUT-SP-NO
L192A:  XOR     A               ; initialize digit to 0

;; OUT-SP-1
L192B:  ADD     HL,BC           ; add negative number to HL.
        INC     A               ; increment digit
        JR      C,L192B         ; back to OUT-SP-1 until no carry from
                                ; the addition.

        SBC     HL,BC           ; cancel the last addition
        DEC     A               ; and decrement the digit.
        JR      Z,L1925         ; back to OUT-SP-2 if it is zero.

        JP      L15EF           ; jump back to exit via OUT-CODE.    ->


; -------------------------------------
; Outputting characters in a BASIC line
; -------------------------------------
; This subroutine ...

;; OUT-CHAR
L1937:  CALL    L2D1B           ; routine NUMERIC tests if it is a digit ?
        JR      NC,L196C        ; to OUT-CH-3 to print digit without
                                ; changing mode. Will be 'K' mode if digits
                                ; are at beginning of edit line.

        CP      $21             ; less than quote character ?
        JR      C,L196C         ; to OUT-CH-3 to output controls and space.

        RES     2,(IY+$01)      ; initialize FLAGS to 'K' mode and leave
                                ; unchanged if this character would precede
                                ; a keyword.

        CP      $CB             ; is character 'THEN' token ?
        JR      Z,L196C         ; to OUT-CH-3 to output if so.

        CP      $3A             ; is it ':' ?
        JR      NZ,L195A        ; to OUT-CH-1 if not statement separator
                                ; to change mode back to 'L'.

        BIT     5,(IY+$37)      ; FLAGX  - Input Mode ??
        JR      NZ,L1968        ; to OUT-CH-2 if in input as no statements.
                                ; Note. this check should seemingly be at
                                ; the start. Commands seem inappropriate in
                                ; INPUT mode and are rejected by the syntax
                                ; checker anyway.
                                ; unless INPUT LINE is being used.

        BIT     2,(IY+$30)      ; test FLAGS2 - is the ':' within quotes ?
        JR      Z,L196C         ; to OUT-CH-3 if ':' is outside quoted text.

        JR      L1968           ; to OUT-CH-2 as ':' is within quotes

; ---

;; OUT-CH-1
L195A:  CP      $22             ; is it quote character '"'  ?
        JR      NZ,L1968        ; to OUT-CH-2 with others to set 'L' mode.

        PUSH    AF              ; save character.
        LD      A,($5C6A)       ; fetch FLAGS2.
        XOR     $04             ; toggle the quotes flag.
        LD      ($5C6A),A       ; update FLAGS2
        POP     AF              ; and restore character.

;; OUT-CH-2
L1968:  SET     2,(IY+$01)      ; update FLAGS - signal L mode if the cursor
                                ; is next.

;; OUT-CH-3
L196C:  RST     10H             ; PRINT-A vectors the character to
                                ; channel 'S', 'K', 'R' or 'P'.
        RET                     ; return.

; -------------------------------------------
; Get starting address of line, or line after
; -------------------------------------------
; This routine is used often to get the address, in HL, of a BASIC line
; number supplied in HL, or failing that the address of the following line
; and the address of the previous line in DE.

;; LINE-ADDR
L196E:  PUSH    HL              ; save line number in HL register
        LD      HL,($5C53)      ; fetch start of program from PROG
        LD      D,H             ; transfer address to
        LD      E,L             ; the DE register pair.

;; LINE-AD-1
L1974:  POP     BC              ; restore the line number to BC
        CALL    L1980           ; routine CP-LINES compares with that
                                ; addressed by HL
        RET     NC              ; return if line has been passed or matched.
                                ; if NZ, address of previous is in DE

        PUSH    BC              ; save the current line number
        CALL    L19B8           ; routine NEXT-ONE finds address of next
                                ; line number in DE, previous in HL.
        EX      DE,HL           ; switch so next in HL
        JR      L1974           ; back to LINE-AD-1 for another comparison

; --------------------
; Compare line numbers
; --------------------
; This routine compares a line number supplied in BC with an addressed
; line number pointed to by HL.

;; CP-LINES
L1980:  LD      A,(HL)          ; Load the high byte of line number and
        CP      B               ; compare with that of supplied line number.
        RET     NZ              ; return if yet to match (carry will be set).

        INC     HL              ; address low byte of
        LD      A,(HL)          ; number and pick up in A.
        DEC     HL              ; step back to first position.
        CP      C               ; now compare.
        RET                     ; zero set if exact match.
                                ; carry set if yet to match.
                                ; no carry indicates a match or
                                ; next available BASIC line or
                                ; program end marker.

; -------------------
; Find each statement
; -------------------
; The single entry point EACH-STMT is used to
; 1) To find the D'th statement in a line.
; 2) To find a token in held E.

;; not-used
L1988:  INC     HL              ;
        INC     HL              ;
        INC     HL              ;

; -> entry point.

;; EACH-STMT
L198B:  LD      ($5C5D),HL      ; save HL in CH_ADD
        LD      C,$00           ; initialize quotes flag

;; EACH-S-1
L1990:  DEC     D               ; decrease statement count
        RET     Z               ; return if zero


        RST     20H             ; NEXT-CHAR
        CP      E               ; is it the search token ?
        JR      NZ,L199A        ; forward to EACH-S-3 if not

        AND     A               ; clear carry
        RET                     ; return signalling success.

; ---

;; EACH-S-2
L1998:  INC     HL              ; next address
        LD      A,(HL)          ; next character

;; EACH-S-3
L199A:  CALL    L18B6           ; routine NUMBER skips if number marker
        LD      ($5C5D),HL      ; save in CH_ADD
        CP      $22             ; is it quotes '"' ?
        JR      NZ,L19A5        ; to EACH-S-4 if not

        DEC     C               ; toggle bit 0 of C

;; EACH-S-4
L19A5:  CP      $3A             ; is it ':'
        JR      Z,L19AD         ; to EACH-S-5

        CP      $CB             ; 'THEN'
        JR      NZ,L19B1        ; to EACH-S-6

;; EACH-S-5
L19AD:  BIT     0,C             ; is it in quotes
        JR      Z,L1990         ; to EACH-S-1 if not

;; EACH-S-6
L19B1:  CP      $0D             ; end of line ?
        JR      NZ,L1998        ; to EACH-S-2

        DEC     D               ; decrease the statement counter
                                ; which should be zero else
                                ; 'Statement Lost'.
        SCF                     ; set carry flag - not found
        RET                     ; return

; -----------------------------------------------------------------------
; Storage of variables. For full details - see chapter 24.
; ZX Spectrum BASIC Programming by Steven Vickers 1982.
; It is bits 7-5 of the first character of a variable that allow
; the six types to be distinguished. Bits 4-0 are the reduced letter.
; So any variable name is higher that $3F and can be distinguished
; also from the variables area end-marker $80.
;
; 76543210 meaning                               brief outline of format.
; -------- ------------------------              -----------------------
; 010      string variable.                      2 byte length + contents.
; 110      string array.                         2 byte length + contents.
; 100      array of numbers.                     2 byte length + contents.
; 011      simple numeric variable.              5 bytes.
; 101      variable length named numeric.        5 bytes.
; 111      for-next loop variable.               18 bytes.
; 10000000 the variables area end-marker.
;
; Note. any of the above seven will serve as a program end-marker.
;
; -----------------------------------------------------------------------

; ------------
; Get next one
; ------------
; This versatile routine is used to find the address of the next line
; in the program area or the next variable in the variables area.
; The reason one routine is made to handle two apparently unrelated tasks
; is that it can be called indiscriminately when merging a line or a
; variable.

;; NEXT-ONE
L19B8:  PUSH    HL              ; save the pointer address.
        LD      A,(HL)          ; get first byte.
        CP      $40             ; compare with upper limit for line numbers.
        JR      C,L19D5         ; forward to NEXT-O-3 if within BASIC area.

; the continuation here is for the next variable unless the supplied
; line number was erroneously over 16383. see RESTORE command.

        BIT     5,A             ; is it a string or an array variable ?
        JR      Z,L19D6         ; forward to NEXT-O-4 to compute length.

        ADD     A,A             ; test bit 6 for single-character variables.
        JP      M,L19C7         ; forward to NEXT-O-1 if so

        CCF                     ; clear the carry for long-named variables.
                                ; it remains set for for-next loop variables.

;; NEXT-O-1
L19C7:  LD      BC,$0005        ; set BC to 5 for floating point number
        JR      NC,L19CE        ; forward to NEXT-O-2 if not a for/next
                                ; variable.

        LD      C,$12           ; set BC to eighteen locations.
                                ; value, limit, step, line and statement.

; now deal with long-named variables

;; NEXT-O-2
L19CE:  RLA                     ; test if character inverted. carry will also
                                ; be set for single character variables
        INC     HL              ; address next location.
        LD      A,(HL)          ; and load character.
        JR      NC,L19CE        ; back to NEXT-O-2 if not inverted bit.
                                ; forward immediately with single character
                                ; variable names.

        JR      L19DB           ; forward to NEXT-O-5 to add length of
                                ; floating point number(s etc.).

; ---

; this branch is for line numbers.

;; NEXT-O-3
L19D5:  INC     HL              ; increment pointer to low byte of line no.

; strings and arrays rejoin here

;; NEXT-O-4
L19D6:  INC     HL              ; increment to address the length low byte.
        LD      C,(HL)          ; transfer to C and
        INC     HL              ; point to high byte of length.
        LD      B,(HL)          ; transfer that to B
        INC     HL              ; point to start of BASIC/variable contents.

; the three types of numeric variables rejoin here

;; NEXT-O-5
L19DB:  ADD     HL,BC           ; add the length to give address of next
                                ; line/variable in HL.
        POP     DE              ; restore previous address to DE.

; ------------------
; Difference routine
; ------------------
; This routine terminates the above routine and is also called from the
; start of the next routine to calculate the length to reclaim.

;; DIFFER
L19DD:  AND     A               ; prepare for true subtraction.
        SBC     HL,DE           ; subtract the two pointers.
        LD      B,H             ; transfer result
        LD      C,L             ; to BC register pair.
        ADD     HL,DE           ; add back
        EX      DE,HL           ; and switch pointers
        RET                     ; return values are the length of area in BC,
                                ; low pointer (previous) in HL,
                                ; high pointer (next) in DE.

; -----------------------
; Handle reclaiming space
; -----------------------
;

;; RECLAIM-1
L19E5:  CALL    L19DD           ; routine DIFFER immediately above

;; RECLAIM-2
L19E8:  PUSH    BC              ;

        LD      A,B             ;
        CPL                     ;
        LD      B,A             ;
        LD      A,C             ;
        CPL                     ;
        LD      C,A             ;
        INC     BC              ;

        CALL    L1664           ; routine POINTERS
        EX      DE,HL           ;
        POP     HL              ;

        ADD     HL,DE           ;
        PUSH    DE              ;
        LDIR                    ; copy bytes

        POP     HL              ;
        RET                     ;

; ----------------------------------------
; Read line number of line in editing area
; ----------------------------------------
; This routine reads a line number in the editing area returning the number
; in the BC register or zero if no digits exist before commands.
; It is called from LINE-SCAN to check the syntax of the digits.
; It is called from MAIN-3 to extract the line number in preparation for
; inclusion of the line in the BASIC program area.
;
; Interestingly the calculator stack is moved from its normal place at the
; end of dynamic memory to an adequate area within the system variables area.
; This ensures that in a low memory situation, that valid line numbers can
; be extracted without raising an error and that memory can be reclaimed
; by deleting lines. If the stack was in its normal place then a situation
; arises whereby the Spectrum becomes locked with no means of reclaiming space.

;; E-LINE-NO
L19FB:  LD      HL,($5C59)      ; load HL from system variable E_LINE.

        DEC     HL              ; decrease so that NEXT_CHAR can be used
                                ; without skipping the first digit.

        LD      ($5C5D),HL      ; store in the system variable CH_ADD.

        RST     20H             ; NEXT-CHAR skips any noise and white-space
                                ; to point exactly at the first digit.

        LD      HL,$5C92        ; use MEM-0 as a temporary calculator stack
                                ; an overhead of three locations are needed.
        LD      ($5C65),HL      ; set new STKEND.

        CALL    L2D3B           ; routine INT-TO-FP will read digits till
                                ; a non-digit found.
        CALL    L2DA2           ; routine FP-TO-BC will retrieve number
                                ; from stack at membot.
        JR      C,L1A15         ; forward to E-L-1 if overflow i.e. > 65535.
                                ; 'Nonsense in BASIC'

        LD      HL,$D8F0        ; load HL with value -9999
        ADD     HL,BC           ; add to line number in BC

;; E-L-1
L1A15:  JP      C,L1C8A         ; to REPORT-C 'Nonsense in BASIC' if over.
                                ; Note. As ERR_SP points to ED_ERROR
                                ; the report is never produced although
                                ; the RST $08 will update X_PTR leading to
                                ; the error marker being displayed when
                                ; the ED_LOOP is reiterated.
                                ; in fact, since it is immediately
                                ; cancelled, any report will do.

; a line in the range 0 - 9999 has been entered.

        JP      L16C5           ; jump back to SET-STK to set the calculator 
                                ; stack back to its normal place and exit 
                                ; from there.

; ---------------------------------
; Report and line number outputting
; ---------------------------------
; Entry point OUT-NUM-1 is used by the Error Reporting code to print
; the line number and later the statement number held in BC.
; If the statement was part of a direct command then -2 is used as a
; dummy line number so that zero will be printed in the report.
; This routine is also used to print the exponent of E-format numbers.
;
; Entry point OUT-NUM-2 is used from OUT-LINE to output the line number
; addressed by HL with leading spaces if necessary.

;; OUT-NUM-1
L1A1B:  PUSH    DE              ; save the
        PUSH    HL              ; registers.
        XOR     A               ; set A to zero.
        BIT     7,B             ; is the line number minus two ?
        JR      NZ,L1A42        ; forward to OUT-NUM-4 if so to print zero 
                                ; for a direct command.

        LD      H,B             ; transfer the
        LD      L,C             ; number to HL.
        LD      E,$FF           ; signal 'no leading zeros'.
        JR      L1A30           ; forward to continue at OUT-NUM-3

; ---

; from OUT-LINE - HL addresses line number.

;; OUT-NUM-2
L1A28:  PUSH    DE              ; save flags
        LD      D,(HL)          ; high byte to D
        INC     HL              ; address next
        LD      E,(HL)          ; low byte to E
        PUSH    HL              ; save pointer
        EX      DE,HL           ; transfer number to HL
        LD      E,$20           ; signal 'output leading spaces'

;; OUT-NUM-3
L1A30:  LD      BC,$FC18        ; value -1000
        CALL    L192A           ; routine OUT-SP-NO outputs space or number
        LD      BC,$FF9C        ; value -100
        CALL    L192A           ; routine OUT-SP-NO
        LD      C,$F6           ; value -10 ( B is still $FF )
        CALL    L192A           ; routine OUT-SP-NO
        LD      A,L             ; remainder to A.

;; OUT-NUM-4
L1A42:  CALL    L15EF           ; routine OUT-CODE for final digit.
                                ; else report code zero wouldn't get
                                ; printed.
        POP     HL              ; restore the
        POP     DE              ; registers and
        RET                     ; return.
