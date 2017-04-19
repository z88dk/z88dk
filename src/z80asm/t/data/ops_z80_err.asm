 EX DE', HL             ;; 0384:  E3
 EX DE, HL'             ;; 0384:  76 EB
 EX DE', HL'            ;; 0384:  76 E3
 TST B                  ;; 0518:  ED 04
 TST C                  ;; 0518:  ED 0C
 TST D                  ;; 0518:  ED 14
 TST E                  ;; 0518:  ED 1C
 TST H                  ;; 0518:  ED 24
 TST L                  ;; 0518:  ED 2C
 TST A                  ;; 0518:  ED 3C
 TST 0                  ;; 0518:  ED 64 00
 TST 85                 ;; 0518:  ED 64 55
 TST 170                ;; 0518:  ED 64 AA
 TST 255                ;; 0518:  ED 64 FF
 TST (HL)               ;; 0518:  ED 34
 SLP                    ;; 0524:  ED 76
 ALTD                   ;; 0524:  76
 ADD SP, -128           ;; 0538:  27 80
 ADD SP, 0              ;; 0538:  27 00
 ADD SP, 127            ;; 0538:  27 7F
 AND HL, DE             ;; 0548:  DC
 AND IX, DE             ;; 0548:  DD DC
 AND IY, DE             ;; 0548:  FD DC
 BOOL HL                ;; 0548:  CC
 BOOL IX                ;; 0548:  DD CC
 BOOL IY                ;; 0548:  FD CC
 MLT BC                 ;; 0558:  ED 4C
 MLT DE                 ;; 0558:  ED 5C
 MLT HL                 ;; 0558:  ED 6C
 MLT SP                 ;; 0558:  ED 7C
 JP LZ, 0               ;; 0AC8:  E2 00 00
 JP LZ, 4660            ;; 0AC8:  E2 34 12
 JP LZ, 52719           ;; 0AC8:  E2 EF CD
 JP LZ, 65535           ;; 0AC8:  E2 FF FF
 JP LO, 0               ;; 0AC8:  EA 00 00
 JP LO, 4660            ;; 0AC8:  EA 34 12
 JP LO, 52719           ;; 0AC8:  EA EF CD
 JP LO, 65535           ;; 0AC8:  EA FF FF
 RET LZ                 ;; 0B4E:  E0
 RET LO                 ;; 0B4E:  E8
 IN0 B, (0)             ;; 0B92:  ED 00 00
 IN0 B, (85)            ;; 0B92:  ED 00 55
 IN0 B, (170)           ;; 0B92:  ED 00 AA
 IN0 B, (255)           ;; 0B92:  ED 00 FF
 IN0 C, (0)             ;; 0B92:  ED 08 00
 IN0 C, (85)            ;; 0B92:  ED 08 55
 IN0 C, (170)           ;; 0B92:  ED 08 AA
 IN0 C, (255)           ;; 0B92:  ED 08 FF
 IN0 D, (0)             ;; 0B92:  ED 10 00
 IN0 D, (85)            ;; 0B92:  ED 10 55
 IN0 D, (170)           ;; 0B92:  ED 10 AA
 IN0 D, (255)           ;; 0B92:  ED 10 FF
 IN0 E, (0)             ;; 0B92:  ED 18 00
 IN0 E, (85)            ;; 0B92:  ED 18 55
 IN0 E, (170)           ;; 0B92:  ED 18 AA
 IN0 E, (255)           ;; 0B92:  ED 18 FF
 IN0 H, (0)             ;; 0B92:  ED 20 00
 IN0 H, (85)            ;; 0B92:  ED 20 55
 IN0 H, (170)           ;; 0B92:  ED 20 AA
 IN0 H, (255)           ;; 0B92:  ED 20 FF
 IN0 L, (0)             ;; 0B92:  ED 28 00
 IN0 L, (85)            ;; 0B92:  ED 28 55
 IN0 L, (170)           ;; 0B92:  ED 28 AA
 IN0 L, (255)           ;; 0B92:  ED 28 FF
 IN0 A, (0)             ;; 0B92:  ED 38 00
 IN0 A, (85)            ;; 0B92:  ED 38 55
 IN0 A, (170)           ;; 0B92:  ED 38 AA
 IN0 A, (255)           ;; 0B92:  ED 38 FF
 OUT0 (0), B            ;; 0B92:  ED 01 00
 OUT0 (85), B           ;; 0B92:  ED 01 55
 OUT0 (170), B          ;; 0B92:  ED 01 AA
 OUT0 (255), B          ;; 0B92:  ED 01 FF
 OUT0 (0), C            ;; 0B92:  ED 09 00
 OUT0 (85), C           ;; 0B92:  ED 09 55
 OUT0 (170), C          ;; 0B92:  ED 09 AA
 OUT0 (255), C          ;; 0B92:  ED 09 FF
 OUT0 (0), D            ;; 0B92:  ED 11 00
 OUT0 (85), D           ;; 0B92:  ED 11 55
 OUT0 (170), D          ;; 0B92:  ED 11 AA
 OUT0 (255), D          ;; 0B92:  ED 11 FF
 OUT0 (0), E            ;; 0B92:  ED 19 00
 OUT0 (85), E           ;; 0B92:  ED 19 55
 OUT0 (170), E          ;; 0B92:  ED 19 AA
 OUT0 (255), E          ;; 0B92:  ED 19 FF
 OUT0 (0), H            ;; 0B92:  ED 21 00
 OUT0 (85), H           ;; 0B92:  ED 21 55
 OUT0 (170), H          ;; 0B92:  ED 21 AA
 OUT0 (255), H          ;; 0B92:  ED 21 FF
 OUT0 (0), L            ;; 0B92:  ED 29 00
 OUT0 (85), L           ;; 0B92:  ED 29 55
 OUT0 (170), L          ;; 0B92:  ED 29 AA
 OUT0 (255), L          ;; 0B92:  ED 29 FF
 OUT0 (0), A            ;; 0B92:  ED 39 00
 OUT0 (85), A           ;; 0B92:  ED 39 55
 OUT0 (170), A          ;; 0B92:  ED 39 AA
 OUT0 (255), A          ;; 0B92:  ED 39 FF
 OTDM                   ;; 0B92:  ED 8B
 OTDMR                  ;; 0B92:  ED 9B
 OTIM                   ;; 0B92:  ED 83
 OTIMR                  ;; 0B92:  ED 93
 TSTIO 0                ;; 0B92:  ED 74 00
 TSTIO 85               ;; 0B92:  ED 74 55
 TSTIO 170              ;; 0B92:  ED 74 AA
 TSTIO 255              ;; 0B92:  ED 74 FF
 IOE                    ;; 0B92:  DB
 IOI                    ;; 0B92:  D3
 IPSET 0                ;; 0B9A:  ED 46
 IPSET 1                ;; 0B9A:  ED 56
 IPSET 2                ;; 0B9A:  ED 4E
 IPSET 3                ;; 0B9A:  ED 5E
 IPRES                  ;; 0B9A:  ED 5D
 LD IIR, A              ;; 0BA2:  ED 47
 LD A, IIR              ;; 0BA2:  ED 57
 LD EIR, A              ;; 0BA2:  ED 4F
 LD A, EIR              ;; 0BA2:  ED 5F
 IDET                   ;; 0BA6:  5B
