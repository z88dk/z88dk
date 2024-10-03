        #define     HEADER 1
;Vortex Tracker II v1.0 PT3 player for ZX Spectrum
;(c)2004,2007 S.V.Bulba <vorobey@mail.khstu.ru>
;http://bulba.untergrund.net (http://bulba.at.kz)

;Release number
Release EQU     '7'

;Features
;--------
;-Can be compiled at any address (i.e. no need rounding ORG
; address).
;-Variables (VARS) can be located at any address (not only after
;code block).
;-INIT subroutine detects module version and rightly generates
; both note and volume tables outside of code block (in VARS).
;-Two portamento (spc. command 3xxx) algorithms (depending of
; module version).
;-New 1.XX and 2.XX special command behaviour (only for PT v3.7
; and higher).
;-Any Tempo value are accepted (including Tempo=1 and Tempo=2).
;-Fully compatible with Ay_Emul PT3 player codes.
;-See also notes at the end of this source code.

;Limitations
;-----------
;-Can run in RAM only (self-modified code is used).

;Warning!!! PLAY subroutine can crash if no module are loaded
;into RAM or INIT subroutine was not called before.

;Call MUTE or INIT one more time to mute sound after stopping
;playing

PT3Player_DecodeB   equ PT3Player_Decode
PT3Player_IsDoneB   equ PT3Player_IsDone
PT3Player_PauseB    equ PT3Player_Pause
PT3Player_PlaySongB equ PT3Player_PlaySong
SETUPB  equ     SETUP

        public  AYREGSB
        public  PT3Player_DecodeB
        public  PT3Player_IsDoneB
        public  PT3Player_PauseB
        public  PT3Player_PlaySongB
        public  SETUPB
;        public  chainLoop
;        public  chainSong

        section code_user

TonA    EQU     0
TonB    EQU     2
TonC    EQU     4
Noise   EQU     6
Mixer   EQU     7
AmplA   EQU     8
AmplB   EQU     9
AmplC   EQU     10
Env     EQU     11
EnvTp   EQU     13

;ChannelsVars
;	STRUCT	CHP
;reset group
PsInOr  EQU     0
PsInSm  EQU     1
CrAmSl  EQU     2
CrNsSl  EQU     3
CrEnSl  EQU     4
TSlCnt  EQU     5
CrTnSl  EQU     6
TnAcc   EQU     8
COnOff  EQU     10
;reset group

OnOffD  EQU     11

;IX for PTDECOD here (+12)
OffOnD  EQU     12
OrnPtr  EQU     13
SamPtr  EQU     15
NNtSkp  EQU     17
Note    EQU     18
SlToNt  EQU     19
Env_En  EQU     20
Flags   EQU     21
 ;Enabled - 0,SimpleGliss - 2
TnSlDl  EQU     22
TSlStp  EQU     23
TnDelt  EQU     25
NtSkCn  EQU     27
Volume  EQU     28
;	ENDS
CHP     EQU     29

;Identifier
;        DB      "=VTII PT3 Player r.", Release, "="

PT3Player_IsDone:
        ld      hl, SETUP
        bit     6, (hl)
        ret     z
        res     6, (hl)
        ret

PT3Player_Pause:
        DI
        LD      HL, SETUP
        RES     1, (HL)                 ; Stop the decoder
        ; Reset amplitude of all channels
        XOR     A
        LD      H, A
        LD      L, A
        LD      (AYREGSB+AmplA), A
        LD      (AYREGSB+AmplB), HL     ; Covers channel B & C
        EI
        RET

CHECKLP:
        LD      HL, SETUP
        SET     7, (HL)
        BIT     0, (HL)
        RET     Z
        POP     HL                      ; Remove return address

        ; Finished playing current song
        LD      A, $40
        ld      (SETUP), a

		; Check for chain
        LD      A, (chainSong+1)
        OR      A
        JR      NZ, chain

        LD      HL, DelyCnt
        INC     (HL)
        LD      HL, ChanA+NtSkCn
        INC     (HL)
        XOR     A
        LD      H, A
        LD      L, A
        LD      (AYREGSB+AmplA), A
        LD      (AYREGSB+AmplB), HL
        RET

chain:
        LD      HL, (chainSong)
        XOR     A
        ld      (chainSong+1), A
        LD      A, (chainLoop)
        JP      INIT


        ;
        ; Start a new song playing.
        ;
        ; Input:
        ;   hl  -   Pointer to song data
        ;   a   -   1 = No loop, 0 = Loop
        ;
PT3Player_PlaySong:
        DI
        CALL    INIT
        LD      A, (SETUP)
        AND     ~$40
        LD      (SETUP), A
        EI
        RET

