IF !__CPU_INTEL__ & !__CPU_GBZ80__ & !__CPU_RABBIT__ & !__CPU_Z180__
;Vortex Tracker II v1.0 PT3 player for ZX Spectrum
;ROM version (specially for Axor)
;(c)2004,2007 S.V.Bulba <vorobey@mail.khstu.ru>
;http://bulba.untergrund.net (http://bulba.at.kz)

;Release number
;DEFM Release = "MOR7"

;This file has been adapted to the z80asm assembler in z88dk and is based on the
;file PT3Play/ROM/PT3PROM.asm in http://bulba.untergrund.net/PTxTools.7z, which
;uses the SjASM assembler syntax. The code section can be executed from RAM or
;ROM, contains no self-modifying code, and can be assembled at any address.
;The data section contains the variables and self-modifying code and can be
;located at any address in RAM. The MUTE routine has been extended to also
;disable all channels.

;Features
;--------
;-Can run in ROM (self-modified code is not used).
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

;Warning!!! PLAY subroutine can crash if no module are loaded
;into RAM or INIT subroutine was not called before.

;Call MUTE or INIT one more time to mute sound after stopping
;playing 

SECTION code_psg
;	ORG $C000

;Test codes (commented)
;	CALL START
;	EI
;_LP:
;	HALT
;	CALL START+5
;	XOR A
;	IN A,($FE)
;	CPL
;	AND 15
;	JR Z,_LP
;	JR START+8

DEFC TonA  = 0
DEFC TonB  = 2
DEFC TonC  = 4
DEFC Noise = 6
DEFC Mixer = 7
DEFC AmplA = 8
DEFC AmplB = 9
DEFC AmplC = 10
DEFC Env   = 11
DEFC EnvTp = 13

;ChannelsVars
;	STRUCT	CHP
;reset group
DEFC CHP_PsInOr = 0
DEFC CHP_PsInSm = 1
DEFC CHP_CrAmSl = 2
DEFC CHP_CrNsSl = 3
DEFC CHP_CrEnSl = 4
DEFC CHP_TSlCnt = 5
DEFC CHP_CrTnSl = 6
DEFC CHP_TnAcc  = 8
DEFC CHP_COnOff = 10
;reset group

DEFC CHP_OnOffD = 11

;IX for PTDECOD here (+12)
DEFC CHP_OffOnD = 12
DEFC CHP_OrnPtr = 13
DEFC CHP_SamPtr = 15
DEFC CHP_NNtSkp = 17
DEFC CHP_Note   = 18
DEFC CHP_SlToNt = 19
DEFC CHP_Env_En = 20
DEFC CHP_Flags  = 21
 ;Enabled - 0,SimpleGliss - 2
DEFC CHP_TnSlDl = 22
DEFC CHP_TSlStp = 23
DEFC CHP_TnDelt = 25
DEFC CHP_NtSkCn = 27
DEFC CHP_Volume = 28
;	ENDS
DEFC CHP = 29

;Entry and other points
;START initialization
;START+3 initialization with module address in HL
;START+5 play one quark
;START+8 mute
;START+10 setup and status flags
;START+11 pointer to current position value in PT3 module;
;After INIT (START+11) points to Postion0-1 (optimization)

PUBLIC asm_VT_START
PUBLIC asm_VT_PLAY
PUBLIC asm_VT_MUTE
PUBLIC asm_VT_INIT
PUBLIC asm_VT_AYREGS
EXTERN asm_vt_hardware_out
EXTERN asm_vt_hardware_out_A0
asm_VT_START:

START:
	LD HL,MDLADDR
asm_VT_INIT:
	JR INIT
asm_VT_PLAY:
	JP PLAY
asm_VT_MUTE:
	JR MUTE

;Identifier
	DEFM "=VTII PT3 Player r.7ROM="

CHECKLP:
	LD HL,SETUP
	SET 7,(HL)
	BIT 0,(HL)
	RET Z
	POP HL
	LD HL,DelyCnt
	INC (HL)
	LD HL,ChanA+CHP_NtSkCn
	INC (HL)
MUTE:
	LD A,$3F
	LD (AYREGS+Mixer),A
	XOR A
	LD H,A
	LD L,A
	LD (AYREGS+AmplA),A
	LD (AYREGS+AmplB),HL
	JP asm_vt_hardware_out_A0

