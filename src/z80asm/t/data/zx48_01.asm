;************************************************************************
;** An Assembly File Listing to generate a 16K ROM for the ZX Spectrum **
;************************************************************************

        PUBLIC L0018
        PUBLIC L0055
        PUBLIC L0074
        PUBLIC L0077
        PUBLIC L0078
        PUBLIC L0095
        PUBLIC L0205
        PUBLIC L022C
        PUBLIC L0246
        PUBLIC L0260
        PUBLIC L026A
        PUBLIC L0284

        EXTERN L02BF
        EXTERN L11CB
        EXTERN L15F2
        EXTERN L169E
        EXTERN L16C5
        EXTERN L335B

; -------------------------
; Last updated: 13-DEC-2004
; -------------------------

; TASM cross-assembler directives. 
; ( comment out, perhaps, for other assemblers - see Notes at end.)

;#define DEFB .BYTE      
;#define DEFW .WORD
;#define DEFM .TEXT
;#define ORG  .ORG
;#define EQU  .EQU
;#define equ  .EQU

;   It is always a good idea to anchor, using ORGs, important sections such as 
;   the character bitmaps so that they don't move as code is added and removed.

;   Generally most approaches try to maintain main entry points as they are
;   often used by third-party software. 

	ORG 0000

;*****************************************
;** Part 1. RESTART ROUTINES AND TABLES **
;*****************************************

; -----------
; THE 'START'
; -----------
;   At switch on, the Z80 chip is in Interrupt Mode 0.
;   The Spectrum uses Interrupt Mode 1.
;   This location can also be 'called' to reset the machine.
;   Typically with PRINT USR 0.

;; START
L0000:  DI                      ; Disable Interrupts.
        XOR     A               ; Signal coming from START.
        LD      DE,$FFFF        ; Set pointer to top of possible physical RAM.
        JP      L11CB           ; Jump forward to common code at START-NEW.

; -------------------
; THE 'ERROR' RESTART
; -------------------
;   The error pointer is made to point to the position of the error to enable
;   the editor to highlight the error position if it occurred during syntax 
;   checking.  It is used at 37 places in the program.  An instruction fetch 
;   on address $0008 may page in a peripheral ROM such as the Sinclair 
;   Interface 1 or Disciple Disk Interface.  This was not an original design 
;   concept and not all errors pass through here.

;; ERROR-1
L0008:  LD      HL,($5C5D)      ; Fetch the character address from CH_ADD.
        LD      ($5C5F),HL      ; Copy it to the error pointer X_PTR.
        JR      L0053           ; Forward to continue at ERROR-2.

; -----------------------------
; THE 'PRINT CHARACTER' RESTART
; -----------------------------
;   The A register holds the code of the character that is to be sent to
;   the output stream of the current channel.  The alternate register set is 
;   used to output a character in the A register so there is no need to 
;   preserve any of the current main registers (HL, DE, BC).  
;   This restart is used 21 times.

;; PRINT-A
L0010:  JP      L15F2           ; Jump forward to continue at PRINT-A-2.

; ---

        DEFB    $FF, $FF, $FF   ; Five unused locations.
        DEFB    $FF, $FF        ;

; -------------------------------
; THE 'COLLECT CHARACTER' RESTART
; -------------------------------
;   The contents of the location currently addressed by CH_ADD are fetched.
;   A return is made if the value represents a character that has
;   relevance to the BASIC parser. Otherwise CH_ADD is incremented and the
;   tests repeated. CH_ADD will be addressing somewhere -
;   1) in the BASIC program area during line execution.
;   2) in workspace if evaluating, for example, a string expression.
;   3) in the edit buffer if parsing a direct command or a new BASIC line.
;   4) in workspace if accepting input but not that from INPUT LINE.

;; GET-CHAR
L0018:  LD      HL,($5C5D)      ; fetch the address from CH_ADD.
        LD      A,(HL)          ; use it to pick up current character.

;; TEST-CHAR
L001C:  CALL    L007D           ; routine SKIP-OVER tests if the character is
                                ; relevant.
        RET     NC              ; Return if it is significant.

; ------------------------------------
; THE 'COLLECT NEXT CHARACTER' RESTART
; ------------------------------------
;   As the BASIC commands and expressions are interpreted, this routine is
;   called repeatedly to step along the line.  It is used 83 times.