INIT:
;HL - AddressOfModule
  IF    !HEADER
        LD      DE, 100
        SBC     HL, DE
  ENDIF
        LD      (MODADDR), HL
        LD      (MDADDR2), HL
        PUSH    HL
        LD      C, A
        LD      A, (SETUP)
        AND     $40
        OR      2                       ; Set bit 1
        OR      C                       ; Set loop
        LD      (SETUP), A
  IF    HEADER
        LD      DE, 100
  ENDIF
        ADD     HL, DE
        LD      A, (HL)
        LD      (Delay), A
        PUSH    HL
        POP     IX
        ADD     HL, DE
        LD      (CrPsPtr), HL
        LD      E, (IX+102-100)
        ADD     HL, DE
        INC     HL
        LD      (LPosPtr), HL
        POP     DE
        LD      L, (IX+103-100)
        LD      H, (IX+104-100)
        ADD     HL, DE
        LD      (PatsPtr), HL
        LD      HL, 169
        ADD     HL, DE
        LD      (OrnPtrs), HL
        LD      HL, 105
        ADD     HL, DE
        LD      (SamPtrs), HL
        LD      HL, SETUP
        RES     7, (HL)

  IF    HEADER
;note table data depacker
        LD      DE, T_PACK
        LD      BC, T1_+(2*49)-1
TP_0:   LD      A, (DE)
        INC     DE
        CP      15*2
        JR      NC, TP_1
        LD      H, A
        LD      A, (DE)
        LD      L, A
        INC     DE
        JR      TP_2
TP_1:   PUSH    DE
        LD      D, 0
        LD      E, A
        ADD     HL, DE
        ADD     HL, DE
        POP     DE
TP_2:   LD      A, H
        LD      (BC), A
        DEC     BC
        LD      A, L
        LD      (BC), A
        DEC     BC
        SUB     +($F8*2)%256
        JR      NZ, TP_0

        LD      HL, VARS
        LD      (HL), A
  ELSE
        XOR     A
        LD      HL, VARS
        LD      (HL), A
  ENDIF

        LD      DE, VARS+1
        LD      BC, VAR0END-VARS-1
        LDIR
        INC     A
        LD      (DelyCnt), A
        LD      HL, $F001               ;H - Volume, L - NtSkCn
        LD      (ChanA+NtSkCn), HL
        LD      (ChanB+NtSkCn), HL
        LD      (ChanC+NtSkCn), HL

        LD      HL, EMPTYSAMORN
        LD      (AdInPtA), HL           ;ptr to zero
        LD      (ChanA+OrnPtr), HL      ;ornament 0 is "0,1,0"
        LD      (ChanB+OrnPtr), HL      ;in all versions from
        LD      (ChanC+OrnPtr), HL      ;3.xx to 3.6x and VTII

        LD      (ChanA+SamPtr), HL      ;S1 There is no default
        LD      (ChanB+SamPtr), HL      ;S2 sample in PT3, so, you
        LD      (ChanC+SamPtr), HL      ;S3 can comment S1,2,3; see
				    ;also EMPTYSAMORN comment
  IF    HEADER
        LD      A, (IX+13-100)          ;EXTRACT VERSION NUMBER
        SUB     $30
        JR      C, L20
        CP      10
        JR      C, L21
L20:    LD      A, 6
L21:    LD      (Version), A
        PUSH    AF
        CP      4
        LD      A, (IX+99-100)          ;TONE TABLE NUMBER
        RLA
        AND     7

;NoteTableCreator (c) Ivan Roshin
;A - NoteTableNumber*2+VersionForNoteTable
;(xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)

        LD      HL, NT_DATA
        PUSH    DE
        LD      D, B
        ADD     A, A
        LD      E, A
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        SRL     E
        SBC     A, A
        AND     $A7                     ;$00 (NOP) or $A7 (AND A)
        LD      (L3), A
        EX      DE, HL
        POP     BC                      ;BC=T1_
        ADD     HL, BC

        LD      A, (DE)
        ADD     A, +(T_%256)
        LD      C, A
        ADC     A, T_/256
        SUB     C
        LD      B, A
        PUSH    BC
        LD      DE, NT_
        PUSH    DE

        LD      B, 12
L1:     PUSH    BC
        LD      C, (HL)
        INC     HL
        PUSH    HL
        LD      B, (HL)

        PUSH    DE
        EX      DE, HL
        LD      DE, 23
        LD      IXH, 8

L2:     SRL     B
        RR      C
L3:     DB      $19                     ;AND A or NOP
        LD      A, C
        ADC     A, D                    ;=ADC 0
        LD      (HL), A
        INC     HL
        LD      A, B
        ADC     A, D
        LD      (HL), A
        ADD     HL, DE
        DEC     IXH
        JR      NZ, L2

        POP     DE
        INC     DE
        INC     DE
        POP     HL
        INC     HL
        POP     BC
        DJNZ    L1

        POP     HL
        POP     DE

        LD      A, E
        CP      +(TCOLD_1)%256
        JR      NZ, CORR_1
        LD      A, $FD
        LD      (NT_+$2E), A

CORR_1: LD      A, (DE)
        AND     A
        JR      Z, TC_EXIT
        RRA
        PUSH    AF
        ADD     A, A
        LD      C, A
        ADD     HL, BC
        POP     AF
        JR      NC, CORR_2
        DEC     (HL)
        DEC     (HL)
CORR_2: INC     (HL)
        AND     A
        SBC     HL, BC
        INC     DE
        JR      CORR_1

TC_EXIT:

        POP     AF
  ELSE
        ; Force to "ProTracker 3.5" Module
        LD      A, 5
        LD      (Version), A
  ENDIF

