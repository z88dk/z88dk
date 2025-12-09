;
; This fast pixel routine was posted to the forum here: https://www.z88dk.org/forum/viewtopic.php?p=24144#p24144
;
; Note, alternate registers are used
;

    SECTION code_clib
    PUBLIC  fastdot_MODE0


fastdot_MODE0:
    PUSH DE
    EXX
    POP DE
    OR A
    PUSH AF
    LD C,D
    PUSH BC
    LD BC,0x20
    INC E
    LD HL,0x2800
goY:
    LD D,3
    LD A,1
y3:
    DEC E
    JR Z,gotov
    RLCA
    RLCA
    DEC D
    JR NZ,y3
    ADD HL,BC
    RES 1,H
    JR goY
gotov:
    LD B,A
    EX (SP),HL
    RES 7,L
    RES 6,L
    SRL L
    JR NC,parni
    RLCA
parni:
    LD H,0
    POP BC
    ADD HL,BC
    LD B,A
    POP AF
    LD A,B
    JR NZ,sres
    BIT 7,(HL)
    JR Z,exret
    AND (HL)
exret:
    EXX
    RET

sres:
    PUSH AF
    BIT 7,(HL)
    JR NZ,sr
    LD (HL),0x80
sr:
    POP AF
    JP M,setxy
    CPL
    AND (HL)
    LD (HL),A
    EXX
    RET

setxy:
    OR (HL)
    LD (HL),A
    EXX
    RET