;; NEXT-CHAR
L0020:  CALL    L0074           ; routine CH-ADD+1 fetches the next immediate
                                ; character.
        JR      L001C           ; jump back to TEST-CHAR until a valid
                                ; character is found.

; ---

        DEFB    $FF, $FF, $FF   ; unused

; -----------------------
; THE 'CALCULATE' RESTART
; -----------------------
;   This restart enters the Spectrum's internal, floating-point, stack-based, 
;   FORTH-like language.
;   It is further used recursively from within the calculator.
;   It is used on 77 occasions.

;; FP-CALC
L0028:  JP      L335B           ; jump forward to the CALCULATE routine.

; ---

        DEFB    $FF, $FF, $FF   ; spare - note that on the ZX81, space being a 
        DEFB    $FF, $FF        ; little cramped, these same locations were
                                ; used for the five-byte end-calc literal.

; ------------------------------
; THE 'CREATE BC SPACES' RESTART
; ------------------------------
;   This restart is used on only 12 occasions to create BC spaces
;   between workspace and the calculator stack.

;; BC-SPACES
L0030:  PUSH    BC              ; Save number of spaces.
        LD      HL,($5C61)      ; Fetch WORKSP.
        PUSH    HL              ; Save address of workspace.
        JP      L169E           ; Jump forward to continuation code RESERVE.

; --------------------------------
; THE 'MASKABLE INTERRUPT' ROUTINE
; --------------------------------
;   This routine increments the Spectrum's three-byte FRAMES counter fifty 
;   times a second (sixty times a second in the USA ).
;   Both this routine and the called KEYBOARD subroutine use the IY register 
;   to access system variables and flags so a user-written program must 
;   disable interrupts to make use of the IY register.

;; MASK-INT
L0038:  PUSH    AF              ; Save the registers that will be used but not
        PUSH    HL              ; the IY register unfortunately.
        LD      HL,($5C78)      ; Fetch the first two bytes at FRAMES1.
        INC     HL              ; Increment lowest two bytes of counter.
        LD      ($5C78),HL      ; Place back in FRAMES1.
        LD      A,H             ; Test if the result was zero.
        OR      L               ;            
        JR      NZ,L0048        ; Forward, if not, to KEY-INT

        INC     (IY+$40)        ; otherwise increment FRAMES3 the third byte.

;   Now save the rest of the main registers and read and decode the keyboard.

;; KEY-INT
L0048:  PUSH    BC              ; Save the other main registers.
        PUSH    DE              ;                 

        CALL    L02BF           ; Routine KEYBOARD executes a stage in the 
                                ; process of reading a key-press.
        POP     DE              ;
        POP     BC              ; Restore registers.

        POP     HL              ;
        POP     AF              ;

        EI                      ; Enable Interrupts.
        RET                     ; Return.

; ---------------------
; THE 'ERROR-2' ROUTINE
; ---------------------
;   A continuation of the code at 0008.
;   The error code is stored and after clearing down stacks, an indirect jump 
;   is made to MAIN-4, etc. to handle the error.

;; ERROR-2
L0053:  POP     HL              ; drop the return address - the location
                                ; after the RST 08H instruction.
        LD      L,(HL)          ; fetch the error code that follows.
                                ; (nice to see this instruction used.)

;   Note. this entry point is used when out of memory at REPORT-4.
;   The L register has been loaded with the report code but X-PTR is not
;   updated.

;; ERROR-3
L0055:  LD      (IY+$00),L      ; Store it in the system variable ERR_NR.
        LD      SP,($5C3D)      ; ERR_SP points to an error handler on the
                                ; machine stack. There may be a hierarchy
                                ; of routines.
                                ; To MAIN-4 initially at base.
                                ; or REPORT-G on line entry.
                                ; or  ED-ERROR when editing.
                                ; or   ED-FULL during ed-enter.
                                ; or  IN-VAR-1 during runtime input etc.

        JP      L16C5           ; Jump to SET-STK to clear the calculator stack 
                                ; and reset MEM to usual place in the systems 
                                ; variables area and then indirectly to MAIN-4, 
                                ; etc.

; ---

        DEFB    $FF, $FF, $FF   ; Unused locations
        DEFB    $FF, $FF, $FF   ; before the fixed-position
        DEFB    $FF             ; NMI routine.