;VolTableCreator (c) Ivan Roshin
;A - VersionForVolumeTable (0..4 - 3.xx..3.4x;
			   ;5.. - 3.5x..3.6x..VTII1.0)

        CP      5
        LD      HL, $11
        LD      D, H
        LD      E, H
        LD      A, $17
        JR      NC, M1
        DEC     L
        LD      E, L
        XOR     A
M1:     LD      (M2), A

        LD      IX, VT_+16
        LD      C, $10

INITV2: PUSH    HL

        ADD     HL, DE
        EX      DE, HL
        SBC     HL, HL

INITV1: LD      A, L
M2:     DB      $7D
        LD      A, H
        ADC     A, 0
        LD      (IX), A
        INC     IX
        ADD     HL, DE
        INC     C
        LD      A, C
        AND     15
        JR      NZ, INITV1

        POP     HL
        LD      A, E
        CP      $77
        JR      NZ, M3
        INC     E
M3:     LD      A, C
        AND     A
        JR      NZ, INITV2
        RET

;pattern decoder
PD_OrSm:
        LD      (IX-12+Env_En), 0
        CALL    SETORN
        LD      A, (BC)
        INC     BC
        RRCA

PD_SAM: ADD     A, A
PD_SAM_:
        LD      E, A
        LD      D, 0
SamPtrs EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
MODADDR EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      (IX-12+SamPtr), L
        LD      (IX-12+SamPtr+1), H
        JR      PD_LOOP

PD_VOL: RLCA
        RLCA
        RLCA
        RLCA
        LD      (IX-12+Volume), A
        JR      PD_LP2

PD_EOff:
        LD      (IX-12+Env_En), A
        LD      (IX-12+PsInOr), A
        JR      PD_LP2

PD_SorE:
        DEC     A
        JR      NZ, PD_ENV
        LD      A, (BC)
        INC     BC
        LD      (IX-12+NNtSkp), A
        JR      PD_LP2

PD_ENV: CALL    SETENV
        JR      PD_LP2

PD_ORN: CALL    SETORN
        JR      PD_LOOP

PD_ESAM:
        LD      (IX-12+Env_En), A
        LD      (IX-12+PsInOr), A
        CALL    NZ, SETENV
        LD      A, (BC)
        INC     BC
        JR      PD_SAM_

PTDECOD:
        LD      A, (IX-12+Note)
        LD      (PrNote+1), A
        LD      L, (IX-12+CrTnSl)
        LD      H, (IX-12+CrTnSl+1)
        LD      (PrSlide+1), HL

PD_LOOP:
        LD      DE, $2010
PD_LP2: LD      A, (BC)
        INC     BC
        ADD     A, E
        JR      C, PD_OrSm
        ADD     A, D
        JR      Z, PD_FIN
        JR      C, PD_SAM
        ADD     A, E
        JR      Z, PD_REL
        JR      C, PD_VOL
        ADD     A, E
        JR      Z, PD_EOff
        JR      C, PD_SorE
        ADD     A, 96
        JR      C, PD_NOTE
        ADD     A, E
        JR      C, PD_ORN
        ADD     A, D
        JR      C, PD_NOIS
        ADD     A, E
        JR      C, PD_ESAM
        ADD     A, A
        LD      E, A
        LD      HL, SPCCOMS+$FF20-$2000
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        PUSH    DE
        JR      PD_LOOP

PD_NOIS:
        LD      (Ns_Base), A
        JR      PD_LP2

PD_REL: RES     0, (IX-12+Flags)
        JR      PD_RES

PD_NOTE:
        LD      (IX-12+Note), A
        SET     0, (IX-12+Flags)
        XOR     A

PD_RES: LD      (PDSP_+1), SP
        LD      SP, IX
        LD      H, A
        LD      L, A
        PUSH    HL
        PUSH    HL
        PUSH    HL
        PUSH    HL
        PUSH    HL
        PUSH    HL
PDSP_:  LD      SP, $3131

PD_FIN: LD      A, (IX-12+NNtSkp)
        LD      (IX-12+NtSkCn), A
        RET

C_PORTM:
        RES     2, (IX-12+Flags)
        LD      A, (BC)
        INC     BC
;SKIP PRECALCULATED TONE DELTA (BECAUSE
;CANNOT BE RIGHT AFTER PT3 COMPILATION)
        INC     BC
        INC     BC
        LD      (IX-12+TnSlDl), A
        LD      (IX-12+TSlCnt), A
        LD      DE, NT_
        LD      A, (IX-12+Note)
        LD      (IX-12+SlToNt), A
        ADD     A, A
        LD      L, A
        LD      H, 0
        ADD     HL, DE
        LD      A, (HL)
        INC     HL
        LD      H, (HL)
        LD      L, A
        PUSH    HL
PrNote: LD      A, $3E
        LD      (IX-12+Note), A
        ADD     A, A
        LD      L, A
        LD      H, 0
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        POP     HL
        SBC     HL, DE
        LD      (IX-12+TnDelt), L
        LD      (IX-12+TnDelt+1), H
        LD      E, (IX-12+CrTnSl)
        LD      D, (IX-12+CrTnSl+1)
Version EQU     $+1
        LD      A, $3E
        CP      6
        JR      C, OLDPRTM              ;Old 3xxx for PT v3.5-
PrSlide:
        LD      DE, $1111
        LD      (IX-12+CrTnSl), E
        LD      (IX-12+CrTnSl+1), D
