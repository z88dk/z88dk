 LD (HL + -128), HL     ;; 011D:  DD F4 80
 LD (HL + 0), HL        ;; 011D:  DD F4 00
 LD (HL + 127), HL      ;; 011D:  DD F4 7F
 LD (ix + -128), HL     ;; 011D:  F4 80
 LD (ix + 0), HL        ;; 011D:  F4 00
 LD (ix + 127), HL      ;; 011D:  F4 7F
 LD (iy + -128), HL     ;; 011D:  FD F4 80
 LD (iy + 0), HL        ;; 011D:  FD F4 00
 LD (iy + 127), HL      ;; 011D:  FD F4 7F
 LD (SP + 0), HL        ;; 011D:  D4 00
 LD (SP + 85), HL       ;; 011D:  D4 55
 LD (SP + 170), HL      ;; 011D:  D4 AA
 LD (SP + 255), HL      ;; 011D:  D4 FF
 LD (SP + 0), IX        ;; 011D:  DD D4 00
 LD (SP + 85), IX       ;; 011D:  DD D4 55
 LD (SP + 170), IX      ;; 011D:  DD D4 AA
 LD (SP + 255), IX      ;; 011D:  DD D4 FF
 LD (SP + 0), IY        ;; 011D:  FD D4 00
 LD (SP + 85), IY       ;; 011D:  FD D4 55
 LD (SP + 170), IY      ;; 011D:  FD D4 AA
 LD (SP + 255), IY      ;; 011D:  FD D4 FF
 EX DE', HL             ;; 0125:  E3
 EX DE, HL'             ;; 0125:  76 EB
 EX DE', HL'            ;; 0125:  76 E3
 TST B                  ;; 02B9:  ED 04
 TST C                  ;; 02B9:  ED 0C
 TST D                  ;; 02B9:  ED 14
 TST E                  ;; 02B9:  ED 1C
 TST H                  ;; 02B9:  ED 24
 TST L                  ;; 02B9:  ED 2C
 TST A                  ;; 02B9:  ED 3C
 TST 0                  ;; 02B9:  ED 64 00
 TST 85                 ;; 02B9:  ED 64 55
 TST 170                ;; 02B9:  ED 64 AA
 TST 255                ;; 02B9:  ED 64 FF
 TST (HL)               ;; 02B9:  ED 34
 SLP                    ;; 02C5:  ED 76
 ALTD                   ;; 02C5:  76
 LD A, XPC              ;; 02C5:  ED 77
 LD XPC, A              ;; 02C5:  ED 67
 ADD SP, -128           ;; 02D9:  27 80
 ADD SP, 0              ;; 02D9:  27 00
 ADD SP, 127            ;; 02D9:  27 7F
 AND HL, DE             ;; 02E9:  DC
 AND IX, DE             ;; 02E9:  DD DC
 AND IY, DE             ;; 02E9:  FD DC
 BOOL HL                ;; 02E9:  CC
 BOOL IX                ;; 02E9:  DD CC
 BOOL IY                ;; 02E9:  FD CC
 MLT BC                 ;; 02F9:  ED 4C
 MLT DE                 ;; 02F9:  ED 5C
 MLT HL                 ;; 02F9:  ED 6C
 MLT SP                 ;; 02F9:  ED 7C
 JP LZ, 0               ;; 0869:  E2 00 00
 JP LZ, 4660            ;; 0869:  E2 34 12
 JP LZ, 52719           ;; 0869:  E2 EF CD
 JP LZ, 65535           ;; 0869:  E2 FF FF
 JP LO, 0               ;; 0869:  EA 00 00
 JP LO, 4660            ;; 0869:  EA 34 12
 JP LO, 52719           ;; 0869:  EA EF CD
 JP LO, 65535           ;; 0869:  EA FF FF
 RET LZ                 ;; 08EF:  E0
 RET LO                 ;; 08EF:  E8
 IN0 B, (0)             ;; 0933:  ED 00 00
 IN0 B, (85)            ;; 0933:  ED 00 55
 IN0 B, (170)           ;; 0933:  ED 00 AA
 IN0 B, (255)           ;; 0933:  ED 00 FF
 IN0 C, (0)             ;; 0933:  ED 08 00
 IN0 C, (85)            ;; 0933:  ED 08 55
 IN0 C, (170)           ;; 0933:  ED 08 AA
 IN0 C, (255)           ;; 0933:  ED 08 FF
 IN0 D, (0)             ;; 0933:  ED 10 00
 IN0 D, (85)            ;; 0933:  ED 10 55
 IN0 D, (170)           ;; 0933:  ED 10 AA
 IN0 D, (255)           ;; 0933:  ED 10 FF
 IN0 E, (0)             ;; 0933:  ED 18 00
 IN0 E, (85)            ;; 0933:  ED 18 55
 IN0 E, (170)           ;; 0933:  ED 18 AA
 IN0 E, (255)           ;; 0933:  ED 18 FF
 IN0 H, (0)             ;; 0933:  ED 20 00
 IN0 H, (85)            ;; 0933:  ED 20 55
 IN0 H, (170)           ;; 0933:  ED 20 AA
 IN0 H, (255)           ;; 0933:  ED 20 FF
 IN0 L, (0)             ;; 0933:  ED 28 00
 IN0 L, (85)            ;; 0933:  ED 28 55
 IN0 L, (170)           ;; 0933:  ED 28 AA
 IN0 L, (255)           ;; 0933:  ED 28 FF
 IN0 A, (0)             ;; 0933:  ED 38 00
 IN0 A, (85)            ;; 0933:  ED 38 55
 IN0 A, (170)           ;; 0933:  ED 38 AA
 IN0 A, (255)           ;; 0933:  ED 38 FF
 OUT0 (0), B            ;; 0933:  ED 01 00
 OUT0 (85), B           ;; 0933:  ED 01 55
 OUT0 (170), B          ;; 0933:  ED 01 AA
 OUT0 (255), B          ;; 0933:  ED 01 FF
 OUT0 (0), C            ;; 0933:  ED 09 00
 OUT0 (85), C           ;; 0933:  ED 09 55
 OUT0 (170), C          ;; 0933:  ED 09 AA
 OUT0 (255), C          ;; 0933:  ED 09 FF
 OUT0 (0), D            ;; 0933:  ED 11 00
 OUT0 (85), D           ;; 0933:  ED 11 55
 OUT0 (170), D          ;; 0933:  ED 11 AA
 OUT0 (255), D          ;; 0933:  ED 11 FF
 OUT0 (0), E            ;; 0933:  ED 19 00
 OUT0 (85), E           ;; 0933:  ED 19 55
 OUT0 (170), E          ;; 0933:  ED 19 AA
 OUT0 (255), E          ;; 0933:  ED 19 FF
 OUT0 (0), H            ;; 0933:  ED 21 00
 OUT0 (85), H           ;; 0933:  ED 21 55
 OUT0 (170), H          ;; 0933:  ED 21 AA
 OUT0 (255), H          ;; 0933:  ED 21 FF
 OUT0 (0), L            ;; 0933:  ED 29 00
 OUT0 (85), L           ;; 0933:  ED 29 55
 OUT0 (170), L          ;; 0933:  ED 29 AA
 OUT0 (255), L          ;; 0933:  ED 29 FF
 OUT0 (0), A            ;; 0933:  ED 39 00
 OUT0 (85), A           ;; 0933:  ED 39 55
 OUT0 (170), A          ;; 0933:  ED 39 AA
 OUT0 (255), A          ;; 0933:  ED 39 FF
 OTDM                   ;; 0933:  ED 8B
 OTDMR                  ;; 0933:  ED 9B
 OTIM                   ;; 0933:  ED 83
 OTIMR                  ;; 0933:  ED 93
 TSTIO 0                ;; 0933:  ED 74 00
 TSTIO 85               ;; 0933:  ED 74 55
 TSTIO 170              ;; 0933:  ED 74 AA
 TSTIO 255              ;; 0933:  ED 74 FF
 IOE                    ;; 0933:  DB
 IOI                    ;; 0933:  D3
 IPSET 0                ;; 093B:  ED 46
 IPSET 1                ;; 093B:  ED 56
 IPSET 2                ;; 093B:  ED 4E
 IPSET 3                ;; 093B:  ED 5E
 IPRES                  ;; 093B:  ED 5D
 LD IIR, A              ;; 0943:  ED 47
 LD A, IIR              ;; 0943:  ED 57
 LD EIR, A              ;; 0943:  ED 4F
 LD A, EIR              ;; 0943:  ED 5F
 IDET                   ;; 0947:  5B
 ld bc', bc             ;; 0BB2:  ED 49
 ld bc', de             ;; 0BB2:  ED 41
 ld de', bc             ;; 0BB2:  ED 59
 ld de', de             ;; 0BB2:  ED 51
 ld hl', bc             ;; 0BB2:  ED 69
 ld hl', de             ;; 0BB2:  ED 61