; ------------------------------------
; THE 'NON-MASKABLE INTERRUPT' ROUTINE
; ------------------------------------
;   
;   There is no NMI switch on the standard Spectrum or its peripherals.
;   When the NMI line is held low, then no matter what the Z80 was doing at 
;   the time, it will now execute the code at 66 Hex.
;   This Interrupt Service Routine will jump to location zero if the contents 
;   of the system variable NMIADD are zero or return if the location holds a
;   non-zero address.   So attaching a simple switch to the NMI as in the book 
;   "Spectrum Hardware Manual" causes a reset.  The logic was obviously 
;   intended to work the other way.  Sinclair Research said that, since they
;   had never advertised the NMI, they had no plans to fix the error "until 
;   the opportunity arose".
;   
;   Note. The location NMIADD was, in fact, later used by Sinclair Research 
;   to enhance the text channel on the ZX Interface 1.
;   On later Amstrad-made Spectrums, and the Brazilian Spectrum, the logic of 
;   this routine was indeed reversed but not as at first intended.
;
;   It can be deduced by looking elsewhere in this ROM that the NMIADD system
;   variable pointed to L121C and that this enabled a Warm Restart to be 
;   performed at any time, even while playing machine code games, or while 
;   another Spectrum has been allowed to gain control of this one. 
;
;   Software houses would have been able to protect their games from attack by
;   placing two zeros in the NMIADD system variable.

;; RESET
L0066:  PUSH    AF              ; save the
        PUSH    HL              ; registers.
        LD      HL,($5CB0)      ; fetch the system variable NMIADD.
        LD      A,H             ; test address
        OR      L               ; for zero.

        JR      NZ,L0070        ; skip to NO-RESET if NOT ZERO

        JP      (HL)            ; jump to routine ( i.e. L0000 )

;; NO-RESET
L0070:  POP     HL              ; restore the
        POP     AF              ; registers.
        RETN                    ; return to previous interrupt state.

; ---------------------------
; THE 'CH ADD + 1' SUBROUTINE
; ---------------------------
;   This subroutine is called from RST 20, and three times from elsewhere
;   to fetch the next immediate character following the current valid character
;   address and update the associated system variable.
;   The entry point TEMP-PTR1 is used from the SCANNING routine.
;   Both TEMP-PTR1 and TEMP-PTR2 are used by the READ command routine.

;; CH-ADD+1
L0074:  LD      HL,($5C5D)      ; fetch address from CH_ADD.

;; TEMP-PTR1
L0077:  INC     HL              ; increase the character address by one.

;; TEMP-PTR2
L0078:  LD      ($5C5D),HL      ; update CH_ADD with character address.

X007B:  LD      A,(HL)          ; load character to A from HL.
        RET                     ; and return.

; --------------------------
; THE 'SKIP OVER' SUBROUTINE
; --------------------------
;   This subroutine is called once from RST 18 to skip over white-space and
;   other characters irrelevant to the parsing of a BASIC line etc. .
;   Initially the A register holds the character to be considered
;   and HL holds its address which will not be within quoted text
;   when a BASIC line is parsed.
;   Although the 'tab' and 'at' characters will not appear in a BASIC line,
;   they could be present in a string expression, and in other situations.
;   Note. although white-space is usually placed in a program to indent loops
;   and make it more readable, it can also be used for the opposite effect and
;   spaces may appear in variable names although the parser never sees them.
;   It is this routine that helps make the variables 'Anum bEr5 3BUS' and
;   'a number 53 bus' appear the same to the parser.

;; SKIP-OVER
L007D:  CP      $21             ; test if higher than space.
        RET     NC              ; return with carry clear if so.

        CP      $0D             ; carriage return ?
        RET     Z               ; return also with carry clear if so.

                                ; all other characters have no relevance
                                ; to the parser and must be returned with
                                ; carry set.

        CP      $10             ; test if 0-15d
        RET     C               ; return, if so, with carry set.

        CP      $18             ; test if 24-32d
        CCF                     ; complement carry flag.
        RET     C               ; return with carry set if so.

                                ; now leaves 16d-23d

        INC     HL              ; all above have at least one extra character
                                ; to be stepped over.

        CP      $16             ; controls 22d ('at') and 23d ('tab') have two.
        JR      C,L0090         ; forward to SKIPS with ink, paper, flash,
                                ; bright, inverse or over controls.
                                ; Note. the high byte of tab is for RS232 only.
                                ; it has no relevance on this machine.

        INC     HL              ; step over the second character of 'at'/'tab'.