OLDPRTM:
        LD      A, (BC)                 ;SIGNED TONE STEP
        INC     BC
        EX      AF, AF'
        LD      A, (BC)
        INC     BC
        AND     A
        JR      Z, NOSIG
        EX      DE, HL
NOSIG:  SBC     HL, DE
        JP      P, SET_STP
        CPL
        EX      AF, AF'
        NEG
        EX      AF, AF'
SET_STP:
        LD      (IX-12+TSlStp+1), A
        EX      AF, AF'
        LD      (IX-12+TSlStp), A
        LD      (IX-12+COnOff), 0
        RET

C_GLISS:
        SET     2, (IX-12+Flags)
        LD      A, (BC)
        INC     BC
        LD      (IX-12+TnSlDl), A
        AND     A
        JR      NZ, GL36
        LD      A, (Version)            ;AlCo PT3.7+
        CP      7
        SBC     A, A
        INC     A
GL36:   LD      (IX-12+TSlCnt), A
        LD      A, (BC)
        INC     BC
        EX      AF, AF'
        LD      A, (BC)
        INC     BC
        JR      SET_STP

C_SMPOS:
        LD      A, (BC)
        INC     BC
        LD      (IX-12+PsInSm), A
        RET

C_ORPOS:
        LD      A, (BC)
        INC     BC
        LD      (IX-12+PsInOr), A
        RET

C_VIBRT:
        LD      A, (BC)
        INC     BC
        LD      (IX-12+OnOffD), A
        LD      (IX-12+COnOff), A
        LD      A, (BC)
        INC     BC
        LD      (IX-12+OffOnD), A
        XOR     A
        LD      (IX-12+TSlCnt), A
        LD      (IX-12+CrTnSl), A
        LD      (IX-12+CrTnSl+1), A
        RET

C_ENGLS:
        LD      A, (BC)
        INC     BC
        LD      (Env_Del), A
        LD      (CurEDel), A
        LD      A, (BC)
        INC     BC
        LD      L, A
        LD      A, (BC)
        INC     BC
        LD      H, A
        LD      (ESldAdd), HL
        RET

C_DELAY:
        LD      A, (BC)
        INC     BC
        LD      (Delay), A
        RET

SETENV: LD      (IX-12+Env_En), E
        LD      (AYREGSB+EnvTp), A
        LD      A, (BC)
        INC     BC
        LD      H, A
        LD      A, (BC)
        INC     BC
        LD      L, A
        LD      (EnvBase), HL
        XOR     A
        LD      (IX-12+PsInOr), A
        LD      (CurEDel), A
        LD      H, A
        LD      L, A
        LD      (CurESld), HL
C_NOP:  RET

SETORN: ADD     A, A
        LD      E, A
        LD      D, 0
        LD      (IX-12+PsInOr), D
OrnPtrs EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
MDADDR2 EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      (IX-12+OrnPtr), L
        LD      (IX-12+OrnPtr+1), H
        RET

;ALL 16 ADDRESSES TO PROTECT FROM BROKEN PT3 MODULES
SPCCOMS:
        DW      C_NOP
        DW      C_GLISS
        DW      C_PORTM
        DW      C_SMPOS
        DW      C_ORPOS
        DW      C_VIBRT
        DW      C_NOP
        DW      C_NOP
        DW      C_ENGLS
        DW      C_DELAY
        DW      C_NOP
        DW      C_NOP
        DW      C_NOP
        DW      C_NOP
        DW      C_NOP
        DW      C_NOP

CHREGS: XOR     A
        LD      (Ampl), A
        BIT     0, (IX+Flags)
        PUSH    HL
        JP      Z, CH_EXIT
        LD      (CSP_+1), SP
        LD      L, (IX+OrnPtr)
        LD      H, (IX+OrnPtr+1)
        LD      SP, HL
        POP     DE
        LD      H, A
        LD      A, (IX+PsInOr)
        LD      L, A
        ADD     HL, SP
        INC     A
        CP      D
        JR      C, CH_ORPS
        LD      A, E
CH_ORPS:
        LD      (IX+PsInOr), A
        LD      A, (IX+Note)
        ADD     A, (HL)
        JP      P, CH_NTP
        XOR     A
CH_NTP: CP      96
        JR      C, CH_NOK
        LD      A, 95
CH_NOK: ADD     A, A
        EX      AF, AF'
        LD      L, (IX+SamPtr)
        LD      H, (IX+SamPtr+1)
        LD      SP, HL
        POP     DE
        LD      H, 0
        LD      A, (IX+PsInSm)
        LD      B, A
        ADD     A, A
        ADD     A, A
        LD      L, A
        ADD     HL, SP
        LD      SP, HL
        LD      A, B
        INC     A
        CP      D
        JR      C, CH_SMPS
        LD      A, E
CH_SMPS:
        LD      (IX+PsInSm), A
        POP     BC
        POP     HL
        LD      E, (IX+TnAcc)
        LD      D, (IX+TnAcc+1)
        ADD     HL, DE
        BIT     6, B
        JR      Z, CH_NOAC
        LD      (IX+TnAcc), L
        LD      (IX+TnAcc+1), H