INIT:
;HL - AddressOfModule

	LD (MODADDR),HL
	PUSH HL
	LD DE,100
	ADD HL,DE
	LD A,(HL)
	LD (Delay),A
	PUSH HL
	POP IX
	ADD HL,DE
	LD (CrPsPtr),HL
	LD E,(IX+102-100)
	ADD HL,DE
	INC HL
	LD (LPosPtr),HL
	POP DE
	LD L,(IX+103-100)
	LD H,(IX+104-100)
	ADD HL,DE
	LD (PatsPtr),HL
	LD HL,169
	ADD HL,DE
	LD (OrnPtrs),HL
	LD HL,105
	ADD HL,DE
	LD (SamPtrs),HL
	LD HL,SETUP
	RES 7,(HL)

;note table data depacker
	LD DE,T_PACK
	LD BC,T1_+(2*49)-1
TP_0:
	LD A,(DE)
	INC DE
	CP 15*2
	JR NC,TP_1
	LD H,A
	LD A,(DE)
	LD L,A
	INC DE
	JR TP_2
TP_1:
	PUSH DE
	LD D,0
	LD E,A
	ADD HL,DE
	ADD HL,DE
	POP DE
TP_2:
	LD A,H
	LD (BC),A
	DEC BC
	LD A,L
	LD (BC),A
	DEC BC
	SUB +($F8*2) % 256
	JR NZ,TP_0

	LD HL,VAR0START
	LD (HL),A
	LD DE,VAR0START+1
	LD BC,VAR0END-VAR0START-1
	LDIR
	INC A
	LD (DelyCnt),A
	LD HL,$F001 ;H - CHP_Volume, L - CHP_NtSkCn
	LD (ChanA+CHP_NtSkCn),HL
	LD (ChanB+CHP_NtSkCn),HL
	LD (ChanC+CHP_NtSkCn),HL

	LD HL,EMPTYSAMORN
	LD (AdInPtA),HL ;ptr to zero
	LD (ChanA+CHP_OrnPtr),HL ;ornament 0 is "0,1,0"
	LD (ChanB+CHP_OrnPtr),HL ;in all versions from
	LD (ChanC+CHP_OrnPtr),HL ;3.xx to 3.6x and VTII

	LD (ChanA+CHP_SamPtr),HL ;S1 There is no default
	LD (ChanB+CHP_SamPtr),HL ;S2 sample in PT3, so, you
	LD (ChanC+CHP_SamPtr),HL ;S3 can comment S1,2,3; see
				    ;also EMPTYSAMORN comment

	LD A,(IX+13-100) ;EXTRACT VERSION NUMBER
	SUB $30
	JR C,L20
	CP 10
	JR C,L21
L20:
	LD A,6
L21:
	LD (Version),A
	PUSH AF
	CP 4
	LD A,(IX+99-100) ;TONE TABLE NUMBER
	RLA
	AND 7

;NoteTableCreator (c) Ivan Roshin
;A - NoteTableNumber*2+VersionForNoteTable
;(xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)

	LD HL,NT_DATA
	PUSH DE
	LD D,B
	ADD A,A
	LD E,A
	ADD HL,DE
	LD E,(HL)
	INC HL
	SRL E
	SBC A,A
	AND $A7 ;$00 (NOP) or $A7 (AND A)
	LD (L3),A
	LD A,201 ;RET temporary
	LD (L3+1),A ;temporary
	EX DE,HL
	POP BC ;BC=T1_
	ADD HL,BC

	LD A,(DE)

	ADD A,+(T_ % 256)
	LD C,A
	ADC A,T_/256

	SUB C
	LD B,A
	PUSH BC
	LD DE,NT_
	PUSH DE

	LD B,12
L1:
	PUSH BC
	LD C,(HL)
	INC HL
	PUSH HL
	LD B,(HL)

	PUSH DE
	EX DE,HL
	LD DE,23
	LD IXH,8

L2:
	SRL B
	RR C
	CALL L3 ;temporary
;L3:
;	DB $19	;AND A or NOP
	LD A,C
	ADC A,D	;=ADC 0
	LD (HL),A
	INC HL
	LD A,B
	ADC A,D
	LD (HL),A
	ADD HL,DE
	DEC IXH
	JR NZ,L2

	POP DE
	INC DE
	INC DE
	POP HL
	INC HL
	POP BC
	DJNZ L1

	POP HL
	POP DE

	LD A,E
	CP +(TCOLD_1) % 256
	JR NZ,CORR_1
	LD A,$FD
	LD (NT_+$2E),A

