; ================================================================================
; An Assembly Listing of the Operating System of the ZX81 version 2 (improved) ROM
; ================================================================================
;
; Work in progress.
; This file will cross-assemble an original version of the "Improved"
; ZX81 ROM.  The file can be modified to change the behaviour of the ROM
; when used in emulators although there is no spare space available.
;
; The documentation is incomplete and if you can find a copy
; of "The Complete Spectrum ROM Disassembly" then many routines
; such as POINTERS and most of the mathematical routines are
; similar and often identical.
;
; I've used the labels from the above book in this file and also
; some from the more elusive Complete ZX81 ROM Disassembly
; by the same publishers, Melbourne House.


; ================
; ZX-81 MEMORY MAP
; ================

; +------------------+-- Top of memory
; | Reserved area    |
; +------------------+-- (RAMTOP)
; | GOSUB stack      |
; +------------------+-- (ERR_SP)
; | Machine stack    |
; +------------------+-- SP
; | Spare memory     |
; +------------------+-- (STKEND)
; | Calculator stack |
; +------------------+-- (STKBOT)
; | Edit line        |
; +------------------+-- (E_LINE)
; | User variables   |
; +------------------+-- (VARS)
; | Screen           |
; +------------------+-- (D_FILE)
; | User program     |
; +------------------+-- 407Dh (16509d)
; | System variables |
; +------------------+-- 4000h (16384d)

; ======================
; ZX-81 User VARIABLES
; ======================
;
; Example for the following code:
;       10 LET Z=100
;       20 LET ABC=1
;       30 DIM N(4)
;       40 FOR I=1 TO 10
;       50 LET H$="HELLO"
;       60 DIM Z$(100)
;
; VARS:
;       7F = %011 vvvvv, v = Z - number Z
;           87 48 00 00 00      - value
;
;       A6 = %101 vvvvv, v = A
;       27 = %001 vvvvv, V = B
;       A8 = %101 vvvvv, v = C - long number ABC
;           81 00 00 00 00      - value
;
;       93 = %100 vvvvv, v = N - array of numbers
;           17 00               - total length of elements & dimensions + 1 = 23
;           01                  - number of dimensions = 1
;           04 00               - first dimension = 4
;           00 00 00 00 00      - N(1)
;           00 00 00 00 00      - N(2)
;           00 00 00 00 00      - N(3)
;           00 00 00 00 00      - N(4)
;
;       EE = %111 vvvvv, v = I - loop control variable
;           81 00 00 00 00      - value
;           84 20 00 00 00      - limit
;           81 00 00 00 00      - step
;           29 00               - looping line = 41 (LSB first, manual says MSB first)
;
;       4D = %010 vvvvv, v = H - string
;           05 00               - length = 5
;           2D 2A 31 31 34      - "HELLO"
;
;       DF = %110 vvvvv, v = Z - array of characters
;           67 00               - total length of elements & dimensions + 1 = 103
;           01                  - number of dimensions = 1
;           64 00               - first dimension = 100
;           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
;           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
;           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
;           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
;           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 - 20*5 blank spaces
;
;       80 = %100 00000 - end marker
;


; -------------------
; THE 'CHARACTER SET'
; -------------------
;
; $00 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $0D $0E $0F
;     gra gra gra gra gra gra gra gra gra gra  "  pnd  $   :   ?
;
; $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $1A $1B $1C $1D $1E $1F
;  (   )   >   <   =   +   -   *   /   ;   ,   .   0   1   2   3
;
; $20 $21 $22 $23 $24 $25 $26 $27 $28 $29 $2A $2B $2C $2D $2E $2F
;  4   5   6   7   8   9   A   B   C   D   E   F   G   H   I   J
;
; $30 $31 $32 $33 $34 $35 $36 $37 $38 $39 $3A $3B $3C $3D $3E $3F
;  K   L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z
;


; -------------------
; THE 'ZX81 KEYBOARD'
; -------------------
;
;                                [] mosaic graphic
;
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
; | EDIT| |  AND| | THEN| |  TO | |  <- | |   v | |   ^ | |  -> | |GRAPH| | RUB |
; | 1 []| | 2 []| | 3 []| | 4 []| | 5 []| | 6 []| | 7 []| | 8 []| | 9   | | 0   |
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
;
;  PLOT   UNPLOT    REM     RUN     RAND  RETURN    IF     INPUT   POKE    PRINT
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
; |  "" | |  OR | | STEP| |  <= | |  <> | |  >= | |   $ | |   ( | |   ) | |   " |
; | Q []| | W []| | E []| | R []| | T []| | Y []| | U   | | I   | | O   | | P   |
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
;
;   NEW    SAVE     DIM     FOR     GOTO   GOSUB   LOAD    LIST     LET
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
; | STOP| |LPRNT| | SLOW| | FAST| |LLIST| |  ** | |   - | |   + | |   = | |FUNCT|
; | A []| | S []| | D []| | F []| | G []| | H []| | J   | | K   | | L   | | N/L |
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
;
;          COPY    CLEAR   CONT     CLS   SCROLL    NEXT   PAUSE           BREAK
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
; |     | |   : | |   ; | |   ? | |   / | |   * | |   < | |   > | |   , | |  pnd|
; |SHIFT| | Z   | | X   | | C   | | V   | | B   | | N   | | M   | | .   | |SPACE|
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
;
;
; Graphic Character Locations
; ---------------------------
;
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;  |# |  | #|  |  |  |  |  |# |    |  |  |##|  | #|  |  |  |  |
;  |  |  |  |  | #|  |# |  |# |    |##|  |  |  | #|  |  |  |  |
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;  | #|  |# |  |##|  |##|  | #|    |# |  |  |  |  |  |  |  |  |
;  |##|  |##|  |# |  | #|  |# |    | #|  |  |  |  |  |  |  |  |
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;  |XX|  |XX|  |  |  |xx|  |##|    |xx|  |  |  |  |  |  |  |  |
;  |XX|  |  |  |XX|  |##|  |xx|    |xx|  |  |  |  |  |  |  |  |
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;  |  |  |  |  |  |  |  |  |  |    |  |  |  |  |  |  |  |  |  |
;  |  |  |  |  |  |  |  |  |  |    |  |  |  |  |  |  |  |  |  |
;  +--+  +--+  +--+  +--+  +--+    +--+  +--+  +--+  +--+  +--+
;

; ======================
; ZX-81 SYSTEM VARIABLES
; ======================
; X The variable should not be poked, because the system might crash.
; N Poking the variable will have no lasting effect.
; S The variable is saved by SAVE.
;
defc    ERR_NR  = $4000         ;    1  16384
                                ;       1 less than the report code. Starts off
                                ;       at 255 (for -1), so PEEK 16384, if it
                                ;       works at all, gives 255.
                                ;       POKE 16384,n can be used to force an
                                ;       error halt: 0 <= n <= 14 gives one of
                                ;       the usual reports, 15 <= n <= 34 or
                                ;       99 <= n <= 127 gives a nonstandard
                                ;       report, and 35 <= n <= 98 is likely to
                                ;       mess up the display file.
defc    FLAGS   = $4001         ;   X1  16385
                                ;       Various flags to control the BASIC system.
defc    ERR_SP  = $4002         ;   X2  16386
                                ;       Address of first item on machine stack
                                ;       (after GOSUB returns).
defc    RAMTOP  = $4004         ;    2  16388
                                ;       Address of first byte above BASIC system
                                ;       area. You can poke this to make NEW
                                ;       reserve space above that area (see
                                ;       Chapter 26) or to fool CLS into setting
                                ;       up a minimal display file (Chapter 27).
defc    MODE    = $4006         ;   N1  16390
                                ;       Specifies K, L, F or G cursor.
defc    PPC     = $4007         ;   N2  16391
                                ;       Line number of statement currently being
                                ;       executed. Poking this has no lasting
                                ;       effect except in the last line of the
                                ;       program.
defc    VERSN   = $4009         ;   S1  16393
                                ;       0 identifies 8K ROM in saved programs.
defc    E_PPC   = $400A         ;   S2  16394
                                ;       Number of current line (with program
                                ;       cursor).
defc    D_FILE  = $400C         ;  SX2  16396
                                ;       The display file is the memory copy of
                                ;       the television picture. It begins with a
                                ;       NEWLINE character, & then has the twenty
                                ;       four lines of text, each finishing with
                                ;       a NEWLINE.
defc    DF_CC   = $400E         ;   S2  16398
                                ;       Address of PRINT position in display
                                ;       file. Can be poked so that PRINT output
                                ;       is sent elsewhere.
defc    VARS    = $4010         ;  SX2  16400
                                ;       The variables have different formats
                                ;       according to their different natures.
defc    DEST    = $4012         ;  SN2  16402
                                ;       Address of variable in assignment.
defc    E_LINE  = $4014         ;  SX2  16404
                                ;       Contains the line being typed (as a
                                ;       command, a program line, or INPUT data)
                                ;       & also some work space.
defc    CH_ADD  = $4016         ;  SX2  16406
                                ;       Address of the next character to be
                                ;       interpreted: the character after the
                                ;       argument of PEEK, or the ENTER at the
                                ;       end of a POKE statement.
defc    X_PTR   = $4018         ;   S2  16408
                                ;       Address of the character preceding the
                                ;       syntax error marker.
defc    STKBOT  = $401A         ;  SX2  16410
                                ;       Calculator stack start. The calculator
                                ;       stack is the part of the BASIC system
                                ;       that deals with arithmetic, & the
                                ;       numbers on which it is operating are
                                ;       held mostly in the calculator stack.
defc    STKEND  = $401C         ;  SX2  16412
                                ;       Calculator stack end.
defc    BREG    = $401E         ;  SN1  16414
                                ;       Calculator's b register.
defc    MEM     = $401F         ;  SN2  16415
                                ;       Address of area used for calculator's
                                ;       memory. (Usually MEMBOT but not always.)
defc    SPARE1  = $4021         ;   S1  16417
                                ;       Not used.
defc    DF_SZ   = $4022         ;  SX1  16418
                                ;       The number of lines (including one blank
                                ;       line) in the lower part of the screen.
defc    S_TOP   = $4023         ;   S2  16419
                                ;       The number of the top program line in
                                ;       automatic listings.
defc    LAST_K  = $4025         ;  SN2  16421
                                ;       Shows which keys pressed.
defc    DB_ST   = $4027         ;  SN1  16423
                                ;       Debounce status of keyboard.
defc    MARGIN  = $4028         ;  SN1  16424
                                ;       Number of blank lines above or below
                                ;       picture - 31.
defc    NXTLIN  = $4029         ;  SX2  16425
                                ;       Address of next program line to be
                                ;       executed.
defc    OLDPPC  = $402B         ;   S2  16427
                                ;       Line number to which CONT jumps.
defc    FLAGX   = $402D         ;  SN1  16429
                                ;       Various flags.
defc    STRLEN  = $402E         ;  SN2  16430
                                ;       Length of string type designation in
                                ;       assignment.
defc    T_ADDR  = $4030         ;  SN2  16432
                                ;       Address of next item in syntax table
                                ;       (very unlikely to be useful).
defc    SEED    = $4032         ;   S2  16434
                                ;       The seed for RND. This is the variable
                                ;       that is set by RAND.
defc    FRAMES  = $4034         ;   S2  16436
                                ;       Counts the frames displayed on the
                                ;       television. Bit 15 is 1. Bits 0 to 14
                                ;       are decremented for each frame sent to
                                ;       the television. This can be used for
                                ;       timing, but PAUSE also uses it.
                                ;       PAUSE resets bit 15 to 0 and puts in
                                ;       bits 0 to 14 the length of the pause.
                                ;       When these have been counted down to
                                ;       zero, the pause stops. If the pause
                                ;       stops because of a key depression, bit
                                ;       15 is set to 1 again.
defc    COORDS  = $4036         ;   S1  16438
                                ;       x-coordinate of last pointed PLOTted.
                                ;   S1  16439
                                ;       y-coordinate of last pointed PLOTted.
defc    PR_CC   = $4038         ;   S1  16440
                                ;       Less significant byte of address of next
                                ;       position for LPRINT to print at (in
                                ;       PRBUFF).
defc    S_POSN  = $4039         ;  SX1  16441
                                ;       Column number for PRINT position.
                                ;  SX1  16442
                                ;       Line number for PRINT position.
defc    CDFLAG  = $403B         ;   S1  16443
                                ;       Various flags.
                                ;       Bit 7 is 1 during compute and display
                                ;       mode, 0 for fast mode.
                                ;       Bit 6 is 1 to request slow mode, 0 to
                                ;       request fast mode. If slow mode not
                                ;       available then bit 6 is set back to 0.
                                ;       If slow mode is available then bit 7
                                ;       will be set to 1.
                                ;       Bit 0 is set if key available.
defc    PRBUFF  = $403C         ;  S33  16444
                                ;       Printer buffer (33rd character is ENTER).
defc    MEMBOT  = $405D         ; SN30  16477
                                ;       Calculator's memory area; used to store
                                ;       numbers that cannot conveniently be put
                                ;       on the calculator stack.
defc    SPARE2  = $407B         ;   S2  16507
                                ;       Not used.

defc    PROG    = $407D         ;       16509
                                ;       Start of BASIC program

defc    MAXRAM  = $7FFF         ; Maximum value of RAMTOP

defc    IY0     = ERR_NR        ; Base of system variables


; =================
; ZX-81 Error Codes
; =================

; 0     Successful completion, or jump to line number bigger than any
;       existing. A report with code 0 does not change the line number
;       used by CONT.
defc    ERR_0_OK = 0 - 1

; 1     The control variable does not exist (has not been set up by a
;       FOR statement) but there is an ordinary variable with the same
;       name.
defc    ERR_1_NEXT_WO_FOR = 1 - 1

; 2     An undefined variable has been used.
;       For a simple variable this will happen if the variable is used
;       before it has been assigned to in a LET statement.
;       For a subscripted variable it will happen if the variable is used
;       before it has been dimensioned in a DIM statement.
;       For a control variable this will happen if the variable is used
;       before it has been set up as a control variable in a FOR
;       statement, when there is no ordinary simple variable with the
;       same name.
defc    ERR_2_UNDEF_VAR = 2 - 1

; 3     Subscript out of range.
;       If the subscript is hopelessly out of range (negative, or bigger
;       than 65535) then error B will result.
defc    ERR_3_SUBSCRIPT_RANGE = 3 - 1

; 4     Not enough room in memory. Note that the line number in the
;       report (after the /) may be incomplete on the screen, because of
;       the shortage of memory: for instance 4/20 may appear as 4/2.
;       See chapter 23. For GOSUB see exercise 6 of chapter 14.
defc    ERR_4_NO_ROOM = 4 - 1

; 5     No more room on the screen. CONT will make room by clearing
;       the screen.
defc    ERR_4_SCREEN_FULL = 5 - 1

; 6     Arithmetic overflow: calculations have led to a number greater
;       than about 10^38.
defc    ERR_6_OVERFLOW = 6 - 1

; 7     No corresponding GOSUB for a RETURN statement.
defc    ERR_7_RET_WO_GOSUB = 7 - 1

; 8     You have attempted INPUT as a command (not allowed).
defc    ERR_8_EOF = 8 - 1

; 9     STOP statement executed. CONT will not try to re-execute the
;       STOP statement.
defc    ERR_9_STOP = 9 - 1

; A     Invalid argument to certain functions.
defc    ERR_A_INVALID_ARG = $0A - 1

; B     Integer out of range. When an integer is required, the floating
;       point argument is rounded to the nearest integer. If this is
;       outside a suitable range then error B results.
;       For array access, see also report 3.
defc    ERR_B_INT_OVERFLOW = $0B - 1

; C     The text of the (string) argument of VAL does not form a valid
;       numerical expression.
defc    ERR_C_NONSENSE = $0C - 1

; D     (i) Program interrupted by BREAK.
;       (ii) The INPUT line starts with STOP.
defc    ERR_D_BREAK = $0D - 1

; E     Not used
;
; F     The program name provided is the empty string.
defc    ERR_F_PROG_NAME = $0F - 1



org     $0000


;*****************************************
;** Part 1. RESTART ROUTINES AND TABLES **
;*****************************************

; -----------
; THE 'START'
; -----------
; All Z80 chips start at location zero.
; At start-up the Interrupt Mode is 0, ZX computers use Interrupt Mode 1.
; Interrupts are disabled .

START:
        out     ($FD), a        ; Turn off the NMI generator if this ROM is
                                ; running in ZX81 hardware. This does nothing
                                ; if this ROM is running within an upgraded
                                ; ZX80.
        ld      bc, MAXRAM      ; Set BC to the top of possible RAM.
                                ; The higher unpopulated addresses are used for
                                ; video generation.
        jp      RAM_CHECK       ; Jump forward to RAM-CHECK.

; -------------------
; THE 'ERROR' RESTART
; -------------------
; The error restart deals immediately with an error. ZX computers execute the
; same code in runtime as when checking syntax. If the error occurred while
; running a program then a brief report is produced. If the error occurred
; while entering a BASIC line or in input etc., then the error marker indicates
; the exact point at which the error lies.

ERROR_1:
        ld      hl, (CH_ADD)    ; fetch character address from CH_ADD.
        ld      (X_PTR), hl     ; and set the error pointer X_PTR.
        jr      ERROR_2         ; forward to continue at ERROR-2.

; ---

; -------------------------------
; THE 'PRINT A CHARACTER' RESTART
; -------------------------------
; This restart prints the character in the accumulator using the alternate
; register set so there is no requirement to save the main registers.
; There is sufficient room available to separate a space (zero) from other
; characters as leading spaces need not be considered with a space.
; Note. the accumulator is preserved only when printing to the screen.

PRINT_A:
        and     a               ; test for zero - space.
        jp      nz, PRINT_CH    ; jump forward if not to PRINT-CH.

        jp      PRINT_SP        ; jump forward to PRINT-SP.

; ---

        defs    PRINT_A + 8 - ASMPC, $FF
                                ; fill remaining space

; ---------------------------------
; THE 'COLLECT A CHARACTER' RESTART
; ---------------------------------
; The character addressed by the system variable CH_ADD is fetched and if it
; is a non-space, non-cursor character it is returned else CH_ADD is
; incremented and the new addressed character tested until it is not a space.

GET_CHAR:
        ld      hl, (CH_ADD)    ; set HL to character address CH_ADD.
        ld      a, (hl)         ; fetch addressed character to A.

TEST_SP:
        and     a               ; test for space.
        ret     nz              ; return if not a space

        nop                     ; else trickle through
        nop                     ; to the next routine.

; ------------------------------------
; THE 'COLLECT NEXT CHARACTER' RESTART
; ------------------------------------
; The character address in incremented and the new addressed character is
; returned if not a space, or cursor, else the process is repeated.

NEXT_CHAR:
        call    INC_CH_ADD      ; routine CH-ADD+1 gets next immediate
                                ; character.
        jr      TEST_SP         ; back to TEST-SP.

; ---

        defs    NEXT_CHAR + 8 - ASMPC, $FF
                                ; unused locations.

; ---------------------------------------
; THE 'FLOATING POINT CALCULATOR' RESTART
; ---------------------------------------
; this restart jumps to the recursive floating-point calculator.
; the ZX81's internal, FORTH-like, stack-based language.
;
; In the five remaining bytes there is, appropriately, enough room for the
; end-calc literal - the instruction which exits the calculator.

FP_CALC:
        jp      CALCULATE       ; jump immediately to the CALCULATE routine.

; ---

end_calc:
        pop     af              ; drop the calculator return address RE-ENTRY
        exx                     ; switch to the other set.

        ex      (sp), hl        ; transfer H'L' to machine stack for the
                                ; return address.
                                ; when exiting recursion then the previous
                                ; pointer is transferred to H'L'.

        exx                     ; back to main set.
        ret                     ; return.


; -----------------------------
; THE 'MAKE BC SPACES'  RESTART
; -----------------------------
; This restart is used eight times to create, in workspace, the number of
; spaces passed in the BC register.

BC_SPACES:
        push    bc              ; push number of spaces on stack.
        ld      hl, (E_LINE)    ; fetch edit line location from E_LINE.
        push    hl              ; save this value on stack.
        jp      RESERVE         ; jump forward to continue at RESERVE.

; -----------------------
; THE 'INTERRUPT' RESTART
; -----------------------
;   The Mode 1 Interrupt routine is concerned solely with generating the central
;   television picture.
;   On the ZX81 interrupts are enabled only during the interrupt routine,
;   although the interrupt
;   This Interrupt Service Routine automatically disables interrupts at the
;   outset and the last interrupt in a cascade exits before the interrupts are
;   enabled.
;   There is no DI instruction in the ZX81 ROM.
;   An maskable interrupt is triggered when bit 6 of the Z80's Refresh register
;   changes from set to reset.
;   The Z80 will always be executing a HALT (NEWLINE) when the interrupt occurs.
;   A HALT instruction repeatedly executes NOPS but the seven lower bits
;   of the Refresh register are incremented each time as they are when any
;   simple instruction is executed. (The lower 7 bits are incremented twice for
;   a prefixed instruction)
;   This is controlled by the Sinclair Computer Logic Chip - manufactured from
;   a Ferranti Uncommitted Logic Array.
;
;   When a Mode 1 Interrupt occurs the Program Counter, which is the address in
;   the upper echo display following the NEWLINE/HALT instruction, goes on the
;   machine stack.  193 interrupts are required to generate the last part of
;   the 56th border line and then the 192 lines of the central TV picture and,
;   although each interrupt interrupts the previous one, there are no stack
;   problems as the 'return address' is discarded each time.
;
;   The scan line counter in C counts down from 8 to 1 within the generation of
;   each text line. For the first interrupt in a cascade the initial value of
;   C is set to 1 for the last border line.
;   Timing is of the utmost importance as the RH border, horizontal retrace
;   and LH border are mostly generated in the 58 clock cycles this routine
;   takes .

INTERRUPT:
        dec     c               ; (4)  decrement C - the scan line counter.
        jp      nz, SCAN_LINE   ; (10/10) jump forward if not zero to SCAN-LINE

        pop     hl              ; (10) point to start of next row in display
                                ;      file.

        dec     b               ; (4)  decrement the row counter. (4)
        ret     z               ; (11/5) return when picture complete to DISPLAY_5_RET
                                ;      with interrupts disabled.

        set     3, c            ; (8)  Load the scan line counter with eight.
                                ;      Note. LD C, $08 is 7 clock cycles which
                                ;      is way too fast.

; ->

WAIT_INT:
        ld      r, a            ; (9) Load R with initial rising value $DD.

        ei                      ; (4) Enable Interrupts.  [ R is now $DE ].

        jp      (hl)            ; (4) jump to the echo display file in upper
                                ;     memory and execute characters $00 - $3F
                                ;     as NOP instructions.  The video hardware
                                ;     is able to read these characters and,
                                ;     with the I register is able to convert
                                ;     the character bitmaps in this ROM into a
                                ;     line of bytes. Eventually the NEWLINE/HALT
                                ;     will be encountered before R reaches $FF.
                                ;     It is however the transition from $FF to
                                ;     $80 that triggers the next interrupt.
                                ;     [ The Refresh register is now $DF ]

; ---

SCAN_LINE:
        pop     de              ; (10) discard the address after NEWLINE as the
                                ;      same text line has to be done again
                                ;      eight times.

        ret     z               ; (5)  Harmless Nonsensical Timing.
                                ;      (condition never met)

        jr      WAIT_INT        ; (12) back to WAIT-INT

;   Note. that a computer with less than 4K or RAM will have a collapsed
;   display file and the above mechanism deals with both types of display.
;
;   With a full display, the 32 characters in the line are treated as NOPS
;   and the Refresh register rises from $E0 to $FF and, at the next instruction
;   - HALT, the interrupt occurs.
;   With a collapsed display and an initial NEWLINE/HALT, it is the NOPs
;   generated by the HALT that cause the Refresh value to rise from $E0 to $FF,
;   triggering an Interrupt on the next transition.
;   This works happily for all display lines between these extremes and the
;   generation of the 32 character, 1 pixel high, line will always take 128
;   clock cycles.

; ---------------------------------
; THE 'INCREMENT CH-ADD' SUBROUTINE
; ---------------------------------
; This is the subroutine that increments the character address system variable
; and returns if it is not the cursor character. The ZX81 has an actual
; character at the cursor position rather than a pointer system variable
; as is the case with prior and subsequent ZX computers.

INC_CH_ADD:
        ld      hl, (CH_ADD)    ; fetch character address to CH_ADD.

TEMP_PTR1:
        inc     hl              ; address next immediate location.

TEMP_PTR2:
        ld      (CH_ADD), hl    ; update system variable CH_ADD.

        ld      a, (hl)         ; fetch the character.
        cp      $7F             ; compare to cursor character.
        ret     nz              ; return if not the cursor.

        jr      TEMP_PTR1       ; back for next character to TEMP-PTR1.

; --------------------
; THE 'ERROR-2' BRANCH
; --------------------
; This is a continuation of the error restart.
; If the error occurred in runtime then the error stack pointer will probably
; lead to an error report being printed unless it occurred during input.
; If the error occurred when checking syntax then the error stack pointer
; will be an editing routine and the position of the error will be shown
; when the lower screen is reprinted.

ERROR_2:
        pop     hl              ; pop the return address which points to the
                                ; DEFB, error code, after the RST 08.
        ld      l, (hl)         ; load L with the error code. HL is not needed
                                ; anymore.

ERROR_3:
        ld      (iy+ERR_NR-IY0), l
                                ; place error code in system variable ERR_NR
        ld      sp, (ERR_SP)    ; set the stack pointer from ERR_SP
        call    SLOW_FAST       ; routine SLOW/FAST selects slow mode.
        jp      SET_MIN         ; exit to address on stack via routine SET-MIN.

; ---

        defs    0x0066 - ASMPC, $FF
                                ; unused.

; ------------------------------------
; THE 'NON MASKABLE INTERRUPT' ROUTINE
; ------------------------------------
;   Jim Westwood's technical dodge using Non-Maskable Interrupts solved the
;   flicker problem of the ZX80 and gave the ZX81 a multi-tasking SLOW mode
;   with a steady display.  Note that the AF' register is reserved for this
;   function and its interaction with the display routines.  When counting
;   TV lines, the NMI makes no use of the main registers.
;   The circuitry for the NMI generator is contained within the SCL (Sinclair
;   Computer Logic) chip.
;   ( It takes 32 clock cycles while incrementing towards zero ).

NMI:
        ex      af, af'         ; (4) switch in the NMI's copy of the
                                ;     accumulator.
        inc     a               ; (4) increment.
        jp      m, NMI_RET      ; (10/10) jump, if minus, to NMI-RET as this is
                                ;     part of a test to see if the NMI
                                ;     generation is working or an intermediate
                                ;     value for the ascending negated blank
                                ;     line counter.

        jr      z, NMI_CONT     ; (12) forward to NMI-CONT
                                ;      when line count has incremented to zero.

; Note. the synchronizing NMI when A increments from zero to one takes this
; 7 clock cycle route making 39 clock cycles in all.

NMI_RET:
        ex      af, af'         ; (4)  switch out the incremented line counter
                                ;      or test result $80
        ret                     ; (10) return to User application for a while.

; ---

;   This branch is taken when the 55 (or 31) lines have been drawn.

NMI_CONT:
        ex      af, af'         ; (4) restore the main accumulator.

        push    af              ; (11) *             Save Main Registers
        push    bc              ; (11) **
        push    de              ; (11) ***
        push    hl              ; (11) ****

;   the next set-up procedure is only really applicable when the top set of
;   blank lines have been generated.

        ld      hl, (D_FILE)    ; (16) fetch start of Display File from D_FILE
                                ;      points to the HALT at beginning.
        set     7, h            ; (8) point to upper 32K 'echo display file'

        halt                    ; (1) HALT synchronizes with NMI.
                                ; Used with special hardware connected to the
                                ; Z80 HALT and WAIT lines to take 1 clock cycle.

; ----------------------------------------------------------------------------
;   the NMI has been generated - start counting. The cathode ray is at the RH
;   side of the TV.
;   First the NMI servicing, similar to CALL            =  17 clock cycles.
;   Then the time taken by the NMI for zero-to-one path =  39 cycles
;   The HALT above                                      =  01 cycles.
;   The two instructions below                          =  19 cycles.
;   The code at L0281 up to and including the CALL      =  43 cycles.
;   The Called routine at L02B5                         =  24 cycles.
;   --------------------------------------                ---
;   Total Z80 instructions                              = 143 cycles.
;
;   Meanwhile in TV world,
;   Horizontal retrace                                  =  15 cycles.
;   Left blanking border 8 character positions          =  32 cycles
;   Generation of 75% scanline from the first NEWLINE   =  96 cycles
;   ---------------------------------------               ---
;                                                         143 cycles
;
;   Since at the time the first JP (HL) is encountered to execute the echo
;   display another 8 character positions have to be put out, then the
;   Refresh register need to hold $F8. Working back and counteracting
;   the fact that every instruction increments the Refresh register then
;   the value that is loaded into R needs to be $F5.      :-)
;
;
        out     ($FD), a        ; (11) Stop the NMI generator.

        jp      (ix)            ; (8) forward to L0281 (after top) or L028F


; ****************
; ** KEY TABLES **
; ****************

; -------------------------------
; THE 'UNSHIFTED' CHARACTER CODES
; -------------------------------

K_UNSHIFT:
        defb    $3F             ; Z
        defb    $3D             ; X
        defb    $28             ; C
        defb    $3B             ; V
        defb    $26             ; A
        defb    $38             ; S
        defb    $29             ; D
        defb    $2B             ; F
        defb    $2C             ; G
        defb    $36             ; Q
        defb    $3C             ; W
        defb    $2A             ; E
        defb    $37             ; R
        defb    $39             ; T
        defb    $1D             ; 1
        defb    $1E             ; 2
        defb    $1F             ; 3
        defb    $20             ; 4
        defb    $21             ; 5
        defb    $1C             ; 0
        defb    $25             ; 9
        defb    $24             ; 8
        defb    $23             ; 7
        defb    $22             ; 6
        defb    $35             ; P
        defb    $34             ; O
        defb    $2E             ; I
        defb    $3A             ; U
        defb    $3E             ; Y
        defb    $76             ; NEWLINE
        defb    $31             ; L
        defb    $30             ; K
        defb    $2F             ; J
        defb    $2D             ; H
        defb    $00             ; SPACE
        defb    $1B             ; .
        defb    $32             ; M
        defb    $33             ; N
        defb    $27             ; B

; -----------------------------
; THE 'SHIFTED' CHARACTER CODES
; -----------------------------

K_SHIFT:
        defb    $0E             ; :
        defb    $19             ; ;
        defb    $0F             ; ?
        defb    $18             ; /
        defb    $E3             ; STOP
        defb    $E1             ; LPRINT
        defb    $E4             ; SLOW
        defb    $E5             ; FAST
        defb    $E2             ; LLIST
        defb    $C0             ; ""
        defb    $D9             ; OR
        defb    $E0             ; STEP
        defb    $DB             ; <=
        defb    $DD             ; <>
        defb    $75             ; EDIT
        defb    $DA             ; AND
        defb    $de             ; THEN
        defb    $DF             ; TO
        defb    $72             ; cursor-left
        defb    $77             ; RUBOUT
        defb    $74             ; GRAPHICS
        defb    $73             ; cursor-right
        defb    $70             ; cursor-up
        defb    $71             ; cursor-down
        defb    $0B             ; "
        defb    $11             ; )
        defb    $10             ; (
        defb    $0D             ; $
        defb    $DC             ; >=
        defb    $79             ; FUNCTION
        defb    $14             ; =
        defb    $15             ; +
        defb    $16             ; -
        defb    $D8             ; **
        defb    $0C             ; ukp
        defb    $1A             ; ,
        defb    $12             ; >
        defb    $13             ; <
        defb    $17             ; *

; ------------------------------
; THE 'FUNCTION' CHARACTER CODES
; ------------------------------

K_FUNCT:
        defb    $CD             ; LN
        defb    $CE             ; EXP
        defb    $C1             ; AT
        defb    $78             ; KL
        defb    $CA             ; ASN
        defb    $CB             ; ACS
        defb    $CC             ; ATN
        defb    $D1             ; SGN
        defb    $D2             ; ABS
        defb    $C7             ; SIN
        defb    $C8             ; COS
        defb    $C9             ; TAN
        defb    $CF             ; INT
        defb    $40             ; RND
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $C2             ; TAB
        defb    $D3             ; PEEK
        defb    $C4             ; CODE
        defb    $D6             ; CHR$
        defb    $D5             ; STR$
        defb    $78             ; KL
        defb    $D4             ; USR
        defb    $C6             ; LEN
        defb    $C5             ; VAL
        defb    $D0             ; SQR
        defb    $78             ; KL
        defb    $78             ; KL
        defb    $42             ; PI
        defb    $D7             ; NOT
        defb    $41             ; INKEY$

; -----------------------------
; THE 'GRAPHIC' CHARACTER CODES
; -----------------------------

K_GRAPH:
        defb    $08             ; graphic
        defb    $0A             ; graphic
        defb    $09             ; graphic
        defb    $8A             ; graphic
        defb    $89             ; graphic
        defb    $81             ; graphic
        defb    $82             ; graphic
        defb    $07             ; graphic
        defb    $84             ; graphic
        defb    $06             ; graphic
        defb    $01             ; graphic
        defb    $02             ; graphic
        defb    $87             ; graphic
        defb    $04             ; graphic
        defb    $05             ; graphic
        defb    $77             ; RUBOUT
        defb    $78             ; KL
        defb    $85             ; graphic
        defb    $03             ; graphic
        defb    $83             ; graphic
        defb    $8B             ; graphic
        defb    $91             ; inverse )
        defb    $90             ; inverse (
        defb    $8D             ; inverse $
        defb    $86             ; graphic
        defb    $78             ; KL
        defb    $92             ; inverse >
        defb    $95             ; inverse +
        defb    $96             ; inverse -
        defb    $88             ; graphic

; ------------------
; THE 'TOKEN' TABLES
; ------------------

TOKENS_TAB:
        defb    $0F+$80         ; '?'+$80
        defb    $0B, $0B+$80    ; ""
        defb    $26, $39+$80    ; AT
        defb    $39, $26, $27+$80
                                ; TAB
        defb    $0F+$80         ; '?'+$80
        defb    $28, $34, $29, $2A+$80
                                ; CODE
        defb    $3B, $26, $31+$80
                                ; VAL
        defb    $31, $2A, $33+$80
                                ; LEN
        defb    $38, $2E, $33+$80
                                ; SIN
        defb    $28, $34, $38+$80
                                ; COS
        defb    $39, $26, $33+$80
                                ; TAN
        defb    $26, $38, $33+$80
                                ; ASN
        defb    $26, $28, $38+$80
                                ; ACS
        defb    $26, $39, $33+$80
                                ; ATN
        defb    $31, $33+$80    ; LN
        defb    $2A, $3D, $35+$80
                                ; EXP
        defb    $2E, $33, $39+$80
                                ; INT
        defb    $38, $36, $37+$80
                                ; SQR
        defb    $38, $2C, $33+$80
                                ; SGN
        defb    $26, $27, $38+$80
                                ; ABS
        defb    $35, $2A, $2A, $30+$80
                                ; PEEK
        defb    $3A, $38, $37+$80
                                ; USR
        defb    $38, $39, $37, $0D+$80
                                ; STR$
        defb    $28, $2D, $37, $0D+$80
                                ; CHR$
        defb    $33, $34, $39+$80
                                ; NOT
        defb    $17, $17+$80    ; **
        defb    $34, $37+$80    ; OR
        defb    $26, $33, $29+$80
                                ; AND
        defb    $13, $14+$80    ; <=
        defb    $12, $14+$80    ; >=
        defb    $13, $12+$80    ; <>
        defb    $39, $2D, $2A, $33+$80
                                ; THEN
        defb    $39, $34+$80    ; TO
        defb    $38, $39, $2A, $35+$80
                                ; STEP
        defb    $31, $35, $37, $2E, $33, $39+$80
                                ; LPRINT
        defb    $31, $31, $2E, $38, $39+$80
                                ; LLIST
        defb    $38, $39, $34, $35+$80
                                ; STOP
        defb    $38, $31, $34, $3C+$80
                                ; SLOW
        defb    $2B, $26, $38, $39+$80
                                ; FAST
        defb    $33, $2A, $3C+$80
                                ; NEW
        defb    $38, $28, $37, $34, $31, $31+$80
                                ; SCROLL
        defb    $28, $34, $33, $39+$80
                                ; CONT
        defb    $29, $2E, $32+$80
                                ; DIM
        defb    $37, $2A, $32+$80
                                ; REM
        defb    $2B, $34, $37+$80
                                ; FOR
        defb    $2C, $34, $39, $34+$80
                                ; GOTO
        defb    $2C, $34, $38, $3A, $27+$80
                                ; GOSUB
        defb    $2E, $33, $35, $3A, $39+$80
                                ; INPUT
        defb    $31, $34, $26, $29+$80
                                ; LOAD
        defb    $31, $2E, $38, $39+$80
                                ; LIST
        defb    $31, $2A, $39+$80
                                ; LET
        defb    $35, $26, $3A, $38, $2A+$80
                                ; PAUSE
        defb    $33, $2A, $3D, $39+$80
                                ; NEXT
        defb    $35, $34, $30, $2A+$80
                                ; POKE
        defb    $35, $37, $2E, $33, $39+$80
                                ; PRINT
        defb    $35, $31, $34, $39+$80
                                ; PLOT
        defb    $37, $3A, $33+$80
                                ; RUN
        defb    $38, $26, $3B, $2A+$80
                                ; SAVE
        defb    $37, $26, $33, $29+$80
                                ; RAND
        defb    $2E, $2B+$80    ; IF
        defb    $28, $31, $38+$80
                                ; CLS
        defb    $3A, $33, $35, $31, $34, $39+$80
                                ; UNPLOT
        defb    $28, $31, $2A, $26, $37+$80
                                ; CLEAR
        defb    $37, $2A, $39, $3A, $37, $33+$80
                                ; RETURN
        defb    $28, $34, $35, $3E+$80
                                ; COPY
        defb    $37, $33, $29+$80
                                ; RND
        defb    $2E, $33, $30, $2A, $3E, $0D+$80
                                ; INKEY$
        defb    $35, $2E+$80    ; PI


; ------------------------------
; THE 'LOAD-SAVE UPDATE' ROUTINE
; ------------------------------

LOAD_SAVE:
        inc     hl
        ex      de, hl
        ld      hl, (E_LINE)    ; system variable edit line E_LINE.
        scf                     ; set carry flag
        sbc     hl, de
        ex      de, hl
        ret     nc              ; return if more bytes to load/save.

        pop     hl              ; else drop return address

; ----------------------
; THE 'DISPLAY' ROUTINES
; ----------------------

SLOW_FAST:
        ld      hl, CDFLAG      ; Address the system variable CDFLAG.
        ld      a, (hl)         ; Load value to the accumulator.
        rla                     ; rotate bit 6 to position 7.
        xor     (hl)            ; exclusive or with original bit 7.
        rla                     ; rotate result out to carry.
        ret     nc              ; return if both bits were the same.

; Now test if this really is a ZX81 or a ZX80 running the upgraded ROM.
; The standard ZX80 did not have an NMI generator.

        ld      a, $7F          ; Load accumulator with %011111111
        ex      af, af'         ; save in AF'

        ld      b, $11          ; A counter within which an NMI should occur
                                ; if this is a ZX81.
        out     ($FE), a        ; start the NMI generator.

;  Note that if this is a ZX81 then the NMI will increment AF'.

LOOP_11:
        djnz    LOOP_11         ; self loop to give the NMI a chance to kick in.
                                ; = 16*13 clock cycles + 8 = 216 clock cycles.

        out     ($FD), a        ; Turn off the NMI generator.
        ex      af, af'         ; bring back the AF' value.
        rla                     ; test bit 7.
        jr      nc, NO_SLOW     ; forward, if bit 7 is still reset, to NO-SLOW.

;   If the AF' was incremented then the NMI generator works and SLOW mode can
;   be set.

        set     7, (hl)         ; Indicate SLOW mode - Compute and Display.

        push    af              ; *             Save Main Registers
        push    bc              ; **
        push    de              ; ***
        push    hl              ; ****

        jr      DISPLAY_1       ; skip forward - to DISPLAY-1.

; ---

NO_SLOW:
        res     6, (hl)         ; reset bit 6 of CDFLAG.
        ret                     ; return.

; -----------------------
; THE 'MAIN DISPLAY' LOOP
; -----------------------
; This routine is executed once for every frame displayed.

DISPLAY_1:
        ld      hl, (FRAMES)    ; fetch two-byte system variable FRAMES.
        dec     hl              ; decrement frames counter.

DISPLAY_P:
        ld      a, $7F          ; prepare a mask
        and     h               ; pick up bits 6-0 of H.
        or      l               ; and any bits of L.
        ld      a, h            ; reload A with all bits of H for PAUSE test.

;   Note both branches must take the same time.

        jr      nz, ANOTHER     ; (12/7) forward if bits 14-0 are not zero
                                ; to ANOTHER

        rla                     ; (4) test bit 15 of FRAMES.
        jr      OVER_NC         ; (12) forward with result to OVER-NC

; ---

ANOTHER:
        ld      b, (hl)         ; (7) Note. Harmless Nonsensical Timing weight.
        scf                     ; (4) Set Carry Flag.

; Note. the branch to here takes either (12)(7)(4) cyles or (7)(4)(12) cycles.

OVER_NC:
        ld      h, a            ; (4)  set H to zero
        ld      (FRAMES), hl    ; (16) update system variable FRAMES
        ret     nc              ; (11/5) return if FRAMES is in use by PAUSE
                                ; command.

DISPLAY_2:
        call    KEYBOARD        ; routine KEYBOARD gets the key row in H and
                                ; the column in L. Reading the ports also starts
                                ; the TV frame synchronization pulse. (VSYNC)

        ld      bc, (LAST_K)    ; fetch the last key values read from LAST_K
        ld      (LAST_K), hl    ; update LAST_K with new values.

        ld      a, b            ; load A with previous column - will be $FF if
                                ; there was no key.
        add     a, $02          ; adding two will set carry if no previous key.

        sbc     hl, bc          ; subtract with the carry the two key values.

; If the same key value has been returned twice then HL will be zero.

        ld      a, (DB_ST)      ; fetch system variable DEBOUNCE
        or      h               ; and OR with both bytes of the difference
        or      l               ; setting the zero flag for the upcoming branch.

        ld      e, b            ; transfer the column value to E
        ld      b, $0B          ; and load B with eleven

        ld      hl, CDFLAG      ; address system variable CDFLAG
        res     0, (hl)         ; reset the rightmost bit of CDFLAG
        jr      nz, NO_KEY      ; skip forward if debounce/diff >0 to NO-KEY

        bit     7, (hl)         ; test compute and display bit of CDFLAG
        set     0, (hl)         ; set the rightmost bit of CDFLAG.
        ret     z               ; return if bit 7 indicated fast mode.

        dec     b               ; (4) decrement the counter.
        nop                     ; (4) Timing - 4 clock cycles. ??
        scf                     ; (4) Set Carry Flag

NO_KEY:
        ld      hl, DB_ST       ; sv DEBOUNCE
        ccf                     ; Complement Carry Flag
        rl      b               ; rotate left B picking up carry
                                ;  C<-76543210<-C

LOOP_B:
        djnz    LOOP_B          ; self-loop while B>0 to LOOP-B

        ld      b, (hl)         ; fetch value of DEBOUNCE to B
        ld      a, e            ; transfer column value
        cp      $FE             ;
        sbc     a, a            ;
        ld      b, $1F          ;
        or      (hl)            ;
        and     b               ;
        rra                     ;
        ld      (hl), a         ;

        out     ($FF), a        ; end the TV frame synchronization pulse.

        ld      hl, (D_FILE)    ; (12) set HL to the Display File from D_FILE
        set     7, h            ; (8) set bit 15 to address the echo display.

        call    DISPLAY_3       ; (17) routine DISPLAY-3 displays the top set
                                ; of blank lines.

; ---------------------
; THE 'VIDEO-1' ROUTINE
; ---------------------

R_IX_1:
        ld      a, r            ; (9)  Harmless Nonsensical Timing or something
                                ;      very clever?
        ld      bc, $1901       ; (10) 25 lines, 1 scanline in first.
        ld      a, $F5          ; (7)  This value will be loaded into R and
                                ; ensures that the cycle starts at the right
                                ; part of the display  - after 32nd character
                                ; position.

        call    DISPLAY_5       ; (17) routine DISPLAY-5 completes the current
                                ; blank line and then generates the display of
                                ; the live picture using INT interrupts
                                ; The final interrupt returns to the next
                                ; address.

DISPLAY_5_RET:
        dec     hl              ; point HL to the last NEWLINE/HALT.

        call    DISPLAY_3       ; routine DISPLAY-3 displays the bottom set of
                                ; blank lines.

; ---

R_IX_2:
        jp      DISPLAY_1       ; jump back to DISPLAY-1

; ---------------------------------
; THE 'DISPLAY BLANK LINES' ROUTINE
; ---------------------------------
;   This subroutine is called twice (see above) to generate first the blank
;   lines at the top of the television display and then the blank lines at the
;   bottom of the display.

DISPLAY_3:
        pop     ix              ; pop the return address to IX register.
                                ; will be either R_IX_1 or R_IX_2 - see above.

        ld      c, (iy+MARGIN-IY0)
                                ; load C with value of system constant MARGIN.
        bit     7, (iy+CDFLAG-IY0)
                                ; test CDFLAG for compute and display.
        jr      z, DISPLAY_4    ; forward, with FAST mode, to DISPLAY-4

        ld      a, c            ; move MARGIN to A  - 31d or 55d.
        neg                     ; Negate
        inc     a               ;
        ex      af, af'         ; place negative count of blank lines in A'

        out     ($FE), a        ; enable the NMI generator.

        pop     hl              ; ****
        pop     de              ; ***
        pop     bc              ; **
        pop     af              ; *             Restore Main Registers

        ret                     ; return - end of interrupt.  Return is to
                                ; user's program - BASIC or machine code.
                                ; which will be interrupted by every NMI.

; ------------------------
; THE 'FAST MODE' ROUTINES
; ------------------------

DISPLAY_4:
        ld      a, $FC          ; (7)  load A with first R delay value
        ld      b, $01          ; (7)  one row only.

        call    DISPLAY_5       ; (17) routine DISPLAY-5

        dec     hl              ; (6)  point back to the HALT.
        ex      (sp), hl        ; (19) Harmless Nonsensical Timing if paired.
        ex      (sp), hl        ; (19) Harmless Nonsensical Timing.
        jp      (ix)            ; (8)  to R_IX_1 or R_IX_2

; --------------------------
; THE 'DISPLAY-5' SUBROUTINE
; --------------------------
;   This subroutine is called from SLOW mode and FAST mode to generate the
;   central TV picture. With SLOW mode the R register is incremented, with
;   each instruction, to $F7 by the time it completes.  With fast mode, the
;   final R value will be $FF and an interrupt will occur as soon as the
;   Program Counter reaches the HALT.  (24 clock cycles)

DISPLAY_5:
        ld      r, a            ; (9) Load R from A.    R = slow: $F5 fast: $FC
        ld      a, $DD          ; (7) load future R value.        $F6       $FD

        ei                      ; (4) Enable Interrupts           $F7       $FE

        jp      (hl)            ; (4) jump to the echo display.   $F8       $FF

; ----------------------------------
; THE 'KEYBOARD SCANNING' SUBROUTINE
; ----------------------------------
; The keyboard is read during the vertical sync interval while no video is
; being displayed.  Reading a port with address bit 0 low i.e. $FE starts the
; vertical sync pulse.

KEYBOARD:
        ld      hl, $FFFF       ; (16) prepare a buffer to take key.
        ld      bc, $FEFE       ; (20) set BC to port $FEFE. The B register,
                                ;      with its single reset bit also acts as
                                ;      an 8-counter.
        in      a, (c)          ; (11) read the port - all 16 bits are put on
                                ;      the address bus.  Start VSYNC pulse.
        or      $01             ; (7)  set the rightmost bit so as to ignore
                                ;      the SHIFT key.

EACH_LINE:
        or      $E0             ; [7] OR %11100000
        ld      d, a            ; [4] transfer to D.
        cpl                     ; [4] complement - only bits 4-0 meaningful now.
        cp      $01             ; [7] sets carry if A is zero.
        sbc     a, a            ; [4] $FF if $00 else zero.
        or      b               ; [7] $FF or port FE,FD,FB....
        and     l               ; [4] unless more than one key, L will still be
                                ;     $FF. if more than one key is pressed then A is
                                ;     now invalid.
        ld      l, a            ; [4] transfer to L.

; now consider the column identifier.

        ld      a, h            ; [4] will be $FF if no previous keys.
        and     d               ; [4] 111xxxxx
        ld      h, a            ; [4] transfer A to H

; since only one key may be pressed, H will, if valid, be one of
; 11111110, 11111101, 11111011, 11110111, 11101111
; reading from the outer column, say Q, to the inner column, say T.

        rlc     b               ; [8]  rotate the 8-counter/port address.
                                ;      sets carry if more to do.
        in      a, (c)          ; [10] read another half-row.
                                ;      all five bits this time.

        jr      c, EACH_LINE    ; [12](7) loop back, until done, to EACH-LINE

;   The last row read is SHIFT,Z,X,C,V  for the second time.

        rra                     ; (4) test the shift key - carry will be reset
                                ;     if the key is pressed.
        rl      h               ; (8) rotate left H picking up the carry giving
                                ;     column values -
                                ;        $FD, $FB, $F7, $EF, $DF.
                                ;     or $FC, $FA, $F6, $EE, $DE if shifted.

;   We now have H identifying the column and L identifying the row in the
;   keyboard matrix.

;   This is a good time to test if this is an American or British machine.
;   The US machine has an extra diode that causes bit 6 of a byte read from
;   a port to be reset.

        rla                     ; (4) compensate for the shift test.
        rla                     ; (4) rotate bit 7 out.
        rla                     ; (4) test bit 6.

        sbc     a, a            ; (4)           $FF or $00 {USA}
        and     $18             ; (7)           $18 or $00
        add     a, $1F          ; (7)           $37 or $1F

;   result is either 31 (USA) or 55 (UK) blank lines above and below the TV
;   picture.

        ld      (MARGIN), a     ; (13) update system variable MARGIN

        ret                     ; (10) return

; ------------------------------
; THE 'SET FAST MODE' SUBROUTINE
; ------------------------------

SET_FAST:
        bit     7, (iy+CDFLAG-IY0)
                                ; sv CDFLAG
        ret     z

        halt                    ; Wait for Interrupt
        out     ($FD), a
        res     7, (iy+CDFLAG-IY0)
                                ; sv CDFLAG
        ret                     ; return.

; --------------
; THE 'REPORT-F'
; --------------

REPORT_F:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_F_PROG_NAME ; Error Report: No Program Name supplied.

; --------------------------
; THE 'SAVE COMMAND' ROUTINE
; --------------------------

SAVE:
        call    NAME            ; routine NAME
        jr      c, REPORT_F     ; back with null name to REPORT-F above.

        ex      de, hl          ;
        ld      de, $12CB       ; five seconds timing value

HEADER:
        call    BREAK_1         ; routine BREAK-1
        jr      nc, BREAK_2     ; to BREAK-2


DELAY_1:
        djnz    DELAY_1         ; to DELAY-1

        dec     de              ;
        ld      a, d            ;
        or      e               ;
        jr      nz, HEADER      ; back for delay to HEADER

OUT_NAME:
        call    OUT_BYTE        ; routine OUT-BYTE
        bit     7, (hl)         ; test for inverted bit.
        inc     hl              ; address next character of name.
        jr      z, OUT_NAME     ; back if not inverted to OUT-NAME

; now start saving the system variables onwards.

        ld      hl, VERSN       ; set start of area to VERSN thereby
                                ; preserving RAMTOP etc.

OUT_PROG:
        call    OUT_BYTE        ; routine OUT-BYTE

        call    LOAD_SAVE       ; routine LOAD/SAVE                     >>
        jr      OUT_PROG        ; loop back to OUT-PROG

; -------------------------
; THE 'OUT-BYTE' SUBROUTINE
; -------------------------
; This subroutine outputs a byte a bit at a time to a domestic tape recorder.

OUT_BYTE:
        ld      e, (hl)         ; fetch byte to be saved.
        scf                     ; set carry flag - as a marker.

EACH_BIT:
        rl      e               ;  C < 76543210 < C
        ret     z               ; return when the marker bit has passed
                                ; right through.                        >>

        sbc     a, a            ; $FF if set bit or $00 with no carry.
        and     $05             ; $05               $00
        add     a, $04          ; $09               $04
        ld      c, a            ; transfer timer to C. a set bit has a longer
                                ; pulse than a reset bit.

PULSES:
        out     ($FF), a        ; pulse to cassette.
        ld      b, $23          ; set timing constant

DELAY_2:
        djnz    DELAY_2         ; self-loop to DELAY-2

        call    BREAK_1         ; routine BREAK-1 test for BREAK key.

BREAK_2:
        jr      nc, REPORT_D    ; forward with break to REPORT-D

        ld      b, $1E          ; set timing value.

DELAY_3:
        djnz    DELAY_3         ; self-loop to DELAY-3

        dec     c               ; decrement counter
        jr      nz, PULSES      ; loop back to PULSES

DELAY_4:
        and     a               ; clear carry for next bit test.
        djnz    DELAY_4         ; self loop to DELAY-4 (B is zero - 256)

        jr      EACH_BIT        ; loop back to EACH-BIT

; --------------------------
; THE 'LOAD COMMAND' ROUTINE
; --------------------------
;
;

LOAD:
        call    NAME            ; routine NAME

; DE points to start of name in RAM.

        rl      d               ; pick up carry
        rrc     d               ; carry now in bit 7.

NEXT_PROG:
        call    IN_BYTE         ; routine IN-BYTE
        jr      NEXT_PROG       ; loop to NEXT-PROG

; ------------------------
; THE 'IN-BYTE' SUBROUTINE
; ------------------------

IN_BYTE:
        ld      c, $01          ; prepare an eight counter 00000001.

NEXT_BIT:
        ld      b, $00          ; set counter to 256

BREAK_3:
        ld      a, $7F          ; read the keyboard row
        in      a, ($FE)        ; with the SPACE key.

        out     ($FF), a        ; output signal to screen.

        rra                     ; test for SPACE pressed.
        jr      nc, BREAK_4     ; forward if so to BREAK-4

        rla                     ; reverse above rotation
        rla                     ; test tape bit.
        jr      c, GET_BIT      ; forward if set to GET-BIT

        djnz    BREAK_3         ; loop back to BREAK-3

        pop     af              ; drop the return address.
        cp      d               ; ugh.

RESTART:
        jp      nc, INITIAL     ; jump forward to INITIAL if D is zero
                                ; to reset the system
                                ; if the tape signal has timed out for example
                                ; if the tape is stopped. Not just a simple
                                ; report as some system variables will have
                                ; been overwritten.

        ld      h, d            ; else transfer the start of name
        ld      l, e            ; to the HL register

IN_NAME:
        call    IN_BYTE         ; routine IN-BYTE is sort of recursion for name
                                ; part. received byte in C.
        bit     7, d            ; is name the null string ?
        ld      a, c            ; transfer byte to A.
        jr      nz, MATCHING    ; forward with null string to MATCHING

        cp      (hl)            ; else compare with string in memory.
        jr      nz, NEXT_PROG   ; back with mis-match to NEXT-PROG
                                ; (seemingly out of subroutine but return
                                ; address has been dropped).

MATCHING:
        inc     hl              ; address next character of name
        rla                     ; test for inverted bit.
        jr      nc, IN_NAME     ; back if not to IN-NAME

; the name has been matched in full.
; proceed to load the data but first increment the high byte of E_LINE, which
; is one of the system variables to be loaded in. Since the low byte is loaded
; before the high byte, it is possible that, at the in-between stage, a false
; value could cause the load to end prematurely - see  LOAD/SAVE check.

        inc     (iy+E_LINE+1-IY0)
                                ; increment system variable E_LINE_hi.
        ld      hl, VERSN       ; start loading at system variable VERSN.

IN_PROG:
        ld      d, b            ; set D to zero as indicator.
        call    IN_BYTE         ; routine IN-BYTE loads a byte
        ld      (hl), c         ; insert assembled byte in memory.
        call    LOAD_SAVE       ; routine LOAD/SAVE                     >>
        jr      IN_PROG         ; loop back to IN-PROG

; ---

; this branch assembles a full byte before exiting normally
; from the IN-BYTE subroutine.

GET_BIT:
        push    de              ; save the
        ld      e, $94          ; timing value.

TRAILER:
        ld      b, $1A          ; counter to twenty six.

COUNTER:
        dec     e               ; decrement the measuring timer.
        in      a, ($FE)        ; read the
        rla                     ;
        bit     7, e            ;
        ld      a, e            ;
        jr      c, TRAILER      ; loop back with carry to TRAILER

        djnz    COUNTER         ; to COUNTER

        pop     de              ;
        jr      nz, BIT_DONE    ; to BIT-DONE

        cp      $56             ;
        jr      nc, NEXT_BIT    ; to NEXT-BIT

BIT_DONE:
        ccf                     ; complement carry flag
        rl      c               ;
        jr      nc, NEXT_BIT    ; to NEXT-BIT

        ret                     ; return with full byte.

; ---

; if break is pressed while loading data then perform a reset.
; if break pressed while waiting for program on tape then OK to break.

BREAK_4:
        ld      a, d            ; transfer indicator to A.
        and     a               ; test for zero.
        jr      z, RESTART      ; back if so to RESTART


REPORT_D:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_D_BREAK     ; Error Report: BREAK - CONT repeats

; -----------------------------
; THE 'PROGRAM NAME' SUBROUTINE
; -----------------------------
;
;

NAME:
        call    SCANNING        ; routine SCANNING
        ld      a, (FLAGS)      ; sv FLAGS
        add     a, a            ;
        jp      m, REPORT_C     ; to REPORT-C

        pop     hl              ;
        ret     nc              ;

        push    hl              ;
        call    SET_FAST        ; routine SET-FAST
        call    STK_FETCH       ; routine STK-FETCH
        ld      h, d            ;
        ld      l, e            ;
        dec     c               ;
        ret     m               ;

        add     hl, bc          ;
        set     7, (hl)         ;
        ret                     ;

; -------------------------
; THE 'NEW' COMMAND ROUTINE
; -------------------------
;
;

NEW:
        call    SET_FAST        ; routine SET-FAST

        ld      bc, (RAMTOP)    ; fetch value of system variable RAMTOP
        dec     bc              ; point to last system byte.

; -----------------------
; THE 'RAM CHECK' ROUTINE
; -----------------------
;
;


RAM_CHECK:
        ld      h, b
        ld      l, c
        ld      a, $3F

RAM_FILL:
        ld      (hl), $02
        dec     hl
        cp      h
        jr      nz, RAM_FILL    ; to RAM-FILL

RAM_READ:
        and     a
        sbc     hl, bc
        add     hl, bc
        inc     hl
        jr      nc, SET_TOP     ; to SET-TOP

        dec     (hl)
        jr      z, SET_TOP      ; to SET-TOP

        dec     (hl)
        jr      z, RAM_READ     ; to RAM-READ

SET_TOP:
        ld      (RAMTOP), hl    ; set system variable RAMTOP to first byte
                                ; above the BASIC system area.



; ----------------------------
; THE 'INITIALIZATION' ROUTINE
; ----------------------------
;
;

INITIAL:
        ld      hl, (RAMTOP)    ; fetch system variable RAMTOP.
        dec     hl              ; point to last system byte.
        ld      (hl), $3E       ; make GO SUB end-marker $3E - too high for
                                ; high order byte of line number.
                                ; (was $3F on ZX80)
        dec     hl              ; point to unimportant low-order byte.
        ld      sp, hl          ; and initialize the stack-pointer to this
                                ; location.
        dec     hl              ; point to first location on the machine stack
        dec     hl              ; which will be filled by next CALL/PUSH.
        ld      (ERR_SP), hl    ; set the error stack pointer ERR_SP to
                                ; the base of the now empty machine stack.

; Now set the I register so that the video hardware knows where to find the
; character set. This ROM only uses the character set when printing to
; the ZX Printer. The TV picture is formed by the external video hardware.
; Consider also, that this 8K ROM can be retro-fitted to the ZX80 instead of
; its original 4K ROM so the video hardware could be on the ZX80.

        ld      a, char_set >> 8; address for this ROM is $1E00.
        ld      i, a            ; set I register from A.
        im      1               ; select Z80 Interrupt Mode 1.

        ld      iy, ERR_NR      ; set IY to the start of RAM so that the
                                ; system variables can be indexed.
        ld      (iy+CDFLAG-IY0), $40
                                ; set CDFLAG 0100 0000. Bit 6 indicates
                                ; Compute and Display required.

        ld      hl, PROG        ; The first location after System Variables -
                                ; 16509 decimal.


        ld      (D_FILE), hl    ; set system variable D_FILE to this value.
        ld      b, $19          ; prepare minimal screen of 24 NEWLINEs
                                ; following an initial NEWLINE.

LINE:
        ld      (hl), $76       ; insert NEWLINE (HALT instruction)
        inc     hl              ; point to next location.
        djnz    LINE            ; loop back for all twenty five to LINE

        ld      (VARS), hl      ; set system variable VARS to next location

        call    CLEAR           ; routine CLEAR sets $80 end-marker and the
                                ; dynamic memory pointers E_LINE, STKBOT and
                                ; STKEND.

NL_ONLY:
        call    CURSOR_IN       ; routine CURSOR-IN inserts the cursor and
                                ; end-marker in the Edit Line also setting
                                ; size of lower display to two lines.

        call    SLOW_FAST       ; routine SLOW/FAST selects COMPUTE and DISPLAY

; ---------------------------
; THE 'BASIC LISTING' SECTION
; ---------------------------
;
;

UPPER:
        call    CLS             ; routine CLS
        ld      hl, (E_PPC)     ; sv E_PPC_lo
        ld      de, (S_TOP)     ; sv S_TOP_lo
        and     a               ;
        sbc     hl, de          ;
        ex      de, hl          ;
        jr      nc, ADDR_TOP    ; to ADDR-TOP

        add     hl, de          ;
        ld      (S_TOP), hl     ; sv S_TOP_lo

ADDR_TOP:
        call    LINE_ADDR       ; routine LINE-ADDR
        jr      z, LIST_TOP     ; to LIST-TOP

        ex      de, hl          ;

LIST_TOP:
        call    LIST_PROG       ; routine LIST-PROG
        dec     (iy+BREG-IY0)   ; sv BREG
        jr      nz, LOWER       ; to LOWER

        ld      hl, (E_PPC)     ; sv E_PPC_lo
        call    LINE_ADDR       ; routine LINE-ADDR
        ld      hl, (CH_ADD)    ; sv CH_ADD_lo
        scf                     ; Set Carry Flag
        sbc     hl, de          ;
        ld      hl, S_TOP       ; sv S_TOP_lo
        jr      nc, INC_LINE    ; to INC-LINE

        ex      de, hl          ;
        ld      a, (hl)         ;
        inc     hl              ;
        ldi                     ;
        ld      (de), a         ;
        jr      UPPER           ; to UPPER

; ---

DOWN_KEY:
        ld      hl, E_PPC       ; sv E_PPC_lo

INC_LINE:
        ld      e, (hl)         ;
        inc     hl              ;
        ld      d, (hl)         ;
        push    hl              ;
        ex      de, hl          ;
        inc     hl              ;
        call    LINE_ADDR       ; routine LINE-ADDR
        call    LINE_NO         ; routine LINE-NO
        pop     hl              ;

KEY_INPUT:
        bit     5, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      nz, LOWER       ; forward to LOWER

        ld      (hl), d         ;
        dec     hl              ;
        ld      (hl), e         ;
        jr      UPPER           ; to UPPER

; ----------------------------
; THE 'EDIT LINE COPY' SECTION
; ----------------------------
; This routine sets the edit line to just the cursor when
; 1) There is not enough memory to edit a BASIC line.
; 2) The edit key is used during input.
; The entry point LOWER


EDIT_INP:
        call    CURSOR_IN       ; routine CURSOR-IN sets cursor only edit line.

; ->

LOWER:
        ld      hl, (E_LINE)    ; fetch edit line start from E_LINE.

EACH_CHAR:
        ld      a, (hl)         ; fetch a character from edit line.
        cp      $7E             ; compare to the number marker.
        jr      nz, END_LINE    ; forward if not to END-LINE

        ld      bc, $0006       ; else six invisible bytes to be removed.
        call    RECLAIM_2       ; routine RECLAIM-2
        jr      EACH_CHAR       ; back to EACH-CHAR

; ---

END_LINE:
        cp      $76             ;
        inc     hl              ;
        jr      nz, EACH_CHAR   ; to EACH-CHAR

EDIT_LINE:
        call    CURSOR          ; routine CURSOR sets cursor K or L.

EDIT_ROOM:
        call    LINE_ENDS       ; routine LINE-ENDS
        ld      hl, (E_LINE)    ; sv E_LINE_lo
        ld      (iy+ERR_NR-IY0), ERR_0_OK
                                ; sv ERR_NR
        call    COPY_LINE       ; routine COPY-LINE
        bit     7, (iy+ERR_NR-IY0)
                                ; sv ERR_NR
        jr      nz, DISPLAY_6   ; to DISPLAY-6

        ld      a, (DF_SZ)      ; sv DF_SZ
        cp      $18             ;
        jr      nc, DISPLAY_6   ; to DISPLAY-6

        inc     a               ;
        ld      (DF_SZ), a      ; sv DF_SZ
        ld      b, a            ;
        ld      c, $01          ;
        call    LOC_ADDR        ; routine LOC-ADDR
        ld      d, h            ;
        ld      e, l            ;
        ld      a, (hl)         ;

FREE_LINE:
        dec     hl              ;
        cp      (hl)            ;
        jr      nz, FREE_LINE   ; to FREE-LINE

        inc     hl              ;
        ex      de, hl          ;
        ld      a, (RAMTOP+1)   ; sv RAMTOP_hi
        cp      $4D             ;
        call    c, RECLAIM_1    ; routine RECLAIM-1
        jr      EDIT_ROOM       ; to EDIT-ROOM

; --------------------------
; THE 'WAIT FOR KEY' SECTION
; --------------------------
;
;

DISPLAY_6:
        ld      hl, $0000       ; These 2 zeros addressed from ZERO_DE
        ld      (X_PTR), hl     ; sv X_PTR_lo

        ld      hl, CDFLAG      ; system variable CDFLAG
        bit     7, (hl)         ;

        call    z, DISPLAY_1    ; routine DISPLAY-1

SLOW_DISP:
        bit     0, (hl)         ;
        jr      z, SLOW_DISP    ; to SLOW-DISP

        ld      bc, (LAST_K)    ; sv LAST_K
        call    DEBOUNCE        ; routine DEBOUNCE
        call    DECODE          ; routine DECODE

        jr      nc, LOWER       ; back to LOWER

; -------------------------------
; THE 'KEYBOARD DECODING' SECTION
; -------------------------------
;   The decoded key value is in E and HL points to the position in the
;   key table. D contains zero.

K_DECODE:
        ld      a, (MODE)       ; Fetch value of system variable MODE
        dec     a               ; test the three values together

        jp      m, FETCH_2      ; forward, if was zero, to FETCH-2

        jr      nz, FETCH_1     ; forward, if was 2, to FETCH-1

;   The original value was one and is now zero.

        ld      (MODE), a       ; update the system variable MODE

        dec     e               ; reduce E to range $00 - $7F
        ld      a, e            ; place in A
        sub     $27             ; subtract 39 setting carry if range 00 - 38
        jr      c, FUNC_BASE    ; forward, if so, to FUNC-BASE

        ld      e, a            ; else set E to reduced value

FUNC_BASE:
        ld      hl, K_FUNCT     ; address of K-FUNCT table for function keys.
        jr      TABLE_ADD       ; forward to TABLE-ADD

; ---

FETCH_1:
        ld      a, (hl)         ;
        cp      $76             ;
        jr      z, KL_KEY       ; to K/L-KEY

        cp      $40             ;
        set     7, a            ;
        jr      c, ENTER        ; to ENTER

        ld      hl, $00C7       ; (expr reqd)

TABLE_ADD:
        add     hl, de          ;
        jr      FETCH_3         ; to FETCH-3

; ---

FETCH_2:
        ld      a, (hl)         ;
        bit     2, (iy+FLAGS-IY0)
                                ; sv FLAGS  - K or L mode ?
        jr      nz, TEST_CURS   ; to TEST-CURS

        add     a, $C0          ;
        cp      $E6             ;
        jr      nc, TEST_CURS   ; to TEST-CURS

FETCH_3:
        ld      a, (hl)         ;

TEST_CURS:
        cp      $F0             ;
        jp      pe, KEY_SORT    ; to KEY-SORT

ENTER:
        ld      e, a            ;
        call    CURSOR          ; routine CURSOR

        ld      a, e            ;
        call    ADD_CHAR        ; routine ADD-CHAR

BACK_NEXT:
        jp      LOWER           ; back to LOWER

; ------------------------------
; THE 'ADD CHARACTER' SUBROUTINE
; ------------------------------
;
;

ADD_CHAR:
        call    ONE_SPACE       ; routine ONE-SPACE
        ld      (de), a         ;
        ret                     ;

; -------------------------
; THE 'CURSOR KEYS' ROUTINE
; -------------------------
;
;

KL_KEY:
        ld      a, $78          ;

KEY_SORT:
        ld      e, a            ;
        ld      hl, ED_KEYS - $E0
                                ; base address of ED-KEYS (exp reqd)
        add     hl, de          ;
        add     hl, de          ;
        ld      c, (hl)         ;
        inc     hl              ;
        ld      b, (hl)         ;
        push    bc              ;

CURSOR:
        ld      hl, (E_LINE)    ; sv E_LINE_lo
        bit     5, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      nz, L_MODE      ; to L-MODE

K_MODE:
        res     2, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal use K mode

TEST_CHAR:
        ld      a, (hl)         ;
        cp      $7F             ;
        ret     z               ; return

        inc     hl              ;
        call    NUMBER          ; routine NUMBER
        jr      z, TEST_CHAR    ; to TEST-CHAR

        cp      $26             ;
        jr      c, TEST_CHAR    ; to TEST-CHAR

        cp      $de             ;
        jr      z, K_MODE       ; to K-MODE

L_MODE:
        set     2, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal use L mode
        jr      TEST_CHAR       ; to TEST-CHAR

; --------------------------
; THE 'CLEAR-ONE' SUBROUTINE
; --------------------------
;
;

CLEAR_ONE:
        ld      bc, $0001       ;
        jp      RECLAIM_2       ; to RECLAIM-2



; ------------------------
; THE 'EDITING KEYS' TABLE
; ------------------------
;
;

ED_KEYS:
        defw    UP_KEY          ; Address: $059F; Address: UP-KEY
        defw    DOWN_KEY        ; Address: $0454; Address: DOWN-KEY
        defw    LEFT_KEY        ; Address: $0576; Address: LEFT-KEY
        defw    RIGHT_KEY       ; Address: $057F; Address: RIGHT-KEY
        defw    FUNCTION        ; Address: $05AF; Address: FUNCTION
        defw    EDIT_KEY        ; Address: $05C4; Address: EDIT-KEY
        defw    NL_KEY          ; Address: $060C; Address: N/L-KEY
        defw    RUBOUT          ; Address: $058B; Address: RUBOUT
        defw    FUNCTION        ; Address: $05AF; Address: FUNCTION
        defw    FUNCTION        ; Address: $05AF; Address: FUNCTION


; -------------------------
; THE 'CURSOR LEFT' ROUTINE
; -------------------------
;
;

LEFT_KEY:
        call    LEFT_EDGE       ; routine LEFT-EDGE
        ld      a, (hl)         ;
        ld      (hl), $7F       ;
        inc     hl              ;
        jr      GET_CODE        ; to GET-CODE

; --------------------------
; THE 'CURSOR RIGHT' ROUTINE
; --------------------------
;
;

RIGHT_KEY:
        inc     hl              ;
        ld      a, (hl)         ;
        cp      $76             ;
        jr      z, ENDED_2      ; to ENDED-2

        ld      (hl), $7F       ;
        dec     hl              ;

GET_CODE:
        ld      (hl), a         ;

ENDED_1:
        jr      BACK_NEXT       ; to BACK-NEXT

; --------------------
; THE 'RUBOUT' ROUTINE
; --------------------
;
;

RUBOUT:
        call    LEFT_EDGE       ; routine LEFT-EDGE
        call    CLEAR_ONE       ; routine CLEAR-ONE
        jr      ENDED_1         ; to ENDED-1

; ------------------------
; THE 'ED-EDGE' SUBROUTINE
; ------------------------
;
;

LEFT_EDGE:
        dec     hl              ;
        ld      de, (E_LINE)    ; sv E_LINE_lo
        ld      a, (de)         ;
        cp      $7F             ;
        ret     nz              ;

        pop     de              ;

ENDED_2:
        jr      ENDED_1         ; to ENDED-1

; -----------------------
; THE 'CURSOR UP' ROUTINE
; -----------------------
;
;

UP_KEY:
        ld      hl, (E_PPC)     ; sv E_PPC_lo
        call    LINE_ADDR       ; routine LINE-ADDR
        ex      de, hl          ;
        call    LINE_NO         ; routine LINE-NO
        ld      hl, E_PPC+1     ; point to system variable E_PPC_hi
        jp      KEY_INPUT       ; jump back to KEY-INPUT

; --------------------------
; THE 'FUNCTION KEY' ROUTINE
; --------------------------
;
;

FUNCTION:
        ld      a, e            ;
        and     $07             ;
        ld      (MODE), a       ; sv MODE
        jr      ENDED_2         ; back to ENDED-2

; ------------------------------------
; THE 'COLLECT LINE NUMBER' SUBROUTINE
; ------------------------------------
;
;

ZERO_DE:
        ex      de, hl          ;
        ld      de, DISPLAY_6 + 1
                                ; $04C2 - a location addressing two zeros.

; ->

LINE_NO:
        ld      a, (hl)         ;
        and     $C0             ;
        jr      nz, ZERO_DE     ; to ZERO-DE

        ld      d, (hl)         ;
        inc     hl              ;
        ld      e, (hl)         ;
        ret                     ;

; ----------------------
; THE 'EDIT KEY' ROUTINE
; ----------------------
;
;

EDIT_KEY:
        call    LINE_ENDS       ; routine LINE-ENDS clears lower display.

        ld      hl, EDIT_INP    ; Address: EDIT-INP
        push    hl              ; ** is pushed as an error looping address.

        bit     5, (iy+FLAGX-IY0)
                                ; test FLAGX
        ret     nz              ; indirect jump if in input mode
                                ; to L046F, EDIT-INP (begin again).

;

        ld      hl, (E_LINE)    ; fetch E_LINE
        ld      (DF_CC), hl     ; and use to update the screen cursor DF_CC

; so now RST $10 will print the line numbers to the edit line instead of screen.
; first make sure that no newline/out of screen can occur while sprinting the
; line numbers to the edit line.

        ld      hl, $1821       ; prepare line 0, column 0.
        ld      (S_POSN), hl    ; update S_POSN with these dummy values.

        ld      hl, (E_PPC)     ; fetch current line from E_PPC may be a
                                ; non-existent line e.g. last line deleted.
        call    LINE_ADDR       ; routine LINE-ADDR gets address or that of
                                ; the following line.
        call    LINE_NO         ; routine LINE-NO gets line number if any in DE
                                ; leaving HL pointing at second low byte.

        ld      a, d            ; test the line number for zero.
        or      e               ;
        ret     z               ; return if no line number - no program to edit.

        dec     hl              ; point to high byte.
        call    OUT_NO          ; routine OUT-NO writes number to edit line.

        inc     hl              ; point to length bytes.
        ld      c, (hl)         ; low byte to C.
        inc     hl              ;
        ld      b, (hl)         ; high byte to B.

        inc     hl              ; point to first character in line.
        ld      de, (DF_CC)     ; fetch display file cursor DF_CC

        ld      a, $7F          ; prepare the cursor character.
        ld      (de), a         ; and insert in edit line.
        inc     de              ; increment intended destination.

        push    hl              ; * save start of BASIC.

        ld      hl, $001D       ; set an overhead of 29 bytes.
        add     hl, de          ; add in the address of cursor.
        add     hl, bc          ; add the length of the line.
        sbc     hl, sp          ; subtract the stack pointer.

        pop     hl              ; * restore pointer to start of BASIC.

        ret     nc              ; return if not enough room to L046F EDIT-INP.
                                ; the edit key appears not to work.

        ldir                    ; else copy bytes from program to edit line.
                                ; Note. hidden floating point forms are also
                                ; copied to edit line.

        ex      de, hl          ; transfer free location pointer to HL

        pop     de              ; ** remove address EDIT-INP from stack.

        call    SET_STK_B       ; routine SET-STK-B sets STKEND from HL.

        jr      ENDED_2         ; back to ENDED-2 and after 3 more jumps
                                ; to L0472, LOWER.
                                ; Note. The LOWER routine removes the hidden
                                ; floating-point numbers from the edit line.

; -------------------------
; THE 'NEWLINE KEY' ROUTINE
; -------------------------
;
;

NL_KEY:
        call    LINE_ENDS       ; routine LINE-ENDS

        ld      hl, LOWER       ; prepare address: LOWER

        bit     5, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      nz, NOW_SCAN    ; to NOW-SCAN

        ld      hl, (E_LINE)    ; sv E_LINE_lo
        ld      a, (hl)         ;
        cp      $FF             ;
        jr      z, STK_UPPER    ; to STK-UPPER

        call    CLEAR_PRB       ; routine CLEAR-PRB
        call    CLS             ; routine CLS

STK_UPPER:
        ld      hl, UPPER       ; Address: UPPER

NOW_SCAN:
        push    hl              ; push routine address (LOWER or UPPER).
        call    LINE_SCAN       ; routine LINE-SCAN
        pop     hl              ;
        call    CURSOR          ; routine CURSOR
        call    CLEAR_ONE       ; routine CLEAR-ONE
        call    E_LINE_NO       ; routine E-LINE-NO
        jr      nz, NL_INP      ; to N/L-INP

        ld      a, b            ;
        or      c               ;
        jp      nz, NL_LINE     ; to N/L-LINE

        dec     bc              ;
        dec     bc              ;
        ld      (PPC), bc       ; sv PPC_lo
        ld      (iy+DF_SZ-IY0), $02
                                ; sv DF_SZ
        ld      de, (D_FILE)    ; sv D_FILE_lo

        jr      TEST_NULL       ; forward to TEST-NULL

; ---

NL_INP:
        cp      $76             ;
        jr      z, NL_NULL      ; to N/L-NULL

        ld      bc, (T_ADDR)    ; sv T_ADDR_lo
        call    LOC_ADDR        ; routine LOC-ADDR
        ld      de, (NXTLIN)    ; sv NXTLIN_lo
        ld      (iy+DF_SZ-IY0), $02
                                ; sv DF_SZ

TEST_NULL:
        rst     GET_CHAR        ; GET-CHAR
        cp      $76             ;

NL_NULL:
        jp      z, NL_ONLY      ; to N/L-ONLY

        ld      (iy+FLAGS-IY0), $80
                                ; sv FLAGS
        ex      de, hl          ;

NEXT_LINE:
        ld      (NXTLIN), hl    ; sv NXTLIN_lo
        ex      de, hl          ;
        call    TEMP_PTR2       ; routine TEMP-PTR-2
        call    LINE_RUN        ; routine LINE-RUN
        res     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal printer not in use
        ld      a, $C0          ;
        ld      (iy+X_PTR+1-IY0), a
                                ; sv X_PTR_hi
        call    X_TEMP          ; routine X-TEMP
        res     5, (iy+FLAGX-IY0)
                                ; sv FLAGX
        bit     7, (iy+ERR_NR-IY0)
                                ; sv ERR_NR
        jr      z, STOP_LINE    ; to STOP-LINE

        ld      hl, (NXTLIN)    ; sv NXTLIN_lo
        and     (hl)            ;
        jr      nz, STOP_LINE   ; to STOP-LINE

        ld      d, (hl)         ;
        inc     hl              ;
        ld      e, (hl)         ;
        ld      (PPC), de       ; sv PPC_lo
        inc     hl              ;
        ld      e, (hl)         ;
        inc     hl              ;
        ld      d, (hl)         ;
        inc     hl              ;
        ex      de, hl          ;
        add     hl, de          ;
        call    BREAK_1         ; routine BREAK-1
        jr      c, NEXT_LINE    ; to NEXT-LINE

        ld      hl, ERR_NR      ; sv ERR_NR
        bit     7, (hl)         ;
        jr      z, STOP_LINE    ; to STOP-LINE

        ld      (hl), ERR_D_BREAK

STOP_LINE:
        bit     7, (iy+PR_CC-IY0)
                                ; sv PR_CC
        call    z, COPY_BUFF    ; routine COPY-BUFF
        ld      bc, $0121       ;
        call    LOC_ADDR        ; routine LOC-ADDR
        ld      a, (ERR_NR)     ; sv ERR_NR
        ld      bc, (PPC)       ; sv PPC_lo
        inc     a               ;
        jr      z, REPORT       ; to REPORT

        cp      $09             ;
        jr      nz, CONTINUE    ; to CONTINUE

        inc     bc              ;

CONTINUE:
        ld      (OLDPPC), bc    ; sv OLDPPC_lo
        jr      nz, REPORT      ; to REPORT

        dec     bc              ;

REPORT:
        call    OUT_CODE        ; routine OUT-CODE
        ld      a, $18          ;

        rst     PRINT_A         ; PRINT-A
        call    OUT_NUM         ; routine OUT-NUM
        call    CURSOR_IN       ; routine CURSOR-IN
        jp      DISPLAY_6       ; to DISPLAY-6

; ---

NL_LINE:
        ld      (E_PPC), bc     ; sv E_PPC_lo
        ld      hl, (CH_ADD)    ; sv CH_ADD_lo
        ex      de, hl          ;
        ld      hl, NL_ONLY     ; Address: N/L-ONLY
        push    hl              ;
        ld      hl, (STKBOT)    ; sv STKBOT_lo
        sbc     hl, de          ;
        push    hl              ;
        push    bc              ;
        call    SET_FAST        ; routine SET-FAST
        call    CLS             ; routine CLS
        pop     hl              ;
        call    LINE_ADDR       ; routine LINE-ADDR
        jr      nz, COPY_OVER   ; to COPY-OVER

        call    NEXT_ONE        ; routine NEXT-ONE
        call    RECLAIM_2       ; routine RECLAIM-2

COPY_OVER:
        pop     bc              ;
        ld      a, c            ;
        dec     a               ;
        or      b               ;
        ret     z               ;

        push    bc              ;
        inc     bc              ;
        inc     bc              ;
        inc     bc              ;
        inc     bc              ;
        dec     hl              ;
        call    MAKE_ROOM       ; routine MAKE-ROOM
        call    SLOW_FAST       ; routine SLOW/FAST
        pop     bc              ;
        push    bc              ;
        inc     de              ;
        ld      hl, (STKBOT)    ; sv STKBOT_lo
        dec     hl              ;
        lddr                    ; copy bytes
        ld      hl, (E_PPC)     ; sv E_PPC_lo
        ex      de, hl          ;
        pop     bc              ;
        ld      (hl), b         ;
        dec     hl              ;
        ld      (hl), c         ;
        dec     hl              ;
        ld      (hl), e         ;
        dec     hl              ;
        ld      (hl), d         ;

        ret                     ; return.

; ---------------------------------------
; THE 'LIST' AND 'LLIST' COMMAND ROUTINES
; ---------------------------------------
;
;

LLIST:
        set     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - signal printer in use

LIST:
        call    FIND_INT        ; routine FIND-INT

        ld      a, b            ; fetch high byte of user-supplied line number.
        and     $3F             ; and crudely limit to range 1-16383.

        ld      h, a            ;
        ld      l, c            ;
        ld      (E_PPC), hl     ; sv E_PPC_lo
        call    LINE_ADDR       ; routine LINE-ADDR

LIST_PROG:
        ld      e, $00          ;

UNTIL_END:
        call    OUT_LINE        ; routine OUT-LINE lists one line of BASIC
                                ; making an early return when the screen is
                                ; full or the end of program is reached.    >>
        jr      UNTIL_END       ; loop back to UNTIL-END

; -----------------------------------
; THE 'PRINT A BASIC LINE' SUBROUTINE
; -----------------------------------
;
;

OUT_LINE:
        ld      bc, (E_PPC)     ; sv E_PPC_lo
        call    CP_LINES        ; routine CP-LINES
        ld      d, $92          ;
        jr      z, TEST_END     ; to TEST-END

        ld      de, $0000       ;
        rl      e               ;

TEST_END:
        ld      (iy+BREG-IY0), e
                                ; sv BREG
        ld      a, (hl)         ;
        cp      $40             ;
        pop     bc              ;
        ret     nc              ;

        push    bc              ;
        call    OUT_NO          ; routine OUT-NO
        inc     hl              ;
        ld      a, d            ;

        rst     PRINT_A         ; PRINT-A
        inc     hl              ;
        inc     hl              ;

COPY_LINE:
        ld      (CH_ADD), hl    ; sv CH_ADD_lo
        set     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Suppress leading space

MORE_LINE:
        ld      bc, (X_PTR)     ; sv X_PTR_lo
        ld      hl, (CH_ADD)    ; sv CH_ADD_lo
        and     a               ;
        sbc     hl, bc          ;
        jr      nz, TEST_NUM    ; to TEST-NUM

        ld      a, $B8          ;

        rst     PRINT_A         ; PRINT-A

TEST_NUM:
        ld      hl, (CH_ADD)    ; sv CH_ADD_lo
        ld      a, (hl)         ;
        inc     hl              ;
        call    NUMBER          ; routine NUMBER
        ld      (CH_ADD), hl    ; sv CH_ADD_lo
        jr      z, MORE_LINE    ; to MORE-LINE

        cp      $7F             ;
        jr      z, OUT_CURS     ; to OUT-CURS

        cp      $76             ;
        jr      z, OUT_CH       ; to OUT-CH

        bit     6, a            ;
        jr      z, NOT_TOKEN    ; to NOT-TOKEN

        call    TOKENS          ; routine TOKENS
        jr      MORE_LINE       ; to MORE-LINE

; ---


NOT_TOKEN:
        rst     PRINT_A         ; PRINT-A
        jr      MORE_LINE       ; to MORE-LINE

; ---

OUT_CURS:
        ld      a, (MODE)       ; Fetch value of system variable MODE
        ld      b, $AB          ; Prepare an inverse [F] for function cursor.

        and     a               ; Test for zero -
        jr      nz, FLAGS_2     ; forward if not to FLAGS-2

        ld      a, (FLAGS)      ; Fetch system variable FLAGS.
        ld      b, $B0          ; Prepare an inverse [K] for keyword cursor.

FLAGS_2:
        rra                     ; 00000?00 -> 000000?0
        rra                     ; 000000?0 -> 0000000?
        and     $01             ; 0000000?    0000000x

        add     a, b            ; Possibly [F] -> [G]  or  [K] -> [L]

        call    PRINT_SP        ; routine PRINT-SP prints character
        jr      MORE_LINE       ; back to MORE-LINE

; -----------------------
; THE 'NUMBER' SUBROUTINE
; -----------------------
;
;

NUMBER:
        cp      $7E             ;
        ret     nz              ;

        inc     hl              ;
        inc     hl              ;
        inc     hl              ;
        inc     hl              ;
        inc     hl              ;
        ret                     ;

; --------------------------------
; THE 'KEYBOARD DECODE' SUBROUTINE
; --------------------------------
;
;

DECODE:
        ld      d, $00          ;
        sra     b               ;
        sbc     a, a            ;
        or      $26             ;
        ld      l, $05          ;
        sub     l               ;

KEY_LINE:
        add     a, l            ;
        scf                     ; Set Carry Flag
        rr      c               ;
        jr      c, KEY_LINE     ; to KEY-LINE

        inc     c               ;
        ret     nz              ;

        ld      c, b            ;
        dec     l               ;
        ld      l, $01          ;
        jr      nz, KEY_LINE    ; to KEY-LINE

        ld      hl, $007D       ; (expr reqd)
        ld      e, a            ;
        add     hl, de          ;
        scf                     ; Set Carry Flag
        ret                     ;

; -------------------------
; THE 'PRINTING' SUBROUTINE
; -------------------------
;
;

LEAD_SP:
        ld      a, e            ;
        and     a               ;
        ret     m               ;

        jr      PRINT_CH        ; to PRINT-CH

; ---

OUT_DIGIT:
        xor     a               ;

DIGIT_INC:
        add     hl, bc          ;
        inc     a               ;
        jr      c, DIGIT_INC    ; to DIGIT-INC

        sbc     hl, bc          ;
        dec     a               ;
        jr      z, LEAD_SP      ; to LEAD-SP

OUT_CODE:
        ld      e, $1C          ;
        add     a, e            ;

OUT_CH:
        and     a               ;
        jr      z, PRINT_SP     ; to PRINT-SP

PRINT_CH:
        res     0, (iy+FLAGS-IY0)
                                ; update FLAGS - signal leading space permitted

PRINT_SP:
        exx                     ;
        push    hl              ;
        bit     1, (iy+FLAGS-IY0)
                                ; test FLAGS - is printer in use ?
        jr      nz, LPRINT_A    ; to LPRINT-A

        call    ENTER_CH        ; routine ENTER-CH
        jr      PRINT_EXX       ; to PRINT-EXX

; ---

LPRINT_A:
        call    LPRINT_CH       ; routine LPRINT-CH

PRINT_EXX:
        pop     hl              ;
        exx                     ;
        ret                     ;

; ---

ENTER_CH:
        ld      d, a            ;
        ld      bc, (S_POSN)    ; sv S_POSN_x
        ld      a, c            ;
        cp      $21             ;
        jr      z, TEST_LOW     ; to TEST-LOW

TEST_NL:
        ld      a, $76          ;
        cp      d               ;
        jr      z, WRITE_NL     ; to WRITE-N/L

        ld      hl, (DF_CC)     ; sv DF_CC_lo
        cp      (hl)            ;
        ld      a, d            ;
        jr      nz, WRITE_CH    ; to WRITE-CH

        dec     c               ;
        jr      nz, EXPAND_1    ; to EXPAND-1

        inc     hl              ;
        ld      (DF_CC), hl     ; sv DF_CC_lo
        ld      c, $21          ;
        dec     b               ;
        ld      (S_POSN), bc    ; sv S_POSN_x

TEST_LOW:
        ld      a, b            ;
        cp      (iy+DF_SZ-IY0)  ; sv DF_SZ
        jr      z, REPORT_5     ; to REPORT-5

        and     a               ;
        jr      nz, TEST_NL     ; to TEST-N/L

REPORT_5:
        ld      l, ERR_4_SCREEN_FULL
                                ; 'No more room on screen'
        jp      ERROR_3         ; to ERROR-3

; ---

EXPAND_1:
        call    ONE_SPACE       ; routine ONE-SPACE
        ex      de, hl          ;

WRITE_CH:
        ld      (hl), a         ;
        inc     hl              ;
        ld      (DF_CC), hl     ; sv DF_CC_lo
        dec     (iy+S_POSN-IY0) ; sv S_POSN_x
        ret                     ;

; ---

WRITE_NL:
        ld      c, $21          ;
        dec     b               ;
        set     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Suppress leading space
        jp      LOC_ADDR        ; to LOC-ADDR

; --------------------------
; THE 'LPRINT-CH' SUBROUTINE
; --------------------------
; This routine sends a character to the ZX-Printer placing the code for the
; character in the Printer Buffer.
; Note. PR-CC contains the low byte of the buffer address. The high order byte
; is always constant.


LPRINT_CH:
        cp      $76             ; compare to NEWLINE.
        jr      z, COPY_BUFF    ; forward if so to COPY-BUFF

        ld      c, a            ; take a copy of the character in C.
        ld      a, (PR_CC)      ; fetch print location from PR_CC
        and     $7F             ; ignore bit 7 to form true position.
        cp      $5C             ; compare to 33rd location

        ld      l, a            ; form low-order byte.
        ld      h, $40          ; the high-order byte is fixed.

        call    z, COPY_BUFF    ; routine COPY-BUFF to send full buffer to
                                ; the printer if first 32 bytes full.
                                ; (this will reset HL to start.)

        ld      (hl), c         ; place character at location.
        inc     l               ; increment - will not cross a 256 boundary.
        ld      (iy+PR_CC-IY0), l
                                ; update system variable PR_CC
                                ; automatically resetting bit 7 to show that
                                ; the buffer is not empty.
        ret                     ; return.

; --------------------------
; THE 'COPY' COMMAND ROUTINE
; --------------------------
; The full character-mapped screen is copied to the ZX-Printer.
; All twenty-four text/graphic lines are printed.

COPY:
        ld      d, $16          ; prepare to copy twenty four text lines.
        ld      hl, (D_FILE)    ; set HL to start of display file from D_FILE.
        inc     hl              ;
        jr      COPY_MULT_D     ; forward to COPY*D

; ---

; A single character-mapped printer buffer is copied to the ZX-Printer.

COPY_BUFF:
        ld      d, $01          ; prepare to copy a single text line.
        ld      hl, PRBUFF      ; set HL to start of printer buffer PRBUFF.

; both paths converge here.

COPY_MULT_D:
        call    SET_FAST        ; routine SET-FAST

        push    bc              ; *** preserve BC throughout.
                                ; a pending character may be present
                                ; in C from LPRINT-CH

COPY_LOOP:
        push    hl              ; save first character of line pointer. (*)
        xor     a               ; clear accumulator.
        ld      e, a            ; set pixel line count, range 0-7, to zero.

; this inner loop deals with each horizontal pixel line.

COPY_TIME:
        out     ($FB), a        ; bit 2 reset starts the printer motor
                                ; with an inactive stylus - bit 7 reset.
        pop     hl              ; pick up first character of line pointer (*)
                                ; on inner loop.

COPY_BRK:
        call    BREAK_1         ; routine BREAK-1
        jr      c, COPY_CONT    ; forward with no keypress to COPY-CONT

; else A will hold 11111111 0

        rra                     ; 0111 1111
        out     ($FB), a        ; stop ZX printer motor, de-activate stylus.

REPORT_D2:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_D_BREAK     ; Error Report: BREAK - CONT repeats

; ---

COPY_CONT:
        in      a, ($FB)        ; read from printer port.
        add     a, a            ; test bit 6 and 7
        jp      m, COPY_END     ; jump forward with no printer to COPY-END

        jr      nc, COPY_BRK    ; back if stylus not in position to COPY-BRK

        push    hl              ; save first character of line pointer (*)
        push    de              ; ** preserve character line and pixel line.

        ld      a, d            ; text line count to A?
        cp      $02             ; sets carry if last line.
        sbc     a, a            ; now $FF if last line else zero.

; now cleverly prepare a printer control mask setting bit 2 (later moved to 1)
; of D to slow printer for the last two pixel lines ( E = 6 and 7)

        and     e               ; and with pixel line offset 0-7
        rlca                    ; shift to left.
        and     e               ; and again.
        ld      d, a            ; store control mask in D.

COPY_NEXT:
        ld      c, (hl)         ; load character from screen or buffer.
        ld      a, c            ; save a copy in C for later inverse test.
        inc     hl              ; update pointer for next time.
        cp      $76             ; is character a NEWLINE ?
        jr      z, COPY_NL      ; forward, if so, to COPY-N/L

        push    hl              ; * else preserve the character pointer.

        sla     a               ; (?) multiply by two
        add     a, a            ; multiply by four
        add     a, a            ; multiply by eight

        ld      h, $0F          ; load H with half the address of character set.
        rl      h               ; now $1E or $1F (with carry)
        add     a, e            ; add byte offset 0-7
        ld      l, a            ; now HL addresses character source byte

        rl      c               ; test character, setting carry if inverse.
        sbc     a, a            ; accumulator now $00 if normal, $FF if inverse.

        xor     (hl)            ; combine with bit pattern at end or ROM.
        ld      c, a            ; transfer the byte to C.
        ld      b, $08          ; count eight bits to output.

COPY_BITS:
        ld      a, d            ; fetch speed control mask from D.
        rlc     c               ; rotate a bit from output byte to carry.
        rra                     ; pick up in bit 7, speed bit to bit 1
        ld      h, a            ; store aligned mask in H register.

COPY_WAIT:
        in      a, ($FB)        ; read the printer port
        rra                     ; test for alignment signal from encoder.
        jr      nc, COPY_WAIT   ; loop if not present to COPY-WAIT

        ld      a, h            ; control byte to A.
        out     ($FB), a        ; and output to printer port.
        djnz    COPY_BITS       ; loop for all eight bits to COPY-BITS

        pop     hl              ; * restore character pointer.
        jr      COPY_NEXT       ; back for adjacent character line to COPY-NEXT

; ---

; A NEWLINE has been encountered either following a text line or as the
; first character of the screen or printer line.

COPY_NL:
        in      a, ($FB)        ; read printer port.
        rra                     ; wait for encoder signal.
        jr      nc, COPY_NL     ; loop back if not to COPY-N/L

        ld      a, d            ; transfer speed mask to A.
        rrca                    ; rotate speed bit to bit 1.
                                ; bit 7, stylus control is reset.
        out     ($FB), a        ; set the printer speed.

        pop     de              ; ** restore character line and pixel line.
        inc     e               ; increment pixel line 0-7.
        bit     3, e            ; test if value eight reached.
        jr      z, COPY_TIME    ; back if not to COPY-TIME

; eight pixel lines, a text line have been completed.

        pop     bc              ; lose the now redundant first character
                                ; pointer
        dec     d               ; decrease text line count.
        jr      nz, COPY_LOOP   ; back if not zero to COPY-LOOP

        ld      a, $04          ; stop the already slowed printer motor.
        out     ($FB), a        ; output to printer port.

COPY_END:
        call    SLOW_FAST       ; routine SLOW/FAST
        pop     bc              ; *** restore preserved BC.

; -------------------------------------
; THE 'CLEAR PRINTER BUFFER' SUBROUTINE
; -------------------------------------
; This subroutine sets 32 bytes of the printer buffer to zero (space) and
; the 33rd character is set to a NEWLINE.
; This occurs after the printer buffer is sent to the printer but in addition
; after the 24 lines of the screen are sent to the printer.
; Note. This is a logic error as the last operation does not involve the
; buffer at all. Logically one should be able to use
; 10 LPRINT "HELLO ";
; 20 COPY
; 30 LPRINT ; "WORLD"
; and expect to see the entire greeting emerge from the printer.
; Surprisingly this logic error was never discovered and although one can argue
; if the above is a bug, the repetition of this error on the Spectrum was most
; definitely a bug.
; Since the printer buffer is fixed at the end of the system variables, and
; the print position is in the range $3C - $5C, then bit 7 of the system
; variable is set to show the buffer is empty and automatically reset when
; the variable is updated with any print position - neat.

CLEAR_PRB:
        ld      hl, PRBUFF+$20  ; address fixed end of PRBUFF
        ld      (hl), $76       ; place a newline at last position.
        ld      b, $20          ; prepare to blank 32 preceding characters.

PRB_BYTES:
        dec     hl              ; decrement address - could be DEC L.
        ld      (hl), $00       ; place a zero byte.
        djnz    PRB_BYTES       ; loop for all thirty-two to PRB-BYTES

        ld      a, l            ; fetch character print position.
        set     7, a            ; signal the printer buffer is clear.
        ld      (PR_CC), a      ; update one-byte system variable PR_CC
        ret                     ; return.

; -------------------------
; THE 'PRINT AT' SUBROUTINE
; -------------------------
;
;

PRINT_AT:
        ld      a, $17          ;
        sub     b               ;
        jr      c, WRONG_VAL    ; to WRONG-VAL

TEST_VAL:
        cp      (iy+DF_SZ-IY0)  ; sv DF_SZ
        jp      c, REPORT_5     ; to REPORT-5

        inc     a               ;
        ld      b, a            ;
        ld      a, $1F          ;
        sub     c               ;

WRONG_VAL:
        jp      c, REPORT_B     ; to REPORT-B

        add     a, $02          ;
        ld      c, a            ;

SET_FIELD:
        bit     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Is printer in use
        jr      z, LOC_ADDR     ; to LOC-ADDR

        ld      a, $5D          ;
        sub     c               ;
        ld      (PR_CC), a      ; sv PR_CC
        ret                     ;

; ----------------------------
; THE 'LOCATE ADDRESS' ROUTINE
; ----------------------------
;
;

LOC_ADDR:
        ld      (S_POSN), bc    ; sv S_POSN_x
        ld      hl, (VARS)      ; sv VARS_lo
        ld      d, c            ;
        ld      a, $22          ;
        sub     c               ;
        ld      c, a            ;
        ld      a, $76          ;
        inc     b               ;

LOOK_BACK:
        dec     hl              ;
        cp      (hl)            ;
        jr      nz, LOOK_BACK   ; to LOOK-BACK

        djnz    LOOK_BACK       ; to LOOK-BACK

        inc     hl              ;
        cpir                    ;
        dec     hl              ;
        ld      (DF_CC), hl     ; sv DF_CC_lo
        scf                     ; Set Carry Flag
        ret     po              ;

        dec     d               ;
        ret     z               ;

        push    bc              ;
        call    MAKE_ROOM       ; routine MAKE-ROOM
        pop     bc              ;
        ld      b, c            ;
        ld      h, d            ;
        ld      l, e            ;

EXPAND_2:
        ld      (hl), $00       ;
        dec     hl              ;
        djnz    EXPAND_2        ; to EXPAND-2

        ex      de, hl          ;
        inc     hl              ;
        ld      (DF_CC), hl     ; sv DF_CC_lo
        ret                     ;

; ------------------------------
; THE 'EXPAND TOKENS' SUBROUTINE
; ------------------------------
;
;

TOKENS:
        push    af              ;
        call    TOKEN_ADD       ; routine TOKEN-ADD
        jr      nc, ALL_CHARS   ; to ALL-CHARS

        bit     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Leading space if set
        jr      nz, ALL_CHARS   ; to ALL-CHARS

        xor     a               ;

        rst     PRINT_A         ; PRINT-A

ALL_CHARS:
        ld      a, (bc)         ;
        and     $3F             ;

        rst     PRINT_A         ; PRINT-A
        ld      a, (bc)         ;
        inc     bc              ;
        add     a, a            ;
        jr      nc, ALL_CHARS   ; to ALL-CHARS

        pop     bc              ;
        bit     7, b            ;
        ret     z               ;

        cp      $1A             ;
        jr      z, TRAIL_SP     ; to TRAIL-SP

        cp      $38             ;
        ret     c               ;

TRAIL_SP:
        xor     a               ;
        set     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Suppress leading space
        jp      PRINT_SP        ; to PRINT-SP

; ---

TOKEN_ADD:
        push    hl              ;
        ld      hl, TOKENS_TAB  ; Address of TOKENS_TAB
        bit     7, a            ;
        jr      z, TEST_HIGH    ; to TEST-HIGH

        and     $3F             ;

TEST_HIGH:
        cp      $43             ;
        jr      nc, FOUND       ; to FOUND

        ld      b, a            ;
        inc     b               ;

WORDS:
        bit     7, (hl)         ;
        inc     hl              ;
        jr      z, WORDS        ; to WORDS

        djnz    WORDS           ; to WORDS

        bit     6, a            ;
        jr      nz, COMP_FLAG   ; to COMP-FLAG

        cp      $18             ;

COMP_FLAG:
        ccf                     ; Complement Carry Flag

FOUND:
        ld      b, h            ;
        ld      c, l            ;
        pop     hl              ;
        ret     nc              ;

        ld      a, (bc)         ;
        add     a, $E4          ;
        ret                     ;

; --------------------------
; THE 'ONE SPACE' SUBROUTINE
; --------------------------
;
;

ONE_SPACE:
        ld      bc, $0001       ;

; --------------------------
; THE 'MAKE ROOM' SUBROUTINE
; --------------------------
;
;

MAKE_ROOM:
        push    hl              ;
        call    TEST_ROOM       ; routine TEST-ROOM
        pop     hl              ;
        call    POINTERS        ; routine POINTERS
        ld      hl, (STKEND)    ; sv STKEND_lo
        ex      de, hl          ;
        lddr                    ; Copy Bytes
        ret                     ;

; -------------------------
; THE 'POINTERS' SUBROUTINE
; -------------------------
;
;

POINTERS:
        push    af              ;
        push    hl              ;
        ld      hl, D_FILE      ; sv D_FILE_lo
        ld      a, $09          ;

NEXT_PTR:
        ld      e, (hl)         ;
        inc     hl              ;
        ld      d, (hl)         ;
        ex      (sp), hl        ;
        and     a               ;
        sbc     hl, de          ;
        add     hl, de          ;
        ex      (sp), hl        ;
        jr      nc, PTR_DONE    ; to PTR-DONE

        push    de              ;
        ex      de, hl          ;
        add     hl, bc          ;
        ex      de, hl          ;
        ld      (hl), d         ;
        dec     hl              ;
        ld      (hl), e         ;
        inc     hl              ;
        pop     de              ;

PTR_DONE:
        inc     hl              ;
        dec     a               ;
        jr      nz, NEXT_PTR    ; to NEXT-PTR

        ex      de, hl          ;
        pop     de              ;
        pop     af              ;
        and     a               ;
        sbc     hl, de          ;
        ld      b, h            ;
        ld      c, l            ;
        inc     bc              ;
        add     hl, de          ;
        ex      de, hl          ;
        ret                     ;

; -----------------------------
; THE 'LINE ADDRESS' SUBROUTINE
; -----------------------------
;
;

LINE_ADDR:
        push    hl              ;
        ld      hl, PROG
        ld      d, h            ;
        ld      e, l            ;

NEXT_TEST:
        pop     bc              ;
        call    CP_LINES        ; routine CP-LINES
        ret     nc              ;

        push    bc              ;
        call    NEXT_ONE        ; routine NEXT-ONE
        ex      de, hl          ;
        jr      NEXT_TEST       ; to NEXT-TEST

; -------------------------------------
; THE 'COMPARE LINE NUMBERS' SUBROUTINE
; -------------------------------------
;
;

CP_LINES:
        ld      a, (hl)         ;
        cp      b               ;
        ret     nz              ;

        inc     hl              ;
        ld      a, (hl)         ;
        dec     hl              ;
        cp      c               ;
        ret                     ;

; --------------------------------------
; THE 'NEXT LINE OR VARIABLE' SUBROUTINE
; --------------------------------------
;
;

NEXT_ONE:
        push    hl              ;
        ld      a, (hl)         ;
        cp      $40             ;
        jr      c, LINES        ; to LINES

        bit     5, a            ;
        jr      z, NEXT_O_4     ; forward to NEXT-O-4

        add     a, a            ;
        jp      m, NEXT_PLUS_FIVE
                                ; to NEXT+FIVE

        ccf                     ; Complement Carry Flag

NEXT_PLUS_FIVE:
        ld      bc, $0005
                                ;
        jr      nc, NEXT_LETT   ; to NEXT-LETT

        ld      c, $11          ;

NEXT_LETT:
        rla                     ;
        inc     hl              ;
        ld      a, (hl)         ;
        jr      nc, NEXT_LETT   ; to NEXT-LETT

        jr      NEXT_ADD        ; to NEXT-ADD

; ---

LINES:
        inc     hl              ;

NEXT_O_4:
        inc     hl              ;
        ld      c, (hl)         ;
        inc     hl              ;
        ld      b, (hl)         ;
        inc     hl              ;

NEXT_ADD:
        add     hl, bc          ;
        pop     de              ;

; ---------------------------
; THE 'DIFFERENCE' SUBROUTINE
; ---------------------------
;
;

DIFFER:
        and     a               ;
        sbc     hl, de          ;
        ld      b, h            ;
        ld      c, l            ;
        add     hl, de          ;
        ex      de, hl          ;
        ret                     ;

; --------------------------
; THE 'LINE-ENDS' SUBROUTINE
; --------------------------
;
;

LINE_ENDS:
        ld      b, (iy+DF_SZ-IY0)
                                ; sv DF_SZ
        push    bc              ;
        call    B_LINES         ; routine B-LINES
        pop     bc              ;
        dec     b               ;
        jr      B_LINES         ; to B-LINES

; -------------------------
; THE 'CLS' COMMAND ROUTINE
; -------------------------
;
;

CLS:
        ld      b, $18          ;

B_LINES:
        res     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal printer not in use
        ld      c, $21          ;
        push    bc              ;
        call    LOC_ADDR        ; routine LOC-ADDR
        pop     bc              ;
        ld      a, (RAMTOP+1)   ; sv RAMTOP_hi
        cp      $4D             ;
        jr      c, COLLAPSED    ; to COLLAPSED

        set     7, (iy+S_POSN+1-IY0)
                                ; sv S_POSN_y

CLEAR_LOC:
        xor     a               ; prepare a space
        call    PRINT_SP        ; routine PRINT-SP prints a space
        ld      hl, (S_POSN)    ; sv S_POSN_x
        ld      a, l            ;
        or      h               ;
        and     $7E             ;
        jr      nz, CLEAR_LOC   ; to CLEAR-LOC

        jp      LOC_ADDR        ; to LOC-ADDR

; ---

COLLAPSED:
        ld      d, h            ;
        ld      e, l            ;
        dec     hl              ;
        ld      c, b            ;
        ld      b, $00          ;
        ldir                    ; Copy Bytes
        ld      hl, (VARS)      ; sv VARS_lo

; ----------------------------
; THE 'RECLAIMING' SUBROUTINES
; ----------------------------
;
;

RECLAIM_1:
        call    DIFFER          ; routine DIFFER

RECLAIM_2:
        push    bc              ;
        ld      a, b            ;
        cpl                     ;
        ld      b, a            ;
        ld      a, c            ;
        cpl                     ;
        ld      c, a            ;
        inc     bc              ;
        call    POINTERS        ; routine POINTERS
        ex      de, hl          ;
        pop     hl              ;
        add     hl, de          ;
        push    de              ;
        ldir                    ; Copy Bytes
        pop     hl              ;
        ret                     ;

; ------------------------------
; THE 'E-LINE NUMBER' SUBROUTINE
; ------------------------------
;
;

E_LINE_NO:
        ld      hl, (E_LINE)    ; sv E_LINE_lo
        call    TEMP_PTR2       ; routine TEMP-PTR-2

        rst     GET_CHAR        ; GET-CHAR
        bit     5, (iy+FLAGX-IY0)
                                ; sv FLAGX
        ret     nz              ;

        ld      hl, MEMBOT      ; sv MEM-0-1st
        ld      (STKEND), hl    ; sv STKEND_lo
        call    INT_TO_FP       ; routine INT-TO-FP
        call    FP_TO_BC        ; routine FP-TO-BC
        jr      c, NO_NUMBER    ; to NO-NUMBER

        ld      hl, $D8F0       ; value '-10000'
        add     hl, bc          ;

NO_NUMBER:
        jp      c, REPORT_C     ; to REPORT-C

        cp      a               ;
        jp      SET_MIN         ; routine SET-MIN

; -------------------------------------------------
; THE 'REPORT AND LINE NUMBER' PRINTING SUBROUTINES
; -------------------------------------------------
;
;

OUT_NUM:
        push    de              ;
        push    hl              ;
        xor     a               ;
        bit     7, b            ;
        jr      nz, UNITS       ; to UNITS

        ld      h, b            ;
        ld      l, c            ;
        ld      e, $FF          ;
        jr      THOUSAND        ; to THOUSAND

; ---

OUT_NO:
        push    de              ;
        ld      d, (hl)         ;
        inc     hl              ;
        ld      e, (hl)         ;
        push    hl              ;
        ex      de, hl          ;
        ld      e, $00          ; set E to leading space.

THOUSAND:
        ld      bc, $FC18       ;
        call    OUT_DIGIT       ; routine OUT-DIGIT
        ld      bc, $FF9C       ;
        call    OUT_DIGIT       ; routine OUT-DIGIT
        ld      c, $F6          ;
        call    OUT_DIGIT       ; routine OUT-DIGIT
        ld      a, l            ;

UNITS:
        call    OUT_CODE        ; routine OUT-CODE
        pop     hl              ;
        pop     de              ;
        ret                     ;

; --------------------------
; THE 'UNSTACK-Z' SUBROUTINE
; --------------------------
; This subroutine is used to return early from a routine when checking syntax.
; On the ZX81 the same routines that execute commands also check the syntax
; on line entry. This enables precise placement of the error marker in a line
; that fails syntax.
; The sequence CALL SYNTAX-Z ; RET Z can be replaced by a call to this routine
; although it has not replaced every occurrence of the above two instructions.
; Even on the ZX-80 this routine was not fully utilized.

UNSTACK_Z:
        call    SYNTAX_Z        ; routine SYNTAX-Z resets the ZERO flag if
                                ; checking syntax.
        pop     hl              ; drop the return address.
        ret     z               ; return to previous calling routine if
                                ; checking syntax.

        jp      (hl)            ; else jump to the continuation address in
                                ; the calling routine as RET would have done.

; ----------------------------
; THE 'LPRINT' COMMAND ROUTINE
; ----------------------------
;
;

LPRINT:
        set     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal printer in use

; ---------------------------
; THE 'PRINT' COMMAND ROUTINE
; ---------------------------
;
;

PRINT:
        ld      a, (hl)         ;
        cp      $76             ;
        jp      z, PRINT_END    ; to PRINT-END

PRINT_1:
        sub     $1A             ;
        adc     a, $00          ;
        jr      z, SPACING      ; to SPACING

        cp      $A7             ;
        jr      nz, NOT_AT      ; to NOT-AT


        rst     NEXT_CHAR       ; NEXT-CHAR
        call    CLASS_6         ; routine CLASS-6
        cp      $1A             ;
        jp      nz, REPORT_C    ; to REPORT-C


        rst     NEXT_CHAR       ; NEXT-CHAR
        call    CLASS_6         ; routine CLASS-6
        call    SYNTAX_ON       ; routine SYNTAX-ON

        rst     FP_CALC         ;; FP-CALC
        defb    $01             ;;exchange
        defb    $34             ;;end-calc

        call    STK_TO_BC       ; routine STK-TO-BC
        call    PRINT_AT        ; routine PRINT-AT
        jr      PRINT_ON        ; to PRINT-ON

; ---

NOT_AT:
        cp      $A8             ;
        jr      nz, NOT_TAB     ; to NOT-TAB


        rst     NEXT_CHAR       ; NEXT-CHAR
        call    CLASS_6         ; routine CLASS-6
        call    SYNTAX_ON       ; routine SYNTAX-ON
        call    STK_TO_A        ; routine STK-TO-A
        jp      nz, REPORT_B    ; to REPORT-B

        and     $1F             ;
        ld      c, a            ;
        bit     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Is printer in use
        jr      z, TAB_TEST     ; to TAB-TEST

        sub     (iy+PR_CC-IY0)  ; sv PR_CC
        set     7, a            ;
        add     a, $3C          ;
        call    nc, COPY_BUFF   ; routine COPY-BUFF

TAB_TEST:
        add     a, (iy+S_POSN-IY0)
                                ; sv S_POSN_x
        cp      $21             ;
        ld      a, (S_POSN+1)   ; sv S_POSN_y
        sbc     a, $01          ;
        call    TEST_VAL        ; routine TEST-VAL
        set     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Suppress leading space
        jr      PRINT_ON        ; to PRINT-ON

; ---

NOT_TAB:
        call    SCANNING        ; routine SCANNING
        call    PRINT_STK       ; routine PRINT-STK

PRINT_ON:
        rst     GET_CHAR        ; GET-CHAR
        sub     $1A             ;
        adc     a, $00          ;
        jr      z, SPACING      ; to SPACING

        call    CHECK_END       ; routine CHECK-END
        jp      PRINT_END       ;;; to PRINT-END

; ---

SPACING:
        call    nc, FIELD       ; routine FIELD

        rst     NEXT_CHAR       ; NEXT-CHAR
        cp      $76             ;
        ret     z               ;

        jp      PRINT_1         ;;; to PRINT-1

; ---

SYNTAX_ON:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        ret     nz              ;

        pop     hl              ;
        jr      PRINT_ON        ; to PRINT-ON

; ---

PRINT_STK:
        call    UNSTACK_Z       ; routine UNSTACK-Z
        bit     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Numeric or string result?
        call    z, STK_FETCH    ; routine STK-FETCH
        jr      z, PR_STR_4     ; to PR-STR-4

        jp      PRINT_FP        ; jump forward to PRINT-FP

; ---

PR_STR_1:
        ld      a, $0B          ;

PR_STR_2:
        rst     PRINT_A         ; PRINT-A

PR_STR_3:
        ld      de, (X_PTR)     ; sv X_PTR_lo

PR_STR_4:
        ld      a, b            ;
        or      c               ;
        dec     bc              ;
        ret     z               ;

        ld      a, (de)         ;
        inc     de              ;
        ld      (X_PTR), de     ; sv X_PTR_lo
        bit     6, a            ;
        jr      z, PR_STR_2     ; to PR-STR-2

        cp      $C0             ;
        jr      z, PR_STR_1     ; to PR-STR-1

        push    bc              ;
        call    TOKENS          ; routine TOKENS
        pop     bc              ;
        jr      PR_STR_3        ; to PR-STR-3

; ---

PRINT_END:
        call    UNSTACK_Z       ; routine UNSTACK-Z
        ld      a, $76          ;

        rst     PRINT_A         ; PRINT-A
        ret                     ;

; ---

FIELD:
        call    UNSTACK_Z       ; routine UNSTACK-Z
        set     0, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Suppress leading space
        xor     a               ;

        rst     PRINT_A         ; PRINT-A
        ld      bc, (S_POSN)    ; sv S_POSN_x
        ld      a, c            ;
        bit     1, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Is printer in use
        jr      z, CENTRE       ; to CENTRE

        ld      a, $5D          ;
        sub     (iy+PR_CC-IY0)  ; sv PR_CC

CENTRE:
        ld      c, $11          ;
        cp      c               ;
        jr      nc, RIGHT       ; to RIGHT

        ld      c, $01          ;

RIGHT:
        call    SET_FIELD       ; routine SET-FIELD
        ret                     ;

; --------------------------------------
; THE 'PLOT AND UNPLOT' COMMAND ROUTINES
; --------------------------------------
;
; The graphic character codes used by PLOT are formed by assigning values as follows:
;
; +---+---+
; | 1 | 2 |
; +---+---+
; | 4 |   |
; +---+---+
;
; This yields codes $00 to $07:
;
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
; |   |   | |###|   | |   |###| |###|###| |   |   | |###|   | |   |###| |###|###|
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
; |   |   | |   |   | |   |   | |   |   | |###|   | |###|   | |###|   | |###|   |
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
;    $00       $01       $02       $03       $04       $05       $06       $07
;
; The inverse characters are therefore available via codes $80 to $87:
;
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
; |###|###| |   |###| |###|   | |   |   | |###|###| |   |###| |###|   | |   |   |
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
; |###|###| |###|###| |###|###| |###|###| |   |###| |   |###| |   |###| |   |###|
; +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+ +---+---+
;    $80       $81       $82       $83       $84       $85       $86       $87

PLOT_UNPLOT:
        call    STK_TO_BC       ; Call routine STK-TO-BC to fetch the x coordinate
                                ; to C and the y coordinate to B.
        ld      (COORDS), bc    ; Store the coordinates in system variable COORDS.

        ld      a, 43           ; Is the specified y coordinate out of range, i.e. greater than 43?
        sub     b               ;
        jp      c, REPORT_B     ; Jump if so to produce an error (REPORT-B).

; The y coordinate is within range and has been negated.

        ld      b, a            ; Store 43-y in B.

        ld      a, $01          ; Assume it is a point with even x and y coordinates.
        sra     b               ; Test whether an even or odd y coordinate by dividing B by 2.
        jr      nc, COLUMNS     ; Jump if an even coordinate to COLUMNS.

        ld      a, $04          ; It is an odd y coordinate, but still assume an even x coordinate.

COLUMNS:
        sra     c               ; Test whether an even or odd x coordinate by dividing C by 2.
        jr      nc, FIND_ADDR   ; Jump if an even coordinate to FIND-ADDR.

        rlca                    ; It is an odd x coordinate so multiple by 2, i.e. A holds
                                ; $02 (even y coordinate) or $08 (odd y coordinate).

; By here the A register holds either $01 (even y, even x), $02 (even y, odd x),
; $04 (odd y, even x) or $08 (odd y, odd x),
; and B holds the row position and C the column position.

FIND_ADDR:
        push    af              ; Save the generated plot code.
        call    PRINT_AT        ; Call routine PRINT-AT to find the location within the display file.
        ld      a, (hl)         ; Fetch the current character at the display file location.
        rlca                    ; Shift such that the 'invert' flags goes into bit 0. The low
                                ; 4 bits uniquely identifies all graphic plot characters.
        cp      $10             ; Did the location hold a graphic plot character (code $00 to $0F)?
        jr      nc, TABLE_PTR   ; Jump if not to TABLE-PTR.

        rrca                    ; Shift to restore the 'invert' flag, testing it in the process.
        jr      nc, SQ_SAVED    ; Jump if the 'invert' flag is reset (i.e. a non-inverted
                                ; character) to SQ-SAVED.

        xor     $8F             ; The existing character code is inverted so un-invert it.

SQ_SAVED:
        ld      b, a            ; Store the non-inverted character code of the existing
                                ; graphic character.

; Now determine whether plotting or unplotting.

TABLE_PTR:
        ld      de, P_UNPLOT    ; Address: P-UNPLOT
        ld      a, (T_ADDR)     ; sv T_ADDR_lo
        sub     e               ;
        jp      m, PLOT         ; Jump if plotting to PLOT.

        pop     af              ; Fetch the plot code.
        cpl                     ; Invert it and
        and     b               ; mask out the point in the existing character code.
        jr      UNPLOT          ; Jump ahead to UNPLOT.

; ---

PLOT:
        pop     af              ; Fetch the plot code and
        or      b               ; set the point in the existing character code.

; Plot and unplot join here. If the new generated graphic code is above $07 then it needs to
; be represented by an inverse character code.

UNPLOT:
        cp      $08             ; If the new graphic code below $08?
        jr      c, PLOT_END     ; Jump if so to PLOT-END.

        xor     $8F             ; Invert the graphic code to form the appropriate
                                ; inverse character code.

; The character code to display has been constructed.

PLOT_END:
        exx                     ; Preserve the main registers.

        rst     PRINT_A         ; Call PRINT-A to update the display file location with
                                ; the new character code.

        exx                     ; Restore the main registers.
        ret

; ----------------------------
; THE 'STACK-TO-BC' SUBROUTINE
; ----------------------------
;
;

STK_TO_BC:
        call    STK_TO_A        ; routine STK-TO-A
        ld      b, a            ;
        push    bc              ;
        call    STK_TO_A        ; routine STK-TO-A
        ld      e, c            ;
        pop     bc              ;
        ld      d, c            ;
        ld      c, a            ;
        ret                     ;

; ---------------------------
; THE 'STACK-TO-A' SUBROUTINE
; ---------------------------
;
;

STK_TO_A:
        call    FP_TO_A         ; routine FP-TO-A
        jp      c, REPORT_B     ; to REPORT-B

        ld      c, $01          ;
        ret     z               ;

        ld      c, $FF          ;
        ret                     ;

; -----------------------
; THE 'SCROLL' SUBROUTINE
; -----------------------
;
;

SCROLL:
        ld      b, (iy+DF_SZ-IY0)
                                ; sv DF_SZ
        ld      c, $21          ;
        call    LOC_ADDR        ; routine LOC-ADDR
        call    ONE_SPACE       ; routine ONE-SPACE
        ld      a, (hl)         ;
        ld      (de), a         ;
        inc     (iy+S_POSN+1-IY0)
                                ; sv S_POSN_y
        ld      hl, (D_FILE)    ; sv D_FILE_lo
        inc     hl              ;
        ld      d, h            ;
        ld      e, l            ;
        cpir                    ;
        jp      RECLAIM_1       ; to RECLAIM-1

; -------------------
; THE 'SYNTAX' TABLES
; -------------------

; i) The Offset table

offset_t:
        defb    P_LPRINT - ASMPC; 8B offset to; Address: P-LPRINT
        defb    P_LLIST - ASMPC ; 8D offset to; Address: P-LLIST
        defb    P_STOP - ASMPC  ; 2D offset to; Address: P-STOP
        defb    P_SLOW - ASMPC  ; 7F offset to; Address: P-SLOW
        defb    P_FAST - ASMPC  ; 81 offset to; Address: P-FAST
        defb    P_NEW - ASMPC   ; 49 offset to; Address: P-NEW
        defb    P_SCROLL - ASMPC; 75 offset to; Address: P-SCROLL
        defb    P_CONT - ASMPC  ; 5F offset to; Address: P-CONT
        defb    P_DIM - ASMPC   ; 40 offset to; Address: P-DIM
        defb    P_REM - ASMPC   ; 42 offset to; Address: P-REM
        defb    P_FOR - ASMPC   ; 2B offset to; Address: P-FOR
        defb    P_GOTO - ASMPC  ; 17 offset to; Address: P-GOTO
        defb    P_GOSUB - ASMPC ; 1F offset to; Address: P-GOSUB
        defb    P_INPUT - ASMPC ; 37 offset to; Address: P-INPUT
        defb    P_LOAD - ASMPC  ; 52 offset to; Address: P-LOAD
        defb    P_LIST - ASMPC  ; 45 offset to; Address: P-LIST
        defb    P_LET - ASMPC   ; 0F offset to; Address: P-LET
        defb    P_PAUSE - ASMPC ; 6D offset to; Address: P-PAUSE
        defb    P_NEXT - ASMPC  ; 2B offset to; Address: P-NEXT
        defb    P_POKE - ASMPC  ; 44 offset to; Address: P-POKE
        defb    P_PRINT - ASMPC ; 2D offset to; Address: P-PRINT
        defb    P_PLOT - ASMPC  ; 5A offset to; Address: P-PLOT
        defb    P_RUN - ASMPC   ; 3B offset to; Address: P-RUN
        defb    P_SAVE - ASMPC  ; 4C offset to; Address: P-SAVE
        defb    P_RAND - ASMPC  ; 45 offset to; Address: P-RAND
        defb    P_IF - ASMPC    ; 0D offset to; Address: P-IF
        defb    P_CLS - ASMPC   ; 52 offset to; Address: P-CLS
        defb    P_UNPLOT - ASMPC; 5A offset to; Address: P-UNPLOT
        defb    P_CLEAR - ASMPC ; 4D offset to; Address: P-CLEAR
        defb    P_RETURN - ASMPC; 15 offset to; Address: P-RETURN
        defb    P_COPY - ASMPC  ; 6A offset to; Address: P-COPY

; ii) The parameter table.


P_LET:
        defb    $01             ; Class-01 - A variable is required.
        defb    $14             ; Separator:  '='
        defb    $02             ; Class-02 - An expression, numeric or string,
                                ; must follow.

P_GOTO:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    GOTO            ; Address: $0E81; Address: GOTO

P_IF:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $de             ; Separator:  'THEN'
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    IF              ; Address: $0DAB; Address: IF

P_GOSUB:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    GOSUB           ; Address: $0EB5; Address: GOSUB

P_STOP:
        defb    $00             ; Class-00 - No further operands.
        defw    STOP            ; Address: $0CDC; Address: STOP

P_RETURN:
        defb    $00             ; Class-00 - No further operands.
        defw    RETURN          ; Address: $0ED8; Address: RETURN

P_FOR:
        defb    $04             ; Class-04 - A single character variable must
                                ; follow.
        defb    $14             ; Separator:  '='
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $DF             ; Separator:  'TO'
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    FOR             ; Address: $0DB9; Address: FOR

P_NEXT:
        defb    $04             ; Class-04 - A single character variable must
                                ; follow.
        defb    $00             ; Class-00 - No further operands.
        defw    NEXT            ; Address: $0E2E; Address: NEXT

P_PRINT:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    PRINT           ; Address: $0ACF; Address: PRINT

P_INPUT:
        defb    $01             ; Class-01 - A variable is required.
        defb    $00             ; Class-00 - No further operands.
        defw    INPUT           ; Address: $0EE9; Address: INPUT

P_DIM:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    DIM             ; Address: $1409; Address: DIM

P_REM:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    REM             ; Address: $0D6A; Address: REM

P_NEW:
        defb    $00             ; Class-00 - No further operands.
        defw    NEW             ; Address: $03C3; Address: NEW

P_RUN:
        defb    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        defw    RUN             ; Address: $0EAF; Address: RUN

P_LIST:
        defb    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        defw    LIST            ; Address: $0730; Address: LIST

P_POKE:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $1A             ; Separator:  ','
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    POKE            ; Address: $0E92; Address: POKE

P_RAND:
        defb    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        defw    RAND            ; Address: $0E6C; Address: RAND

P_LOAD:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    LOAD            ; Address: $0340; Address: LOAD

P_SAVE:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    SAVE            ; Address: $02F6; Address: SAVE

P_CONT:
        defb    $00             ; Class-00 - No further operands.
        defw    CONT            ; Address: $0E7C; Address: CONT

P_CLEAR:
        defb    $00             ; Class-00 - No further operands.
        defw    CLEAR           ; Address: $149A; Address: CLEAR

P_CLS:
        defb    $00             ; Class-00 - No further operands.
        defw    CLS             ; Address: $0A2A; Address: CLS

P_PLOT:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $1A             ; Separator:  ','
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    PLOT_UNPLOT     ; Address: $0BAF; Address: PLOT/UNP

P_UNPLOT:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $1A             ; Separator:  ','
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    PLOT_UNPLOT     ; Address: $0BAF; Address: PLOT/UNP

P_SCROLL:
        defb    $00             ; Class-00 - No further operands.
        defw    SCROLL          ; Address: $0C0E; Address: SCROLL

P_PAUSE:
        defb    $06             ; Class-06 - A numeric expression must follow.
        defb    $00             ; Class-00 - No further operands.
        defw    PAUSE           ; Address: $0F32; Address: PAUSE

P_SLOW:
        defb    $00             ; Class-00 - No further operands.
        defw    SLOW            ; Address: $0F2B; Address: SLOW

P_FAST:
        defb    $00             ; Class-00 - No further operands.
        defw    FAST            ; Address: $0F23; Address: FAST

P_COPY:
        defb    $00             ; Class-00 - No further operands.
        defw    COPY            ; Address: $0869; Address: COPY

P_LPRINT:
        defb    $05             ; Class-05 - Variable syntax checked entirely
                                ; by routine.
        defw    LPRINT          ; Address: $0ACB; Address: LPRINT

P_LLIST:
        defb    $03             ; Class-03 - A numeric expression may follow
                                ; else default to zero.
        defw    LLIST           ; Address: $072C; Address: LLIST


; ---------------------------
; THE 'LINE SCANNING' ROUTINE
; ---------------------------
;
;

LINE_SCAN:
        ld      (iy+FLAGS-IY0), $01
                                ; sv FLAGS
        call    E_LINE_NO       ; routine E-LINE-NO

LINE_RUN:
        call    SET_MIN         ; routine SET-MIN

        ld      hl, ERR_NR      ; sv ERR_NR
        ld      (hl), ERR_0_OK

        ld      hl, FLAGX       ; sv FLAGX
        bit     5, (hl)         ;
        jr      z, LINE_NULL    ; to LINE-NULL

        cp      $E3             ; 'STOP' ?
        ld      a, (hl)         ;
        jp      nz, INPUT_REP   ; to INPUT-REP

        call    SYNTAX_Z        ; routine SYNTAX-Z
        ret     z               ;


        rst     ERROR_1         ; ERROR-1
        defb    ERR_D_BREAK     ; Error Report: BREAK - CONT repeats


; --------------------------
; THE 'STOP' COMMAND ROUTINE
; --------------------------
;
;

STOP:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_9_STOP      ; Error Report: STOP statement

; ---

; the interpretation of a line continues with a check for just spaces
; followed by a carriage return.
; The IF command also branches here with a true value to execute the
; statement after the THEN but the statement can be null so
; 10 IF 1 = 1 THEN
; passes syntax (on all ZX computers).

LINE_NULL:
        rst     GET_CHAR        ; GET-CHAR
        ld      b, $00          ; prepare to index - early.
        cp      $76             ; compare to NEWLINE.
        ret     z               ; return if so.

        ld      c, a            ; transfer character to C.

        rst     NEXT_CHAR       ; NEXT-CHAR advances.
        ld      a, c            ; character to A
        sub     $E1             ; subtract 'LPRINT' - lowest command.
        jr      c, REPORT_C2    ; forward if less to REPORT-C2

        ld      c, a            ; reduced token to C
        ld      hl, offset_t    ; set HL to address of offset table.
        add     hl, bc          ; index into offset table.
        ld      c, (hl)         ; fetch offset
        add     hl, bc          ; index into parameter table.
        jr      GET_PARAM       ; to GET-PARAM

; ---

SCAN_LOOP:
        ld      hl, (T_ADDR)    ; sv T_ADDR_lo

; -> Entry Point to Scanning Loop

GET_PARAM:
        ld      a, (hl)         ;
        inc     hl              ;
        ld      (T_ADDR), hl    ; sv T_ADDR_lo

        ld      bc, SCAN_LOOP   ; Address: SCAN-LOOP
        push    bc              ; is pushed on machine stack.

        ld      c, a            ;
        cp      $0B             ;
        jr      nc, SEPARATOR   ; to SEPARATOR

        ld      hl, class_tbl   ; class-tbl - the address of the class table.
        ld      b, $00          ;
        add     hl, bc          ;
        ld      c, (hl)         ;
        add     hl, bc          ;
        push    hl              ;

        rst     GET_CHAR        ; GET-CHAR
        ret                     ; indirect jump to class routine and
                                ; by subsequent RET to SCAN-LOOP.

; -----------------------
; THE 'SEPARATOR' ROUTINE
; -----------------------

SEPARATOR:
        rst     GET_CHAR        ; GET-CHAR
        cp      c               ;
        jr      nz, REPORT_C2   ; to REPORT-C2
                                ; 'Nonsense in BASIC'

        rst     NEXT_CHAR       ; NEXT-CHAR
        ret                     ; return


; -------------------------
; THE 'COMMAND CLASS' TABLE
; -------------------------
;

class_tbl:
        defb    CLASS_0 - ASMPC ; 17 offset to; Address: CLASS-0
        defb    CLASS_1 - ASMPC ; 25 offset to; Address: CLASS-1
        defb    CLASS_2 - ASMPC ; 53 offset to; Address: CLASS-2
        defb    CLASS_3 - ASMPC ; 0F offset to; Address: CLASS-3
        defb    CLASS_4 - ASMPC ; 6B offset to; Address: CLASS-4
        defb    CLASS_5 - ASMPC ; 13 offset to; Address: CLASS-5
        defb    CLASS_6 - ASMPC ; 76 offset to; Address: CLASS-6


; --------------------------
; THE 'CHECK END' SUBROUTINE
; --------------------------
; Check for end of statement and that no spurious characters occur after
; a correctly parsed statement. Since only one statement is allowed on each
; line, the only character that may follow a statement is a NEWLINE.
;

CHECK_END:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        ret     nz              ; return in runtime.

        pop     bc              ; else drop return address.

CHECK_2:
        ld      a, (hl)         ; fetch character.
        cp      $76             ; compare to NEWLINE.
        ret     z               ; return if so.

REPORT_C2:
        jr      REPORT_C        ; to REPORT-C
                                ; 'Nonsense in BASIC'

; --------------------------
; COMMAND CLASSES 03, 00, 05
; --------------------------
;
;

CLASS_3:
        cp      $76             ;
        call    NO_TO_STK       ; routine NO-TO-STK

CLASS_0:
        cp      a               ;

CLASS_5:
        pop     bc              ;
        call    z, CHECK_END    ; routine CHECK-END
        ex      de, hl          ;
        ld      hl, (T_ADDR)    ; sv T_ADDR_lo
        ld      c, (hl)         ;
        inc     hl              ;
        ld      b, (hl)         ;
        ex      de, hl          ;

CLASS_END:
        push    bc              ;
        ret                     ;

; ------------------------------
; COMMAND CLASSES 01, 02, 04, 06
; ------------------------------
;
;

CLASS_1:
        call    LOOK_VARS       ; routine LOOK-VARS

CLASS_4_2:
        ld      (iy+FLAGX-IY0), $00
                                ; sv FLAGX
        jr      nc, SET_STK     ; to SET-STK

        set     1, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      nz, SET_STRLN   ; to SET-STRLN


REPORT_2:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_2_UNDEF_VAR ; Error Report: Variable not found

; ---

SET_STK:
        call    z, STK_VAR      ; routine STK-VAR
        bit     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Numeric or string result?
        jr      nz, SET_STRLN   ; to SET-STRLN

        xor     a               ;
        call    SYNTAX_Z        ; routine SYNTAX-Z
        call    nz, STK_FETCH   ; routine STK-FETCH
        ld      hl, FLAGX       ; sv FLAGX
        or      (hl)            ;
        ld      (hl), a         ;
        ex      de, hl          ;

SET_STRLN:
        ld      (STRLEN), bc    ; sv STRLEN_lo
        ld      (DEST), hl      ; sv DEST-lo

; THE 'REM' COMMAND ROUTINE

REM:
        ret                     ;

; ---

CLASS_2:
        pop     bc              ;
        ld      a, (FLAGS)      ; sv FLAGS

INPUT_REP:
        push    af              ;
        call    SCANNING        ; routine SCANNING
        pop     af              ;
        ld      bc, LET         ; Address: LET
        ld      d, (iy+FLAGS-IY0)
                                ; sv FLAGS
        xor     d               ;
        and     $40             ;
        jr      nz, REPORT_C    ; to REPORT-C

        bit     7, d            ;
        jr      nz, CLASS_END   ; to CLASS-END

        jr      CHECK_2         ; to CHECK-2

; ---

CLASS_4:
        call    LOOK_VARS       ; routine LOOK-VARS
        push    af              ;
        ld      a, c            ;
        or      $9F             ;
        inc     a               ;
        jr      nz, REPORT_C    ; to REPORT-C

        pop     af              ;
        jr      CLASS_4_2       ; to CLASS-4-2

; ---

CLASS_6:
        call    SCANNING        ; routine SCANNING
        bit     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Numeric or string result?
        ret     nz              ;


REPORT_C:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_C_NONSENSE  ; Error Report: Nonsense in BASIC

; --------------------------------
; THE 'NUMBER TO STACK' SUBROUTINE
; --------------------------------
;
;

NO_TO_STK:
        jr      nz, CLASS_6     ; back to CLASS-6 with a non-zero number.

        call    SYNTAX_Z        ; routine SYNTAX-Z
        ret     z               ; return if checking syntax.

; in runtime a zero default is placed on the calculator stack.

        rst     FP_CALC         ;; FP-CALC
        defb    $A0             ;;stk-zero
        defb    $34             ;;end-calc

        ret                     ; return.

; -------------------------
; THE 'SYNTAX-Z' SUBROUTINE
; -------------------------
; This routine returns with zero flag set if checking syntax.
; Calling this routine uses three instruction bytes compared to four if the
; bit test is implemented inline.

SYNTAX_Z:
        bit     7, (iy+FLAGS-IY0)
                                ; test FLAGS  - checking syntax only?
        ret                     ; return.

; ------------------------
; THE 'IF' COMMAND ROUTINE
; ------------------------
; In runtime, the class routines have evaluated the test expression and
; the result, true or false, is on the stack.

IF:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      z, IF_END       ; forward if checking syntax to IF-END

; else delete the Boolean value on the calculator stack.

        rst     FP_CALC         ;; FP-CALC
        defb    $02             ;;delete
        defb    $34             ;;end-calc

; register DE points to exponent of floating point value.

        ld      a, (de)         ; fetch exponent.
        and     a               ; test for zero - FALSE.
        ret     z               ; return if so.

IF_END:
        jp      LINE_NULL       ; jump back to LINE-NULL

; -------------------------
; THE 'FOR' COMMAND ROUTINE
; -------------------------
;
;

FOR:
        cp      $E0             ; is current character 'STEP' ?
        jr      nz, F_USE_ONE   ; forward if not to F-USE-ONE


        rst     NEXT_CHAR       ; NEXT-CHAR
        call    CLASS_6         ; routine CLASS-6 stacks the number
        call    CHECK_END       ; routine CHECK-END
        jr      F_REORDER       ; forward to F-REORDER

; ---

F_USE_ONE:
        call    CHECK_END       ; routine CHECK-END

        rst     FP_CALC         ;; FP-CALC
        defb    $A1             ;;stk-one
        defb    $34             ;;end-calc



F_REORDER:
        rst     FP_CALC         ;; FP-CALC      v, l, s.
        defb    $C0             ;;st-mem-0      v, l, s.
        defb    $02             ;;delete        v, l.
        defb    $01             ;;exchange      l, v.
        defb    $E0             ;;get-mem-0     l, v, s.
        defb    $01             ;;exchange      l, s, v.
        defb    $34             ;;end-calc      l, s, v.

        call    LET             ; routine LET

        ld      (MEM), hl       ; set MEM to address variable.
        dec     hl              ; point to letter.
        ld      a, (hl)         ;
        set     7, (hl)         ;
        ld      bc, $0006       ;
        add     hl, bc          ;
        rlca                    ;
        jr      c, F_LMT_STP    ; to F-LMT-STP

        sla     c               ;
        call    MAKE_ROOM       ; routine MAKE-ROOM
        inc     hl              ;

F_LMT_STP:
        push    hl              ;

        rst     FP_CALC         ;; FP-CALC
        defb    $02             ;;delete
        defb    $02             ;;delete
        defb    $34             ;;end-calc

        pop     hl              ;
        ex      de, hl          ;

        ld      c, $0A          ; ten bytes to be moved.
        ldir                    ; copy bytes

        ld      hl, (PPC)       ; set HL to system variable PPC current line.
        ex      de, hl          ; transfer to DE, variable pointer to HL.
        inc     de              ; loop start will be this line + 1 at least.
        ld      (hl), e         ;
        inc     hl              ;
        ld      (hl), d         ;
        call    NEXT_LOOP       ; routine NEXT-LOOP considers an initial pass.
        ret     nc              ; return if possible.

; else program continues from point following matching NEXT.

        bit     7, (iy+PPC+1-IY0)
                                ; test PPC_hi
        ret     nz              ; return if over 32767 ???

        ld      b, (iy+STRLEN-IY0)
                                ; fetch variable name from STRLEN_lo
        res     6, b            ; make a true letter.
        ld      hl, (NXTLIN)    ; set HL from NXTLIN

; now enter a loop to look for matching next.

NXTLIN_NO:
        ld      a, (hl)         ; fetch high byte of line number.
        and     $C0             ; mask off low bits $3F
        jr      nz, FOR_END     ; forward at end of program to FOR-END

        push    bc              ; save letter
        call    NEXT_ONE        ; routine NEXT-ONE finds next line.
        pop     bc              ; restore letter

        inc     hl              ; step past low byte
        inc     hl              ; past the
        inc     hl              ; line length.
        call    TEMP_PTR1       ; routine TEMP-PTR1 sets CH_ADD

        rst     GET_CHAR        ; GET-CHAR
        cp      $F3             ; compare to 'NEXT'.
        ex      de, hl          ; next line to HL.
        jr      nz, NXTLIN_NO   ; back with no match to NXTLIN-NO

;

        ex      de, hl          ; restore pointer.

        rst     NEXT_CHAR       ; NEXT-CHAR advances and gets letter in A.
        ex      de, hl          ; save pointer
        cp      b               ; compare to variable name.
        jr      nz, NXTLIN_NO   ; back with mismatch to NXTLIN-NO

FOR_END:
        ld      (NXTLIN), hl    ; update system variable NXTLIN
        ret                     ; return.

; --------------------------
; THE 'NEXT' COMMAND ROUTINE
; --------------------------
;
;

NEXT:
        bit     1, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jp      nz, REPORT_2    ; to REPORT-2

        ld      hl, (DEST)      ; DEST
        bit     7, (hl)         ;
        jr      z, REPORT_1     ; to REPORT-1

        inc     hl              ;
        ld      (MEM), hl       ; sv MEM_lo

        rst     FP_CALC         ;; FP-CALC
        defb    $E0             ;;get-mem-0
        defb    $E2             ;;get-mem-2
        defb    $0F             ;;addition
        defb    $C0             ;;st-mem-0
        defb    $02             ;;delete
        defb    $34             ;;end-calc

        call    NEXT_LOOP       ; routine NEXT-LOOP
        ret     c               ;

        ld      hl, (MEM)       ; sv MEM_lo
        ld      de, $000F       ;
        add     hl, de          ;
        ld      e, (hl)         ;
        inc     hl              ;
        ld      d, (hl)         ;
        ex      de, hl          ;
        jr      GOTO_2          ; to GOTO-2

; ---


REPORT_1:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_1_NEXT_WO_FOR
                                ; Error Report: NEXT without FOR


; --------------------------
; THE 'NEXT-LOOP' SUBROUTINE
; --------------------------
;
;

NEXT_LOOP:
        rst     FP_CALC         ;; FP-CALC
        defb    $E1             ;;get-mem-1
        defb    $E0             ;;get-mem-0
        defb    $E2             ;;get-mem-2
        defb    $32             ;;less-0
        defb    $00             ;;jump-true
        defb    $02             ;;to L0E62, LMT-V-VAL

        defb    $01             ;;exchange

LMT_V_VAL:
        defb    $03             ;;subtract
        defb    $33             ;;greater-0
        defb    $00             ;;jump-true
        defb    $04             ;;to L0E69, IMPOSS

        defb    $34             ;;end-calc

        and     a               ; clear carry flag
        ret                     ; return.

; ---


IMPOSS:
        defb    $34             ;;end-calc

        scf                     ; set carry flag
        ret                     ; return.

; --------------------------
; THE 'RAND' COMMAND ROUTINE
; --------------------------
; The keyword was 'RANDOMISE' on the ZX80, is 'RAND' here on the ZX81 and
; becomes 'RANDOMIZE' on the ZX Spectrum.
; In all invocations the procedure is the same - to set the SEED system variable
; with a supplied integer value or to use a time-based value if no number, or
; zero, is supplied.

RAND:
        call    FIND_INT        ; routine FIND-INT
        ld      a, b            ; test value
        or      c               ; for zero
        jr      nz, SET_SEED    ; forward if not zero to SET-SEED

        ld      bc, (FRAMES)    ; fetch value of FRAMES system variable.

SET_SEED:
        ld      (SEED), bc      ; update the SEED system variable.
        ret                     ; return.

; --------------------------
; THE 'CONT' COMMAND ROUTINE
; --------------------------
; Another abbreviated command. ROM space was really tight.
; CONTINUE at the line number that was set when break was pressed.
; Sometimes the current line, sometimes the next line.

CONT:
        ld      hl, (OLDPPC)    ; set HL from system variable OLDPPC
        jr      GOTO_2          ; forward to GOTO-2

; --------------------------
; THE 'GOTO' COMMAND ROUTINE
; --------------------------
; This token also suffered from the shortage of room and there is no space
; getween GO and TO as there is on the ZX80 and ZX Spectrum. The same also
; applies to the GOSUB keyword.

GOTO:
        call    FIND_INT        ; routine FIND-INT
        ld      h, b            ;
        ld      l, c            ;

GOTO_2:
        ld      a, h            ;
        cp      $F0             ;
        jr      nc, REPORT_B    ; to REPORT-B

        call    LINE_ADDR       ; routine LINE-ADDR
        ld      (NXTLIN), hl    ; sv NXTLIN_lo
        ret                     ;

; --------------------------
; THE 'POKE' COMMAND ROUTINE
; --------------------------
;
;

POKE:
        call    FP_TO_A         ; routine FP-TO-A
        jr      c, REPORT_B     ; forward, with overflow, to REPORT-B

        jr      z, POKE_SAVE    ; forward, if positive, to POKE-SAVE

        neg                     ; negate

POKE_SAVE:
        push    af              ; preserve value.
        call    FIND_INT        ; routine FIND-INT gets address in BC
                                ; invoking the error routine with overflow
                                ; or a negative number.
        pop     af              ; restore value.

; Note. the next two instructions are legacy code from the ZX80 and
; inappropriate here.

        bit     7, (iy+ERR_NR-IY0)
                                ; test ERR_NR - is it still $FF ?
        ret     z               ; return with error.

        ld      (bc), a         ; update the address contents.
        ret                     ; return.

; -----------------------------
; THE 'FIND INTEGER' SUBROUTINE
; -----------------------------
;
;

FIND_INT:
        call    FP_TO_BC        ; routine FP-TO-BC
        jr      c, REPORT_B     ; forward with overflow to REPORT-B

        ret     z               ; return if positive (0-65535).


REPORT_B:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_B_INT_OVERFLOW
                                ; Error Report: Integer out of range

; -------------------------
; THE 'RUN' COMMAND ROUTINE
; -------------------------
;
;

RUN:
        call    GOTO            ; routine GOTO
        jp      CLEAR           ; to CLEAR

; ---------------------------
; THE 'GOSUB' COMMAND ROUTINE
; ---------------------------
;
;

GOSUB:
        ld      hl, (PPC)       ; sv PPC_lo
        inc     hl              ;
        ex      (sp), hl        ;
        push    hl              ;
        ld      (ERR_SP), sp    ; set the error stack pointer - ERR_SP
        call    GOTO            ; routine GOTO
        ld      bc, $0006       ;

; --------------------------
; THE 'TEST ROOM' SUBROUTINE
; --------------------------
;
;

TEST_ROOM:
        ld      hl, (STKEND)    ; sv STKEND_lo
        add     hl, bc          ;
        jr      c, REPORT_4     ; to REPORT-4

        ex      de, hl          ;
        ld      hl, $0024       ;
        add     hl, de          ;
        sbc     hl, sp          ;
        ret     c               ;

REPORT_4:
        ld      l, ERR_4_NO_ROOM
        jp      ERROR_3         ; to ERROR-3

; ----------------------------
; THE 'RETURN' COMMAND ROUTINE
; ----------------------------
;
;

RETURN:
        pop     hl              ;
        ex      (sp), hl        ;
        ld      a, h            ;
        cp      $3E             ;
        jr      z, REPORT_7     ; to REPORT-7

        ld      (ERR_SP), sp    ; sv ERR_SP_lo
        jr      GOTO_2          ; back to GOTO-2

; ---

REPORT_7:
        ex      (sp), hl        ;
        push    hl              ;

        rst     ERROR_1         ; ERROR-1
        defb    ERR_7_RET_WO_GOSUB
                                ; Error Report: RETURN without GOSUB

; ---------------------------
; THE 'INPUT' COMMAND ROUTINE
; ---------------------------
;
;

INPUT:
        bit     7, (iy+PPC+1-IY0)
                                ; Test high byte of PPC for line number
        jr      nz, REPORT_8    ; REPORT-8 (Input must have line number)


; In edition 2 ROM, a new CALL instruction added to clear the workspace
; during the INPUT routine

        call    X_TEMP          ; Call X-TEMP to clears the workspace

        ld      hl, FLAGX       ; FLAGX
        set     5, (hl)         ; Set INPUT mode
        res     6, (hl)         ; to string
        ld      a, (FLAGS)      ; sv FLAGS
        and     $40             ;
        ld      bc, $0002       ;
        jr      nz, PROMPT      ; to PROMPT

        ld      c, $04          ;

PROMPT:
        or      (hl)            ;
        ld      (hl), a         ;

        rst     BC_SPACES       ; BC-SPACES
        ld      (hl), $76       ;
        ld      a, c            ;
        rrca                    ;
        rrca                    ;
        jr      c, ENTER_CUR    ; to ENTER-CUR

        ld      a, $0B          ;
        ld      (de), a         ;
        dec     hl              ;
        ld      (hl), a         ;

ENTER_CUR:
        dec     hl              ;
        ld      (hl), $7F       ;
        ld      hl, (S_POSN)    ; sv S_POSN_x
        ld      (T_ADDR), hl    ; sv T_ADDR_lo
        pop     hl              ;
        jp      LOWER           ; to LOWER

; ---

REPORT_8:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_8_EOF       ; Error Report: End of file

; ---------------------------
; THE 'PAUSE' COMMAND ROUTINE
; ---------------------------
;
;

FAST:
        call    SET_FAST        ; routine SET-FAST
        res     6, (iy+CDFLAG-IY0)
                                ; sv CDFLAG
        ret                     ; return.

; --------------------------
; THE 'SLOW' COMMAND ROUTINE
; --------------------------
;
;

SLOW:
        set     6, (iy+CDFLAG-IY0)
                                ; sv CDFLAG
        jp      SLOW_FAST       ; to SLOW/FAST

; ---------------------------
; THE 'PAUSE' COMMAND ROUTINE
; ---------------------------

PAUSE:
        call    FIND_INT        ; Call FIND-INT to get the PAUSE parameter
        call    SET_FAST        ; Call SET-FAST to go into fast mode
                                ; (but keep CDFLAG bit 6 set, indicating SLOW mode)
        ld      h, b            ; Move PAUSE parameter into HL
        ld      l, c            ; NB: This will be saved to FRAMES
        call    DISPLAY_P       ; Call DISPLAY-P to generate display until
                                ; FRAMES zero or a key is pressed


; In edition 2 ROM, rewritten PAUSE routine to ensure bit 15 of FRAMES set.

        ld      (iy+FRAMES+1-IY0), $FF
                                ; Set high byte of FRAMES to make sure a
                                ; new frame does not get FRAMES to zero

        call    SLOW_FAST       ; Call SLOW/FAST to re-enter "normal" slow mode
        jr      DEBOUNCE        ; routine DEBOUNCE

; ----------------------
; THE 'BREAK' SUBROUTINE
; ----------------------
;
;

BREAK_1:
        ld      a, $7F          ; read port $7FFE - keys B,N,M,.,SPACE.
        in      a, ($FE)        ;
        rra                     ; carry will be set if space not pressed.

; -------------------------
; THE 'DEBOUNCE' SUBROUTINE
; -------------------------
;
;

DEBOUNCE:
        res     0, (iy+CDFLAG-IY0)
                                ; update system variable CDFLAG
        ld      a, $FF          ;
        ld      (DB_ST), a      ; update system variable DEBOUNCE
        ret                     ; return.


; -------------------------
; THE 'SCANNING' SUBROUTINE
; -------------------------
; This recursive routine is where the ZX81 gets its power. Provided there is
; enough memory it can evaluate an expression of unlimited complexity.
; Note. there is no unary plus so, as on the ZX80, PRINT +1 gives a syntax error.
; PRINT +1 works on the Spectrum but so too does PRINT + "STRING".

SCANNING:
        rst     GET_CHAR        ; GET-CHAR
        ld      b, $00          ; set B register to zero.
        push    bc              ; stack zero as a priority end-marker.

S_LOOP_1:
        cp      $40             ; compare to the 'RND' character
        jr      nz, S_TEST_PI   ; forward, if not, to S-TEST-PI

; ------------------
; THE 'RND' FUNCTION
; ------------------

        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      z, S_JPI_END    ; forward if checking syntax to S-JPI-END

        ld      bc, (SEED)      ; sv SEED_lo
        call    STACK_BC        ; routine STACK-BC

        rst     FP_CALC         ;; FP-CALC
        defb    $A1             ;;stk-one
        defb    $0F             ;;addition
        defb    $30             ;;stk-data
        defb    $37             ;;Exponent: $87, Bytes: 1
        defb    $16             ;;(+00,+00,+00)
        defb    $04             ;;multiply
        defb    $30             ;;stk-data
        defb    $80             ;;Bytes: 3
        defb    $41             ;;Exponent $91
        defb    $00, $00, $80   ;;(+00)
        defb    $2E             ;;n-mod-m
        defb    $02             ;;delete
        defb    $A1             ;;stk-one
        defb    $03             ;;subtract
        defb    $2D             ;;duplicate
        defb    $34             ;;end-calc

        call    FP_TO_BC        ; routine FP-TO-BC
        ld      (SEED), bc      ; update the SEED system variable.
        ld      a, (hl)         ; HL addresses the exponent of the last value.
        and     a               ; test for zero
        jr      z, S_JPI_END    ; forward, if so, to S-JPI-END

        sub     $10             ; else reduce exponent by sixteen
        ld      (hl), a         ; thus dividing by 65536 for last value.

S_JPI_END:
        jr      S_PI_END        ; forward to S-PI-END

; ---

S_TEST_PI:
        cp      $42             ; the 'PI' character
        jr      nz, S_TST_INK   ; forward, if not, to S-TST-INK

; -------------------
; THE 'PI' EVALUATION
; -------------------

        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      z, S_PI_END     ; forward if checking syntax to S-PI-END


        rst     FP_CALC         ;; FP-CALC
        defb    $A3             ;;stk-pi/2
        defb    $34             ;;end-calc

        inc     (hl)            ; double the exponent giving PI on the stack.

S_PI_END:
        rst     NEXT_CHAR       ; NEXT-CHAR advances character pointer.

        jp      S_NUMERIC       ; jump forward to S-NUMERIC to set the flag
                                ; to signal numeric result before advancing.

; ---

S_TST_INK:
        cp      $41             ; compare to character 'INKEY$'
        jr      nz, S_ALPHANUM  ; forward, if not, to S-ALPHANUM

; -----------------------
; THE 'INKEY$' EVALUATION
; -----------------------

        call    KEYBOARD        ; routine KEYBOARD
        ld      b, h            ;
        ld      c, l            ;
        ld      d, c            ;
        inc     d               ;
        call    nz, DECODE      ; routine DECODE
        ld      a, d            ;
        adc     a, d            ;
        ld      b, d            ;
        ld      c, a            ;
        ex      de, hl          ;
        jr      S_STRING        ; forward to S-STRING

; ---

S_ALPHANUM:
        call    ALPHANUM        ; routine ALPHANUM
        jr      c, S_LTR_DGT    ; forward, if alphanumeric to S-LTR-DGT

        cp      $1B             ; is character a '.' ?
        jp      z, S_DECIMAL    ; jump forward if so to S-DECIMAL

        ld      bc, $09D8       ; prepare priority 09, operation 'subtract'
        cp      $16             ; is character unary minus '-' ?
        jr      z, S_PUSH_PO    ; forward, if so, to S-PUSH-PO

        cp      $10             ; is character a '(' ?
        jr      nz, S_QUOTE     ; forward if not to S-QUOTE

        call    INC_CH_ADD      ; routine CH-ADD+1 advances character pointer.

        call    SCANNING        ; recursively call routine SCANNING to
                                ; evaluate the sub-expression.

        cp      $11             ; is subsequent character a ')' ?
        jr      nz, S_RPT_C     ; forward if not to S-RPT-C


        call    INC_CH_ADD      ; routine CH-ADD+1  advances.
        jr      S_JP_CONT3      ; relative jump to S-JP-CONT3 and then S-CONT3

; ---

; consider a quoted string e.g. PRINT "Hooray!"
; Note. quotes are not allowed within a string.

S_QUOTE:
        cp      $0B             ; is character a quote (") ?
        jr      nz, S_FUNCTION  ; forward, if not, to S-FUNCTION

        call    INC_CH_ADD      ; routine CH-ADD+1 advances
        push    hl              ; * save start of string.
        jr      S_QUOTE_S       ; forward to S-QUOTE-S

; ---


S_Q_AGAIN:
        call    INC_CH_ADD      ; routine CH-ADD+1

S_QUOTE_S:
        cp      $0B             ; is character a '"' ?
        jr      nz, S_Q_NL      ; forward if not to S-Q-NL

        pop     de              ; * retrieve start of string
        and     a               ; prepare to subtract.
        sbc     hl, de          ; subtract start from current position.
        ld      b, h            ; transfer this length
        ld      c, l            ; to the BC register pair.

S_STRING:
        ld      hl, FLAGS       ; address system variable FLAGS
        res     6, (hl)         ; signal string result
        bit     7, (hl)         ; test if checking syntax.

        call    nz, STK_STO_DOLLAR
                                ; in run-time routine STK-STO-$ stacks the
                                ; string descriptor - start DE, length BC.

        rst     NEXT_CHAR       ; NEXT-CHAR advances pointer.

S_JP_CONT3:
        jp      S_CONT_3        ; jump to S-CONT-3

; ---

; A string with no terminating quote has to be considered.

S_Q_NL:
        cp      $76             ; compare to NEWLINE
        jr      nz, S_Q_AGAIN   ; loop back if not to S-Q-AGAIN

S_RPT_C:
        jp      REPORT_C        ; to REPORT-C

; ---

S_FUNCTION:
        sub     $C4             ; subtract 'CODE' reducing codes
                                ; CODE thru '<>' to range $00 - $XX
        jr      c, S_RPT_C      ; back, if less, to S-RPT-C

; test for NOT the last function in character set.

        ld      bc, $04EC       ; prepare priority $04, operation 'not'
        cp      $13             ; compare to 'NOT'  ( - CODE)
        jr      z, S_PUSH_PO    ; forward, if so, to S-PUSH-PO

        jr      nc, S_RPT_C     ; back with anything higher to S-RPT-C

; else is a function 'CODE' thru 'CHR$'

        ld      b, $10          ; priority sixteen binds all functions to
                                ; arguments removing the need for brackets.

        add     a, $D9          ; add $D9 to give range $D9 thru $EB
                                ; bit 6 is set to show numeric argument.
                                ; bit 7 is set to show numeric result.

; now adjust these default argument/result indicators.

        ld      c, a            ; save code in C

        cp      $DC             ; separate 'CODE', 'VAL', 'LEN'
        jr      nc, S_NO_TO__DOLLAR
                                ; skip forward if string operand to S-NO-TO-$

        res     6, c            ; signal string operand.

S_NO_TO__DOLLAR:
        cp      $EA             ; isolate top of range 'STR$' and 'CHR$'
        jr      c, S_PUSH_PO    ; skip forward with others to S-PUSH-PO

        res     7, c            ; signal string result.

S_PUSH_PO:
        push    bc              ; push the priority/operation

        rst     NEXT_CHAR       ; NEXT-CHAR
        jp      S_LOOP_1        ; jump back to S-LOOP-1

; ---

S_LTR_DGT:
        cp      'A' - 27        ; Jump if dealing with a digit (<'A').
        jr      c, S_DECIMAL    ; to the S-DECIMAL routine

        call    LOOK_VARS       ; We have a variable name. See if it exists
                                ; by calling LOOK-VARS
        jp      c, REPORT_2     ; back if not found to REPORT-2
                                ; (Undefined variable)
                                ; a variable is always 'found' when checking
                                ; syntax.

        call    z, STK_VAR      ; routine STK-VAR stacks string parameters or
                                ; returns cell location if numeric.


; In Edition 2 ROM, rewritten numeric processing routine to cater for
; syntax checking.

        ld      a, (FLAGS)      ; Fetch the value of FLAGS
        cp      $C0             ; Test bit 6 & 7 together
        jr      c, S_CONT_2     ; Jump to S-CONT-2 to continue processing if
                                ; not a number and/or are syntax checking

        inc     hl              ; A numeric value is to be stacked during
                                ; line execution
        ld      de, (STKEND)    ; set destination to STKEND
        call    duplicate       ; routine MOVE-FP/duplicate stacks the five bytes
        ex      de, hl          ; transfer new free location from DE to HL.
        ld      (STKEND), hl    ; update STKEND system variable.
        jr      S_CONT_2        ; forward to S-CONT-2

; ---

; The Scanning Decimal routine is invoked when a decimal point or digit is
; found in the expression.
; When checking syntax, then the 'hidden floating point' form is placed
; after the number in the BASIC line.
; In run-time, the digits are skipped and the floating point number is picked
; up.

S_DECIMAL:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      nz, S_STK_DEC   ; forward in run-time to S-STK-DEC

        call    DEC_TO_FP       ; routine DEC-TO-FP

        rst     GET_CHAR        ; GET-CHAR advances HL past digits
        ld      bc, $0006       ; six locations are required.
        call    MAKE_ROOM       ; routine MAKE-ROOM
        inc     hl              ; point to first new location
        ld      (hl), $7E       ; insert the number marker 126 decimal.
        inc     hl              ; increment
        ex      de, hl          ; transfer destination to DE.
        ld      hl, (STKEND)    ; set HL from STKEND which points to the
                                ; first location after the 'last value'
        ld      c, $05          ; five bytes to move.
        and     a               ; clear carry.
        sbc     hl, bc          ; subtract five pointing to 'last value'.
        ld      (STKEND), hl    ; update STKEND thereby 'deleting the value.

        ldir                    ; copy the five value bytes.

        ex      de, hl          ; basic pointer to HL which may be white-space
                                ; following the number.
        dec     hl              ; now points to last of five bytes.
        call    TEMP_PTR1       ; routine TEMP-PTR1 advances the character
                                ; address skipping any white-space.
        jr      S_NUMERIC       ; forward to S-NUMERIC
                                ; to signal a numeric result.

; ---

; In run-time the branch is here when a digit or point is encountered.

S_STK_DEC:
        rst     NEXT_CHAR       ; NEXT-CHAR
        cp      $7E             ; compare to 'number marker'
        jr      nz, S_STK_DEC   ; loop back until found to S-STK-DEC
                                ; skipping all the digits.

        inc     hl              ; point to first of five hidden bytes.
        ld      de, (STKEND)    ; set destination from STKEND system variable
        call    duplicate       ; routine MOVE-FP/duplicate stacks the number.
        ld      (STKEND), de    ; update system variable STKEND.
        ld      (CH_ADD), hl    ; update system variable CH_ADD.

S_NUMERIC:
        set     6, (iy+FLAGS-IY0)
                                ; update FLAGS  - Signal numeric result

S_CONT_2:
        rst     GET_CHAR        ; GET-CHAR

S_CONT_3:
        cp      $10             ; compare to opening bracket '('
        jr      nz, S_OPERTR    ; forward if not to S-OPERTR

        bit     6, (iy+FLAGS-IY0)
                                ; test FLAGS  - Numeric or string result?
        jr      nz, S_LOOP      ; forward if numeric to S-LOOP

; else is a string

        call    SLICING         ; routine SLICING

        rst     NEXT_CHAR       ; NEXT-CHAR
        jr      S_CONT_3        ; back to S-CONT-3

; ---

; the character is now manipulated to form an equivalent in the table of
; calculator literals. This is quite cumbersome and in the ZX Spectrum a
; simple look-up table was introduced at this point.

S_OPERTR:
        ld      bc, $00C3       ; prepare operator 'subtract' as default.
                                ; also set B to zero for later indexing.

        cp      $12             ; is character '>' ?
        jr      c, S_LOOP       ; forward if less to S-LOOP as
                                ; we have reached end of meaningful expression

        sub     $16             ; is character '-' ?
        jr      nc, SUBMLTDIV   ; forward with - * / and '**' '<>' to SUBMLTDIV

        add     a, $0D          ; increase others by thirteen
                                ; $09 '>' thru $0C '+'
        jr      GET_PRIO        ; forward to GET-PRIO

; ---

SUBMLTDIV:
        cp      $03             ; isolate $00 '-', $01 '*', $02 '/'
        jr      c, GET_PRIO     ; forward if so to GET-PRIO

; else possibly originally $D8 '**' thru $DD '<>' already reduced by $16

        sub     $C2             ; giving range $00 to $05
        jr      c, S_LOOP       ; forward if less to S-LOOP

        cp      $06             ; test the upper limit for nonsense also
        jr      nc, S_LOOP      ; forward if so to S-LOOP

        add     a, $03          ; increase by 3 to give combined operators of

                                ; $00 '-'
                                ; $01 '*'
                                ; $02 '/'

                                ; $03 '**'
                                ; $04 'OR'
                                ; $05 'AND'
                                ; $06 '<='
                                ; $07 '>='
                                ; $08 '<>'

                                ; $09 '>'
                                ; $0A '<'
                                ; $0B '='
                                ; $0C '+'

GET_PRIO:
        add     a, c            ; add to default operation 'sub' ($C3)
        ld      c, a            ; and place in operator byte - C.

        ld      hl, tbl_pri - $C3
                                ; theoretical base of the priorities table.
        add     hl, bc          ; add C ( B is zero)
        ld      b, (hl)         ; pick up the priority in B

S_LOOP:
        pop     de              ; restore previous
        ld      a, d            ; load A with priority.
        cp      b               ; is present priority higher
        jr      c, S_TIGHTER    ; forward if so to S-TIGHTER

        and     a               ; are both priorities zero
        jp      z, GET_CHAR     ; exit if zero via GET-CHAR

        push    bc              ; stack present values
        push    de              ; stack last values
        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      z, S_SYNTEST    ; forward is checking syntax to S-SYNTEST

        ld      a, e            ; fetch last operation
        and     $3F             ; mask off the indicator bits to give true
                                ; calculator literal.
        ld      b, a            ; place in the B register for BREG

; perform the single operation

        rst     FP_CALC         ;; FP-CALC
        defb    $37             ;;fp-calc-2
        defb    $34             ;;end-calc

        jr      S_RUNTEST       ; forward to S-RUNTEST

; ---

S_SYNTEST:
        ld      a, e            ; transfer masked operator to A
        xor     (iy+FLAGS-IY0)  ; XOR with FLAGS like results will reset bit 6
        and     $40             ; test bit 6

S_RPORT_C:
        jp      nz, REPORT_C    ; back to REPORT-C if results do not agree.

; ---

; in run-time impose bit 7 of the operator onto bit 6 of the FLAGS

S_RUNTEST:
        pop     de              ; restore last operation.
        ld      hl, FLAGS       ; address system variable FLAGS
        set     6, (hl)         ; presume a numeric result
        bit     7, e            ; test expected result in operation
        jr      nz, S_LOOPEND   ; forward if numeric to S-LOOPEND

        res     6, (hl)         ; reset to signal string result

S_LOOPEND:
        pop     bc              ; restore present values
        jr      S_LOOP          ; back to S-LOOP

; ---

S_TIGHTER:
        push    de              ; push last values and consider these

        ld      a, c            ; get the present operator.
        bit     6, (iy+FLAGS-IY0)
                                ; test FLAGS  - Numeric or string result?
        jr      nz, S_NEXT      ; forward if numeric to S-NEXT

        and     $3F             ; strip indicator bits to give clear literal.
        add     a, $08          ; add eight - augmenting numeric to equivalent
                                ; string literals.
        ld      c, a            ; place plain literal back in C.
        cp      $10             ; compare to 'AND'
        jr      nz, S_NOT_AND   ; forward if not to S-NOT-AND

        set     6, c            ; set the numeric operand required for 'AND'
        jr      S_NEXT          ; forward to S-NEXT

; ---

S_NOT_AND:
        jr      c, S_RPORT_C    ; back if less than 'AND' to S-RPORT-C
                                ; Nonsense if '-', '*' etc.

        cp      $17             ; compare to 'strs-add' literal
        jr      z, S_NEXT       ; forward if so signaling string result

        set     7, c            ; set bit to numeric (Boolean) for others.

S_NEXT:
        push    bc              ; stack 'present' values

        rst     NEXT_CHAR       ; NEXT-CHAR
        jp      S_LOOP_1        ; jump back to S-LOOP-1



; -------------------------
; THE 'TABLE OF PRIORITIES'
; -------------------------
;
;

tbl_pri:
        defb    $06             ;       '-'
        defb    $08             ;       '*'
        defb    $08             ;       '/'
        defb    $0A             ;       '**'
        defb    $02             ;       'OR'
        defb    $03             ;       'AND'
        defb    $05             ;       '<='
        defb    $05             ;       '>='
        defb    $05             ;       '<>'
        defb    $05             ;       '>'
        defb    $05             ;       '<'
        defb    $05             ;       '='
        defb    $06             ;       '+'


; --------------------------
; THE 'LOOK-VARS' SUBROUTINE
; --------------------------
;
;

LOOK_VARS:
        set     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal numeric result

        rst     GET_CHAR        ; GET-CHAR
        call    ALPHA           ; routine ALPHA
        jp      nc, REPORT_C    ; to REPORT-C

        push    hl              ;
        ld      c, a            ;

        rst     NEXT_CHAR       ; NEXT-CHAR
        push    hl              ;
        res     5, c            ;
        cp      $10             ;
        jr      z, V_RUN_OR_SYN ; to V-SYN/RUN

        set     6, c            ;
        cp      $0D             ;
        jr      z, V_STR_VAR    ; forward to V-STR-VAR

        set     5, c            ;

V_CHAR:
        call    ALPHANUM        ; routine ALPHANUM
        jr      nc, V_RUN_OR_SYN; forward when not to V-RUN/SYN

        res     6, c            ;

        rst     NEXT_CHAR       ; NEXT-CHAR
        jr      V_CHAR          ; loop back to V-CHAR

; ---

V_STR_VAR:
        rst     NEXT_CHAR       ; NEXT-CHAR
        res     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal string result

V_RUN_OR_SYN:
        ld      b, c            ;
        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      nz, V_RUN       ; forward to V-RUN

        ld      a, c            ;
        and     $E0             ;
        set     7, a            ;
        ld      c, a            ;
        jr      V_SYNTAX        ; forward to V-SYNTAX

; ---

V_RUN:
        ld      hl, (VARS)      ; sv VARS

V_EACH:
        ld      a, (hl)         ;
        and     $7F             ;
        jr      z, V_80_BYTE    ; to V-80-BYTE

        cp      c               ;
        jr      nz, V_NEXT      ; to V-NEXT

        rla                     ;
        add     a, a            ;
        jp      p, V_FOUND_2    ; to V-FOUND-2

        jr      c, V_FOUND_2    ; to V-FOUND-2

        pop     de              ;
        push    de              ;
        push    hl              ;

V_MATCHES:
        inc     hl              ;

V_SPACES:
        ld      a, (de)         ;
        inc     de              ;
        and     a               ;
        jr      z, V_SPACES     ; back to V-SPACES

        cp      (hl)            ;
        jr      z, V_MATCHES    ; back to V-MATCHES

        or      $80             ;
        cp      (hl)            ;
        jr      nz, V_GET_PTR   ; forward to V-GET-PTR

        ld      a, (de)         ;
        call    ALPHANUM        ; routine ALPHANUM
        jr      nc, V_FOUND_1   ; forward to V-FOUND-1

V_GET_PTR:
        pop     hl              ;

V_NEXT:
        push    bc              ;
        call    NEXT_ONE        ; routine NEXT-ONE
        ex      de, hl          ;
        pop     bc              ;
        jr      V_EACH          ; back to V-EACH

; ---

V_80_BYTE:
        set     7, b            ;

V_SYNTAX:
        pop     de              ;

        rst     GET_CHAR        ; GET-CHAR
        cp      $10             ;
        jr      z, V_PASS       ; forward to V-PASS

        set     5, b            ;
        jr      V_END           ; forward to V-END

; ---

V_FOUND_1:
        pop     de              ;

V_FOUND_2:
        pop     de              ;
        pop     de              ;
        push    hl              ;

        rst     GET_CHAR        ; GET-CHAR

V_PASS:
        call    ALPHANUM        ; routine ALPHANUM
        jr      nc, V_END       ; forward if not alphanumeric to V-END


        rst     NEXT_CHAR       ; NEXT-CHAR
        jr      V_PASS          ; back to V-PASS

; ---

V_END:
        pop     hl              ;
        rl      b               ;
        bit     6, b            ;
        ret                     ;

; ------------------------
; THE 'STK-VAR' SUBROUTINE
; ------------------------
;
;

STK_VAR:
        xor     a               ;
        ld      b, a            ;
        bit     7, c            ;
        jr      nz, SV_COUNT    ; forward to SV-COUNT

        bit     7, (hl)         ;
        jr      nz, SV_ARRAYS   ; forward to SV-ARRAYS

        inc     a               ;

SV_SIMPLE_DOLLAR:
        inc     hl              ;
        ld      c, (hl)         ;
        inc     hl              ;
        ld      b, (hl)         ;
        inc     hl              ;
        ex      de, hl          ;
        call    STK_STO_DOLLAR  ; routine STK-STO-$

        rst     GET_CHAR        ; GET-CHAR
        jp      SV_SLICE_QUESTION
                                ; jump forward to SV-SLICE?

; ---

SV_ARRAYS:
        inc     hl              ;
        inc     hl              ;
        inc     hl              ;
        ld      b, (hl)         ;
        bit     6, c            ;
        jr      z, SV_PTR       ; forward to SV-PTR

        dec     b               ;
        jr      z, SV_SIMPLE_DOLLAR
                                ; forward to SV-SIMPLE$

        ex      de, hl          ;

        rst     GET_CHAR        ; GET-CHAR
        cp      $10             ;
        jr      nz, REPORT_3    ; forward to REPORT-3

        ex      de, hl          ;

SV_PTR:
        ex      de, hl          ;
        jr      SV_COUNT        ; forward to SV-COUNT

; ---

SV_COMMA:
        push    hl              ;

        rst     GET_CHAR        ; GET-CHAR
        pop     hl              ;
        cp      $1A             ;
        jr      z, SV_LOOP      ; forward to SV-LOOP

        bit     7, c            ;
        jr      z, REPORT_3     ; forward to REPORT-3

        bit     6, c            ;
        jr      nz, SV_CLOSE    ; forward to SV-CLOSE

        cp      $11             ;
        jr      nz, SV_RPT_C    ; forward to SV-RPT-C


        rst     NEXT_CHAR       ; NEXT-CHAR
        ret                     ;

; ---

SV_CLOSE:
        cp      $11             ;
        jr      z, SV_DIM       ; forward to SV-DIM

        cp      $DF             ;
        jr      nz, SV_RPT_C    ; forward to SV-RPT-C


SV_CH_ADD:
        rst     GET_CHAR        ; GET-CHAR
        dec     hl              ;
        ld      (CH_ADD), hl    ; sv CH_ADD
        jr      SV_SLICE        ; forward to SV-SLICE

; ---

SV_COUNT:
        ld      hl, $0000       ;

SV_LOOP:
        push    hl              ;

        rst     NEXT_CHAR       ; NEXT-CHAR
        pop     hl              ;
        ld      a, c            ;
        cp      $C0             ;
        jr      nz, SV_MULT     ; forward to SV-MULT


        rst     GET_CHAR        ; GET-CHAR
        cp      $11             ;
        jr      z, SV_DIM       ; forward to SV-DIM

        cp      $DF             ;
        jr      z, SV_CH_ADD    ; back to SV-CH-ADD

SV_MULT:
        push    bc              ;
        push    hl              ;
        call    GET_DE_FROM_DE_PLUS_1
                                ; routine DE, (DE+1)
        ex      (sp), hl        ;
        ex      de, hl          ;
        call    INT_EXP1        ; routine INT-EXP1
        jr      c, REPORT_3     ; forward to REPORT-3

        dec     bc              ;
        call    GET_HL_MULT_DE  ; routine GET-HL*DE
        add     hl, bc          ;
        pop     de              ;
        pop     bc              ;
        djnz    SV_COMMA        ; loop back to SV-COMMA

        bit     7, c            ;

SV_RPT_C:
        jr      nz, SL_RPT_C    ; relative jump to SL-RPT-C

        push    hl              ;
        bit     6, c            ;
        jr      nz, SV_ELEM_DOLLAR
                                ; forward to SV-ELEM$

        ld      b, d            ;
        ld      c, e            ;

        rst     GET_CHAR        ; GET-CHAR
        cp      $11             ; is character a ')' ?
        jr      z, SV_NUMBER    ; skip forward to SV-NUMBER


REPORT_3:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_3_SUBSCRIPT_RANGE
                                ; Error Report: Subscript wrong


SV_NUMBER:
        rst     NEXT_CHAR       ; NEXT-CHAR
        pop     hl              ;
        ld      de, $0005       ;
        call    GET_HL_MULT_DE  ; routine GET-HL*DE
        add     hl, bc          ;
        ret                     ; return                            >>

; ---

SV_ELEM_DOLLAR:
        call    GET_DE_FROM_DE_PLUS_1
                                ; routine DE, (DE+1)
        ex      (sp), hl        ;
        call    GET_HL_MULT_DE  ; routine GET-HL*DE
        pop     bc              ;
        add     hl, bc          ;
        inc     hl              ;
        ld      b, d            ;
        ld      c, e            ;
        ex      de, hl          ;
        call    STK_ST_0        ; routine STK-ST-0

        rst     GET_CHAR        ; GET-CHAR
        cp      $11             ; is it ')' ?
        jr      z, SV_DIM       ; forward if so to SV-DIM

        cp      $1A             ; is it ',' ?
        jr      nz, REPORT_3    ; back if not to REPORT-3

SV_SLICE:
        call    SLICING         ; routine SLICING

SV_DIM:
        rst     NEXT_CHAR       ; NEXT-CHAR

SV_SLICE_QUESTION:
        cp      $10             ;
        jr      z, SV_SLICE     ; back to SV-SLICE

        res     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal string result
        ret                     ; return.

; ------------------------
; THE 'SLICING' SUBROUTINE
; ------------------------
;
;

SLICING:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        call    nz, STK_FETCH   ; routine STK-FETCH

        rst     NEXT_CHAR       ; NEXT-CHAR
        cp      $11             ; is it ')' ?
        jr      z, SL_STORE     ; forward if so to SL-STORE

        push    de              ;
        xor     a               ;
        push    af              ;
        push    bc              ;
        ld      de, $0001       ;

        rst     GET_CHAR        ; GET-CHAR
        pop     hl              ;
        cp      $DF             ; is it 'TO' ?
        jr      z, SL_SECOND    ; forward if so to SL-SECOND

        pop     af              ;
        call    INT_EXP2        ; routine INT-EXP2
        push    af              ;
        ld      d, b            ;
        ld      e, c            ;
        push    hl              ;

        rst     GET_CHAR        ; GET-CHAR
        pop     hl              ;
        cp      $DF             ; is it 'TO' ?
        jr      z, SL_SECOND    ; forward if so to SL-SECOND

        cp      $11             ;

SL_RPT_C:
        jp      nz, REPORT_C    ; to REPORT-C

        ld      h, d            ;
        ld      l, e            ;
        jr      SL_DEFINE       ; forward to SL-DEFINE

; ---

SL_SECOND:
        push    hl              ;

        rst     NEXT_CHAR       ; NEXT-CHAR
        pop     hl              ;
        cp      $11             ; is it ')' ?
        jr      z, SL_DEFINE    ; forward if so to SL-DEFINE

        pop     af              ;
        call    INT_EXP2        ; routine INT-EXP2
        push    af              ;

        rst     GET_CHAR        ; GET-CHAR
        ld      h, b            ;
        ld      l, c            ;
        cp      $11             ; is it ')' ?
        jr      nz, SL_RPT_C    ; back if not to SL-RPT-C

SL_DEFINE:
        pop     af              ;
        ex      (sp), hl        ;
        add     hl, de          ;
        dec     hl              ;
        ex      (sp), hl        ;
        and     a               ;
        sbc     hl, de          ;
        ld      bc, $0000       ;
        jr      c, SL_OVER      ; forward to SL-OVER

        inc     hl              ;
        and     a               ;
        jp      m, REPORT_3     ; jump back to REPORT-3

        ld      b, h            ;
        ld      c, l            ;

SL_OVER:
        pop     de              ;
        res     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Signal string result

SL_STORE:
        call    SYNTAX_Z        ; routine SYNTAX-Z
        ret     z               ; return if checking syntax.

; --------------------------
; THE 'STK-STORE' SUBROUTINE
; --------------------------
;
;

STK_ST_0:
        xor     a               ;

STK_STO_DOLLAR:
        push    bc              ;
        call    TEST_5_SP       ; routine TEST-5-SP
        pop     bc              ;
        ld      hl, (STKEND)    ; sv STKEND
        ld      (hl), a         ;
        inc     hl              ;
        ld      (hl), e         ;
        inc     hl              ;
        ld      (hl), d         ;
        inc     hl              ;
        ld      (hl), c         ;
        inc     hl              ;
        ld      (hl), b         ;
        inc     hl              ;
        ld      (STKEND), hl    ; sv STKEND
        res     6, (iy+FLAGS-IY0)
                                ; update FLAGS - signal string result
        ret                     ; return.

; -------------------------
; THE 'INT EXP' SUBROUTINES
; -------------------------
;
;

INT_EXP1:
        xor     a               ;

INT_EXP2:
        push    de              ;
        push    hl              ;
        push    af              ;
        call    CLASS_6         ; routine CLASS-6
        pop     af              ;
        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      z, I_RESTORE    ; forward if checking syntax to I-RESTORE

        push    af              ;
        call    FIND_INT        ; routine FIND-INT
        pop     de              ;
        ld      a, b            ;
        or      c               ;
        scf                     ; Set Carry Flag
        jr      z, I_CARRY      ; forward to I-CARRY

        pop     hl              ;
        push    hl              ;
        and     a               ;
        sbc     hl, bc          ;

I_CARRY:
        ld      a, d            ;
        sbc     a, $00          ;

I_RESTORE:
        pop     hl              ;
        pop     de              ;
        ret                     ;

; --------------------------
; THE 'DE, (DE+1)' SUBROUTINE
; --------------------------
; INDEX and LOAD Z80 subroutine.
; This emulates the 6800 processor instruction LDX 1,X which loads a two-byte
; value from memory into the register indexing it. Often these are hardly worth
; the bother of writing as subroutines and this one doesn't save any time or
; memory. The timing and space overheads have to be offset against the ease of
; writing and the greater program readability from using such toolkit routines.

GET_DE_FROM_DE_PLUS_1:
        ex      de, hl          ; move index address into HL.
        inc     hl              ; increment to address word.
        ld      e, (hl)         ; pick up word low-order byte.
        inc     hl              ; index high-order byte and
        ld      d, (hl)         ; pick it up.
        ret                     ; return with DE = word.

; --------------------------
; THE 'GET-HL*DE' SUBROUTINE
; --------------------------
;

GET_HL_MULT_DE:
        call    SYNTAX_Z
                                ; routine SYNTAX-Z
        ret     z               ;

        push    bc              ;
        ld      b, $10          ;
        ld      a, h            ;
        ld      c, l            ;
        ld      hl, $0000       ;

HL_LOOP:
        add     hl, hl          ;
        jr      c, HL_END       ; forward with carry to HL-END

        rl      c               ;
        rla                     ;
        jr      nc, HL_AGAIN    ; forward with no carry to HL-AGAIN

        add     hl, de          ;

HL_END:
        jp      c, REPORT_4     ; to REPORT-4

HL_AGAIN:
        djnz    HL_LOOP         ; loop back to HL-LOOP

        pop     bc              ;
        ret                     ; return.

; --------------------
; THE 'LET' SUBROUTINE
; --------------------
;
;

LET:
        ld      hl, (DEST)      ; sv DEST-lo
        bit     1, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      z, L_EXISTS     ; forward to L-EXISTS

        ld      bc, $0005       ;

L_EACH_CH:
        inc     bc              ;

; check

L_NO_SP:
        inc     hl              ;
        ld      a, (hl)         ;
        and     a               ;
        jr      z, L_NO_SP      ; back to L-NO-SP

        call    ALPHANUM        ; routine ALPHANUM
        jr      c, L_EACH_CH    ; back to L-EACH-CH

        cp      $0D             ; is it '$' ?
        jp      z, L_NEW_DOLLAR ; forward if so to L-NEW$


        rst     BC_SPACES       ; BC-SPACES
        push    de              ;
        ld      hl, (DEST)      ; sv DEST
        dec     de              ;
        ld      a, c            ;
        sub     $06             ;
        ld      b, a            ;
        ld      a, $40          ;
        jr      z, L_SINGLE     ; forward to L-SINGLE

L_CHAR:
        inc     hl              ;
        ld      a, (hl)         ;
        and     a               ; is it a space ?
        jr      z, L_CHAR       ; back to L-CHAR

        inc     de              ;
        ld      (de), a         ;
        djnz    L_CHAR          ; loop back to L-CHAR

        or      $80             ;
        ld      (de), a         ;
        ld      a, $80          ;

L_SINGLE:
        ld      hl, (DEST)      ; sv DEST-lo
        xor     (hl)            ;
        pop     hl              ;
        call    L_FIRST         ; routine L-FIRST

L_NUMERIC:
        push    hl              ;

        rst     FP_CALC         ;; FP-CALC
        defb    $02             ;;delete
        defb    $34             ;;end-calc

        pop     hl              ;
        ld      bc, $0005       ;
        and     a               ;
        sbc     hl, bc          ;
        jr      L_ENTER         ; forward to L-ENTER

; ---

L_EXISTS:
        bit     6, (iy+FLAGS-IY0)
                                ; sv FLAGS  - Numeric or string result?
        jr      z, L_DELETE_DOLLAR
                                ; forward to L-DELETE$

        ld      de, $0006       ;
        add     hl, de          ;
        jr      L_NUMERIC       ; back to L-NUMERIC

; ---

L_DELETE_DOLLAR:
        ld      hl, (DEST)
                                ; sv DEST-lo
        ld      bc, (STRLEN)    ; sv STRLEN_lo
        bit     0, (iy+FLAGX-IY0)
                                ; sv FLAGX
        jr      nz, L_ADD_DOLLAR; forward to L-ADD$

        ld      a, b            ;
        or      c               ;
        ret     z               ;

        push    hl              ;

        rst     BC_SPACES       ; BC-SPACES
        push    de              ;
        push    bc              ;
        ld      d, h            ;
        ld      e, l            ;
        inc     hl              ;
        ld      (hl), $00       ;
        lddr                    ; Copy Bytes
        push    hl              ;
        call    STK_FETCH       ; routine STK-FETCH
        pop     hl              ;
        ex      (sp), hl        ;
        and     a               ;
        sbc     hl, bc          ;
        add     hl, bc          ;
        jr      nc, L_LENGTH    ; forward to L-LENGTH

        ld      b, h            ;
        ld      c, l            ;

L_LENGTH:
        ex      (sp), hl        ;
        ex      de, hl          ;
        ld      a, b            ;
        or      c               ;
        jr      z, L_IN_WS      ; forward if zero to L-IN-W/S

        ldir                    ; Copy Bytes

L_IN_WS:
        pop     bc              ;
        pop     de              ;
        pop     hl              ;


; ------------------------
; THE 'L-ENTER' SUBROUTINE
; ------------------------
;   Part of the LET command contains a natural subroutine which is a
;   conditional LDIR. The copy only occurs of BC is non-zero.

L_ENTER:
        ex      de, hl          ;


COND_MV:
        ld      a, b            ;
        or      c               ;
        ret     z               ;

        push    de              ;

        ldir                    ; Copy Bytes

        pop     hl              ;
        ret                     ; Return.

; ---

L_ADD_DOLLAR:
        dec     hl              ;
        dec     hl              ;
        dec     hl              ;
        ld      a, (hl)         ;
        push    hl              ;
        push    bc              ;

        call    L_STRING        ; routine L-STRING

        pop     bc              ;
        pop     hl              ;
        inc     bc              ;
        inc     bc              ;
        inc     bc              ;
        jp      RECLAIM_2       ; jump back to exit via RECLAIM-2

; ---

L_NEW_DOLLAR:
        ld      a, $60          ; prepare mask %01100000
        ld      hl, (DEST)      ; sv DEST-lo
        xor     (hl)            ;

; -------------------------
; THE 'L-STRING' SUBROUTINE
; -------------------------
;

L_STRING:
        push    af              ;
        call    STK_FETCH       ; routine STK-FETCH
        ex      de, hl          ;
        add     hl, bc          ;
        push    hl              ;
        inc     bc              ;
        inc     bc              ;
        inc     bc              ;

        rst     BC_SPACES       ; BC-SPACES
        ex      de, hl          ;
        pop     hl              ;
        dec     bc              ;
        dec     bc              ;
        push    bc              ;
        lddr                    ; Copy Bytes
        ex      de, hl          ;
        pop     bc              ;
        dec     bc              ;
        ld      (hl), b         ;
        dec     hl              ;
        ld      (hl), c         ;
        pop     af              ;

L_FIRST:
        push    af              ;
        call    REC_V80         ; routine REC-V80
        pop     af              ;
        dec     hl              ;
        ld      (hl), a         ;
        ld      hl, (STKBOT)    ; sv STKBOT_lo
        ld      (E_LINE), hl    ; sv E_LINE_lo
        dec     hl              ;
        ld      (hl), $80       ;
        ret                     ;

; --------------------------
; THE 'STK-FETCH' SUBROUTINE
; --------------------------
; This routine fetches a five-byte value from the calculator stack
; reducing the pointer to the end of the stack by five.
; For a floating-point number the exponent is in A and the mantissa
; is the thirty-two bits EDCB.
; For strings, the start of the string is in DE and the length in BC.
; A is unused.

STK_FETCH:
        ld      hl, (STKEND)    ; load HL from system variable STKEND

        dec     hl              ;
        ld      b, (hl)         ;
        dec     hl              ;
        ld      c, (hl)         ;
        dec     hl              ;
        ld      d, (hl)         ;
        dec     hl              ;
        ld      e, (hl)         ;
        dec     hl              ;
        ld      a, (hl)         ;

        ld      (STKEND), hl    ; set system variable STKEND to lower value.
        ret                     ; return.

; -------------------------
; THE 'DIM' COMMAND ROUTINE
; -------------------------
; An array is created and initialized to zeros which is also the space
; character on the ZX81.

DIM:
        call    LOOK_VARS       ; routine LOOK-VARS

D_RPORT_C:
        jp      nz, REPORT_C    ; to REPORT-C

        call    SYNTAX_Z        ; routine SYNTAX-Z
        jr      nz, D_RUN       ; forward to D-RUN

        res     6, c            ;
        call    STK_VAR         ; routine STK-VAR
        call    CHECK_END       ; routine CHECK-END

D_RUN:
        jr      c, D_LETTER     ; forward to D-LETTER

        push    bc              ;
        call    NEXT_ONE        ; routine NEXT-ONE
        call    RECLAIM_2       ; routine RECLAIM-2
        pop     bc              ;

D_LETTER:
        set     7, c            ;
        ld      b, $00          ;
        push    bc              ;
        ld      hl, $0001       ;
        bit     6, c            ;
        jr      nz, D_SIZE      ; forward to D-SIZE

        ld      l, $05          ;

D_SIZE:
        ex      de, hl          ;

D_NO_LOOP:
        rst     NEXT_CHAR       ; NEXT-CHAR
        ld      h, $40          ;
        call    INT_EXP1        ; routine INT-EXP1
        jp      c, REPORT_3     ; jump back to REPORT-3

        pop     hl              ;
        push    bc              ;
        inc     h               ;
        push    hl              ;
        ld      h, b            ;
        ld      l, c            ;
        call    GET_HL_MULT_DE  ; routine GET-HL*DE
        ex      de, hl          ;

        rst     GET_CHAR        ; GET-CHAR
        cp      $1A             ;
        jr      z, D_NO_LOOP    ; back to D-NO-LOOP

        cp      $11             ; is it ')' ?
        jr      nz, D_RPORT_C   ; back if not to D-RPORT-C


        rst     NEXT_CHAR       ; NEXT-CHAR
        pop     bc              ;
        ld      a, c            ;
        ld      l, b            ;
        ld      h, $00          ;
        inc     hl              ;
        inc     hl              ;
        add     hl, hl          ;
        add     hl, de          ;
        jp      c, REPORT_4     ; jump to REPORT-4

        push    de              ;
        push    bc              ;
        push    hl              ;
        ld      b, h            ;
        ld      c, l            ;
        ld      hl, (E_LINE)    ; sv E_LINE_lo
        dec     hl              ;
        call    MAKE_ROOM       ; routine MAKE-ROOM
        inc     hl              ;
        ld      (hl), a         ;
        pop     bc              ;
        dec     bc              ;
        dec     bc              ;
        dec     bc              ;
        inc     hl              ;
        ld      (hl), c         ;
        inc     hl              ;
        ld      (hl), b         ;
        pop     af              ;
        inc     hl              ;
        ld      (hl), a         ;
        ld      h, d            ;
        ld      l, e            ;
        dec     de              ;
        ld      (hl), $00       ;
        pop     bc              ;
        lddr                    ; Copy Bytes

DIM_SIZES:
        pop     bc              ;
        ld      (hl), b         ;
        dec     hl              ;
        ld      (hl), c         ;
        dec     hl              ;
        dec     a               ;
        jr      nz, DIM_SIZES   ; back to DIM-SIZES

        ret                     ; return.

; ---------------------
; THE 'RESERVE' ROUTINE
; ---------------------
;
;

RESERVE:
        ld      hl, (STKBOT)    ; address STKBOT
        dec     hl              ; now last byte of workspace
        call    MAKE_ROOM       ; routine MAKE-ROOM
        inc     hl              ;
        inc     hl              ;
        pop     bc              ;
        ld      (E_LINE), bc    ; sv E_LINE_lo
        pop     bc              ;
        ex      de, hl          ;
        inc     hl              ;
        ret                     ;

; ---------------------------
; THE 'CLEAR' COMMAND ROUTINE
; ---------------------------
;
;

CLEAR:
        ld      hl, (VARS)      ; sv VARS_lo
        ld      (hl), $80       ;
        inc     hl              ;
        ld      (E_LINE), hl    ; sv E_LINE_lo

; -----------------------
; THE 'X-TEMP' SUBROUTINE
; -----------------------
;
;

X_TEMP:
        ld      hl, (E_LINE)    ; sv E_LINE_lo

; ----------------------
; THE 'SET-STK' ROUTINES
; ----------------------
;
;

SET_STK_B:
        ld      (STKBOT), hl    ; sv STKBOT

;

SET_STK_E:
        ld      (STKEND), hl    ; sv STKEND
        ret                     ;

; -----------------------
; THE 'CURSOR-IN' ROUTINE
; -----------------------
; This routine is called to set the edit line to the minimum cursor/newline
; and to set STKEND, the start of free space, at the next position.

CURSOR_IN:
        ld      hl, (E_LINE)    ; fetch start of edit line from E_LINE
        ld      (hl), $7F       ; insert cursor character

        inc     hl              ; point to next location.
        ld      (hl), $76       ; insert NEWLINE character
        inc     hl              ; point to next free location.

        ld      (iy+DF_SZ-IY0), $02
                                ; set lower screen display file size DF_SZ

        jr      SET_STK_B       ; exit via SET-STK-B above

; ------------------------
; THE 'SET-MIN' SUBROUTINE
; ------------------------
;
;

SET_MIN:
        ld      hl, MEMBOT      ; normal location of calculator's memory area
        ld      (MEM), hl       ; update system variable MEM
        ld      hl, (STKBOT)    ; fetch STKBOT
        jr      SET_STK_E       ; back to SET-STK-E


; ------------------------------------
; THE 'RECLAIM THE END-MARKER' ROUTINE
; ------------------------------------

REC_V80:
        ld      de, (E_LINE)    ; sv E_LINE_lo
        jp      RECLAIM_1       ; to RECLAIM-1

; ----------------------
; THE 'ALPHA' SUBROUTINE
; ----------------------

ALPHA:
        cp      $26             ;
        jr      ALPHA_2         ; skip forward to ALPHA-2


; -------------------------
; THE 'ALPHANUM' SUBROUTINE
; -------------------------

ALPHANUM:
        cp      $1C             ;


ALPHA_2:
        ccf                     ; Complement Carry Flag
        ret     nc              ;

        cp      $40             ;
        ret                     ;


; ------------------------------------------
; THE 'DECIMAL TO FLOATING POINT' SUBROUTINE
; ------------------------------------------
;

DEC_TO_FP:
        call    INT_TO_FP       ; routine INT-TO-FP gets first part
        cp      $1B             ; is character a '.' ?
        jr      nz, E_FORMAT    ; forward if not to E-FORMAT


        rst     FP_CALC         ;; FP-CALC
        defb    $A1             ;;stk-one
        defb    $C0             ;;st-mem-0
        defb    $02             ;;delete
        defb    $34             ;;end-calc


; ---------------------
; THE 'NEXT DIGIT' LOOP
; ---------------------

NXT_DGT_1:
        rst     NEXT_CHAR       ; NEXT-CHAR
        call    STK_DIGIT       ; routine STK-DIGIT
        jr      c, E_FORMAT     ; forward to E-FORMAT


        rst     FP_CALC         ;; FP-CALC
        defb    $E0             ;;get-mem-0
        defb    $A4             ;;stk-ten
        defb    $05             ;;division
        defb    $C0             ;;st-mem-0
        defb    $04             ;;multiply
        defb    $0F             ;;addition
        defb    $34             ;;end-calc

        jr      NXT_DGT_1       ; loop back till exhausted to NXT-DGT-1

; ---

E_FORMAT:
        cp      $2A             ; is character 'E' ?
        ret     nz              ; return if not

        ld      (iy+MEMBOT-IY0), $FF
                                ; initialize sv MEM-0-1st to $FF TRUE

        rst     NEXT_CHAR       ; NEXT-CHAR
        cp      $15             ; is character a '+' ?
        jr      z, SIGN_DONE    ; forward if so to SIGN-DONE

        cp      $16             ; is it a '-' ?
        jr      nz, ST_E_PART   ; forward if not to ST-E-PART

        inc     (iy+MEMBOT-IY0) ; sv MEM-0-1st change to FALSE

SIGN_DONE:
        rst     NEXT_CHAR       ; NEXT-CHAR

ST_E_PART:
        call    INT_TO_FP       ; routine INT-TO-FP

        rst     FP_CALC         ;; FP-CALC              m, e.
        defb    $E0             ;;get-mem-0             m, e, (1/0) TRUE/FALSE
        defb    $00             ;;jump-true
        defb    $02             ;;to L1511, E-POSTVE
        defb    $18             ;;neg                   m, -e

E_POSTVE:
        defb    $38             ;;e-to-fp               x.
        defb    $34             ;;end-calc              x.

        ret                     ; return.


; --------------------------
; THE 'STK-DIGIT' SUBROUTINE
; --------------------------
;

STK_DIGIT:
        cp      $1C             ;
        ret     c               ;

        cp      $26             ;
        ccf                     ; Complement Carry Flag
        ret     c               ;

        sub     $1C             ;

; ------------------------
; THE 'STACK-A' SUBROUTINE
; ------------------------
;


STACK_A:
        ld      c, a            ;
        ld      b, $00          ;

; -------------------------
; THE 'STACK-BC' SUBROUTINE
; -------------------------
; The ZX81 does not have an integer number format so the BC register contents
; must be converted to their full floating-point form.

STACK_BC:
        ld      iy, ERR_NR      ; re-initialize the system variables pointer.
        push    bc              ; save the integer value.

; now stack zero, five zero bytes as a starting point.

        rst     FP_CALC         ;; FP-CALC
        defb    $A0             ;;stk-zero                      0.
        defb    $34             ;;end-calc

        pop     bc              ; restore integer value.

        ld      (hl), $91       ; place $91 in exponent         65536.
                                ; this is the maximum possible value

        ld      a, b            ; fetch hi-byte.
        and     a               ; test for zero.
        jr      nz, STK_BC_2    ; forward if not zero to STK-BC-2

        ld      (hl), a         ; else make exponent zero again
        or      c               ; test lo-byte
        ret     z               ; return if BC was zero - done.

; else  there has to be a set bit if only the value one.

        ld      b, c            ; save C in B.
        ld      c, (hl)         ; fetch zero to C
        ld      (hl), $89       ; make exponent $89             256.

STK_BC_2:
        dec     (hl)            ; decrement exponent - halving number
        sla     c               ;  C<-76543210<-0
        rl      b               ;  C<-76543210<-C
        jr      nc, STK_BC_2    ; loop back if no carry to STK-BC-2

        srl     b               ;  0->76543210->C
        rr      c               ;  C->76543210->C

        inc     hl              ; address first byte of mantissa
        ld      (hl), b         ; insert B
        inc     hl              ; address second byte of mantissa
        ld      (hl), c         ; insert C

        dec     hl              ; point to the
        dec     hl              ; exponent again
        ret                     ; return.

; ------------------------------------------
; THE 'INTEGER TO FLOATING POINT' SUBROUTINE
; ------------------------------------------
;
;

INT_TO_FP:
        push    af              ;

        rst     FP_CALC         ;; FP-CALC
        defb    $A0             ;;stk-zero
        defb    $34             ;;end-calc

        pop     af              ;

NXT_DGT_2:
        call    STK_DIGIT       ; routine STK-DIGIT
        ret     c               ;


        rst     FP_CALC         ;; FP-CALC
        defb    $01             ;;exchange
        defb    $A4             ;;stk-ten
        defb    $04             ;;multiply
        defb    $0F             ;;addition
        defb    $34             ;;end-calc


        rst     NEXT_CHAR       ; NEXT-CHAR
        jr      NXT_DGT_2       ; to NXT-DGT-2


; -------------------------------------------
; THE 'E-FORMAT TO FLOATING POINT' SUBROUTINE
; -------------------------------------------
; (Offset $38: 'e-to-fp')
; invoked from DEC-TO-FP and PRINT-FP.
; e.g. 2.3E4 is 23000.
; This subroutine evaluates xEm where m is a positive or negative integer.
; At a simple level x is multiplied by ten for every unit of m.
; If the decimal exponent m is negative then x is divided by ten for each unit.
; A short-cut is taken if the exponent is greater than seven and in this
; case the exponent is reduced by seven and the value is multiplied or divided
; by ten million.
; Note. for the ZX Spectrum an even cleverer method was adopted which involved
; shifting the bits out of the exponent so the result was achieved with six
; shifts at most. The routine below had to be completely re-written mostly
; in Z80 machine code.
; Although no longer operable, the calculator literal was retained for old
; times sake, the routine being invoked directly from a machine code CALL.
;
; On entry in the ZX81, m, the exponent, is the 'last value', and the
; floating-point decimal mantissa is beneath it.


e_to_fp:
        rst     FP_CALC         ;; FP-CALC              x, m.
        defb    $2D             ;;duplicate             x, m, m.
        defb    $32             ;;less-0                x, m, (1/0).
        defb    $C0             ;;st-mem-0              x, m, (1/0).
        defb    $02             ;;delete                x, m.
        defb    $27             ;;abs                   x, +m.

E_LOOP:
        defb    $A1             ;;stk-one               x, m,1.
        defb    $03             ;;subtract              x, m-1.
        defb    $2D             ;;duplicate             x, m-1,m-1.
        defb    $32             ;;less-0                x, m-1, (1/0).
        defb    $00             ;;jump-true             x, m-1.
        defb    $22             ;;to L1587, E-END       x, m-1.

        defb    $2D             ;;duplicate             x, m-1, m-1.
        defb    $30             ;;stk-data
        defb    $33             ;;Exponent: $83, Bytes: 1

        defb    $40             ;;(+00,+00,+00)         x, m-1, m-1, 6.
        defb    $03             ;;subtract              x, m-1, m-7.
        defb    $2D             ;;duplicate             x, m-1, m-7, m-7.
        defb    $32             ;;less-0                x, m-1, m-7, (1/0).
        defb    $00             ;;jump-true             x, m-1, m-7.
        defb    $0C             ;;to L157A, E-LOW

; but if exponent m is higher than 7 do a bigger chunk.
; multiplying (or dividing if negative) by 10 million - 1e7.

        defb    $01             ;;exchange              x, m-7, m-1.
        defb    $02             ;;delete                x, m-7.
        defb    $01             ;;exchange              m-7, x.
        defb    $30             ;;stk-data
        defb    $80             ;;Bytes: 3
        defb    $48             ;;Exponent $98
        defb    $18, $96, $80   ;;(+00)                 m-7, x, 10,000,000 (=f)
        defb    $2F             ;;jump
        defb    $04             ;;to L157D, E-CHUNK

; ---

E_LOW:
        defb    $02             ;;delete                x, m-1.
        defb    $01             ;;exchange              m-1, x.
        defb    $A4             ;;stk-ten               m-1, x, 10 (=f).

E_CHUNK:
        defb    $E0             ;;get-mem-0             m-1, x, f, (1/0)
        defb    $00             ;;jump-true             m-1, x, f
        defb    $04             ;;to L1583, E-DIVSN

        defb    $04             ;;multiply              m-1, x*f.
        defb    $2F             ;;jump
        defb    $02             ;;to L1584, E-SWAP

; ---

E_DIVSN:
        defb    $05             ;;division              m-1, x/f (= new x).

E_SWAP:
        defb    $01             ;;exchange              x, m-1 (= new m).
        defb    $2F             ;;jump                  x, m.
        defb    $DA             ;;to L1560, E-LOOP

; ---

E_END:
        defb    $02             ;;delete                x. (-1)
        defb    $34             ;;end-calc              x.

        ret                     ; return.

; -------------------------------------
; THE 'FLOATING-POINT TO BC' SUBROUTINE
; -------------------------------------
; The floating-point form on the calculator stack is compressed directly into
; the BC register rounding up if necessary.
; Valid range is 0 to 65535.4999

FP_TO_BC:
        call    STK_FETCH       ; routine STK-FETCH - exponent to A
                                ; mantissa to EDCB.
        and     a               ; test for value zero.
        jr      nz, FPBC_NZRO   ; forward if not to FPBC-NZRO

; else value is zero

        ld      b, a            ; zero to B
        ld      c, a            ; also to C
        push    af              ; save the flags on machine stack
        jr      FPBC_END        ; forward to FPBC-END

; ---

; EDCB  =>  BCE

FPBC_NZRO:
        ld      b, e            ; transfer the mantissa from EDCB
        ld      e, c            ; to BCE. Bit 7 of E is the 17th bit which
        ld      c, d            ; will be significant for rounding if the
                                ; number is already normalized.

        sub     $91             ; subtract 65536
        ccf                     ; complement carry flag
        bit     7, b            ; test sign bit
        push    af              ; push the result

        set     7, b            ; set the implied bit
        jr      c, FPBC_END     ; forward with carry from SUB/CCF to FPBC-END
                                ; number is too big.

        inc     a               ; increment the exponent and
        neg                     ; negate to make range $00 - $0F

        cp      $08             ; test if one or two bytes
        jr      c, BIG_INT      ; forward with two to BIG-INT

        ld      e, c            ; shift mantissa
        ld      c, b            ; 8 places right
        ld      b, $00          ; insert a zero in B
        sub     $08             ; reduce exponent by eight

BIG_INT:
        and     a               ; test the exponent
        ld      d, a            ; save exponent in D.

        ld      a, e            ; fractional bits to A
        rlca                    ; rotate most significant bit to carry for
                                ; rounding of an already normal number.

        jr      z, EXP_ZERO     ; forward if exponent zero to EXP-ZERO
                                ; the number is normalized

FPBC_NORM:
        srl     b               ;   0->76543210->C
        rr      c               ;   C->76543210->C

        dec     d               ; decrement exponent

        jr      nz, FPBC_NORM   ; loop back till zero to FPBC-NORM

EXP_ZERO:
        jr      nc, FPBC_END    ; forward without carry to NO-ROUND

        inc     bc              ; round up.
        ld      a, b            ; test result
        or      c               ; for zero
        jr      nz, FPBC_END    ; forward if not to GRE-ZERO

        pop     af              ; restore sign flag
        scf                     ; set carry flag to indicate overflow
        push    af              ; save combined flags again

FPBC_END:
        push    bc              ; save BC value

; set HL and DE to calculator stack pointers.

        rst     FP_CALC         ;; FP-CALC
        defb    $34             ;;end-calc


        pop     bc              ; restore BC value
        pop     af              ; restore flags
        ld      a, c            ; copy low byte to A also.
        ret                     ; return

; ------------------------------------
; THE 'FLOATING-POINT TO A' SUBROUTINE
; ------------------------------------
;
;

FP_TO_A:
        call    FP_TO_BC        ; routine FP-TO-BC
        ret     c               ;

        push    af              ;
        dec     b               ;
        inc     b               ;
        jr      z, FP_A_END     ; forward if in range to FP-A-END

        pop     af              ; fetch result
        scf                     ; set carry flag signaling overflow
        ret                     ; return

FP_A_END:
        pop     af              ;
        ret                     ;


; ----------------------------------------------
; THE 'PRINT A FLOATING-POINT NUMBER' SUBROUTINE
; ----------------------------------------------
; prints 'last value' x on calculator stack.
; There are a wide variety of formats see Chapter 4.
; e.g.
; PI            prints as       3.1415927
; .123          prints as       0.123
; .0123         prints as       .0123
; 999999999999  prints as       1000000000000
; 9876543210123 prints as       9876543200000

; Begin by isolating zero and just printing the '0' character
; for that case. For negative numbers print a leading '-' and
; then form the absolute value of x.

PRINT_FP:
        rst     FP_CALC         ;; FP-CALC              x.
        defb    $2D             ;;duplicate             x, x.
        defb    $32             ;;less-0                x, (1/0).
        defb    $00             ;;jump-true
        defb    $0B             ;;to L15EA, PF-NGTVE    x.

        defb    $2D             ;;duplicate             x, x
        defb    $33             ;;greater-0             x, (1/0).
        defb    $00             ;;jump-true
        defb    $0D             ;;to L15F0, PF-POSTVE   x.

        defb    $02             ;;delete                .
        defb    $34             ;;end-calc              .

        ld      a, $1C          ; load accumulator with character '0'

        rst     PRINT_A         ; PRINT-A
        ret                     ; return.                               >>

; ---

PF_NEGTVE:
        defb    $27             ; abs                   +x.
        defb    $34             ;;end-calc              x.

        ld      a, $16          ; load accumulator with '-'

        rst     PRINT_A         ; PRINT-A

        rst     FP_CALC         ;; FP-CALC              x.

PF_POSTVE:
        defb    $34             ;;end-calc              x.

; register HL addresses the exponent of the floating-point value.
; if positive, and point floats to left, then bit 7 is set.

        ld      a, (hl)         ; pick up the exponent byte
        call    STACK_A         ; routine STACK-A places on calculator stack.

; now calculate roughly the number of digits, n, before the decimal point by
; subtracting a half from true exponent and multiplying by log to
; the base 10 of 2.
; The true number could be one higher than n, the integer result.

        rst     FP_CALC         ;; FP-CALC              x, e.
        defb    $30             ;;stk-data
        defb    $78             ;;Exponent: $88, Bytes: 2
        defb    $00, $80        ;;(+00,+00)             x, e, 128.5.
        defb    $03             ;;subtract              x, e -.5.
        defb    $30             ;;stk-data
        defb    $EF             ;;Exponent: $7F, Bytes: 4
        defb    $1A, $20, $9A, $85
                                ;;                      .30103 (log10 2)
        defb    $04             ;;multiply              x,
        defb    $24             ;;int
        defb    $C1             ;;st-mem-1              x, n.


        defb    $30             ;;stk-data
        defb    $34             ;;Exponent: $84, Bytes: 1
        defb    $00             ;;(+00,+00,+00)         x, n, 8.

        defb    $03             ;;subtract              x, n-8.
        defb    $18             ;;neg                   x, 8-n.
        defb    $38             ;;e-to-fp               x * (10^n)

; finally the 8 or 9 digit decimal is rounded.
; a ten-digit integer can arise in the case of, say, 999999999.5
; which gives 1000000000.

        defb    $A2             ;;stk-half
        defb    $0F             ;;addition
        defb    $24             ;;int                   i.
        defb    $34             ;;end-calc

; If there were 8 digits then final rounding will take place on the calculator
; stack above and the next two instructions insert a masked zero so that
; no further rounding occurs. If the result is a 9 digit integer then
; rounding takes place within the buffer.

        ld      hl, MEMBOT+2*5+4; address system variable MEM-2-5th
                                ; which could be the 'ninth' digit.
        ld      (hl), $90       ; insert the value $90  10010000

; now starting from lowest digit lay down the 8, 9 or 10 digit integer
; which represents the significant portion of the number
; e.g. PI will be the nine-digit integer 314159265

        ld      b, $0A          ; count is ten digits.

PF_LOOP:
        inc     hl              ; increase pointer

        push    hl              ; preserve buffer address.
        push    bc              ; preserve counter.

        rst     FP_CALC         ;; FP-CALC              i.
        defb    $A4             ;;stk-ten               i, 10.
        defb    $2E             ;;n-mod-m               i mod 10, i/10
        defb    $01             ;;exchange              i/10, remainder.
        defb    $34             ;;end-calc

        call    FP_TO_A         ; routine FP-TO-A  $00-$09

        or      $90             ; make left hand nibble 9

        pop     bc              ; restore counter
        pop     hl              ; restore buffer address.

        ld      (hl), a         ; insert masked digit in buffer.
        djnz    PF_LOOP         ; loop back for all ten to PF-LOOP

; the most significant digit will be last but if the number is exhausted then
; the last one or two positions will contain zero ($90).

; e.g. for 'one' we have zero as estimate of leading digits.
; 1*10^8 100000000 as integer value
; 90 90 90 90 90   90 90 90 91 90 as buffer mem3/mem4 contents.


        inc     hl              ; advance pointer to one past buffer
        ld      bc, $0008       ; set C to 8 ( B is already zero )
        push    hl              ; save pointer.

PF_NULL:
        dec     hl              ; decrease pointer
        ld      a, (hl)         ; fetch masked digit
        cp      $90             ; is it a leading zero ?
        jr      z, PF_NULL      ; loop back if so to PF-NULL

; at this point a significant digit has been found. carry is reset.

        sbc     hl, bc          ; subtract eight from the address.
        push    hl              ; ** save this pointer too
        ld      a, (hl)         ; fetch addressed byte
        add     a, $6B          ; add $6B - forcing a round up ripple
                                ; if  $95 or over.
        push    af              ; save the carry result.

; now enter a loop to round the number. After rounding has been considered
; a zero that has arisen from rounding or that was present at that position
; originally is changed from $90 to $80.

PF_RND_LP:
        pop     af              ; retrieve carry from machine stack.
        inc     hl              ; increment address
        ld      a, (hl)         ; fetch new byte
        adc     a, $00          ; add in any carry

        daa                     ; decimal adjust accumulator
                                ; carry will ripple through the '9'

        push    af              ; save carry on machine stack.
        and     $0F             ; isolate character 0 - 9 AND set zero flag
                                ; if zero.
        ld      (hl), a         ; place back in location.
        set     7, (hl)         ; set bit 7 to show printable.
                                ; but not if trailing zero after decimal point.
        jr      z, PF_RND_LP    ; back if a zero to PF-RND-LP
                                ; to consider further rounding and/or trailing
                                ; zero identification.

        pop     af              ; balance stack
        pop     hl              ; ** retrieve lower pointer

; now insert 6 trailing zeros which are printed if before the decimal point
; but mark the end of printing if after decimal point.
; e.g. 9876543210123 is printed as 9876543200000
; 123.456001 is printed as 123.456

        ld      b, $06          ; the count is six.

PF_ZERO_6:
        ld      (hl), $80       ; insert a masked zero
        dec     hl              ; decrease pointer.
        djnz    PF_ZERO_6       ; loop back for all six to PF-ZERO-6

; n-mod-m reduced the number to zero and this is now deleted from the calculator
; stack before fetching the original estimate of leading digits.


        rst     FP_CALC         ;; FP-CALC              0.
        defb    $02             ;;delete                .
        defb    $E1             ;;get-mem-1             n.
        defb    $34             ;;end-calc              n.

        call    FP_TO_A         ; routine FP-TO-A
        jr      z, PF_POS       ; skip forward if positive to PF-POS

        neg                     ; negate makes positive

PF_POS:
        ld      e, a            ; transfer count of digits to E
        inc     e               ; increment twice
        inc     e               ;
        pop     hl              ; * retrieve pointer to one past buffer.

GET_FIRST:
        dec     hl              ; decrement address.
        dec     e               ; decrement digit counter.
        ld      a, (hl)         ; fetch masked byte.
        and     $0F             ; isolate right-hand nibble.
        jr      z, GET_FIRST    ; back with leading zero to GET-FIRST

; now determine if E-format printing is needed

        ld      a, e            ; transfer now accurate number count to A.
        sub     $05             ; subtract five
        cp      $08             ; compare with 8 as maximum digits is 13.
        jp      p, PF_E_FMT     ; forward if positive to PF-E-FMT

        cp      $F6             ; test for more than four zeros after point.
        jp      m, PF_E_FMT     ; forward if so to PF-E-FMT

        add     a, $06          ; test for zero leading digits, e.g. 0.5
        jr      z, PF_ZERO_1    ; forward if so to PF-ZERO-1

        jp      m, PF_ZEROS     ; forward if more than one zero to PF-ZEROS

; else digits before the decimal point are to be printed

        ld      b, a            ; count of leading characters to B.

PF_NIB_LP:
        call    PF_NIBBLE       ; routine PF-NIBBLE
        djnz    PF_NIB_LP       ; loop back for counted numbers to PF-NIB-LP

        jr      PF_DC_OUT       ; forward to consider decimal part to PF-DC-OUT

; ---

PF_E_FMT:
        ld      b, e            ; count to B
        call    PF_NIBBLE       ; routine PF-NIBBLE prints one digit.
        call    PF_DC_OUT       ; routine PF-DC-OUT considers fractional part.

        ld      a, $2A          ; prepare character 'E'
        rst     PRINT_A         ; PRINT-A

        ld      a, b            ; transfer exponent to A
        and     a               ; test the sign.
        jp      p, PF_E_POS     ; forward if positive to PF-E-POS

        neg                     ; negate the negative exponent.
        ld      b, a            ; save positive exponent in B.

        ld      a, $16          ; prepare character '-'
        jr      PF_E_SIGN       ; skip forward to PF-E-SIGN

; ---

PF_E_POS:
        ld      a, $15          ; prepare character '+'

PF_E_SIGN:
        rst     PRINT_A         ; PRINT-A

; now convert the integer exponent in B to two characters.
; it will be less than 99.

        ld      a, b            ; fetch positive exponent.
        ld      b, $FF          ; initialize left hand digit to minus one.

PF_E_TENS:
        inc     b               ; increment ten count
        sub     $0A             ; subtract ten from exponent
        jr      nc, PF_E_TENS   ; loop back if greater than ten to PF-E-TENS

        add     a, $0A          ; reverse last subtraction
        ld      c, a            ; transfer remainder to C

        ld      a, b            ; transfer ten value to A.
        and     a               ; test for zero.
        jr      z, PF_E_LOW     ; skip forward if so to PF-E-LOW

        call    OUT_CODE        ; routine OUT-CODE prints as digit '1' - '9'

PF_E_LOW:
        ld      a, c            ; low byte to A
        call    OUT_CODE        ; routine OUT-CODE prints final digit of the
                                ; exponent.
        ret                     ; return.                               >>

; ---

; -------------------------------------
; THE 'FLOATING POINT PRINT ZEROS' LOOP
; -------------------------------------

; This branch deals with zeros after decimal point.
; e.g.      .01 or .0000999
; Note. that printing to the ZX Printer destroys A and that A should be
; initialized to '0' at each stage of the loop.
; LPRINT .00001 prints as .0XYZ1

PF_ZEROS:
        neg                     ; negate makes number positive 1 to 4.
        ld      b, a            ; zero count to B.

        ld      a, $1B          ; prepare character '.'
        rst     PRINT_A         ; PRINT-A

        ld      a, $1C          ; prepare a '0'

PF_ZRO_LP:
        rst     PRINT_A         ; PRINT-A

        djnz    PF_ZRO_LP       ; loop back to PF-ZRO-LP

;   and continue with trailing fractional digits...

        jr      PF_FRAC_LP      ; forward to PF-FRAC-LP

; ---

; there is  a need to print a leading zero e.g. 0.1 but not with .01

PF_ZERO_1:
        ld      a, $1C          ; prepare character '0'.
        rst     PRINT_A         ; PRINT-A

; this subroutine considers the decimal point and any trailing digits.
; if the next character is a marked zero, $80, then nothing more to print.

PF_DC_OUT:
        dec     (hl)            ; decrement addressed character
        inc     (hl)            ; increment it again
        ret     pe              ; return with overflow  (was 128) >>
                                ; as no fractional part

; else there is a fractional part so print the decimal point.

        ld      a, $1B          ; prepare character '.'
        rst     PRINT_A         ; PRINT-A

; now enter a loop to print trailing digits

PF_FRAC_LP:
        dec     (hl)            ; test for a marked zero.
        inc     (hl)            ;
        ret     pe              ; return when digits exhausted          >>

        call    PF_NIBBLE       ; routine PF-NIBBLE
        jr      PF_FRAC_LP      ; back for all fractional digits to PF-FRAC-LP.

; ---

; subroutine to print right-hand nibble

PF_NIBBLE:
        ld      a, (hl)         ; fetch addressed byte
        and     $0F             ; mask off lower 4 bits
        call    OUT_CODE        ; routine OUT-CODE
        dec     hl              ; decrement pointer.
        ret                     ; return.


; -------------------------------
; THE 'PREPARE TO ADD' SUBROUTINE
; -------------------------------
; This routine is called twice to prepare each floating point number for
; addition, in situ, on the calculator stack.
; The exponent is picked up from the first byte which is then cleared to act
; as a sign byte and accept any overflow.
; If the exponent is zero then the number is zero and an early return is made.
; The now redundant sign bit of the mantissa is set and if the number is
; negative then all five bytes of the number are twos-complemented to prepare
; the number for addition.
; On the second invocation the exponent of the first number is in B.


PREP_ADD:
        ld      a, (hl)         ; fetch exponent.
        ld      (hl), $00       ; make this byte zero to take any overflow and
                                ; default to positive.
        and     a               ; test stored exponent for zero.
        ret     z               ; return with zero flag set if number is zero.

        inc     hl              ; point to first byte of mantissa.
        bit     7, (hl)         ; test the sign bit.
        set     7, (hl)         ; set it to its implied state.
        dec     hl              ; set pointer to first byte again.
        ret     z               ; return if bit indicated number is positive.>>

; if negative then all five bytes are twos complemented starting at LSB.

        push    bc              ; save B register contents.
        ld      bc, $0005       ; set BC to five.
        add     hl, bc          ; point to location after 5th byte.
        ld      b, c            ; set the B counter to five.
        ld      c, a            ; store original exponent in C.
        scf                     ; set carry flag so that one is added.

; now enter a loop to twos-complement the number.
; The first of the five bytes becomes $FF to denote a negative number.

NEG_BYTE:
        dec     hl              ; point to first or more significant byte.
        ld      a, (hl)         ; fetch to accumulator.
        cpl                     ; complement.
        adc     a, $00          ; add in initial carry or any subsequent carry.
        ld      (hl), a         ; place number back.
        djnz    NEG_BYTE        ; loop back five times to NEG-BYTE

        ld      a, c            ; restore the exponent to accumulator.
        pop     bc              ; restore B register contents.

        ret                     ; return.

; ----------------------------------
; THE 'FETCH TWO NUMBERS' SUBROUTINE
; ----------------------------------
; This routine is used by addition, multiplication and division to fetch
; the two five-byte numbers addressed by HL and DE from the calculator stack
; into the Z80 registers.
; The HL register may no longer point to the first of the two numbers.
; Since the 32-bit addition operation is accomplished using two Z80 16-bit
; instructions, it is important that the lower two bytes of each mantissa are
; in one set of registers and the other bytes all in the alternate set.
;
; In: HL = highest number, DE= lowest number
;
;         : alt':   :
; Out:    :H,B-C:C,B: num1
;         :L,D-E:D-E: num2

FETCH_TWO:
        push    hl              ; save HL
        push    af              ; save A - result sign when used from division.

        ld      c, (hl)         ;
        inc     hl              ;
        ld      b, (hl)         ;
        ld      (hl), a         ; insert sign when used from multiplication.
        inc     hl              ;
        ld      a, c            ; m1
        ld      c, (hl)         ;
        push    bc              ; PUSH m2 m3

        inc     hl              ;
        ld      c, (hl)         ; m4
        inc     hl              ;
        ld      b, (hl)         ; m5  BC holds m5 m4

        ex      de, hl          ; make HL point to start of second number.

        ld      d, a            ; m1
        ld      e, (hl)         ;
        push    de              ; PUSH m1 n1

        inc     hl              ;
        ld      d, (hl)         ;
        inc     hl              ;
        ld      e, (hl)         ;
        push    de              ; PUSH n2 n3

        exx                     ; - - - - - - -

        pop     de              ; POP n2 n3
        pop     hl              ; POP m1 n1
        pop     bc              ; POP m2 m3

        exx                     ; - - - - - - -

        inc     hl              ;
        ld      d, (hl)         ;
        inc     hl              ;
        ld      e, (hl)         ; DE holds n4 n5

        pop     af              ; restore saved
        pop     hl              ; registers.
        ret                     ; return.

; -----------------------------
; THE 'SHIFT ADDEND' SUBROUTINE
; -----------------------------
; The accumulator A contains the difference between the two exponents.
; This is the lowest of the two numbers to be added

SHIFT_FP:
        and     a               ; test difference between exponents.
        ret     z               ; return if zero. both normal.

        cp      $21             ; compare with 33 bits.
        jr      nc, ADDEND_0    ; forward if greater than 32 to ADDEND-0

        push    bc              ; preserve BC - part
        ld      b, a            ; shift counter to B.

; Now perform B right shifts on the addend  L'D'E'D E
; to bring it into line with the augend     H'B'C'C B

ONE_SHIFT:
        exx                     ; - - -
        sra     l               ;    76543210->C    bit 7 unchanged.
        rr      d               ; C->76543210->C
        rr      e               ; C->76543210->C
        exx                     ; - - -
        rr      d               ; C->76543210->C
        rr      e               ; C->76543210->C
        djnz    ONE_SHIFT       ; loop back B times to ONE-SHIFT

        pop     bc              ; restore BC
        ret     nc              ; return if last shift produced no carry.   >>

; if carry flag was set then accuracy is being lost so round up the addend.

        call    ADD_BACK        ; routine ADD-BACK
        ret     nz              ; return if not FF 00 00 00 00

; this branch makes all five bytes of the addend zero and is made during
; addition when the exponents are too far apart for the addend bits to
; affect the result.

ADDEND_0:
        exx                     ; select alternate set for more significant
                                ; bytes.


; In Edition 2 ROM, deleted spurious instructions causing floating point bug

        xor     a               ; clear accumulator.

; this entry point (from multiplication) sets four of the bytes to zero or if
; continuing from above, during addition, then all five bytes are set to zero.

ZEROS_4_OR_5:
        ld      l, $00          ; set byte 1 to zero - sign indicator
        ld      d, a            ; set byte 2 to A.
        ld      e, l            ; set byte 3 to zero.
        exx                     ; select main set
        ld      de, $0000       ; set lower bytes 4 and 5 to zero.
        ret                     ; return.

; -------------------------
; THE 'ADD-BACK' SUBROUTINE
; -------------------------
; Called from SHIFT-FP above during addition and after normalization from
; multiplication.
; This is really a 32-bit increment routine which sets the zero flag according
; to the 32-bit result.
; During addition, only negative numbers like FF FF FF FF FF,
; the twos-complement version of xx 80 00 00 01 say
; will result in a full ripple FF 00 00 00 00.
; FF FF FF FF FF when shifted right is unchanged by SHIFT-FP but sets the
; carry invoking this routine.

ADD_BACK:
        inc     e               ;
        ret     nz              ;

        inc     d               ;
        ret     nz              ;

        exx                     ;
        inc     e               ;
        jr      nz, ALL_ADDED   ; forward if no overflow to ALL-ADDED

        inc     d               ;

ALL_ADDED:
        exx                     ;
        ret                     ; return with zero flag set for zero mantissa.


; ---------------------------
; THE 'SUBTRACTION' OPERATION
; ---------------------------
; just switch the sign of subtrahend and do an add.

subtract:
        ld      a, (de)         ; fetch exponent byte of second number the
                                ; subtrahend.
        and     a               ; test for zero
        ret     z               ; return if zero - first number is result.

        inc     de              ; address the first mantissa byte.
        ld      a, (de)         ; fetch to accumulator.
        xor     $80             ; toggle the sign bit.
        ld      (de), a         ; place back on calculator stack.
        dec     de              ; point to exponent byte.
                                ; continue into addition routine.

; ------------------------
; THE 'ADDITION' OPERATION
; ------------------------
; The addition operation pulls out all the stops and uses most of the Z80's
; registers to add two floating-point numbers.
; This is a binary operation and on entry, HL points to the first number
; and DE to the second.

addition:
        exx                     ; - - -
        push    hl              ; save the pointer to the next literal.
        exx                     ; - - -

        push    de              ; save pointer to second number
        push    hl              ; save pointer to first number - will be the
                                ; result pointer on calculator stack.

        call    PREP_ADD        ; routine PREP-ADD
        ld      b, a            ; save first exponent byte in B.
        ex      de, hl          ; switch number pointers.
        call    PREP_ADD        ; routine PREP-ADD
        ld      c, a            ; save second exponent byte in C.
        cp      b               ; compare the exponent bytes.
        jr      nc, SHIFT_LEN   ; forward if second higher to SHIFT-LEN

        ld      a, b            ; else higher exponent to A
        ld      b, c            ; lower exponent to B
        ex      de, hl          ; switch the number pointers.

SHIFT_LEN:
        push    af              ; save higher exponent
        sub     b               ; subtract lower exponent

        call    FETCH_TWO       ; routine FETCH-TWO
        call    SHIFT_FP        ; routine SHIFT-FP

        pop     af              ; restore higher exponent.
        pop     hl              ; restore result pointer.
        ld      (hl), a         ; insert exponent byte.
        push    hl              ; save result pointer again.

; now perform the 32-bit addition using two 16-bit Z80 add instructions.

        ld      l, b            ; transfer low bytes of mantissa individually
        ld      h, c            ; to HL register

        add     hl, de          ; the actual binary addition of lower bytes

; now the two higher byte pairs that are in the alternate register sets.

        exx                     ; switch in set
        ex      de, hl          ; transfer high mantissa bytes to HL register.

        adc     hl, bc          ; the actual addition of higher bytes with
                                ; any carry from first stage.

        ex      de, hl          ; result in DE, sign bytes ($FF or $00) to HL

; now consider the two sign bytes

        ld      a, h            ; fetch sign byte of num1

        adc     a, l            ; add including any carry from mantissa
                                ; addition. 00 or 01 or FE or FF

        ld      l, a            ; result in L.

; possible outcomes of signs and overflow from mantissa are
;
;  H +  L + carry =  L    RRA  XOR L  RRA
; ------------------------------------------------------------
; 00 + 00         = 00    00   00
; 00 + 00 + carry = 01    00   01     carry
; FF + FF         = FE C  FF   01     carry
; FF + FF + carry = FF C  FF   00
; FF + 00         = FF    FF   00
; FF + 00 + carry = 00 C  80   80

        rra                     ; C->76543210->C
        xor     l               ; set bit 0 if shifting required.

        exx                     ; switch back to main set
        ex      de, hl          ; full mantissa result now in D'E'D E registers.
        pop     hl              ; restore pointer to result exponent on
                                ; the calculator stack.

        rra                     ; has overflow occurred ?
        jr      nc, TEST_NEG    ; skip forward if not to TEST-NEG

; if the addition of two positive mantissas produced overflow or if the
; addition of two negative mantissas did not then the result exponent has to
; be incremented and the mantissa shifted one place to the right.

        ld      a, $01          ; one shift required.
        call    SHIFT_FP        ; routine SHIFT-FP performs a single shift
                                ; rounding any lost bit
        inc     (hl)            ; increment the exponent.
        jr      z, ADD_REP_6    ; forward to ADD-REP-6 if the exponent
                                ; wraps round from FF to zero as number is too
                                ; big for the system.

; at this stage the exponent on the calculator stack is correct.

TEST_NEG:
        exx                     ; switch in the alternate set.
        ld      a, l            ; load result sign to accumulator.
        and     $80             ; isolate bit 7 from sign byte setting zero
                                ; flag if positive.
        exx                     ; back to main set.

        inc     hl              ; point to first byte of mantissa
        ld      (hl), a         ; insert $00 positive or $80 negative at
                                ; position on calculator stack.

        dec     hl              ; point to exponent again.
        jr      z, GO_NC_MLT    ; forward if positive to GO-NC-MLT

; a negative number has to be twos-complemented before being placed on stack.

        ld      a, e            ; fetch lowest (rightmost) mantissa byte.
        neg                     ; Negate
        ccf                     ; Complement Carry Flag
        ld      e, a            ; place back in register

        ld      a, d            ; ditto
        cpl                     ;
        adc     a, $00          ;
        ld      d, a            ;

        exx                     ; switch to higher (leftmost) 16 bits.

        ld      a, e            ; ditto
        cpl                     ;
        adc     a, $00          ;
        ld      e, a            ;

        ld      a, d            ; ditto
        cpl                     ;
        adc     a, $00          ;
        jr      nc, END_COMPL   ; forward without overflow to END-COMPL

; else entire mantissa is now zero.  00 00 00 00

        rra                     ; set mantissa to 80 00 00 00
        exx                     ; switch.
        inc     (hl)            ; increment the exponent.

ADD_REP_6:
        jp      z, REPORT_6     ; jump forward if exponent now zero to REPORT-6
                                ; 'Number too big'

        exx                     ; switch back to alternate set.

END_COMPL:
        ld      d, a            ; put first byte of mantissa back in DE.
        exx                     ; switch to main set.

GO_NC_MLT:
        xor     a               ; clear carry flag and
                                ; clear accumulator so no extra bits carried
                                ; forward as occurs in multiplication.

        jr      TEST_NORM       ; forward to common code at TEST-NORM
                                ; but should go straight to NORMALIZE.


; ----------------------------------------------
; THE 'PREPARE TO MULTIPLY OR DIVIDE' SUBROUTINE
; ----------------------------------------------
; this routine is called twice from multiplication and twice from division
; to prepare each of the two numbers for the operation.
; Initially the accumulator holds zero and after the second invocation bit 7
; of the accumulator will be the sign bit of the result.

PREP_M_OR_D:
        scf                     ; set carry flag to signal number is zero.
        dec     (hl)            ; test exponent
        inc     (hl)            ; for zero.
        ret     z               ; return if zero with carry flag set.

        inc     hl              ; address first mantissa byte.
        xor     (hl)            ; exclusive or the running sign bit.
        set     7, (hl)         ; set the implied bit.
        dec     hl              ; point to exponent byte.
        ret                     ; return.

; ------------------------------
; THE 'MULTIPLICATION' OPERATION
; ------------------------------
;
;

multiply:
        xor     a               ; reset bit 7 of running sign flag.
        call    PREP_M_OR_D     ; routine PREP-M/D
        ret     c               ; return if number is zero.
                                ; zero * anything = zero.

        exx                     ; - - -
        push    hl              ; save pointer to 'next literal'
        exx                     ; - - -

        push    de              ; save pointer to second number

        ex      de, hl          ; make HL address second number.

        call    PREP_M_OR_D     ; routine PREP-M/D

        ex      de, hl          ; HL first number, DE - second number
        jr      c, ZERO_RSLT    ; forward with carry to ZERO-RSLT
                                ; anything * zero = zero.

        push    hl              ; save pointer to first number.

        call    FETCH_TWO       ; routine FETCH-TWO fetches two mantissas from
                                ; calc stack to B'C'C,B  D'E'D E
                                ; (HL will be overwritten but the result sign
                                ; in A is inserted on the calculator stack)

        ld      a, b            ; transfer low mantissa byte of first number
        and     a               ; clear carry.
        sbc     hl, hl          ; a short form of LD HL,$0000 to take lower
                                ; two bytes of result. (2 program bytes)
        exx                     ; switch in alternate set
        push    hl              ; preserve HL
        sbc     hl, hl          ; set HL to zero also to take higher two bytes
                                ; of the result and clear carry.
        exx                     ; switch back.

        ld      b, $21          ; register B can now be used to count thirty
                                ; three shifts.
        jr      STRT_MLT        ; forward to loop entry point STRT-MLT

; ---

; The multiplication loop is entered at  STRT-LOOP.

MLT_LOOP:
        jr      nc, NO_ADD      ; forward if no carry to NO-ADD

                                ; else add in the multiplicand.

        add     hl, de          ; add the two low bytes to result
        exx                     ; switch to more significant bytes.
        adc     hl, de          ; add high bytes of multiplicand and any carry.
        exx                     ; switch to main set.

; in either case shift result right into B'C'C A

NO_ADD:
        exx                     ; switch to alternate set
        rr      h               ; C > 76543210 > C
        rr      l               ; C > 76543210 > C
        exx                     ;
        rr      h               ; C > 76543210 > C
        rr      l               ; C > 76543210 > C

STRT_MLT:
        exx                     ; switch in alternate set.
        rr      b               ; C > 76543210 > C
        rr      c               ; C > 76543210 > C
        exx                     ; now main set
        rr      c               ; C > 76543210 > C
        rra                     ; C > 76543210 > C
        djnz    MLT_LOOP        ; loop back 33 times to MLT-LOOP

;

        ex      de, hl          ;
        exx                     ;
        ex      de, hl          ;
        exx                     ;
        pop     bc              ;
        pop     hl              ;
        ld      a, b            ;
        add     a, c            ;
        jr      nz, MAKE_EXPT   ; forward to MAKE-EXPT

        and     a               ;

MAKE_EXPT:
        dec     a               ;
        ccf                     ; Complement Carry Flag

DIVN_EXPT:
        rla                     ;
        ccf                     ; Complement Carry Flag
        rra                     ;
        jp      p, OFLW1_CLR    ; forward to OFLW1-CLR

        jr      nc, REPORT_6    ; forward to REPORT-6

        and     a               ;

OFLW1_CLR:
        inc     a               ;
        jr      nz, OFLW2_CLR   ; forward to OFLW2-CLR

        jr      c, OFLW2_CLR    ; forward to OFLW2-CLR

        exx                     ;
        bit     7, d            ;
        exx                     ;
        jr      nz, REPORT_6    ; forward to REPORT-6

OFLW2_CLR:
        ld      (hl), a         ;
        exx                     ;
        ld      a, b            ;
        exx                     ;

; addition joins here with carry flag clear.

TEST_NORM:
        jr      nc, NORMALIZE   ; forward to NORMALIZE

        ld      a, (hl)         ;
        and     a               ;

NEAR_ZERO:
        ld      a, $80          ; prepare to rescue the most significant bit
                                ; of the mantissa if it is set.
        jr      z, SKIP_ZERO    ; skip forward to SKIP-ZERO

ZERO_RSLT:
        xor     a               ; make mask byte zero signaling set five
                                ; bytes to zero.

SKIP_ZERO:
        exx                     ; switch in alternate set
        and     d               ; isolate most significant bit (if A is $80).

        call    ZEROS_4_OR_5    ; routine ZEROS-4/5 sets mantissa without
                                ; affecting any flags.

        rlca                    ; test if MSB set. bit 7 goes to bit 0.
                                ; either $00 -> $00 or $80 -> $01
        ld      (hl), a         ; make exponent $01 (lowest) or $00 zero
        jr      c, OFLOW_CLR    ; forward if first case to OFLOW-CLR

        inc     hl              ; address first mantissa byte on the
                                ; calculator stack.
        ld      (hl), a         ; insert a zero for the sign bit.
        dec     hl              ; point to zero exponent
        jr      OFLOW_CLR       ; forward to OFLOW-CLR

; ---

; this branch is common to addition and multiplication with the mantissa
; result still in registers D'E'D E .

NORMALIZE:
        ld      b, $20          ; a maximum of thirty-two left shifts will be
                                ; needed.

SHIFT_ONE:
        exx                     ; address higher 16 bits.
        bit     7, d            ; test the leftmost bit
        exx                     ; address lower 16 bits.

        jr      nz, NORML_NOW   ; forward if leftmost bit was set to NORML-NOW

        rlca                    ; this holds zero from addition, 33rd bit
                                ; from multiplication.

        rl      e               ; C < 76543210 < C
        rl      d               ; C < 76543210 < C

        exx                     ; address higher 16 bits.

        rl      e               ; C < 76543210 < C
        rl      d               ; C < 76543210 < C

        exx                     ; switch to main set.

        dec     (hl)            ; decrement the exponent byte on the calculator
                                ; stack.

        jr      z, NEAR_ZERO    ; back if exponent becomes zero to NEAR-ZERO
                                ; it's just possible that the last rotation
                                ; set bit 7 of D. We shall see.

        djnz    SHIFT_ONE       ; loop back to SHIFT-ONE

; if thirty-two left shifts were performed without setting the most significant
; bit then the result is zero.

        jr      ZERO_RSLT       ; back to ZERO-RSLT

; ---

NORML_NOW:
        rla                     ; for the addition path, A is always zero.
                                ; for the mult path, ...

        jr      nc, OFLOW_CLR   ; forward to OFLOW-CLR

; this branch is taken only with multiplication.

        call    ADD_BACK        ; routine ADD-BACK

        jr      nz, OFLOW_CLR   ; forward to OFLOW-CLR

        exx                     ;
        ld      d, $80          ;
        exx                     ;
        inc     (hl)            ;
        jr      z, REPORT_6     ; forward to REPORT-6

; now transfer the mantissa from the register sets to the calculator stack
; incorporating the sign bit already there.

OFLOW_CLR:
        push    hl              ; save pointer to exponent on stack.
        inc     hl              ; address first byte of mantissa which was
                                ; previously loaded with sign bit $00 or $80.

        exx                     ; - - -
        push    de              ; push the most significant two bytes.
        exx                     ; - - -

        pop     bc              ; pop - true mantissa is now BCDE.

; now pick up the sign bit.

        ld      a, b            ; first mantissa byte to A
        rla                     ; rotate out bit 7 which is set
        rl      (hl)            ; rotate sign bit on stack into carry.
        rra                     ; rotate sign bit into bit 7 of mantissa.

; and transfer mantissa from main registers to calculator stack.

        ld      (hl), a         ;
        inc     hl              ;
        ld      (hl), c         ;
        inc     hl              ;
        ld      (hl), d         ;
        inc     hl              ;
        ld      (hl), e         ;

        pop     hl              ; restore pointer to num1 now result.
        pop     de              ; restore pointer to num2 now STKEND.

        exx                     ; - - -
        pop     hl              ; restore pointer to next calculator literal.
        exx                     ; - - -

        ret                     ; return.

; ---

REPORT_6:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_6_OVERFLOW  ; Error Report: Arithmetic overflow.

; ------------------------
; THE 'DIVISION' OPERATION
; ------------------------
;   "Of all the arithmetic subroutines, division is the most complicated and
;   the least understood.  It is particularly interesting to note that the
;   Sinclair programmer himself has made a mistake in his programming ( or has
;   copied over someone else's mistake!) for
;   PRINT PEEK 6352 [ $18D0 ] ('unimproved' ROM, 6351 [ $18CF ] )
;   should give 218 not 225."
;   - Dr. Ian Logan, Syntax magazine Jul/Aug 1982.
;   [  i.e. the jump should be made to div-34th ]

;   First check for division by zero.

division:
        ex      de, hl          ; consider the second number first.
        xor     a               ; set the running sign flag.
        call    PREP_M_OR_D     ; routine PREP-M/D
        jr      c, REPORT_6     ; back if zero to REPORT-6
                                ; 'Arithmetic overflow'

        ex      de, hl          ; now prepare first number and check for zero.
        call    PREP_M_OR_D     ; routine PREP-M/D
        ret     c               ; return if zero, 0/anything is zero.

        exx                     ; - - -
        push    hl              ; save pointer to the next calculator literal.
        exx                     ; - - -

        push    de              ; save pointer to divisor - will be STKEND.
        push    hl              ; save pointer to dividend - will be result.

        call    FETCH_TWO       ; routine FETCH-TWO fetches the two numbers
                                ; into the registers H'B'C'C B
                                ;                    L'D'E'D E
        exx                     ; - - -
        push    hl              ; save the two exponents.

        ld      h, b            ; transfer the dividend to H'L'H L
        ld      l, c            ;
        exx                     ;
        ld      h, c            ;
        ld      l, b            ;

        xor     a               ; clear carry bit and accumulator.
        ld      b, $DF          ; count upwards from -33 decimal
        jr      DIV_START       ; forward to mid-loop entry point DIV-START

; ---

DIV_LOOP:
        rla                     ; multiply partial quotient by two
        rl      c               ; setting result bit from carry.
        exx                     ;
        rl      c               ;
        rl      b               ;
        exx                     ;

div_34th:
        add     hl, hl          ;
        exx                     ;
        adc     hl, hl          ;
        exx                     ;
        jr      c, SUBN_ONLY    ; forward to SUBN-ONLY

DIV_START:
        sbc     hl, de          ; subtract divisor part.
        exx                     ;
        sbc     hl, de          ;
        exx                     ;
        jr      nc, NO_RSTORE   ; forward if subtraction goes to NO-RSTORE

        add     hl, de          ; else restore
        exx                     ;
        adc     hl, de          ;
        exx                     ;
        and     a               ; clear carry
        jr      COUNT_ONE       ; forward to COUNT-ONE

; ---

SUBN_ONLY:
        and     a               ;
        sbc     hl, de          ;
        exx                     ;
        sbc     hl, de          ;
        exx                     ;

NO_RSTORE:
        scf                     ; set carry flag

COUNT_ONE:
        inc     b               ; increment the counter
        jp      m, DIV_LOOP     ; back while still minus to DIV-LOOP

        push    af              ;

        jr      z, DIV_START    ; back to DIV-START

; "This jump is made to the wrong place. No 34th bit will ever be obtained
; without first shifting the dividend. Hence important results like 1/10 and
; 1/1000 are not rounded up as they should be. Rounding up never occurs when
; it depends on the 34th bit. The jump should be made to div-34th above."
; - Dr. Frank O'Hara, "The Complete Spectrum ROM Disassembly", 1983,
; published by Melbourne House.
; (Note. on the ZX81 this would be JR Z,L18AB)
;
; However if you make this change, then while (1/2=.5) will now evaluate as
; true, (.25=1/4), which did evaluate as true, no longer does.

        ld      e, a            ;
        ld      d, c            ;
        exx                     ;
        ld      e, c            ;
        ld      d, b            ;

        pop     af              ;
        rr      b               ;
        pop     af              ;
        rr      b               ;

        exx                     ;
        pop     bc              ;
        pop     hl              ;
        ld      a, b            ;
        sub     c               ;
        jp      DIVN_EXPT       ; jump back to DIVN-EXPT

; ------------------------------------------------
; THE 'INTEGER TRUNCATION TOWARDS ZERO' SUBROUTINE
; ------------------------------------------------
;

truncate:
        ld      a, (hl)         ; fetch exponent
        cp      $81             ; compare to +1
        jr      nc, T_GR_ZERO   ; forward, if 1 or more, to T-GR-ZERO

; else the number is smaller than plus or minus 1 and can be made zero.

        ld      (hl), $00       ; make exponent zero.
        ld      a, $20          ; prepare to set 32 bits of mantissa to zero.
        jr      NIL_BYTES       ; forward to NIL-BYTES

; ---

T_GR_ZERO:
        sub     $A0             ; subtract +32 from exponent
        ret     p               ; return if result is positive as all 32 bits
                                ; of the mantissa relate to the integer part.
                                ; The floating point is somewhere to the right
                                ; of the mantissa

        neg                     ; else negate to form number of rightmost bits
                                ; to be blanked.

; for instance, disregarding the sign bit, the number 3.5 is held as
; exponent $82 mantissa .11100000 00000000 00000000 00000000
; we need to set $82 - $A0 = $E2 NEG = $1E (thirty) bits to zero to form the
; integer.
; The sign of the number is never considered as the first bit of the mantissa
; must be part of the integer.

NIL_BYTES:
        push    de              ; save pointer to STKEND
        ex      de, hl          ; HL points at STKEND
        dec     hl              ; now at last byte of mantissa.
        ld      b, a            ; Transfer bit count to B register.
        srl     b               ; divide by
        srl     b               ; eight
        srl     b               ;
        jr      z, BITS_ZERO    ; forward if zero to BITS-ZERO

; else the original count was eight or more and whole bytes can be blanked.

BYTE_ZERO:
        ld      (hl), $00       ; set eight bits to zero.
        dec     hl              ; point to more significant byte of mantissa.
        djnz    BYTE_ZERO       ; loop back to BYTE-ZERO

; now consider any residual bits.

BITS_ZERO:
        and     $07             ; isolate the remaining bits
        jr      z, IX_END       ; forward if none to IX-END

        ld      b, a            ; transfer bit count to B counter.
        ld      a, $FF          ; form a mask 11111111

LESS_MASK:
        sla     a               ; 1 <- 76543210 <- o     slide mask leftwards.
        djnz    LESS_MASK       ; loop back for bit count to LESS-MASK

        and     (hl)            ; lose the unwanted rightmost bits
        ld      (hl), a         ; and place in mantissa byte.

IX_END:
        ex      de, hl          ; restore result pointer from DE.
        pop     de              ; restore STKEND from stack.
        ret                     ; return.




;********************************
;**  FLOATING-POINT CALCULATOR **
;********************************

; As a general rule the calculator avoids using the IY register.
; Exceptions are val and str$.
; So an assembly language programmer who has disabled interrupts to use IY
; for other purposes can still use the calculator for mathematical
; purposes.


; ------------------------
; THE 'TABLE OF CONSTANTS'
; ------------------------
; The ZX81 has only floating-point number representation.
; Both the ZX80 and the ZX Spectrum have integer numbers in some form.

TAB_CNST:
;; stk-zero                                                 00 00 00 00 00
        defb    $00             ;;Bytes: 1
        defb    $B0             ;;Exponent $00
        defb    $00             ;;(+00,+00,+00)

;; stk-one                                                  81 00 00 00 00
        defb    $31             ;;Exponent $81, Bytes: 1
        defb    $00             ;;(+00,+00,+00)


;; stk-half                                                 80 00 00 00 00
        defb    $30             ;;Exponent: $80, Bytes: 1
        defb    $00             ;;(+00,+00,+00)


;; stk-pi/2                                                 81 49 0F DA A2
        defb    $F1             ;;Exponent: $81, Bytes: 4
        defb    $49, $0F, $DA, $A2
                                ;;

;; stk-ten                                                  84 20 00 00 00
        defb    $34             ;;Exponent: $84, Bytes: 1
        defb    $20             ;;(+00,+00,+00)

; ------------------------
; THE 'TABLE OF ADDRESSES'
; ------------------------
;
; Starts with binary operations which have two operands and one result.
; three pseudo binary operations first.

tbl_addrs:
        defw    jump_true       ; $00 Address: $1C2F - jump-true
        defw    exchange        ; $01 Address: $1A72 - exchange
        defw    delete          ; $02 Address: $19E3 - delete

; true binary operations.

        defw    subtract        ; $03 Address: $174C - subtract
        defw    multiply        ; $04 Address: $176C - multiply
        defw    division        ; $05 Address: $1882 - division
        defw    to_power        ; $06 Address: $1DE2 - to-power
        defw    or              ; $07 Address: $1AED - or

        defw    no_and_no       ; $08 Address: $1B03 - no-&-no
        defw    no_l_eql        ; $09 Address: $1B03 - no-l-eql
        defw    no_l_eql        ; $0A Address: $1B03 - no-gr-eql
        defw    no_l_eql        ; $0B Address: $1B03 - nos-neql
        defw    no_l_eql        ; $0C Address: $1B03 - no-grtr
        defw    no_l_eql        ; $0D Address: $1B03 - no-less
        defw    no_l_eql        ; $0E Address: $1B03 - nos-eql
        defw    addition        ; $0F Address: $1755 - addition

        defw    str_and_no      ; $10 Address: $1AF8 - str-&-no
        defw    no_l_eql        ; $11 Address: $1B03 - str-l-eql
        defw    no_l_eql        ; $12 Address: $1B03 - str-gr-eql
        defw    no_l_eql        ; $13 Address: $1B03 - strs-neql
        defw    no_l_eql        ; $14 Address: $1B03 - str-grtr
        defw    no_l_eql        ; $15 Address: $1B03 - str-less
        defw    no_l_eql        ; $16 Address: $1B03 - strs-eql
        defw    strs_add        ; $17 Address: $1B62 - strs-add

; unary follow

        defw    neg             ; $18 Address: $1AA0 - neg

        defw    code            ; $19 Address: $1C06 - code
        defw    val             ; $1A Address: $1BA4 - val
        defw    len             ; $1B Address: $1C11 - len
        defw    sin             ; $1C Address: $1D49 - sin
        defw    cos             ; $1D Address: $1D3E - cos
        defw    tan             ; $1E Address: $1D6E - tan
        defw    asn             ; $1F Address: $1DC4 - asn
        defw    acs             ; $20 Address: $1DD4 - acs
        defw    atn             ; $21 Address: $1D76 - atn
        defw    ln              ; $22 Address: $1CA9 - ln
        defw    exp             ; $23 Address: $1C5B - exp
        defw    int             ; $24 Address: $1C46 - int
        defw    sqr             ; $25 Address: $1DDB - sqr
        defw    sgn             ; $26 Address: $1AAF - sgn
        defw    abs             ; $27 Address: $1AAA - abs
        defw    peek            ; $28 Address: $1A1B - peek
        defw    usr_no          ; $29 Address: $1AC5 - usr-no
        defw    str_dollar      ; $2A Address: $1BD5 - str$
        defw    chr_dollar      ; $2B Address: $1B8F - chr$
        defw    not             ; $2C Address: $1AD5 - not

; end of true unary

        defw    duplicate       ; $2D Address: $19F6 - duplicate
        defw    n_mod_m         ; $2E Address: $1C37 - n-mod-m

        defw    jump            ; $2F Address: $1C23 - jump
        defw    stk_data        ; $30 Address: $19FC - stk-data

        defw    dec_jr_nz       ; $31 Address: $1C17 - dec-jr-nz
        defw    less_0          ; $32 Address: $1ADB - less-0
        defw    greater_0       ; $33 Address: $1ACE - greater-0
        defw    end_calc        ; $34 Address: $002B - end-calc
        defw    get_argt        ; $35 Address: $1D18 - get-argt
        defw    truncate        ; $36 Address: $18E4 - truncate
        defw    fp_calc_2       ; $37 Address: $19E4 - fp-calc-2
        defw    e_to_fp         ; $38 Address: $155A - e-to-fp

; the following are just the next available slots for the 128 compound literals
; which are in range $80 - $FF.

        defw    seriesg_x       ; $39 Address: $1A7F - series-xx    $80 - $9F.
        defw    stk_con_x       ; $3A Address: $1A51 - stk-const-xx $A0 - $BF.
        defw    sto_mem_x       ; $3B Address: $1A63 - st-mem-xx    $C0 - $DF.
        defw    get_mem_x       ; $3C Address: $1A45 - get-mem-xx   $E0 - $FF.

; Aside: 3D - 7F are therefore unused calculator literals.
;        39 - 7B would be available for expansion.

; -------------------------------
; THE 'FLOATING POINT CALCULATOR'
; -------------------------------
;
;

CALCULATE:
        call    STK_PNTRS       ; routine STK-PNTRS is called to set up the
                                ; calculator stack pointers for a default
                                ; unary operation. HL = last value on stack.
                                ; DE = STKEND first location after stack.

; the calculate routine is called at this point by the series generator...

GEN_ENT_1:
        ld      a, b            ; fetch the Z80 B register to A
        ld      (BREG), a       ; and store value in system variable BREG.
                                ; this will be the counter for dec-jr-nz
                                ; or if used from fp-calc2 the calculator
                                ; instruction.

; ... and again later at this point

GEN_ENT_2:
        exx                     ; switch sets
        ex      (sp), hl        ; and store the address of next instruction,
                                ; the return address, in H'L'.
                                ; If this is a recursive call then the H'L'
                                ; of the previous invocation goes on stack.
                                ; c.f. end-calc.
        exx                     ; switch back to main set.

; this is the re-entry looping point when handling a string of literals.

RE_ENTRY:
        ld      (STKEND), de    ; save end of stack in system variable STKEND
        exx                     ; switch to alt
        ld      a, (hl)         ; get next literal
        inc     hl              ; increase pointer'

; single operation jumps back to here

SCAN_ENT:
        push    hl              ; save pointer on stack   *
        and     a               ; now test the literal
        jp      p, FIRST_3D     ; forward to FIRST-3D if in range $00 - $3D
                                ; anything with bit 7 set will be one of
                                ; 128 compound literals.

; Compound literals have the following format.
; bit 7 set indicates compound.
; bits 6-5 the subgroup 0-3.
; bits 4-0 the embedded parameter $00 - $1F.
; The subgroup 0-3 needs to be manipulated to form the next available four
; address places after the simple literals in the address table.

        ld      d, a            ; save literal in D
        and     $60             ; and with 01100000 to isolate subgroup
        rrca                    ; rotate bits
        rrca                    ; 4 places to right
        rrca                    ; not five as we need offset * 2
        rrca                    ; 00000xx0
        add     a, $72          ; add ($39 * 2) to give correct offset.
                                ; alter above if you add more literals.
        ld      l, a            ; store in L for later indexing.
        ld      a, d            ; bring back compound literal
        and     $1F             ; use mask to isolate parameter bits
        jr      ENT_TABLE       ; forward to ENT-TABLE

; ---

; the branch was here with simple literals.

FIRST_3D:
        cp      $18             ; compare with first unary operations.
        jr      nc, DOUBLE_A    ; to DOUBLE-A with unary operations

; it is binary so adjust pointers.

        exx                     ;
        ld      bc, $FFFB       ; the value -5
        ld      d, h            ; transfer HL, the last value, to DE.
        ld      e, l            ;
        add     hl, bc          ; subtract 5 making HL point to second
                                ; value.
        exx                     ;

DOUBLE_A:
        rlca                    ; double the literal
        ld      l, a            ; and store in L for indexing

ENT_TABLE:
        ld      de, tbl_addrs   ; Address: tbl-addrs
        ld      h, $00          ; prepare to index
        add     hl, de          ; add to get address of routine
        ld      e, (hl)         ; low byte to E
        inc     hl              ;
        ld      d, (hl)         ; high byte to D

        ld      hl, RE_ENTRY    ; Address: RE-ENTRY
        ex      (sp), hl        ; goes on machine stack
                                ; address of next literal goes to HL. *


        push    de              ; now the address of routine is stacked.
        exx                     ; back to main set
                                ; avoid using IY register.
        ld      bc, (BREG-1)    ; STKEND_hi
                                ; nothing much goes to C but BREG to B
                                ; and continue into next ret instruction
                                ; which has a dual identity


; -----------------------
; THE 'DELETE' SUBROUTINE
; -----------------------
; (offset $02: 'delete')
; A simple return but when used as a calculator literal this
; deletes the last value from the calculator stack.
; On entry, as always with binary operations,
; HL=first number, DE=second number
; On exit, HL=result, DE=stkend.
; So nothing to do

delete:
        ret                     ; return - indirect jump if from above.

; ---------------------------------
; THE 'SINGLE OPERATION' SUBROUTINE
; ---------------------------------
; (offset $37: 'fp-calc-2')
; this single operation is used, in the first instance, to evaluate most
; of the mathematical and string functions found in BASIC expressions.

fp_calc_2:
        pop     af              ; drop return address.
        ld      a, (BREG)       ; load accumulator from system variable BREG
                                ; value will be literal eg. 'tan'
        exx                     ; switch to alt
        jr      SCAN_ENT        ; back to SCAN-ENT
                                ; next literal will be end-calc in scanning

; ------------------------------
; THE 'TEST 5 SPACES' SUBROUTINE
; ------------------------------
; This routine is called from MOVE-FP/duplicate, STK-CONST and STK-STORE to
; test that there is enough space between the calculator stack and the
; machine stack for another five-byte value. It returns with BC holding
; the value 5 ready for any subsequent LDIR.

TEST_5_SP:
        push    de              ; save
        push    hl              ; registers
        ld      bc, $0005       ; an overhead of five bytes
        call    TEST_ROOM       ; routine TEST-ROOM tests free RAM raising
                                ; an error if not.
        pop     hl              ; else restore
        pop     de              ; registers.
        ret                     ; return with BC set at 5.


; ---------------------------------------------
; THE 'MOVE A FLOATING POINT NUMBER' SUBROUTINE
; ---------------------------------------------
; (offset $2D: 'duplicate')
; This simple routine is a 5-byte LDIR instruction
; that incorporates a memory check.
; When used as a calculator literal it duplicates the last value on the
; calculator stack.
; Unary so on entry HL points to last value, DE to stkend

duplicate:
        call    TEST_5_SP       ; routine TEST-5-SP test free memory
                                ; and sets BC to 5.
        ldir                    ; copy the five bytes.
        ret                     ; return with DE addressing new STKEND
                                ; and HL addressing new last value.

; -------------------------------
; THE 'STACK LITERALS' SUBROUTINE
; -------------------------------
; (offset $30: 'stk-data')
; When a calculator subroutine needs to put a value on the calculator
; stack that is not a regular constant this routine is called with a
; variable number of following data bytes that convey to the routine
; the floating point form as succinctly as is possible.

stk_data:
        ld      h, d            ; transfer STKEND
        ld      l, e            ; to HL for result.

STK_CONST:
        call    TEST_5_SP       ; routine TEST-5-SP tests that room exists
                                ; and sets BC to $05.

        exx                     ; switch to alternate set
        push    hl              ; save the pointer to next literal on stack
        exx                     ; switch back to main set

        ex      (sp), hl        ; pointer to HL, destination to stack.
        push    bc              ; save BC - value 5 from test room. No need.

        ld      a, (hl)         ; fetch the byte following 'stk-data'
        and     $C0             ; isolate bits 7 and 6
        rlca                    ; rotate
        rlca                    ; to bits 1 and 0  range $00 - $03.
        ld      c, a            ; transfer to C
        inc     c               ; and increment to give number of bytes
                                ; to read. $01 - $04
        ld      a, (hl)         ; reload the first byte
        and     $3F             ; mask off to give possible exponent.
        jr      nz, FORM_EXP    ; forward to FORM-EXP if it was possible to
                                ; include the exponent.

; else byte is just a byte count and exponent comes next.

        inc     hl              ; address next byte and
        ld      a, (hl)         ; pick up the exponent ( - $50).

FORM_EXP:
        add     a, $50          ; now add $50 to form actual exponent
        ld      (de), a         ; and load into first destination byte.
        ld      a, $05          ; load accumulator with $05 and
        sub     c               ; subtract C to give count of trailing
                                ; zeros plus one.
        inc     hl              ; increment source
        inc     de              ; increment destination
        ld      b, $00          ; prepare to copy. Note. B is zero.
        ldir                    ; copy C bytes

        pop     bc              ; restore 5 counter to BC.

        ex      (sp), hl        ; put HL on stack as next literal pointer
                                ; and the stack value - result pointer -
                                ; to HL.

        exx                     ; switch to alternate set.
        pop     hl              ; restore next literal pointer from stack
                                ; to H'L'.
        exx                     ; switch back to main set.

        ld      b, a            ; zero count to B
        xor     a               ; clear accumulator

STK_ZEROS:
        dec     b               ; decrement B counter
        ret     z               ; return if zero.          >>
                                ; DE points to new STKEND
                                ; HL to new number.

        ld      (de), a         ; else load zero to destination
        inc     de              ; increase destination
        jr      STK_ZEROS       ; loop back to STK-ZEROS until done.

; -------------------------------
; THE 'SKIP CONSTANTS' SUBROUTINE
; -------------------------------
; This routine traverses variable-length entries in the table of constants,
; stacking intermediate, unwanted constants onto a dummy calculator stack,
; in the first five bytes of the ZX81 ROM.

SKIP_CONS:
        and     a               ; test if initially zero.

SKIP_NEXT:
        ret     z               ; return if zero.          >>

        push    af              ; save count.
        push    de              ; and normal STKEND

        ld      de, $0000       ; dummy value for STKEND at start of ROM
                                ; Note. not a fault but this has to be
                                ; moved elsewhere when running in RAM.
                                ;
        call    STK_CONST       ; routine STK-CONST works through variable
                                ; length records.

        pop     de              ; restore real STKEND
        pop     af              ; restore count
        dec     a               ; decrease
        jr      SKIP_NEXT       ; loop back to SKIP-NEXT

; --------------------------------
; THE 'MEMORY LOCATION' SUBROUTINE
; --------------------------------
; This routine, when supplied with a base address in HL and an index in A,
; will calculate the address of the A'th entry, where each entry occupies
; five bytes. It is used for addressing floating-point numbers in the
; calculator's memory area.

LOC_MEM:
        ld      c, a            ; store the original number $00-$1F.
        rlca                    ; double.
        rlca                    ; quadruple.
        add     a, c            ; now add original value to multiply by five.

        ld      c, a            ; place the result in C.
        ld      b, $00          ; set B to 0.
        add     hl, bc          ; add to form address of start of number in HL.

        ret                     ; return.

; -------------------------------------
; THE 'GET FROM MEMORY AREA' SUBROUTINE
; -------------------------------------
; offsets $E0 to $FF: 'get-mem-0', 'get-mem-1' etc.
; A holds $00-$1F offset.
; The calculator stack increases by 5 bytes.

get_mem_x:
        push    de              ; save STKEND
        ld      hl, (MEM)       ; MEM is base address of the memory cells.

        call    LOC_MEM         ; routine LOC-MEM so that HL = first byte
        call    duplicate       ; routine MOVE-FP/duplicate moves 5 bytes with memory
                                ; check.
                                ; DE now points to new STKEND.
        pop     hl              ; the original STKEND is now RESULT pointer.
        ret                     ; return.

; ---------------------------------
; THE 'STACK A CONSTANT' SUBROUTINE
; ---------------------------------
; (offset $A0: 'stk-zero')
; (offset $A1: 'stk-one')
; (offset $A2: 'stk-half')
; (offset $A3: 'stk-pi/2')
; (offset $A4: 'stk-ten')
; This routine allows a one-byte instruction to stack up to 32 constants
; held in short form in a table of constants. In fact only 5 constants are
; required. On entry the A register holds the literal ANDed with $1F.
;
; It isn't very efficient and it would have been better to hold the
; numbers in full, five byte form and stack them in a similar manner
; to that which would be used later for semi-tone table values.

stk_con_x:
        ld      h, d            ; save STKEND - required for result
        ld      l, e            ;
        exx                     ; swap
        push    hl              ; save pointer to next literal
        ld      hl, TAB_CNST    ; Address: stk-zero - start of table of
                                ; constants
        exx                     ;
        call    SKIP_CONS       ; routine SKIP-CONS
        call    STK_CONST       ; routine STK-CONST
        exx                     ;
        pop     hl              ; restore pointer to next literal.
        exx                     ;
        ret                     ; return.

; ---

; ---------------------------------------
; THE 'STORE IN A MEMORY AREA' SUBROUTINE
; ---------------------------------------
; Offsets $C0 to $DF: 'st-mem-0', 'st-mem-1' etc.
; Although 32 memory storage locations can be addressed, only six
; $C0 to $C5 are required by the ROM and only the thirty bytes (6*5)
; required for these are allocated. ZX81 programmers who wish to
; use the floating point routines from assembly language may wish to
; alter the system variable MEM to point to 160 bytes of RAM to have
; use the full range available.
; A holds derived offset $00-$1F.
; Unary so on entry HL points to last value, DE to STKEND.

sto_mem_x:
        push    hl              ; save the result pointer.
        ex      de, hl          ; transfer to DE.
        ld      hl, (MEM)       ; fetch MEM the base of memory area.
        call    LOC_MEM         ; routine LOC-MEM sets HL to the destination.
        ex      de, hl          ; swap - HL is start, DE is destination.

        call    duplicate       ; routine MOVE-FP/duplicate.
                                ; note. a short ld bc,5; ldir
                                ; the embedded memory check is not required
                                ; so these instructions would be faster!

        ex      de, hl          ; DE = STKEND
        pop     hl              ; restore original result pointer
        ret                     ; return.

; -------------------------
; THE 'EXCHANGE' SUBROUTINE
; -------------------------
; (offset $01: 'exchange')
; This routine exchanges the last two values on the calculator stack
; On entry, as always with binary operations,
; HL=first number, DE=second number
; On exit, HL=result, DE=stkend.

exchange:
        ld      b, $05          ; there are five bytes to be swapped

; start of loop.

SWAP_BYTE:
        ld      a, (de)         ; each byte of second
        ld      c, (hl)         ; each byte of first
        ex      de, hl          ; swap pointers
        ld      (de), a         ; store each byte of first
        ld      (hl), c         ; store each byte of second
        inc     hl              ; advance both
        inc     de              ; pointers.
        djnz    SWAP_BYTE       ; loop back to SWAP-BYTE until all 5 done.

        ex      de, hl          ; even up the exchanges
                                ; so that DE addresses STKEND.
        ret                     ; return.

; ---------------------------------
; THE 'SERIES GENERATOR' SUBROUTINE
; ---------------------------------
; (offset $86: 'series-06')
; (offset $88: 'series-08')
; (offset $8C: 'series-0C')
; The ZX81 uses Chebyshev polynomials to generate approximations for
; SIN, ATN, LN and EXP. These are named after the Russian mathematician
; Pafnuty Chebyshev, born in 1821, who did much pioneering work on numerical
; series. As far as calculators are concerned, Chebyshev polynomials have an
; advantage over other series, for example the Taylor series, as they can
; reach an approximation in just six iterations for SIN, eight for EXP and
; twelve for LN and ATN. The mechanics of the routine are interesting but
; for full treatment of how these are generated with demonstrations in
; Sinclair BASIC see "The Complete Spectrum ROM Disassembly" by Dr Ian Logan
; and Dr Frank O'Hara, published 1983 by Melbourne House.

seriesg_x:
        ld      b, a            ; parameter $00 - $1F to B counter
        call    GEN_ENT_1       ; routine GEN-ENT-1 is called.
                                ; A recursive call to a special entry point
                                ; in the calculator that puts the B register
                                ; in the system variable BREG. The return
                                ; address is the next location and where
                                ; the calculator will expect its first
                                ; instruction - now pointed to by HL'.
                                ; The previous pointer to the series of
                                ; five-byte numbers goes on the machine stack.

; The initialization phase.

        defb    $2D             ;;duplicate       x,x
        defb    $0F             ;;addition        x+x
        defb    $C0             ;;st-mem-0        x+x
        defb    $02             ;;delete          .
        defb    $A0             ;;stk-zero        0
        defb    $C2             ;;st-mem-2        0

; a loop is now entered to perform the algebraic calculation for each of
; the numbers in the series

G_LOOP:
        defb    $2D             ;;duplicate       v,v.
        defb    $E0             ;;get-mem-0       v,v,x+2
        defb    $04             ;;multiply        v,v*x+2
        defb    $E2             ;;get-mem-2       v,v*x+2,v
        defb    $C1             ;;st-mem-1
        defb    $03             ;;subtract
        defb    $34             ;;end-calc

; the previous pointer is fetched from the machine stack to H'L' where it
; addresses one of the numbers of the series following the series literal.

        call    stk_data        ; routine STK-DATA is called directly to
                                ; push a value and advance H'L'.
        call    GEN_ENT_2       ; routine GEN-ENT-2 recursively re-enters
                                ; the calculator without disturbing
                                ; system variable BREG
                                ; H'L' value goes on the machine stack and is
                                ; then loaded as usual with the next address.

        defb    $0F             ;;addition
        defb    $01             ;;exchange
        defb    $C2             ;;st-mem-2
        defb    $02             ;;delete

        defb    $31             ;;dec-jr-nz
        defb    G_LOOP - ASMPC  ;;back to L1A89, G-LOOP

; when the counted loop is complete the final subtraction yields the result
; for example SIN X.

        defb    $E1             ;;get-mem-1
        defb    $03             ;;subtract
        defb    $34             ;;end-calc

        ret                     ; return with H'L' pointing to location
                                ; after last number in series.

; -----------------------
; Handle unary minus (18)
; -----------------------
; Unary so on entry HL points to last value, DE to STKEND.

neg:
        ld      a, (hl)         ; fetch exponent of last value on the
                                ; calculator stack.
        and     a               ; test it.
        ret     z               ; return if zero.

        inc     hl              ; address the byte with the sign bit.
        ld      a, (hl)         ; fetch to accumulator.
        xor     $80             ; toggle the sign bit.
        ld      (hl), a         ; put it back.
        dec     hl              ; point to last value again.
        ret                     ; return.

; -----------------------
; Absolute magnitude (27)
; -----------------------
; This calculator literal finds the absolute value of the last value,
; floating point, on calculator stack.

abs:
        inc     hl              ; point to byte with sign bit.
        res     7, (hl)         ; make the sign positive.
        dec     hl              ; point to last value again.
        ret                     ; return.

; -----------
; Signum (26)
; -----------
; This routine replaces the last value on the calculator stack,
; which is in floating point form, with one if positive and with minus one
; if it is negative. If it is zero then it is left unchanged.

sgn:
        inc     hl              ; point to first byte of 4-byte mantissa.
        ld      a, (hl)         ; pick up the byte with the sign bit.
        dec     hl              ; point to exponent.
        dec     (hl)            ; test the exponent for
        inc     (hl)            ; the value zero.

        scf                     ; Set the carry flag.
        call    nz, FP_0_1      ; Routine FP-0/1  replaces last value with one
                                ; if exponent indicates the value is non-zero.
                                ; In either case mantissa is now four zeros.

        inc     hl              ; Point to first byte of 4-byte mantissa.
        rlca                    ; Rotate original sign bit to carry.
        rr      (hl)            ; Rotate the carry into sign.
        dec     hl              ; Point to last value.
        ret                     ; Return.


; -------------------------
; Handle PEEK function (28)
; -------------------------
; This function returns the contents of a memory address.
; The entire address space can be peeked including the ROM.

peek:
        call    FIND_INT        ; routine FIND-INT puts address in BC.
        ld      a, (bc)         ; load contents into A register.

IN_PK_STK:
        jp      STACK_A         ; exit via STACK-A to put value on the
                                ; calculator stack.

; ---------------
; USR number (29)
; ---------------
; The USR function followed by a number 0-65535 is the method by which
; the ZX81 invokes machine code programs. This function returns the
; contents of the BC register pair.
; Note. that STACK-BC re-initializes the IY register to $4000 if a user-written
; program has altered it.

usr_no:
        call    FIND_INT        ; routine FIND-INT to fetch the
                                ; supplied address into BC.

        ld      hl, STACK_BC    ; address: STACK-BC is
        push    hl              ; pushed onto the machine stack.
        push    bc              ; then the address of the machine code
                                ; routine.

        ret                     ; make an indirect jump to the user's routine
                                ; and, hopefully, to STACK-BC also.


; -----------------------
; Greater than zero ($33)
; -----------------------
; Test if the last value on the calculator stack is greater than zero.
; This routine is also called directly from the end-tests of the comparison
; routine.

greater_0:
        ld      a, (hl)         ; fetch exponent.
        and     a               ; test it for zero.
        ret     z               ; return if so.


        ld      a, $FF          ; prepare XOR mask for sign bit
        jr      SIGN_TO_C       ; forward to SIGN-TO-C
                                ; to put sign in carry
                                ; (carry will become set if sign is positive)
                                ; and then overwrite location with 1 or 0
                                ; as appropriate.

; ------------------------
; Handle NOT operator ($2C)
; ------------------------
; This overwrites the last value with 1 if it was zero else with zero
; if it was any other value.
;
; e.g. NOT 0 returns 1, NOT 1 returns 0, NOT -3 returns 0.
;
; The subroutine is also called directly from the end-tests of the comparison
; operator.

not:
        ld      a, (hl)         ; get exponent byte.
        neg                     ; negate - sets carry if non-zero.
        ccf                     ; complement so carry set if zero, else reset.
        jr      FP_0_1          ; forward to FP-0/1.

; -------------------
; Less than zero (32)
; -------------------
; Destructively test if last value on calculator stack is less than zero.
; Bit 7 of second byte will be set if so.

less_0:
        xor     a               ; set xor mask to zero
                                ; (carry will become set if sign is negative).

; transfer sign of mantissa to Carry Flag.

SIGN_TO_C:
        inc     hl              ; address 2nd byte.
        xor     (hl)            ; bit 7 of HL will be set if number is negative.
        dec     hl              ; address 1st byte again.
        rlca                    ; rotate bit 7 of A to carry.

; -----------
; Zero or one
; -----------
; This routine places an integer value zero or one at the addressed location
; of calculator stack or MEM area. The value one is written if carry is set on
; entry else zero.

FP_0_1:
        push    hl              ; save pointer to the first byte
        ld      b, $05          ; five bytes to do.

PF_loop:
        ld      (hl), $00       ; insert a zero.
        inc     hl              ;
        djnz    PF_loop         ; repeat.

        pop     hl              ;
        ret     nc              ;

        ld      (hl), $81       ; make value 1
        ret                     ; return.


; -----------------------
; Handle OR operator (07)
; -----------------------
; The Boolean OR operator. eg. X OR Y
; The result is zero if both values are zero else a non-zero value.
;
; e.g.    0 OR 0  returns 0.
;        -3 OR 0  returns -3.
;         0 OR -3 returns 1.
;        -3 OR 2  returns 1.
;
; A binary operation.
; On entry HL points to first operand (X) and DE to second operand (Y).

or:
        ld      a, (de)         ; fetch exponent of second number
        and     a               ; test it.
        ret     z               ; return if zero.

        scf                     ; set carry flag
        jr      FP_0_1          ; back to FP-0/1 to overwrite the first operand
                                ; with the value 1.


; -----------------------------
; Handle number AND number (08)
; -----------------------------
; The Boolean AND operator.
;
; e.g.    -3 AND 2  returns -3.
;         -3 AND 0  returns 0.
;          0 and -2 returns 0.
;          0 and 0  returns 0.
;
; Compare with OR routine above.

no_and_no:
        ld      a, (de)         ; fetch exponent of second number.
        and     a               ; test it.
        ret     nz              ; return if not zero.

        jr      FP_0_1          ; back to FP-0/1 to overwrite the first operand
                                ; with zero for return value.

; -----------------------------
; Handle string AND number (10)
; -----------------------------
; e.g. "YOU WIN" AND SCORE>99 will return the string if condition is true
; or the null string if false.

str_and_no:
        ld      a, (de)         ; fetch exponent of second number.
        and     a               ; test it.
        ret     nz              ; return if number was not zero - the string
                                ; is the result.

; if the number was zero (false) then the null string must be returned by
; altering the length of the string on the calculator stack to zero.

        push    de              ; save pointer to the now obsolete number
                                ; (which will become the new STKEND)

        dec     de              ; point to the 5th byte of string descriptor.
        xor     a               ; clear the accumulator.
        ld      (de), a         ; place zero in high byte of length.
        dec     de              ; address low byte of length.
        ld      (de), a         ; place zero there - now the null string.

        pop     de              ; restore pointer - new STKEND.
        ret                     ; return.

; -------------------------------------
; Perform comparison ($09-$0E, $11-$16)
; -------------------------------------
; True binary operations.
;
; A single entry point is used to evaluate six numeric and six string
; comparisons. On entry, the calculator literal is in the B register and
; the two numeric values, or the two string parameters, are on the
; calculator stack.
; The individual bits of the literal are manipulated to group similar
; operations although the SUB 8 instruction does nothing useful and merely
; alters the string test bit.
; Numbers are compared by subtracting one from the other, strings are
; compared by comparing every character until a mismatch, or the end of one
; or both, is reached.
;
; Numeric Comparisons.
; --------------------
; The 'x>y' example is the easiest as it employs straight-thru logic.
; Number y is subtracted from x and the result tested for greater-0 yielding
; a final value 1 (true) or 0 (false).
; For 'x<y' the same logic is used but the two values are first swapped on the
; calculator stack.
; For 'x=y' NOT is applied to the subtraction result yielding true if the
; difference was zero and false with anything else.
; The first three numeric comparisons are just the opposite of the last three
; so the same processing steps are used and then a final NOT is applied.
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
; String comparisons are a little different in that the eql/neql carry flag
; from the 2nd RRCA is, as before, fed into the first of the end tests but
; along the way it gets modified by the comparison process. The result on the
; stack always starts off as zero and the carry fed in determines if NOT is
; applied to it. So the only time the greater-0 test is applied is if the
; stack holds zero which is not very efficient as the test will always yield
; zero. The most likely explanation is that there were once separate end tests
; for numbers and strings.

no_l_eql:
        ld      a, b            ; transfer literal to accumulator.
        sub     $08             ; subtract eight - which is not useful.

        bit     2, a            ; isolate '>', '<', '='.

        jr      nz, EX_OR_NOT   ; skip to EX-OR-NOT with these.

        dec     a               ; else make $00-$02, $08-$0A to match bits 0-2.

EX_OR_NOT:
        rrca                    ; the first RRCA sets carry for a swap.
        jr      nc, NU_OR_STR   ; forward to NU-OR-STR with other 8 cases

; for the other 4 cases the two values on the calculator stack are exchanged.

        push    af              ; save A and carry.
        push    hl              ; save HL - pointer to first operand.
                                ; (DE points to second operand).

        call    exchange        ; routine exchange swaps the two values.
                                ; (HL = second operand, DE = STKEND)

        pop     de              ; DE = first operand
        ex      de, hl          ; as we were.
        pop     af              ; restore A and carry.

; Note. it would be better if the 2nd RRCA preceded the string test.
; It would save two duplicate bytes and if we also got rid of that sub 8
; at the beginning we wouldn't have to alter which bit we test.

NU_OR_STR:
        bit     2, a            ; test if a string comparison.
        jr      nz, STRINGS     ; forward to STRINGS if so.

; continue with numeric comparisons.

        rrca                    ; 2nd RRCA causes eql/neql to set carry.
        push    af              ; save A and carry
        call    subtract        ; routine subtract leaves result on stack.
        jr      END_TESTS       ; forward to END-TESTS

; ---

STRINGS:
        rrca                    ; 2nd RRCA causes eql/neql to set carry.
        push    af              ; save A and carry.

        call    STK_FETCH       ; routine STK-FETCH gets 2nd string params
        push    de              ; save start2 *.
        push    bc              ; and the length.

        call    STK_FETCH       ; routine STK-FETCH gets 1st string
                                ; parameters - start in DE, length in BC.
        pop     hl              ; restore length of second to HL.

; A loop is now entered to compare, by subtraction, each corresponding character
; of the strings. For each successful match, the pointers are incremented and
; the lengths decreased and the branch taken back to here. If both string
; remainders become null at the same time, then an exact match exists.

BYTE_COMP:
        ld      a, h            ; test if the second string
        or      l               ; is the null string and hold flags.

        ex      (sp), hl        ; put length2 on stack, bring start2 to HL *.
        ld      a, b            ; hi byte of length1 to A

        jr      nz, SEC_PLUS    ; forward to SEC-PLUS if second not null.

        or      c               ; test length of first string.

SECND_LOW:
        pop     bc              ; pop the second length off stack.
        jr      z, BOTH_NULL    ; forward to BOTH-NULL if first string is also
                                ; of zero length.

; the true condition - first is longer than second (SECND-LESS)

        pop     af              ; restore carry (set if eql/neql)
        ccf                     ; complement carry flag.
                                ; Note. equality becomes false.
                                ; Inequality is true. By swapping or applying
                                ; a terminal 'not', all comparisons have been
                                ; manipulated so that this is success path.
        jr      STR_TEST        ; forward to leave via STR-TEST

; ---
; the branch was here with a match

BOTH_NULL:
        pop     af              ; restore carry - set for eql/neql
        jr      STR_TEST        ; forward to STR-TEST

; ---
; the branch was here when 2nd string not null and low byte of first is yet
; to be tested.


SEC_PLUS:
        or      c               ; test the length of first string.
        jr      z, FRST_LESS    ; forward to FRST-LESS if length is zero.

; both strings have at least one character left.

        ld      a, (de)         ; fetch character of first string.
        sub     (hl)            ; subtract with that of 2nd string.
        jr      c, FRST_LESS    ; forward to FRST-LESS if carry set

        jr      nz, SECND_LOW   ; back to SECND-LOW and then STR-TEST
                                ; if not exact match.

        dec     bc              ; decrease length of 1st string.
        inc     de              ; increment 1st string pointer.

        inc     hl              ; increment 2nd string pointer.
        ex      (sp), hl        ; swap with length on stack
        dec     hl              ; decrement 2nd string length
        jr      BYTE_COMP       ; back to BYTE-COMP

; ---
;   the false condition.

FRST_LESS:
        pop     bc              ; discard length
        pop     af              ; pop A
        and     a               ; clear the carry for false result.

; ---
;   exact match and x$>y$ rejoin here

STR_TEST:
        push    af              ; save A and carry

        rst     FP_CALC         ;; FP-CALC
        defb    $A0             ;;stk-zero      an initial false value.
        defb    $34             ;;end-calc

;   both numeric and string paths converge here.

END_TESTS:
        pop     af              ; pop carry  - will be set if eql/neql
        push    af              ; save it again.

        call    c, not          ; routine NOT sets true(1) if equal(0)
                                ; or, for strings, applies true result.
        call    greater_0       ; greater-0  ??????????


        pop     af              ; pop A
        rrca                    ; the third RRCA - test for '<=', '>=' or '<>'.
        call    nc, not         ; apply a terminal NOT if so.
        ret                     ; return.

; -----------------------------------
; THE 'STRING CONCATENATION' OPERATOR
; -----------------------------------
; (offset $17: 'strs_add')
;   This literal combines two strings into one e.g. LET A$ = B$ + C$
;   The two parameters of the two strings to be combined are on the stack.

strs_add:
        call    STK_FETCH       ; routine STK-FETCH fetches string parameters
                                ; and deletes calculator stack entry.
        push    de              ; save start address.
        push    bc              ; and length.

        call    STK_FETCH       ; routine STK-FETCH for first string
        pop     hl              ; re-fetch first length
        push    hl              ; and save again
        push    de              ; save start of second string
        push    bc              ; and its length.

        add     hl, bc          ; add the two lengths.
        ld      b, h            ; transfer to BC
        ld      c, l            ; and create
        rst     BC_SPACES       ; BC-SPACES in workspace.
                                ; DE points to start of space.

        call    STK_STO_DOLLAR  ; routine STK-STO-$ stores parameters
                                ; of new string updating STKEND.

        pop     bc              ; length of first
        pop     hl              ; address of start

        ld      a, b            ; test for
        or      c               ; zero length.
        jr      z, OTHER_STR    ; to OTHER-STR if null string

        ldir                    ; copy string to workspace.

OTHER_STR:
        pop     bc              ; now second length
        pop     hl              ; and start of string

        ld      a, b            ; test this one
        or      c               ; for zero length
        jr      z, STK_PNTRS    ; skip forward to STK-PNTRS if so as complete.

        ldir                    ; else copy the bytes.

; Continue into next routine which sets the calculator stack pointers.

; ----------------------------
; THE 'STACK POINTERS' ROUTINE
; ----------------------------
;   Register DE is set to STKEND and HL, the result pointer, is set to five
;   locations below this - the 'last value'.
;   This routine is used when it is inconvenient to save these values at the
;   time the calculator stack is manipulated due to other activity on the
;   machine stack.
;   This routine is also used to terminate the VAL routine for
;   the same reason and to initialize the calculator stack at the start of
;   the CALCULATE routine.

STK_PNTRS:
        ld      hl, (STKEND)    ; fetch STKEND value from system variable.
        ld      de, $FFFB       ; the value -5
        push    hl              ; push STKEND value.

        add     hl, de          ; subtract 5 from HL.

        pop     de              ; pop STKEND to DE.
        ret                     ; return.

; -------------------
; THE 'CHR$' FUNCTION
; -------------------
; (offset $2B: 'chr$')
;   This function returns a single character string that is a result of
;   converting a number in the range 0-255 to a string e.g. CHR$ 38 = "A".
;   Note. the ZX81 does not have an ASCII character set.

chr_dollar:
        call    FP_TO_A         ; routine FP-TO-A puts the number in A.

        jr      c, REPORT_Bd    ; forward to REPORT-Bd if overflow
        jr      nz, REPORT_Bd   ; forward to REPORT-Bd if negative

        push    af              ; save the argument.

        ld      bc, $0001       ; one space required.
        rst     BC_SPACES       ; BC-SPACES makes DE point to start

        pop     af              ; restore the number.

        ld      (de), a         ; and store in workspace

        call    STK_STO_DOLLAR  ; routine STK-STO-$ stacks descriptor.

        ex      de, hl          ; make HL point to result and DE to STKEND.
        ret                     ; return.

; ---

REPORT_Bd:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_B_INT_OVERFLOW
                                ; Error Report: Integer out of range

; ------------------
; THE 'VAL' FUNCTION
; ------------------
; (offset $1A: 'val')
;   VAL treats the characters in a string as a numeric expression.
;       e.g. VAL "2.3" = 2.3, VAL "2+4" = 6, VAL ("2" + "4") = 24.

val:
        ld      hl, (CH_ADD)    ; fetch value of system variable CH_ADD

        push    hl              ; and save on the machine stack.

        call    STK_FETCH       ; routine STK-FETCH fetches the string operand
                                ; from calculator stack.

        push    de              ; save the address of the start of the string.
        inc     bc              ; increment the length for a carriage return.

        rst     BC_SPACES       ; BC-SPACES creates the space in workspace.
        pop     hl              ; restore start of string to HL.
        ld      (CH_ADD), de    ; load CH_ADD with start DE in workspace.

        push    de              ; save the start in workspace
        ldir                    ; copy string from program or variables or
                                ; workspace to the workspace area.
        ex      de, hl          ; end of string + 1 to HL
        dec     hl              ; decrement HL to point to end of new area.
        ld      (hl), $76       ; insert a carriage return at end.
                                ; ZX81 has a non-ASCII character set
        res     7, (iy+FLAGS-IY0)
                                ; update FLAGS  - signal checking syntax.
        call    CLASS_6         ; routine CLASS-06 - SCANNING evaluates string
                                ; expression and checks for integer result.

        call    CHECK_2         ; routine CHECK-2 checks for carriage return.


        pop     hl              ; restore start of string in workspace.

        ld      (CH_ADD), hl    ; set CH_ADD to the start of the string again.
        set     7, (iy+FLAGS-IY0)
                                ; update FLAGS  - signal running program.
        call    SCANNING        ; routine SCANNING evaluates the string
                                ; in full leaving result on calculator stack.

        pop     hl              ; restore saved character address in program.
        ld      (CH_ADD), hl    ; and reset the system variable CH_ADD.

        jr      STK_PNTRS       ; back to exit via STK-PNTRS.
                                ; resetting the calculator stack pointers
                                ; HL and DE from STKEND as it wasn't possible
                                ; to preserve them during this routine.

; -------------------
; THE 'STR$' FUNCTION
; -------------------
; (offset $2A: 'str$')
;   This function returns a string representation of a numeric argument.
;   The method used is to trick the PRINT-FP routine into thinking it
;   is writing to a collapsed display file when in fact it is writing to
;   string workspace.
;   If there is already a newline at the intended print position and the
;   column count has not been reduced to zero then the print routine
;   assumes that there is only 1K of RAM and the screen memory, like the rest
;   of dynamic memory, expands as necessary using calls to the ONE-SPACE
;   routine. The screen is character-mapped not bit-mapped.

str_dollar:
        ld      bc, $0001       ; create an initial byte in workspace
        rst     BC_SPACES       ; using BC-SPACES restart.

        ld      (hl), $76       ; place a carriage return there.

        ld      hl, (S_POSN)    ; fetch value of S_POSN column/line
        push    hl              ; and preserve on stack.

        ld      l, $FF          ; make column value high to create a
                                ; contrived buffer of length 254.
        ld      (S_POSN), hl    ; and store in system variable S_POSN.

        ld      hl, (DF_CC)     ; fetch value of DF_CC
        push    hl              ; and preserve on stack also.

        ld      (DF_CC), de     ; now set DF_CC which normally addresses
                                ; somewhere in the display file to the start
                                ; of workspace.
        push    de              ; save the start of new string.

        call    PRINT_FP        ; routine PRINT-FP.

        pop     de              ; retrieve start of string.

        ld      hl, (DF_CC)     ; fetch end of string from DF_CC.
        and     a               ; prepare for true subtraction.
        sbc     hl, de          ; subtract to give length.

        ld      b, h            ; and transfer to the BC
        ld      c, l            ; register.

        pop     hl              ; restore original
        ld      (DF_CC), hl     ; DF_CC value

        pop     hl              ; restore original
        ld      (S_POSN), hl    ; S_POSN values.

        call    STK_STO_DOLLAR  ; routine STK-STO-$ stores the string
                                ; descriptor on the calculator stack.

        ex      de, hl          ; HL = last value, DE = STKEND.
        ret                     ; return.


; -------------------
; THE 'CODE' FUNCTION
; -------------------
; (offset $19: 'code')
;   Returns the code of a character or first character of a string
;   e.g. CODE "AARDVARK" = 38  (not 65 as the ZX81 does not have an ASCII
;   character set).


code:
        call    STK_FETCH       ; routine STK-FETCH to fetch and delete the
                                ; string parameters.
                                ; DE points to the start, BC holds the length.
        ld      a, b            ; test length
        or      c               ; of the string.
        jr      z, STK_CODE     ; skip to STK-CODE with zero if the null string.

        ld      a, (de)         ; else fetch the first character.

STK_CODE:
        jp      STACK_A         ; jump back to STACK-A (with memory check)

; --------------------
; THE 'LEN' SUBROUTINE
; --------------------
; (offset $1b: 'len')
;   Returns the length of a string.
;   In Sinclair BASIC strings can be more than twenty thousand characters long
;   so a sixteen-bit register is required to store the length

len:
        call    STK_FETCH       ; routine STK-FETCH to fetch and delete the
                                ; string parameters from the calculator stack.
                                ; register BC now holds the length of string.

        jp      STACK_BC        ; jump back to STACK-BC to save result on the
                                ; calculator stack (with memory check).

; -------------------------------------
; THE 'DECREASE THE COUNTER' SUBROUTINE
; -------------------------------------
; (offset $31: 'dec-jr-nz')
;   The calculator has an instruction that decrements a single-byte
;   pseudo-register and makes consequential relative jumps just like
;   the Z80's DJNZ instruction.

dec_jr_nz:
        exx                     ; switch in set that addresses code

        push    hl              ; save pointer to offset byte
        ld      hl, BREG        ; address BREG in system variables
        dec     (hl)            ; decrement it
        pop     hl              ; restore pointer

        jr      nz, JUMP_2      ; to JUMP-2 if not zero

        inc     hl              ; step past the jump length.
        exx                     ; switch in the main set.
        ret                     ; return.

;   Note. as a general rule the calculator avoids using the IY register
;   otherwise the cumbersome 4 instructions in the middle could be replaced by
;   dec (iy+$xx) - using three instruction bytes instead of six.


; ---------------------
; THE 'JUMP' SUBROUTINE
; ---------------------
; Offset $2F; 'jump'
;   This enables the calculator to perform relative jumps just like
;   the Z80 chip's JR instruction.
;   This is one of the few routines to be polished for the ZX Spectrum.
;   See, without looking at the ZX Spectrum ROM, if you can get rid of the
;   relative jump.

jump:
        exx                     ;switch in pointer set

JUMP_2:
        ld      e, (hl)         ; the jump byte 0-127 forward, 128-255 back.
        xor     a               ; clear accumulator.
        bit     7, e            ; test if negative jump
        jr      z, JUMP_3       ; skip, if positive, to JUMP-3.

        cpl                     ; else change to $FF.

JUMP_3:
        ld      d, a            ; transfer to high byte.
        add     hl, de          ; advance calculator pointer forward or back.

        exx                     ; switch out pointer set.
        ret                     ; return.

; -----------------------------
; THE 'JUMP ON TRUE' SUBROUTINE
; -----------------------------
; Offset $00; 'jump-true'
;   This enables the calculator to perform conditional relative jumps
;   dependent on whether the last test gave a true result
;   On the ZX81, the exponent will be zero for zero or else $81 for one.

jump_true:
        ld      a, (de)         ; collect exponent byte

        and     a               ; is result 0 or 1 ?
        jr      nz, jump        ; back to jump if true (1).

        exx                     ; else switch in the pointer set.
        inc     hl              ; step past the jump length.
        exx                     ; switch in the main set.
        ret                     ; return.


; ------------------------
; THE 'MODULUS' SUBROUTINE
; ------------------------
; ( Offset $2E: 'n-mod-m' )
; ( i1, i2 -- i3, i4 )
;   The subroutine calculate N mod M where M is the positive integer, the
;   'last value' on the calculator stack and N is the integer beneath.
;   The subroutine returns the integer quotient as the last value and the
;   remainder as the value beneath.
;   e.g.    17 MOD 3 = 5 remainder 2
;   It is invoked during the calculation of a random number and also by
;   the PRINT-FP routine.

n_mod_m:
        rst     FP_CALC         ;; FP-CALC          17, 3.
        defb    $C0             ;;st-mem-0          17, 3.
        defb    $02             ;;delete            17.
        defb    $2D             ;;duplicate         17, 17.
        defb    $E0             ;;get-mem-0         17, 17, 3.
        defb    $05             ;;division          17, 17/3.
        defb    $24             ;;int               17, 5.
        defb    $E0             ;;get-mem-0         17, 5, 3.
        defb    $01             ;;exchange          17, 3, 5.
        defb    $C0             ;;st-mem-0          17, 3, 5.
        defb    $04             ;;multiply          17, 15.
        defb    $03             ;;subtract          2.
        defb    $E0             ;;get-mem-0         2, 5.
        defb    $34             ;;end-calc          2, 5.

        ret                     ; return.


; ----------------------
; THE 'INTEGER' FUNCTION
; ----------------------
; (offset $24: 'int')
;   This function returns the integer of x, which is just the same as truncate
;   for positive numbers. The truncate literal truncates negative numbers
;   upwards so that -3.4 gives -3 whereas the BASIC INT function has to
;   truncate negative numbers down so that INT -3.4 is 4.
; It is best to work through using, say, plus and minus 3.4 as examples.

int:
        rst     FP_CALC         ;; FP-CALC              x.    (= 3.4 or -3.4).
        defb    $2D             ;;duplicate             x, x.
        defb    $32             ;;less-0                x, (1/0)
        defb    $00             ;;jump-true             x, (1/0)
        defb    X_NEG - ASMPC   ;;to L1C46, X-NEG

        defb    $36             ;;truncate              trunc 3.4 = 3.
        defb    $34             ;;end-calc              3.

        ret                     ; return with + int x on stack.


X_NEG:
        defb    $2D             ;;duplicate             -3.4, -3.4.
        defb    $36             ;;truncate              -3.4, -3.
        defb    $C0             ;;st-mem-0              -3.4, -3.
        defb    $03             ;;subtract              -.4
        defb    $E0             ;;get-mem-0             -.4, -3.
        defb    $01             ;;exchange              -3, -.4.
        defb    $2C             ;;not                   -3, (0).
        defb    $00             ;;jump-true             -3.
        defb    EXIT - ASMPC    ;;to L1C59, EXIT        -3.

        defb    $A1             ;;stk-one               -3, 1.
        defb    $03             ;;subtract              -4.

EXIT:
        defb    $34             ;;end-calc              -4.

        ret                     ; return.


; --------------------------
; THE 'EXPONENTIAL' FUNCTION
; --------------------------
; (Offset $23: 'exp')
;   The exponential function returns the exponential of the argument, or the
;   value of 'e' (2.7182818...) raised to the power of the argument.
;   PRINT EXP 1 gives 2.7182818
;
;   EXP is the opposite of the LN function (see below) and is equivalent to
;   the 'antiln' function found on pocket calculators or the 'Inverse ln'
;   function found on the Windows scientific calculator.
;   So PRINT EXP LN 5.3 will give 5.3 as will PRINT LN EXP 5.3 or indeed
;   any number e.g. PRINT EXP LN PI.
;
;   The applications of the exponential function are in areas where exponential
;   growth is experienced, calculus, population growth and compound interest.
;
;   Error 6 if the argument is above 88.

exp:
        rst     FP_CALC         ;; FP-CALC
        defb    $30             ;;stk-data          1/LN 2
        defb    $F1             ;;Exponent: $81, Bytes: 4
        defb    $38, $AA, $3B, $29
                                ;;
        defb    $04             ;;multiply
        defb    $2D             ;;duplicate
        defb    $24             ;;int
        defb    $C3             ;;st-mem-3
        defb    $03             ;;subtract
        defb    $2D             ;;duplicate
        defb    $0F             ;;addition
        defb    $A1             ;;stk-one
        defb    $03             ;;subtract
        defb    $88             ;;series-08
        defb    $13             ;;Exponent: $63, Bytes: 1
        defb    $36             ;;(+00,+00,+00)
        defb    $58             ;;Exponent: $68, Bytes: 2
        defb    $65, $66        ;;(+00,+00)
        defb    $9D             ;;Exponent: $6D, Bytes: 3
        defb    $78, $65, $40   ;;(+00)
        defb    $A2             ;;Exponent: $72, Bytes: 3
        defb    $60, $32, $C9   ;;(+00)
        defb    $E7             ;;Exponent: $77, Bytes: 4
        defb    $21, $F7, $af, $24
                                ;;
        defb    $EB             ;;Exponent: $7B, Bytes: 4
        defb    $2F, $B0, $B0, $14
                                ;;
        defb    $EE             ;;Exponent: $7E, Bytes: 4
        defb    $7E, $BB, $94, $58
                                ;;
        defb    $F1             ;;Exponent: $81, Bytes: 4
        defb    $3A, $7E, $F8, $CF
                                ;;
        defb    $E3             ;;get-mem-3
        defb    $34             ;;end-calc

        call    FP_TO_A         ; routine FP-TO-A
        jr      nz, N_NEGTV     ; to N-NEGTV

        jr      c, REPORT_6b    ; to REPORT-6b

        add     a, (hl)         ;
        jr      nc, RESULT_OK   ; to RESULT-OK


REPORT_6b:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_6_OVERFLOW  ; Error Report: Number too big

N_NEGTV:
        jr      c, RSLT_ZERO    ; to RSLT-ZERO

        sub     (hl)            ;
        jr      nc, RSLT_ZERO   ; to RSLT-ZERO

        neg                     ; Negate

RESULT_OK:
        ld      (hl), a         ;
        ret                     ; return.


RSLT_ZERO:
        rst     FP_CALC         ;; FP-CALC
        defb    $02             ;;delete
        defb    $A0             ;;stk-zero
        defb    $34             ;;end-calc

        ret                     ; return.


; --------------------------------
; THE 'NATURAL LOGARITHM' FUNCTION
; --------------------------------
; (offset $22: 'ln')
;   Like the ZX81 itself, 'natural' logarithms came from Scotland.
;   They were devised in 1614 by well-traveled Scotsman John Napier who noted
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
;   It is only recently with the introduction of pocket calculators and
;   computers like the ZX81 that natural logarithms are once more at the fore,
;   although some computers retain logarithms to the base ten.
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

ln:
        rst     FP_CALC         ;; FP-CALC      x.
        defb    $2D             ;;duplicate     x,x.
        defb    $33             ;;greater-0     x,(0/1).
        defb    $00             ;;jump-true     x.
        defb    VALID - ASMPC   ;;to L1CB1, VALID

        defb    $34             ;;end-calc      x.


REPORT_Ab:
        rst     ERROR_1         ; ERROR-1
        defb    ERR_A_INVALID_ARG
                                ; Error Report: Invalid argument

VALID:
        defb    $A0             ;;stk-zero              Note. not
        defb    $02             ;;delete                necessary.
        defb    $34             ;;end-calc      x.

;   Register HL addresses the 'last value' x.

        ld      a, (hl)         ; Fetch exponent to A.

        ld      (hl), $80       ; Insert 'plus zero' as exponent.
        call    STACK_A         ; routine STACK-A stacks true binary exponent.

        rst     FP_CALC         ;; FP-CALC
        defb    $30             ;;stk-data
        defb    $38             ;;Exponent: $88, Bytes: 1
        defb    $00             ;;(+00,+00,+00)
        defb    $03             ;;subtract
        defb    $01             ;;exchange
        defb    $2D             ;;duplicate
        defb    $30             ;;stk-data
        defb    $F0             ;;Exponent: $80, Bytes: 4
        defb    $4C, $CC, $CC, $CD
                                ;;
        defb    $03             ;;subtract
        defb    $33             ;;greater-0
        defb    $00             ;;jump-true
        defb    GRE_8 - ASMPC   ;;to L1CD2, GRE.8

        defb    $01             ;;exchange
        defb    $A1             ;;stk-one
        defb    $03             ;;subtract
        defb    $01             ;;exchange
        defb    $34             ;;end-calc

        inc     (hl)            ;

        rst     FP_CALC         ;; FP-CALC

GRE_8:
        defb    $01             ;;exchange
        defb    $30             ;;stk-data          LN 2
        defb    $F0             ;;Exponent: $80, Bytes: 4
        defb    $31, $72, $17, $F8
                                ;;
        defb    $04             ;;multiply
        defb    $01             ;;exchange
        defb    $A2             ;;stk-half
        defb    $03             ;;subtract
        defb    $A2             ;;stk-half
        defb    $03             ;;subtract
        defb    $2D             ;;duplicate
        defb    $30             ;;stk-data
        defb    $32             ;;Exponent: $82, Bytes: 1
        defb    $20             ;;(+00,+00,+00)
        defb    $04             ;;multiply
        defb    $A2             ;;stk-half
        defb    $03             ;;subtract
        defb    $8C             ;;series-0C
        defb    $11             ;;Exponent: $61, Bytes: 1
        defb    $AC             ;;(+00,+00,+00)
        defb    $14             ;;Exponent: $64, Bytes: 1
        defb    $09             ;;(+00,+00,+00)
        defb    $56             ;;Exponent: $66, Bytes: 2
        defb    $DA, $A5        ;;(+00,+00)
        defb    $59             ;;Exponent: $69, Bytes: 2
        defb    $30, $C5        ;;(+00,+00)
        defb    $5C             ;;Exponent: $6C, Bytes: 2
        defb    $90, $AA        ;;(+00,+00)
        defb    $9E             ;;Exponent: $6E, Bytes: 3
        defb    $70, $6F, $61   ;;(+00)
        defb    $A1             ;;Exponent: $71, Bytes: 3
        defb    $CB, $DA, $96   ;;(+00)
        defb    $A4             ;;Exponent: $74, Bytes: 3
        defb    $31, $9F, $B4   ;;(+00)
        defb    $E7             ;;Exponent: $77, Bytes: 4
        defb    $A0, $FE, $5C, $FC
                                ;;
        defb    $EA             ;;Exponent: $7A, Bytes: 4
        defb    $1B, $43, $CA, $36
                                ;;
        defb    $ED             ;;Exponent: $7D, Bytes: 4
        defb    $A7, $9C, $7E, $5E
                                ;;
        defb    $F0             ;;Exponent: $80, Bytes: 4
        defb    $6E, $23, $80, $93
                                ;;
        defb    $04             ;;multiply
        defb    $0F             ;;addition
        defb    $34             ;;end-calc

        ret                     ; return.

; -----------------------------
; THE 'TRIGONOMETRIC' FUNCTIONS
; -----------------------------
;   Trigonometry is rocket science. It is also used by carpenters and pyramid
;   builders.
;   Some uses can be quite abstract but the principles can be seen in simple
;   right-angled triangles. Triangles have some special properties -
;
;   1) The sum of the three angles is always PI radians (180 degrees).
;      Very helpful if you know two angles and wish to find the third.
;   2) In any right-angled triangle the sum of the squares of the two shorter
;      sides is equal to the square of the longest side opposite the right-angle.
;      Very useful if you know the length of two sides and wish to know the
;      length of the third side.
;   3) Functions sine, cosine and tangent enable one to calculate the length
;      of an unknown side when the length of one other side and an angle is
;      known.
;   4) Functions arcsin, arccosine and arctan enable one to calculate an unknown
;      angle when the length of two of the sides is known.

; --------------------------------
; THE 'REDUCE ARGUMENT' SUBROUTINE
; --------------------------------
; (offset $35: 'get-argt')
;
;   This routine performs two functions on the angle, in radians, that forms
;   the argument to the sine and cosine functions.
;   First it ensures that the angle 'wraps round'. That if a ship turns through
;   an angle of, say, 3*PI radians (540 degrees) then the net effect is to turn
;   through an angle of PI radians (180 degrees).
;   Secondly it converts the angle in radians to a fraction of a right angle,
;   depending within which quadrant the angle lies, with the periodicity
;   resembling that of the desired sine value.
;   The result lies in the range -1 to +1.
;
;                       90 deg.
;
;                       (pi/2)
;                II       +1        I
;                         |
;          sin+      |\   |   /|    sin+
;          cos-      | \  |  / |    cos+
;          tan-      |  \ | /  |    tan+
;                    |   \|/)  |
;   180 deg. (pi) 0 -|----+----|-- 0  (0)   0 degrees
;                    |   /|\   |
;          sin-      |  / | \  |    sin-
;          cos-      | /  |  \ |    cos+
;          tan+      |/   |   \|    tan-
;                         |
;                III      -1       IV
;                       (3pi/2)
;
;                       270 deg.


get_argt:
        rst     FP_CALC         ;; FP-CALC         X.
        defb    $30             ;;stk-data
        defb    $EE             ;;Exponent: $7E,
                                ;;Bytes: 4
        defb    $22, $F9, $83, $6E
                                ;;                 X, 1/(2*PI)
        defb    $04             ;;multiply         X/(2*PI) = fraction

        defb    $2D             ;;duplicate
        defb    $A2             ;;stk-half
        defb    $0F             ;;addition
        defb    $24             ;;int

        defb    $03             ;;subtract         now range -.5 to .5

        defb    $2D             ;;duplicate
        defb    $0F             ;;addition         now range -1 to 1.
        defb    $2D             ;;duplicate
        defb    $0F             ;;addition         now range -2 to 2.

;   quadrant I (0 to +1) and quadrant IV (-1 to 0) are now correct.
;   quadrant II ranges +1 to +2.
;   quadrant III ranges -2 to -1.

        defb    $2D             ;;duplicate        Y, Y.
        defb    $27             ;;abs              Y, abs(Y).    range 1 to 2
        defb    $A1             ;;stk-one          Y, abs(Y), 1.
        defb    $03             ;;subtract         Y, abs(Y)-1.  range 0 to 1
        defb    $2D             ;;duplicate        Y, Z, Z.
        defb    $33             ;;greater-0        Y, Z, (1/0).

        defb    $C0             ;;st-mem-0         store as possible sign
                                ;;                 for cosine function.

        defb    $00             ;;jump-true
        defb    ZPLUS - ASMPC   ;;to L1D35, ZPLUS  with quadrants II and III

;   else the angle lies in quadrant I or IV and value Y is already correct.

        defb    $02             ;;delete          Y    delete test value.
        defb    $34             ;;end-calc        Y.

        ret                     ; return.         with Q1 and Q4 >>>

;   The branch was here with quadrants II (0 to 1) and III (1 to 0).
;   Y will hold -2 to -1 if this is quadrant III.

ZPLUS:
        defb    $A1             ;;stk-one         Y, Z, 1
        defb    $03             ;;subtract        Y, Z-1.       Q3 = 0 to -1
        defb    $01             ;;exchange        Z-1, Y.
        defb    $32             ;;less-0          Z-1, (1/0).
        defb    $00             ;;jump-true       Z-1.
        defb    YNEG - ASMPC    ;;to L1D3C, YNEG
                                ;;if angle in quadrant III

;   else angle is within quadrant II (-1 to 0)

        defb    $18             ;;negate          range +1 to 0


YNEG:
        defb    $34             ;;end-calc        quadrants II and III correct.

        ret                     ; return.


; ---------------------
; THE 'COSINE' FUNCTION
; ---------------------
; (offset $1D: 'cos')
;   Cosines are calculated as the sine of the opposite angle rectifying the
;   sign depending on the quadrant rules.
;
;
;             /|
;          h /y|
;           /  |o
;          /x  |
;         /----|
;           a
;
;   The cosine of angle x is the adjacent side (a) divided by the hypotenuse 1.
;   However if we examine angle y then a/h is the sine of that angle.
;   Since angle x plus angle y equals a right-angle, we can find angle y by
;   subtracting angle x from pi/2.
;   However it's just as easy to reduce the argument first and subtract the
;   reduced argument from the value 1 (a reduced right-angle).
;   It's even easier to subtract 1 from the angle and rectify the sign.
;   In fact, after reducing the argument, the absolute value of the argument
;   is used and rectified using the test result stored in mem-0 by 'get-argt'
;   for that purpose.

cos:
        rst     FP_CALC         ;; FP-CALC              angle in radians.
        defb    $35             ;;get-argt              X       reduce -1 to +1

        defb    $27             ;;abs                   ABS X   0 to 1
        defb    $A1             ;;stk-one               ABS X, 1.
        defb    $03             ;;subtract              now opposite angle
                                ;;                      though negative sign.
        defb    $E0             ;;get-mem-0             fetch sign indicator.
        defb    $00             ;;jump-true
        defb    C_ENT - ASMPC   ;;fwd to L1D4B, C-ENT
                                ;;forward to common code if in QII or QIII


        defb    $18             ;;negate                else make positive.
        defb    $2F             ;;jump
        defb    C_ENT - ASMPC   ;;fwd to L1D4B, C-ENT
                                ;;with quadrants QI and QIV

; -------------------
; THE 'SINE' FUNCTION
; -------------------
; (offset $1C: 'sin')
;   This is a fundamental transcendental function from which others such as cos
;   and tan are directly, or indirectly, derived.
;   It uses the series generator to produce Chebyshev polynomials.
;
;
;             /|
;          1 / |
;           /  |x
;          /a  |
;         /----|
;           y
;
;   The 'get-argt' function is designed to modify the angle and its sign
;   in line with the desired sine value and afterwards it can launch straight
;   into common code.

sin:
        rst     FP_CALC         ;; FP-CALC      angle in radians
        defb    $35             ;;get-argt      reduce - sign now correct.

C_ENT:
        defb    $2D             ;;duplicate
        defb    $2D             ;;duplicate
        defb    $04             ;;multiply
        defb    $2D             ;;duplicate
        defb    $0F             ;;addition
        defb    $A1             ;;stk-one
        defb    $03             ;;subtract

        defb    $86             ;;series-06
        defb    $14             ;;Exponent: $64, Bytes: 1
        defb    $E6             ;;(+00,+00,+00)
        defb    $5C             ;;Exponent: $6C, Bytes: 2
        defb    $1F, $0B        ;;(+00,+00)
        defb    $A3             ;;Exponent: $73, Bytes: 3
        defb    $8F, $38, $EE   ;;(+00)
        defb    $E9             ;;Exponent: $79, Bytes: 4
        defb    $15, $63, $BB, $23
                                ;;
        defb    $EE             ;;Exponent: $7E, Bytes: 4
        defb    $92, $0D, $CD, $ED
                                ;;
        defb    $F1             ;;Exponent: $81, Bytes: 4
        defb    $23, $5D, $1B, $EA
                                ;;

        defb    $04             ;;multiply
        defb    $34             ;;end-calc

        ret                     ; return.


; ----------------------
; THE 'TANGENT' FUNCTION
; ----------------------
; (offset $1E: 'tan')
;
;   Evaluates tangent x as    sin(x) / cos(x).
;
;
;             /|
;          h / |
;           /  |o
;          /x  |
;         /----|
;           a
;
;   The tangent of angle x is the ratio of the length of the opposite side
;   divided by the length of the adjacent side. As the opposite length can
;   be calculates using sin(x) and the adjacent length using cos(x) then
;   the tangent can be defined in terms of the previous two functions.

;   Error 6 if the argument, in radians, is too close to one like pi/2
;   which has an infinite tangent. e.g. PRINT TAN (PI/2)  evaluates as 1/0.
;   Similarly PRINT TAN (3*PI/2), TAN (5*PI/2) etc.

tan:
        rst     FP_CALC         ;; FP-CALC          x.
        defb    $2D             ;;duplicate         x, x.
        defb    $1C             ;;sin               x, sin x.
        defb    $01             ;;exchange          sin x, x.
        defb    $1D             ;;cos               sin x, cos x.
        defb    $05             ;;division          sin x/cos x (= tan x).
        defb    $34             ;;end-calc          tan x.

        ret                     ; return.

; ---------------------
; THE 'ARCTAN' FUNCTION
; ---------------------
; (Offset $21: 'atn')
;   The inverse tangent function with the result in radians.
;   This is a fundamental transcendental function from which others such as
;   asn and acs are directly, or indirectly, derived.
;   It uses the series generator to produce Chebyshev polynomials.

atn:
        ld      a, (hl)         ; fetch exponent
        cp      $81             ; compare to that for 'one'
        jr      c, SMALL        ; forward, if less, to SMALL

        rst     FP_CALC         ;; FP-CALC      X.
        defb    $A1             ;;stk-one
        defb    $18             ;;negate
        defb    $01             ;;exchange
        defb    $05             ;;division
        defb    $2D             ;;duplicate
        defb    $32             ;;less-0
        defb    $A3             ;;stk-pi/2
        defb    $01             ;;exchange
        defb    $00             ;;jump-true
        defb    CASES - ASMPC   ;;to L1D8B, CASES

        defb    $18             ;;negate
        defb    $2F             ;;jump
        defb    CASES - ASMPC   ;;to L1D8B, CASES

; ---

SMALL:
        rst     FP_CALC         ;; FP-CALC
        defb    $A0             ;;stk-zero

CASES:
        defb    $01             ;;exchange
        defb    $2D             ;;duplicate
        defb    $2D             ;;duplicate
        defb    $04             ;;multiply
        defb    $2D             ;;duplicate
        defb    $0F             ;;addition
        defb    $A1             ;;stk-one
        defb    $03             ;;subtract

        defb    $8C             ;;series-0C
        defb    $10             ;;Exponent: $60, Bytes: 1
        defb    $B2             ;;(+00,+00,+00)
        defb    $13             ;;Exponent: $63, Bytes: 1
        defb    $0E             ;;(+00,+00,+00)
        defb    $55             ;;Exponent: $65, Bytes: 2
        defb    $E4, $8D        ;;(+00,+00)
        defb    $58             ;;Exponent: $68, Bytes: 2
        defb    $39, $bc        ;;(+00,+00)
        defb    $5B             ;;Exponent: $6B, Bytes: 2
        defb    $98, $FD        ;;(+00,+00)
        defb    $9E             ;;Exponent: $6E, Bytes: 3
        defb    $00, $36, $75   ;;(+00)
        defb    $A0             ;;Exponent: $70, Bytes: 3
        defb    $DB, $E8, $B4   ;;(+00)
        defb    $63             ;;Exponent: $73, Bytes: 2
        defb    $42, $C4        ;;(+00,+00)
        defb    $E6             ;;Exponent: $76, Bytes: 4
        defb    $B5, $09, $36, $BE
                                ;;
        defb    $E9             ;;Exponent: $79, Bytes: 4
        defb    $36, $73, $1B, $5D
                                ;;
        defb    $EC             ;;Exponent: $7C, Bytes: 4
        defb    $D8, $de, $63, $BE
                                ;;
        defb    $F0             ;;Exponent: $80, Bytes: 4
        defb    $61, $A1, $B3, $0C
                                ;;

        defb    $04             ;;multiply
        defb    $0F             ;;addition
        defb    $34             ;;end-calc

        ret                     ; return.


; ---------------------
; THE 'ARCSIN' FUNCTION
; ---------------------
; (Offset $1F: 'asn')
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

asn:
        rst     FP_CALC         ;; FP-CALC      x.
        defb    $2D             ;;duplicate     x, x.
        defb    $2D             ;;duplicate     x, x, x.
        defb    $04             ;;multiply      x, x*x.
        defb    $A1             ;;stk-one       x, x*x, 1.
        defb    $03             ;;subtract      x, x*x-1.
        defb    $18             ;;negate        x, 1-x*x.
        defb    $25             ;;sqr           x, sqr(1-x*x) = y.
        defb    $A1             ;;stk-one       x, y, 1.
        defb    $0F             ;;addition      x, y+1.
        defb    $05             ;;division      x/y+1.
        defb    $21             ;;atn           a/2     (half the angle)
        defb    $2D             ;;duplicate     a/2, a/2.
        defb    $0F             ;;addition      a.
        defb    $34             ;;end-calc      a.

        ret                     ; return.


; ------------------------
; THE 'ARCCOS' FUNCTION
; ------------------------
; (Offset $20: 'acs')
;   The inverse cosine function with the result in radians.
;   Error A unless the argument is between -1 and +1.
;   Result in range 0 to pi.
;   Derived from asn above which is in turn derived from the preceding atn.
;   It could have been derived directly from atn using acs(x) = atn(sqr(1-x*x)/x).
;   However, as sine and cosine are horizontal translations of each other,
;   uses acs(x) = pi/2 - asn(x)

;   e.g. the arccosine of a known x value will give the required angle b in
;   radians.
;   We know, from above, how to calculate the angle a using asn(x).
;   Since the three angles of any triangle add up to 180 degrees, or pi radians,
;   and the largest angle in this case is a right-angle (pi/2 radians), then
;   we can calculate angle b as pi/2 (both angles) minus asn(x) (angle a).
;
;
;            /|
;         1 /b|
;          /  |x
;         /a  |
;        /----|
;          y

acs:
        rst     FP_CALC         ;; FP-CALC      x.
        defb    $1F             ;;asn           asn(x).
        defb    $A3             ;;stk-pi/2      asn(x), pi/2.
        defb    $03             ;;subtract      asn(x) - pi/2.
        defb    $18             ;;negate        pi/2 - asn(x) = acs(x).
        defb    $34             ;;end-calc      acs(x)

        ret                     ; return.


; ------------------------------
; THE OLD 'SQUARE ROOT' FUNCTION
; ------------------------------
; (Offset $25: 'sqr')
;   Error A if argument is negative.
;   This routine is remarkable for its brevity - 7 bytes.
;   The ZX81 code was originally 9K and various techniques had to be
;   used to shoe-horn it into an 8K Rom chip.


sqr:
        rst     FP_CALC         ;; FP-CALC              x.
        defb    $2D             ;;duplicate             x, x.
        defb    $2C             ;;not                   x, 1/0
        defb    $00             ;;jump-true             x, (1/0).
        defb    LAST - ASMPC    ;;to L1DFD, LAST        exit if argument zero
                                ;;                      with zero result.

;   else continue to calculate as x ** .5

        defb    $A2             ;;stk-half              x, .5.
        defb    $34             ;;end-calc              x, .5.


; drop into the exponentiation operation

; ------------------------
; THE 'TO POWER' OPERATION
; ------------------------
; (Offset $06: 'to-power')
;   The 'Exponential' operation.
;   This raises the first number X to the power of the second number Y.
;   e.g. PRINT 2 ** 3 gives the result 8
;   As with the ZX80,
;   0 ** 0 = 1
;   0 ** +n = 0
;   0 ** -n = arithmetic overflow.

to_power:
        rst     FP_CALC         ;; FP-CALC              X,Y.
        defb    $01             ;;exchange              Y,X.
        defb    $2D             ;;duplicate             Y,X,X.
        defb    $2C             ;;not                   Y,X,(1/0).
        defb    $00             ;;jump-true
        defb    XISO - ASMPC    ;;forward to L1DEE, XISO if X is zero.

;   else X is non-zero. function 'ln' will catch a negative value of X.

        defb    $22             ;;ln                    Y, LN X.

;   Multiply the power by the logarithm of the argument.

        defb    $04             ;;multiply              Y * LN X
        defb    $34             ;;end-calc

        jp      exp             ; jump back to EXP routine             ->>
                                ; to find the 'antiln'

; ---

;   These routines form the three simple results when the number is zero.
;   begin by deleting the known zero to leave Y the power factor.

XISO:
        defb    $02             ;;delete                Y.
        defb    $2D             ;;duplicate             Y, Y.
        defb    $2C             ;;not                   Y, (1/0).
        defb    $00             ;;jump-true
        defb    ONE - ASMPC     ;;forward to L1DFB, ONE if Y is zero.

;   the power factor is not zero. If negative then an error exists.

        defb    $A0             ;;stk-zero              Y, 0.
        defb    $01             ;;exchange              0, Y.
        defb    $33             ;;greater-0             0, (1/0).
        defb    $00             ;;jump-true             0
        defb    LAST - ASMPC    ;;to L1DFD, LAST        if Y was any positive
                                ;;                      number.

;   else force division by zero thereby raising an Arithmetic overflow error.
;   There are some one and two-byte alternatives but perhaps the most formal
;   might have been to use end-calc; rst 08; defb 05.

        defb    $A1             ;;stk-one               0, 1.
        defb    $01             ;;exchange              1, 0.
        defb    $05             ;;division              1/0    >> error

; ---

ONE:
        defb    $02             ;;delete                .
        defb    $A1             ;;stk-one               1.

LAST:
        defb    $34             ;;end-calc              last value 1 or 0.

        ret                     ; return.


; ---------------------
; THE 'SPARE LOCATIONS'
; ---------------------

SPARE:
        defs    $1E00 - ASMPC, $FF

; That's all folks.


; ------------------------
; THE 'ZX81 CHARACTER SET'
; ------------------------

;; char-set - begins with space character.

; $00 - Character: ' '          CHR$(0)

char_set:
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000

; $01 - Character: mosaic       CHR$(1)

        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000


; $02 - Character: mosaic       CHR$(2)

        defb    %00001111
        defb    %00001111
        defb    %00001111
        defb    %00001111
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000


; $03 - Character: mosaic       CHR$(3)

        defb    %11111111
        defb    %11111111
        defb    %11111111
        defb    %11111111
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000

; $04 - Character: mosaic       CHR$(4)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000

; $05 - Character: mosaic       CHR$(5)

        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000

; $06 - Character: mosaic       CHR$(6)

        defb    %00001111
        defb    %00001111
        defb    %00001111
        defb    %00001111
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000

; $07 - Character: mosaic       CHR$(7)

        defb    %11111111
        defb    %11111111
        defb    %11111111
        defb    %11111111
        defb    %11110000
        defb    %11110000
        defb    %11110000
        defb    %11110000

; $08 - Character: mosaic       CHR$(8)

        defb    %10101010
        defb    %01010101
        defb    %10101010
        defb    %01010101
        defb    %10101010
        defb    %01010101
        defb    %10101010
        defb    %01010101

; $09 - Character: mosaic       CHR$(9)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %10101010
        defb    %01010101
        defb    %10101010
        defb    %01010101

; $0A - Character: mosaic       CHR$(10)

        defb    %10101010
        defb    %01010101
        defb    %10101010
        defb    %01010101
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000

; $0B - Character: '"'          CHR$(11)

        defb    %00000000
        defb    %00100100
        defb    %00100100
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000

; $0B - Character: ukp          CHR$(12)

        defb    %00000000
        defb    %00011100
        defb    %00100010
        defb    %01111000
        defb    %00100000
        defb    %00100000
        defb    %01111110
        defb    %00000000

; $0B - Character: '$'          CHR$(13)

        defb    %00000000
        defb    %00001000
        defb    %00111110
        defb    %00101000
        defb    %00111110
        defb    %00001010
        defb    %00111110
        defb    %00001000

; $0B - Character: ':'          CHR$(14)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00010000
        defb    %00000000
        defb    %00000000
        defb    %00010000
        defb    %00000000

; $0B - Character: '?'          CHR$(15)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %00000100
        defb    %00001000
        defb    %00000000
        defb    %00001000
        defb    %00000000

; $10 - Character: '('          CHR$(16)

        defb    %00000000
        defb    %00000100
        defb    %00001000
        defb    %00001000
        defb    %00001000
        defb    %00001000
        defb    %00000100
        defb    %00000000

; $11 - Character: ')'          CHR$(17)

        defb    %00000000
        defb    %00100000
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00100000
        defb    %00000000

; $12 - Character: '>'          CHR$(18)

        defb    %00000000
        defb    %00000000
        defb    %00010000
        defb    %00001000
        defb    %00000100
        defb    %00001000
        defb    %00010000
        defb    %00000000

; $13 - Character: '<'          CHR$(19)

        defb    %00000000
        defb    %00000000
        defb    %00000100
        defb    %00001000
        defb    %00010000
        defb    %00001000
        defb    %00000100
        defb    %00000000

; $14 - Character: '='          CHR$(20)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00111110
        defb    %00000000
        defb    %00111110
        defb    %00000000
        defb    %00000000

; $15 - Character: '+'          CHR$(21)

        defb    %00000000
        defb    %00000000
        defb    %00001000
        defb    %00001000
        defb    %00111110
        defb    %00001000
        defb    %00001000
        defb    %00000000

; $16 - Character: '-'          CHR$(22)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00111110
        defb    %00000000
        defb    %00000000
        defb    %00000000

; $17 - Character: '*'          CHR$(23)

        defb    %00000000
        defb    %00000000
        defb    %00010100
        defb    %00001000
        defb    %00111110
        defb    %00001000
        defb    %00010100
        defb    %00000000

; $18 - Character: '/'          CHR$(24)

        defb    %00000000
        defb    %00000000
        defb    %00000010
        defb    %00000100
        defb    %00001000
        defb    %00010000
        defb    %00100000
        defb    %00000000

; $19 - Character: ';'          CHR$(25)

        defb    %00000000
        defb    %00000000
        defb    %00010000
        defb    %00000000
        defb    %00000000
        defb    %00010000
        defb    %00010000
        defb    %00100000

; $1A - Character: ','          CHR$(26)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00001000
        defb    %00001000
        defb    %00010000

; $1B - Character: '.'          CHR$(27)

        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00000000
        defb    %00011000
        defb    %00011000
        defb    %00000000

; $1C - Character: '0'          CHR$(28)

        defb    %00000000
        defb    %00111100
        defb    %01000110
        defb    %01001010
        defb    %01010010
        defb    %01100010
        defb    %00111100
        defb    %00000000

; $1D - Character: '1'          CHR$(29)

        defb    %00000000
        defb    %00011000
        defb    %00101000
        defb    %00001000
        defb    %00001000
        defb    %00001000
        defb    %00111110
        defb    %00000000

; $1E - Character: '2'          CHR$(30)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %00000010
        defb    %00111100
        defb    %01000000
        defb    %01111110
        defb    %00000000

; $1F - Character: '3'          CHR$(31)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %00001100
        defb    %00000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $20 - Character: '4'          CHR$(32)

        defb    %00000000
        defb    %00001000
        defb    %00011000
        defb    %00101000
        defb    %01001000
        defb    %01111110
        defb    %00001000
        defb    %00000000

; $21 - Character: '5'          CHR$(33)

        defb    %00000000
        defb    %01111110
        defb    %01000000
        defb    %01111100
        defb    %00000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $22 - Character: '6'          CHR$(34)

        defb    %00000000
        defb    %00111100
        defb    %01000000
        defb    %01111100
        defb    %01000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $23 - Character: '7'          CHR$(35)

        defb    %00000000
        defb    %01111110
        defb    %00000010
        defb    %00000100
        defb    %00001000
        defb    %00010000
        defb    %00010000
        defb    %00000000

; $24 - Character: '8'          CHR$(36)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %00111100
        defb    %01000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $25 - Character: '9'          CHR$(37)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000010
        defb    %00111110
        defb    %00000010
        defb    %00111100
        defb    %00000000

; $26 - Character: 'A'          CHR$(38)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000010
        defb    %01111110
        defb    %01000010
        defb    %01000010
        defb    %00000000

; $27 - Character: 'B'          CHR$(39)

        defb    %00000000
        defb    %01111100
        defb    %01000010
        defb    %01111100
        defb    %01000010
        defb    %01000010
        defb    %01111100
        defb    %00000000

; $28 - Character: 'C'          CHR$(40)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000000
        defb    %01000000
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $29 - Character: 'D'          CHR$(41)

        defb    %00000000
        defb    %01111000
        defb    %01000100
        defb    %01000010
        defb    %01000010
        defb    %01000100
        defb    %01111000
        defb    %00000000

; $2A - Character: 'E'          CHR$(42)

        defb    %00000000
        defb    %01111110
        defb    %01000000
        defb    %01111100
        defb    %01000000
        defb    %01000000
        defb    %01111110
        defb    %00000000

; $2B - Character: 'F'          CHR$(43)

        defb    %00000000
        defb    %01111110
        defb    %01000000
        defb    %01111100
        defb    %01000000
        defb    %01000000
        defb    %01000000
        defb    %00000000

; $2C - Character: 'G'          CHR$(44)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000000
        defb    %01001110
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $2D - Character: 'H'          CHR$(45)

        defb    %00000000
        defb    %01000010
        defb    %01000010
        defb    %01111110
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %00000000

; $2E - Character: 'I'          CHR$(46)

        defb    %00000000
        defb    %00111110
        defb    %00001000
        defb    %00001000
        defb    %00001000
        defb    %00001000
        defb    %00111110
        defb    %00000000

; $2F - Character: 'J'          CHR$(47)

        defb    %00000000
        defb    %00000010
        defb    %00000010
        defb    %00000010
        defb    %01000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $30 - Character: 'K'          CHR$(48)

        defb    %00000000
        defb    %01000100
        defb    %01001000
        defb    %01110000
        defb    %01001000
        defb    %01000100
        defb    %01000010
        defb    %00000000

; $31 - Character: 'L'          CHR$(49)

        defb    %00000000
        defb    %01000000
        defb    %01000000
        defb    %01000000
        defb    %01000000
        defb    %01000000
        defb    %01111110
        defb    %00000000

; $32 - Character: 'M'          CHR$(50)

        defb    %00000000
        defb    %01000010
        defb    %01100110
        defb    %01011010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %00000000

; $33 - Character: 'N'          CHR$(51)

        defb    %00000000
        defb    %01000010
        defb    %01100010
        defb    %01010010
        defb    %01001010
        defb    %01000110
        defb    %01000010
        defb    %00000000

; $34 - Character: 'O'          CHR$(52)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $35 - Character: 'P'          CHR$(53)

        defb    %00000000
        defb    %01111100
        defb    %01000010
        defb    %01000010
        defb    %01111100
        defb    %01000000
        defb    %01000000
        defb    %00000000

; $36 - Character: 'Q'          CHR$(54)

        defb    %00000000
        defb    %00111100
        defb    %01000010
        defb    %01000010
        defb    %01010010
        defb    %01001010
        defb    %00111100
        defb    %00000000

; $37 - Character: 'R'          CHR$(55)

        defb    %00000000
        defb    %01111100
        defb    %01000010
        defb    %01000010
        defb    %01111100
        defb    %01000100
        defb    %01000010
        defb    %00000000

; $38 - Character: 'S'          CHR$(56)

        defb    %00000000
        defb    %00111100
        defb    %01000000
        defb    %00111100
        defb    %00000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $39 - Character: 'T'          CHR$(57)

        defb    %00000000
        defb    %11111110
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00000000

; $3A - Character: 'U'          CHR$(58)

        defb    %00000000
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %00111100
        defb    %00000000

; $3B - Character: 'V'          CHR$(59)

        defb    %00000000
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %00100100
        defb    %00011000
        defb    %00000000

; $3C - Character: 'W'          CHR$(60)

        defb    %00000000
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01000010
        defb    %01011010
        defb    %00100100
        defb    %00000000

; $3D - Character: 'X'          CHR$(61)

        defb    %00000000
        defb    %01000010
        defb    %00100100
        defb    %00011000
        defb    %00011000
        defb    %00100100
        defb    %01000010
        defb    %00000000

; $3E - Character: 'Y'          CHR$(62)

        defb    %00000000
        defb    %10000010
        defb    %01000100
        defb    %00101000
        defb    %00010000
        defb    %00010000
        defb    %00010000
        defb    %00000000

; $3F - Character: 'Z'          CHR$(63)

        defb    %00000000
        defb    %01111110
        defb    %00000100
        defb    %00001000
        defb    %00010000
        defb    %00100000
        defb    %01111110
        defb    %00000000


; *****************
; Map file by value
; *****************

; ERR_0_OK                        = $FFFFFFFFFFFFFFFF
; ERR_1_NEXT_WO_FOR               = $0000
; START                           = $0000
; ERR_2_UNDEF_VAR                 = $0001
; ERR_3_SUBSCRIPT_RANGE           = $0002
; ERR_4_NO_ROOM                   = $0003
; ERR_4_SCREEN_FULL               = $0004
; ERR_6_OVERFLOW                  = $0005
; ERR_7_RET_WO_GOSUB              = $0006
; ERR_8_EOF                       = $0007
; ERROR_1                         = $0008
; ERR_9_STOP                      = $0008
; ERR_A_INVALID_ARG               = $0009
; ERR_B_INT_OVERFLOW              = $000A
; ERR_C_NONSENSE                  = $000B
; ERR_D_BREAK                     = $000C
; ERR_F_PROG_NAME                 = $000E
; PRINT_A                         = $0010
; GET_CHAR                        = $0018
; TEST_SP                         = $001C
; NEXT_CHAR                       = $0020
; FP_CALC                         = $0028
; end_calc                        = $002B
; BC_SPACES                       = $0030
; INTERRUPT                       = $0038
; WAIT_INT                        = $0041
; SCAN_LINE                       = $0045
; INC_CH_ADD                      = $0049
; TEMP_PTR1                       = $004C
; TEMP_PTR2                       = $004D
; ERROR_2                         = $0056
; ERROR_3                         = $0058
; NMI                             = $0066
; NMI_RET                         = $006D
; NMI_CONT                        = $006F
; K_UNSHIFT                       = $007E
; K_SHIFT                         = $00A5
; K_FUNCT                         = $00CC
; K_GRAPH                         = $00F3
; TOKENS_TAB                      = $0111
; LOAD_SAVE                       = $01FC
; SLOW_FAST                       = $0207
; LOOP_11                         = $0216
; NO_SLOW                         = $0226
; DISPLAY_1                       = $0229
; DISPLAY_P                       = $022D
; ANOTHER                         = $0237
; OVER_NC                         = $0239
; DISPLAY_2                       = $023E
; NO_KEY                          = $0264
; LOOP_B                          = $026A
; R_IX_1                          = $0281
; DISPLAY_5_RET                   = $028B
; R_IX_2                          = $028F
; DISPLAY_3                       = $0292
; DISPLAY_4                       = $02A9
; DISPLAY_5                       = $02B5
; KEYBOARD                        = $02BB
; EACH_LINE                       = $02C5
; SET_FAST                        = $02E7
; REPORT_F                        = $02F4
; SAVE                            = $02F6
; HEADER                          = $02FF
; DELAY_1                         = $0304
; OUT_NAME                        = $030B
; OUT_PROG                        = $0316
; OUT_BYTE                        = $031E
; EACH_BIT                        = $0320
; PULSES                          = $0329
; DELAY_2                         = $032D
; BREAK_2                         = $0332
; DELAY_3                         = $0336
; DELAY_4                         = $033B
; LOAD                            = $0340
; NEXT_PROG                       = $0347
; IN_BYTE                         = $034C
; NEXT_BIT                        = $034E
; BREAK_3                         = $0350
; RESTART                         = $0361
; IN_NAME                         = $0366
; MATCHING                        = $0371
; IN_PROG                         = $037B
; GET_BIT                         = $0385
; TRAILER                         = $0388
; COUNTER                         = $038A
; BIT_DONE                        = $039C
; BREAK_4                         = $03A2
; REPORT_D                        = $03A6
; NAME                            = $03A8
; NEW                             = $03C3
; RAM_CHECK                       = $03CB
; RAM_FILL                        = $03CF
; RAM_READ                        = $03D5
; SET_TOP                         = $03E2
; INITIAL                         = $03E5
; LINE                            = $0408
; NL_ONLY                         = $0413
; UPPER                           = $0419
; ADDR_TOP                        = $042D
; LIST_TOP                        = $0433
; DOWN_KEY                        = $0454
; INC_LINE                        = $0457
; KEY_INPUT                       = $0464
; EDIT_INP                        = $046F
; LOWER                           = $0472
; EACH_CHAR                       = $0475
; END_LINE                        = $0482
; EDIT_LINE                       = $0487
; EDIT_ROOM                       = $048A
; FREE_LINE                       = $04B1
; DISPLAY_6                       = $04C1
; SLOW_DISP                       = $04CF
; K_DECODE                        = $04DF
; FUNC_BASE                       = $04F2
; FETCH_1                         = $04F7
; TABLE_ADD                       = $0505
; FETCH_2                         = $0508
; FETCH_3                         = $0515
; TEST_CURS                       = $0516
; ENTER                           = $051B
; BACK_NEXT                       = $0523
; ADD_CHAR                        = $0526
; KL_KEY                          = $052B
; KEY_SORT                        = $052D
; CURSOR                          = $0537
; K_MODE                          = $0540
; TEST_CHAR                       = $0544
; L_MODE                          = $0556
; CLEAR_ONE                       = $055C
; ED_KEYS                         = $0562
; LEFT_KEY                        = $0576
; RIGHT_KEY                       = $057F
; GET_CODE                        = $0588
; ENDED_1                         = $0589
; RUBOUT                          = $058B
; LEFT_EDGE                       = $0593
; ENDED_2                         = $059D
; UP_KEY                          = $059F
; FUNCTION                        = $05AF
; ZERO_DE                         = $05B7
; LINE_NO                         = $05BB
; EDIT_KEY                        = $05C4
; NL_KEY                          = $060C
; STK_UPPER                       = $0626
; NOW_SCAN                        = $0629
; NL_INP                          = $064E
; TEST_NULL                       = $0661
; NL_NULL                         = $0664
; NEXT_LINE                       = $066C
; STOP_LINE                       = $06AE
; CONTINUE                        = $06CA
; REPORT                          = $06D1
; NL_LINE                         = $06E0
; COPY_OVER                       = $0705
; LLIST                           = $072C
; LIST                            = $0730
; LIST_PROG                       = $073E
; UNTIL_END                       = $0740
; OUT_LINE                        = $0745
; TEST_END                        = $0755
; COPY_LINE                       = $0766
; MORE_LINE                       = $076D
; TEST_NUM                        = $077C
; NOT_TOKEN                       = $079A
; OUT_CURS                        = $079D
; FLAGS_2                         = $07AA
; NUMBER                          = $07B4
; DECODE                          = $07BD
; KEY_LINE                        = $07C7
; LEAD_SP                         = $07DC
; OUT_DIGIT                       = $07E1
; DIGIT_INC                       = $07E2
; OUT_CODE                        = $07EB
; OUT_CH                          = $07EE
; PRINT_CH                        = $07F1
; PRINT_SP                        = $07F5
; LPRINT_A                        = $0802
; PRINT_EXX                       = $0805
; ENTER_CH                        = $0808
; TEST_NL                         = $0812
; TEST_LOW                        = $082C
; REPORT_5                        = $0835
; EXPAND_1                        = $083A
; WRITE_CH                        = $083E
; WRITE_NL                        = $0847
; LPRINT_CH                       = $0851
; COPY                            = $0869
; COPY_BUFF                       = $0871
; COPY_MULT_D                     = $0876
; COPY_LOOP                       = $087A
; COPY_TIME                       = $087D
; COPY_BRK                        = $0880
; REPORT_D2                       = $0888
; COPY_CONT                       = $088A
; COPY_NEXT                       = $089C
; COPY_BITS                       = $08B5
; COPY_WAIT                       = $08BA
; COPY_NL                         = $08C7
; COPY_END                        = $08DE
; CLEAR_PRB                       = $08E2
; PRB_BYTES                       = $08E9
; PRINT_AT                        = $08F5
; TEST_VAL                        = $08FA
; WRONG_VAL                       = $0905
; SET_FIELD                       = $090B
; LOC_ADDR                        = $0918
; LOOK_BACK                       = $0927
; EXPAND_2                        = $0940
; TOKENS                          = $094B
; ALL_CHARS                       = $0959
; TRAIL_SP                        = $096D
; TOKEN_ADD                       = $0975
; TEST_HIGH                       = $097F
; WORDS                           = $0985
; COMP_FLAG                       = $0992
; FOUND                           = $0993
; ONE_SPACE                       = $099B
; MAKE_ROOM                       = $099E
; POINTERS                        = $09AD
; NEXT_PTR                        = $09B4
; PTR_DONE                        = $09C8
; LINE_ADDR                       = $09D8
; NEXT_TEST                       = $09DE
; CP_LINES                        = $09EA
; NEXT_ONE                        = $09F2
; NEXT_PLUS_FIVE                  = $0A01
; NEXT_LETT                       = $0A08
; LINES                           = $0A0F
; NEXT_O_4                        = $0A10
; NEXT_ADD                        = $0A15
; DIFFER                          = $0A17
; LINE_ENDS                       = $0A1F
; CLS                             = $0A2A
; B_LINES                         = $0A2C
; CLEAR_LOC                       = $0A42
; COLLAPSED                       = $0A52
; RECLAIM_1                       = $0A5D
; RECLAIM_2                       = $0A60
; E_LINE_NO                       = $0A73
; NO_NUMBER                       = $0A91
; OUT_NUM                         = $0A98
; OUT_NO                          = $0AA5
; THOUSAND                        = $0AAD
; UNITS                           = $0ABF
; UNSTACK_Z                       = $0AC5
; LPRINT                          = $0ACB
; PRINT                           = $0ACF
; PRINT_1                         = $0AD5
; NOT_AT                          = $0AFA
; TAB_TEST                        = $0B1E
; NOT_TAB                         = $0B31
; PRINT_ON                        = $0B37
; SPACING                         = $0B44
; SYNTAX_ON                       = $0B4E
; PRINT_STK                       = $0B55
; PR_STR_1                        = $0B64
; PR_STR_2                        = $0B66
; PR_STR_3                        = $0B67
; PR_STR_4                        = $0B6B
; PRINT_END                       = $0B84
; FIELD                           = $0B8B
; CENTRE                          = $0BA4
; RIGHT                           = $0BAB
; PLOT_UNPLOT                     = $0BAF
; COLUMNS                         = $0BC5
; FIND_ADDR                       = $0BCA
; SQ_SAVED                        = $0BD9
; TABLE_PTR                       = $0BDA
; PLOT                            = $0BE9
; UNPLOT                          = $0BEB
; PLOT_END                        = $0BF1
; STK_TO_BC                       = $0BF5
; STK_TO_A                        = $0C02
; SCROLL                          = $0C0E
; offset_t                        = $0C29
; P_LET                           = $0C48
; P_GOTO                          = $0C4B
; P_IF                            = $0C4F
; P_GOSUB                         = $0C54
; P_STOP                          = $0C58
; P_RETURN                        = $0C5B
; P_FOR                           = $0C5E
; P_NEXT                          = $0C66
; P_PRINT                         = $0C6A
; P_INPUT                         = $0C6D
; P_DIM                           = $0C71
; P_REM                           = $0C74
; P_NEW                           = $0C77
; P_RUN                           = $0C7A
; P_LIST                          = $0C7D
; P_POKE                          = $0C80
; P_RAND                          = $0C86
; P_LOAD                          = $0C89
; P_SAVE                          = $0C8C
; P_CONT                          = $0C8F
; P_CLEAR                         = $0C92
; P_CLS                           = $0C95
; P_PLOT                          = $0C98
; P_UNPLOT                        = $0C9E
; P_SCROLL                        = $0CA4
; P_PAUSE                         = $0CA7
; P_SLOW                          = $0CAB
; P_FAST                          = $0CAE
; P_COPY                          = $0CB1
; P_LPRINT                        = $0CB4
; P_LLIST                         = $0CB7
; LINE_SCAN                       = $0CBA
; LINE_RUN                        = $0CC1
; STOP                            = $0CDC
; LINE_NULL                       = $0CDE
; SCAN_LOOP                       = $0CF4
; GET_PARAM                       = $0CF7
; SEPARATOR                       = $0D10
; class_tbl                       = $0D16
; CHECK_END                       = $0D1D
; CHECK_2                         = $0D22
; REPORT_C2                       = $0D26
; CLASS_3                         = $0D28
; CLASS_0                         = $0D2D
; CLASS_5                         = $0D2E
; CLASS_END                       = $0D3A
; CLASS_1                         = $0D3C
; CLASS_4_2                       = $0D3F
; REPORT_2                        = $0D4B
; SET_STK                         = $0D4D
; SET_STRLN                       = $0D63
; REM                             = $0D6A
; CLASS_2                         = $0D6B
; INPUT_REP                       = $0D6F
; CLASS_4                         = $0D85
; CLASS_6                         = $0D92
; REPORT_C                        = $0D9A
; NO_TO_STK                       = $0D9C
; SYNTAX_Z                        = $0DA6
; IF                              = $0DAB
; IF_END                          = $0DB6
; FOR                             = $0DB9
; F_USE_ONE                       = $0DC6
; F_REORDER                       = $0DCC
; F_LMT_STP                       = $0DEA
; NXTLIN_NO                       = $0E0E
; FOR_END                         = $0E2A
; NEXT                            = $0E2E
; REPORT_1                        = $0E58
; NEXT_LOOP                       = $0E5A
; LMT_V_VAL                       = $0E62
; IMPOSS                          = $0E69
; RAND                            = $0E6C
; SET_SEED                        = $0E77
; CONT                            = $0E7C
; GOTO                            = $0E81
; GOTO_2                          = $0E86
; POKE                            = $0E92
; POKE_SAVE                       = $0E9B
; FIND_INT                        = $0EA7
; REPORT_B                        = $0EAD
; RUN                             = $0EAF
; GOSUB                           = $0EB5
; TEST_ROOM                       = $0EC5
; REPORT_4                        = $0ED3
; RETURN                          = $0ED8
; REPORT_7                        = $0EE5
; INPUT                           = $0EE9
; PROMPT                          = $0F05
; ENTER_CUR                       = $0F14
; REPORT_8                        = $0F21
; FAST                            = $0F23
; SLOW                            = $0F2B
; PAUSE                           = $0F32
; BREAK_1                         = $0F46
; DEBOUNCE                        = $0F4B
; SCANNING                        = $0F55
; S_LOOP_1                        = $0F59
; S_JPI_END                       = $0F8A
; S_TEST_PI                       = $0F8C
; S_PI_END                        = $0F99
; S_TST_INK                       = $0F9D
; S_ALPHANUM                      = $0FB2
; S_QUOTE                         = $0FD6
; S_Q_AGAIN                       = $0FE0
; S_QUOTE_S                       = $0FE3
; S_STRING                        = $0FED
; S_JP_CONT3                      = $0FF8
; S_Q_NL                          = $0FFB
; S_RPT_C                         = $0FFF
; S_FUNCTION                      = $1002
; S_NO_TO__DOLLAR                 = $101A
; S_PUSH_PO                       = $1020
; S_LTR_DGT                       = $1025
; S_DECIMAL                       = $1047
; S_STK_DEC                       = $106F
; S_NUMERIC                       = $1083
; S_CONT_2                        = $1087
; S_CONT_3                        = $1088
; S_OPERTR                        = $1098
; SUBMLTDIV                       = $10A7
; GET_PRIO                        = $10B5
; S_LOOP                          = $10BC
; S_SYNTEST                       = $10D5
; S_RPORT_C                       = $10DB
; S_RUNTEST                       = $10DE
; S_LOOPEND                       = $10EA
; S_TIGHTER                       = $10ED
; S_NOT_AND                       = $1102
; S_NEXT                          = $110A
; tbl_pri                         = $110F
; LOOK_VARS                       = $111C
; V_CHAR                          = $1139
; V_STR_VAR                       = $1143
; V_RUN_OR_SYN                    = $1148
; V_RUN                           = $1156
; V_EACH                          = $1159
; V_MATCHES                       = $116B
; V_SPACES                        = $116C
; V_GET_PTR                       = $117F
; V_NEXT                          = $1180
; V_80_BYTE                       = $1188
; V_SYNTAX                        = $118A
; V_FOUND_1                       = $1194
; V_FOUND_2                       = $1195
; V_PASS                          = $1199
; V_END                           = $11A1
; STK_VAR                         = $11A7
; SV_SIMPLE_DOLLAR                = $11B2
; SV_ARRAYS                       = $11BF
; SV_PTR                          = $11D1
; SV_COMMA                        = $11D4
; SV_CLOSE                        = $11E9
; SV_CH_ADD                       = $11F1
; SV_COUNT                        = $11F8
; SV_LOOP                         = $11FB
; SV_MULT                         = $120C
; SV_RPT_C                        = $1223
; REPORT_3                        = $1231
; SV_NUMBER                       = $1233
; SV_ELEM_DOLLAR                  = $123D
; SV_SLICE                        = $1256
; SV_DIM                          = $1259
; SV_SLICE_QUESTION               = $125A
; SLICING                         = $1263
; SL_RPT_C                        = $128B
; SL_SECOND                       = $1292
; SL_DEFINE                       = $12A5
; SL_OVER                         = $12B9
; SL_STORE                        = $12BE
; STK_ST_0                        = $12C2
; STK_STO_DOLLAR                  = $12C3
; INT_EXP1                        = $12DD
; INT_EXP2                        = $12DE
; I_CARRY                         = $12F9
; I_RESTORE                       = $12FC
; GET_DE_FROM_DE_PLUS_1           = $12FF
; GET_HL_MULT_DE                  = $1305
; HL_LOOP                         = $1311
; HL_END                          = $131A
; HL_AGAIN                        = $131D
; LET                             = $1321
; L_EACH_CH                       = $132D
; L_NO_SP                         = $132E
; L_CHAR                          = $134B
; L_SINGLE                        = $1359
; L_NUMERIC                       = $1361
; L_EXISTS                        = $136E
; L_DELETE_DOLLAR                 = $137A
; L_LENGTH                        = $13A3
; L_IN_WS                         = $13AB
; L_ENTER                         = $13AE
; COND_MV                         = $13AF
; L_ADD_DOLLAR                    = $13B7
; L_NEW_DOLLAR                    = $13C8
; L_STRING                        = $13CE
; L_FIRST                         = $13E7
; STK_FETCH                       = $13F8
; DIM                             = $1409
; D_RPORT_C                       = $140C
; D_RUN                           = $141C
; D_LETTER                        = $1426
; D_SIZE                          = $1434
; D_NO_LOOP                       = $1435
; DIM_SIZES                       = $147F
; RESERVE                         = $1488
; CLEAR                           = $149A
; X_TEMP                          = $14A3
; SET_STK_B                       = $14A6
; SET_STK_E                       = $14A9
; CURSOR_IN                       = $14AD
; SET_MIN                         = $14BC
; REC_V80                         = $14C7
; ALPHA                           = $14CE
; ALPHANUM                        = $14D2
; ALPHA_2                         = $14D4
; DEC_TO_FP                       = $14D9
; NXT_DGT_1                       = $14E5
; E_FORMAT                        = $14F5
; SIGN_DONE                       = $1508
; ST_E_PART                       = $1509
; E_POSTVE                        = $1511
; STK_DIGIT                       = $1514
; STACK_A                         = $151D
; STACK_BC                        = $1520
; STK_BC_2                        = $1536
; INT_TO_FP                       = $1548
; NXT_DGT_2                       = $154D
; e_to_fp                         = $155A
; E_LOOP                          = $1560
; E_LOW                           = $157A
; E_CHUNK                         = $157D
; E_DIVSN                         = $1583
; E_SWAP                          = $1584
; E_END                           = $1587
; FP_TO_BC                        = $158A
; FPBC_NZRO                       = $1595
; BIG_INT                         = $15AF
; FPBC_NORM                       = $15B5
; EXP_ZERO                        = $15BC
; FPBC_END                        = $15C6
; FP_TO_A                         = $15CD
; FP_A_END                        = $15D9
; PRINT_FP                        = $15DB
; PF_NEGTVE                       = $15EA
; PF_POSTVE                       = $15F0
; PF_LOOP                         = $1615
; PF_NULL                         = $162C
; PF_RND_LP                       = $1639
; PF_ZERO_6                       = $164B
; PF_POS                          = $165B
; GET_FIRST                       = $165F
; PF_NIB_LP                       = $167B
; PF_E_FMT                        = $1682
; PF_E_POS                        = $1698
; PF_E_SIGN                       = $169A
; PF_E_TENS                       = $169E
; PF_E_LOW                        = $16AD
; PF_ZEROS                        = $16B2
; PF_ZRO_LP                       = $16BA
; PF_ZERO_1                       = $16BF
; PF_DC_OUT                       = $16C2
; PF_FRAC_LP                      = $16C8
; PF_NIBBLE                       = $16D0
; PREP_ADD                        = $16D8
; NEG_BYTE                        = $16EC
; FETCH_TWO                       = $16F7
; SHIFT_FP                        = $171A
; ONE_SHIFT                       = $1722
; ADDEND_0                        = $1736
; ZEROS_4_OR_5                    = $1738
; ADD_BACK                        = $1741
; ALL_ADDED                       = $174A
; subtract                        = $174C
; addition                        = $1755
; SHIFT_LEN                       = $1769
; TEST_NEG                        = $1790
; ADD_REP_6                       = $17B3
; END_COMPL                       = $17B7
; GO_NC_MLT                       = $17B9
; PREP_M_OR_D                     = $17BC
; multiply                        = $17C6
; MLT_LOOP                        = $17E7
; NO_ADD                          = $17EE
; STRT_MLT                        = $17F8
; MAKE_EXPT                       = $180E
; DIVN_EXPT                       = $1810
; OFLW1_CLR                       = $1819
; OFLW2_CLR                       = $1824
; TEST_NORM                       = $1828
; NEAR_ZERO                       = $182C
; ZERO_RSLT                       = $1830
; SKIP_ZERO                       = $1831
; NORMALIZE                       = $183F
; SHIFT_ONE                       = $1841
; NORML_NOW                       = $1859
; OFLOW_CLR                       = $1868
; REPORT_6                        = $1880
; division                        = $1882
; DIV_LOOP                        = $18A2
; div_34th                        = $18AB
; DIV_START                       = $18B2
; SUBN_ONLY                       = $18C2
; NO_RSTORE                       = $18C9
; COUNT_ONE                       = $18CA
; truncate                        = $18E4
; T_GR_ZERO                       = $18EF
; NIL_BYTES                       = $18F4
; BYTE_ZERO                       = $1900
; BITS_ZERO                       = $1905
; LESS_MASK                       = $190C
; IX_END                          = $1912
; TAB_CNST                        = $1915
; tbl_addrs                       = $1923
; CALCULATE                       = $199D
; GEN_ENT_1                       = $19A0
; GEN_ENT_2                       = $19A4
; RE_ENTRY                        = $19A7
; SCAN_ENT                        = $19AE
; FIRST_3D                        = $19C2
; DOUBLE_A                        = $19CE
; ENT_TABLE                       = $19D0
; delete                          = $19E3
; fp_calc_2                       = $19E4
; TEST_5_SP                       = $19EB
; duplicate                       = $19F6
; stk_data                        = $19FC
; STK_CONST                       = $19FE
; FORM_EXP                        = $1A14
; STK_ZEROS                       = $1A27
; SKIP_CONS                       = $1A2D
; SKIP_NEXT                       = $1A2E
; LOC_MEM                         = $1A3C
; get_mem_x                       = $1A45
; stk_con_x                       = $1A51
; sto_mem_x                       = $1A63
; exchange                        = $1A72
; SWAP_BYTE                       = $1A74
; seriesg_x                       = $1A7F
; G_LOOP                          = $1A89
; neg                             = $1AA0
; abs                             = $1AAA
; sgn                             = $1AAF
; peek                            = $1ABE
; IN_PK_STK                       = $1AC2
; usr_no                          = $1AC5
; greater_0                       = $1ACE
; not                             = $1AD5
; less_0                          = $1ADB
; SIGN_TO_C                       = $1ADC
; FP_0_1                          = $1AE0
; PF_loop                         = $1AE3
; or                              = $1AED
; no_and_no                       = $1AF3
; str_and_no                      = $1AF8
; no_l_eql                        = $1B03
; EX_OR_NOT                       = $1B0B
; NU_OR_STR                       = $1B16
; STRINGS                         = $1B21
; BYTE_COMP                       = $1B2C
; SECND_LOW                       = $1B33
; BOTH_NULL                       = $1B3A
; SEC_PLUS                        = $1B3D
; FRST_LESS                       = $1B4D
; STR_TEST                        = $1B50
; END_TESTS                       = $1B54
; strs_add                        = $1B62
; OTHER_STR                       = $1B7D
; STK_PNTRS                       = $1B85
; chr_dollar                      = $1B8F
; REPORT_Bd                       = $1BA2
; val                             = $1BA4
; str_dollar                      = $1BD5
; code                            = $1C06
; STK_CODE                        = $1C0E
; len                             = $1C11
; dec_jr_nz                       = $1C17
; jump                            = $1C23
; JUMP_2                          = $1C24
; JUMP_3                          = $1C2B
; jump_true                       = $1C2F
; n_mod_m                         = $1C37
; int                             = $1C46
; X_NEG                           = $1C4E
; EXIT                            = $1C59
; exp                             = $1C5B
; REPORT_6b                       = $1C99
; N_NEGTV                         = $1C9B
; RESULT_OK                       = $1CA2
; RSLT_ZERO                       = $1CA4
; ln                              = $1CA9
; REPORT_Ab                       = $1CAF
; VALID                           = $1CB1
; GRE_8                           = $1CD2
; get_argt                        = $1D18
; ZPLUS                           = $1D35
; YNEG                            = $1D3C
; cos                             = $1D3E
; sin                             = $1D49
; C_ENT                           = $1D4B
; tan                             = $1D6E
; atn                             = $1D76
; SMALL                           = $1D89
; CASES                           = $1D8B
; asn                             = $1DC4
; acs                             = $1DD4
; sqr                             = $1DDB
; to_power                        = $1DE2
; XISO                            = $1DEE
; ONE                             = $1DFB
; LAST                            = $1DFD
; SPARE                           = $1DFF
; char_set                        = $1E00
; ERR_NR                          = $4000
; IY0                             = $4000
; FLAGS                           = $4001
; ERR_SP                          = $4002
; RAMTOP                          = $4004
; MODE                            = $4006
; PPC                             = $4007
; VERSN                           = $4009
; E_PPC                           = $400A
; D_FILE                          = $400C
; DF_CC                           = $400E
; VARS                            = $4010
; DEST                            = $4012
; E_LINE                          = $4014
; CH_ADD                          = $4016
; X_PTR                           = $4018
; STKBOT                          = $401A
; STKEND                          = $401C
; BREG                            = $401E
; MEM                             = $401F
; DF_SZ                           = $4022
; S_TOP                           = $4023
; LAST_K                          = $4025
; DB_ST                           = $4027
; MARGIN                          = $4028
; NXTLIN                          = $4029
; OLDPPC                          = $402B
; FLAGX                           = $402D
; STRLEN                          = $402E
; T_ADDR                          = $4030
; SEED                            = $4032
; FRAMES                          = $4034
; COORDS                          = $4036
; PR_CC                           = $4038
; S_POSN                          = $4039
; CDFLAG                          = $403B
; PRBUFF                          = $403C
; MEMBOT                          = $405D
; PROG                            = $407D
; MAXRAM                          = $7FFF

; ****************
; Map file by name
; ****************

; ADDEND_0                        = $1736
; ADDR_TOP                        = $042D
; ADD_BACK                        = $1741
; ADD_CHAR                        = $0526
; ADD_REP_6                       = $17B3
; ALL_ADDED                       = $174A
; ALL_CHARS                       = $0959
; ALPHA                           = $14CE
; ALPHANUM                        = $14D2
; ALPHA_2                         = $14D4
; ANOTHER                         = $0237
; BACK_NEXT                       = $0523
; BC_SPACES                       = $0030
; BIG_INT                         = $15AF
; BITS_ZERO                       = $1905
; BIT_DONE                        = $039C
; BOTH_NULL                       = $1B3A
; BREAK_1                         = $0F46
; BREAK_2                         = $0332
; BREAK_3                         = $0350
; BREAK_4                         = $03A2
; BREG                            = $401E
; BYTE_COMP                       = $1B2C
; BYTE_ZERO                       = $1900
; B_LINES                         = $0A2C
; CALCULATE                       = $199D
; CASES                           = $1D8B
; CDFLAG                          = $403B
; CENTRE                          = $0BA4
; CHECK_2                         = $0D22
; CHECK_END                       = $0D1D
; CH_ADD                          = $4016
; CLASS_0                         = $0D2D
; CLASS_1                         = $0D3C
; CLASS_2                         = $0D6B
; CLASS_3                         = $0D28
; CLASS_4                         = $0D85
; CLASS_4_2                       = $0D3F
; CLASS_5                         = $0D2E
; CLASS_6                         = $0D92
; CLASS_END                       = $0D3A
; CLEAR                           = $149A
; CLEAR_LOC                       = $0A42
; CLEAR_ONE                       = $055C
; CLEAR_PRB                       = $08E2
; CLS                             = $0A2A
; COLLAPSED                       = $0A52
; COLUMNS                         = $0BC5
; COMP_FLAG                       = $0992
; COND_MV                         = $13AF
; CONT                            = $0E7C
; CONTINUE                        = $06CA
; COORDS                          = $4036
; COPY                            = $0869
; COPY_BITS                       = $08B5
; COPY_BRK                        = $0880
; COPY_BUFF                       = $0871
; COPY_CONT                       = $088A
; COPY_END                        = $08DE
; COPY_LINE                       = $0766
; COPY_LOOP                       = $087A
; COPY_MULT_D                     = $0876
; COPY_NEXT                       = $089C
; COPY_NL                         = $08C7
; COPY_OVER                       = $0705
; COPY_TIME                       = $087D
; COPY_WAIT                       = $08BA
; COUNTER                         = $038A
; COUNT_ONE                       = $18CA
; CP_LINES                        = $09EA
; CURSOR                          = $0537
; CURSOR_IN                       = $14AD
; C_ENT                           = $1D4B
; DB_ST                           = $4027
; DEBOUNCE                        = $0F4B
; DECODE                          = $07BD
; DEC_TO_FP                       = $14D9
; DELAY_1                         = $0304
; DELAY_2                         = $032D
; DELAY_3                         = $0336
; DELAY_4                         = $033B
; DEST                            = $4012
; DF_CC                           = $400E
; DF_SZ                           = $4022
; DIFFER                          = $0A17
; DIGIT_INC                       = $07E2
; DIM                             = $1409
; DIM_SIZES                       = $147F
; DISPLAY_1                       = $0229
; DISPLAY_2                       = $023E
; DISPLAY_3                       = $0292
; DISPLAY_4                       = $02A9
; DISPLAY_5                       = $02B5
; DISPLAY_5_RET                   = $028B
; DISPLAY_6                       = $04C1
; DISPLAY_P                       = $022D
; DIVN_EXPT                       = $1810
; DIV_LOOP                        = $18A2
; DIV_START                       = $18B2
; DOUBLE_A                        = $19CE
; DOWN_KEY                        = $0454
; D_FILE                          = $400C
; D_LETTER                        = $1426
; D_NO_LOOP                       = $1435
; D_RPORT_C                       = $140C
; D_RUN                           = $141C
; D_SIZE                          = $1434
; EACH_BIT                        = $0320
; EACH_CHAR                       = $0475
; EACH_LINE                       = $02C5
; EDIT_INP                        = $046F
; EDIT_KEY                        = $05C4
; EDIT_LINE                       = $0487
; EDIT_ROOM                       = $048A
; ED_KEYS                         = $0562
; ENDED_1                         = $0589
; ENDED_2                         = $059D
; END_COMPL                       = $17B7
; END_LINE                        = $0482
; END_TESTS                       = $1B54
; ENTER                           = $051B
; ENTER_CH                        = $0808
; ENTER_CUR                       = $0F14
; ENT_TABLE                       = $19D0
; ERROR_1                         = $0008
; ERROR_2                         = $0056
; ERROR_3                         = $0058
; ERR_0_OK                        = $FFFFFFFFFFFFFFFF
; ERR_1_NEXT_WO_FOR               = $0000
; ERR_2_UNDEF_VAR                 = $0001
; ERR_3_SUBSCRIPT_RANGE           = $0002
; ERR_4_NO_ROOM                   = $0003
; ERR_4_SCREEN_FULL               = $0004
; ERR_6_OVERFLOW                  = $0005
; ERR_7_RET_WO_GOSUB              = $0006
; ERR_8_EOF                       = $0007
; ERR_9_STOP                      = $0008
; ERR_A_INVALID_ARG               = $0009
; ERR_B_INT_OVERFLOW              = $000A
; ERR_C_NONSENSE                  = $000B
; ERR_D_BREAK                     = $000C
; ERR_F_PROG_NAME                 = $000E
; ERR_NR                          = $4000
; ERR_SP                          = $4002
; EXIT                            = $1C59
; EXPAND_1                        = $083A
; EXPAND_2                        = $0940
; EXP_ZERO                        = $15BC
; EX_OR_NOT                       = $1B0B
; E_CHUNK                         = $157D
; E_DIVSN                         = $1583
; E_END                           = $1587
; E_FORMAT                        = $14F5
; E_LINE                          = $4014
; E_LINE_NO                       = $0A73
; E_LOOP                          = $1560
; E_LOW                           = $157A
; E_POSTVE                        = $1511
; E_PPC                           = $400A
; E_SWAP                          = $1584
; FAST                            = $0F23
; FETCH_1                         = $04F7
; FETCH_2                         = $0508
; FETCH_3                         = $0515
; FETCH_TWO                       = $16F7
; FIELD                           = $0B8B
; FIND_ADDR                       = $0BCA
; FIND_INT                        = $0EA7
; FIRST_3D                        = $19C2
; FLAGS                           = $4001
; FLAGS_2                         = $07AA
; FLAGX                           = $402D
; FOR                             = $0DB9
; FORM_EXP                        = $1A14
; FOR_END                         = $0E2A
; FOUND                           = $0993
; FPBC_END                        = $15C6
; FPBC_NORM                       = $15B5
; FPBC_NZRO                       = $1595
; FP_0_1                          = $1AE0
; FP_A_END                        = $15D9
; FP_CALC                         = $0028
; FP_TO_A                         = $15CD
; FP_TO_BC                        = $158A
; FRAMES                          = $4034
; FREE_LINE                       = $04B1
; FRST_LESS                       = $1B4D
; FUNCTION                        = $05AF
; FUNC_BASE                       = $04F2
; F_LMT_STP                       = $0DEA
; F_REORDER                       = $0DCC
; F_USE_ONE                       = $0DC6
; GEN_ENT_1                       = $19A0
; GEN_ENT_2                       = $19A4
; GET_BIT                         = $0385
; GET_CHAR                        = $0018
; GET_CODE                        = $0588
; GET_DE_FROM_DE_PLUS_1           = $12FF
; GET_FIRST                       = $165F
; GET_HL_MULT_DE                  = $1305
; GET_PARAM                       = $0CF7
; GET_PRIO                        = $10B5
; GOSUB                           = $0EB5
; GOTO                            = $0E81
; GOTO_2                          = $0E86
; GO_NC_MLT                       = $17B9
; GRE_8                           = $1CD2
; G_LOOP                          = $1A89
; HEADER                          = $02FF
; HL_AGAIN                        = $131D
; HL_END                          = $131A
; HL_LOOP                         = $1311
; IF                              = $0DAB
; IF_END                          = $0DB6
; IMPOSS                          = $0E69
; INC_CH_ADD                      = $0049
; INC_LINE                        = $0457
; INITIAL                         = $03E5
; INPUT                           = $0EE9
; INPUT_REP                       = $0D6F
; INTERRUPT                       = $0038
; INT_EXP1                        = $12DD
; INT_EXP2                        = $12DE
; INT_TO_FP                       = $1548
; IN_BYTE                         = $034C
; IN_NAME                         = $0366
; IN_PK_STK                       = $1AC2
; IN_PROG                         = $037B
; IX_END                          = $1912
; IY0                             = $4000
; I_CARRY                         = $12F9
; I_RESTORE                       = $12FC
; JUMP_2                          = $1C24
; JUMP_3                          = $1C2B
; KEYBOARD                        = $02BB
; KEY_INPUT                       = $0464
; KEY_LINE                        = $07C7
; KEY_SORT                        = $052D
; KL_KEY                          = $052B
; K_DECODE                        = $04DF
; K_FUNCT                         = $00CC
; K_GRAPH                         = $00F3
; K_MODE                          = $0540
; K_SHIFT                         = $00A5
; K_UNSHIFT                       = $007E
; LAST                            = $1DFD
; LAST_K                          = $4025
; LEAD_SP                         = $07DC
; LEFT_EDGE                       = $0593
; LEFT_KEY                        = $0576
; LESS_MASK                       = $190C
; LET                             = $1321
; LINE                            = $0408
; LINES                           = $0A0F
; LINE_ADDR                       = $09D8
; LINE_ENDS                       = $0A1F
; LINE_NO                         = $05BB
; LINE_NULL                       = $0CDE
; LINE_RUN                        = $0CC1
; LINE_SCAN                       = $0CBA
; LIST                            = $0730
; LIST_PROG                       = $073E
; LIST_TOP                        = $0433
; LLIST                           = $072C
; LMT_V_VAL                       = $0E62
; LOAD                            = $0340
; LOAD_SAVE                       = $01FC
; LOC_ADDR                        = $0918
; LOC_MEM                         = $1A3C
; LOOK_BACK                       = $0927
; LOOK_VARS                       = $111C
; LOOP_11                         = $0216
; LOOP_B                          = $026A
; LOWER                           = $0472
; LPRINT                          = $0ACB
; LPRINT_A                        = $0802
; LPRINT_CH                       = $0851
; L_ADD_DOLLAR                    = $13B7
; L_CHAR                          = $134B
; L_DELETE_DOLLAR                 = $137A
; L_EACH_CH                       = $132D
; L_ENTER                         = $13AE
; L_EXISTS                        = $136E
; L_FIRST                         = $13E7
; L_IN_WS                         = $13AB
; L_LENGTH                        = $13A3
; L_MODE                          = $0556
; L_NEW_DOLLAR                    = $13C8
; L_NO_SP                         = $132E
; L_NUMERIC                       = $1361
; L_SINGLE                        = $1359
; L_STRING                        = $13CE
; MAKE_EXPT                       = $180E
; MAKE_ROOM                       = $099E
; MARGIN                          = $4028
; MATCHING                        = $0371
; MAXRAM                          = $7FFF
; MEM                             = $401F
; MEMBOT                          = $405D
; MLT_LOOP                        = $17E7
; MODE                            = $4006
; MORE_LINE                       = $076D
; NAME                            = $03A8
; NEAR_ZERO                       = $182C
; NEG_BYTE                        = $16EC
; NEW                             = $03C3
; NEXT                            = $0E2E
; NEXT_ADD                        = $0A15
; NEXT_BIT                        = $034E
; NEXT_CHAR                       = $0020
; NEXT_LETT                       = $0A08
; NEXT_LINE                       = $066C
; NEXT_LOOP                       = $0E5A
; NEXT_ONE                        = $09F2
; NEXT_O_4                        = $0A10
; NEXT_PLUS_FIVE                  = $0A01
; NEXT_PROG                       = $0347
; NEXT_PTR                        = $09B4
; NEXT_TEST                       = $09DE
; NIL_BYTES                       = $18F4
; NL_INP                          = $064E
; NL_KEY                          = $060C
; NL_LINE                         = $06E0
; NL_NULL                         = $0664
; NL_ONLY                         = $0413
; NMI                             = $0066
; NMI_CONT                        = $006F
; NMI_RET                         = $006D
; NORMALIZE                       = $183F
; NORML_NOW                       = $1859
; NOT_AT                          = $0AFA
; NOT_TAB                         = $0B31
; NOT_TOKEN                       = $079A
; NOW_SCAN                        = $0629
; NO_ADD                          = $17EE
; NO_KEY                          = $0264
; NO_NUMBER                       = $0A91
; NO_RSTORE                       = $18C9
; NO_SLOW                         = $0226
; NO_TO_STK                       = $0D9C
; NUMBER                          = $07B4
; NU_OR_STR                       = $1B16
; NXTLIN                          = $4029
; NXTLIN_NO                       = $0E0E
; NXT_DGT_1                       = $14E5
; NXT_DGT_2                       = $154D
; N_NEGTV                         = $1C9B
; OFLOW_CLR                       = $1868
; OFLW1_CLR                       = $1819
; OFLW2_CLR                       = $1824
; OLDPPC                          = $402B
; ONE                             = $1DFB
; ONE_SHIFT                       = $1722
; ONE_SPACE                       = $099B
; OTHER_STR                       = $1B7D
; OUT_BYTE                        = $031E
; OUT_CH                          = $07EE
; OUT_CODE                        = $07EB
; OUT_CURS                        = $079D
; OUT_DIGIT                       = $07E1
; OUT_LINE                        = $0745
; OUT_NAME                        = $030B
; OUT_NO                          = $0AA5
; OUT_NUM                         = $0A98
; OUT_PROG                        = $0316
; OVER_NC                         = $0239
; PAUSE                           = $0F32
; PF_DC_OUT                       = $16C2
; PF_E_FMT                        = $1682
; PF_E_LOW                        = $16AD
; PF_E_POS                        = $1698
; PF_E_SIGN                       = $169A
; PF_E_TENS                       = $169E
; PF_FRAC_LP                      = $16C8
; PF_LOOP                         = $1615
; PF_NEGTVE                       = $15EA
; PF_NIBBLE                       = $16D0
; PF_NIB_LP                       = $167B
; PF_NULL                         = $162C
; PF_POS                          = $165B
; PF_POSTVE                       = $15F0
; PF_RND_LP                       = $1639
; PF_ZEROS                        = $16B2
; PF_ZERO_1                       = $16BF
; PF_ZERO_6                       = $164B
; PF_ZRO_LP                       = $16BA
; PF_loop                         = $1AE3
; PLOT                            = $0BE9
; PLOT_END                        = $0BF1
; PLOT_UNPLOT                     = $0BAF
; POINTERS                        = $09AD
; POKE                            = $0E92
; POKE_SAVE                       = $0E9B
; PPC                             = $4007
; PRBUFF                          = $403C
; PRB_BYTES                       = $08E9
; PREP_ADD                        = $16D8
; PREP_M_OR_D                     = $17BC
; PRINT                           = $0ACF
; PRINT_1                         = $0AD5
; PRINT_A                         = $0010
; PRINT_AT                        = $08F5
; PRINT_CH                        = $07F1
; PRINT_END                       = $0B84
; PRINT_EXX                       = $0805
; PRINT_FP                        = $15DB
; PRINT_ON                        = $0B37
; PRINT_SP                        = $07F5
; PRINT_STK                       = $0B55
; PROG                            = $407D
; PROMPT                          = $0F05
; PR_CC                           = $4038
; PR_STR_1                        = $0B64
; PR_STR_2                        = $0B66
; PR_STR_3                        = $0B67
; PR_STR_4                        = $0B6B
; PTR_DONE                        = $09C8
; PULSES                          = $0329
; P_CLEAR                         = $0C92
; P_CLS                           = $0C95
; P_CONT                          = $0C8F
; P_COPY                          = $0CB1
; P_DIM                           = $0C71
; P_FAST                          = $0CAE
; P_FOR                           = $0C5E
; P_GOSUB                         = $0C54
; P_GOTO                          = $0C4B
; P_IF                            = $0C4F
; P_INPUT                         = $0C6D
; P_LET                           = $0C48
; P_LIST                          = $0C7D
; P_LLIST                         = $0CB7
; P_LOAD                          = $0C89
; P_LPRINT                        = $0CB4
; P_NEW                           = $0C77
; P_NEXT                          = $0C66
; P_PAUSE                         = $0CA7
; P_PLOT                          = $0C98
; P_POKE                          = $0C80
; P_PRINT                         = $0C6A
; P_RAND                          = $0C86
; P_REM                           = $0C74
; P_RETURN                        = $0C5B
; P_RUN                           = $0C7A
; P_SAVE                          = $0C8C
; P_SCROLL                        = $0CA4
; P_SLOW                          = $0CAB
; P_STOP                          = $0C58
; P_UNPLOT                        = $0C9E
; RAMTOP                          = $4004
; RAM_CHECK                       = $03CB
; RAM_FILL                        = $03CF
; RAM_READ                        = $03D5
; RAND                            = $0E6C
; RECLAIM_1                       = $0A5D
; RECLAIM_2                       = $0A60
; REC_V80                         = $14C7
; REM                             = $0D6A
; REPORT                          = $06D1
; REPORT_1                        = $0E58
; REPORT_2                        = $0D4B
; REPORT_3                        = $1231
; REPORT_4                        = $0ED3
; REPORT_5                        = $0835
; REPORT_6                        = $1880
; REPORT_6b                       = $1C99
; REPORT_7                        = $0EE5
; REPORT_8                        = $0F21
; REPORT_Ab                       = $1CAF
; REPORT_B                        = $0EAD
; REPORT_Bd                       = $1BA2
; REPORT_C                        = $0D9A
; REPORT_C2                       = $0D26
; REPORT_D                        = $03A6
; REPORT_D2                       = $0888
; REPORT_F                        = $02F4
; RESERVE                         = $1488
; RESTART                         = $0361
; RESULT_OK                       = $1CA2
; RETURN                          = $0ED8
; RE_ENTRY                        = $19A7
; RIGHT                           = $0BAB
; RIGHT_KEY                       = $057F
; RSLT_ZERO                       = $1CA4
; RUBOUT                          = $058B
; RUN                             = $0EAF
; R_IX_1                          = $0281
; R_IX_2                          = $028F
; SAVE                            = $02F6
; SCANNING                        = $0F55
; SCAN_ENT                        = $19AE
; SCAN_LINE                       = $0045
; SCAN_LOOP                       = $0CF4
; SCROLL                          = $0C0E
; SECND_LOW                       = $1B33
; SEC_PLUS                        = $1B3D
; SEED                            = $4032
; SEPARATOR                       = $0D10
; SET_FAST                        = $02E7
; SET_FIELD                       = $090B
; SET_MIN                         = $14BC
; SET_SEED                        = $0E77
; SET_STK                         = $0D4D
; SET_STK_B                       = $14A6
; SET_STK_E                       = $14A9
; SET_STRLN                       = $0D63
; SET_TOP                         = $03E2
; SHIFT_FP                        = $171A
; SHIFT_LEN                       = $1769
; SHIFT_ONE                       = $1841
; SIGN_DONE                       = $1508
; SIGN_TO_C                       = $1ADC
; SKIP_CONS                       = $1A2D
; SKIP_NEXT                       = $1A2E
; SKIP_ZERO                       = $1831
; SLICING                         = $1263
; SLOW                            = $0F2B
; SLOW_DISP                       = $04CF
; SLOW_FAST                       = $0207
; SL_DEFINE                       = $12A5
; SL_OVER                         = $12B9
; SL_RPT_C                        = $128B
; SL_SECOND                       = $1292
; SL_STORE                        = $12BE
; SMALL                           = $1D89
; SPACING                         = $0B44
; SPARE                           = $1DFF
; SQ_SAVED                        = $0BD9
; STACK_A                         = $151D
; STACK_BC                        = $1520
; START                           = $0000
; STKBOT                          = $401A
; STKEND                          = $401C
; STK_BC_2                        = $1536
; STK_CODE                        = $1C0E
; STK_CONST                       = $19FE
; STK_DIGIT                       = $1514
; STK_FETCH                       = $13F8
; STK_PNTRS                       = $1B85
; STK_STO_DOLLAR                  = $12C3
; STK_ST_0                        = $12C2
; STK_TO_A                        = $0C02
; STK_TO_BC                       = $0BF5
; STK_UPPER                       = $0626
; STK_VAR                         = $11A7
; STK_ZEROS                       = $1A27
; STOP                            = $0CDC
; STOP_LINE                       = $06AE
; STRINGS                         = $1B21
; STRLEN                          = $402E
; STRT_MLT                        = $17F8
; STR_TEST                        = $1B50
; ST_E_PART                       = $1509
; SUBMLTDIV                       = $10A7
; SUBN_ONLY                       = $18C2
; SV_ARRAYS                       = $11BF
; SV_CH_ADD                       = $11F1
; SV_CLOSE                        = $11E9
; SV_COMMA                        = $11D4
; SV_COUNT                        = $11F8
; SV_DIM                          = $1259
; SV_ELEM_DOLLAR                  = $123D
; SV_LOOP                         = $11FB
; SV_MULT                         = $120C
; SV_NUMBER                       = $1233
; SV_PTR                          = $11D1
; SV_RPT_C                        = $1223
; SV_SIMPLE_DOLLAR                = $11B2
; SV_SLICE                        = $1256
; SV_SLICE_QUESTION               = $125A
; SWAP_BYTE                       = $1A74
; SYNTAX_ON                       = $0B4E
; SYNTAX_Z                        = $0DA6
; S_ALPHANUM                      = $0FB2
; S_CONT_2                        = $1087
; S_CONT_3                        = $1088
; S_DECIMAL                       = $1047
; S_FUNCTION                      = $1002
; S_JPI_END                       = $0F8A
; S_JP_CONT3                      = $0FF8
; S_LOOP                          = $10BC
; S_LOOPEND                       = $10EA
; S_LOOP_1                        = $0F59
; S_LTR_DGT                       = $1025
; S_NEXT                          = $110A
; S_NOT_AND                       = $1102
; S_NO_TO__DOLLAR                 = $101A
; S_NUMERIC                       = $1083
; S_OPERTR                        = $1098
; S_PI_END                        = $0F99
; S_POSN                          = $4039
; S_PUSH_PO                       = $1020
; S_QUOTE                         = $0FD6
; S_QUOTE_S                       = $0FE3
; S_Q_AGAIN                       = $0FE0
; S_Q_NL                          = $0FFB
; S_RPORT_C                       = $10DB
; S_RPT_C                         = $0FFF
; S_RUNTEST                       = $10DE
; S_STK_DEC                       = $106F
; S_STRING                        = $0FED
; S_SYNTEST                       = $10D5
; S_TEST_PI                       = $0F8C
; S_TIGHTER                       = $10ED
; S_TOP                           = $4023
; S_TST_INK                       = $0F9D
; TABLE_ADD                       = $0505
; TABLE_PTR                       = $0BDA
; TAB_CNST                        = $1915
; TAB_TEST                        = $0B1E
; TEMP_PTR1                       = $004C
; TEMP_PTR2                       = $004D
; TEST_5_SP                       = $19EB
; TEST_CHAR                       = $0544
; TEST_CURS                       = $0516
; TEST_END                        = $0755
; TEST_HIGH                       = $097F
; TEST_LOW                        = $082C
; TEST_NEG                        = $1790
; TEST_NL                         = $0812
; TEST_NORM                       = $1828
; TEST_NULL                       = $0661
; TEST_NUM                        = $077C
; TEST_ROOM                       = $0EC5
; TEST_SP                         = $001C
; TEST_VAL                        = $08FA
; THOUSAND                        = $0AAD
; TOKENS                          = $094B
; TOKENS_TAB                      = $0111
; TOKEN_ADD                       = $0975
; TRAILER                         = $0388
; TRAIL_SP                        = $096D
; T_ADDR                          = $4030
; T_GR_ZERO                       = $18EF
; UNITS                           = $0ABF
; UNPLOT                          = $0BEB
; UNSTACK_Z                       = $0AC5
; UNTIL_END                       = $0740
; UPPER                           = $0419
; UP_KEY                          = $059F
; VALID                           = $1CB1
; VARS                            = $4010
; VERSN                           = $4009
; V_80_BYTE                       = $1188
; V_CHAR                          = $1139
; V_EACH                          = $1159
; V_END                           = $11A1
; V_FOUND_1                       = $1194
; V_FOUND_2                       = $1195
; V_GET_PTR                       = $117F
; V_MATCHES                       = $116B
; V_NEXT                          = $1180
; V_PASS                          = $1199
; V_RUN                           = $1156
; V_RUN_OR_SYN                    = $1148
; V_SPACES                        = $116C
; V_STR_VAR                       = $1143
; V_SYNTAX                        = $118A
; WAIT_INT                        = $0041
; WORDS                           = $0985
; WRITE_CH                        = $083E
; WRITE_NL                        = $0847
; WRONG_VAL                       = $0905
; XISO                            = $1DEE
; X_NEG                           = $1C4E
; X_PTR                           = $4018
; X_TEMP                          = $14A3
; YNEG                            = $1D3C
; ZEROS_4_OR_5                    = $1738
; ZERO_DE                         = $05B7
; ZERO_RSLT                       = $1830
; ZPLUS                           = $1D35
; abs                             = $1AAA
; acs                             = $1DD4
; addition                        = $1755
; asn                             = $1DC4
; atn                             = $1D76
; char_set                        = $1E00
; chr_dollar                      = $1B8F
; class_tbl                       = $0D16
; code                            = $1C06
; cos                             = $1D3E
; dec_jr_nz                       = $1C17
; delete                          = $19E3
; div_34th                        = $18AB
; division                        = $1882
; duplicate                       = $19F6
; e_to_fp                         = $155A
; end_calc                        = $002B
; exchange                        = $1A72
; exp                             = $1C5B
; fp_calc_2                       = $19E4
; get_argt                        = $1D18
; get_mem_x                       = $1A45
; greater_0                       = $1ACE
; int                             = $1C46
; jump                            = $1C23
; jump_true                       = $1C2F
; len                             = $1C11
; less_0                          = $1ADB
; ln                              = $1CA9
; multiply                        = $17C6
; n_mod_m                         = $1C37
; neg                             = $1AA0
; no_and_no                       = $1AF3
; no_l_eql                        = $1B03
; not                             = $1AD5
; offset_t                        = $0C29
; or                              = $1AED
; peek                            = $1ABE
; seriesg_x                       = $1A7F
; sgn                             = $1AAF
; sin                             = $1D49
; sqr                             = $1DDB
; stk_con_x                       = $1A51
; stk_data                        = $19FC
; sto_mem_x                       = $1A63
; str_and_no                      = $1AF8
; str_dollar                      = $1BD5
; strs_add                        = $1B62
; subtract                        = $174C
; tan                             = $1D6E
; tbl_addrs                       = $1923
; tbl_pri                         = $110F
; to_power                        = $1DE2
; truncate                        = $18E4
; usr_no                          = $1AC5
; val                             = $1BA4