CH_NOAC:
        EX      DE, HL
        EX      AF, AF'
        LD      L, A
        LD      H, 0
        LD      SP, NT_
        ADD     HL, SP
        LD      SP, HL
        POP     HL
        ADD     HL, DE
        LD      E, (IX+CrTnSl)
        LD      D, (IX+CrTnSl+1)
        ADD     HL, DE
CSP_:   LD      SP, $3131
        EX      (SP), HL
        XOR     A
        OR      (IX+TSlCnt)
        JR      Z, CH_AMP
        DEC     (IX+TSlCnt)
        JR      NZ, CH_AMP
        LD      A, (IX+TnSlDl)
        LD      (IX+TSlCnt), A
        LD      L, (IX+TSlStp)
        LD      H, (IX+TSlStp+1)
        LD      A, H
        ADD     HL, DE
        LD      (IX+CrTnSl), L
        LD      (IX+CrTnSl+1), H
        BIT     2, (IX+Flags)
        JR      NZ, CH_AMP
        LD      E, (IX+TnDelt)
        LD      D, (IX+TnDelt+1)
        AND     A
        JR      Z, CH_STPP
        EX      DE, HL
CH_STPP:
        SBC     HL, DE
        JP      M, CH_AMP
        LD      A, (IX+SlToNt)
        LD      (IX+Note), A
        XOR     A
        LD      (IX+TSlCnt), A
        LD      (IX+CrTnSl), A
        LD      (IX+CrTnSl+1), A
CH_AMP: LD      A, (IX+CrAmSl)
        BIT     7, C
        JR      Z, CH_NOAM
        BIT     6, C
        JR      Z, CH_AMIN
        CP      15
        JR      Z, CH_NOAM
        INC     A
        JR      CH_SVAM
CH_AMIN:
        CP      -15
        JR      Z, CH_NOAM
        DEC     A
CH_SVAM:
        LD      (IX+CrAmSl), A
CH_NOAM:
        LD      L, A
        LD      A, B
        AND     15
        ADD     A, L
        JP      P, CH_APOS
        XOR     A
CH_APOS:
        CP      16
        JR      C, CH_VOL
        LD      A, 15
CH_VOL: OR      (IX+Volume)
        LD      L, A
        LD      H, 0
        LD      DE, VT_
        ADD     HL, DE
        LD      A, (HL)
CH_ENV: BIT     0, C
        JR      NZ, CH_NOEN
        OR      (IX+Env_En)
CH_NOEN:
        LD      (Ampl), A
        BIT     7, B
        LD      A, C
        JR      Z, NO_ENSL
        RLA
        RLA
        SRA     A
        SRA     A
        SRA     A
        ADD     A, (IX+CrEnSl)          ;SEE COMMENT BELOW
        BIT     5, B
        JR      Z, NO_ENAC
        LD      (IX+CrEnSl), A
NO_ENAC:
        LD      HL, AddToEn
        ADD     A, (HL)                 ;BUG IN PT3 - NEED WORD HERE.
		   ;FIX IT IN NEXT VERSION?
        LD      (HL), A
        JR      CH_MIX
NO_ENSL:
        RRA
        ADD     A, (IX+CrNsSl)
        LD      (AddToNs), A
        BIT     5, B
        JR      Z, CH_MIX
        LD      (IX+CrNsSl), A
CH_MIX:
        LD      A, B
        RRA
        AND     $48
CH_EXIT:
        LD      HL, AYREGSB+Mixer
        OR      (HL)
        RRCA
        LD      (HL), A
        POP     HL
        XOR     A
        OR      (IX+COnOff)
        RET     Z
        DEC     (IX+COnOff)
        RET     NZ
        XOR     (IX+Flags)
        LD      (IX+Flags), A
        RRA
        LD      A, (IX+OnOffD)
        JR      C, CH_ONDL
        LD      A, (IX+OffOnD)
CH_ONDL:
        LD      (IX+COnOff), A
        RET

		;
		; Decode the next PT3 frame
		;
PT3Player_Decode:
PLAY:
        ld      hl, SETUP
        bit     1, (hl)
        ret     z                       ; Do nothing is bit 1 is reset
        XOR     A
        LD      (AddToEn), A
        LD      (AYREGSB+Mixer), A
        DEC     A
        LD      (AYREGSB+EnvTp), A
        LD      HL, DelyCnt
        DEC     (HL)
        JR      NZ, PL2
        LD      HL, ChanA+NtSkCn
        DEC     (HL)
        JR      NZ, PL1B
AdInPtA EQU     $+1
        LD      BC, $0101
        LD      A, (BC)
        AND     A
        JR      NZ, PL1A
        LD      D, A
        LD      (Ns_Base), A
        LD      HL, (CrPsPtr)
        INC     HL
        LD      A, (HL)
        INC     A
        JR      NZ, PLNLP
        CALL    CHECKLP
LPosPtr EQU     $+1
        LD      HL, $2121
        LD      A, (HL)
        INC     A
PLNLP:  LD      (CrPsPtr), HL
        DEC     A
        ADD     A, A
        LD      E, A
        RL      D
PatsPtr EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      DE, (MODADDR)
        LD      (PSP_+1), SP
        LD      SP, HL
        POP     HL
        ADD     HL, DE
        LD      B, H
        LD      C, L
        POP     HL
        ADD     HL, DE
        LD      (AdInPtB), HL
        POP     HL
        ADD     HL, DE
        LD      (AdInPtC), HL