CORR_1:
	LD A,(DE)
	AND A
	JR Z,TC_EXIT
	RRA
	PUSH AF
	ADD A,A
	LD C,A
	ADD HL,BC
	POP AF
	JR NC,CORR_2
	DEC (HL)
	DEC (HL)
CORR_2:
	INC (HL)
	AND A
	SBC HL,BC
	INC DE
	JR CORR_1

TC_EXIT:

	POP AF

;VolTableCreator (c) Ivan Roshin
;A - VersionForVolumeTable (0..4 - 3.xx..3.4x;
			   ;5.. - 3.5x..3.6x..VTII1.0)

	CP 5
	LD HL,$11
	LD D,H
	LD E,H
	LD A,$17
	JR NC,M1
	DEC L
	LD E,L
	XOR A
M1:
	LD (M2),A

	LD IX,VT_+16
	LD C,$10

INITV2:
	PUSH HL

	ADD HL,DE
	EX DE,HL
	SBC HL,HL

INITV1:
	LD A,L
;M2:
;	DB $7D
	CALL M2 ;temporary
	LD A,H
	ADC A,0
	LD (IX),A
	INC IX
	ADD HL,DE
	INC C
	LD A,C
	AND 15
	JR NZ,INITV1

	POP HL
	LD A,E
	CP $77
	JR NZ,M3
	INC E
M3:
	LD A,C
	AND A
	JR NZ,INITV2

	JP asm_vt_hardware_out_A0

;pattern decoder
PD_OrSm:
	LD (IX-12+CHP_Env_En),0
	CALL SETORN
	LD A,(BC)
	INC BC
	RRCA

PD_SAM:
	ADD A,A
PD_SAM_:
	LD E,A
	LD D,0
;DEFC SamPtrs = ASMPC+1
;	LD HL,$2121
	LD HL,(SamPtrs)
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
;DEFC MODADDR = ASMPC+1
;	LD HL,$2121
	LD HL,(MODADDR)
	ADD HL,DE
	LD (IX-12+CHP_SamPtr),L
	LD (IX-12+CHP_SamPtr+1),H
	JR PD_LOOP

PD_VOL:
	RLCA
	RLCA
	RLCA
	RLCA
	LD (IX-12+CHP_Volume),A
	JR PD_LP2
	
PD_EOff:
	LD (IX-12+CHP_Env_En),A
	LD (IX-12+CHP_PsInOr),A
	JR PD_LP2

PD_SorE:
	DEC A
	JR NZ,PD_ENV
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_NNtSkp),A
	JR PD_LP2

PD_ENV:
	CALL SETENV
	JR PD_LP2

PD_ORN:
	CALL SETORN
	JR PD_LOOP

PD_ESAM:
	LD (IX-12+CHP_Env_En),A
	LD (IX-12+CHP_PsInOr),A
	CALL NZ,SETENV
	LD A,(BC)
	INC BC
	JR PD_SAM_

PTDECOD:
	LD A,(IX-12+CHP_Note)
;	LD (PrNote+1),A
	LD (PrNote),A
	LD L,(IX-12+CHP_CrTnSl)
	LD H,(IX-12+CHP_CrTnSl+1)
;	LD (PrSlide+1),HL
	LD (PrSlide),HL

PD_LOOP:
	LD DE,$2010
PD_LP2:
	LD A,(BC)
	INC BC
	ADD A,E
	JR C,PD_OrSm
	ADD A,D
	JR Z,PD_FIN
	JR C,PD_SAM
	ADD A,E
	JR Z,PD_REL
	JR C,PD_VOL
	ADD A,E
	JR Z,PD_EOff
	JR C,PD_SorE
	ADD A,96
	JR C,PD_NOTE
	ADD A,E
	JR C,PD_ORN
	ADD A,D
	JR C,PD_NOIS
	ADD A,E
	JR C,PD_ESAM
	ADD A,A
	LD E,A
	LD HL,SPCCOMS+$FF20-$2000
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	PUSH DE
	JR PD_LOOP

PD_NOIS:
	LD (Ns_Base),A
	JR PD_LP2

PD_REL:
	RES 0,(IX-12+CHP_Flags)
	JR PD_RES
	
PD_NOTE:
	LD (IX-12+CHP_Note),A
	SET 0,(IX-12+CHP_Flags)
	XOR A

PD_RES:
;	LD (PDSP_+1),SP
	LD (PDSP_),SP
	LD SP,IX
	LD H,A
	LD L,A
	PUSH HL
	PUSH HL
	PUSH HL
	PUSH HL
	PUSH HL
	PUSH HL
