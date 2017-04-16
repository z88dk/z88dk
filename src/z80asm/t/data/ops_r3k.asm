 LD B, B                ;; 0000:  40
 LD B, C                ;; 0001:  41
 LD B, D                ;; 0002:  42
 LD B, E                ;; 0003:  43
 LD B, H                ;; 0004:  44
 LD B, L                ;; 0005:  45
 LD B, A                ;; 0006:  47
 LD C, B                ;; 0007:  48
 LD C, C                ;; 0008:  49
 LD C, D                ;; 0009:  4A
 LD C, E                ;; 000A:  4B
 LD C, H                ;; 000B:  4C
 LD C, L                ;; 000C:  4D
 LD C, A                ;; 000D:  4F
 LD D, B                ;; 000E:  50
 LD D, C                ;; 000F:  51
 LD D, D                ;; 0010:  52
 LD D, E                ;; 0011:  53
 LD D, H                ;; 0012:  54
 LD D, L                ;; 0013:  55
 LD D, A                ;; 0014:  57
 LD E, B                ;; 0015:  58
 LD E, C                ;; 0016:  59
 LD E, D                ;; 0017:  5A
 LD E, E                ;; 0018:  5B
 LD E, H                ;; 0019:  5C
 LD E, L                ;; 001A:  5D
 LD E, A                ;; 001B:  5F
 LD H, B                ;; 001C:  60
 LD H, C                ;; 001D:  61
 LD H, D                ;; 001E:  62
 LD H, E                ;; 001F:  63
 LD H, H                ;; 0020:  64
 LD H, L                ;; 0021:  65
 LD H, A                ;; 0022:  67
 LD L, B                ;; 0023:  68
 LD L, C                ;; 0024:  69
 LD L, D                ;; 0025:  6A
 LD L, E                ;; 0026:  6B
 LD L, H                ;; 0027:  6C
 LD L, L                ;; 0028:  6D
 LD L, A                ;; 0029:  6F
 LD A, B                ;; 002A:  78
 LD A, C                ;; 002B:  79
 LD A, D                ;; 002C:  7A
 LD A, E                ;; 002D:  7B
 LD A, H                ;; 002E:  7C
 LD A, L                ;; 002F:  7D
 LD A, A                ;; 0030:  7F
 LD B, 0                ;; 0031:  06 00
 LD B, 85               ;; 0033:  06 55
 LD B, 170              ;; 0035:  06 AA
 LD B, 255              ;; 0037:  06 FF
 LD C, 0                ;; 0039:  0E 00
 LD C, 85               ;; 003B:  0E 55
 LD C, 170              ;; 003D:  0E AA
 LD C, 255              ;; 003F:  0E FF
 LD D, 0                ;; 0041:  16 00
 LD D, 85               ;; 0043:  16 55
 LD D, 170              ;; 0045:  16 AA
 LD D, 255              ;; 0047:  16 FF
 LD E, 0                ;; 0049:  1E 00
 LD E, 85               ;; 004B:  1E 55
 LD E, 170              ;; 004D:  1E AA
 LD E, 255              ;; 004F:  1E FF
 LD H, 0                ;; 0051:  26 00
 LD H, 85               ;; 0053:  26 55
 LD H, 170              ;; 0055:  26 AA
 LD H, 255              ;; 0057:  26 FF
 LD L, 0                ;; 0059:  2E 00
 LD L, 85               ;; 005B:  2E 55
 LD L, 170              ;; 005D:  2E AA
 LD L, 255              ;; 005F:  2E FF
 LD A, 0                ;; 0061:  3E 00
 LD A, 85               ;; 0063:  3E 55
 LD A, 170              ;; 0065:  3E AA
 LD A, 255              ;; 0067:  3E FF
 LD B, (HL)             ;; 0069:  46
 LD C, (HL)             ;; 006A:  4E
 LD D, (HL)             ;; 006B:  56
 LD E, (HL)             ;; 006C:  5E
 LD H, (HL)             ;; 006D:  66
 LD L, (HL)             ;; 006E:  6E
 LD A, (HL)             ;; 006F:  7E
 LD B, (IX + -128)      ;; 0070:  DD 46 80
 LD B, (IX + 0)         ;; 0073:  DD 46 00
 LD B, (IX + 127)       ;; 0076:  DD 46 7F
 LD B, (IY + -128)      ;; 0079:  FD 46 80
 LD B, (IY + 0)         ;; 007C:  FD 46 00
 LD B, (IY + 127)       ;; 007F:  FD 46 7F
 LD C, (IX + -128)      ;; 0082:  DD 4E 80
 LD C, (IX + 0)         ;; 0085:  DD 4E 00
 LD C, (IX + 127)       ;; 0088:  DD 4E 7F
 LD C, (IY + -128)      ;; 008B:  FD 4E 80
 LD C, (IY + 0)         ;; 008E:  FD 4E 00
 LD C, (IY + 127)       ;; 0091:  FD 4E 7F
 LD D, (IX + -128)      ;; 0094:  DD 56 80
 LD D, (IX + 0)         ;; 0097:  DD 56 00
 LD D, (IX + 127)       ;; 009A:  DD 56 7F
 LD D, (IY + -128)      ;; 009D:  FD 56 80
 LD D, (IY + 0)         ;; 00A0:  FD 56 00
 LD D, (IY + 127)       ;; 00A3:  FD 56 7F
 LD E, (IX + -128)      ;; 00A6:  DD 5E 80
 LD E, (IX + 0)         ;; 00A9:  DD 5E 00
 LD E, (IX + 127)       ;; 00AC:  DD 5E 7F
 LD E, (IY + -128)      ;; 00AF:  FD 5E 80
 LD E, (IY + 0)         ;; 00B2:  FD 5E 00
 LD E, (IY + 127)       ;; 00B5:  FD 5E 7F
 LD H, (IX + -128)      ;; 00B8:  DD 66 80
 LD H, (IX + 0)         ;; 00BB:  DD 66 00
 LD H, (IX + 127)       ;; 00BE:  DD 66 7F
 LD H, (IY + -128)      ;; 00C1:  FD 66 80
 LD H, (IY + 0)         ;; 00C4:  FD 66 00
 LD H, (IY + 127)       ;; 00C7:  FD 66 7F
 LD L, (IX + -128)      ;; 00CA:  DD 6E 80
 LD L, (IX + 0)         ;; 00CD:  DD 6E 00
 LD L, (IX + 127)       ;; 00D0:  DD 6E 7F
 LD L, (IY + -128)      ;; 00D3:  FD 6E 80
 LD L, (IY + 0)         ;; 00D6:  FD 6E 00
 LD L, (IY + 127)       ;; 00D9:  FD 6E 7F
 LD A, (IX + -128)      ;; 00DC:  DD 7E 80
 LD A, (IX + 0)         ;; 00DF:  DD 7E 00
 LD A, (IX + 127)       ;; 00E2:  DD 7E 7F
 LD A, (IY + -128)      ;; 00E5:  FD 7E 80
 LD A, (IY + 0)         ;; 00E8:  FD 7E 00
 LD A, (IY + 127)       ;; 00EB:  FD 7E 7F
 LD (HL), B             ;; 00EE:  70
 LD (HL), C             ;; 00EF:  71
 LD (HL), D             ;; 00F0:  72
 LD (HL), E             ;; 00F1:  73
 LD (HL), H             ;; 00F2:  74
 LD (HL), L             ;; 00F3:  75
 LD (HL), A             ;; 00F4:  77
 LD (IX + -128), B      ;; 00F5:  DD 70 80
 LD (IX + 0), B         ;; 00F8:  DD 70 00
 LD (IX + 127), B       ;; 00FB:  DD 70 7F
 LD (IY + -128), B      ;; 00FE:  FD 70 80
 LD (IY + 0), B         ;; 0101:  FD 70 00
 LD (IY + 127), B       ;; 0104:  FD 70 7F
 LD (IX + -128), C      ;; 0107:  DD 71 80
 LD (IX + 0), C         ;; 010A:  DD 71 00
 LD (IX + 127), C       ;; 010D:  DD 71 7F
 LD (IY + -128), C      ;; 0110:  FD 71 80
 LD (IY + 0), C         ;; 0113:  FD 71 00
 LD (IY + 127), C       ;; 0116:  FD 71 7F
 LD (IX + -128), D      ;; 0119:  DD 72 80
 LD (IX + 0), D         ;; 011C:  DD 72 00
 LD (IX + 127), D       ;; 011F:  DD 72 7F
 LD (IY + -128), D      ;; 0122:  FD 72 80
 LD (IY + 0), D         ;; 0125:  FD 72 00
 LD (IY + 127), D       ;; 0128:  FD 72 7F
 LD (IX + -128), E      ;; 012B:  DD 73 80
 LD (IX + 0), E         ;; 012E:  DD 73 00
 LD (IX + 127), E       ;; 0131:  DD 73 7F
 LD (IY + -128), E      ;; 0134:  FD 73 80
 LD (IY + 0), E         ;; 0137:  FD 73 00
 LD (IY + 127), E       ;; 013A:  FD 73 7F
 LD (IX + -128), H      ;; 013D:  DD 74 80
 LD (IX + 0), H         ;; 0140:  DD 74 00
 LD (IX + 127), H       ;; 0143:  DD 74 7F
 LD (IY + -128), H      ;; 0146:  FD 74 80
 LD (IY + 0), H         ;; 0149:  FD 74 00
 LD (IY + 127), H       ;; 014C:  FD 74 7F
 LD (IX + -128), L      ;; 014F:  DD 75 80
 LD (IX + 0), L         ;; 0152:  DD 75 00
 LD (IX + 127), L       ;; 0155:  DD 75 7F
 LD (IY + -128), L      ;; 0158:  FD 75 80
 LD (IY + 0), L         ;; 015B:  FD 75 00
 LD (IY + 127), L       ;; 015E:  FD 75 7F
 LD (IX + -128), A      ;; 0161:  DD 77 80
 LD (IX + 0), A         ;; 0164:  DD 77 00
 LD (IX + 127), A       ;; 0167:  DD 77 7F
 LD (IY + -128), A      ;; 016A:  FD 77 80
 LD (IY + 0), A         ;; 016D:  FD 77 00
 LD (IY + 127), A       ;; 0170:  FD 77 7F
 LD (HL), 0             ;; 0173:  36 00
 LD (HL), 85            ;; 0175:  36 55
 LD (HL), 170           ;; 0177:  36 AA
 LD (HL), 255           ;; 0179:  36 FF
 LD (IX + -128), 0      ;; 017B:  DD 36 80 00
 LD (IX + 0), 0         ;; 017F:  DD 36 00 00
 LD (IX + 127), 0       ;; 0183:  DD 36 7F 00
 LD (IX + -128), 85     ;; 0187:  DD 36 80 55
 LD (IX + 0), 85        ;; 018B:  DD 36 00 55
 LD (IX + 127), 85      ;; 018F:  DD 36 7F 55
 LD (IX + -128), 170    ;; 0193:  DD 36 80 AA
 LD (IX + 0), 170       ;; 0197:  DD 36 00 AA
 LD (IX + 127), 170     ;; 019B:  DD 36 7F AA
 LD (IX + -128), 255    ;; 019F:  DD 36 80 FF
 LD (IX + 0), 255       ;; 01A3:  DD 36 00 FF
 LD (IX + 127), 255     ;; 01A7:  DD 36 7F FF
 LD (IY + -128), 0      ;; 01AB:  FD 36 80 00
 LD (IY + 0), 0         ;; 01AF:  FD 36 00 00
 LD (IY + 127), 0       ;; 01B3:  FD 36 7F 00
 LD (IY + -128), 85     ;; 01B7:  FD 36 80 55
 LD (IY + 0), 85        ;; 01BB:  FD 36 00 55
 LD (IY + 127), 85      ;; 01BF:  FD 36 7F 55
 LD (IY + -128), 170    ;; 01C3:  FD 36 80 AA
 LD (IY + 0), 170       ;; 01C7:  FD 36 00 AA
 LD (IY + 127), 170     ;; 01CB:  FD 36 7F AA
 LD (IY + -128), 255    ;; 01CF:  FD 36 80 FF
 LD (IY + 0), 255       ;; 01D3:  FD 36 00 FF
 LD (IY + 127), 255     ;; 01D7:  FD 36 7F FF
 LD A, (BC)             ;; 01DB:  0A
 LD A, (DE)             ;; 01DC:  1A
 LD A, (0)              ;; 01DD:  3A 00 00
 LD A, (4660)           ;; 01E0:  3A 34 12
 LD A, (52719)          ;; 01E3:  3A EF CD
 LD A, (65535)          ;; 01E6:  3A FF FF
 LD (BC), A             ;; 01E9:  02
 LD (DE), A             ;; 01EA:  12
 LD (0), A              ;; 01EB:  32 00 00
 LD (4660), A           ;; 01EE:  32 34 12
 LD (52719), A          ;; 01F1:  32 EF CD
 LD (65535), A          ;; 01F4:  32 FF FF
 LD IIR, A              ;; 01F7:  ED 47
 LD A, IIR              ;; 01F9:  ED 57
 LD EIR, A              ;; 01FB:  ED 4F
 LD A, EIR              ;; 01FD:  ED 5F
 LD BC, 0               ;; 01FF:  01 00 00
 LD BC, 4660            ;; 0202:  01 34 12
 LD BC, 52719           ;; 0205:  01 EF CD
 LD BC, 65535           ;; 0208:  01 FF FF
 LD DE, 0               ;; 020B:  11 00 00
 LD DE, 4660            ;; 020E:  11 34 12
 LD DE, 52719           ;; 0211:  11 EF CD
 LD DE, 65535           ;; 0214:  11 FF FF
 LD HL, 0               ;; 0217:  21 00 00
 LD HL, 4660            ;; 021A:  21 34 12
 LD HL, 52719           ;; 021D:  21 EF CD
 LD HL, 65535           ;; 0220:  21 FF FF
 LD SP, 0               ;; 0223:  31 00 00
 LD SP, 4660            ;; 0226:  31 34 12
 LD SP, 52719           ;; 0229:  31 EF CD
 LD SP, 65535           ;; 022C:  31 FF FF
 LD IX, 0               ;; 022F:  DD 21 00 00
 LD IX, 4660            ;; 0233:  DD 21 34 12
 LD IX, 52719           ;; 0237:  DD 21 EF CD
 LD IX, 65535           ;; 023B:  DD 21 FF FF
 LD IY, 0               ;; 023F:  FD 21 00 00
 LD IY, 4660            ;; 0243:  FD 21 34 12
 LD IY, 52719           ;; 0247:  FD 21 EF CD
 LD IY, 65535           ;; 024B:  FD 21 FF FF
 LD HL, (0)             ;; 024F:  2A 00 00
 LD HL, (4660)          ;; 0252:  2A 34 12
 LD HL, (52719)         ;; 0255:  2A EF CD
 LD HL, (65535)         ;; 0258:  2A FF FF
 LD IX, (0)             ;; 025B:  DD 2A 00 00
 LD IX, (4660)          ;; 025F:  DD 2A 34 12
 LD IX, (52719)         ;; 0263:  DD 2A EF CD
 LD IX, (65535)         ;; 0267:  DD 2A FF FF
 LD IY, (0)             ;; 026B:  FD 2A 00 00
 LD IY, (4660)          ;; 026F:  FD 2A 34 12
 LD IY, (52719)         ;; 0273:  FD 2A EF CD
 LD IY, (65535)         ;; 0277:  FD 2A FF FF
 LD BC, (0)             ;; 027B:  ED 4B 00 00
 LD BC, (4660)          ;; 027F:  ED 4B 34 12
 LD BC, (52719)         ;; 0283:  ED 4B EF CD
 LD BC, (65535)         ;; 0287:  ED 4B FF FF
 LD DE, (0)             ;; 028B:  ED 5B 00 00
 LD DE, (4660)          ;; 028F:  ED 5B 34 12
 LD DE, (52719)         ;; 0293:  ED 5B EF CD
 LD DE, (65535)         ;; 0297:  ED 5B FF FF
 LD SP, (0)             ;; 029B:  ED 7B 00 00
 LD SP, (4660)          ;; 029F:  ED 7B 34 12
 LD SP, (52719)         ;; 02A3:  ED 7B EF CD
 LD SP, (65535)         ;; 02A7:  ED 7B FF FF
 LD (0), HL             ;; 02AB:  22 00 00
 LD (4660), HL          ;; 02AE:  22 34 12
 LD (52719), HL         ;; 02B1:  22 EF CD
 LD (65535), HL         ;; 02B4:  22 FF FF
 LD (0), IX             ;; 02B7:  DD 22 00 00
 LD (4660), IX          ;; 02BB:  DD 22 34 12
 LD (52719), IX         ;; 02BF:  DD 22 EF CD
 LD (65535), IX         ;; 02C3:  DD 22 FF FF
 LD (0), IY             ;; 02C7:  FD 22 00 00
 LD (4660), IY          ;; 02CB:  FD 22 34 12
 LD (52719), IY         ;; 02CF:  FD 22 EF CD
 LD (65535), IY         ;; 02D3:  FD 22 FF FF
 LD (0), BC             ;; 02D7:  ED 43 00 00
 LD (4660), BC          ;; 02DB:  ED 43 34 12
 LD (52719), BC         ;; 02DF:  ED 43 EF CD
 LD (65535), BC         ;; 02E3:  ED 43 FF FF
 LD (0), DE             ;; 02E7:  ED 53 00 00
 LD (4660), DE          ;; 02EB:  ED 53 34 12
 LD (52719), DE         ;; 02EF:  ED 53 EF CD
 LD (65535), DE         ;; 02F3:  ED 53 FF FF
 LD (0), SP             ;; 02F7:  ED 73 00 00
 LD (4660), SP          ;; 02FB:  ED 73 34 12
 LD (52719), SP         ;; 02FF:  ED 73 EF CD
 LD (65535), SP         ;; 0303:  ED 73 FF FF
 LD SP, HL              ;; 0307:  F9
 LD SP, IX              ;; 0308:  DD F9
 LD SP, IY              ;; 030A:  FD F9
 PUSH BC                ;; 030C:  C5
 PUSH DE                ;; 030D:  D5
 PUSH HL                ;; 030E:  E5
 PUSH AF                ;; 030F:  F5
 PUSH IX                ;; 0310:  DD E5
 PUSH IY                ;; 0312:  FD E5
 POP BC                 ;; 0314:  C1
 POP DE                 ;; 0315:  D1
 POP HL                 ;; 0316:  E1
 POP AF                 ;; 0317:  F1
 POP IX                 ;; 0318:  DD E1
 POP IY                 ;; 031A:  FD E1
 EX DE, HL              ;; 031C:  EB
 EX AF, AF'             ;; 031D:  08
 EXX                    ;; 031E:  D9
 EX (SP), HL            ;; 031F:  ED 54
 EX (SP), IX            ;; 0321:  DD E3
 EX (SP), IY            ;; 0323:  FD E3
 LDI                    ;; 0325:  ED A0
 LDIR                   ;; 0327:  ED B0
 LDD                    ;; 0329:  ED A8
 LDDR                   ;; 032B:  ED B8
 ADD A, B               ;; 032D:  80
 ADC A, B               ;; 032E:  88
 SUB B                  ;; 032F:  90
 SBC A, B               ;; 0330:  98
 AND B                  ;; 0331:  A0
 XOR B                  ;; 0332:  A8
 OR B                   ;; 0333:  B0
 CP B                   ;; 0334:  B8
 ADD A, C               ;; 0335:  81
 ADC A, C               ;; 0336:  89
 SUB C                  ;; 0337:  91
 SBC A, C               ;; 0338:  99
 AND C                  ;; 0339:  A1
 XOR C                  ;; 033A:  A9
 OR C                   ;; 033B:  B1
 CP C                   ;; 033C:  B9
 ADD A, D               ;; 033D:  82
 ADC A, D               ;; 033E:  8A
 SUB D                  ;; 033F:  92
 SBC A, D               ;; 0340:  9A
 AND D                  ;; 0341:  A2
 XOR D                  ;; 0342:  AA
 OR D                   ;; 0343:  B2
 CP D                   ;; 0344:  BA
 ADD A, E               ;; 0345:  83
 ADC A, E               ;; 0346:  8B
 SUB E                  ;; 0347:  93
 SBC A, E               ;; 0348:  9B
 AND E                  ;; 0349:  A3
 XOR E                  ;; 034A:  AB
 OR E                   ;; 034B:  B3
 CP E                   ;; 034C:  BB
 ADD A, H               ;; 034D:  84
 ADC A, H               ;; 034E:  8C
 SUB H                  ;; 034F:  94
 SBC A, H               ;; 0350:  9C
 AND H                  ;; 0351:  A4
 XOR H                  ;; 0352:  AC
 OR H                   ;; 0353:  B4
 CP H                   ;; 0354:  BC
 ADD A, L               ;; 0355:  85
 ADC A, L               ;; 0356:  8D
 SUB L                  ;; 0357:  95
 SBC A, L               ;; 0358:  9D
 AND L                  ;; 0359:  A5
 XOR L                  ;; 035A:  AD
 OR L                   ;; 035B:  B5
 CP L                   ;; 035C:  BD
 ADD A, A               ;; 035D:  87
 ADC A, A               ;; 035E:  8F
 SUB A                  ;; 035F:  97
 SBC A, A               ;; 0360:  9F
 AND A                  ;; 0361:  A7
 XOR A                  ;; 0362:  AF
 OR A                   ;; 0363:  B7
 CP A                   ;; 0364:  BF
 ADD A, 0               ;; 0365:  C6 00
 ADD A, 85              ;; 0367:  C6 55
 ADD A, 170             ;; 0369:  C6 AA
 ADD A, 255             ;; 036B:  C6 FF
 ADC A, 0               ;; 036D:  CE 00
 ADC A, 85              ;; 036F:  CE 55
 ADC A, 170             ;; 0371:  CE AA
 ADC A, 255             ;; 0373:  CE FF
 SUB 0                  ;; 0375:  D6 00
 SUB 85                 ;; 0377:  D6 55
 SUB 170                ;; 0379:  D6 AA
 SUB 255                ;; 037B:  D6 FF
 SBC A, 0               ;; 037D:  DE 00
 SBC A, 85              ;; 037F:  DE 55
 SBC A, 170             ;; 0381:  DE AA
 SBC A, 255             ;; 0383:  DE FF
 AND 0                  ;; 0385:  E6 00
 AND 85                 ;; 0387:  E6 55
 AND 170                ;; 0389:  E6 AA
 AND 255                ;; 038B:  E6 FF
 XOR 0                  ;; 038D:  EE 00
 XOR 85                 ;; 038F:  EE 55
 XOR 170                ;; 0391:  EE AA
 XOR 255                ;; 0393:  EE FF
 OR 0                   ;; 0395:  F6 00
 OR 85                  ;; 0397:  F6 55
 OR 170                 ;; 0399:  F6 AA
 OR 255                 ;; 039B:  F6 FF
 CP 0                   ;; 039D:  FE 00
 CP 85                  ;; 039F:  FE 55
 CP 170                 ;; 03A1:  FE AA
 CP 255                 ;; 03A3:  FE FF
 ADD A, (HL)            ;; 03A5:  86
 ADC A, (HL)            ;; 03A6:  8E
 SUB (HL)               ;; 03A7:  96
 SBC A, (HL)            ;; 03A8:  9E
 AND (HL)               ;; 03A9:  A6
 XOR (HL)               ;; 03AA:  AE
 OR (HL)                ;; 03AB:  B6
 CP (HL)                ;; 03AC:  BE
 ADD A, (IX + -128)     ;; 03AD:  DD 86 80
 ADD A, (IX + 0)        ;; 03B0:  DD 86 00
 ADD A, (IX + 127)      ;; 03B3:  DD 86 7F
 ADC A, (IX + -128)     ;; 03B6:  DD 8E 80
 ADC A, (IX + 0)        ;; 03B9:  DD 8E 00
 ADC A, (IX + 127)      ;; 03BC:  DD 8E 7F
 SUB (IX + -128)        ;; 03BF:  DD 96 80
 SUB (IX + 0)           ;; 03C2:  DD 96 00
 SUB (IX + 127)         ;; 03C5:  DD 96 7F
 SBC A, (IX + -128)     ;; 03C8:  DD 9E 80
 SBC A, (IX + 0)        ;; 03CB:  DD 9E 00
 SBC A, (IX + 127)      ;; 03CE:  DD 9E 7F
 AND (IX + -128)        ;; 03D1:  DD A6 80
 AND (IX + 0)           ;; 03D4:  DD A6 00
 AND (IX + 127)         ;; 03D7:  DD A6 7F
 XOR (IX + -128)        ;; 03DA:  DD AE 80
 XOR (IX + 0)           ;; 03DD:  DD AE 00
 XOR (IX + 127)         ;; 03E0:  DD AE 7F
 OR (IX + -128)         ;; 03E3:  DD B6 80
 OR (IX + 0)            ;; 03E6:  DD B6 00
 OR (IX + 127)          ;; 03E9:  DD B6 7F
 CP (IX + -128)         ;; 03EC:  DD BE 80
 CP (IX + 0)            ;; 03EF:  DD BE 00
 CP (IX + 127)          ;; 03F2:  DD BE 7F
 ADD A, (IY + -128)     ;; 03F5:  FD 86 80
 ADD A, (IY + 0)        ;; 03F8:  FD 86 00
 ADD A, (IY + 127)      ;; 03FB:  FD 86 7F
 ADC A, (IY + -128)     ;; 03FE:  FD 8E 80
 ADC A, (IY + 0)        ;; 0401:  FD 8E 00
 ADC A, (IY + 127)      ;; 0404:  FD 8E 7F
 SUB (IY + -128)        ;; 0407:  FD 96 80
 SUB (IY + 0)           ;; 040A:  FD 96 00
 SUB (IY + 127)         ;; 040D:  FD 96 7F
 SBC A, (IY + -128)     ;; 0410:  FD 9E 80
 SBC A, (IY + 0)        ;; 0413:  FD 9E 00
 SBC A, (IY + 127)      ;; 0416:  FD 9E 7F
 AND (IY + -128)        ;; 0419:  FD A6 80
 AND (IY + 0)           ;; 041C:  FD A6 00
 AND (IY + 127)         ;; 041F:  FD A6 7F
 XOR (IY + -128)        ;; 0422:  FD AE 80
 XOR (IY + 0)           ;; 0425:  FD AE 00
 XOR (IY + 127)         ;; 0428:  FD AE 7F
 OR (IY + -128)         ;; 042B:  FD B6 80
 OR (IY + 0)            ;; 042E:  FD B6 00
 OR (IY + 127)          ;; 0431:  FD B6 7F
 CP (IY + -128)         ;; 0434:  FD BE 80
 CP (IY + 0)            ;; 0437:  FD BE 00
 CP (IY + 127)          ;; 043A:  FD BE 7F
 INC B                  ;; 043D:  04
 INC C                  ;; 043E:  0C
 INC D                  ;; 043F:  14
 INC E                  ;; 0440:  1C
 INC H                  ;; 0441:  24
 INC L                  ;; 0442:  2C
 INC A                  ;; 0443:  3C
 INC (HL)               ;; 0444:  34
 INC (IX + -128)        ;; 0445:  DD 34 80
 INC (IX + 0)           ;; 0448:  DD 34 00
 INC (IX + 127)         ;; 044B:  DD 34 7F
 INC (IY + -128)        ;; 044E:  FD 34 80
 INC (IY + 0)           ;; 0451:  FD 34 00
 INC (IY + 127)         ;; 0454:  FD 34 7F
 DEC B                  ;; 0457:  05
 DEC C                  ;; 0458:  0D
 DEC D                  ;; 0459:  15
 DEC E                  ;; 045A:  1D
 DEC H                  ;; 045B:  25
 DEC L                  ;; 045C:  2D
 DEC A                  ;; 045D:  3D
 DEC (HL)               ;; 045E:  35
 DEC (IX + -128)        ;; 045F:  DD 35 80
 DEC (IX + 0)           ;; 0462:  DD 35 00
 DEC (IX + 127)         ;; 0465:  DD 35 7F
 DEC (IY + -128)        ;; 0468:  FD 35 80
 DEC (IY + 0)           ;; 046B:  FD 35 00
 DEC (IY + 127)         ;; 046E:  FD 35 7F
 CPL                    ;; 0471:  2F
 NEG                    ;; 0472:  ED 44
 CCF                    ;; 0474:  3F
 SCF                    ;; 0475:  37
 NOP                    ;; 0476:  00
 ADD HL, BC             ;; 0477:  09
 ADD HL, DE             ;; 0478:  19
 ADD HL, HL             ;; 0479:  29
 ADD HL, SP             ;; 047A:  39
 ADD IX, BC             ;; 047B:  DD 09
 ADD IY, BC             ;; 047D:  FD 09
 ADD IX, DE             ;; 047F:  DD 19
 ADD IY, DE             ;; 0481:  FD 19
 ADD IX, IX             ;; 0483:  DD 29
 ADD IY, IY             ;; 0485:  FD 29
 ADD IX, SP             ;; 0487:  DD 39
 ADD IY, SP             ;; 0489:  FD 39
 ADC HL, BC             ;; 048B:  ED 4A
 ADC HL, DE             ;; 048D:  ED 5A
 ADC HL, HL             ;; 048F:  ED 6A
 ADC HL, SP             ;; 0491:  ED 7A
 SBC HL, BC             ;; 0493:  ED 42
 SBC HL, DE             ;; 0495:  ED 52
 SBC HL, HL             ;; 0497:  ED 62
 SBC HL, SP             ;; 0499:  ED 72
 INC BC                 ;; 049B:  03
 INC DE                 ;; 049C:  13
 INC HL                 ;; 049D:  23
 INC SP                 ;; 049E:  33
 INC IX                 ;; 049F:  DD 23
 INC IY                 ;; 04A1:  FD 23
 DEC BC                 ;; 04A3:  0B
 DEC DE                 ;; 04A4:  1B
 DEC HL                 ;; 04A5:  2B
 DEC SP                 ;; 04A6:  3B
 DEC IX                 ;; 04A7:  DD 2B
 DEC IY                 ;; 04A9:  FD 2B
 RLCA                   ;; 04AB:  07
 RRCA                   ;; 04AC:  0F
 RLA                    ;; 04AD:  17
 RRA                    ;; 04AE:  1F
 RLC B                  ;; 04AF:  CB 00
 RRC B                  ;; 04B1:  CB 08
 RL B                   ;; 04B3:  CB 10
 RR B                   ;; 04B5:  CB 18
 SLA B                  ;; 04B7:  CB 20
 SRA B                  ;; 04B9:  CB 28
 SRL B                  ;; 04BB:  CB 38
 RLC C                  ;; 04BD:  CB 01
 RRC C                  ;; 04BF:  CB 09
 RL C                   ;; 04C1:  CB 11
 RR C                   ;; 04C3:  CB 19
 SLA C                  ;; 04C5:  CB 21
 SRA C                  ;; 04C7:  CB 29
 SRL C                  ;; 04C9:  CB 39
 RLC D                  ;; 04CB:  CB 02
 RRC D                  ;; 04CD:  CB 0A
 RL D                   ;; 04CF:  CB 12
 RR D                   ;; 04D1:  CB 1A
 SLA D                  ;; 04D3:  CB 22
 SRA D                  ;; 04D5:  CB 2A
 SRL D                  ;; 04D7:  CB 3A
 RLC E                  ;; 04D9:  CB 03
 RRC E                  ;; 04DB:  CB 0B
 RL E                   ;; 04DD:  CB 13
 RR E                   ;; 04DF:  CB 1B
 SLA E                  ;; 04E1:  CB 23
 SRA E                  ;; 04E3:  CB 2B
 SRL E                  ;; 04E5:  CB 3B
 RLC H                  ;; 04E7:  CB 04
 RRC H                  ;; 04E9:  CB 0C
 RL H                   ;; 04EB:  CB 14
 RR H                   ;; 04ED:  CB 1C
 SLA H                  ;; 04EF:  CB 24
 SRA H                  ;; 04F1:  CB 2C
 SRL H                  ;; 04F3:  CB 3C
 RLC L                  ;; 04F5:  CB 05
 RRC L                  ;; 04F7:  CB 0D
 RL L                   ;; 04F9:  CB 15
 RR L                   ;; 04FB:  CB 1D
 SLA L                  ;; 04FD:  CB 25
 SRA L                  ;; 04FF:  CB 2D
 SRL L                  ;; 0501:  CB 3D
 RLC A                  ;; 0503:  CB 07
 RRC A                  ;; 0505:  CB 0F
 RL A                   ;; 0507:  CB 17
 RR A                   ;; 0509:  CB 1F
 SLA A                  ;; 050B:  CB 27
 SRA A                  ;; 050D:  CB 2F
 SRL A                  ;; 050F:  CB 3F
 RLC (HL)               ;; 0511:  CB 06
 RRC (HL)               ;; 0513:  CB 0E
 RL (HL)                ;; 0515:  CB 16
 RR (HL)                ;; 0517:  CB 1E
 SLA (HL)               ;; 0519:  CB 26
 SRA (HL)               ;; 051B:  CB 2E
 SRL (HL)               ;; 051D:  CB 3E
 RLC (IX + -128)        ;; 051F:  DD CB 80 06
 RLC (IX + 0)           ;; 0523:  DD CB 00 06
 RLC (IX + 127)         ;; 0527:  DD CB 7F 06
 RRC (IX + -128)        ;; 052B:  DD CB 80 0E
 RRC (IX + 0)           ;; 052F:  DD CB 00 0E
 RRC (IX + 127)         ;; 0533:  DD CB 7F 0E
 RL (IX + -128)         ;; 0537:  DD CB 80 16
 RL (IX + 0)            ;; 053B:  DD CB 00 16
 RL (IX + 127)          ;; 053F:  DD CB 7F 16
 RR (IX + -128)         ;; 0543:  DD CB 80 1E
 RR (IX + 0)            ;; 0547:  DD CB 00 1E
 RR (IX + 127)          ;; 054B:  DD CB 7F 1E
 SLA (IX + -128)        ;; 054F:  DD CB 80 26
 SLA (IX + 0)           ;; 0553:  DD CB 00 26
 SLA (IX + 127)         ;; 0557:  DD CB 7F 26
 SRA (IX + -128)        ;; 055B:  DD CB 80 2E
 SRA (IX + 0)           ;; 055F:  DD CB 00 2E
 SRA (IX + 127)         ;; 0563:  DD CB 7F 2E
 SRL (IX + -128)        ;; 0567:  DD CB 80 3E
 SRL (IX + 0)           ;; 056B:  DD CB 00 3E
 SRL (IX + 127)         ;; 056F:  DD CB 7F 3E
 RLC (IY + -128)        ;; 0573:  FD CB 80 06
 RLC (IY + 0)           ;; 0577:  FD CB 00 06
 RLC (IY + 127)         ;; 057B:  FD CB 7F 06
 RRC (IY + -128)        ;; 057F:  FD CB 80 0E
 RRC (IY + 0)           ;; 0583:  FD CB 00 0E
 RRC (IY + 127)         ;; 0587:  FD CB 7F 0E
 RL (IY + -128)         ;; 058B:  FD CB 80 16
 RL (IY + 0)            ;; 058F:  FD CB 00 16
 RL (IY + 127)          ;; 0593:  FD CB 7F 16
 RR (IY + -128)         ;; 0597:  FD CB 80 1E
 RR (IY + 0)            ;; 059B:  FD CB 00 1E
 RR (IY + 127)          ;; 059F:  FD CB 7F 1E
 SLA (IY + -128)        ;; 05A3:  FD CB 80 26
 SLA (IY + 0)           ;; 05A7:  FD CB 00 26
 SLA (IY + 127)         ;; 05AB:  FD CB 7F 26
 SRA (IY + -128)        ;; 05AF:  FD CB 80 2E
 SRA (IY + 0)           ;; 05B3:  FD CB 00 2E
 SRA (IY + 127)         ;; 05B7:  FD CB 7F 2E
 SRL (IY + -128)        ;; 05BB:  FD CB 80 3E
 SRL (IY + 0)           ;; 05BF:  FD CB 00 3E
 SRL (IY + 127)         ;; 05C3:  FD CB 7F 3E
 BIT 0, B               ;; 05C7:  CB 40
 BIT 1, B               ;; 05C9:  CB 48
 BIT 2, B               ;; 05CB:  CB 50
 BIT 3, B               ;; 05CD:  CB 58
 BIT 4, B               ;; 05CF:  CB 60
 BIT 5, B               ;; 05D1:  CB 68
 BIT 6, B               ;; 05D3:  CB 70
 BIT 7, B               ;; 05D5:  CB 78
 RES 0, B               ;; 05D7:  CB 80
 RES 1, B               ;; 05D9:  CB 88
 RES 2, B               ;; 05DB:  CB 90
 RES 3, B               ;; 05DD:  CB 98
 RES 4, B               ;; 05DF:  CB A0
 RES 5, B               ;; 05E1:  CB A8
 RES 6, B               ;; 05E3:  CB B0
 RES 7, B               ;; 05E5:  CB B8
 SET 0, B               ;; 05E7:  CB C0
 SET 1, B               ;; 05E9:  CB C8
 SET 2, B               ;; 05EB:  CB D0
 SET 3, B               ;; 05ED:  CB D8
 SET 4, B               ;; 05EF:  CB E0
 SET 5, B               ;; 05F1:  CB E8
 SET 6, B               ;; 05F3:  CB F0
 SET 7, B               ;; 05F5:  CB F8
 BIT 0, C               ;; 05F7:  CB 41
 BIT 1, C               ;; 05F9:  CB 49
 BIT 2, C               ;; 05FB:  CB 51
 BIT 3, C               ;; 05FD:  CB 59
 BIT 4, C               ;; 05FF:  CB 61
 BIT 5, C               ;; 0601:  CB 69
 BIT 6, C               ;; 0603:  CB 71
 BIT 7, C               ;; 0605:  CB 79
 RES 0, C               ;; 0607:  CB 81
 RES 1, C               ;; 0609:  CB 89
 RES 2, C               ;; 060B:  CB 91
 RES 3, C               ;; 060D:  CB 99
 RES 4, C               ;; 060F:  CB A1
 RES 5, C               ;; 0611:  CB A9
 RES 6, C               ;; 0613:  CB B1
 RES 7, C               ;; 0615:  CB B9
 SET 0, C               ;; 0617:  CB C1
 SET 1, C               ;; 0619:  CB C9
 SET 2, C               ;; 061B:  CB D1
 SET 3, C               ;; 061D:  CB D9
 SET 4, C               ;; 061F:  CB E1
 SET 5, C               ;; 0621:  CB E9
 SET 6, C               ;; 0623:  CB F1
 SET 7, C               ;; 0625:  CB F9
 BIT 0, D               ;; 0627:  CB 42
 BIT 1, D               ;; 0629:  CB 4A
 BIT 2, D               ;; 062B:  CB 52
 BIT 3, D               ;; 062D:  CB 5A
 BIT 4, D               ;; 062F:  CB 62
 BIT 5, D               ;; 0631:  CB 6A
 BIT 6, D               ;; 0633:  CB 72
 BIT 7, D               ;; 0635:  CB 7A
 RES 0, D               ;; 0637:  CB 82
 RES 1, D               ;; 0639:  CB 8A
 RES 2, D               ;; 063B:  CB 92
 RES 3, D               ;; 063D:  CB 9A
 RES 4, D               ;; 063F:  CB A2
 RES 5, D               ;; 0641:  CB AA
 RES 6, D               ;; 0643:  CB B2
 RES 7, D               ;; 0645:  CB BA
 SET 0, D               ;; 0647:  CB C2
 SET 1, D               ;; 0649:  CB CA
 SET 2, D               ;; 064B:  CB D2
 SET 3, D               ;; 064D:  CB DA
 SET 4, D               ;; 064F:  CB E2
 SET 5, D               ;; 0651:  CB EA
 SET 6, D               ;; 0653:  CB F2
 SET 7, D               ;; 0655:  CB FA
 BIT 0, E               ;; 0657:  CB 43
 BIT 1, E               ;; 0659:  CB 4B
 BIT 2, E               ;; 065B:  CB 53
 BIT 3, E               ;; 065D:  CB 5B
 BIT 4, E               ;; 065F:  CB 63
 BIT 5, E               ;; 0661:  CB 6B
 BIT 6, E               ;; 0663:  CB 73
 BIT 7, E               ;; 0665:  CB 7B
 RES 0, E               ;; 0667:  CB 83
 RES 1, E               ;; 0669:  CB 8B
 RES 2, E               ;; 066B:  CB 93
 RES 3, E               ;; 066D:  CB 9B
 RES 4, E               ;; 066F:  CB A3
 RES 5, E               ;; 0671:  CB AB
 RES 6, E               ;; 0673:  CB B3
 RES 7, E               ;; 0675:  CB BB
 SET 0, E               ;; 0677:  CB C3
 SET 1, E               ;; 0679:  CB CB
 SET 2, E               ;; 067B:  CB D3
 SET 3, E               ;; 067D:  CB DB
 SET 4, E               ;; 067F:  CB E3
 SET 5, E               ;; 0681:  CB EB
 SET 6, E               ;; 0683:  CB F3
 SET 7, E               ;; 0685:  CB FB
 BIT 0, H               ;; 0687:  CB 44
 BIT 1, H               ;; 0689:  CB 4C
 BIT 2, H               ;; 068B:  CB 54
 BIT 3, H               ;; 068D:  CB 5C
 BIT 4, H               ;; 068F:  CB 64
 BIT 5, H               ;; 0691:  CB 6C
 BIT 6, H               ;; 0693:  CB 74
 BIT 7, H               ;; 0695:  CB 7C
 RES 0, H               ;; 0697:  CB 84
 RES 1, H               ;; 0699:  CB 8C
 RES 2, H               ;; 069B:  CB 94
 RES 3, H               ;; 069D:  CB 9C
 RES 4, H               ;; 069F:  CB A4
 RES 5, H               ;; 06A1:  CB AC
 RES 6, H               ;; 06A3:  CB B4
 RES 7, H               ;; 06A5:  CB BC
 SET 0, H               ;; 06A7:  CB C4
 SET 1, H               ;; 06A9:  CB CC
 SET 2, H               ;; 06AB:  CB D4
 SET 3, H               ;; 06AD:  CB DC
 SET 4, H               ;; 06AF:  CB E4
 SET 5, H               ;; 06B1:  CB EC
 SET 6, H               ;; 06B3:  CB F4
 SET 7, H               ;; 06B5:  CB FC
 BIT 0, L               ;; 06B7:  CB 45
 BIT 1, L               ;; 06B9:  CB 4D
 BIT 2, L               ;; 06BB:  CB 55
 BIT 3, L               ;; 06BD:  CB 5D
 BIT 4, L               ;; 06BF:  CB 65
 BIT 5, L               ;; 06C1:  CB 6D
 BIT 6, L               ;; 06C3:  CB 75
 BIT 7, L               ;; 06C5:  CB 7D
 RES 0, L               ;; 06C7:  CB 85
 RES 1, L               ;; 06C9:  CB 8D
 RES 2, L               ;; 06CB:  CB 95
 RES 3, L               ;; 06CD:  CB 9D
 RES 4, L               ;; 06CF:  CB A5
 RES 5, L               ;; 06D1:  CB AD
 RES 6, L               ;; 06D3:  CB B5
 RES 7, L               ;; 06D5:  CB BD
 SET 0, L               ;; 06D7:  CB C5
 SET 1, L               ;; 06D9:  CB CD
 SET 2, L               ;; 06DB:  CB D5
 SET 3, L               ;; 06DD:  CB DD
 SET 4, L               ;; 06DF:  CB E5
 SET 5, L               ;; 06E1:  CB ED
 SET 6, L               ;; 06E3:  CB F5
 SET 7, L               ;; 06E5:  CB FD
 BIT 0, A               ;; 06E7:  CB 47
 BIT 1, A               ;; 06E9:  CB 4F
 BIT 2, A               ;; 06EB:  CB 57
 BIT 3, A               ;; 06ED:  CB 5F
 BIT 4, A               ;; 06EF:  CB 67
 BIT 5, A               ;; 06F1:  CB 6F
 BIT 6, A               ;; 06F3:  CB 77
 BIT 7, A               ;; 06F5:  CB 7F
 RES 0, A               ;; 06F7:  CB 87
 RES 1, A               ;; 06F9:  CB 8F
 RES 2, A               ;; 06FB:  CB 97
 RES 3, A               ;; 06FD:  CB 9F
 RES 4, A               ;; 06FF:  CB A7
 RES 5, A               ;; 0701:  CB AF
 RES 6, A               ;; 0703:  CB B7
 RES 7, A               ;; 0705:  CB BF
 SET 0, A               ;; 0707:  CB C7
 SET 1, A               ;; 0709:  CB CF
 SET 2, A               ;; 070B:  CB D7
 SET 3, A               ;; 070D:  CB DF
 SET 4, A               ;; 070F:  CB E7
 SET 5, A               ;; 0711:  CB EF
 SET 6, A               ;; 0713:  CB F7
 SET 7, A               ;; 0715:  CB FF
 BIT 0, (HL)            ;; 0717:  CB 46
 BIT 1, (HL)            ;; 0719:  CB 4E
 BIT 2, (HL)            ;; 071B:  CB 56
 BIT 3, (HL)            ;; 071D:  CB 5E
 BIT 4, (HL)            ;; 071F:  CB 66
 BIT 5, (HL)            ;; 0721:  CB 6E
 BIT 6, (HL)            ;; 0723:  CB 76
 BIT 7, (HL)            ;; 0725:  CB 7E
 RES 0, (HL)            ;; 0727:  CB 86
 RES 1, (HL)            ;; 0729:  CB 8E
 RES 2, (HL)            ;; 072B:  CB 96
 RES 3, (HL)            ;; 072D:  CB 9E
 RES 4, (HL)            ;; 072F:  CB A6
 RES 5, (HL)            ;; 0731:  CB AE
 RES 6, (HL)            ;; 0733:  CB B6
 RES 7, (HL)            ;; 0735:  CB BE
 SET 0, (HL)            ;; 0737:  CB C6
 SET 1, (HL)            ;; 0739:  CB CE
 SET 2, (HL)            ;; 073B:  CB D6
 SET 3, (HL)            ;; 073D:  CB DE
 SET 4, (HL)            ;; 073F:  CB E6
 SET 5, (HL)            ;; 0741:  CB EE
 SET 6, (HL)            ;; 0743:  CB F6
 SET 7, (HL)            ;; 0745:  CB FE
 BIT 0, (IX + -128)     ;; 0747:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 074B:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 074F:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 0753:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 0757:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 075B:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 075F:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 0763:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 0767:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 076B:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 076F:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 0773:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 0777:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 077B:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 077F:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 0783:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 0787:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 078B:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 078F:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 0793:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 0797:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 079B:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 079F:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 07A3:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 07A7:  DD CB 80 86
 RES 1, (IX + -128)     ;; 07AB:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 07AF:  DD CB 80 96
 RES 3, (IX + -128)     ;; 07B3:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 07B7:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 07BB:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 07BF:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 07C3:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 07C7:  DD CB 00 86
 RES 1, (IX + 0)        ;; 07CB:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 07CF:  DD CB 00 96
 RES 3, (IX + 0)        ;; 07D3:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 07D7:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 07DB:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 07DF:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 07E3:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 07E7:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 07EB:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 07EF:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 07F3:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 07F7:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 07FB:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 07FF:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0803:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0807:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 080B:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 080F:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0813:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0817:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 081B:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 081F:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0823:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0827:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 082B:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 082F:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 0833:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0837:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 083B:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 083F:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 0843:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0847:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 084B:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 084F:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 0853:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 0857:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 085B:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 085F:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 0863:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 0867:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 086B:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 086F:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 0873:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 0877:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 087B:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 087F:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 0883:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 0887:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 088B:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 088F:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 0893:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 0897:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 089B:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 089F:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 08A3:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 08A7:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 08AB:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 08AF:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 08B3:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 08B7:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 08BB:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 08BF:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 08C3:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 08C7:  FD CB 80 86
 RES 1, (IY + -128)     ;; 08CB:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 08CF:  FD CB 80 96
 RES 3, (IY + -128)     ;; 08D3:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 08D7:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 08DB:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 08DF:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 08E3:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 08E7:  FD CB 00 86
 RES 1, (IY + 0)        ;; 08EB:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 08EF:  FD CB 00 96
 RES 3, (IY + 0)        ;; 08F3:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 08F7:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 08FB:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 08FF:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0903:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0907:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 090B:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 090F:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0913:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0917:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 091B:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 091F:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0923:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0927:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 092B:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 092F:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 0933:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0937:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 093B:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 093F:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 0943:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0947:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 094B:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 094F:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 0953:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 0957:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 095B:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 095F:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 0963:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 0967:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 096B:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 096F:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 0973:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 0977:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 097B:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 097F:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 0983:  FD CB 7F FE
 JP 0                   ;; 0987:  C3 00 00
 JP 4660                ;; 098A:  C3 34 12
 JP 52719               ;; 098D:  C3 EF CD
 JP 65535               ;; 0990:  C3 FF FF
 JP NZ, 0               ;; 0993:  C2 00 00
 JP NZ, 4660            ;; 0996:  C2 34 12
 JP NZ, 52719           ;; 0999:  C2 EF CD
 JP NZ, 65535           ;; 099C:  C2 FF FF
 JP Z, 0                ;; 099F:  CA 00 00
 JP Z, 4660             ;; 09A2:  CA 34 12
 JP Z, 52719            ;; 09A5:  CA EF CD
 JP Z, 65535            ;; 09A8:  CA FF FF
 JP NC, 0               ;; 09AB:  D2 00 00
 JP NC, 4660            ;; 09AE:  D2 34 12
 JP NC, 52719           ;; 09B1:  D2 EF CD
 JP NC, 65535           ;; 09B4:  D2 FF FF
 JP C, 0                ;; 09B7:  DA 00 00
 JP C, 4660             ;; 09BA:  DA 34 12
 JP C, 52719            ;; 09BD:  DA EF CD
 JP C, 65535            ;; 09C0:  DA FF FF
 JP PO, 0               ;; 09C3:  E2 00 00
 JP PO, 4660            ;; 09C6:  E2 34 12
 JP PO, 52719           ;; 09C9:  E2 EF CD
 JP PO, 65535           ;; 09CC:  E2 FF FF
 JP PE, 0               ;; 09CF:  EA 00 00
 JP PE, 4660            ;; 09D2:  EA 34 12
 JP PE, 52719           ;; 09D5:  EA EF CD
 JP PE, 65535           ;; 09D8:  EA FF FF
 JP P, 0                ;; 09DB:  F2 00 00
 JP P, 4660             ;; 09DE:  F2 34 12
 JP P, 52719            ;; 09E1:  F2 EF CD
 JP P, 65535            ;; 09E4:  F2 FF FF
 JP M, 0                ;; 09E7:  FA 00 00
 JP M, 4660             ;; 09EA:  FA 34 12
 JP M, 52719            ;; 09ED:  FA EF CD
 JP M, 65535            ;; 09F0:  FA FF FF
 JR ASMPC+2             ;; 09F3:  18 00
 JR NZ, ASMPC+2         ;; 09F5:  20 00
 JR Z, ASMPC+2          ;; 09F7:  28 00
 JR NC, ASMPC+2         ;; 09F9:  30 00
 JR C, ASMPC+2          ;; 09FB:  38 00
 JP (HL)                ;; 09FD:  E9
 JP (IX)                ;; 09FE:  DD E9
 JP (IY)                ;; 0A00:  FD E9
 DJNZ ASMPC+2           ;; 0A02:  10 00
 CALL 0                 ;; 0A04:  CD 00 00
 CALL 4660              ;; 0A07:  CD 34 12
 CALL 52719             ;; 0A0A:  CD EF CD
 CALL 65535             ;; 0A0D:  CD FF FF
 RET                    ;; 0A10:  C9
 RET NZ                 ;; 0A11:  C0
 RET Z                  ;; 0A12:  C8
 RET NC                 ;; 0A13:  D0
 RET C                  ;; 0A14:  D8
 RET PO                 ;; 0A15:  E0
 RET PE                 ;; 0A16:  E8
 RET P                  ;; 0A17:  F0
 RET M                  ;; 0A18:  F8
 RETI                   ;; 0A19:  ED 4D
 RST 16                 ;; 0A1B:  D7
 RST 24                 ;; 0A1C:  DF
 RST 32                 ;; 0A1D:  E7
 RST 40                 ;; 0A1E:  EF
 RST 56                 ;; 0A1F:  FF
 MLT BC                 ;; 0A20:  ED 4C
 MLT DE                 ;; 0A22:  ED 5C
 MLT HL                 ;; 0A24:  ED 6C
 TST B                  ;; 0A26:  ED 04
 TST C                  ;; 0A28:  ED 0C
 TST D                  ;; 0A2A:  ED 14
 TST E                  ;; 0A2C:  ED 1C
 TST H                  ;; 0A2E:  ED 24
 TST L                  ;; 0A30:  ED 2C
 TST A                  ;; 0A32:  ED 3C
 TST 0                  ;; 0A34:  ED 64 00
 TST 85                 ;; 0A37:  ED 64 55
 TST 170                ;; 0A3A:  ED 64 AA
 TST 255                ;; 0A3D:  ED 64 FF
 TST (HL)               ;; 0A40:  ED 34