PSP_:   LD      SP, $3131
PL1A:   LD      IX, ChanA+12
        CALL    PTDECOD
        LD      (AdInPtA), BC

PL1B:   LD      HL, ChanB+NtSkCn
        DEC     (HL)
        JR      NZ, PL1C
        LD      IX, ChanB+12
AdInPtB EQU     $+1
        LD      BC, $0101
        CALL    PTDECOD
        LD      (AdInPtB), BC

PL1C:   LD      HL, ChanC+NtSkCn
        DEC     (HL)
        JR      NZ, PL1D
        LD      IX, ChanC+12
AdInPtC EQU     $+1
        LD      BC, $0101
        CALL    PTDECOD
        LD      (AdInPtC), BC

Delay   EQU     $+1
PL1D:   LD      A, $3E
        LD      (DelyCnt), A

PL2:    LD      IX, ChanA
        LD      HL, (AYREGSB+TonA)
        CALL    CHREGS
        LD      (AYREGSB+TonA), HL
        LD      A, (Ampl)
        LD      (AYREGSB+AmplA), A
        LD      IX, ChanB
        LD      HL, (AYREGSB+TonB)
        CALL    CHREGS
        LD      (AYREGSB+TonB), HL
        LD      A, (Ampl)
        LD      (AYREGSB+AmplB), A
        LD      IX, ChanC
        LD      HL, (AYREGSB+TonC)
        CALL    CHREGS
;	LD A,(Ampl) ;Ampl = AYREGSB+AmplC
;	LD (AYREGSB+AmplC),A
        LD      (AYREGSB+TonC), HL

        LD      HL, (Ns_Base_AddToNs)
        LD      A, H
        ADD     A, L
        LD      (AYREGSB+Noise), A

AddToEn EQU     $+1
        LD      A, $3E
        LD      E, A
        ADD     A, A
        SBC     A, A
        LD      D, A
        LD      HL, (EnvBase)
        ADD     HL, DE
        LD      DE, (CurESld)
        ADD     HL, DE
        LD      (AYREGSB+Env), HL

        XOR     A
        LD      HL, CurEDel
        OR      (HL)
        RET     Z
        DEC     (HL)
        RET     NZ
Env_Del EQU     $+1
        LD      A, $3E
        LD      (HL), A
ESldAdd EQU     $+1
        LD      HL, $2121
        ADD     HL, DE
        LD      (CurESld), HL
        RET

        section rodata_user
  IF    HEADER
NT_DATA:
        DB      (T_NEW_0-T1_)*2
        DB      TCNEW_0-T_
        DB      (T_OLD_0-T1_)*2+1
        DB      TCOLD_0-T_
        DB      (T_NEW_1-T1_)*2+1
        DB      TCNEW_1-T_
        DB      (T_OLD_1-T1_)*2+1
        DB      TCOLD_1-T_
        DB      (T_NEW_2-T1_)*2
        DB      TCNEW_2-T_
        DB      (T_OLD_2-T1_)*2
        DB      TCOLD_2-T_
        DB      (T_NEW_3-T1_)*2
        DB      TCNEW_3-T_
        DB      (T_OLD_3-T1_)*2
        DB      TCOLD_3-T_

T_:

TCOLD_0:
        DB      $00+1, $04+1, $08+1, $0A+1, $0C+1, $0E+1, $12+1, $14+1
        DB      $18+1, $24+1, $3C+1, 0
TCOLD_1:
        DB      $5C+1, 0
TCOLD_2:
        DB      $30+1, $36+1, $4C+1, $52+1, $5E+1, $70+1, $82, $8C, $9C
        DB      $9E, $A0, $A6, $A8, $AA, $AC, $AE, $AE, 0
TCNEW_3:
        DB      $56+1
TCOLD_3:
        DB      $1E+1, $22+1, $24+1, $28+1, $2C+1, $2E+1, $32+1, $BE+1, 0
TCNEW_0:
        DB      $1C+1, $20+1, $22+1, $26+1, $2A+1, $2C+1, $30+1, $54+1
        DB      $BC+1, $BE+1, 0
TCNEW_1 EQU     TCOLD_1
TCNEW_2:
        DB      $1A+1, $20+1, $24+1, $28+1, $2A+1, $3A+1, $4C+1, $5E+1
        DB      $BA+1, $BC+1, $BE+1, 0

EMPTYSAMORN EQU $-1
        DB      1, 0, $90               ;delete $90 if you don't need default sample

;first 12 values of tone tables (packed)