;PDSP_:
;	LD SP,$3131
	LD SP,(PDSP_)

PD_FIN:
	LD A,(IX-12+CHP_NNtSkp)
	LD (IX-12+CHP_NtSkCn),A
	RET

C_PORTM:
	RES 2,(IX-12+CHP_Flags)
	LD A,(BC)
	INC BC
;SKIP PRECALCULATED TONE DELTA (BECAUSE
;CANNOT BE RIGHT AFTER PT3 COMPILATION)
	INC BC
	INC BC
	LD (IX-12+CHP_TnSlDl),A
	LD (IX-12+CHP_TSlCnt),A
	LD DE,NT_
	LD A,(IX-12+CHP_Note)
	LD (IX-12+CHP_SlToNt),A
	ADD A,A
	LD L,A
	LD H,0
	ADD HL,DE
	LD A,(HL)
	INC HL
	LD H,(HL)
	LD L,A
	PUSH HL
;PrNote:
;	LD A,$3E
	LD A,(PrNote)
	LD (IX-12+CHP_Note),A
	ADD A,A
	LD L,A
	LD H,0
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	POP HL
	SBC HL,DE
	LD (IX-12+CHP_TnDelt),L
	LD (IX-12+CHP_TnDelt+1),H
	LD E,(IX-12+CHP_CrTnSl)
	LD D,(IX-12+CHP_CrTnSl+1)
;DEFC Version = ASMPC+1
;	LD A,$3E
	LD A,(Version)
	CP 6
	JR C,OLDPRTM ;Old 3xxx for PT v3.5-
;PrSlide:
;	LD DE,$1111
	LD DE,(PrSlide)
	LD (IX-12+CHP_CrTnSl),E
	LD (IX-12+CHP_CrTnSl+1),D
OLDPRTM:
	LD A,(BC) ;SIGNED TONE STEP
	INC BC
	EX AF,AF'
	LD A,(BC)
	INC BC
	AND A
	JR Z,NOSIG
	EX DE,HL
NOSIG:
	SBC HL,DE
	JP P,SET_STP
	CPL
	EX AF,AF'
	NEG
	EX AF,AF'
SET_STP:
	LD (IX-12+CHP_TSlStp+1),A
	EX AF,AF'
	LD (IX-12+CHP_TSlStp),A
	LD (IX-12+CHP_COnOff),0
	RET

C_GLISS:
	SET 2,(IX-12+CHP_Flags)
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_TnSlDl),A
	AND A
	JR NZ,GL36
	LD A,(Version) ;AlCo PT3.7+
	CP 7
	SBC A,A
	INC A
GL36:
	LD (IX-12+CHP_TSlCnt),A
	LD A,(BC)
	INC BC
	EX AF,AF'
	LD A,(BC)
	INC BC
	JR SET_STP

C_SMPOS:
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_PsInSm),A
	RET

C_ORPOS:
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_PsInOr),A
	RET

C_VIBRT:
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_OnOffD),A
	LD (IX-12+CHP_COnOff),A
	LD A,(BC)
	INC BC
	LD (IX-12+CHP_OffOnD),A
	XOR A
	LD (IX-12+CHP_TSlCnt),A
	LD (IX-12+CHP_CrTnSl),A
	LD (IX-12+CHP_CrTnSl+1),A
	RET

C_ENGLS:
	LD A,(BC)
	INC BC
	LD (Env_Del),A
	LD (CurEDel),A
	LD A,(BC)
	INC BC
	LD L,A
	LD A,(BC)
	INC BC
	LD H,A
	LD (ESldAdd),HL
	RET

C_DELAY:
	LD A,(BC)
	INC BC
	LD (Delay),A
	RET
	
SETENV:
	LD (IX-12+CHP_Env_En),E
	LD (AYREGS+EnvTp),A
	LD A,(BC)
	INC BC
	LD H,A
	LD A,(BC)
	INC BC
	LD L,A
	LD (EnvBase),HL
	XOR A
	LD (IX-12+CHP_PsInOr),A
	LD (CurEDel),A
	LD H,A
	LD L,A
	LD (CurESld),HL
C_NOP:
	RET

SETORN:
	ADD A,A
	LD E,A
	LD D,0
	LD (IX-12+CHP_PsInOr),D
