 TST B                  ;; 018C:  ED 04
 TST C                  ;; 018C:  ED 0C
 TST D                  ;; 018C:  ED 14
 TST E                  ;; 018C:  ED 1C
 TST H                  ;; 018C:  ED 24
 TST L                  ;; 018C:  ED 2C
 TST A                  ;; 018C:  ED 3C
 TST 0                  ;; 018C:  ED 64 00
 TST 85                 ;; 018C:  ED 64 55
 TST 170                ;; 018C:  ED 64 AA
 TST 255                ;; 018C:  ED 64 FF
 TST (HL)               ;; 018C:  ED 34
 SLP                    ;; 0198:  ED 76
 ALTD                   ;; 0198:  76
 LD A, XPC              ;; 0198:  ED 77
 LD XPC, A              ;; 0198:  ED 67
 ADD SP, -128           ;; 01AC:  27 80
 ADD SP, 0              ;; 01AC:  27 00
 ADD SP, 127            ;; 01AC:  27 7F
 AND HL, DE             ;; 01BC:  DC
 AND IX, DE             ;; 01BC:  DD DC
 AND IY, DE             ;; 01BC:  FD DC
 BOOL HL                ;; 01BC:  CC
 BOOL IX                ;; 01BC:  DD CC
 BOOL IY                ;; 01BC:  FD CC
 MLT BC                 ;; 01CC:  ED 4C
 MLT DE                 ;; 01CC:  ED 5C
 MLT HL                 ;; 01CC:  ED 6C
 MLT SP                 ;; 01CC:  ED 7C
 JP LZ, 0               ;; 073C:  E2 00 00
 JP LZ, 4660            ;; 073C:  E2 34 12
 JP LZ, 52719           ;; 073C:  E2 EF CD
 JP LZ, 65535           ;; 073C:  E2 FF FF
 JP LO, 0               ;; 073C:  EA 00 00
 JP LO, 4660            ;; 073C:  EA 34 12
 JP LO, 52719           ;; 073C:  EA EF CD
 JP LO, 65535           ;; 073C:  EA FF FF
 RET LZ                 ;; 07C2:  E0
 RET LO                 ;; 07C2:  E8
 IN0 B, (0)             ;; 0806:  ED 00 00
 IN0 B, (85)            ;; 0806:  ED 00 55
 IN0 B, (170)           ;; 0806:  ED 00 AA
 IN0 B, (255)           ;; 0806:  ED 00 FF
 IN0 C, (0)             ;; 0806:  ED 08 00
 IN0 C, (85)            ;; 0806:  ED 08 55
 IN0 C, (170)           ;; 0806:  ED 08 AA
 IN0 C, (255)           ;; 0806:  ED 08 FF
 IN0 D, (0)             ;; 0806:  ED 10 00
 IN0 D, (85)            ;; 0806:  ED 10 55
 IN0 D, (170)           ;; 0806:  ED 10 AA
 IN0 D, (255)           ;; 0806:  ED 10 FF
 IN0 E, (0)             ;; 0806:  ED 18 00
 IN0 E, (85)            ;; 0806:  ED 18 55
 IN0 E, (170)           ;; 0806:  ED 18 AA
 IN0 E, (255)           ;; 0806:  ED 18 FF
 IN0 H, (0)             ;; 0806:  ED 20 00
 IN0 H, (85)            ;; 0806:  ED 20 55
 IN0 H, (170)           ;; 0806:  ED 20 AA
 IN0 H, (255)           ;; 0806:  ED 20 FF
 IN0 L, (0)             ;; 0806:  ED 28 00
 IN0 L, (85)            ;; 0806:  ED 28 55
 IN0 L, (170)           ;; 0806:  ED 28 AA
 IN0 L, (255)           ;; 0806:  ED 28 FF
 IN0 A, (0)             ;; 0806:  ED 38 00
 IN0 A, (85)            ;; 0806:  ED 38 55
 IN0 A, (170)           ;; 0806:  ED 38 AA
 IN0 A, (255)           ;; 0806:  ED 38 FF
 OUT0 (0), B            ;; 0806:  ED 01 00
 OUT0 (85), B           ;; 0806:  ED 01 55
 OUT0 (170), B          ;; 0806:  ED 01 AA
 OUT0 (255), B          ;; 0806:  ED 01 FF
 OUT0 (0), C            ;; 0806:  ED 09 00
 OUT0 (85), C           ;; 0806:  ED 09 55
 OUT0 (170), C          ;; 0806:  ED 09 AA
 OUT0 (255), C          ;; 0806:  ED 09 FF
 OUT0 (0), D            ;; 0806:  ED 11 00
 OUT0 (85), D           ;; 0806:  ED 11 55
 OUT0 (170), D          ;; 0806:  ED 11 AA
 OUT0 (255), D          ;; 0806:  ED 11 FF
 OUT0 (0), E            ;; 0806:  ED 19 00
 OUT0 (85), E           ;; 0806:  ED 19 55
 OUT0 (170), E          ;; 0806:  ED 19 AA
 OUT0 (255), E          ;; 0806:  ED 19 FF
 OUT0 (0), H            ;; 0806:  ED 21 00
 OUT0 (85), H           ;; 0806:  ED 21 55
 OUT0 (170), H          ;; 0806:  ED 21 AA
 OUT0 (255), H          ;; 0806:  ED 21 FF
 OUT0 (0), L            ;; 0806:  ED 29 00
 OUT0 (85), L           ;; 0806:  ED 29 55
 OUT0 (170), L          ;; 0806:  ED 29 AA
 OUT0 (255), L          ;; 0806:  ED 29 FF
 OUT0 (0), A            ;; 0806:  ED 39 00
 OUT0 (85), A           ;; 0806:  ED 39 55
 OUT0 (170), A          ;; 0806:  ED 39 AA
 OUT0 (255), A          ;; 0806:  ED 39 FF
 OTDM                   ;; 0806:  ED 8B
 OTDMR                  ;; 0806:  ED 9B
 OTIM                   ;; 0806:  ED 83
 OTIMR                  ;; 0806:  ED 93
 TSTIO 0                ;; 0806:  ED 74 00
 TSTIO 85               ;; 0806:  ED 74 55
 TSTIO 170              ;; 0806:  ED 74 AA
 TSTIO 255              ;; 0806:  ED 74 FF
 IOE                    ;; 0806:  DB
 IOI                    ;; 0806:  D3
 IPSET 0                ;; 080E:  ED 46
 IPSET 1                ;; 080E:  ED 56
 IPSET 2                ;; 080E:  ED 4E
 IPSET 3                ;; 080E:  ED 5E
 IPRES                  ;; 080E:  ED 5D
 LD IIR, A              ;; 0816:  ED 47
 LD A, IIR              ;; 0816:  ED 57
 LD EIR, A              ;; 0816:  ED 4F
 LD A, EIR              ;; 0816:  ED 5F
 IDET                   ;; 081A:  5B
 ld (hl + -128), hl     ;; 0C26:  DD F4 80
 ld (hl + 0), hl        ;; 0C26:  DD F4 00
 ld (hl + 127), hl      ;; 0C26:  DD F4 7F
 ld (ix + -128), hl     ;; 0C26:  F4 80
 ld (ix + 0), hl        ;; 0C26:  F4 00
 ld (ix + 127), hl      ;; 0C26:  F4 7F
 ld (iy + -128), hl     ;; 0C26:  FD F4 80
 ld (iy + 0), hl        ;; 0C26:  FD F4 00
 ld (iy + 127), hl      ;; 0C26:  FD F4 7F
 ld (sp + 0), hl        ;; 0C26:  D4 00
 ld (sp + 85), hl       ;; 0C26:  D4 55
 ld (sp + 170), hl      ;; 0C26:  D4 AA
 ld (sp + 255), hl      ;; 0C26:  D4 FF
 ld (sp + 0), ix        ;; 0C26:  DD D4 00
 ld (sp + 85), ix       ;; 0C26:  DD D4 55
 ld (sp + 170), ix      ;; 0C26:  DD D4 AA
 ld (sp + 255), ix      ;; 0C26:  DD D4 FF
 ld (sp + 0), iy        ;; 0C26:  FD D4 00
 ld (sp + 85), iy       ;; 0C26:  FD D4 55
 ld (sp + 170), iy      ;; 0C26:  FD D4 AA
 ld (sp + 255), iy      ;; 0C26:  FD D4 FF
 ld bc', bc             ;; 0C26:  ED 49
 ld bc', de             ;; 0C26:  ED 41
 ld de', bc             ;; 0C26:  ED 59
 ld de', de             ;; 0C26:  ED 51
 ld hl', bc             ;; 0C26:  ED 69
 ld hl', de             ;; 0C26:  ED 61
 ex de', hl             ;; 0C2F:  E3
 ex de, hl'             ;; 0C2F:  76 EB
 ex de', hl'            ;; 0C2F:  76 E3
