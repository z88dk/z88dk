  ;-----------------------------------------------------------------------------
; sbasic.inc
;
; This file contains locations of SBASIC3 systen variables and ROM calls
;
; Locations to the original Aquarius ROM are taken from the dissassembly by
; Curtis F Kaylor, which can be found at:
; https://github.com/RevCurtisP/Aquarius/blob/main/disassembly/aquarius-rom.lst
;-----------------------------------------------------------------------------
; sbasic.inc

;-----------------------------------------------------------------------------
; System variables
;-----------------------------------------------------------------------------
SCREEN:     equ $3000   ; Screen Character Matrix
COLOR:      equ $3400   ; Screen Color Matrix
TTYPOS:     equ $3800   ; [M80] STORE TERMINAL POSITION HERE
CURRAM:     equ $3801   ; Position in CHARACTER RAM of cursor
USRPOK:     equ $3803   ; JP instruction for USR() routine
USRADD:     equ $3804   ; Address of USR routine
HOOK:       equ $3806   ; Extended ROM Hook Vector
CNTOFL:     equ $3808   ; Line Counter. If not 0,
LASTFF:     equ $3809   ; Last value last output to port #FF
CHARC:      equ $380A   ; [M80] ISCNTC STORES EATEN CHAR HERE WHEN NOT A ^C
RESPTR:     equ $380B   ; Pointer to Ctrl-Key Reserved Word
CURCHR:     equ $380D   ; Character under Cursor
LSTX:       equ $380E   ; [M64] Matrix Coordinate of Last Key Pressed
KCOUNT:     equ $380F   ; Keyboard debounce counter
FDIVC:      equ $3810   ;
FDIVB:      equ $3814   ;
FDIVA:      equ $3818   ;
FDIVG:      equ $381B   ;
;               $381E   ; {M80} RND FUNCTION PERTUBATION COUNT
RNDCNT:     equ $381F   ;
;               $3820   ;
RNDTAB      equ $3821   ; RND Permutation Table - Deprecated in S3BASIC
                        ; Used for plusBASIC system variables (see plus.inc)
RNDX:       equ $3841   ; [M80] LAST RANDOM NUMBER GENERATED, BETWEEN 0 AND 1
LPTPOS:     equ $3846   ; [M80] POSITION OF LPT PRINT HEAD
PRTFLG:     equ $3847   ; [M80] WHETHER OUTPUT GOES TO LPT
LINLEN:     equ $3848   ; Length of a Screen Line
CLMLST:     equ $3849   ;
SCOLOR      equ $384A   ; Screen colors for TTYOUT
TOPMEM:     equ $384B   ; [M80] TOP LOCATION TO USE FOR THE STACK INITIALLY SET UP BY INIT
                        ; [M80] ACCORDING TO MEMORY SIZE TO ALLOW FOR 50 BYTES OF STRING SPACE.
                        ; [M80] CHANGED BY A CLEAR COMMAND WITH AN ARGUMENT.
CURLIN:     equ $384D   ; [M80] CURRENT LINE #
TXTTAB:     equ $384F   ; [M80] POINTER TO BEGINNING OF TEXT
                        ; [M80] DOESN'T CHANGE AFTER BEING SETUP BY INIT.
FILNAM:     equ $3851   ; File Name for CSAVE and CLOAD
FILNAF:     equ $3857   ; File Name Read from Cassette
INSYNC:     equ $385D   ; Contains $FF between read of SYNC and data from tape
CLFLAG:     equ $385E   ; Flags whether doing CLOAD (0) or CLOAD? ($FF)
BUFMIN:     equ $385F   ; {M80} START OF BUFFER
BUF:        equ $3860   ; [M80] TYPE IN STORED HERE. DIRECT STATEMENTS EXECUTE OUT OF HERE.
                        ; [M80] REMEMBER "INPUT" SMASHES BUF. MUST BE AT A LOWER ADDRESS THAN DSCTMP
                        ; [M80] OR ASSIGNMENT OF STRING VALUES IN DIRECT STATEMENTS WON'T COPY INTO
                        ; [M80] STRING SPACE -- WHICH IT MUST ALLOW FOR SINGLE QUOTE IN BIG LINE