;DEFC OrnPtrs = ASMPC+1
;	LD HL,$2121
	LD HL,(OrnPtrs)
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
;DEFC MDADDR2 = ASMPC+1
;	LD HL,$2121
	LD HL,(MODADDR)
	ADD HL,DE
	LD (IX-12+CHP_OrnPtr),L
	LD (IX-12+CHP_OrnPtr+1),H
	RET

;ALL 16 ADDRESSES TO PROTECT FROM BROKEN PT3 MODULES
SPCCOMS:
	DEFW C_NOP
	DEFW C_GLISS
	DEFW C_PORTM
	DEFW C_SMPOS
	DEFW C_ORPOS
	DEFW C_VIBRT
	DEFW C_NOP
	DEFW C_NOP
	DEFW C_ENGLS
	DEFW C_DELAY
	DEFW C_NOP
	DEFW C_NOP
	DEFW C_NOP
	DEFW C_NOP
	DEFW C_NOP
	DEFW C_NOP

CHREGS:
	XOR A
	LD (Ampl),A
	BIT 0,(IX+CHP_Flags)
	PUSH HL
	JP Z,CH_EXIT
;	LD (CSP_+1),SP
	LD (CSP_),SP
	LD L,(IX+CHP_OrnPtr)
	LD H,(IX+CHP_OrnPtr+1)
	LD SP,HL
	POP DE
	LD H,A
	LD A,(IX+CHP_PsInOr)
	LD L,A
	ADD HL,SP
	INC A
	CP D
	JR C,CH_ORPS
	LD A,E
CH_ORPS:
	LD (IX+CHP_PsInOr),A
	LD A,(IX+CHP_Note)
	ADD A,(HL)
	JP P,CH_NTP
	XOR A
CH_NTP:
	CP 96
	JR C,CH_NOK
	LD A,95
CH_NOK:
	ADD A,A
	EX AF,AF'
	LD L,(IX+CHP_SamPtr)
	LD H,(IX+CHP_SamPtr+1)
	LD SP,HL
	POP DE
	LD H,0
	LD A,(IX+CHP_PsInSm)
	LD B,A
	ADD A,A
	ADD A,A
	LD L,A
	ADD HL,SP
	LD SP,HL
	LD A,B
	INC A
	CP D
	JR C,CH_SMPS
	LD A,E
CH_SMPS:
	LD (IX+CHP_PsInSm),A
	POP BC
	POP HL
	LD E,(IX+CHP_TnAcc)
	LD D,(IX+CHP_TnAcc+1)
	ADD HL,DE
	BIT 6,B
	JR Z,CH_NOAC
	LD (IX+CHP_TnAcc),L
	LD (IX+CHP_TnAcc+1),H
CH_NOAC:
	EX DE,HL
	EX AF,AF'
	LD L,A
	LD H,0
	LD SP,NT_
	ADD HL,SP
	LD SP,HL
	POP HL
	ADD HL,DE
	LD E,(IX+CHP_CrTnSl)
	LD D,(IX+CHP_CrTnSl+1)
	ADD HL,DE
;CSP_:
;	LD SP,$3131
	LD SP,(CSP_)
	EX (SP),HL
	XOR A
	OR (IX+CHP_TSlCnt)
	JR Z,CH_AMP
	DEC (IX+CHP_TSlCnt)
	JR NZ,CH_AMP
	LD A,(IX+CHP_TnSlDl)
	LD (IX+CHP_TSlCnt),A
	LD L,(IX+CHP_TSlStp)
	LD H,(IX+CHP_TSlStp+1)
	LD A,H
	ADD HL,DE
	LD (IX+CHP_CrTnSl),L
	LD (IX+CHP_CrTnSl+1),H
	BIT 2,(IX+CHP_Flags)
	JR NZ,CH_AMP
	LD E,(IX+CHP_TnDelt)
	LD D,(IX+CHP_TnDelt+1)
	AND A
	JR Z,CH_STPP
	EX DE,HL
CH_STPP:
	SBC HL,DE
	JP M,CH_AMP
	LD A,(IX+CHP_SlToNt)
	LD (IX+CHP_Note),A
	XOR A
	LD (IX+CHP_TSlCnt),A
	LD (IX+CHP_CrTnSl),A
	LD (IX+CHP_CrTnSl+1),A
CH_AMP:
	LD A,(IX+CHP_CrAmSl)
	BIT 7,C
	JR Z,CH_NOAM
	BIT 6,C
	JR Z,CH_AMIN
	CP 15
	JR Z,CH_NOAM
	INC A
	JR CH_SVAM
CH_AMIN:
	CP -15
	JR Z,CH_NOAM
	DEC A