T_PACK:
        DB      ($06EC*2/256)%256, ($06EC*2)%256
        DB      $0755-$06EC
        DB      $07C5-$0755
        DB      $083B-$07C5
        DB      $08B8-$083B
        DB      $093D-$08B8
        DB      $09CA-$093D
        DB      $0A5F-$09CA
        DB      $0AFC-$0A5F
        DB      $0BA4-$0AFC
        DB      $0C55-$0BA4
        DB      $0D10-$0C55
        DB      ($066D*2/256)%256, ($066D*2)%256
        DB      $06CF-$066D
        DB      $0737-$06CF
        DB      $07A4-$0737
        DB      $0819-$07A4
        DB      $0894-$0819
        DB      $0917-$0894
        DB      $09A1-$0917
        DB      $0A33-$09A1
        DB      $0ACF-$0A33
        DB      $0B73-$0ACF
        DB      $0C22-$0B73
        DB      $0CDA-$0C22
        DB      ($0704*2/256)%256, ($0704*2)%256
        DB      $076E-$0704
        DB      $07E0-$076E
        DB      $0858-$07E0
        DB      $08D6-$0858
        DB      $095C-$08D6
        DB      $09EC-$095C
        DB      $0A82-$09EC
        DB      $0B22-$0A82
        DB      $0BCC-$0B22
        DB      $0C80-$0BCC
        DB      $0D3E-$0C80
        DB      ($07E0*2/256)%256, ($07E0*2)%256
        DB      $0858-$07E0
        DB      $08E0-$0858
        DB      $0960-$08E0
        DB      $09F0-$0960
        DB      $0A88-$09F0
        DB      $0B28-$0A88
        DB      $0BD8-$0B28
        DB      $0C80-$0BD8
        DB      $0D60-$0C80
        DB      $0E10-$0D60
        DB      $0EF8-$0E10
  ELSE
EMPTYSAMORN EQU $
        DB      0, 1, 0, $90            ;delete $90 if you don't need default sample
  ENDIF

        section bss_user
chainLoop:
        ds      1
chainSong:
        ds      2

;vars from here can be stripped
;you can move VARS to any other address

        ; Bit 0, 1 = no loop, 0 = no loop
        ; Bit 1, 1 = playing, 0 = not playing
        ; Bit 6, 1 = song ended or chain started
        ; Bit 7, set when loop point is passed
SETUP:  DB      0

CrPsPtr:
        DW      0
VARS:

ChanA:  DS      CHP
ChanB:  DS      CHP
ChanC:  DS      CHP

;GlobalVars
DelyCnt:
        DB      0
CurESld:
        DW      0
CurEDel:
        DB      0
Ns_Base_AddToNs:
Ns_Base:
        DB      0
AddToNs:
        DB      0

AYREGSB:

VT_:    DS      256                     ;CreatedVolumeTableAddress

EnvBase EQU     VT_+14

T1_     EQU     VT_+16                  ;Tone tables data depacked here

T_OLD_1 EQU     T1_
T_OLD_2 EQU     T_OLD_1+24
T_OLD_3 EQU     T_OLD_2+24
T_OLD_0 EQU     T_OLD_3+2
T_NEW_0 EQU     T_OLD_0
T_NEW_1 EQU     T_OLD_1
T_NEW_2 EQU     T_NEW_0+24
T_NEW_3 EQU     T_OLD_3

NT_:
  IF    HEADER
        DS      192                     ;CreatedNoteTableAddress
  ELSE
        ; Note table #2
;        dw 0x0D10,0x0C55,0x0BA4,0x0AFC,0x0A5F,0x09CA,0x093D,0x08B8,0x083B,0x07C5,0x0755,0x06EC
;        dw 0x0688,0x062A,0x05D2,0x057E,0x052F,0x04E5,0x049E,0x045C,0x041D,0x03E2,0x03AB,0x0376
;        dw 0x0344,0x0315,0x02E9,0x02BF,0x0298,0x0272,0x024F,0x022E,0x020F,0x01F1,0x01D5,0x01BB
;        dw 0x01A2,0x018B,0x0174,0x0160,0x014C,0x0139,0x0128,0x0117,0x0107,0x00F9,0x00EB,0x00DD
;        dw 0x00D1,0x00C5,0x00BA,0x00B0,0x00A6,0x009D,0x0094,0x008C,0x0084,0x007C,0x0075,0x006F
;        dw 0x0069,0x0063,0x005D,0x0058,0x0053,0x004E,0x004A,0x0046,0x0042,0x003E,0x003B,0x0037
;        dw 0x0034,0x0031,0x002F,0x002C,0x0029,0x0027,0x0025,0x0023,0x0021,0x001F,0x001D,0x001C
;        dw 0x001A,0x0019,0x0017,0x0016,0x0015,0x0014,0x0012,0x0011,0x0010,0x000F,0x000E,0x000D

        ; Recalculated for ZX Spectrum AY clock speed of 1.7734MHz
        ; Based on the following note...
        ; A#4 = 440Hz, 1773400/(440*2*16) = 0x007D
        dw      0x0D3D, 0x0C7E, 0x0BCB, 0x0B21, 0x0A82, 0x09EB, 0x095C, 0x08D6, 0x0857, 0x07DF, 0x076E, 0x0703
        dw      0x069E, 0x063F, 0x05E5, 0x0590, 0x0541, 0x04F5, 0x04AE, 0x046B, 0x042B, 0x03EF, 0x03B7, 0x0381
        dw      0x034F, 0x031F, 0x02F2, 0x02C8, 0x02A0, 0x027A, 0x0257, 0x0235, 0x0215, 0x01F7, 0x01DB, 0x01C0
        dw      0x01A7, 0x018F, 0x0179, 0x0164, 0x0150, 0x013D, 0x012B, 0x011A, 0x010A, 0x00FB, 0x00ED, 0x00E0
        dw      0x00D3, 0x00C7, 0x00BC, 0x00B2, 0x00A8, 0x009E, 0x0095, 0x008D, 0x0085, 0x007D, 0x0076, 0x0070
        dw      0x0069, 0x0063, 0x005E, 0x0059, 0x0054, 0x004F, 0x004A, 0x0046, 0x0042, 0x003E, 0x003B, 0x0038
        dw      0x0034, 0x0031, 0x002F, 0x002C, 0x002A, 0x0027, 0x0025, 0x0023, 0x0021, 0x001F, 0x001D, 0x001C
        dw      0x001A, 0x0018, 0x0017, 0x0016, 0x0015, 0x0013, 0x0012, 0x0011, 0x0010, 0x000F, 0x000E, 0x000E
  ENDIF