;; SKIPS
L0090:  SCF                     ; set the carry flag
        LD      ($5C5D),HL      ; update the CH_ADD system variable.
        RET                     ; return with carry set.


; ------------------
; THE 'TOKEN' TABLES
; ------------------
;   The tokenized characters 134d (RND) to 255d (COPY) are expanded using
;   this table. The last byte of a token is inverted to denote the end of
;   the word. The first is an inverted step-over byte.

;; TKN-TABLE
L0095:  DEFB    '?'+$80
        DEFM    "RN"
        DEFB    'D'+$80
        DEFM    "INKEY"
        DEFB    '$'+$80
        DEFB    'P','I'+$80
        DEFB    'F','N'+$80
        DEFM    "POIN"
        DEFB    'T'+$80
        DEFM    "SCREEN"
        DEFB    '$'+$80
        DEFM    "ATT"
        DEFB    'R'+$80
        DEFB    'A','T'+$80
        DEFM    "TA"
        DEFB    'B'+$80
        DEFM    "VAL"
        DEFB    '$'+$80
        DEFM    "COD"
        DEFB    'E'+$80
        DEFM    "VA"
        DEFB    'L'+$80
        DEFM    "LE"
        DEFB    'N'+$80
        DEFM    "SI"
        DEFB    'N'+$80
        DEFM    "CO"
        DEFB    'S'+$80
        DEFM    "TA"
        DEFB    'N'+$80
        DEFM    "AS"
        DEFB    'N'+$80
        DEFM    "AC"
        DEFB    'S'+$80
        DEFM    "AT"
        DEFB    'N'+$80
        DEFB    'L','N'+$80
        DEFM    "EX"
        DEFB    'P'+$80
        DEFM    "IN"
        DEFB    'T'+$80
        DEFM    "SQ"
        DEFB    'R'+$80
        DEFM    "SG"
        DEFB    'N'+$80
        DEFM    "AB"
        DEFB    'S'+$80
        DEFM    "PEE"
        DEFB    'K'+$80
        DEFB    'I','N'+$80
        DEFM    "US"
        DEFB    'R'+$80
        DEFM    "STR"
        DEFB    '$'+$80
        DEFM    "CHR"
        DEFB    '$'+$80
        DEFM    "NO"
        DEFB    'T'+$80
        DEFM    "BI"
        DEFB    'N'+$80