CH_SVAM:
	LD (IX+CHP_CrAmSl),A
CH_NOAM:
	LD L,A
	LD A,B
	AND 15
	ADD A,L
	JP P,CH_APOS
	XOR A
CH_APOS:
	CP 16
	JR C,CH_VOL
	LD A,15
CH_VOL:
	OR (IX+CHP_Volume)
	LD L,A
	LD H,0
	LD DE,VT_
	ADD HL,DE
	LD A,(HL)
CH_ENV:
	BIT 0,C
	JR NZ,CH_NOEN
	OR (IX+CHP_Env_En)
CH_NOEN:
	LD (Ampl),A
	BIT 7,B
	LD A,C
	JR Z,NO_ENSL
	RLA
	RLA
	SRA A
	SRA A
	SRA A
	ADD A,(IX+CHP_CrEnSl) ;SEE COMMENT BELOW
	BIT 5,B
	JR Z,NO_ENAC
	LD (IX+CHP_CrEnSl),A
NO_ENAC:
	LD HL,AddToEn
	ADD A,(HL) ;BUG IN PT3 - NEED WORD HERE.
		   ;FIX IT IN NEXT VERSION?
	LD (HL),A
	JR CH_MIX
NO_ENSL:
	RRA
	ADD A,(IX+CHP_CrNsSl)
	LD (AddToNs),A
	BIT 5,B
	JR Z,CH_MIX
	LD (IX+CHP_CrNsSl),A
CH_MIX:
	LD A,B
	RRA
	AND $48
CH_EXIT:
	LD HL,AYREGS+Mixer
	OR (HL)
	RRCA
	LD (HL),A
	POP HL
	XOR A
	OR (IX+CHP_COnOff)
	RET Z
	DEC (IX+CHP_COnOff)
	RET NZ
	XOR (IX+CHP_Flags)
	LD (IX+CHP_Flags),A
	RRA
	LD A,(IX+CHP_OnOffD)
	JR C,CH_ONDL
	LD A,(IX+CHP_OffOnD)
CH_ONDL:
	LD (IX+CHP_COnOff),A
	RET

PLAY:
	XOR A
	LD (AddToEn),A
	LD (AYREGS+Mixer),A
	DEC A
	LD (AYREGS+EnvTp),A
	LD HL,DelyCnt
	DEC (HL)
	JP NZ,PL2
	LD HL,ChanA+CHP_NtSkCn
	DEC (HL)
	JR NZ,PL1B
;DEFC AdInPtA = ASMPC+1
;	LD BC,$0101
	LD BC,(AdInPtA)
	LD A,(BC)
	AND A
	JR NZ,PL1A
	LD D,A
	LD (Ns_Base),A
	LD HL,(CrPsPtr)
	INC HL
	LD A,(HL)
	INC A
	JR NZ,PLNLP
	CALL CHECKLP
;DEFC LPosPtr = ASMPC+1
;	LD HL,$2121
	LD HL,(LPosPtr)
	LD A,(HL)
	INC A
PLNLP:
	LD (CrPsPtr),HL
	DEC A
	ADD A,A
	LD E,A
	RL D
;DEFC PatsPtr = ASMPC+1
;	LD HL,$2121
	LD HL,(PatsPtr)
	ADD HL,DE
	LD DE,(MODADDR)
;	LD (PSP_+1),SP
	LD (PSP_),SP
	LD SP,HL
	POP HL
	ADD HL,DE
	LD B,H
	LD C,L
	POP HL
	ADD HL,DE
	LD (AdInPtB),HL
	POP HL
	ADD HL,DE
	LD (AdInPtC),HL
;PSP_:
;	LD SP,$3131
	LD SP,(PSP_)
PL1A:
	LD IX,ChanA+12
	CALL PTDECOD
	LD (AdInPtA),BC

PL1B:
	LD HL,ChanB+CHP_NtSkCn
	DEC (HL)
	JR NZ,PL1C
	LD IX,ChanB+12
;DEFC AdInPtB = ASMPC+1
;	LD BC,$0101
	LD BC,(AdInPtB)
	CALL PTDECOD
	LD (AdInPtB),BC

PL1C:
	LD HL,ChanC+CHP_NtSkCn
	DEC (HL)
	JR NZ,PL1D
	LD IX,ChanC+12
;DEFC AdInPtC = ASMPC+1
;	LD BC,$0101
	LD BC,(AdInPtC)
	CALL PTDECOD
	LD (AdInPtC),BC

