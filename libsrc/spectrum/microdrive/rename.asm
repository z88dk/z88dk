; MICRODRIVE RENAME
; (C) A.PENNELL 1984
;
        ORG  28000

.SETUP  RST  8
        DEFB $31 ;make vars
        LD   HL,NEWSYN
        LD   (VECTOR),HL ;change VECTOR
        LD   HL,WATROM
        LD   (HD_11),HL
        RST  8
        DEFB $32 ;call WATROM to modify CALLs
        LD   BC,0
        RET
 ; modify routine for different ROMs
.WATROM LD   HL,OLDROM
        LD   A,($16DA)
        CP   $FF
        JR   Z,YESOLD
        LD   HL,NEWROM ;to suit new ROM
.YESOLD LD   B,5 ;no of CALLs to alter
.REDOLP LD   E,(HL)
        INC  HL
        LD   D,(HL) ;DE=CALL+1
        INC  HL
        LD   A,(HL)
        LD   (DE),A
        INC  HL
        LD   A,(HL)
        INC  DE
        LD   (DE),A ;alter CALL
        INC  HL
        DJNZ REDOLP
        RET
 ; data table for old ROM
.OLDROM DEFW L1+1,$1B29 ;OPEN_M
        DEFW L2+1,$15AC ;LDBYTS
        DEFW L3+1,$12A9 ;CLOSEM
        DEFW L4+1,$14EE ;SVBYTS
        DEFW L5+1,$1D6E ;ERASEM
 ; data table for new ROM
.NEWROM DEFW L1+1,$1B05 ;OPEN_M
        DEFW L2+1,$199D ;LDBYTS
        DEFW L3+1,$138E ;CLOSEM
        DEFW L4+1,$18DF ;SVBYTS
        DEFW L5+1,$1D79 ;ERASEM
.SYNERR JP   $28 ;syntax error
 ; new command routine
.NEWSYN ADD  A,206
        CP   "*"
        JP   NZ,$01F0 ;check "*"
        RST  $10
        DEFW $20 ;next-char
        OR   $20 ;make it lower case
        CP   "r"
        JR   NZ,SYNERR
        RST  $10
        DEFW $20
        CALL $061E ;do drive no
        CP   ";"
        JR   NZ,SYNERR
        CALL $062F ;do old name
        CP   204 ;"TO"
        JR   NZ,SYNERR
        CALL SWOP
        CALL $062F ;do new name
        CALL $05B7 ;check end
        CALL SWOP
        LD   HL,(T_STR1)
        PUSH HL ;save start on stack
.L1     CALL OPEN_M
        POP  HL
        LD   (T_STR1),HL ;restore start
        BIT  0,(IX+24)
        JR   Z,FOUND
        RST  $20
        DEFB $11 ;"File not found"
.FOUND  IN   A,($EF)
        AND  1
        JR   NZ,NPROT
        RST  $20
        DEFB $0E ;"Write protected"
.NPROT  BIT  2,(IX+67)
        JR   NZ,NPRINT
        RST  $20
        DEFB $16 ;"Wrong file type"
.NPRINT PUSH IX
        POP  HL
        LD   DE,82
        ADD  HL,DE ;=1st byte in header
        LD   DE,FREE
        LD   BC,9
        LDIR ;copy header to FREE
        LD   (HD_0D),DE ;start=FREE+9
        LD   HL,FREE+9
        LD   DE,(FREE+1) ;=file length
        ADD  HL,DE
        JR   NC,L2 ;if it will fit
        LD   (IY+0),3 ;"Out of memory"
        RST  $28 ;do BASIC ROM error
.L2     CALL LDBYTS ;load the file
.L3     CALL CLOSEM ;close the channel
        LD   HL,FREE
        LD   DE,HD_00
        LD   BC,9
        LDIR ;copy header to HD_00 etc
        CALL SWOP
        LD   HL,FREE+9
        LD   ($5CE4),HL ;new start
.L4     CALL SVBYTS ;save data & close channel
        CALL SWOP
.L5     CALL ERASEM ;erase old file
        JP   $05C1 ;then exit
 ;
 ; Swop contents of N_STR1 & T_STR1 with 3
.SWOP   LD   HL,N_STR1
        LD   DE,N_STR3
        LD   B,4
        JP   $05A7
.N_STR3 DEFW 0
.T_STR3 DEFW 0
.FREE   NOP

 ; CONSTANTS
 VECTOR EQU  $5CB7
 N_STR1 EQU  $5CDA
 T_STR1 EQU  $5CDC
 N_STR2 EQU  $5CE2
 T_STR2 EQU  $5CE4
 HD_00  EQU  $5CE6
 HD_0B  EQU  $5CE7
 HD_OD  EQU  $5CE9
 HD_11  EQU  $5CED
 ; (NEW) SHADOW ROM ROUTINES
 ERASEM EQU  $1D79
 OPEN_M EQU  $1B05
 LDBYTS EQU  $199D
 SVBYTS EQU  $18DF
 CLOSEM EQU  $138E