;   The previous 32 function-type words are printed without a leading space
;   The following have a leading space if they begin with a letter

        DEFB    'O','R'+$80
        DEFM    "AN"
        DEFB    'D'+$80
        DEFB    $3C,'='+$80             ; <=
        DEFB    $3E,'='+$80             ; >=
        DEFB    $3C,$3E+$80             ; <>
        DEFM    "LIN"
        DEFB    'E'+$80
        DEFM    "THE"
        DEFB    'N'+$80
        DEFB    'T','O'+$80
        DEFM    "STE"
        DEFB    'P'+$80
        DEFM    "DEF F"
        DEFB    'N'+$80
        DEFM    "CA"
        DEFB    'T'+$80
        DEFM    "FORMA"
        DEFB    'T'+$80
        DEFM    "MOV"
        DEFB    'E'+$80
        DEFM    "ERAS"
        DEFB    'E'+$80
        DEFM    "OPEN "
        DEFB    '#'+$80
        DEFM    "CLOSE "
        DEFB    '#'+$80
        DEFM    "MERG"
        DEFB    'E'+$80
        DEFM    "VERIF"
        DEFB    'Y'+$80
        DEFM    "BEE"
        DEFB    'P'+$80
        DEFM    "CIRCL"
        DEFB    'E'+$80
        DEFM    "IN"
        DEFB    'K'+$80
        DEFM    "PAPE"
        DEFB    'R'+$80
        DEFM    "FLAS"
        DEFB    'H'+$80
        DEFM    "BRIGH"
        DEFB    'T'+$80
        DEFM    "INVERS"
        DEFB    'E'+$80
        DEFM    "OVE"
        DEFB    'R'+$80
        DEFM    "OU"
        DEFB    'T'+$80
        DEFM    "LPRIN"
        DEFB    'T'+$80
        DEFM    "LLIS"
        DEFB    'T'+$80
        DEFM    "STO"
        DEFB    'P'+$80
        DEFM    "REA"
        DEFB    'D'+$80
        DEFM    "DAT"
        DEFB    'A'+$80
        DEFM    "RESTOR"
        DEFB    'E'+$80
        DEFM    "NE"
        DEFB    'W'+$80
        DEFM    "BORDE"
        DEFB    'R'+$80
        DEFM    "CONTINU"
        DEFB    'E'+$80
        DEFM    "DI"
        DEFB    'M'+$80
        DEFM    "RE"
        DEFB    'M'+$80
        DEFM    "FO"
        DEFB    'R'+$80
        DEFM    "GO T"
        DEFB    'O'+$80
        DEFM    "GO SU"
        DEFB    'B'+$80
        DEFM    "INPU"
        DEFB    'T'+$80
        DEFM    "LOA"
        DEFB    'D'+$80
        DEFM    "LIS"
        DEFB    'T'+$80
        DEFM    "LE"
        DEFB    'T'+$80
        DEFM    "PAUS"
        DEFB    'E'+$80
        DEFM    "NEX"
        DEFB    'T'+$80
        DEFM    "POK"
        DEFB    'E'+$80
        DEFM    "PRIN"
        DEFB    'T'+$80
        DEFM    "PLO"
        DEFB    'T'+$80
        DEFM    "RU"
        DEFB    'N'+$80
        DEFM    "SAV"
        DEFB    'E'+$80
        DEFM    "RANDOMIZ"
        DEFB    'E'+$80
        DEFB    'I','F'+$80
        DEFM    "CL"
        DEFB    'S'+$80
        DEFM    "DRA"
        DEFB    'W'+$80
        DEFM    "CLEA"
        DEFB    'R'+$80
        DEFM    "RETUR"
        DEFB    'N'+$80
        DEFM    "COP"
        DEFB    'Y'+$80

; ----------------
; THE 'KEY' TABLES
; ----------------
;   These six look-up tables are used by the keyboard reading routine
;   to decode the key values.
;
;   The first table contains the maps for the 39 keys of the standard
;   40-key Spectrum keyboard. The remaining key [SHIFT $27] is read directly.
;   The keys consist of the 26 upper-case alphabetic characters, the 10 digit
;   keys and the space, ENTER and symbol shift key.
;   Unshifted alphabetic keys have $20 added to the value.
;   The keywords for the main alphabetic keys are obtained by adding $A5 to
;   the values obtained from this table.

;; MAIN-KEYS
L0205:  DEFB    $42             ; B
        DEFB    $48             ; H
        DEFB    $59             ; Y
        DEFB    $36             ; 6
        DEFB    $35             ; 5
        DEFB    $54             ; T
        DEFB    $47             ; G
        DEFB    $56             ; V
        DEFB    $4E             ; N
        DEFB    $4A             ; J
        DEFB    $55             ; U
        DEFB    $37             ; 7
        DEFB    $34             ; 4
        DEFB    $52             ; R
        DEFB    $46             ; F
        DEFB    $43             ; C
        DEFB    $4D             ; M
        DEFB    $4B             ; K
        DEFB    $49             ; I
        DEFB    $38             ; 8
        DEFB    $33             ; 3
        DEFB    $45             ; E
        DEFB    $44             ; D
        DEFB    $58             ; X
        DEFB    $0E             ; SYMBOL SHIFT
        DEFB    $4C             ; L
        DEFB    $4F             ; O
        DEFB    $39             ; 9
        DEFB    $32             ; 2
        DEFB    $57             ; W
        DEFB    $53             ; S
        DEFB    $5A             ; Z
        DEFB    $20             ; SPACE
        DEFB    $0D             ; ENTER
        DEFB    $50             ; P
        DEFB    $30             ; 0
        DEFB    $31             ; 1
        DEFB    $51             ; Q
        DEFB    $41             ; A