;DEFC Delay = ASMPC+1
PL1D:
;	LD A,$3E
	LD A,(Delay)
	LD (DelyCnt),A

PL2:
	LD IX,ChanA
	LD HL,(AYREGS+TonA)
	CALL CHREGS
	LD (AYREGS+TonA),HL
	LD A,(Ampl)
	LD (AYREGS+AmplA),A
	LD IX,ChanB
	LD HL,(AYREGS+TonB)
	CALL CHREGS
	LD (AYREGS+TonB),HL
	LD A,(Ampl)
	LD (AYREGS+AmplB),A
	LD IX,ChanC
	LD HL,(AYREGS+TonC)
	CALL CHREGS
;	LD A,(Ampl) ;Ampl = AYREGS+AmplC
;	LD (AYREGS+AmplC),A
	LD (AYREGS+TonC),HL

	LD HL,(Ns_Base_AddToNs)
	LD A,H
	ADD A,L
	LD (AYREGS+Noise),A

;DEFC AddToEn = ASMPC+1
;	LD A,$3E
	LD A,(AddToEn)
	LD E,A
	ADD A,A
	SBC A,A
	LD D,A
	LD HL,(EnvBase)
	ADD HL,DE
	LD DE,(CurESld)
	ADD HL,DE
	LD (AYREGS+Env),HL

	XOR A
	LD HL,CurEDel
	OR (HL)
	JP Z,asm_vt_hardware_out_A0
	DEC (HL)
	JP NZ,asm_vt_hardware_out
;DEFC Env_Del = ASMPC+1
;	LD A,$3E
	LD A,(Env_Del)
	LD (HL),A
;DEFC ESldAdd = ASMPC+1
;	LD HL,$2121
	LD HL,(ESldAdd)
	ADD HL,DE
	LD (CurESld),HL
	JP asm_vt_hardware_out


NT_DATA:
	DEFB (T_NEW_0-T1_)*2
	DEFB TCNEW_0-T_
	DEFB (T_OLD_0-T1_)*2+1
	DEFB TCOLD_0-T_
	DEFB (T_NEW_1-T1_)*2+1
	DEFB TCNEW_1-T_
	DEFB (T_OLD_1-T1_)*2+1
	DEFB TCOLD_1-T_
	DEFB (T_NEW_2-T1_)*2
	DEFB TCNEW_2-T_
	DEFB (T_OLD_2-T1_)*2
	DEFB TCOLD_2-T_
	DEFB (T_NEW_3-T1_)*2
	DEFB TCNEW_3-T_
	DEFB (T_OLD_3-T1_)*2
	DEFB TCOLD_3-T_

T_:

TCOLD_0:
	DEFB $00+1,$04+1,$08+1,$0A+1,$0C+1,$0E+1,$12+1,$14+1
	DEFB $18+1,$24+1,$3C+1,0
TCOLD_1:
	DEFB $5C+1,0
TCOLD_2:
	DEFB $30+1,$36+1,$4C+1,$52+1,$5E+1,$70+1,$82,$8C,$9C
	DEFB $9E,$A0,$A6,$A8,$AA,$AC,$AE,$AE,0
TCNEW_3:
	DEFB $56+1
TCOLD_3:
	DEFB $1E+1,$22+1,$24+1,$28+1,$2C+1,$2E+1,$32+1,$BE+1,0
TCNEW_0:
	DEFB $1C+1,$20+1,$22+1,$26+1,$2A+1,$2C+1,$30+1,$54+1
	DEFB $BC+1,$BE+1,0
DEFC TCNEW_1 = TCOLD_1
TCNEW_2:
	DEFB $1A+1,$20+1,$24+1,$28+1,$2A+1,$3A+1,$4C+1,$5E+1
	DEFB $BA+1,$BC+1,$BE+1,0

DEFC EMPTYSAMORN = ASMPC-1
	DEFB 1,0,$90 ;delete $90 if you don't need default sample

;first 12 values of tone tables (packed)

