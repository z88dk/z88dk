; ****** HVGLIB.H (formally called ballyequ.h) (C)1977,78
; *** Bally Astrocade Equates and Macros Header File ***
; From the nutting_manual and reformatted using Mixed Case
; Version 3.02 - December 29, 2010 thru December 29, 2018
;                by Richard C Degler, combined all updates
;
; > Retyped and proofread by Adam Trionfo and Lance F. Squire
; > Version 1.0 (as ballyequ.h) - January 17, 2002
; > Version 2.52 (Version 1.0 of HVGLIB.H) - March 28, 2003
; > Version 2.6 - March 2, 2004 - as seen on BallyAlley.com
; > Version 3.0 - 2009 Changed "FonT BASE character" comment
; >
; >   This file contains the equates and macros that Bally
; > programs require for assembly.  This file has been
; > written to assemble with ZMAC 1.3 (a freely distribut-
; > able Z-80 assembler (with C source), that has a 25-year
; > history. ZMAC can be compiled under just about any O.S.
; > in existence, so try it out.  This file will probably
; > require changes to be assembled under other assemblers.
; >
; > To assemble your Z-80 source code using ZMAC:
; >
; > zmac -d -o <outfile> -x <listfile> <filename>
; >
; > For example, assemble this Astrocade Z-80 ROM file:
; >   
; > zmac -d -o BallyROM.bin -x BallyROM.lst BallyROM.asm
; >
; >  Currently the Listing file is full of 'Undeclared'
; > errors.  When all of the source is typed-in, these will
; > vanish. I'm leaving the others until all the source is
; > re-typed.
; >
;
; ***************************
; * Home Video Game EQUates *
; ***************************
;
;  ASSEMBLY CONTROL
;
XPNDON  EQU    1          ; ** SET TO 1 WHEN HARDWARE EXP
NWHDWR  EQU    1          ; ** SET TO 1 WHEN NEW HARDWARE
;
; General goodies (HEX and Decimal values):
SCREEN  EQU     $0000   ;     0 ; magic SCREEN start
BYTEPL  EQU     $28     ;    40 ; BYTEs Per Line
BITSPL  EQU     $A0     ;   160 ; PIXelS [not BITS!!] Per Line
FIRSTC  EQU     $2000   ;  8192 ; FIRST address in Cartridge
NORMEM  EQU     $4000   ; 16384 ; NORmal MEMory start [fixed!]
;
; Stuff in SYSTEM DOPE VECTOR (valid for ALL system ROMs):
STIMER  EQU     $0200   ; Seconds and game TIMER, music
CTIMER  EQU     $0203   ; Custom TIMERs
FNTSYS  EQU     $0206   ; FoNT descriptor for SYStem font
FNTSML  EQU     $020D   ; FoNT descriptor for SMaLl font
ALKEYS  EQU     $0214   ; ALl KEYS keypad mask
MENUST  EQU     $0218   ; head of onboard MENU STart
MXSCR   EQU     $021E   ; address of 'MaX SCoRe' text string
NOPLAY  EQU     $0228   ; address of 'Number Of PLAYers' string
NOGAME  EQU     $0235   ; address of 'Number Of GAMEs' string
;
; BITS in PROCESSOR FLAG byte:
PSWCY   EQU     0       ; Processor Status Word, CarrY bit
PSWPV   EQU     2       ; Processor Status Word, Parity or oVerflow bit
PSWZRO  EQU     6       ; Processor Status Word, ZeRO bit
PSWSGN  EQU     7       ; Processor Status Word, SiGN bit
;
; BITS in GAME STATUS Byte:
GSBTIM  EQU     0       ; Game Status Byte, if TIMe is up set end bit
GSBSCR  EQU     1       ; Game Status Byte, if SCoRe reached set end bit
GSBEND  EQU     7       ; Game Status Byte, END flag bit
;
; Standard VECTOR DISPLACEMENTS and bits:
VBMR    EQU     $00     ;  +0   ; Vector Block, Magic Register
VBSTAT  EQU     $01     ;  +1   ; Vector Block, STATus byte
VBTIMB  EQU     $02     ;  +2   ; Vector Block, TIMe Base
VBDXL   EQU     $03     ;  +3   ; Vector Block, Delta for X Low
VBDXH   EQU     $04     ;  +4   ; Vector Block, Delta for X Hi
VBXL    EQU     $05     ;  +5   ; Vector Block, X coord Low
VBXH    EQU     $06     ;  +6   ; Vector Block, X coord Hi
VBXCHK  EQU     $07     ;  +7   ; Vector Block, X CHecK flags
VBDYL   EQU     $08     ;  +8   ; Vector Block, Delta for Y Low
VBDYH   EQU     $09     ;  +9   ; Vector Block, Delta for Y Hi
VBYL    EQU     $0A     ; +10   ; Vector Block, Y coord Low
VBYH    EQU     $0B     ; +11   ; Vector Block, Y coord Hi
VBYCHK  EQU     $0C     ; +12   ; Vector Block, Y CHecK flags
VBOAL   EQU     $0D     ; +13   ; Vector Block, Old Address Low
VBOAH   EQU     $0E     ; +14   ; Vector Block, Old Address Hi
;
; DISPLACEMENTS from start of COORDINATE AREA (X or Y):
VBDCL   EQU     $00     ;  +0   ; Vector Block, Delta for Coord Low
VBDCH   EQU     $01     ;  +1   ; Vector Block, Delta for Coord Hi
VBCL    EQU     $02     ;  +2   ; Vector Block, Coord Low
VBCH    EQU     $03     ;  +3   ; Vector Block, Coord Hi
VBCCHK  EQU     $04     ;  +4   ; Vector Block, Coord CHecK flags
;
; BITS in STATUS byte:
VBBLNK  EQU     6       ; Vector Block status, BLaNK bit
VBSACT  EQU     7       ; Vector Block Status, ACTive bit
;
;  BITS in (X or Y) VB CHECK FLAG bit mask:
VBCLMT  EQU     0       ; Vector Block Check, LiMiT bit
VBCREV  EQU     1       ; Vector Block Check, REVerse delta on limit attain
VBCLAT  EQU     3       ; Vector Block Check, coordinate Limit ATtained
;
; FONT TABLE DISPLACEMENTS for CHARACTER DESCRIPTOR BLOCK:
FTBASE  EQU     $00     ;  +0   ; FonT BASE character (normally $20+$80 ALT)
FTFSX   EQU     $01     ;  +1   ; FonT Frame X Size width
FTFSY   EQU     $02     ;  +2   ; FonT Frame Y Size height
FTBYTE  EQU     $03     ;  +3   ; FonT X size for char in BYTEs
FTYSIZ  EQU     $04     ;  +4   ; FonT Y SIZe height in rows
FTPTL   EQU     $05     ;  +5   ; FonT Pattern Table address Low
FTPTH   EQU     $06     ;  +6   ; FonT Pattern Table address Hi
;
; BITS for MAGIC REGISTER (write option) byte:
MRSHFT  EQU     $03     ; Magic Register, mask of SHiFT amount 0-3
MRROT   EQU     2       ; Magic Register, write with ROTata bit
MRXPND  EQU     3       ; Magic Register, write with eXPaND bit
MROR    EQU     4       ; Magic Register, write with OR bit
MRXOR   EQU     5       ; Magic Register, write with eXclusive-OR bit
MRFLOP  EQU     6       ; Magic Register, write with FLOP bit
;
; BITS of CONTROL HANDLE Input port:
CHUP    EQU     0       ; Control Handle, UP bit
CHDOWN  EQU     1       ; Control Handle, DOWN bit
CHLEFT  EQU     2       ; Control Handle, joystick LEFT bit
CHRIGH  EQU     3       ; Control Handle, joystick RIGHT bit
CHTRIG  EQU     4       ; Control Handle, TRIGger bit
;
; CONTEXT BLOCK Register DISPLACEMENTS:
CBIYL   EQU     $00     ;  +0   ; Context Block, IY register Low
CBIYH   EQU     $01     ;  +1   ; Context Block, IY register Hi
CBIXL   EQU     $02     ;  +2   ; Context Block, IX register Low
CBIXH   EQU     $03     ;  +3   ; Context Block, IX register Hi
CBE     EQU     $04     ;  +4   ; Context Block, E register
CBD     EQU     $05     ;  +5   ; Context Block, D register
CBC     EQU     $06     ;  +6   ; Context Block, C register
CBB     EQU     $07     ;  +7   ; Context Block, B register
CBFLAG  EQU     $08     ;  +8   ; Context Block, FLAGs register
CBA     EQU     $09     ;  +9   ; Context Block, A register
CBL     EQU     $0A     ; +10   ; Context Block, L register
CBH     EQU     $0B     ; +11   ; Context Block, H register
;
; SENTRY RETURN Codes EQUates:
SNUL    EQU     $00     ; Sentry return NULl, nothing happened
SCT0    EQU     $01     ; Sentry, Counter-Timer 0 has counted down
SCT1    EQU     $02     ; Sentry, Counter-Timer 1 has counted down
SCT2    EQU     $03     ; Sentry, Counter-Timer 2 has counted down
SCT3    EQU     $04     ; Sentry, Counter-Timer 3 has counted down
SCT4    EQU     $05     ; Sentry, Counter-Timer 4 has counted down
SCT5    EQU     $06     ; Sentry, Counter-Timer 5 has counted down
SCT6    EQU     $07     ; Sentry, Counter-Timer 6 has counted down
SCT7    EQU     $08     ; Sentry, Counter-Timer 7 has counted down
SF0     EQU     $09     ; Sentry, Flag bit 0 has changed
SF1     EQU     $0A     ; Sentry, Flag bit 1 has changed
SF2     EQU     $0B     ; Sentry, Flag bit 2 has changed
SF3     EQU     $0C     ; Sentry, Flag bit 3 has changed
SF4     EQU     $0D     ; Sentry, Flag bit 4 has changed
SF5     EQU     $0E     ; Sentry, Flag bit 5 has changed
SF6     EQU     $0F     ; Sentry, Flag bit 6 has changed
SF7     EQU     $10     ; Sentry, Flag bit 7 has changed
SSEC    EQU     $11     ; Sentry, SEConds timer has counted down
SKYU    EQU     $12     ; Sentry, KeY is now Up
SKYD    EQU     $13     ; Sentry, KeY is now Down
ST0     EQU     $14     ; Sentry, Trigger 0 for player 1 has changed
SJ0     EQU     $15     ; Sentry, Joystick 0 for player 1 has changed
ST1     EQU     $16     ; Sentry, Trigger 1 for player 2 has changed
SJ1     EQU     $17     ; Sentry, Joystick 1 for player 2 has changed
ST2     EQU     $18     ; Sentry, Trigger 2 for player 3 has changed
SJ2     EQU     $19     ; Sentry, Joystick 2 for player 3 has changed
ST3     EQU     $1A     ; Sentry, Trigger 3 for player 4 has changed
SJ3     EQU     $1B     ; Sentry, Joystick 3 for player 4 has changed
SP0     EQU     $1C     ; Sentry, POTentiometer 0 has changed
SP1     EQU     $1D     ; Sentry, POTentiometer 1 has changed
SP2     EQU     $1E     ; Sentry, POTentiometer 2 has changed
SP3     EQU     $1F     ; Sentry, POTentiometer 3 has changed
;
;
; ********************************
; * Home Video Game PORT EQUates *
; ********************************
;
; INTERRUPT and INTERCEPT INPUT Ports:
INTST   EQU     $08     ; =&(8) ; read INTercept STatus
VERAF   EQU     $0E     ;=&(14) ; read VERtical Address Feedback
HORAF   EQU     $0F     ;=&(15) ; read HORizontal Address Feedback
;
; HAND CONTROL INPUT Ports:
SW0     EQU     $10     ;=&(16) ; read SWitch bank 0 for player 1 hand control
SW1     EQU     $11     ;=&(17) ; read SWitch bank 1 for player 2 hand control
SW2     EQU     $12     ;=&(18) ; read SWitch bank 2 for player 3 hand control
SW3     EQU     $13     ;=&(19) ; read SWitch bank 3 for player 4 hand control
POT0    EQU     $1C     ;=&(28) ; read POTentiometer 0 for player 1 knob
POT1    EQU     $1D     ;=&(29) ; read POTentiometer 1 for player 2 knob
POT2    EQU     $1E     ;=&(30) ; read POTentiometer 2 for player 3 knob
POT3    EQU     $1F     ;=&(31) ; read POTentiometer 3 for player 4 knob
;
; KEYBOARD INPUT Ports:
KEY0    EQU     $14     ;=&(20) ; KEYboard column 0 (right side)
KEY1    EQU     $15     ;=&(21) ; KEYboard column 1 (center right)
KEY2    EQU     $16     ;=&(22) ; KEYboard column 2 (center left)
KEY3    EQU     $17     ;=&(23) ; KEYboard column 3 (left side)
;
;
; OUTPUT Ports for VIRTUAL COLOR:
COL0R   EQU     $00     ; &(0)= ; write COLor 0 Right
COL1R   EQU     $01     ; &(1)= ; write COLor 1 Right
COL2R   EQU     $02     ; &(2)= ; write COLor 2 Right
COL3R   EQU     $03     ; &(3)= ; write COLor 3 Right
COL0L   EQU     $04     ; &(4)= ; write COLor 0 Left
COL1L   EQU     $05     ; &(5)= ; write COLor 1 Left
COL2L   EQU     $06     ; &(6)= ; write COLor 2 Left
COL3L   EQU     $07     ; &(7)= ; write COLor 3 Left
HORCB   EQU     $09     ; &(9)= ; write HORizontal Color Boundary
VERBL   EQU     $0A     ;&(10)= ; write VERtical Blanking Line
COLBX   EQU     $0B     ;&(11)= ; write COLor BloCK multi-port
;
; INTERRUPT and CONTROL OUTPUT Ports:
CONCM   EQU     $08     ; &(8)= ; write 0 for CONsumer, 1 for CoMmercial mode
MAGIC   EQU     $0C     ;&(12)= ; write MAGIC register
INFBK   EQU     $0D     ;&(13)= ; write INterrupt FeedBacK
INMOD   EQU     $0E     ;&(14)= ; write INterrupt MODe
INLIN   EQU     $0F     ;&(15)= ; write INterrupt LINe
XPAND   EQU     $19     ;&(25)= ; eXPANDer pixel definition port
;
; OUTPUT Ports for MUSIC and SOUNDS:
TONMO   EQU     $10     ;&(16)= ; write TONe Master Oscillator
TONEA   EQU     $11     ;&(17)= ; write TONe A oscillator
TONEB   EQU     $12     ;&(18)= ; write TONe B oscillator
TONEC   EQU     $13     ;&(19)= ; write TONe C oscillator
VIBRA   EQU     $14     ;&(20)= ; write VIBRAto frequency & range
VOLC    EQU     $15     ;&(21)= ; write VOLume of tone C
VOLAB   EQU     $16     ;&(22)= ; write VOLumes of tones A & B
VOLN    EQU     $17     ;&(23)= ; write VOLume of Noise
SNDBX   EQU     $18     ;&(24)= ; write SouND BloCK multi-port
;
;
; ***************************************
; * Home Video Game SYSTEM CALL Indexes *
; ***************************************
;
; USER PROGRAM Interface:
INTPC   EQU     $00     ;  # 0  ; INTerPret with Context create
XINTC   EQU     $02     ;  # 2  ; eXit INTerpreter with Context
RCALL   EQU     $04     ;  # 4  ; Real CALL asm language subroutine
MCALL   EQU     $06     ;  # 6  ; Macro CALL interpreter subroutine
MRET    EQU     $08     ;  # 8  ; Macro RETurn from interpreter subroutine
MJUMP   EQU     $0A     ; # 10  ; Macro JUMP to interpreter subroutine
SUCK    EQU     $0C     ; # 12  ; SUCK inline args into context block
;
; SCHEDULER Routines:
ACTINT  EQU     $0E     ; # 14  ; ACTivate sub timer INTerrupts
DECCTS  EQU     $10     ; # 16  ; DECrement CT'S under mask
;
; MUSIC and SOUNDS:
BMUSIC  EQU     $12     ; # 18  ; Begin playing MUSIC
EMUSIC  EQU     $14     ; # 20  ; End playing MUSIC
;
; SCREEN HANDLER Routines:
SETOUT  EQU     $16     ; # 22  ; SET some OUTput ports
COLSET  EQU     $18     ; # 24  ; COLors SET
FILL    EQU     $1A     ; # 26  ; FILL memory with data
RECTAN  EQU     $1C     ; # 28  ; paint a RECTANgle
VWRITR  EQU     $1E     ; # 30  ; Vector WRITe Relative
WRITR   EQU     $20     ; # 32  ; WRITe Relative
WRITP   EQU     $22     ; # 34  ; WRITe with Pattern size lookup
WRIT    EQU     $24     ; # 36  ; WRITe with sizes provided
WRITA   EQU     $26     ; # 38  ; WRITe Absolute
VBLANK  EQU     $28     ; # 40  ; Vector BLANK area
BLANK   EQU     $2A     ; # 42  ; BLANK area
SAVE    EQU     $2C     ; # 44  ; SAVE area
RESTOR  EQU     $2E     ; # 46  ; RESTORe area
SCROLL  EQU     $30     ; # 48  ; SCROLL area of screen
;
CHRDIS  EQU     $32     ; # 50  ; CHaRacter DISplay
STRDIS  EQU     $34     ; # 52  ; STRing DISplay
DISNUM  EQU     $36     ; # 54  ; DISplay NUMber
;
RELABS  EQU     $38     ; # 56  ; RELative to ABSolute conversion
RELAB1  EQU     $3A     ; # 58  ; RELative to non-magic ABSolute
VECTC   EQU     $3C     ; # 60  ; VECTor move single Coordinate
VECT    EQU     $3E     ; # 62  ; VECTor move coordinate pair
;
; HUMAN INTERFACE Routines:
KCTASC  EQU     $40     ; # 64  ; Key Code in B To ASCii
SENTRY  EQU     $42     ; # 66  ; SENse TRansition Y
DOIT    EQU     $44     ; # 68  ; DOIT table, branch to translation handler
DOITB   EQU     $46     ; # 70  ; DOIT table, use B instead of A
PIZBRK  EQU     $48     ; # 72  ; take a PIZza BReaK
MENU    EQU     $4A     ; # 74  ; display a MENU
GETPAR  EQU     $4C     ; # 76  ; GET game PARameter from user
GETNUM  EQU     $4E     ; # 78  ; GET NUMber from user
PAWS    EQU     $50     ; # 80  ; PAUSE
DISTIM  EQU     $52     ; # 82  ; DISplay TIMe
INCSCR  EQU     $54     ; # 84  ; INCrement SCoRe
;
; MATH Routines:
INDEXN  EQU     $56     ; # 86  ; INDEX Nibble by C
STOREN  EQU     $58     ; # 88  ; STORE Nibble in A by C
INDEXW  EQU     $5A     ; # 90  ; INDEX Word by A
INDEXB  EQU     $5C     ; # 92  ; INDEX Byte by A
MOVE    EQU     $5E     ; # 94  ; MOVE block transfer
SHIFTU  EQU     $60     ; # 96  ; SHIFT Up digit in A
BCDADD  EQU     $62     ; # 98  ; BCD ADDition
BCDSUB  EQU     $64     ;# 100  ; BCD SUBtraction
BCDMUL  EQU     $66     ;# 102  ; BCD MULtiplication
BCDDIV  EQU     $68     ;# 104  ; BCD DIVision
BCDCHS  EQU     $6A     ;# 106  ; BCD CHange Sign
BCDNEG  EQU     $6C     ;# 108  ; BCD NEGate to decimal
DADD    EQU     $6E     ;# 110  ; Decimal ADDition
DSMG    EQU     $70     ;# 112  ; Decimal convert to Sign MaGnitude
DABS    EQU     $72     ;# 114  ; Decimal ABSolute value
NEGT    EQU     $74     ;# 116  ; decimal NEGaTe
RANGED  EQU     $76     ;# 118  ; RANGED random number
QUIT    EQU     $78     ;# 120  ; QUIT cartridge execution
SETB    EQU     $7A     ;# 122  ; SET Byte
SETW    EQU     $7C     ;# 124  ; SET Word
MSKTD   EQU     $7E     ;# 127  ; MaSK joystick in B To Deltas
;
;
; **********
; * MACROS *
; **********
; Assembler directives in lower case to distinguish from OPCODEs.
;
; MACROs to define PATTERNs:
DEF2    macro   AA,AB
        DB      AA
        DB      AB
        endm
DEF3    macro   BA,BB,BCC
        DB      BA
        DB      BB
        DB      BCC     ; 'BC' reserved, so used 'BCC'
        endm
DEF4    macro   CA,CB,CC,CD
        DB      CA
        DB      CB
        DB      CC
        DB      CD
        endm
DEF5    macro   DA,DBB,DC,DD,DEE
        DB      DA
        DB      DBB
        DB      DC
        DB      DD
        DB      DEE
        endm
DEF6    macro   EA,EB,EC,ED,EE,EF
        DB      EA
        DB      EB
        DB      EC
        DB      ED
        DB      EE
        DB      EF
        endm
DEF8    macro   GA,GB,GC,GD,GEE,GF,GG,GH
        DB      GA
        DB      GB
        DB      GC
        DB      GD
        DB      GEE     ; 'GE' reserved, so used 'GEE'
        DB      GF
        DB      GG
        DB      GH
        endm
;
; MACRO to compute CONSTANT SCREEN Addresses:
XYRELL  macro   p1,p2,p3  ; RELative LOAD
        LD      p1,[(p3 SHL 8) + p2]
        endm
;
; MACROs to generate SYSTEM CALLs:
SYSTEM  macro   NUMBA
        RST     $38
        DB      NUMBA
        if      NUMBA = INTPC
                INTPCC  DEFL    1
        endif
        endm
; MACRO to generate SYSTEM CALL with SUCK option ON:
SYSSUK  macro   UMBA
        RST     $38
        DB      UMBA + 1
        if      UMBA = INTPC
                INTPCC  DEFL    1
        endif
        endm
;
; MACROs to generate MACRO INTERPRETER CALLs:
; INTERPRET without INLINE SUCK:
DONT    macro   CID
        DB      CID
        endm
; INTERPRET with INLINE SUCK option ON:
DO      macro   CID
        DB      CID + 1
        endm
;
; FILL screen with constant data (was 'FILL?'):
FILLq   macro   START,NBYTES,DATA
        DB      FILL + 1
        DW      START
        DW      NBYTES
        DB      DATA
        endm
; DISPLAY a STRING: (only inside interpreter?)
TEXTD   macro   AA,BB,CC,DD
        DB      STRDIS + 1
        DB      BB
        DB      CC
        DB      DD
        DW      AA
        endm
;
; EXIT interpreter with context restore:
EXIT    macro
        DB      XINTC
        INTPCC  DEFL    0
        endm
;
ENDx    EQU     $C0     ; END of DOIT Table
;
; MACRO CALLs from DOIT Table (only):
MC      macro   AA, BB, EE
        DB      AA + $80
        DW      BB
        if      EE = ENDx
                DB      EE
        endif
        endm
; REAL CALL from DOIT Table:
RC      macro   AA,BB,EE
        DB      AA + $40
        DW      BB
        if      EE = ENDx
                DB      EE
        endif
        endm
; REAL JUMP from DOIT Table:
JMPd    macro   AA,BB,EE
        DB      AA
        DW      BB
        if      EE = ENDx
                DB      EE
        endif
        endm
;
;**************
; MUSIC MACROS:
; $00 to $7F = NOTE DURation, FREQuency(s):
NOTE1   macro   DUR,N1
        DB      (DUR) AND ($7F)
        DB      N1
        endm
NOTE2   macro   DUR,N1,N2
        DB      (DUR) AND ($7F)
        DB      N1
        DB      N2
        endm
NOTE3   macro   DUR,N1,N2,N3
        DB      (DUR) AND ($7F)
        DB      N1
        DB      N2
        DB      N3
        endm
NOTE4   macro   DUR,N1,N2,N3,N4
        DB      (DUR) AND ($7F)
        DB      N1
        DB      N2
        DB      N3
        DB      N4
        endm
NOTE5   macro   DUR,N1,N2,N3,N4,N5
        DB      (DUR) AND ($7F)
        DB      N1
        DB      N2
        DB      N3
        DB      N4
        DB      N5
        endm
; $80 = Set MASTER Osc, Offset:
MASTER  macro   OFFSET
        DB      $80
        DB      OFFSET
        endm
; $80 to $88 = Stuff OUTPUT Port# (0 to 7 only!), Data
; or OUTPUT SNDBX, Data10, D11,..., Data17:
OUTPUT  macro   PORT,D0,D1,D2,D3,D4,D5,D6,D7
        if PORT != $18
                DB      $80 + ((PORT) AND ($7F))
                DB      D0      ; <-- D0 is NOT $D0
        else    ; on PORT = $18
                DB      $88
                DEF8    D7,D6,D5,D4,D3,D2,D1,D0
        endif
        endm
; $90 = Set VOICE MASK byte:
; The format of the Voice MASK is:
;    * I * A * I * B * I * C * V * N *
; bit  7   6   5   4   3   2   1   0
; read right-to-left, where I = INC PC and
; A, B, or C = load TONE A,B,C with data at PC
; V = load Vibrato with data at PC and INC PC
; N = load Noise with data at PC and INC PC
VOICEM  macro   MASK    ; 'VOICES' TO 'VOICEM'
        DB      $90
        DB      MASK
        endm
; $A0 to $AF = PUSH Number 1 to 16 onto music stack:
PUSHN   macro   NUMB
        DB      $A0 + ((NUMB-1) AND $0F)
        endm
; $BO = Set VOLUMEs:
VOLUME  macro   P1,P2
        DB      $B0
        DB      P1
        DB      P2
        endm
; $C0 = Dec Stack top and JNZ:
DSJNZ   macro   ADD_IT
        DB      $C0
        DW      ADD_IT
        endm
; note: Music Processor also uses standard codes as $C3 for
; music JumP, $C9 for music RETurn, and $CD for music CALL.
;
; $D0 = Call RELative self+1 plus 0 to 15:
CREL    macro   BY
        DB      $D0 + (BY AND $0F)
        endm
; $E0 = Flip LEGatto to STAcato:
LEGSTA  macro
        DB      $E0
        endm
REST    macro   TIME
        DB      $E1
        DB      TIME
        endm
QUIET   macro
        DB      $F0
        endm
;
;
; *****************
; * MUSIC EQUATES *
; *****************
; NOTE Values:
G0      EQU     $FD     ; 253
GS0     EQU     $EE     ; 238
A0      EQU     $E1     ; 225
AS0     EQU     $D4     ; 212
B0      EQU     $C8     ; 200
C1      EQU     $BD     ; 189
CS1     EQU     $B2     ; 178
D1      EQU     $A8     ; 168
DS1     EQU     $9F     ; 159
E1      EQU     $96     ; 150
F1      EQU     $8D     ; 141
FS1     EQU     $85     ; 133
G1      EQU     $7E     ; 126
GS1     EQU     $77     ; 119
A1      EQU     $70     ; 112
AS1     EQU     $6A     ; 106
B1      EQU     $64     ; 100
C2      EQU     $5E     ;  94
CS2     EQU     $59     ;  89
D2      EQU     $54     ;  84
DS2     EQU     $4F     ;  79
E2      EQU     $4A     ;  74
F2      EQU     $46     ;  70
FS2     EQU     $42     ;  66
G2      EQU     $3E     ;  62
GS2     EQU     $3B     ;  59
A2      EQU     $37     ;  55
AS2     EQU     $34     ;  52
B2      EQU     $31     ;  49
C3      EQU     $2E     ;  46
CS3     EQU     $2C     ;  44
D3      EQU     $29     ;  41
DS3     EQU     $27     ;  39
E3      EQU     $25     ;  37
F3      EQU     $22     ;  34
FS3     EQU     $20     ;  32
G3      EQU     $1F     ;  31
GS3     EQU     $1D     ;  29
A3      EQU     $1B     ;  27
AS3     EQU     $1A     ;  26
B3      EQU     $18     ;  24
C4      EQU     $17     ;  23
CS4     EQU     $15     ;  21
D4      EQU     $14     ;  20
DS4     EQU     $13     ;  19
E4      EQU     $12     ;  18
F4      EQU     $11     ;  17
FS4     EQU     $10     ;  16
G4      EQU     $0F     ;  15
GS4     EQU     $0E     ;  14
A4      EQU     $0D     ;  13
C5      EQU     $0B     ;  11
CS5     EQU     $0A     ;  10
DS5     EQU     $09     ;   9
F5      EQU     $08     ;   8
G5      EQU     $07     ;   7
A5      EQU     $06     ;   6
C6      EQU     $05     ;   5
DS6     EQU     $04     ;   4
G6      EQU     $03     ;   3
C7      EQU     $02     ;   2
G7      EQU     $01     ;   1
G8      EQU     $00     ;   0
;
; MASTER OSCILATOR Offsets:
OB0     EQU     $FE     ; 254
OC0     EQU     $F1     ; 241
OD1     EQU     $D6     ; 214
OE1     EQU     $BF     ; 191
OF1     EQU     $B4     ; 180
OG1     EQU     $A0     ; 160
OA1     EQU     $8F     ; 143
OA2     EQU     $47     ;  71
OA3     EQU     $23     ;  35
OA4     EQU     $11     ;  17
OA5     EQU     $08     ;   8
;
;
; ***************************
; * SYSTEM RAM MEMORY Cells *
; ***************************
URINAL  EQU     $0FFF   ; STUPID MEMORY CELL
WASTE   EQU     URINAL
WASTER  EQU     WASTE   ; ** LOU HARPS CLEAN AND WHOLESOME TAG **
;
SYSRAM  EQU     $4FCE   ; Resides at the highest possible address
BEGRAM  EQU     SYSRAM  ; typically used for initial Stack Pointer
; Used by MUSIC PROCESSOR:
MUZPC   EQU     $4FCE   ; MUSic Program Counter
MUZSP   EQU     $4FD0   ; MUSic Stack Pointer
PVOLAB  EQU     $4FD2   ; Preset VOLume for tones A and B
PVOLMC  EQU     $4FD3   ; Preset VOLuMe for tone C and Noise Mode
VOICES  EQU     $4FD4   ; music VOICES mask
; COUNTER TIMERS (used by DECCTS,ACTINT,CTIMER):
CT0     EQU     $4FD5   ; Counter Timer 0
CT1     EQU     $4FD6   ; Counter Timer 1
CT2     EQU     $4FD7   ; Counter Timer 2
CT3     EQU     $4FD8   ; Counter Timer 3
CT4     EQU     $4FD9   ; Counter Timer 4
CT5     EQU     $4FDA   ; Counter Timer 5
CT6     EQU     $4FDB   ; Counter Timer 6
CT7     EQU     $4FDC   ; Counter Timer 7
;Used by SENTRY to track controls:
CNT     EQU     $4FDD   ; Counter Update & Number Tracking
SEMI4S  EQU     $4FDE   ; SEMAPHORE flag bitS
OPOT0   EQU     $4FDF   ; Old POT 0 tracking byte
OPOT1   EQU     $4FE0   ; Old POT 1 tracking byte
OPOT2   EQU     $4FE1   ; Old POT 2 tracking byte
OPOT3   EQU     $4FE2   ; Old POT 3 tracking byte
KEYSEX  EQU     $4FE3   ; KEYS-EX tracking byte
OSW0    EQU     $4FE4   ; Old SWitch 0 tracking byte
OSW1    EQU     $4FE5   ; Old SWitch 1 tracking byte
OSW2    EQU     $4FE6   ; Old SWitch 2 tracking byte
OSW3    EQU     $4FE7   ; Old SWitch 3 tracking byte
COLLST  EQU     $4FE8   ; COLset LaST address for P.B. A
; Used by STIMER:
DURAT   EQU     $4FEA   ; note DURATion
TMR60   EQU     $4FEB   ; TiMeR for SIXTY'ths of sec
TIMOUT  EQU     $4FEC   ; TIMer for blackOUT
GTSECS  EQU     $4FED   ; Game Time SECondS
GTMINS  EQU     $4FEE   ; Game Time MINuteS
; Used by MENU:
RANSHT  EQU     $4FEF   ; RANdom number SHifT register
NUMPLY  EQU     $4FF3   ; NUMber of PLaYers
ENDSCR  EQU     $4FF4   ; END SCoRe to 'play to'
MRLOCK  EQU     $4FF7   ; Magic Register LOCK out flag
GAMSTB  EQU     $4FF8   ; GAMe STatus Byte
PRIOR   EQU     $4FF9   ; PRIOR music protect flag
SENFLG  EQU     $4FFA   ; SENtry control seizure FLaG
; User UPI Routines, even numbers from $80 to $FE ( + 1 for SUCK):
UMARGT  EQU     $4FFB   ; User Mask ARGument Table + (routine / 2)
USERTB  EQU     $4FFD   ; USER Table Base + routine = JumP address
;
CRAPPER EQU     $4FFF   ; URINAL flushes here!
;