;; E-UNSHIFT
;  The 26 unshifted extended mode keys for the alphabetic characters.
;  The green keywords on the original keyboard.
L022C:  DEFB    $E3             ; READ
        DEFB    $C4             ; BIN
        DEFB    $E0             ; LPRINT
        DEFB    $E4             ; DATA
        DEFB    $B4             ; TAN
        DEFB    $BC             ; SGN
        DEFB    $BD             ; ABS
        DEFB    $BB             ; SQR
        DEFB    $AF             ; CODE
        DEFB    $B0             ; VAL
        DEFB    $B1             ; LEN
        DEFB    $C0             ; USR
        DEFB    $A7             ; PI
        DEFB    $A6             ; INKEY$
        DEFB    $BE             ; PEEK
        DEFB    $AD             ; TAB
        DEFB    $B2             ; SIN
        DEFB    $BA             ; INT
        DEFB    $E5             ; RESTORE
        DEFB    $A5             ; RND
        DEFB    $C2             ; CHR$
        DEFB    $E1             ; LLIST
        DEFB    $B3             ; COS
        DEFB    $B9             ; EXP
        DEFB    $C1             ; STR$
        DEFB    $B8             ; LN


;; EXT-SHIFT
;  The 26 shifted extended mode keys for the alphabetic characters.
;  The red keywords below keys on the original keyboard.
L0246:  DEFB    $7E             ; ~
        DEFB    $DC             ; BRIGHT
        DEFB    $DA             ; PAPER
        DEFB    $5C             ; \ ;
        DEFB    $B7             ; ATN
        DEFB    $7B             ; {
        DEFB    $7D             ; }
        DEFB    $D8             ; CIRCLE
        DEFB    $BF             ; IN
        DEFB    $AE             ; VAL$
        DEFB    $AA             ; SCREEN$
        DEFB    $AB             ; ATTR
        DEFB    $DD             ; INVERSE
        DEFB    $DE             ; OVER
        DEFB    $DF             ; OUT
        DEFB    $7F             ; (Copyright character)
        DEFB    $B5             ; ASN
        DEFB    $D6             ; VERIFY
        DEFB    $7C             ; |
        DEFB    $D5             ; MERGE
        DEFB    $5D             ; ]
        DEFB    $DB             ; FLASH
        DEFB    $B6             ; ACS
        DEFB    $D9             ; INK
        DEFB    $5B             ; [
        DEFB    $D7             ; BEEP


;; CTL-CODES
;  The ten control codes assigned to the top line of digits when the shift 
;  key is pressed.
L0260:  DEFB    $0C             ; DELETE
        DEFB    $07             ; EDIT
        DEFB    $06             ; CAPS LOCK
        DEFB    $04             ; TRUE VIDEO
        DEFB    $05             ; INVERSE VIDEO
        DEFB    $08             ; CURSOR LEFT
        DEFB    $0A             ; CURSOR DOWN
        DEFB    $0B             ; CURSOR UP
        DEFB    $09             ; CURSOR RIGHT
        DEFB    $0F             ; GRAPHICS


;; SYM-CODES
;  The 26 red symbols assigned to the alphabetic characters of the keyboard.
;  The ten single-character digit symbols are converted without the aid of
;  a table using subtraction and minor manipulation. 
L026A:  DEFB    $E2             ; STOP
        DEFB    $2A             ; *
        DEFB    $3F             ; ?
        DEFB    $CD             ; STEP
        DEFB    $C8             ; >=
        DEFB    $CC             ; TO
        DEFB    $CB             ; THEN
        DEFB    $5E             ; ^
        DEFB    $AC             ; AT
        DEFB    $2D             ; -
        DEFB    $2B             ; +
        DEFB    $3D             ; =
        DEFB    $2E             ; .
        DEFB    $2C             ; ,
        DEFB    $3B             ; ;
        DEFB    $22             ; "
        DEFB    $C7             ; <=
        DEFB    $3C             ; <
        DEFB    $C3             ; NOT
        DEFB    $3E             ; >
        DEFB    $C5             ; OR
        DEFB    $2F             ; /
        DEFB    $C9             ; <>
        DEFB    $60             ; pound
        DEFB    $C6             ; AND
        DEFB    $3A             ; :

;; E-DIGITS
;  The ten keywords assigned to the digits in extended mode.
;  The remaining red keywords below the keys.
L0284:  DEFB    $D0             ; FORMAT
        DEFB    $CE             ; DEF FN
        DEFB    $A8             ; FN
        DEFB    $CA             ; LINE
        DEFB    $D3             ; OPEN #
        DEFB    $D4             ; CLOSE #
        DEFB    $D1             ; MOVE
        DEFB    $D2             ; ERASE
        DEFB    $A9             ; POINT
        DEFB    $CF             ; CAT