T_PACK:
	DEFB ($06EC*2/256) % 256,($06EC*2) % 256
	DEFB $0755-$06EC
	DEFB $07C5-$0755
	DEFB $083B-$07C5
	DEFB $08B8-$083B
	DEFB $093D-$08B8
	DEFB $09CA-$093D
	DEFB $0A5F-$09CA
	DEFB $0AFC-$0A5F
	DEFB $0BA4-$0AFC
	DEFB $0C55-$0BA4
	DEFB $0D10-$0C55
	DEFB ($066D*2/256) % 256, ($066D*2) % 256
	DEFB $06CF-$066D
	DEFB $0737-$06CF
	DEFB $07A4-$0737
	DEFB $0819-$07A4
	DEFB $0894-$0819
	DEFB $0917-$0894
	DEFB $09A1-$0917
	DEFB $0A33-$09A1
	DEFB $0ACF-$0A33
	DEFB $0B73-$0ACF
	DEFB $0C22-$0B73
	DEFB $0CDA-$0C22
	DEFB ($0704*2/256) % 256, ($0704*2) % 256
	DEFB $076E-$0704
	DEFB $07E0-$076E
	DEFB $0858-$07E0
	DEFB $08D6-$0858
	DEFB $095C-$08D6
	DEFB $09EC-$095C
	DEFB $0A82-$09EC
	DEFB $0B22-$0A82
	DEFB $0BCC-$0B22
	DEFB $0C80-$0BCC
	DEFB $0D3E-$0C80
	DEFB ($07E0*2/256) % 256,($07E0*2) % 256
	DEFB $0858-$07E0
	DEFB $08E0-$0858
	DEFB $0960-$08E0
	DEFB $09F0-$0960
	DEFB $0A88-$09F0
	DEFB $0B28-$0A88
	DEFB $0BD8-$0B28
	DEFB $0C80-$0BD8
	DEFB $0D60-$0C80
	DEFB $0E10-$0D60
	DEFB $0EF8-$0E10

SECTION data_psg

;vars from here can be stripped
;you can move VARS to any other address

VARS:

;vars in code and other self-modified code moved here
;(for ROM and RAM separation)
SETUP:
	DEFB 0 ;set bit0 to 1, if you want to play without looping
	     ;bit7 is set each time, when loop point is passed
CrPsPtr:
	DEFW 0
AddToEn:
	DEFB 0
AdInPtA:
	DEFW 0
AdInPtB:
	DEFW 0
AdInPtC:
	DEFW 0
Env_Del:
	DEFB 0
MODADDR:
	DEFW 0
ESldAdd:
	DEFW 0
Delay:
	DEFB 0
PDSP_:
CSP_:
PSP_:
	DEFW 0
SamPtrs:
	DEFW 0
OrnPtrs:
	DEFW 0
PatsPtr:
	DEFW 0
LPosPtr:
	DEFW 0
L3:
M2:
PrSlide:
	DEFW 0
PrNote:
	DEFB 0
Version:
	DEFB 0
;end of moved vars and self-modified code

VAR0START: ;START of INITZERO area

ChanA:
	DEFS CHP
ChanB:
	DEFS CHP
ChanC:
	DEFS CHP

;GlobalVars
DelyCnt:
	DEFB 0
CurESld:
	DEFW 0
CurEDel:
	DEFB 0
Ns_Base_AddToNs:
Ns_Base:
	DEFB 0
AddToNs:
	DEFB 0

asm_VT_AYREGS:
AYREGS:

VT_:
	DEFS 256 ;CreatedVolumeTableAddress

DEFC EnvBase = VT_+14

DEFC T1_ = VT_+16 ;Tone tables data depacked here

DEFC T_OLD_1 = T1_
DEFC T_OLD_2 = T_OLD_1+24
DEFC T_OLD_3 = T_OLD_2+24
DEFC T_OLD_0 = T_OLD_3+2
DEFC T_NEW_0 = T_OLD_0
DEFC T_NEW_1 = T_OLD_1
DEFC T_NEW_2 = T_NEW_0+24
DEFC T_NEW_3 = T_OLD_3

NT_:
	DEFS 192 ;CreatedNoteTableAddress

;local var
DEFC Ampl = AYREGS+AmplC

DEFC VAR0END = VT_+16 ;INIT zeroes from VARS to VAR0END-1

DEFC VARSEND = ASMPC

DEFC MDLADDR = ASMPC

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
;15.Apr.2007 - all in-code variables and self-modified code
;moved to VARS (specially for Axor), code can run in ROM now.
;29.Apr.2007 - new 1.xx and 2.xx interpretation for PT 3.7+.

;Size:
;Code block $664 bytes
;Variables $23B bytes (can be stripped)
;Size in RAM $664+$23B=$89F (2207) bytes

;Notes:
;Pro Tracker 3.4r can not be detected by header, so PT3.4r tone
;tables really used only for modules of 3.3 and older versions.
ENDIF