;local var
Ampl    EQU     AYREGSB+AmplC

VAR0END EQU     VT_+16                  ;INIT zeroes from VARS to VAR0END-1

VARSEND EQU     $

;Release 0 steps:
;11.Sep.2004 - Note tables creator
;12.Sep.2004 - Volume tables creator; INIT subroutine
;13.Sep.2004 - Play counters, position counters
;14.Sep.2004 - Patterns decoder subroutine
;15.Sep.2004 - Resting (no code)
;16.Sep.2004 - CHREGS subroutine; global debugging; 1st stable
;version was born
;17.Sep.2004 - Debugging and optimization. First release!
;Release 1 steps:
;20.Sep.2004 - local vars moved to code (selfmodified code
;smaller and faster)
;22.Sep.2004 - added mute sound entry at START+8; position
;pointer moved to START+11; added setup and status byte at
;START+10 noloop mode and loop passed flags added
;Release 2 steps:
;28.Sep.2004 - Optimization: code around CHREGS's volume and
;vibrato faster now; zeroing PD_RES through stack; Ton and Ampl
;moved from channel vars to global ones; first position selector
;removed from INIT; optimization for packers(Ivan Roshin method)
;Release 3 steps:
;2.Oct.2004 - optimization in INIT and PD_LOOP (thanks to Ivan
;Roshin)
;4.Oct.2004 - load delay from (hl) in INIT (2 bytes shorter)
;5.Oct.2004 - optimization in PD_LOOP (->PD_LP2)
;7.Oct.2004 - swaping some commands for better packing
;Release 4 steps:
;9.Oct.2004 - optimization around LD HL,SPCCOMS (thanks to Ivan
;Roshin); in PTDECOD swapped BC and DE to optimize C_PORTM;
;removed sam and orn len and loop channel vars; CHREGS totally
;optimized
;Release 5 steps:
;11.Oct.2004 - PD_OrSm and C_PORTM optimized; Ivan Roshin's
;volume tables creator algorithm (51 bytes shorter than mine)
;12.Oct.2004 - Ivan Roshin's note tables creator algorithm (74
;bytes shorter than mine)
;Release 6 steps:
;14.Oct.2004 - loop and next position calculations moved to INIT
;15.Oct.2004 - AdInPt moved to code
;19.Oct.2004 - Env_Del moved to code
;20.Oct.2004 - Version PUSH and POP (1 byte shorter, thanks to
;Ivan Roshin)
;22.Oct.2004 - Env_En moved from Flags' bit to byte (shorter and
;faster code)
;25.Oct.2004 - SETENV optimized
;29.Oct.2004 - Optimized around AddToEn (SBC A,A, thanks to Ivan
;Roshin)
;3.Nov.2004 - Note tables data was compressed; with depacker it
;is 9 bytes shorter than uncompressed (thanks to Ivan Roshin)
;4.Nov.2004 - default sample and ornament both are fixed now
;and placed into code block (6 bytes shorter)
;7.Nov.2004 - LD A,(Ns_Base):LD L,A changed to LD HL,(Ns_Base)
;(thanks to Dima Bystrov)
;9.Nov.2004 - Ns_Base and AddToNs are merged to Ns_Base_AddToNs;
;LD A,255 changed to DEC A (at start of PLAY); added ROUT_A0
;12.Nov.2004 - NtSkCn&Volume are merged (8 bytes smaller init);
;LD BC,T1_ changed to PUSH DE...POP BC in note table creator
;19.Dec.2004 - NT_DATA reorganized (6 bytes shorter, thanks to
;Ivan Roshin); C_PORTM and C_GLISS are merged via SET_STP (48
;tacts slower, but 8 bytes smaller, thanks to Ivan Roshin)
;Release 7 steps:
;29.Apr.2007 - SjAsm adaptation; new 1.xx and 2.xx
;interpretation for PT 3.7+.

;Tests in IMMATION TESTER V1.0 by Andy Man/POS (thanks to
;Himik's ZxZ for help):
;Module name/author	Min tacts	Max tacts	Average
;Spleen/Nik-O		1720		9256		5500
;Chuta/Miguel		1720		9496		5500
;Zhara/Macros		4536		8744		5500

;Size:
;Code block $651 bytes
;Variables $21D bytes (can be stripped)
;Size in RAM $651+$21D=$86E (2158) bytes

;Notes:
;Pro Tracker 3.4r can not be detected by header, so PT3.4r tone
;tables really used only for modules of 3.3 and older versions.