ENDBUF:     equ $38A9   ; [M80] PLACE TO STOP BIG LINES
DIMFLG:     equ $38AA   ; [M80] IN GETTING A POINTER TO A VARIABLE IT IS IMPORTANT TO REMEMBER
                        ; [M80] WHETHER IT IS BEING DONE FOR "DIM" OR NOT
VALTYP:     equ $38AB   ; [M80] THE TYPE INDICATOR 0=NUMERIC 1=STRING
DORES:      equ $38AC   ; [M80] WHETHER CAN OR CAN'T CRUNCH RES'D WORDS TURNED ON WHEN "DATA"
                        ; [M80] BEING SCANNED BY CRUNCH SO UNQUOTED STRINGS WON'T BE CRUNCHED.
MEMSIZ:     equ $38AD   ; [M80] HIGHEST LOCATION IN MEMORY
TEMPPT:     equ $38AF   ; [M80] POINTER AT FIRST FREE TEMP DESCRIPTOR. INITIALIZED TO POINT TO TEMPST
TEMPST:     equ $38B1   ; [M80] STORAGE FOR NUMTMP TEMP DESCRIPTORS
DSCTMP:     equ $38BD   ; [M80] STRING FUNCTIONS BUILD ANSWER DESCRIPTOR HERE
FRETOP:     equ $38C1   ; [M80] TOP OF STRING FREE SPACE
TEMP3:      equ $38C3   ; S3BASIC: Used during formula evaluation and array variable processing
                        ; plusBASIC: Line# flag during line tokenization, Line link when searching for label
TEMP8:      equ $38C5   ; [M80] USED TO STORE THE ADDRESS OF THE END OF STRING ARRAYS IN GARBAGE COLLECTION
ENDFOR:     equ $38C7   ; [M80] SAVED TEXT POINTER AT END OF "FOR" STATEMENT
DATLIN:     equ $38C9   ; [M80] DATA LINE # -- REMEMBER FOR ERRORS
SUBFLG:     equ $38CB   ; [M80] FLAG WHETHER SUBSCRIPTED VARIABLE ALLOWED "FOR" AND USER-DEFINED
                        ; [M80] FUNCTION POINTER FETCHING TURN THIS ON BEFORE CALLING PTRGET SO
                        ; [M80] ARRAYS WON'T BE DETECTED. STKINI AND PTRGET CLEAR IT.
USFLG:      equ $38CC   ; Direct Mode Flag
FLGINP:     equ $38CD   ; [M80] FLAGS WHETHER WE ARE DOING "INPUT" OR A READ
SAVTXT:     equ $38CE   ; [M80] PLACE WHERE NEWSTT SAVES TEXT POINTER
TEMP2:      equ $38D0   ; [M80] FORMULA EVALUATOR TEMP MUST BE PRESERVED BY OPERATORS
                        ; [M80] USED IN EXTENDED BY FOUT AND USER-DEFINED FUNCTIONS
OLDLIN:     equ $38D2   ; [M80] OLD LINE NUMBER (SETUP BY ^C,"STOP" OR "END" IN A PROGRAM)
OLDTXT:     equ $38D4   ; [M80] OLD TEXT POINTER
VARTAB:     equ $38D6   ; [M80] POINTER TO START OF SIMPLE VARIABLE SPACE. UPDATED WHENEVER
                        ; [M80] THE SIZE OF THE PROGRAM CHANGES, SET TO [TXTTAB] BY SCRATCH ("NEW").
ARYTAB:     equ $38D8   ; [M80] POINTER TO BEGINNING OF ARRAY TABLE. INCREMENTED BY 6 WHENEVER
                        ; [M80] A NEW SIMPLE VARIABLE IS FOUND, AND SET TO [VARTAB] BY CLEARC.
STREND:     equ $38DA   ; [M80] END OF STORAGE IN USE. INCREASED WHENEVER A NEW ARRAY
                        ; [M80] OR SIMPLE VARIABLE IS ENCOUNTERED SET TO [VARTAB] BY CLEARC.
