 ;      Test-room for
 ;      Microdrive commands
 ;       ORG  23296    ;printer buffer

.TESTRM RST  8
        DEFB $31      ;create extra system variables
        LD   BC,659   ;required space
        JP   $1F05    ;test-room
 ;
 ;      True CLEAR#
.CLEAR  LD   DE,23792
        LD   HL,(CHANS)
        PUSH HL
        AND  A
        SBC  HL,DE
        POP  HL
        CALL NZ,$19E5 ;reclaim maps if CHANS<>23792
        LD   HL,(CHANS)
        LD   DE,20
        ADD  HL,DE
        EX   DE,HL
        LD   HL,(PROG)
        DEC  HL
        LD   A,(DE)
        CP   $80
        CALL NZ,$19E5 ;reclaim channel bytes
        RET
 ;
 ;set constants
 CHANS  EQU  23631
 PROG   EQU  23635
 ;
 ;
 ;COLLAPSE to remove extra system variables
.COLAPS LD   HL,(CHANS)
        LD   DE,$A349
        ADD  HL,DE
        RET  NC       ;return if no variables anyway
        LD   HL,$5CF0 ;end of area
        LD   DE,$5CB6 ;start of area
        JP   $19E5    ;reclaim the area
