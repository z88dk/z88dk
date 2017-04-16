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
 LD I, A                ;; 01F7:  ED 47
 LD A, I                ;; 01F9:  ED 57
 LD R, A                ;; 01FB:  ED 4F
 LD A, R                ;; 01FD:  ED 5F
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
 EX (SP), HL            ;; 031F:  E3
 EX (SP), IX            ;; 0320:  DD E3
 EX (SP), IY            ;; 0322:  FD E3
 LDI                    ;; 0324:  ED A0
 LDIR                   ;; 0326:  ED B0
 LDD                    ;; 0328:  ED A8
 LDDR                   ;; 032A:  ED B8
 CPI                    ;; 032C:  ED A1
 CPIR                   ;; 032E:  ED B1
 CPD                    ;; 0330:  ED A9
 CPDR                   ;; 0332:  ED B9
 ADD A, B               ;; 0334:  80
 ADC A, B               ;; 0335:  88
 SUB B                  ;; 0336:  90
 SBC A, B               ;; 0337:  98
 AND B                  ;; 0338:  A0
 XOR B                  ;; 0339:  A8
 OR B                   ;; 033A:  B0
 CP B                   ;; 033B:  B8
 ADD A, C               ;; 033C:  81
 ADC A, C               ;; 033D:  89
 SUB C                  ;; 033E:  91
 SBC A, C               ;; 033F:  99
 AND C                  ;; 0340:  A1
 XOR C                  ;; 0341:  A9
 OR C                   ;; 0342:  B1
 CP C                   ;; 0343:  B9
 ADD A, D               ;; 0344:  82
 ADC A, D               ;; 0345:  8A
 SUB D                  ;; 0346:  92
 SBC A, D               ;; 0347:  9A
 AND D                  ;; 0348:  A2
 XOR D                  ;; 0349:  AA
 OR D                   ;; 034A:  B2
 CP D                   ;; 034B:  BA
 ADD A, E               ;; 034C:  83
 ADC A, E               ;; 034D:  8B
 SUB E                  ;; 034E:  93
 SBC A, E               ;; 034F:  9B
 AND E                  ;; 0350:  A3
 XOR E                  ;; 0351:  AB
 OR E                   ;; 0352:  B3
 CP E                   ;; 0353:  BB
 ADD A, H               ;; 0354:  84
 ADC A, H               ;; 0355:  8C
 SUB H                  ;; 0356:  94
 SBC A, H               ;; 0357:  9C
 AND H                  ;; 0358:  A4
 XOR H                  ;; 0359:  AC
 OR H                   ;; 035A:  B4
 CP H                   ;; 035B:  BC
 ADD A, L               ;; 035C:  85
 ADC A, L               ;; 035D:  8D
 SUB L                  ;; 035E:  95
 SBC A, L               ;; 035F:  9D
 AND L                  ;; 0360:  A5
 XOR L                  ;; 0361:  AD
 OR L                   ;; 0362:  B5
 CP L                   ;; 0363:  BD
 ADD A, A               ;; 0364:  87
 ADC A, A               ;; 0365:  8F
 SUB A                  ;; 0366:  97
 SBC A, A               ;; 0367:  9F
 AND A                  ;; 0368:  A7
 XOR A                  ;; 0369:  AF
 OR A                   ;; 036A:  B7
 CP A                   ;; 036B:  BF
 ADD A, 0               ;; 036C:  C6 00
 ADD A, 85              ;; 036E:  C6 55
 ADD A, 170             ;; 0370:  C6 AA
 ADD A, 255             ;; 0372:  C6 FF
 ADC A, 0               ;; 0374:  CE 00
 ADC A, 85              ;; 0376:  CE 55
 ADC A, 170             ;; 0378:  CE AA
 ADC A, 255             ;; 037A:  CE FF
 SUB 0                  ;; 037C:  D6 00
 SUB 85                 ;; 037E:  D6 55
 SUB 170                ;; 0380:  D6 AA
 SUB 255                ;; 0382:  D6 FF
 SBC A, 0               ;; 0384:  DE 00
 SBC A, 85              ;; 0386:  DE 55
 SBC A, 170             ;; 0388:  DE AA
 SBC A, 255             ;; 038A:  DE FF
 AND 0                  ;; 038C:  E6 00
 AND 85                 ;; 038E:  E6 55
 AND 170                ;; 0390:  E6 AA
 AND 255                ;; 0392:  E6 FF
 XOR 0                  ;; 0394:  EE 00
 XOR 85                 ;; 0396:  EE 55
 XOR 170                ;; 0398:  EE AA
 XOR 255                ;; 039A:  EE FF
 OR 0                   ;; 039C:  F6 00
 OR 85                  ;; 039E:  F6 55
 OR 170                 ;; 03A0:  F6 AA
 OR 255                 ;; 03A2:  F6 FF
 CP 0                   ;; 03A4:  FE 00
 CP 85                  ;; 03A6:  FE 55
 CP 170                 ;; 03A8:  FE AA
 CP 255                 ;; 03AA:  FE FF
 ADD A, (HL)            ;; 03AC:  86
 ADC A, (HL)            ;; 03AD:  8E
 SUB (HL)               ;; 03AE:  96
 SBC A, (HL)            ;; 03AF:  9E
 AND (HL)               ;; 03B0:  A6
 XOR (HL)               ;; 03B1:  AE
 OR (HL)                ;; 03B2:  B6
 CP (HL)                ;; 03B3:  BE
 ADD A, (IX + -128)     ;; 03B4:  DD 86 80
 ADD A, (IX + 0)        ;; 03B7:  DD 86 00
 ADD A, (IX + 127)      ;; 03BA:  DD 86 7F
 ADC A, (IX + -128)     ;; 03BD:  DD 8E 80
 ADC A, (IX + 0)        ;; 03C0:  DD 8E 00
 ADC A, (IX + 127)      ;; 03C3:  DD 8E 7F
 SUB (IX + -128)        ;; 03C6:  DD 96 80
 SUB (IX + 0)           ;; 03C9:  DD 96 00
 SUB (IX + 127)         ;; 03CC:  DD 96 7F
 SBC A, (IX + -128)     ;; 03CF:  DD 9E 80
 SBC A, (IX + 0)        ;; 03D2:  DD 9E 00
 SBC A, (IX + 127)      ;; 03D5:  DD 9E 7F
 AND (IX + -128)        ;; 03D8:  DD A6 80
 AND (IX + 0)           ;; 03DB:  DD A6 00
 AND (IX + 127)         ;; 03DE:  DD A6 7F
 XOR (IX + -128)        ;; 03E1:  DD AE 80
 XOR (IX + 0)           ;; 03E4:  DD AE 00
 XOR (IX + 127)         ;; 03E7:  DD AE 7F
 OR (IX + -128)         ;; 03EA:  DD B6 80
 OR (IX + 0)            ;; 03ED:  DD B6 00
 OR (IX + 127)          ;; 03F0:  DD B6 7F
 CP (IX + -128)         ;; 03F3:  DD BE 80
 CP (IX + 0)            ;; 03F6:  DD BE 00
 CP (IX + 127)          ;; 03F9:  DD BE 7F
 ADD A, (IY + -128)     ;; 03FC:  FD 86 80
 ADD A, (IY + 0)        ;; 03FF:  FD 86 00
 ADD A, (IY + 127)      ;; 0402:  FD 86 7F
 ADC A, (IY + -128)     ;; 0405:  FD 8E 80
 ADC A, (IY + 0)        ;; 0408:  FD 8E 00
 ADC A, (IY + 127)      ;; 040B:  FD 8E 7F
 SUB (IY + -128)        ;; 040E:  FD 96 80
 SUB (IY + 0)           ;; 0411:  FD 96 00
 SUB (IY + 127)         ;; 0414:  FD 96 7F
 SBC A, (IY + -128)     ;; 0417:  FD 9E 80
 SBC A, (IY + 0)        ;; 041A:  FD 9E 00
 SBC A, (IY + 127)      ;; 041D:  FD 9E 7F
 AND (IY + -128)        ;; 0420:  FD A6 80
 AND (IY + 0)           ;; 0423:  FD A6 00
 AND (IY + 127)         ;; 0426:  FD A6 7F
 XOR (IY + -128)        ;; 0429:  FD AE 80
 XOR (IY + 0)           ;; 042C:  FD AE 00
 XOR (IY + 127)         ;; 042F:  FD AE 7F
 OR (IY + -128)         ;; 0432:  FD B6 80
 OR (IY + 0)            ;; 0435:  FD B6 00
 OR (IY + 127)          ;; 0438:  FD B6 7F
 CP (IY + -128)         ;; 043B:  FD BE 80
 CP (IY + 0)            ;; 043E:  FD BE 00
 CP (IY + 127)          ;; 0441:  FD BE 7F
 INC B                  ;; 0444:  04
 INC C                  ;; 0445:  0C
 INC D                  ;; 0446:  14
 INC E                  ;; 0447:  1C
 INC H                  ;; 0448:  24
 INC L                  ;; 0449:  2C
 INC A                  ;; 044A:  3C
 INC (HL)               ;; 044B:  34
 INC (IX + -128)        ;; 044C:  DD 34 80
 INC (IX + 0)           ;; 044F:  DD 34 00
 INC (IX + 127)         ;; 0452:  DD 34 7F
 INC (IY + -128)        ;; 0455:  FD 34 80
 INC (IY + 0)           ;; 0458:  FD 34 00
 INC (IY + 127)         ;; 045B:  FD 34 7F
 DEC B                  ;; 045E:  05
 DEC C                  ;; 045F:  0D
 DEC D                  ;; 0460:  15
 DEC E                  ;; 0461:  1D
 DEC H                  ;; 0462:  25
 DEC L                  ;; 0463:  2D
 DEC A                  ;; 0464:  3D
 DEC (HL)               ;; 0465:  35
 DEC (IX + -128)        ;; 0466:  DD 35 80
 DEC (IX + 0)           ;; 0469:  DD 35 00
 DEC (IX + 127)         ;; 046C:  DD 35 7F
 DEC (IY + -128)        ;; 046F:  FD 35 80
 DEC (IY + 0)           ;; 0472:  FD 35 00
 DEC (IY + 127)         ;; 0475:  FD 35 7F
 DAA                    ;; 0478:  27
 CPL                    ;; 0479:  2F
 NEG                    ;; 047A:  ED 44
 CCF                    ;; 047C:  3F
 SCF                    ;; 047D:  37
 NOP                    ;; 047E:  00
 HALT                   ;; 047F:  76
 DI                     ;; 0480:  F3
 EI                     ;; 0481:  FB
 IM 0                   ;; 0482:  ED 46
 IM 1                   ;; 0484:  ED 56
 IM 2                   ;; 0486:  ED 5E
 ADD HL, BC             ;; 0488:  09
 ADD HL, DE             ;; 0489:  19
 ADD HL, HL             ;; 048A:  29
 ADD HL, SP             ;; 048B:  39
 ADD IX, BC             ;; 048C:  DD 09
 ADD IY, BC             ;; 048E:  FD 09
 ADD IX, DE             ;; 0490:  DD 19
 ADD IY, DE             ;; 0492:  FD 19
 ADD IX, IX             ;; 0494:  DD 29
 ADD IY, IY             ;; 0496:  FD 29
 ADD IX, SP             ;; 0498:  DD 39
 ADD IY, SP             ;; 049A:  FD 39
 ADC HL, BC             ;; 049C:  ED 4A
 ADC HL, DE             ;; 049E:  ED 5A
 ADC HL, HL             ;; 04A0:  ED 6A
 ADC HL, SP             ;; 04A2:  ED 7A
 SBC HL, BC             ;; 04A4:  ED 42
 SBC HL, DE             ;; 04A6:  ED 52
 SBC HL, HL             ;; 04A8:  ED 62
 SBC HL, SP             ;; 04AA:  ED 72
 INC BC                 ;; 04AC:  03
 INC DE                 ;; 04AD:  13
 INC HL                 ;; 04AE:  23
 INC SP                 ;; 04AF:  33
 INC IX                 ;; 04B0:  DD 23
 INC IY                 ;; 04B2:  FD 23
 DEC BC                 ;; 04B4:  0B
 DEC DE                 ;; 04B5:  1B
 DEC HL                 ;; 04B6:  2B
 DEC SP                 ;; 04B7:  3B
 DEC IX                 ;; 04B8:  DD 2B
 DEC IY                 ;; 04BA:  FD 2B
 RLCA                   ;; 04BC:  07
 RRCA                   ;; 04BD:  0F
 RLA                    ;; 04BE:  17
 RRA                    ;; 04BF:  1F
 RLC B                  ;; 04C0:  CB 00
 RRC B                  ;; 04C2:  CB 08
 RL B                   ;; 04C4:  CB 10
 RR B                   ;; 04C6:  CB 18
 SLA B                  ;; 04C8:  CB 20
 SRA B                  ;; 04CA:  CB 28
 SLL B                  ;; 04CC:  CB 30
 SRL B                  ;; 04CE:  CB 38
 RLC C                  ;; 04D0:  CB 01
 RRC C                  ;; 04D2:  CB 09
 RL C                   ;; 04D4:  CB 11
 RR C                   ;; 04D6:  CB 19
 SLA C                  ;; 04D8:  CB 21
 SRA C                  ;; 04DA:  CB 29
 SLL C                  ;; 04DC:  CB 31
 SRL C                  ;; 04DE:  CB 39
 RLC D                  ;; 04E0:  CB 02
 RRC D                  ;; 04E2:  CB 0A
 RL D                   ;; 04E4:  CB 12
 RR D                   ;; 04E6:  CB 1A
 SLA D                  ;; 04E8:  CB 22
 SRA D                  ;; 04EA:  CB 2A
 SLL D                  ;; 04EC:  CB 32
 SRL D                  ;; 04EE:  CB 3A
 RLC E                  ;; 04F0:  CB 03
 RRC E                  ;; 04F2:  CB 0B
 RL E                   ;; 04F4:  CB 13
 RR E                   ;; 04F6:  CB 1B
 SLA E                  ;; 04F8:  CB 23
 SRA E                  ;; 04FA:  CB 2B
 SLL E                  ;; 04FC:  CB 33
 SRL E                  ;; 04FE:  CB 3B
 RLC H                  ;; 0500:  CB 04
 RRC H                  ;; 0502:  CB 0C
 RL H                   ;; 0504:  CB 14
 RR H                   ;; 0506:  CB 1C
 SLA H                  ;; 0508:  CB 24
 SRA H                  ;; 050A:  CB 2C
 SLL H                  ;; 050C:  CB 34
 SRL H                  ;; 050E:  CB 3C
 RLC L                  ;; 0510:  CB 05
 RRC L                  ;; 0512:  CB 0D
 RL L                   ;; 0514:  CB 15
 RR L                   ;; 0516:  CB 1D
 SLA L                  ;; 0518:  CB 25
 SRA L                  ;; 051A:  CB 2D
 SLL L                  ;; 051C:  CB 35
 SRL L                  ;; 051E:  CB 3D
 RLC A                  ;; 0520:  CB 07
 RRC A                  ;; 0522:  CB 0F
 RL A                   ;; 0524:  CB 17
 RR A                   ;; 0526:  CB 1F
 SLA A                  ;; 0528:  CB 27
 SRA A                  ;; 052A:  CB 2F
 SLL A                  ;; 052C:  CB 37
 SRL A                  ;; 052E:  CB 3F
 RLC (HL)               ;; 0530:  CB 06
 RRC (HL)               ;; 0532:  CB 0E
 RL (HL)                ;; 0534:  CB 16
 RR (HL)                ;; 0536:  CB 1E
 SLA (HL)               ;; 0538:  CB 26
 SRA (HL)               ;; 053A:  CB 2E
 SLL (HL)               ;; 053C:  CB 36
 SRL (HL)               ;; 053E:  CB 3E
 RLC (IX + -128)        ;; 0540:  DD CB 80 06
 RLC (IX + 0)           ;; 0544:  DD CB 00 06
 RLC (IX + 127)         ;; 0548:  DD CB 7F 06
 RRC (IX + -128)        ;; 054C:  DD CB 80 0E
 RRC (IX + 0)           ;; 0550:  DD CB 00 0E
 RRC (IX + 127)         ;; 0554:  DD CB 7F 0E
 RL (IX + -128)         ;; 0558:  DD CB 80 16
 RL (IX + 0)            ;; 055C:  DD CB 00 16
 RL (IX + 127)          ;; 0560:  DD CB 7F 16
 RR (IX + -128)         ;; 0564:  DD CB 80 1E
 RR (IX + 0)            ;; 0568:  DD CB 00 1E
 RR (IX + 127)          ;; 056C:  DD CB 7F 1E
 SLA (IX + -128)        ;; 0570:  DD CB 80 26
 SLA (IX + 0)           ;; 0574:  DD CB 00 26
 SLA (IX + 127)         ;; 0578:  DD CB 7F 26
 SRA (IX + -128)        ;; 057C:  DD CB 80 2E
 SRA (IX + 0)           ;; 0580:  DD CB 00 2E
 SRA (IX + 127)         ;; 0584:  DD CB 7F 2E
 SLL (IX + -128)        ;; 0588:  DD CB 80 36
 SLL (IX + 0)           ;; 058C:  DD CB 00 36
 SLL (IX + 127)         ;; 0590:  DD CB 7F 36
 SRL (IX + -128)        ;; 0594:  DD CB 80 3E
 SRL (IX + 0)           ;; 0598:  DD CB 00 3E
 SRL (IX + 127)         ;; 059C:  DD CB 7F 3E
 RLC (IY + -128)        ;; 05A0:  FD CB 80 06
 RLC (IY + 0)           ;; 05A4:  FD CB 00 06
 RLC (IY + 127)         ;; 05A8:  FD CB 7F 06
 RRC (IY + -128)        ;; 05AC:  FD CB 80 0E
 RRC (IY + 0)           ;; 05B0:  FD CB 00 0E
 RRC (IY + 127)         ;; 05B4:  FD CB 7F 0E
 RL (IY + -128)         ;; 05B8:  FD CB 80 16
 RL (IY + 0)            ;; 05BC:  FD CB 00 16
 RL (IY + 127)          ;; 05C0:  FD CB 7F 16
 RR (IY + -128)         ;; 05C4:  FD CB 80 1E
 RR (IY + 0)            ;; 05C8:  FD CB 00 1E
 RR (IY + 127)          ;; 05CC:  FD CB 7F 1E
 SLA (IY + -128)        ;; 05D0:  FD CB 80 26
 SLA (IY + 0)           ;; 05D4:  FD CB 00 26
 SLA (IY + 127)         ;; 05D8:  FD CB 7F 26
 SRA (IY + -128)        ;; 05DC:  FD CB 80 2E
 SRA (IY + 0)           ;; 05E0:  FD CB 00 2E
 SRA (IY + 127)         ;; 05E4:  FD CB 7F 2E
 SLL (IY + -128)        ;; 05E8:  FD CB 80 36
 SLL (IY + 0)           ;; 05EC:  FD CB 00 36
 SLL (IY + 127)         ;; 05F0:  FD CB 7F 36
 SRL (IY + -128)        ;; 05F4:  FD CB 80 3E
 SRL (IY + 0)           ;; 05F8:  FD CB 00 3E
 SRL (IY + 127)         ;; 05FC:  FD CB 7F 3E
 RLD                    ;; 0600:  ED 6F
 RRD                    ;; 0602:  ED 67
 BIT 0, B               ;; 0604:  CB 40
 BIT 1, B               ;; 0606:  CB 48
 BIT 2, B               ;; 0608:  CB 50
 BIT 3, B               ;; 060A:  CB 58
 BIT 4, B               ;; 060C:  CB 60
 BIT 5, B               ;; 060E:  CB 68
 BIT 6, B               ;; 0610:  CB 70
 BIT 7, B               ;; 0612:  CB 78
 RES 0, B               ;; 0614:  CB 80
 RES 1, B               ;; 0616:  CB 88
 RES 2, B               ;; 0618:  CB 90
 RES 3, B               ;; 061A:  CB 98
 RES 4, B               ;; 061C:  CB A0
 RES 5, B               ;; 061E:  CB A8
 RES 6, B               ;; 0620:  CB B0
 RES 7, B               ;; 0622:  CB B8
 SET 0, B               ;; 0624:  CB C0
 SET 1, B               ;; 0626:  CB C8
 SET 2, B               ;; 0628:  CB D0
 SET 3, B               ;; 062A:  CB D8
 SET 4, B               ;; 062C:  CB E0
 SET 5, B               ;; 062E:  CB E8
 SET 6, B               ;; 0630:  CB F0
 SET 7, B               ;; 0632:  CB F8
 BIT 0, C               ;; 0634:  CB 41
 BIT 1, C               ;; 0636:  CB 49
 BIT 2, C               ;; 0638:  CB 51
 BIT 3, C               ;; 063A:  CB 59
 BIT 4, C               ;; 063C:  CB 61
 BIT 5, C               ;; 063E:  CB 69
 BIT 6, C               ;; 0640:  CB 71
 BIT 7, C               ;; 0642:  CB 79
 RES 0, C               ;; 0644:  CB 81
 RES 1, C               ;; 0646:  CB 89
 RES 2, C               ;; 0648:  CB 91
 RES 3, C               ;; 064A:  CB 99
 RES 4, C               ;; 064C:  CB A1
 RES 5, C               ;; 064E:  CB A9
 RES 6, C               ;; 0650:  CB B1
 RES 7, C               ;; 0652:  CB B9
 SET 0, C               ;; 0654:  CB C1
 SET 1, C               ;; 0656:  CB C9
 SET 2, C               ;; 0658:  CB D1
 SET 3, C               ;; 065A:  CB D9
 SET 4, C               ;; 065C:  CB E1
 SET 5, C               ;; 065E:  CB E9
 SET 6, C               ;; 0660:  CB F1
 SET 7, C               ;; 0662:  CB F9
 BIT 0, D               ;; 0664:  CB 42
 BIT 1, D               ;; 0666:  CB 4A
 BIT 2, D               ;; 0668:  CB 52
 BIT 3, D               ;; 066A:  CB 5A
 BIT 4, D               ;; 066C:  CB 62
 BIT 5, D               ;; 066E:  CB 6A
 BIT 6, D               ;; 0670:  CB 72
 BIT 7, D               ;; 0672:  CB 7A
 RES 0, D               ;; 0674:  CB 82
 RES 1, D               ;; 0676:  CB 8A
 RES 2, D               ;; 0678:  CB 92
 RES 3, D               ;; 067A:  CB 9A
 RES 4, D               ;; 067C:  CB A2
 RES 5, D               ;; 067E:  CB AA
 RES 6, D               ;; 0680:  CB B2
 RES 7, D               ;; 0682:  CB BA
 SET 0, D               ;; 0684:  CB C2
 SET 1, D               ;; 0686:  CB CA
 SET 2, D               ;; 0688:  CB D2
 SET 3, D               ;; 068A:  CB DA
 SET 4, D               ;; 068C:  CB E2
 SET 5, D               ;; 068E:  CB EA
 SET 6, D               ;; 0690:  CB F2
 SET 7, D               ;; 0692:  CB FA
 BIT 0, E               ;; 0694:  CB 43
 BIT 1, E               ;; 0696:  CB 4B
 BIT 2, E               ;; 0698:  CB 53
 BIT 3, E               ;; 069A:  CB 5B
 BIT 4, E               ;; 069C:  CB 63
 BIT 5, E               ;; 069E:  CB 6B
 BIT 6, E               ;; 06A0:  CB 73
 BIT 7, E               ;; 06A2:  CB 7B
 RES 0, E               ;; 06A4:  CB 83
 RES 1, E               ;; 06A6:  CB 8B
 RES 2, E               ;; 06A8:  CB 93
 RES 3, E               ;; 06AA:  CB 9B
 RES 4, E               ;; 06AC:  CB A3
 RES 5, E               ;; 06AE:  CB AB
 RES 6, E               ;; 06B0:  CB B3
 RES 7, E               ;; 06B2:  CB BB
 SET 0, E               ;; 06B4:  CB C3
 SET 1, E               ;; 06B6:  CB CB
 SET 2, E               ;; 06B8:  CB D3
 SET 3, E               ;; 06BA:  CB DB
 SET 4, E               ;; 06BC:  CB E3
 SET 5, E               ;; 06BE:  CB EB
 SET 6, E               ;; 06C0:  CB F3
 SET 7, E               ;; 06C2:  CB FB
 BIT 0, H               ;; 06C4:  CB 44
 BIT 1, H               ;; 06C6:  CB 4C
 BIT 2, H               ;; 06C8:  CB 54
 BIT 3, H               ;; 06CA:  CB 5C
 BIT 4, H               ;; 06CC:  CB 64
 BIT 5, H               ;; 06CE:  CB 6C
 BIT 6, H               ;; 06D0:  CB 74
 BIT 7, H               ;; 06D2:  CB 7C
 RES 0, H               ;; 06D4:  CB 84
 RES 1, H               ;; 06D6:  CB 8C
 RES 2, H               ;; 06D8:  CB 94
 RES 3, H               ;; 06DA:  CB 9C
 RES 4, H               ;; 06DC:  CB A4
 RES 5, H               ;; 06DE:  CB AC
 RES 6, H               ;; 06E0:  CB B4
 RES 7, H               ;; 06E2:  CB BC
 SET 0, H               ;; 06E4:  CB C4
 SET 1, H               ;; 06E6:  CB CC
 SET 2, H               ;; 06E8:  CB D4
 SET 3, H               ;; 06EA:  CB DC
 SET 4, H               ;; 06EC:  CB E4
 SET 5, H               ;; 06EE:  CB EC
 SET 6, H               ;; 06F0:  CB F4
 SET 7, H               ;; 06F2:  CB FC
 BIT 0, L               ;; 06F4:  CB 45
 BIT 1, L               ;; 06F6:  CB 4D
 BIT 2, L               ;; 06F8:  CB 55
 BIT 3, L               ;; 06FA:  CB 5D
 BIT 4, L               ;; 06FC:  CB 65
 BIT 5, L               ;; 06FE:  CB 6D
 BIT 6, L               ;; 0700:  CB 75
 BIT 7, L               ;; 0702:  CB 7D
 RES 0, L               ;; 0704:  CB 85
 RES 1, L               ;; 0706:  CB 8D
 RES 2, L               ;; 0708:  CB 95
 RES 3, L               ;; 070A:  CB 9D
 RES 4, L               ;; 070C:  CB A5
 RES 5, L               ;; 070E:  CB AD
 RES 6, L               ;; 0710:  CB B5
 RES 7, L               ;; 0712:  CB BD
 SET 0, L               ;; 0714:  CB C5
 SET 1, L               ;; 0716:  CB CD
 SET 2, L               ;; 0718:  CB D5
 SET 3, L               ;; 071A:  CB DD
 SET 4, L               ;; 071C:  CB E5
 SET 5, L               ;; 071E:  CB ED
 SET 6, L               ;; 0720:  CB F5
 SET 7, L               ;; 0722:  CB FD
 BIT 0, A               ;; 0724:  CB 47
 BIT 1, A               ;; 0726:  CB 4F
 BIT 2, A               ;; 0728:  CB 57
 BIT 3, A               ;; 072A:  CB 5F
 BIT 4, A               ;; 072C:  CB 67
 BIT 5, A               ;; 072E:  CB 6F
 BIT 6, A               ;; 0730:  CB 77
 BIT 7, A               ;; 0732:  CB 7F
 RES 0, A               ;; 0734:  CB 87
 RES 1, A               ;; 0736:  CB 8F
 RES 2, A               ;; 0738:  CB 97
 RES 3, A               ;; 073A:  CB 9F
 RES 4, A               ;; 073C:  CB A7
 RES 5, A               ;; 073E:  CB AF
 RES 6, A               ;; 0740:  CB B7
 RES 7, A               ;; 0742:  CB BF
 SET 0, A               ;; 0744:  CB C7
 SET 1, A               ;; 0746:  CB CF
 SET 2, A               ;; 0748:  CB D7
 SET 3, A               ;; 074A:  CB DF
 SET 4, A               ;; 074C:  CB E7
 SET 5, A               ;; 074E:  CB EF
 SET 6, A               ;; 0750:  CB F7
 SET 7, A               ;; 0752:  CB FF
 BIT 0, (HL)            ;; 0754:  CB 46
 BIT 1, (HL)            ;; 0756:  CB 4E
 BIT 2, (HL)            ;; 0758:  CB 56
 BIT 3, (HL)            ;; 075A:  CB 5E
 BIT 4, (HL)            ;; 075C:  CB 66
 BIT 5, (HL)            ;; 075E:  CB 6E
 BIT 6, (HL)            ;; 0760:  CB 76
 BIT 7, (HL)            ;; 0762:  CB 7E
 RES 0, (HL)            ;; 0764:  CB 86
 RES 1, (HL)            ;; 0766:  CB 8E
 RES 2, (HL)            ;; 0768:  CB 96
 RES 3, (HL)            ;; 076A:  CB 9E
 RES 4, (HL)            ;; 076C:  CB A6
 RES 5, (HL)            ;; 076E:  CB AE
 RES 6, (HL)            ;; 0770:  CB B6
 RES 7, (HL)            ;; 0772:  CB BE
 SET 0, (HL)            ;; 0774:  CB C6
 SET 1, (HL)            ;; 0776:  CB CE
 SET 2, (HL)            ;; 0778:  CB D6
 SET 3, (HL)            ;; 077A:  CB DE
 SET 4, (HL)            ;; 077C:  CB E6
 SET 5, (HL)            ;; 077E:  CB EE
 SET 6, (HL)            ;; 0780:  CB F6
 SET 7, (HL)            ;; 0782:  CB FE
 BIT 0, (IX + -128)     ;; 0784:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 0788:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 078C:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 0790:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 0794:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 0798:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 079C:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 07A0:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 07A4:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 07A8:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 07AC:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 07B0:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 07B4:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 07B8:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 07BC:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 07C0:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 07C4:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 07C8:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 07CC:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 07D0:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 07D4:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 07D8:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 07DC:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 07E0:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 07E4:  DD CB 80 86
 RES 1, (IX + -128)     ;; 07E8:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 07EC:  DD CB 80 96
 RES 3, (IX + -128)     ;; 07F0:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 07F4:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 07F8:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 07FC:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 0800:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 0804:  DD CB 00 86
 RES 1, (IX + 0)        ;; 0808:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 080C:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0810:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 0814:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 0818:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 081C:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0820:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 0824:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 0828:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 082C:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0830:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0834:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0838:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 083C:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0840:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0844:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0848:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 084C:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0850:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0854:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0858:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 085C:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0860:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0864:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 0868:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 086C:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 0870:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0874:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 0878:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 087C:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 0880:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0884:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 0888:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 088C:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 0890:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 0894:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 0898:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 089C:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 08A0:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 08A4:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 08A8:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 08AC:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 08B0:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 08B4:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 08B8:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 08BC:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 08C0:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 08C4:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 08C8:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 08CC:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 08D0:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 08D4:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 08D8:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 08DC:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 08E0:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 08E4:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 08E8:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 08EC:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 08F0:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 08F4:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 08F8:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 08FC:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 0900:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 0904:  FD CB 80 86
 RES 1, (IY + -128)     ;; 0908:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 090C:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0910:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 0914:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 0918:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 091C:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0920:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 0924:  FD CB 00 86
 RES 1, (IY + 0)        ;; 0928:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 092C:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0930:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0934:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0938:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 093C:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0940:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0944:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0948:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 094C:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0950:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0954:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0958:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 095C:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0960:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0964:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 0968:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 096C:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 0970:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0974:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 0978:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 097C:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 0980:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0984:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 0988:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 098C:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 0990:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 0994:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 0998:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 099C:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 09A0:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 09A4:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 09A8:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 09AC:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 09B0:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 09B4:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 09B8:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 09BC:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 09C0:  FD CB 7F FE
 JP 0                   ;; 09C4:  C3 00 00
 JP 4660                ;; 09C7:  C3 34 12
 JP 52719               ;; 09CA:  C3 EF CD
 JP 65535               ;; 09CD:  C3 FF FF
 JP NZ, 0               ;; 09D0:  C2 00 00
 JP NZ, 4660            ;; 09D3:  C2 34 12
 JP NZ, 52719           ;; 09D6:  C2 EF CD
 JP NZ, 65535           ;; 09D9:  C2 FF FF
 JP Z, 0                ;; 09DC:  CA 00 00
 JP Z, 4660             ;; 09DF:  CA 34 12
 JP Z, 52719            ;; 09E2:  CA EF CD
 JP Z, 65535            ;; 09E5:  CA FF FF
 JP NC, 0               ;; 09E8:  D2 00 00
 JP NC, 4660            ;; 09EB:  D2 34 12
 JP NC, 52719           ;; 09EE:  D2 EF CD
 JP NC, 65535           ;; 09F1:  D2 FF FF
 JP C, 0                ;; 09F4:  DA 00 00
 JP C, 4660             ;; 09F7:  DA 34 12
 JP C, 52719            ;; 09FA:  DA EF CD
 JP C, 65535            ;; 09FD:  DA FF FF
 JP PO, 0               ;; 0A00:  E2 00 00
 JP PO, 4660            ;; 0A03:  E2 34 12
 JP PO, 52719           ;; 0A06:  E2 EF CD
 JP PO, 65535           ;; 0A09:  E2 FF FF
 JP PE, 0               ;; 0A0C:  EA 00 00
 JP PE, 4660            ;; 0A0F:  EA 34 12
 JP PE, 52719           ;; 0A12:  EA EF CD
 JP PE, 65535           ;; 0A15:  EA FF FF
 JP P, 0                ;; 0A18:  F2 00 00
 JP P, 4660             ;; 0A1B:  F2 34 12
 JP P, 52719            ;; 0A1E:  F2 EF CD
 JP P, 65535            ;; 0A21:  F2 FF FF
 JP M, 0                ;; 0A24:  FA 00 00
 JP M, 4660             ;; 0A27:  FA 34 12
 JP M, 52719            ;; 0A2A:  FA EF CD
 JP M, 65535            ;; 0A2D:  FA FF FF
 JR ASMPC+2             ;; 0A30:  18 00
 JR NZ, ASMPC+2         ;; 0A32:  20 00
 JR Z, ASMPC+2          ;; 0A34:  28 00
 JR NC, ASMPC+2         ;; 0A36:  30 00
 JR C, ASMPC+2          ;; 0A38:  38 00
 JP (HL)                ;; 0A3A:  E9
 JP (IX)                ;; 0A3B:  DD E9
 JP (IY)                ;; 0A3D:  FD E9
 DJNZ ASMPC+2           ;; 0A3F:  10 00
 CALL 0                 ;; 0A41:  CD 00 00
 CALL 4660              ;; 0A44:  CD 34 12
 CALL 52719             ;; 0A47:  CD EF CD
 CALL 65535             ;; 0A4A:  CD FF FF
 CALL NZ, 0             ;; 0A4D:  C4 00 00
 CALL NZ, 4660          ;; 0A50:  C4 34 12
 CALL NZ, 52719         ;; 0A53:  C4 EF CD
 CALL NZ, 65535         ;; 0A56:  C4 FF FF
 CALL Z, 0              ;; 0A59:  CC 00 00
 CALL Z, 4660           ;; 0A5C:  CC 34 12
 CALL Z, 52719          ;; 0A5F:  CC EF CD
 CALL Z, 65535          ;; 0A62:  CC FF FF
 CALL NC, 0             ;; 0A65:  D4 00 00
 CALL NC, 4660          ;; 0A68:  D4 34 12
 CALL NC, 52719         ;; 0A6B:  D4 EF CD
 CALL NC, 65535         ;; 0A6E:  D4 FF FF
 CALL C, 0              ;; 0A71:  DC 00 00
 CALL C, 4660           ;; 0A74:  DC 34 12
 CALL C, 52719          ;; 0A77:  DC EF CD
 CALL C, 65535          ;; 0A7A:  DC FF FF
 CALL PO, 0             ;; 0A7D:  E4 00 00
 CALL PO, 4660          ;; 0A80:  E4 34 12
 CALL PO, 52719         ;; 0A83:  E4 EF CD
 CALL PO, 65535         ;; 0A86:  E4 FF FF
 CALL PE, 0             ;; 0A89:  EC 00 00
 CALL PE, 4660          ;; 0A8C:  EC 34 12
 CALL PE, 52719         ;; 0A8F:  EC EF CD
 CALL PE, 65535         ;; 0A92:  EC FF FF
 CALL P, 0              ;; 0A95:  F4 00 00
 CALL P, 4660           ;; 0A98:  F4 34 12
 CALL P, 52719          ;; 0A9B:  F4 EF CD
 CALL P, 65535          ;; 0A9E:  F4 FF FF
 CALL M, 0              ;; 0AA1:  FC 00 00
 CALL M, 4660           ;; 0AA4:  FC 34 12
 CALL M, 52719          ;; 0AA7:  FC EF CD
 CALL M, 65535          ;; 0AAA:  FC FF FF
 RET                    ;; 0AAD:  C9
 RET NZ                 ;; 0AAE:  C0
 RET Z                  ;; 0AAF:  C8
 RET NC                 ;; 0AB0:  D0
 RET C                  ;; 0AB1:  D8
 RET PO                 ;; 0AB2:  E0
 RET PE                 ;; 0AB3:  E8
 RET P                  ;; 0AB4:  F0
 RET M                  ;; 0AB5:  F8
 RETI                   ;; 0AB6:  ED 4D
 RETN                   ;; 0AB8:  ED 45
 RST 0                  ;; 0ABA:  C7
 RST 8                  ;; 0ABB:  CF
 RST 16                 ;; 0ABC:  D7
 RST 24                 ;; 0ABD:  DF
 RST 32                 ;; 0ABE:  E7
 RST 40                 ;; 0ABF:  EF
 RST 48                 ;; 0AC0:  F7
 RST 56                 ;; 0AC1:  FF
 IN A, (0)              ;; 0AC2:  DB 00
 IN A, (85)             ;; 0AC4:  DB 55
 IN A, (170)            ;; 0AC6:  DB AA
 IN A, (255)            ;; 0AC8:  DB FF
 IN B, (C)              ;; 0ACA:  ED 40
 IN C, (C)              ;; 0ACC:  ED 48
 IN D, (C)              ;; 0ACE:  ED 50
 IN E, (C)              ;; 0AD0:  ED 58
 IN H, (C)              ;; 0AD2:  ED 60
 IN L, (C)              ;; 0AD4:  ED 68
 IN A, (C)              ;; 0AD6:  ED 78
 INI                    ;; 0AD8:  ED A2
 INIR                   ;; 0ADA:  ED B2
 IND                    ;; 0ADC:  ED AA
 INDR                   ;; 0ADE:  ED BA
 OUT (0), A             ;; 0AE0:  D3 00
 OUT (85), A            ;; 0AE2:  D3 55
 OUT (170), A           ;; 0AE4:  D3 AA
 OUT (255), A           ;; 0AE6:  D3 FF
 OUT (C), B             ;; 0AE8:  ED 41
 OUT (C), C             ;; 0AEA:  ED 49
 OUT (C), D             ;; 0AEC:  ED 51
 OUT (C), E             ;; 0AEE:  ED 59
 OUT (C), H             ;; 0AF0:  ED 61
 OUT (C), L             ;; 0AF2:  ED 69
 OUT (C), A             ;; 0AF4:  ED 79
 OUTI                   ;; 0AF6:  ED A3
 OTIR                   ;; 0AF8:  ED B3
 OUTD                   ;; 0AFA:  ED AB
 OTDR                   ;; 0AFC:  ED BB
 MLT BC                 ;; 0AFE:  ED 4C
 MLT DE                 ;; 0B00:  ED 5C
 MLT HL                 ;; 0B02:  ED 6C
 MLT SP                 ;; 0B04:  ED 7C
 TST B                  ;; 0B06:  ED 04
 TST C                  ;; 0B08:  ED 0C
 TST D                  ;; 0B0A:  ED 14
 TST E                  ;; 0B0C:  ED 1C
 TST H                  ;; 0B0E:  ED 24
 TST L                  ;; 0B10:  ED 2C
 TST A                  ;; 0B12:  ED 3C
 TST 0                  ;; 0B14:  ED 64 00
 TST 85                 ;; 0B17:  ED 64 55
 TST 170                ;; 0B1A:  ED 64 AA
 TST 255                ;; 0B1D:  ED 64 FF
 TST (HL)               ;; 0B20:  ED 34
 IN0 B, (0)             ;; 0B22:  ED 00 00
 IN0 B, (85)            ;; 0B25:  ED 00 55
 IN0 B, (170)           ;; 0B28:  ED 00 AA
 IN0 B, (255)           ;; 0B2B:  ED 00 FF
 IN0 C, (0)             ;; 0B2E:  ED 08 00
 IN0 C, (85)            ;; 0B31:  ED 08 55
 IN0 C, (170)           ;; 0B34:  ED 08 AA
 IN0 C, (255)           ;; 0B37:  ED 08 FF
 IN0 D, (0)             ;; 0B3A:  ED 10 00
 IN0 D, (85)            ;; 0B3D:  ED 10 55
 IN0 D, (170)           ;; 0B40:  ED 10 AA
 IN0 D, (255)           ;; 0B43:  ED 10 FF
 IN0 E, (0)             ;; 0B46:  ED 18 00
 IN0 E, (85)            ;; 0B49:  ED 18 55
 IN0 E, (170)           ;; 0B4C:  ED 18 AA
 IN0 E, (255)           ;; 0B4F:  ED 18 FF
 IN0 H, (0)             ;; 0B52:  ED 20 00
 IN0 H, (85)            ;; 0B55:  ED 20 55
 IN0 H, (170)           ;; 0B58:  ED 20 AA
 IN0 H, (255)           ;; 0B5B:  ED 20 FF
 IN0 L, (0)             ;; 0B5E:  ED 28 00
 IN0 L, (85)            ;; 0B61:  ED 28 55
 IN0 L, (170)           ;; 0B64:  ED 28 AA
 IN0 L, (255)           ;; 0B67:  ED 28 FF
 IN0 A, (0)             ;; 0B6A:  ED 38 00
 IN0 A, (85)            ;; 0B6D:  ED 38 55
 IN0 A, (170)           ;; 0B70:  ED 38 AA
 IN0 A, (255)           ;; 0B73:  ED 38 FF
 OUT0 (0), B            ;; 0B76:  ED 01 00
 OUT0 (85), B           ;; 0B79:  ED 01 55
 OUT0 (170), B          ;; 0B7C:  ED 01 AA
 OUT0 (255), B          ;; 0B7F:  ED 01 FF
 OUT0 (0), C            ;; 0B82:  ED 09 00
 OUT0 (85), C           ;; 0B85:  ED 09 55
 OUT0 (170), C          ;; 0B88:  ED 09 AA
 OUT0 (255), C          ;; 0B8B:  ED 09 FF
 OUT0 (0), D            ;; 0B8E:  ED 11 00
 OUT0 (85), D           ;; 0B91:  ED 11 55
 OUT0 (170), D          ;; 0B94:  ED 11 AA
 OUT0 (255), D          ;; 0B97:  ED 11 FF
 OUT0 (0), E            ;; 0B9A:  ED 19 00
 OUT0 (85), E           ;; 0B9D:  ED 19 55
 OUT0 (170), E          ;; 0BA0:  ED 19 AA
 OUT0 (255), E          ;; 0BA3:  ED 19 FF
 OUT0 (0), H            ;; 0BA6:  ED 21 00
 OUT0 (85), H           ;; 0BA9:  ED 21 55
 OUT0 (170), H          ;; 0BAC:  ED 21 AA
 OUT0 (255), H          ;; 0BAF:  ED 21 FF
 OUT0 (0), L            ;; 0BB2:  ED 29 00
 OUT0 (85), L           ;; 0BB5:  ED 29 55
 OUT0 (170), L          ;; 0BB8:  ED 29 AA
 OUT0 (255), L          ;; 0BBB:  ED 29 FF
 OUT0 (0), A            ;; 0BBE:  ED 39 00
 OUT0 (85), A           ;; 0BC1:  ED 39 55
 OUT0 (170), A          ;; 0BC4:  ED 39 AA
 OUT0 (255), A          ;; 0BC7:  ED 39 FF
 OTDM                   ;; 0BCA:  ED 8B
 OTDMR                  ;; 0BCC:  ED 9B
 OTIM                   ;; 0BCE:  ED 83
 OTIMR                  ;; 0BD0:  ED 93
 TSTIO 0                ;; 0BD2:  ED 74 00
 TSTIO 85               ;; 0BD5:  ED 74 55
 TSTIO 170              ;; 0BD8:  ED 74 AA
 TSTIO 255              ;; 0BDB:  ED 74 FF
 SLP                    ;; 0BDE:  ED 76