DATPTR:     equ $38DC   ; [M80] POINTER TO DATA. INITIALIZED TO POINT AT THE ZERO IN FRONT OF [TXTTAB]
                        ; [M80] BY "DATPTR" WHICH IS CALLED BY CLEARC. UPDATED BY EXECUTION OF A "READ"
VARNAM:     equ $38DE   ; Variable Name
VARPNT:     equ $38E0
FNPARM      equ $38E2   ; Defined Function Parameter
FACLO:      equ $38E4   ; [M80] LOW ORDER OF MANTISSA
FACMO:      equ $38E5   ; [M80] MIDDLE ORDER OF MANTISSA
FACHO:      equ $38E6   ; [M80] HIGH ORDER OF MANTISSA
FAC:        equ $38E7   ; [M80] EXPONENT
FBUFFR:     equ $38E8   ; [M80[ BUFFER FOR FOUT
FPSTR:      equ $38E9   ; Floating point string
RESHO:      equ $38F6   ; [M65] RESULT OF MULTIPLIER AND DIVIDER
RESMO:      equ $38F7   ; RESMO and RESLO are loaded into and stored from HL
RESLO:      equ $38F8   ;
SAVSTK:     equ $38F9   ; [M80] NEWSTT SAVES STACK HERE BEFORE SO THAT ERROR REVERY CAN
                        ; [M80] CAN DATPTR THE STACK WHEN AN ERROR OCCURS
INTJMP  equ     $38FB   ; RST 7 Interrupt JMP (3 bytes)
STRSPC  equ     $38FE   ; Start of String Space. TOPMEM is 512 bytes below this.
BASTXT:     equ $3901   ; Start of Basic Program

;-----------------------------------------------------------------------------
; System ROM functions
;-----------------------------------------------------------------------------
;RST
START       equ $00     ; 0 Start/Reboot
SYNCHR      equ $08     ; 1 SN Error if next character does not match
CHRGET      equ $10     ; 2 Get Next Character
OUTCHR      equ $18     ; 3 Output Character
COMPAR      equ $20     ; 4 Compare HL with DE
FSIGN       equ $28     ; 5 Get sign of Floating Point Argument
HOOKDO      equ $30     ; 6 Extended BASIC Hook Dispatch
INTRPT      equ $38     ; 7 (S3BASIC) Execute Interrupt Routine

S3VER       equ $0003   ; S3 Version in BCD: YY,MM,DD,Rev
JUMPIX      equ $0034   ; Jump to address in IX
NOHOOK      equ $003B   ; Default Hook routine
RESET:      equ $0089   ; Display start up screen 
RESETC:     equ $008C   ; RESET alternate entry point
COLDST      equ $00FD   ; Do cold start
CLDCON      equ $0138   ; Finish S3BASIC cold boot
HEDING      equ $015F   ; Microsoft copyright message
INITFF:     equ $0153   ; Initialize I/O Port 255 
REDDY       equ $036E   ; Text "Ok"
FNDFOR      equ $039F   ; Find FOR/GOSUB entry on stack
SNERR:      equ $03C4   ; Syntax error
DV0ERR:     equ $03C7   ; Division by zero error
NFERR:      equ $03CA   ; Next without for error
DDERR:      equ $03CD   ; redimensioned array error
UFERR:      equ $03D0   ; Undefined function error
OVERR:      equ $03D3   ; Overflow Error
MOERR:      equ $03D6   ; Missing Operand error
TMERR:      equ $03D9   ; Type mismatch error
ERROR:      equ $03DB   ; Process error code, E = code (offset to 2 char error name)
ERRCRD      equ $03E0   ; Print Error Message and Return to Immediate Mode
ERRPRT      equ $03EA   ; Print Error pointed to by HL and Return to Immediate Mode
ERRFNE      equ $03F1   ; Print "Error in " + line number and Return to Immediate Mode
ERRFN1:     equ $03F4   ; Print String in HL + " in " + line number, Return to Immediate mode 
STPRDY      equ $0401   ; For LIST command stopping
READY:      equ $0402   ; Enter direct mode
MAIN        equ $0414   ; Immediate Mode loop     
DEL         equ $044B   ; Delete BASIC line
LINKIT      equ $0487   ; Link Line with starting address minus 1 in HL
CHEAD       equ $0489   ; Link Lines with starting address in DE
FNDLIN      equ $049F   ; Find BASIC line with line number in DE
FNDLOP      equ $04A2   ; Find BASIC line with line number in DE starting at address in DE
KLOOP       equ $04C5   ; Keyword to token loop
STRNGR      equ $04D1   ; Continue C
CRUNCX      equ $04F9   ; Tokenize text at [HL]
NOTGOS      equ $0536   ; Return point for CRUNCX
STUFFH      equ $053C   ; Copy character to crunch buffer
COLIS       equ $0548   ; Enter STUFFH after DATA token detected
NODATT      equ $054B   ; Enter STUFFH at check for REM token
STRNG       equ $0558   ; Stuff Quoted String
CRDONE      equ $055E   ; Finish CRUNCH
LIST3       equ $0579   ; Start list at line pointed to by BC
LISPRT      equ $0598   ; Detokenize and print BASIC line
RESSRC:     equ $05A8   ; Search keyword list
NEWSTT:     equ $062C   ; Execute next statement
GONE        equ $064B   ; Execute statement
GONEX       equ $0656   ; Evaluate statement token
CHRGTR      equ $066B   ; CALLable CHRGET
CHRGT2      equ $066C   ; Get Current Character and Set Flags
CHRGT3      equ $066D   ; Test character in A and set flags
GONE4       equ $063C   ; Execute next line
GONCON      equ $064A   ; Swap DE and HL then execute GONE
FRCINT:     equ $0682   ; Convert fp number to 16 bit signed integer in DE
CONRUN      equ $06C3   ; RUN specied line number
RETURN      equ $06F8   ; Execute RETURN statement
FCERR:      equ $0697   ; Function call error
IQERR       equ FCERR   ; Illegal quantity error (future expansion)
SCNLIN      equ $069C   ; Get line number from text at (HL)
LINGET      equ $069D   ; Skip over line number
RUNC2:      equ $06DB
GOTO        equ $06DC   ; Execute GOTO statement
GOTOLN      equ $06DF   ; GOTO line# in DE
USERR       equ $06F3   ; Undefined line error
DATA        equ $071C   ; Execute DATA statement
REM         equ $071E   ; Execute REM statement
LET         equ $0731   ; Execute LET statement
LETEQ       equ $0734   ; Continue LET at '='
LETDO       equ $0736   ; Execute LET, bypassing PTRGET and SYNCHK '='
INBUFC      equ $0768   ; Copy temporary string to string variable
NTOERR      equ $0782   ; Execute ON ... GOTO
INPUT       equ $0893   ; Execute INPUT
READC       equ $08C2   ; Continue READ after hook call
FRMNUM:     equ $0972   ; Evaluate numeric expression
CHKNUM:     equ $0975   ; Error if evaluated expression not a number
CHKSTR:     equ $0976   ; Error if evaluated expression not string
FRMEQL      equ $0980   ; Evaluate formula after eating equal sign
FRMPRN      equ $0983   ; Evaluate formula after eating open paren
FRMEVL:     equ $0985   ; Evaluate formula
FRMCHK      equ $0986   ; Skip current character, then evaluate formula
NTPLUS      equ $09BA   ;
EVALOP      equ $09C3   ; Operator evaluator in FRMEVL
QDOT:       equ $0A14   ; Continue EVAL routine
PARCHK:     equ $0A37   ; Evaluate expression in` brackets
LABBCK:     equ $0A49   ; Return numeric value from function
ISVAR       equ $0A4E   ; Get variable value or string pointer
RETVAR      equ $0A51   ; Put value of variable pointed to by DE in FACLO
GIVFLT      equ $0B1C   ; Float HL - DE   
GIVINT      equ $0B21   ; Float Integer MSB=[A], LSB=[C]
FLOATD      equ $0B23   ; Float Integer MSB=[A], LSB=[D]
SNGFLT:     equ $0B36   ; Store variable 8 bit (out: B = value)
ERRDIR      equ $0B45   ; Error if in direct mode
GTBYTC      equ $0B53   ; Skip character, evaluate expression (integer 0-255)
GETBYT:     equ $0B54   ; Evaluate numeric expression (integer 0-255)
CONINT      equ $0B57   ; Convert FAC to byte
OMERR:      equ $0BB7   ; Out of memory error
SCRTCH:     equ $0BBE   ; Execute NEW command
RUNC:       equ $0BCB   ; Do the RUN
CLEARC:     equ $0BCF   ; Clear variable and array space, then initialize stack
CLEARV      equ $0BDF   ; Continue CLEAR after call to RESTOR
STKINI:     equ $0BE5   ; Initialize stack
;FRMINT         $0B7F   ; Use GETINT instead. This routine has an unnecessary PUSH/POP HL
RESTOR      equ $0C05   ; RESTORE statement
BGNRST      equ $0C19   ; Finish up RESTORE
STOP        equ $0C1F   ; STOP statement
ISLETC:     equ $0CC6   ; Test for a letter
CLRCON      equ $0D04   ; Continue CLEARS after setting top of stack
NOTRUB      equ $0DA3   ; Continue Ctrl-key check
CHKFUN      equ $0DA4   ; Evaluate Ctrl-keys
INLINC      equ $0D8E   ; Wait for and process direct mode keypress
GOODCH      equ $0DE9   ; INLINC - Put key in input buffer
STR         equ $0E29   ; Execute STR$ function
TIMSTR      equ $0E2F   ; Create tempory string from null-terminated string
TIMSTF      equ $0E32   ; Return parsed temporary string
STRCPY      equ $0E39   ; Create copy of string
STRINI      equ $0E50   ; Reserve space for new string and create descriptor
STRAD2      equ $0E53   ; Build string descriptor in DSCTMP
STRADI      equ $0E56   ; Build string descriptor at HL
STRADX      equ $0E59   ; Entry point into STRADI
STRLIT      equ $0E5F   ; Build descriptor for string litersl
STRLTI      equ $0E60   ; Do STRLIT, without decrementing HL
STRLT3      equ $0E62   ; Do STRLTI with delimiter in B 
STRLT2      equ $0E63   ; Do STRLTI with delimiters in B and C
STRNEX      equ $0E79   ; Build temporary descriptor for string with address HL, length C
STRNEW      equ $0E7B   ; Build temporary descriptor for string with address DE, length A
PUTNEW      equ $0E7E   ; Set Pointer to Temporary String
GETSPA:     equ $0EB3   ; Allocate string space
STROUT:     equ $0E9D   ; Print null-terminated string in HL
STRPRT      equ $0EA0   ; Print string with descriptor in FACLO
GARBA2      equ $0EDB   ; Perform garbage collection
CAT         equ $0F7C   ; String Concatenation Routine
MOVSTA      equ $0FBC   ; Copy A bytes from [BC] to [DE]
MOVSTR      equ $0FBD   ; Copy L bytes from [BC] to [DE]
FRESTR      equ $0FC6   ; Free tempory string, return string descriptor address in HL
FREFAC      equ $0FC9   ; Free tempory string with descriptor in FAC
FRETM2      equ $0FCC   ; Free up temporary in FACLO
FRETMP      equ $0FCD   ; Free up temporary
FRETMS      equ $0FE4   ; Free up temporary descriptor
LEN1:       equ $0FF7   ; Get string length (in: (FPREG) = string block, out: HL = string block, A = length)
ASC2        equ $1006   ; Return DE = Pointer to String Text, A=First Character 
CHR         equ $1013   ; CHR$ Function
FINBCK      equ $101D   ; Return a String
DIMNXT      equ $10CA   ; Require comma and DIM an array
PTRGET:     equ $10D1   ; Get variable (out: BC = addr, DE = len)
PTRGT2      equ $10D6   ; Get variable - called with first character of name in C
EATEM       equ $10EA   ; Continue PTRGET at skip extra alphanumerics loop
CHKLET      equ $10E4   ; Continue PTRGET at check for letter
ISSEC       equ $10E9   ; Continue PTRGET at skip non-letter
NOSEC       equ $10F2   ; Continue PTRGET at check for '$'
SKIPDS      equ $10FD   ; Continue PTRGET at skip of '$'
BSERR       equ $11CD   ; Bad subscript error
FSUBS       equ $1258   ; Subtract: FACC = (HL) - FACCs
FSUB        equ $125E   ; Subtract: FACC = BCDE - FACC
FADD        equ $1261   ; Add: FACC = BCDE + FACC
FONE        equ $135F   ; Floating point constant 1
FMULT       equ $13CB   ; Multiply: FACC = BCDE * FACC
POPHRT      equ $141A   ; Pop HL and return
FDIV        equ $142F   ; Divide: FACC = BCDE / FACC
FLOAT_NUM   equ $14F6   ; Float signed number in A
FLOATR      equ $14FB   ; Float signed number in B,A,D,E
NEG         equ $150B   ; Negate number in FACC
MOVFM       equ $1520   ; MOVE NUMBER FROM MEMORY [(HL)] TO FAC
MOVFR       equ $1523   ; Move B,C,D,E to FACC
MOVMF       equ $153A   ; MOVE NUMBER FROM FAC TO MEMORY [(HL)]
MOVE        equ $153D   ; Copy 4 bytes from (DE) to (HL)
MOVE1       equ $153F   ; Copy B bytes from (DE) to (HL)
QINT        equ $1586   ; Convert FAC to integer in C,D,E
INT         equ $15B1   ; FACC = INT(FACC)
POPART      equ $15C8   ; Pop AF and return
FIN         equ $15E5   ; Parse floating point number
FIN0        equ $15EE   ; Parse floating point number wihout leading + or -
LINPRT      equ $1675   ; Print Two Byte Number in HL as Decimal - Alters all Registers
INT2STR:    equ $1679   ; Convert 16 bit integer in HL to text at FPSTR (starts with ' ')
FOUT        equ $1680   ; Convert float in FAC to text
PSHNEG      equ $1770   ; Push address of NEG routine on stack
POLYX       equ $1837   ; Polynomial evaluator
PI2         equ $1953   ; Constant: PI / 2
OUTDO       equ $198A   ; Output a Character
OUTCON      equ $198C   ; Output a Character, bypassing hook
CRDO:       equ $19EA   ; Print CR+LF
BUFCIN      equ $1A02   ; Return A as string from function 
NULRT       equ $1A0B   ; Return null string
STRSET      equ $1A0E   ; Put HL in FACLO and 1 in VALTYP
CHARCG      equ $1A18   ; Get saved keypress, check for Ctrl-C
ISCNTC      equ $1A25   ; Check for Ctrl-C and Ctrl-S
ISCNTS      equ $1A29   ; Check for Ctrl-S
TRYIN       equ $1A2F   ; Wait for character from keyboard
CNTCCN      equ $1A39   ; Check for and process Ctrl-C
CNTCCC      equ $1A3C   ; Enter CNTCCN after INCHRH call
WRMCON:     equ $1A40
CNTCCR      equ $1A4A   ; Finish CNTCCN
RSETCC      equ $1A5D   ; Partway into PSET/PRESET`
POINTX      equ $1A69   ; Enter POINT after initial CHRGET
SCAND       equ $1A7F   ; Get parameters for PSET, PRESET, POINT, and SOUND
SCALXY      equ $1A8E   ; Convert PSET Coordinates to Screen Position and Character Mask
BITTAB      equ $1ACA   ; Semigraphic Pixel Index to Bit Mask Table
GETINT      equ $1AD0   ; Parse an Integer
COPY        equ $1B15   ; Execute COPY statement
TTYCHR:     equ $1D72   ; Print character in A with pause/break at end of page
TTYCH:      equ $1D74   ; Print character, bypassing Hook 19
TTYCHP      equ $1D75   ; Enter TTYCH after PUSH AF
TTYOUT:     equ $1D94   ; Print character in A
TTYFIS:     equ $1DE7   ; Finish up TTYOUT
SCROLL      equ $1DFE   ; Scroll screen up one line
TTYMOV      equ $1E1F   ; Move Cursor one character to the right
TTYMOP      equ $1E22   ; Enter TTYMOV after LD HL,(CURRAM)
TTYSAV      equ $1E3E   ; Save Column and Position
TTYCLR      equ $1E45   ; Clear screen (EXX before calling)
SOUNDS      equ $1E64   ; Play frequency DEfor duration BC
INCHRH      equ $1E7E   ; Read key from keyboard
JMPINI:     equ $1FE1   ; Power Up/Reset Routine: Jumped to from RST 0
PRNTIT:     equ $1FF2   ; Print copyright message and return

; Extra variables / functions

; plusBASIC system jump points
SCNLBL  equ     $200F   ;; | Line label hook for GOTO, GOSUB, and RESTORE

XINIT:      equ $E010   ; Cartridge entry point

; Standard BASIC Tokens
FORTK       equ $81     ; FOR
NEXTK       equ $82     ; NEXT
DATATK      equ $83     ; DATA
INPUTK      equ $84     ; INPUT
DIMTK       equ $85     ; DIM
GOTOTK      equ $88     ; GOTO
RUNTK       equ $89     ; RUN
RESTK       equ $8B     ; RESTORE    
GOSUTK      equ $8C     ; GOSUB
RETTK       equ $8D     ; RETURN
ONTK        equ $90     ; ON
DEFTK       equ $93     ; DEF
LISTTK      equ $97     ; LIST
CLRTK       equ $99     ; CLEAR
PLUSTK      equ $A8     ; +
TOTK        equ $A1     ; TO
FNTK        equ $A2     ; FN
MINUTK      equ $A9     ; -
MULTK       equ $AA     ; *
EXPTK       equ $AC     ; ^
ORTK        equ $AE     ; OR
EQUATK      equ $B0     ; = 
LESSTK      equ $B1     ; <
ONEFUN      equ $B2     ; First Function Token
INTTK       equ $B3     ; INT
USRTK       equ $B5     ; USR
POSTK       equ $B8     ; POS
ASCTK       equ $C5     ; ASC

;Adddress of Byte following Hook RST
HOOK0       = $03DF
HOOK1       = $03E7
HOOK2       = $0403
HOOK3       = $0430
HOOK4       = $0481
HOOK5       = $0486
HOOK6       = $07BD
HOOK7       = $0867
HOOK8       = $0881
HOOK9       = $09FE
HOOK10      = $0537
HOOK11      = $0CCE
HOOK12      = $0BBF
HOOK13      = $198B
HOOK14      = $1986
HOOK15      = $0B3C
HOOK16      = $0B41
HOOK17      = $1AE9
HOOK18      = $1E7F
HOOK19      = $1D73
HOOK20      = $1C2D
HOOK21      = $1C09
HOOK22      = $05A1
HOOK23      = $0659
HOOK24      = $06BF
HOOK25      = $0781
HOOK26      = $0894
HOOK27      = $0A60
HOOK28      = $08F1
HOOK29      = $09A3

;-----------------------------------------------------------------------------
; plusBASIC RAM Memory Map
;  12288 =============================         
;                Screen RAM
;  14336 =============================         
;             System Variables
; TXTTAB =============================         
;              BASIC Program
; VARTAB -----------------------------
;             Simple Variables
; ARYTAB -----------------------------
;             Array Variables 
; STREND -----------------------------
;             Unused BASIC RAM  
; STKSAV -----------------------------
;                  Stack                       
; TOPMEM =============================
;           Enhanced Input Buffer
;        -----------------------------
;           String Building Buffer
; STRSPC =============================         
;            String Space in use
; FRETOP -----------------------------    Set by first operand of CLEAR
;            Unused String Space
; MEMSIZ =============================    Set by second operand of CLEAR
;          RAM Reserved using CLEAR
;  49152 =============================
;-----------------------------------------------------------------------------

