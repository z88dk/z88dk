 LD IIR, A              ;; 0267:  ED 47
 LD A, IIR              ;; 0267:  ED 57
 LD EIR, A              ;; 0267:  ED 4F
 LD A, EIR              ;; 0267:  ED 5F
 MLT BC                 ;; 0BA6:  ED 4C
 MLT DE                 ;; 0BA6:  ED 5C
 MLT HL                 ;; 0BA6:  ED 6C
 MLT SP                 ;; 0BA6:  ED 7C
 TST B                  ;; 0BA6:  ED 04
 TST C                  ;; 0BA6:  ED 0C
 TST D                  ;; 0BA6:  ED 14
 TST E                  ;; 0BA6:  ED 1C
 TST H                  ;; 0BA6:  ED 24
 TST L                  ;; 0BA6:  ED 2C
 TST A                  ;; 0BA6:  ED 3C
 TST 0                  ;; 0BA6:  ED 64 00
 TST 85                 ;; 0BA6:  ED 64 55
 TST 170                ;; 0BA6:  ED 64 AA
 TST 255                ;; 0BA6:  ED 64 FF
 TST (HL)               ;; 0BA6:  ED 34
 IN0 B, (0)             ;; 0BA6:  ED 00 00
 IN0 B, (85)            ;; 0BA6:  ED 00 55
 IN0 B, (170)           ;; 0BA6:  ED 00 AA
 IN0 B, (255)           ;; 0BA6:  ED 00 FF
 IN0 C, (0)             ;; 0BA6:  ED 08 00
 IN0 C, (85)            ;; 0BA6:  ED 08 55
 IN0 C, (170)           ;; 0BA6:  ED 08 AA
 IN0 C, (255)           ;; 0BA6:  ED 08 FF
 IN0 D, (0)             ;; 0BA6:  ED 10 00
 IN0 D, (85)            ;; 0BA6:  ED 10 55
 IN0 D, (170)           ;; 0BA6:  ED 10 AA
 IN0 D, (255)           ;; 0BA6:  ED 10 FF
 IN0 E, (0)             ;; 0BA6:  ED 18 00
 IN0 E, (85)            ;; 0BA6:  ED 18 55
 IN0 E, (170)           ;; 0BA6:  ED 18 AA
 IN0 E, (255)           ;; 0BA6:  ED 18 FF
 IN0 H, (0)             ;; 0BA6:  ED 20 00
 IN0 H, (85)            ;; 0BA6:  ED 20 55
 IN0 H, (170)           ;; 0BA6:  ED 20 AA
 IN0 H, (255)           ;; 0BA6:  ED 20 FF
 IN0 L, (0)             ;; 0BA6:  ED 28 00
 IN0 L, (85)            ;; 0BA6:  ED 28 55
 IN0 L, (170)           ;; 0BA6:  ED 28 AA
 IN0 L, (255)           ;; 0BA6:  ED 28 FF
 IN0 A, (0)             ;; 0BA6:  ED 38 00
 IN0 A, (85)            ;; 0BA6:  ED 38 55
 IN0 A, (170)           ;; 0BA6:  ED 38 AA
 IN0 A, (255)           ;; 0BA6:  ED 38 FF
 OUT0 (0), B            ;; 0BA6:  ED 01 00
 OUT0 (85), B           ;; 0BA6:  ED 01 55
 OUT0 (170), B          ;; 0BA6:  ED 01 AA
 OUT0 (255), B          ;; 0BA6:  ED 01 FF
 OUT0 (0), C            ;; 0BA6:  ED 09 00
 OUT0 (85), C           ;; 0BA6:  ED 09 55
 OUT0 (170), C          ;; 0BA6:  ED 09 AA
 OUT0 (255), C          ;; 0BA6:  ED 09 FF
 OUT0 (0), D            ;; 0BA6:  ED 11 00
 OUT0 (85), D           ;; 0BA6:  ED 11 55
 OUT0 (170), D          ;; 0BA6:  ED 11 AA
 OUT0 (255), D          ;; 0BA6:  ED 11 FF
 OUT0 (0), E            ;; 0BA6:  ED 19 00
 OUT0 (85), E           ;; 0BA6:  ED 19 55
 OUT0 (170), E          ;; 0BA6:  ED 19 AA
 OUT0 (255), E          ;; 0BA6:  ED 19 FF
 OUT0 (0), H            ;; 0BA6:  ED 21 00
 OUT0 (85), H           ;; 0BA6:  ED 21 55
 OUT0 (170), H          ;; 0BA6:  ED 21 AA
 OUT0 (255), H          ;; 0BA6:  ED 21 FF
 OUT0 (0), L            ;; 0BA6:  ED 29 00
 OUT0 (85), L           ;; 0BA6:  ED 29 55
 OUT0 (170), L          ;; 0BA6:  ED 29 AA
 OUT0 (255), L          ;; 0BA6:  ED 29 FF
 OUT0 (0), A            ;; 0BA6:  ED 39 00
 OUT0 (85), A           ;; 0BA6:  ED 39 55
 OUT0 (170), A          ;; 0BA6:  ED 39 AA
 OUT0 (255), A          ;; 0BA6:  ED 39 FF
 OTDM                   ;; 0BA6:  ED 8B
 OTDMR                  ;; 0BA6:  ED 9B
 OTIM                   ;; 0BA6:  ED 83
 OTIMR                  ;; 0BA6:  ED 93
 TSTIO 0                ;; 0BA6:  ED 74 00
 TSTIO 85               ;; 0BA6:  ED 74 55
 TSTIO 170              ;; 0BA6:  ED 74 AA
 TSTIO 255              ;; 0BA6:  ED 74 FF
 SLP                    ;; 0BA6:  ED 76
