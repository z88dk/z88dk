 ld b, 0                ;; 0000:  06 00
 ld b, 85               ;; 0002:  06 55
 ld b, 170              ;; 0004:  06 AA
 ld b, 255              ;; 0006:  06 FF
 ld c, 0                ;; 0008:  0E 00
 ld c, 85               ;; 000A:  0E 55
 ld c, 170              ;; 000C:  0E AA
 ld c, 255              ;; 000E:  0E FF
 ld d, 0                ;; 0010:  16 00
 ld d, 85               ;; 0012:  16 55
 ld d, 170              ;; 0014:  16 AA
 ld d, 255              ;; 0016:  16 FF
 ld e, 0                ;; 0018:  1E 00
 ld e, 85               ;; 001A:  1E 55
 ld e, 170              ;; 001C:  1E AA
 ld e, 255              ;; 001E:  1E FF
 ld h, 0                ;; 0020:  26 00
 ld h, 85               ;; 0022:  26 55
 ld h, 170              ;; 0024:  26 AA
 ld h, 255              ;; 0026:  26 FF
 ld l, 0                ;; 0028:  2E 00
 ld l, 85               ;; 002A:  2E 55
 ld l, 170              ;; 002C:  2E AA
 ld l, 255              ;; 002E:  2E FF
 ld a, 0                ;; 0030:  3E 00
 ld a, 85               ;; 0032:  3E 55
 ld a, 170              ;; 0034:  3E AA
 ld a, 255              ;; 0036:  3E FF
 ld b', 0               ;; 0038:  76 06 00
 ld b', 85              ;; 003B:  76 06 55
 ld b', 170             ;; 003E:  76 06 AA
 ld b', 255             ;; 0041:  76 06 FF
 ld c', 0               ;; 0044:  76 0E 00
 ld c', 85              ;; 0047:  76 0E 55
 ld c', 170             ;; 004A:  76 0E AA
 ld c', 255             ;; 004D:  76 0E FF
 ld d', 0               ;; 0050:  76 16 00
 ld d', 85              ;; 0053:  76 16 55
 ld d', 170             ;; 0056:  76 16 AA
 ld d', 255             ;; 0059:  76 16 FF
 ld e', 0               ;; 005C:  76 1E 00
 ld e', 85              ;; 005F:  76 1E 55
 ld e', 170             ;; 0062:  76 1E AA
 ld e', 255             ;; 0065:  76 1E FF
 ld h', 0               ;; 0068:  76 26 00
 ld h', 85              ;; 006B:  76 26 55
 ld h', 170             ;; 006E:  76 26 AA
 ld h', 255             ;; 0071:  76 26 FF
 ld l', 0               ;; 0074:  76 2E 00
 ld l', 85              ;; 0077:  76 2E 55
 ld l', 170             ;; 007A:  76 2E AA
 ld l', 255             ;; 007D:  76 2E FF
 ld a', 0               ;; 0080:  76 3E 00
 ld a', 85              ;; 0083:  76 3E 55
 ld a', 170             ;; 0086:  76 3E AA
 ld a', 255             ;; 0089:  76 3E FF
 ld b, (hl)             ;; 008C:  46
 ld c, (hl)             ;; 008D:  4E
 ld d, (hl)             ;; 008E:  56
 ld e, (hl)             ;; 008F:  5E
 ld h, (hl)             ;; 0090:  66
 ld l, (hl)             ;; 0091:  6E
 ld a, (hl)             ;; 0092:  7E
 ld b', (hl)            ;; 0093:  76 46
 ld c', (hl)            ;; 0095:  76 4E
 ld d', (hl)            ;; 0097:  76 56
 ld e', (hl)            ;; 0099:  76 5E
 ld h', (hl)            ;; 009B:  76 66
 ld l', (hl)            ;; 009D:  76 6E
 ld a', (hl)            ;; 009F:  76 7E
 ld b, (ix + -128)      ;; 00A1:  DD 46 80
 ld b, (ix)             ;; 00A4:  DD 46 00
 ld b, (ix + 127)       ;; 00A7:  DD 46 7F
 ld c, (ix + -128)      ;; 00AA:  DD 4E 80
 ld c, (ix)             ;; 00AD:  DD 4E 00
 ld c, (ix + 127)       ;; 00B0:  DD 4E 7F
 ld d, (ix + -128)      ;; 00B3:  DD 56 80
 ld d, (ix)             ;; 00B6:  DD 56 00
 ld d, (ix + 127)       ;; 00B9:  DD 56 7F
 ld e, (ix + -128)      ;; 00BC:  DD 5E 80
 ld e, (ix)             ;; 00BF:  DD 5E 00
 ld e, (ix + 127)       ;; 00C2:  DD 5E 7F
 ld h, (ix + -128)      ;; 00C5:  DD 66 80
 ld h, (ix)             ;; 00C8:  DD 66 00
 ld h, (ix + 127)       ;; 00CB:  DD 66 7F
 ld l, (ix + -128)      ;; 00CE:  DD 6E 80
 ld l, (ix)             ;; 00D1:  DD 6E 00
 ld l, (ix + 127)       ;; 00D4:  DD 6E 7F
 ld a, (ix + -128)      ;; 00D7:  DD 7E 80
 ld a, (ix)             ;; 00DA:  DD 7E 00
 ld a, (ix + 127)       ;; 00DD:  DD 7E 7F
 ld b', (ix + -128)     ;; 00E0:  76 DD 46 80
 ld b', (ix)            ;; 00E4:  76 DD 46 00
 ld b', (ix + 127)      ;; 00E8:  76 DD 46 7F
 ld c', (ix + -128)     ;; 00EC:  76 DD 4E 80
 ld c', (ix)            ;; 00F0:  76 DD 4E 00
 ld c', (ix + 127)      ;; 00F4:  76 DD 4E 7F
 ld d', (ix + -128)     ;; 00F8:  76 DD 56 80
 ld d', (ix)            ;; 00FC:  76 DD 56 00
 ld d', (ix + 127)      ;; 0100:  76 DD 56 7F
 ld e', (ix + -128)     ;; 0104:  76 DD 5E 80
 ld e', (ix)            ;; 0108:  76 DD 5E 00
 ld e', (ix + 127)      ;; 010C:  76 DD 5E 7F
 ld h', (ix + -128)     ;; 0110:  76 DD 66 80
 ld h', (ix)            ;; 0114:  76 DD 66 00
 ld h', (ix + 127)      ;; 0118:  76 DD 66 7F
 ld l', (ix + -128)     ;; 011C:  76 DD 6E 80
 ld l', (ix)            ;; 0120:  76 DD 6E 00
 ld l', (ix + 127)      ;; 0124:  76 DD 6E 7F
 ld a', (ix + -128)     ;; 0128:  76 DD 7E 80
 ld a', (ix)            ;; 012C:  76 DD 7E 00
 ld a', (ix + 127)      ;; 0130:  76 DD 7E 7F
 ld b, (iy + -128)      ;; 0134:  FD 46 80
 ld b, (iy)             ;; 0137:  FD 46 00
 ld b, (iy + 127)       ;; 013A:  FD 46 7F
 ld c, (iy + -128)      ;; 013D:  FD 4E 80
 ld c, (iy)             ;; 0140:  FD 4E 00
 ld c, (iy + 127)       ;; 0143:  FD 4E 7F
 ld d, (iy + -128)      ;; 0146:  FD 56 80
 ld d, (iy)             ;; 0149:  FD 56 00
 ld d, (iy + 127)       ;; 014C:  FD 56 7F
 ld e, (iy + -128)      ;; 014F:  FD 5E 80
 ld e, (iy)             ;; 0152:  FD 5E 00
 ld e, (iy + 127)       ;; 0155:  FD 5E 7F
 ld h, (iy + -128)      ;; 0158:  FD 66 80
 ld h, (iy)             ;; 015B:  FD 66 00
 ld h, (iy + 127)       ;; 015E:  FD 66 7F
 ld l, (iy + -128)      ;; 0161:  FD 6E 80
 ld l, (iy)             ;; 0164:  FD 6E 00
 ld l, (iy + 127)       ;; 0167:  FD 6E 7F
 ld a, (iy + -128)      ;; 016A:  FD 7E 80
 ld a, (iy)             ;; 016D:  FD 7E 00
 ld a, (iy + 127)       ;; 0170:  FD 7E 7F
 ld b', (iy + -128)     ;; 0173:  76 FD 46 80
 ld b', (iy)            ;; 0177:  76 FD 46 00
 ld b', (iy + 127)      ;; 017B:  76 FD 46 7F
 ld c', (iy + -128)     ;; 017F:  76 FD 4E 80
 ld c', (iy)            ;; 0183:  76 FD 4E 00
 ld c', (iy + 127)      ;; 0187:  76 FD 4E 7F
 ld d', (iy + -128)     ;; 018B:  76 FD 56 80
 ld d', (iy)            ;; 018F:  76 FD 56 00
 ld d', (iy + 127)      ;; 0193:  76 FD 56 7F
 ld e', (iy + -128)     ;; 0197:  76 FD 5E 80
 ld e', (iy)            ;; 019B:  76 FD 5E 00
 ld e', (iy + 127)      ;; 019F:  76 FD 5E 7F
 ld h', (iy + -128)     ;; 01A3:  76 FD 66 80
 ld h', (iy)            ;; 01A7:  76 FD 66 00
 ld h', (iy + 127)      ;; 01AB:  76 FD 66 7F
 ld l', (iy + -128)     ;; 01AF:  76 FD 6E 80
 ld l', (iy)            ;; 01B3:  76 FD 6E 00
 ld l', (iy + 127)      ;; 01B7:  76 FD 6E 7F
 ld a', (iy + -128)     ;; 01BB:  76 FD 7E 80
 ld a', (iy)            ;; 01BF:  76 FD 7E 00
 ld a', (iy + 127)      ;; 01C3:  76 FD 7E 7F
 ld (hl), b             ;; 01C7:  70
 ld (hl), c             ;; 01C8:  71
 ld (hl), d             ;; 01C9:  72
 ld (hl), e             ;; 01CA:  73
 ld (hl), h             ;; 01CB:  74
 ld (hl), l             ;; 01CC:  75
 ld (hl), a             ;; 01CD:  77
 ld (ix + -128), b      ;; 01CE:  DD 70 80
 ld (ix), b             ;; 01D1:  DD 70 00
 ld (ix + 127), b       ;; 01D4:  DD 70 7F
 ld (ix + -128), c      ;; 01D7:  DD 71 80
 ld (ix), c             ;; 01DA:  DD 71 00
 ld (ix + 127), c       ;; 01DD:  DD 71 7F
 ld (ix + -128), d      ;; 01E0:  DD 72 80
 ld (ix), d             ;; 01E3:  DD 72 00
 ld (ix + 127), d       ;; 01E6:  DD 72 7F
 ld (ix + -128), e      ;; 01E9:  DD 73 80
 ld (ix), e             ;; 01EC:  DD 73 00
 ld (ix + 127), e       ;; 01EF:  DD 73 7F
 ld (ix + -128), h      ;; 01F2:  DD 74 80
 ld (ix), h             ;; 01F5:  DD 74 00
 ld (ix + 127), h       ;; 01F8:  DD 74 7F
 ld (ix + -128), l      ;; 01FB:  DD 75 80
 ld (ix), l             ;; 01FE:  DD 75 00
 ld (ix + 127), l       ;; 0201:  DD 75 7F
 ld (ix + -128), a      ;; 0204:  DD 77 80
 ld (ix), a             ;; 0207:  DD 77 00
 ld (ix + 127), a       ;; 020A:  DD 77 7F
 ld (iy + -128), b      ;; 020D:  FD 70 80
 ld (iy), b             ;; 0210:  FD 70 00
 ld (iy + 127), b       ;; 0213:  FD 70 7F
 ld (iy + -128), c      ;; 0216:  FD 71 80
 ld (iy), c             ;; 0219:  FD 71 00
 ld (iy + 127), c       ;; 021C:  FD 71 7F
 ld (iy + -128), d      ;; 021F:  FD 72 80
 ld (iy), d             ;; 0222:  FD 72 00
 ld (iy + 127), d       ;; 0225:  FD 72 7F
 ld (iy + -128), e      ;; 0228:  FD 73 80
 ld (iy), e             ;; 022B:  FD 73 00
 ld (iy + 127), e       ;; 022E:  FD 73 7F
 ld (iy + -128), h      ;; 0231:  FD 74 80
 ld (iy), h             ;; 0234:  FD 74 00
 ld (iy + 127), h       ;; 0237:  FD 74 7F
 ld (iy + -128), l      ;; 023A:  FD 75 80
 ld (iy), l             ;; 023D:  FD 75 00
 ld (iy + 127), l       ;; 0240:  FD 75 7F
 ld (iy + -128), a      ;; 0243:  FD 77 80
 ld (iy), a             ;; 0246:  FD 77 00
 ld (iy + 127), a       ;; 0249:  FD 77 7F
 ld (hl), 0             ;; 024C:  36 00
 ld (hl), 85            ;; 024E:  36 55
 ld (hl), 170           ;; 0250:  36 AA
 ld (hl), 255           ;; 0252:  36 FF
 ld (ix + -128), 0      ;; 0254:  DD 36 80 00
 ld (ix), 0             ;; 0258:  DD 36 00 00
 ld (ix + 127), 0       ;; 025C:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0260:  DD 36 80 55
 ld (ix), 85            ;; 0264:  DD 36 00 55
 ld (ix + 127), 85      ;; 0268:  DD 36 7F 55
 ld (ix + -128), 170    ;; 026C:  DD 36 80 AA
 ld (ix), 170           ;; 0270:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0274:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0278:  DD 36 80 FF
 ld (ix), 255           ;; 027C:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0280:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0284:  FD 36 80 00
 ld (iy), 0             ;; 0288:  FD 36 00 00
 ld (iy + 127), 0       ;; 028C:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0290:  FD 36 80 55
 ld (iy), 85            ;; 0294:  FD 36 00 55
 ld (iy + 127), 85      ;; 0298:  FD 36 7F 55
 ld (iy + -128), 170    ;; 029C:  FD 36 80 AA
 ld (iy), 170           ;; 02A0:  FD 36 00 AA
 ld (iy + 127), 170     ;; 02A4:  FD 36 7F AA
 ld (iy + -128), 255    ;; 02A8:  FD 36 80 FF
 ld (iy), 255           ;; 02AC:  FD 36 00 FF
 ld (iy + 127), 255     ;; 02B0:  FD 36 7F FF
 ld a, (bc)             ;; 02B4:  0A
 ld a, (de)             ;; 02B5:  1A
 ld a', (bc)            ;; 02B6:  76 0A
 ld a', (de)            ;; 02B8:  76 1A
 ld (bc), a             ;; 02BA:  02
 ld (de), a             ;; 02BB:  12
 ld a, (0)              ;; 02BC:  3A 00 00
 ld a, (291)            ;; 02BF:  3A 23 01
 ld a, (17767)          ;; 02C2:  3A 67 45
 ld a, (35243)          ;; 02C5:  3A AB 89
 ld a, (52719)          ;; 02C8:  3A EF CD
 ld a, (65535)          ;; 02CB:  3A FF FF
 ld a', (0)             ;; 02CE:  76 3A 00 00
 ld a', (291)           ;; 02D2:  76 3A 23 01
 ld a', (17767)         ;; 02D6:  76 3A 67 45
 ld a', (35243)         ;; 02DA:  76 3A AB 89
 ld a', (52719)         ;; 02DE:  76 3A EF CD
 ld a', (65535)         ;; 02E2:  76 3A FF FF
 ld (0), a              ;; 02E6:  32 00 00
 ld (291), a            ;; 02E9:  32 23 01
 ld (17767), a          ;; 02EC:  32 67 45
 ld (35243), a          ;; 02EF:  32 AB 89
 ld (52719), a          ;; 02F2:  32 EF CD
 ld (65535), a          ;; 02F5:  32 FF FF
 add a, b               ;; 02F8:  80
 add a, c               ;; 02F9:  81
 add a, d               ;; 02FA:  82
 add a, e               ;; 02FB:  83
 add a, h               ;; 02FC:  84
 add a, l               ;; 02FD:  85
 add a, (hl)            ;; 02FE:  86
 add a, a               ;; 02FF:  87
 adc a, b               ;; 0300:  88
 adc a, c               ;; 0301:  89
 adc a, d               ;; 0302:  8A
 adc a, e               ;; 0303:  8B
 adc a, h               ;; 0304:  8C
 adc a, l               ;; 0305:  8D
 adc a, (hl)            ;; 0306:  8E
 adc a, a               ;; 0307:  8F
 sub a, b               ;; 0308:  90
 sub a, c               ;; 0309:  91
 sub a, d               ;; 030A:  92
 sub a, e               ;; 030B:  93
 sub a, h               ;; 030C:  94
 sub a, l               ;; 030D:  95
 sub a, (hl)            ;; 030E:  96
 sub a, a               ;; 030F:  97
 sbc a, b               ;; 0310:  98
 sbc a, c               ;; 0311:  99
 sbc a, d               ;; 0312:  9A
 sbc a, e               ;; 0313:  9B
 sbc a, h               ;; 0314:  9C
 sbc a, l               ;; 0315:  9D
 sbc a, (hl)            ;; 0316:  9E
 sbc a, a               ;; 0317:  9F
 and a, b               ;; 0318:  A0
 and a, c               ;; 0319:  A1
 and a, d               ;; 031A:  A2
 and a, e               ;; 031B:  A3
 and a, h               ;; 031C:  A4
 and a, l               ;; 031D:  A5
 and a, (hl)            ;; 031E:  A6
 and a, a               ;; 031F:  A7
 xor a, b               ;; 0320:  A8
 xor a, c               ;; 0321:  A9
 xor a, d               ;; 0322:  AA
 xor a, e               ;; 0323:  AB
 xor a, h               ;; 0324:  AC
 xor a, l               ;; 0325:  AD
 xor a, (hl)            ;; 0326:  AE
 xor a, a               ;; 0327:  AF
 or a, b                ;; 0328:  B0
 or a, c                ;; 0329:  B1
 or a, d                ;; 032A:  B2
 or a, e                ;; 032B:  B3
 or a, h                ;; 032C:  B4
 or a, l                ;; 032D:  B5
 or a, (hl)             ;; 032E:  B6
 or a, a                ;; 032F:  B7
 cp a, b                ;; 0330:  B8
 cp a, c                ;; 0331:  B9
 cp a, d                ;; 0332:  BA
 cp a, e                ;; 0333:  BB
 cp a, h                ;; 0334:  BC
 cp a, l                ;; 0335:  BD
 cp a, (hl)             ;; 0336:  BE
 cp a, a                ;; 0337:  BF
 add b                  ;; 0338:  80
 add c                  ;; 0339:  81
 add d                  ;; 033A:  82
 add e                  ;; 033B:  83
 add h                  ;; 033C:  84
 add l                  ;; 033D:  85
 add (hl)               ;; 033E:  86
 add a                  ;; 033F:  87
 adc b                  ;; 0340:  88
 adc c                  ;; 0341:  89
 adc d                  ;; 0342:  8A
 adc e                  ;; 0343:  8B
 adc h                  ;; 0344:  8C
 adc l                  ;; 0345:  8D
 adc (hl)               ;; 0346:  8E
 adc a                  ;; 0347:  8F
 sub b                  ;; 0348:  90
 sub c                  ;; 0349:  91
 sub d                  ;; 034A:  92
 sub e                  ;; 034B:  93
 sub h                  ;; 034C:  94
 sub l                  ;; 034D:  95
 sub (hl)               ;; 034E:  96
 sub a                  ;; 034F:  97
 sbc b                  ;; 0350:  98
 sbc c                  ;; 0351:  99
 sbc d                  ;; 0352:  9A
 sbc e                  ;; 0353:  9B
 sbc h                  ;; 0354:  9C
 sbc l                  ;; 0355:  9D
 sbc (hl)               ;; 0356:  9E
 sbc a                  ;; 0357:  9F
 and b                  ;; 0358:  A0
 and c                  ;; 0359:  A1
 and d                  ;; 035A:  A2
 and e                  ;; 035B:  A3
 and h                  ;; 035C:  A4
 and l                  ;; 035D:  A5
 and (hl)               ;; 035E:  A6
 and a                  ;; 035F:  A7
 xor b                  ;; 0360:  A8
 xor c                  ;; 0361:  A9
 xor d                  ;; 0362:  AA
 xor e                  ;; 0363:  AB
 xor h                  ;; 0364:  AC
 xor l                  ;; 0365:  AD
 xor (hl)               ;; 0366:  AE
 xor a                  ;; 0367:  AF
 or b                   ;; 0368:  B0
 or c                   ;; 0369:  B1
 or d                   ;; 036A:  B2
 or e                   ;; 036B:  B3
 or h                   ;; 036C:  B4
 or l                   ;; 036D:  B5
 or (hl)                ;; 036E:  B6
 or a                   ;; 036F:  B7
 cp b                   ;; 0370:  B8
 cp c                   ;; 0371:  B9
 cp d                   ;; 0372:  BA
 cp e                   ;; 0373:  BB
 cp h                   ;; 0374:  BC
 cp l                   ;; 0375:  BD
 cp (hl)                ;; 0376:  BE
 cp a                   ;; 0377:  BF
 add a, (ix+-128)       ;; 0378:  DD 86 80
 add a, (ix)            ;; 037B:  DD 86 00
 add a, (ix+127)        ;; 037E:  DD 86 7F
 adc a, (ix+-128)       ;; 0381:  DD 8E 80
 adc a, (ix)            ;; 0384:  DD 8E 00
 adc a, (ix+127)        ;; 0387:  DD 8E 7F
 sub a, (ix+-128)       ;; 038A:  DD 96 80
 sub a, (ix)            ;; 038D:  DD 96 00
 sub a, (ix+127)        ;; 0390:  DD 96 7F
 sbc a, (ix+-128)       ;; 0393:  DD 9E 80
 sbc a, (ix)            ;; 0396:  DD 9E 00
 sbc a, (ix+127)        ;; 0399:  DD 9E 7F
 and a, (ix+-128)       ;; 039C:  DD A6 80
 and a, (ix)            ;; 039F:  DD A6 00
 and a, (ix+127)        ;; 03A2:  DD A6 7F
 xor a, (ix+-128)       ;; 03A5:  DD AE 80
 xor a, (ix)            ;; 03A8:  DD AE 00
 xor a, (ix+127)        ;; 03AB:  DD AE 7F
 or a, (ix+-128)        ;; 03AE:  DD B6 80
 or a, (ix)             ;; 03B1:  DD B6 00
 or a, (ix+127)         ;; 03B4:  DD B6 7F
 cp a, (ix+-128)        ;; 03B7:  DD BE 80
 cp a, (ix)             ;; 03BA:  DD BE 00
 cp a, (ix+127)         ;; 03BD:  DD BE 7F
 add (ix+-128)          ;; 03C0:  DD 86 80
 add (ix)               ;; 03C3:  DD 86 00
 add (ix+127)           ;; 03C6:  DD 86 7F
 adc (ix+-128)          ;; 03C9:  DD 8E 80
 adc (ix)               ;; 03CC:  DD 8E 00
 adc (ix+127)           ;; 03CF:  DD 8E 7F
 sub (ix+-128)          ;; 03D2:  DD 96 80
 sub (ix)               ;; 03D5:  DD 96 00
 sub (ix+127)           ;; 03D8:  DD 96 7F
 sbc (ix+-128)          ;; 03DB:  DD 9E 80
 sbc (ix)               ;; 03DE:  DD 9E 00
 sbc (ix+127)           ;; 03E1:  DD 9E 7F
 and (ix+-128)          ;; 03E4:  DD A6 80
 and (ix)               ;; 03E7:  DD A6 00
 and (ix+127)           ;; 03EA:  DD A6 7F
 xor (ix+-128)          ;; 03ED:  DD AE 80
 xor (ix)               ;; 03F0:  DD AE 00
 xor (ix+127)           ;; 03F3:  DD AE 7F
 or (ix+-128)           ;; 03F6:  DD B6 80
 or (ix)                ;; 03F9:  DD B6 00
 or (ix+127)            ;; 03FC:  DD B6 7F
 cp (ix+-128)           ;; 03FF:  DD BE 80
 cp (ix)                ;; 0402:  DD BE 00
 cp (ix+127)            ;; 0405:  DD BE 7F
 add a, (iy+-128)       ;; 0408:  FD 86 80
 add a, (iy)            ;; 040B:  FD 86 00
 add a, (iy+127)        ;; 040E:  FD 86 7F
 adc a, (iy+-128)       ;; 0411:  FD 8E 80
 adc a, (iy)            ;; 0414:  FD 8E 00
 adc a, (iy+127)        ;; 0417:  FD 8E 7F
 sub a, (iy+-128)       ;; 041A:  FD 96 80
 sub a, (iy)            ;; 041D:  FD 96 00
 sub a, (iy+127)        ;; 0420:  FD 96 7F
 sbc a, (iy+-128)       ;; 0423:  FD 9E 80
 sbc a, (iy)            ;; 0426:  FD 9E 00
 sbc a, (iy+127)        ;; 0429:  FD 9E 7F
 and a, (iy+-128)       ;; 042C:  FD A6 80
 and a, (iy)            ;; 042F:  FD A6 00
 and a, (iy+127)        ;; 0432:  FD A6 7F
 xor a, (iy+-128)       ;; 0435:  FD AE 80
 xor a, (iy)            ;; 0438:  FD AE 00
 xor a, (iy+127)        ;; 043B:  FD AE 7F
 or a, (iy+-128)        ;; 043E:  FD B6 80
 or a, (iy)             ;; 0441:  FD B6 00
 or a, (iy+127)         ;; 0444:  FD B6 7F
 cp a, (iy+-128)        ;; 0447:  FD BE 80
 cp a, (iy)             ;; 044A:  FD BE 00
 cp a, (iy+127)         ;; 044D:  FD BE 7F
 add (iy+-128)          ;; 0450:  FD 86 80
 add (iy)               ;; 0453:  FD 86 00
 add (iy+127)           ;; 0456:  FD 86 7F
 adc (iy+-128)          ;; 0459:  FD 8E 80
 adc (iy)               ;; 045C:  FD 8E 00
 adc (iy+127)           ;; 045F:  FD 8E 7F
 sub (iy+-128)          ;; 0462:  FD 96 80
 sub (iy)               ;; 0465:  FD 96 00
 sub (iy+127)           ;; 0468:  FD 96 7F
 sbc (iy+-128)          ;; 046B:  FD 9E 80
 sbc (iy)               ;; 046E:  FD 9E 00
 sbc (iy+127)           ;; 0471:  FD 9E 7F
 and (iy+-128)          ;; 0474:  FD A6 80
 and (iy)               ;; 0477:  FD A6 00
 and (iy+127)           ;; 047A:  FD A6 7F
 xor (iy+-128)          ;; 047D:  FD AE 80
 xor (iy)               ;; 0480:  FD AE 00
 xor (iy+127)           ;; 0483:  FD AE 7F
 or (iy+-128)           ;; 0486:  FD B6 80
 or (iy)                ;; 0489:  FD B6 00
 or (iy+127)            ;; 048C:  FD B6 7F
 cp (iy+-128)           ;; 048F:  FD BE 80
 cp (iy)                ;; 0492:  FD BE 00
 cp (iy+127)            ;; 0495:  FD BE 7F
 add a, 0               ;; 0498:  C6 00
 add a, 85              ;; 049A:  C6 55
 add a, 170             ;; 049C:  C6 AA
 add a, 255             ;; 049E:  C6 FF
 adc a, 0               ;; 04A0:  CE 00
 adc a, 85              ;; 04A2:  CE 55
 adc a, 170             ;; 04A4:  CE AA
 adc a, 255             ;; 04A6:  CE FF
 sub a, 0               ;; 04A8:  D6 00
 sub a, 85              ;; 04AA:  D6 55
 sub a, 170             ;; 04AC:  D6 AA
 sub a, 255             ;; 04AE:  D6 FF
 sbc a, 0               ;; 04B0:  DE 00
 sbc a, 85              ;; 04B2:  DE 55
 sbc a, 170             ;; 04B4:  DE AA
 sbc a, 255             ;; 04B6:  DE FF
 and a, 0               ;; 04B8:  E6 00
 and a, 85              ;; 04BA:  E6 55
 and a, 170             ;; 04BC:  E6 AA
 and a, 255             ;; 04BE:  E6 FF
 xor a, 0               ;; 04C0:  EE 00
 xor a, 85              ;; 04C2:  EE 55
 xor a, 170             ;; 04C4:  EE AA
 xor a, 255             ;; 04C6:  EE FF
 or a, 0                ;; 04C8:  F6 00
 or a, 85               ;; 04CA:  F6 55
 or a, 170              ;; 04CC:  F6 AA
 or a, 255              ;; 04CE:  F6 FF
 cp a, 0                ;; 04D0:  FE 00
 cp a, 85               ;; 04D2:  FE 55
 cp a, 170              ;; 04D4:  FE AA
 cp a, 255              ;; 04D6:  FE FF
 add 0                  ;; 04D8:  C6 00
 add 85                 ;; 04DA:  C6 55
 add 170                ;; 04DC:  C6 AA
 add 255                ;; 04DE:  C6 FF
 adc 0                  ;; 04E0:  CE 00
 adc 85                 ;; 04E2:  CE 55
 adc 170                ;; 04E4:  CE AA
 adc 255                ;; 04E6:  CE FF
 sub 0                  ;; 04E8:  D6 00
 sub 85                 ;; 04EA:  D6 55
 sub 170                ;; 04EC:  D6 AA
 sub 255                ;; 04EE:  D6 FF
 sbc 0                  ;; 04F0:  DE 00
 sbc 85                 ;; 04F2:  DE 55
 sbc 170                ;; 04F4:  DE AA
 sbc 255                ;; 04F6:  DE FF
 and 0                  ;; 04F8:  E6 00
 and 85                 ;; 04FA:  E6 55
 and 170                ;; 04FC:  E6 AA
 and 255                ;; 04FE:  E6 FF
 xor 0                  ;; 0500:  EE 00
 xor 85                 ;; 0502:  EE 55
 xor 170                ;; 0504:  EE AA
 xor 255                ;; 0506:  EE FF
 or 0                   ;; 0508:  F6 00
 or 85                  ;; 050A:  F6 55
 or 170                 ;; 050C:  F6 AA
 or 255                 ;; 050E:  F6 FF
 cp 0                   ;; 0510:  FE 00
 cp 85                  ;; 0512:  FE 55
 cp 170                 ;; 0514:  FE AA
 cp 255                 ;; 0516:  FE FF
 add a', b              ;; 0518:  76 80
 add a', c              ;; 051A:  76 81
 add a', d              ;; 051C:  76 82
 add a', e              ;; 051E:  76 83
 add a', h              ;; 0520:  76 84
 add a', l              ;; 0522:  76 85
 add a', (hl)           ;; 0524:  76 86
 add a', a              ;; 0526:  76 87
 adc a', b              ;; 0528:  76 88
 adc a', c              ;; 052A:  76 89
 adc a', d              ;; 052C:  76 8A
 adc a', e              ;; 052E:  76 8B
 adc a', h              ;; 0530:  76 8C
 adc a', l              ;; 0532:  76 8D
 adc a', (hl)           ;; 0534:  76 8E
 adc a', a              ;; 0536:  76 8F
 sub a', b              ;; 0538:  76 90
 sub a', c              ;; 053A:  76 91
 sub a', d              ;; 053C:  76 92
 sub a', e              ;; 053E:  76 93
 sub a', h              ;; 0540:  76 94
 sub a', l              ;; 0542:  76 95
 sub a', (hl)           ;; 0544:  76 96
 sub a', a              ;; 0546:  76 97
 sbc a', b              ;; 0548:  76 98
 sbc a', c              ;; 054A:  76 99
 sbc a', d              ;; 054C:  76 9A
 sbc a', e              ;; 054E:  76 9B
 sbc a', h              ;; 0550:  76 9C
 sbc a', l              ;; 0552:  76 9D
 sbc a', (hl)           ;; 0554:  76 9E
 sbc a', a              ;; 0556:  76 9F
 and a', b              ;; 0558:  76 A0
 and a', c              ;; 055A:  76 A1
 and a', d              ;; 055C:  76 A2
 and a', e              ;; 055E:  76 A3
 and a', h              ;; 0560:  76 A4
 and a', l              ;; 0562:  76 A5
 and a', (hl)           ;; 0564:  76 A6
 and a', a              ;; 0566:  76 A7
 xor a', b              ;; 0568:  76 A8
 xor a', c              ;; 056A:  76 A9
 xor a', d              ;; 056C:  76 AA
 xor a', e              ;; 056E:  76 AB
 xor a', h              ;; 0570:  76 AC
 xor a', l              ;; 0572:  76 AD
 xor a', (hl)           ;; 0574:  76 AE
 xor a', a              ;; 0576:  76 AF
 or a', b               ;; 0578:  76 B0
 or a', c               ;; 057A:  76 B1
 or a', d               ;; 057C:  76 B2
 or a', e               ;; 057E:  76 B3
 or a', h               ;; 0580:  76 B4
 or a', l               ;; 0582:  76 B5
 or a', (hl)            ;; 0584:  76 B6
 or a', a               ;; 0586:  76 B7
 add a', (ix+-128)      ;; 0588:  76 DD 86 80
 add a', (ix)           ;; 058C:  76 DD 86 00
 add a', (ix+127)       ;; 0590:  76 DD 86 7F
 adc a', (ix+-128)      ;; 0594:  76 DD 8E 80
 adc a', (ix)           ;; 0598:  76 DD 8E 00
 adc a', (ix+127)       ;; 059C:  76 DD 8E 7F
 sub a', (ix+-128)      ;; 05A0:  76 DD 96 80
 sub a', (ix)           ;; 05A4:  76 DD 96 00
 sub a', (ix+127)       ;; 05A8:  76 DD 96 7F
 sbc a', (ix+-128)      ;; 05AC:  76 DD 9E 80
 sbc a', (ix)           ;; 05B0:  76 DD 9E 00
 sbc a', (ix+127)       ;; 05B4:  76 DD 9E 7F
 and a', (ix+-128)      ;; 05B8:  76 DD A6 80
 and a', (ix)           ;; 05BC:  76 DD A6 00
 and a', (ix+127)       ;; 05C0:  76 DD A6 7F
 xor a', (ix+-128)      ;; 05C4:  76 DD AE 80
 xor a', (ix)           ;; 05C8:  76 DD AE 00
 xor a', (ix+127)       ;; 05CC:  76 DD AE 7F
 or a', (ix+-128)       ;; 05D0:  76 DD B6 80
 or a', (ix)            ;; 05D4:  76 DD B6 00
 or a', (ix+127)        ;; 05D8:  76 DD B6 7F
 add a', 0              ;; 05DC:  76 C6 00
 add a', 85             ;; 05DF:  76 C6 55
 add a', 170            ;; 05E2:  76 C6 AA
 add a', 255            ;; 05E5:  76 C6 FF
 adc a', 0              ;; 05E8:  76 CE 00
 adc a', 85             ;; 05EB:  76 CE 55
 adc a', 170            ;; 05EE:  76 CE AA
 adc a', 255            ;; 05F1:  76 CE FF
 sub a', 0              ;; 05F4:  76 D6 00
 sub a', 85             ;; 05F7:  76 D6 55
 sub a', 170            ;; 05FA:  76 D6 AA
 sub a', 255            ;; 05FD:  76 D6 FF
 sbc a', 0              ;; 0600:  76 DE 00
 sbc a', 85             ;; 0603:  76 DE 55
 sbc a', 170            ;; 0606:  76 DE AA
 sbc a', 255            ;; 0609:  76 DE FF
 and a', 0              ;; 060C:  76 E6 00
 and a', 85             ;; 060F:  76 E6 55
 and a', 170            ;; 0612:  76 E6 AA
 and a', 255            ;; 0615:  76 E6 FF
 xor a', 0              ;; 0618:  76 EE 00
 xor a', 85             ;; 061B:  76 EE 55
 xor a', 170            ;; 061E:  76 EE AA
 xor a', 255            ;; 0621:  76 EE FF
 or a', 0               ;; 0624:  76 F6 00
 or a', 85              ;; 0627:  76 F6 55
 or a', 170             ;; 062A:  76 F6 AA
 or a', 255             ;; 062D:  76 F6 FF
 inc b                  ;; 0630:  04
 inc c                  ;; 0631:  0C
 inc d                  ;; 0632:  14
 inc e                  ;; 0633:  1C
 inc h                  ;; 0634:  24
 inc l                  ;; 0635:  2C
 inc a                  ;; 0636:  3C
 dec b                  ;; 0637:  05
 dec c                  ;; 0638:  0D
 dec d                  ;; 0639:  15
 dec e                  ;; 063A:  1D
 dec h                  ;; 063B:  25
 dec l                  ;; 063C:  2D
 dec a                  ;; 063D:  3D
 inc b'                 ;; 063E:  76 04
 inc c'                 ;; 0640:  76 0C
 inc d'                 ;; 0642:  76 14
 inc e'                 ;; 0644:  76 1C
 inc h'                 ;; 0646:  76 24
 inc l'                 ;; 0648:  76 2C
 inc a'                 ;; 064A:  76 3C
 dec b'                 ;; 064C:  76 05
 dec c'                 ;; 064E:  76 0D
 dec d'                 ;; 0650:  76 15
 dec e'                 ;; 0652:  76 1D
 dec h'                 ;; 0654:  76 25
 dec l'                 ;; 0656:  76 2D
 dec a'                 ;; 0658:  76 3D
 inc (hl)               ;; 065A:  34
 dec (hl)               ;; 065B:  35
 inc (ix + -128)        ;; 065C:  DD 34 80
 inc (ix)               ;; 065F:  DD 34 00
 inc (ix + 127)         ;; 0662:  DD 34 7F
 dec (ix + -128)        ;; 0665:  DD 35 80
 dec (ix)               ;; 0668:  DD 35 00
 dec (ix + 127)         ;; 066B:  DD 35 7F
 inc (iy + -128)        ;; 066E:  FD 34 80
 inc (iy)               ;; 0671:  FD 34 00
 inc (iy + 127)         ;; 0674:  FD 34 7F
 dec (iy + -128)        ;; 0677:  FD 35 80
 dec (iy)               ;; 067A:  FD 35 00
 dec (iy + 127)         ;; 067D:  FD 35 7F
 cpl                    ;; 0680:  2F
 cpl a                  ;; 0681:  2F
 cpl a'                 ;; 0682:  76 2F
 neg                    ;; 0684:  ED 44
 neg a                  ;; 0686:  ED 44
 neg a'                 ;; 0688:  76 ED 44
 ccf                    ;; 068B:  3F
 ccf'                   ;; 068C:  76 3F
 scf                    ;; 068E:  37
 scf'                   ;; 068F:  76 37
 ld bc, 0               ;; 0691:  01 00 00
 ld bc, 291             ;; 0694:  01 23 01
 ld bc, 17767           ;; 0697:  01 67 45
 ld bc, 35243           ;; 069A:  01 AB 89
 ld bc, 52719           ;; 069D:  01 EF CD
 ld bc, 65535           ;; 06A0:  01 FF FF
 ld de, 0               ;; 06A3:  11 00 00
 ld de, 291             ;; 06A6:  11 23 01
 ld de, 17767           ;; 06A9:  11 67 45
 ld de, 35243           ;; 06AC:  11 AB 89
 ld de, 52719           ;; 06AF:  11 EF CD
 ld de, 65535           ;; 06B2:  11 FF FF
 ld hl, 0               ;; 06B5:  21 00 00
 ld hl, 291             ;; 06B8:  21 23 01
 ld hl, 17767           ;; 06BB:  21 67 45
 ld hl, 35243           ;; 06BE:  21 AB 89
 ld hl, 52719           ;; 06C1:  21 EF CD
 ld hl, 65535           ;; 06C4:  21 FF FF
 ld sp, 0               ;; 06C7:  31 00 00
 ld sp, 291             ;; 06CA:  31 23 01
 ld sp, 17767           ;; 06CD:  31 67 45
 ld sp, 35243           ;; 06D0:  31 AB 89
 ld sp, 52719           ;; 06D3:  31 EF CD
 ld sp, 65535           ;; 06D6:  31 FF FF
 ld bc', 0              ;; 06D9:  76 01 00 00
 ld bc', 291            ;; 06DD:  76 01 23 01
 ld bc', 17767          ;; 06E1:  76 01 67 45
 ld bc', 35243          ;; 06E5:  76 01 AB 89
 ld bc', 52719          ;; 06E9:  76 01 EF CD
 ld bc', 65535          ;; 06ED:  76 01 FF FF
 ld de', 0              ;; 06F1:  76 11 00 00
 ld de', 291            ;; 06F5:  76 11 23 01
 ld de', 17767          ;; 06F9:  76 11 67 45
 ld de', 35243          ;; 06FD:  76 11 AB 89
 ld de', 52719          ;; 0701:  76 11 EF CD
 ld de', 65535          ;; 0705:  76 11 FF FF
 ld hl', 0              ;; 0709:  76 21 00 00
 ld hl', 291            ;; 070D:  76 21 23 01
 ld hl', 17767          ;; 0711:  76 21 67 45
 ld hl', 35243          ;; 0715:  76 21 AB 89
 ld hl', 52719          ;; 0719:  76 21 EF CD
 ld hl', 65535          ;; 071D:  76 21 FF FF
 ld ix, 0               ;; 0721:  DD 21 00 00
 ld ix, 291             ;; 0725:  DD 21 23 01
 ld ix, 17767           ;; 0729:  DD 21 67 45
 ld ix, 35243           ;; 072D:  DD 21 AB 89
 ld ix, 52719           ;; 0731:  DD 21 EF CD
 ld ix, 65535           ;; 0735:  DD 21 FF FF
 ld iy, 0               ;; 0739:  FD 21 00 00
 ld iy, 291             ;; 073D:  FD 21 23 01
 ld iy, 17767           ;; 0741:  FD 21 67 45
 ld iy, 35243           ;; 0745:  FD 21 AB 89
 ld iy, 52719           ;; 0749:  FD 21 EF CD
 ld iy, 65535           ;; 074D:  FD 21 FF FF
 ld hl, (0)             ;; 0751:  2A 00 00
 ld hl, (291)           ;; 0754:  2A 23 01
 ld hl, (17767)         ;; 0757:  2A 67 45
 ld hl, (35243)         ;; 075A:  2A AB 89
 ld hl, (52719)         ;; 075D:  2A EF CD
 ld hl, (65535)         ;; 0760:  2A FF FF
 ld hl', (0)            ;; 0763:  76 2A 00 00
 ld hl', (291)          ;; 0767:  76 2A 23 01
 ld hl', (17767)        ;; 076B:  76 2A 67 45
 ld hl', (35243)        ;; 076F:  76 2A AB 89
 ld hl', (52719)        ;; 0773:  76 2A EF CD
 ld hl', (65535)        ;; 0777:  76 2A FF FF
 ld ix, (0)             ;; 077B:  DD 2A 00 00
 ld ix, (291)           ;; 077F:  DD 2A 23 01
 ld ix, (17767)         ;; 0783:  DD 2A 67 45
 ld ix, (35243)         ;; 0787:  DD 2A AB 89
 ld ix, (52719)         ;; 078B:  DD 2A EF CD
 ld ix, (65535)         ;; 078F:  DD 2A FF FF
 ld iy, (0)             ;; 0793:  FD 2A 00 00
 ld iy, (291)           ;; 0797:  FD 2A 23 01
 ld iy, (17767)         ;; 079B:  FD 2A 67 45
 ld iy, (35243)         ;; 079F:  FD 2A AB 89
 ld iy, (52719)         ;; 07A3:  FD 2A EF CD
 ld iy, (65535)         ;; 07A7:  FD 2A FF FF
 ld (0), hl             ;; 07AB:  22 00 00
 ld (291), hl           ;; 07AE:  22 23 01
 ld (17767), hl         ;; 07B1:  22 67 45
 ld (35243), hl         ;; 07B4:  22 AB 89
 ld (52719), hl         ;; 07B7:  22 EF CD
 ld (65535), hl         ;; 07BA:  22 FF FF
 ld (0), ix             ;; 07BD:  DD 22 00 00
 ld (291), ix           ;; 07C1:  DD 22 23 01
 ld (17767), ix         ;; 07C5:  DD 22 67 45
 ld (35243), ix         ;; 07C9:  DD 22 AB 89
 ld (52719), ix         ;; 07CD:  DD 22 EF CD
 ld (65535), ix         ;; 07D1:  DD 22 FF FF
 ld (0), iy             ;; 07D5:  FD 22 00 00
 ld (291), iy           ;; 07D9:  FD 22 23 01
 ld (17767), iy         ;; 07DD:  FD 22 67 45
 ld (35243), iy         ;; 07E1:  FD 22 AB 89
 ld (52719), iy         ;; 07E5:  FD 22 EF CD
 ld (65535), iy         ;; 07E9:  FD 22 FF FF
 ld bc, (0)             ;; 07ED:  ED 4B 00 00
 ld bc, (291)           ;; 07F1:  ED 4B 23 01
 ld bc, (17767)         ;; 07F5:  ED 4B 67 45
 ld bc, (35243)         ;; 07F9:  ED 4B AB 89
 ld bc, (52719)         ;; 07FD:  ED 4B EF CD
 ld bc, (65535)         ;; 0801:  ED 4B FF FF
 ld de, (0)             ;; 0805:  ED 5B 00 00
 ld de, (291)           ;; 0809:  ED 5B 23 01
 ld de, (17767)         ;; 080D:  ED 5B 67 45
 ld de, (35243)         ;; 0811:  ED 5B AB 89
 ld de, (52719)         ;; 0815:  ED 5B EF CD
 ld de, (65535)         ;; 0819:  ED 5B FF FF
 ld sp, (0)             ;; 081D:  ED 7B 00 00
 ld sp, (291)           ;; 0821:  ED 7B 23 01
 ld sp, (17767)         ;; 0825:  ED 7B 67 45
 ld sp, (35243)         ;; 0829:  ED 7B AB 89
 ld sp, (52719)         ;; 082D:  ED 7B EF CD
 ld sp, (65535)         ;; 0831:  ED 7B FF FF
 ld bc', (0)            ;; 0835:  76 ED 4B 00 00
 ld bc', (291)          ;; 083A:  76 ED 4B 23 01
 ld bc', (17767)        ;; 083F:  76 ED 4B 67 45
 ld bc', (35243)        ;; 0844:  76 ED 4B AB 89
 ld bc', (52719)        ;; 0849:  76 ED 4B EF CD
 ld bc', (65535)        ;; 084E:  76 ED 4B FF FF
 ld de', (0)            ;; 0853:  76 ED 5B 00 00
 ld de', (291)          ;; 0858:  76 ED 5B 23 01
 ld de', (17767)        ;; 085D:  76 ED 5B 67 45
 ld de', (35243)        ;; 0862:  76 ED 5B AB 89
 ld de', (52719)        ;; 0867:  76 ED 5B EF CD
 ld de', (65535)        ;; 086C:  76 ED 5B FF FF
 ld (0), bc             ;; 0871:  ED 43 00 00
 ld (291), bc           ;; 0875:  ED 43 23 01
 ld (17767), bc         ;; 0879:  ED 43 67 45
 ld (35243), bc         ;; 087D:  ED 43 AB 89
 ld (52719), bc         ;; 0881:  ED 43 EF CD
 ld (65535), bc         ;; 0885:  ED 43 FF FF
 ld (0), de             ;; 0889:  ED 53 00 00
 ld (291), de           ;; 088D:  ED 53 23 01
 ld (17767), de         ;; 0891:  ED 53 67 45
 ld (35243), de         ;; 0895:  ED 53 AB 89
 ld (52719), de         ;; 0899:  ED 53 EF CD
 ld (65535), de         ;; 089D:  ED 53 FF FF
 ld (0), sp             ;; 08A1:  ED 73 00 00
 ld (291), sp           ;; 08A5:  ED 73 23 01
 ld (17767), sp         ;; 08A9:  ED 73 67 45
 ld (35243), sp         ;; 08AD:  ED 73 AB 89
 ld (52719), sp         ;; 08B1:  ED 73 EF CD
 ld (65535), sp         ;; 08B5:  ED 73 FF FF
 ld sp, hl              ;; 08B9:  F9
 ld sp, ix              ;; 08BA:  DD F9
 ld sp, iy              ;; 08BC:  FD F9
 push bc                ;; 08BE:  C5
 push de                ;; 08BF:  D5
 push hl                ;; 08C0:  E5
 push af                ;; 08C1:  F5
 push ix                ;; 08C2:  DD E5
 push iy                ;; 08C4:  FD E5
 push ip                ;; 08C6:  ED 76
 push su                ;; 08C8:  ED 66
 pop bc                 ;; 08CA:  C1
 pop de                 ;; 08CB:  D1
 pop hl                 ;; 08CC:  E1
 pop af                 ;; 08CD:  F1
 pop bc'                ;; 08CE:  76 C1
 pop de'                ;; 08D0:  76 D1
 pop hl'                ;; 08D2:  76 E1
 pop af'                ;; 08D4:  76 F1
 pop ix                 ;; 08D6:  DD E1
 pop iy                 ;; 08D8:  FD E1
 pop ip                 ;; 08DA:  ED 7E
 pop su                 ;; 08DC:  ED 6E
 ld hl, ix              ;; 08DE:  DD 7C
 ld hl', ix             ;; 08E0:  76 DD 7C
 ld hl, iy              ;; 08E3:  FD 7C
 ld hl', iy             ;; 08E5:  76 FD 7C
 ld ix, hl              ;; 08E8:  DD 7D
 ld iy, hl              ;; 08EA:  FD 7D
 ld hl, (hl + -128)     ;; 08EC:  DD E4 80
 ld hl, (hl)            ;; 08EF:  DD E4 00
 ld hl, (hl + 127)      ;; 08F2:  DD E4 7F
 ld hl', (hl + -128)    ;; 08F5:  76 DD E4 80
 ld hl', (hl)           ;; 08F9:  76 DD E4 00
 ld hl', (hl + 127)     ;; 08FD:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 0901:  E4 80
 ld hl, (ix)            ;; 0903:  E4 00
 ld hl, (ix + 127)      ;; 0905:  E4 7F
 ld hl', (ix + -128)    ;; 0907:  76 E4 80
 ld hl', (ix)           ;; 090A:  76 E4 00
 ld hl', (ix + 127)     ;; 090D:  76 E4 7F
 ld hl, (iy + -128)     ;; 0910:  FD E4 80
 ld hl, (iy)            ;; 0913:  FD E4 00
 ld hl, (iy + 127)      ;; 0916:  FD E4 7F
 ld hl', (iy + -128)    ;; 0919:  76 FD E4 80
 ld hl', (iy)           ;; 091D:  76 FD E4 00
 ld hl', (iy + 127)     ;; 0921:  76 FD E4 7F
 ld (hl + -128), hl     ;; 0925:  DD F4 80
 ld (hl), hl            ;; 0928:  DD F4 00
 ld (hl + 127), hl      ;; 092B:  DD F4 7F
 ld (ix + -128), hl     ;; 092E:  F4 80
 ld (ix), hl            ;; 0930:  F4 00
 ld (ix + 127), hl      ;; 0932:  F4 7F
 ld (iy + -128), hl     ;; 0934:  FD F4 80
 ld (iy), hl            ;; 0937:  FD F4 00
 ld (iy + 127), hl      ;; 093A:  FD F4 7F
 ldp (0), hl            ;; 093D:  ED 65 00 00
 ldp (291), hl          ;; 0941:  ED 65 23 01
 ldp (17767), hl        ;; 0945:  ED 65 67 45
 ldp (35243), hl        ;; 0949:  ED 65 AB 89
 ldp (52719), hl        ;; 094D:  ED 65 EF CD
 ldp (65535), hl        ;; 0951:  ED 65 FF FF
 ldp (0), ix            ;; 0955:  DD 65 00 00
 ldp (291), ix          ;; 0959:  DD 65 23 01
 ldp (17767), ix        ;; 095D:  DD 65 67 45
 ldp (35243), ix        ;; 0961:  DD 65 AB 89
 ldp (52719), ix        ;; 0965:  DD 65 EF CD
 ldp (65535), ix        ;; 0969:  DD 65 FF FF
 ldp (0), iy            ;; 096D:  FD 65 00 00
 ldp (291), iy          ;; 0971:  FD 65 23 01
 ldp (17767), iy        ;; 0975:  FD 65 67 45
 ldp (35243), iy        ;; 0979:  FD 65 AB 89
 ldp (52719), iy        ;; 097D:  FD 65 EF CD
 ldp (65535), iy        ;; 0981:  FD 65 FF FF
 ldp hl, (0)            ;; 0985:  ED 6D 00 00
 ldp hl, (291)          ;; 0989:  ED 6D 23 01
 ldp hl, (17767)        ;; 098D:  ED 6D 67 45
 ldp hl, (35243)        ;; 0991:  ED 6D AB 89
 ldp hl, (52719)        ;; 0995:  ED 6D EF CD
 ldp hl, (65535)        ;; 0999:  ED 6D FF FF
 ldp ix, (0)            ;; 099D:  DD 6D 00 00
 ldp ix, (291)          ;; 09A1:  DD 6D 23 01
 ldp ix, (17767)        ;; 09A5:  DD 6D 67 45
 ldp ix, (35243)        ;; 09A9:  DD 6D AB 89
 ldp ix, (52719)        ;; 09AD:  DD 6D EF CD
 ldp ix, (65535)        ;; 09B1:  DD 6D FF FF
 ldp iy, (0)            ;; 09B5:  FD 6D 00 00
 ldp iy, (291)          ;; 09B9:  FD 6D 23 01
 ldp iy, (17767)        ;; 09BD:  FD 6D 67 45
 ldp iy, (35243)        ;; 09C1:  FD 6D AB 89
 ldp iy, (52719)        ;; 09C5:  FD 6D EF CD
 ldp iy, (65535)        ;; 09C9:  FD 6D FF FF
 ldp (hl), hl           ;; 09CD:  ED 64
 ldp (ix), hl           ;; 09CF:  DD 64
 ldp (iy), hl           ;; 09D1:  FD 64
 ldp hl, (hl)           ;; 09D3:  ED 6C
 ldp hl, (ix)           ;; 09D5:  DD 6C
 ldp hl, (iy)           ;; 09D7:  FD 6C
 ld (sp), hl            ;; 09D9:  D4 00
 ld (sp + 85), hl       ;; 09DB:  D4 55
 ld (sp + 170), hl      ;; 09DD:  D4 AA
 ld (sp + 255), hl      ;; 09DF:  D4 FF
 ld (sp), ix            ;; 09E1:  DD D4 00
 ld (sp + 85), ix       ;; 09E4:  DD D4 55
 ld (sp + 170), ix      ;; 09E7:  DD D4 AA
 ld (sp + 255), ix      ;; 09EA:  DD D4 FF
 ld (sp), iy            ;; 09ED:  FD D4 00
 ld (sp + 85), iy       ;; 09F0:  FD D4 55
 ld (sp + 170), iy      ;; 09F3:  FD D4 AA
 ld (sp + 255), iy      ;; 09F6:  FD D4 FF
 ld hl, (sp)            ;; 09F9:  C4 00
 ld hl, (sp + 85)       ;; 09FB:  C4 55
 ld hl, (sp + 170)      ;; 09FD:  C4 AA
 ld hl, (sp + 255)      ;; 09FF:  C4 FF
 ld hl', (sp)           ;; 0A01:  76 C4 00
 ld hl', (sp + 85)      ;; 0A04:  76 C4 55
 ld hl', (sp + 170)     ;; 0A07:  76 C4 AA
 ld hl', (sp + 255)     ;; 0A0A:  76 C4 FF
 ld ix, (sp)            ;; 0A0D:  DD C4 00
 ld ix, (sp + 85)       ;; 0A10:  DD C4 55
 ld ix, (sp + 170)      ;; 0A13:  DD C4 AA
 ld ix, (sp + 255)      ;; 0A16:  DD C4 FF
 ld iy, (sp)            ;; 0A19:  FD C4 00
 ld iy, (sp + 85)       ;; 0A1C:  FD C4 55
 ld iy, (sp + 170)      ;; 0A1F:  FD C4 AA
 ld iy, (sp + 255)      ;; 0A22:  FD C4 FF
 ld bc', bc             ;; 0A25:  ED 49
 ld bc', de             ;; 0A27:  ED 41
 ld de', bc             ;; 0A29:  ED 59
 ld de', de             ;; 0A2B:  ED 51
 ld hl', bc             ;; 0A2D:  ED 69
 ld hl', de             ;; 0A2F:  ED 61
 add hl, bc             ;; 0A31:  09
 add hl, de             ;; 0A32:  19
 add hl, hl             ;; 0A33:  29
 add hl, sp             ;; 0A34:  39
 add hl', bc            ;; 0A35:  76 09
 add hl', de            ;; 0A37:  76 19
 add hl', hl            ;; 0A39:  76 29
 add hl', sp            ;; 0A3B:  76 39
 add ix, bc             ;; 0A3D:  DD 09
 add ix, de             ;; 0A3F:  DD 19
 add ix, ix             ;; 0A41:  DD 29
 add ix, sp             ;; 0A43:  DD 39
 add iy, bc             ;; 0A45:  FD 09
 add iy, de             ;; 0A47:  FD 19
 add iy, iy             ;; 0A49:  FD 29
 add iy, sp             ;; 0A4B:  FD 39
 sbc hl, bc             ;; 0A4D:  ED 42
 sbc hl, de             ;; 0A4F:  ED 52
 sbc hl, hl             ;; 0A51:  ED 62
 sbc hl, sp             ;; 0A53:  ED 72
 adc hl, bc             ;; 0A55:  ED 4A
 adc hl, de             ;; 0A57:  ED 5A
 adc hl, hl             ;; 0A59:  ED 6A
 adc hl, sp             ;; 0A5B:  ED 7A
 sbc hl', bc            ;; 0A5D:  76 ED 42
 sbc hl', de            ;; 0A60:  76 ED 52
 sbc hl', hl            ;; 0A63:  76 ED 62
 sbc hl', sp            ;; 0A66:  76 ED 72
 adc hl', bc            ;; 0A69:  76 ED 4A
 adc hl', de            ;; 0A6C:  76 ED 5A
 adc hl', hl            ;; 0A6F:  76 ED 6A
 adc hl', sp            ;; 0A72:  76 ED 7A
 inc bc                 ;; 0A75:  03
 inc de                 ;; 0A76:  13
 inc hl                 ;; 0A77:  23
 inc sp                 ;; 0A78:  33
 dec bc                 ;; 0A79:  0B
 dec de                 ;; 0A7A:  1B
 dec hl                 ;; 0A7B:  2B
 dec sp                 ;; 0A7C:  3B
 inc bc'                ;; 0A7D:  76 03
 inc de'                ;; 0A7F:  76 13
 inc hl'                ;; 0A81:  76 23
 dec bc'                ;; 0A83:  76 0B
 dec de'                ;; 0A85:  76 1B
 dec hl'                ;; 0A87:  76 2B
 inc ix                 ;; 0A89:  DD 23
 dec ix                 ;; 0A8B:  DD 2B
 inc iy                 ;; 0A8D:  FD 23
 dec iy                 ;; 0A8F:  FD 2B
 add sp, -128           ;; 0A91:  27 80
 add sp, 0              ;; 0A93:  27 00
 add sp, 127            ;; 0A95:  27 7F
 and hl, de             ;; 0A97:  DC
 or hl, de              ;; 0A98:  EC
 and hl', de            ;; 0A99:  76 DC
 or hl', de             ;; 0A9B:  76 EC
 and ix, de             ;; 0A9D:  DD DC
 or ix, de              ;; 0A9F:  DD EC
 and iy, de             ;; 0AA1:  FD DC
 or iy, de              ;; 0AA3:  FD EC
 bool hl                ;; 0AA5:  CC
 bool hl'               ;; 0AA6:  76 CC
 bool ix                ;; 0AA8:  DD CC
 bool iy                ;; 0AAA:  FD CC
 mul                    ;; 0AAC:  F7
 uma                    ;; 0AAD:  ED C0
 ums                    ;; 0AAF:  ED C8
 ex af, af              ;; 0AB1:  08
 ex af, af'             ;; 0AB2:  08
 exx                    ;; 0AB3:  D9
 ex (sp), hl            ;; 0AB4:  ED 54
 ex (sp), hl'           ;; 0AB6:  76 ED 54
 ex (sp), ix            ;; 0AB9:  DD E3
 ex (sp), iy            ;; 0ABB:  FD E3
 ex de, hl              ;; 0ABD:  EB
 ex de', hl             ;; 0ABE:  E3
 ex de, hl'             ;; 0ABF:  76 EB
 ex de', hl'            ;; 0AC1:  76 E3
 rlca                   ;; 0AC3:  07
 rrca                   ;; 0AC4:  0F
 rla                    ;; 0AC5:  17
 rra                    ;; 0AC6:  1F
 rlc b                  ;; 0AC7:  CB 00
 rlc c                  ;; 0AC9:  CB 01
 rlc d                  ;; 0ACB:  CB 02
 rlc e                  ;; 0ACD:  CB 03
 rlc h                  ;; 0ACF:  CB 04
 rlc l                  ;; 0AD1:  CB 05
 rlc (hl)               ;; 0AD3:  CB 06
 rlc a                  ;; 0AD5:  CB 07
 rrc b                  ;; 0AD7:  CB 08
 rrc c                  ;; 0AD9:  CB 09
 rrc d                  ;; 0ADB:  CB 0A
 rrc e                  ;; 0ADD:  CB 0B
 rrc h                  ;; 0ADF:  CB 0C
 rrc l                  ;; 0AE1:  CB 0D
 rrc (hl)               ;; 0AE3:  CB 0E
 rrc a                  ;; 0AE5:  CB 0F
 rl b                   ;; 0AE7:  CB 10
 rl c                   ;; 0AE9:  CB 11
 rl d                   ;; 0AEB:  CB 12
 rl e                   ;; 0AED:  CB 13
 rl h                   ;; 0AEF:  CB 14
 rl l                   ;; 0AF1:  CB 15
 rl (hl)                ;; 0AF3:  CB 16
 rl a                   ;; 0AF5:  CB 17
 rr b                   ;; 0AF7:  CB 18
 rr c                   ;; 0AF9:  CB 19
 rr d                   ;; 0AFB:  CB 1A
 rr e                   ;; 0AFD:  CB 1B
 rr h                   ;; 0AFF:  CB 1C
 rr l                   ;; 0B01:  CB 1D
 rr (hl)                ;; 0B03:  CB 1E
 rr a                   ;; 0B05:  CB 1F
 sla b                  ;; 0B07:  CB 20
 sla c                  ;; 0B09:  CB 21
 sla d                  ;; 0B0B:  CB 22
 sla e                  ;; 0B0D:  CB 23
 sla h                  ;; 0B0F:  CB 24
 sla l                  ;; 0B11:  CB 25
 sla (hl)               ;; 0B13:  CB 26
 sla a                  ;; 0B15:  CB 27
 sra b                  ;; 0B17:  CB 28
 sra c                  ;; 0B19:  CB 29
 sra d                  ;; 0B1B:  CB 2A
 sra e                  ;; 0B1D:  CB 2B
 sra h                  ;; 0B1F:  CB 2C
 sra l                  ;; 0B21:  CB 2D
 sra (hl)               ;; 0B23:  CB 2E
 sra a                  ;; 0B25:  CB 2F
 srl b                  ;; 0B27:  CB 38
 srl c                  ;; 0B29:  CB 39
 srl d                  ;; 0B2B:  CB 3A
 srl e                  ;; 0B2D:  CB 3B
 srl h                  ;; 0B2F:  CB 3C
 srl l                  ;; 0B31:  CB 3D
 srl (hl)               ;; 0B33:  CB 3E
 srl a                  ;; 0B35:  CB 3F
 rlc (ix+-128)          ;; 0B37:  DD CB 80 06
 rlc (ix)               ;; 0B3B:  DD CB 00 06
 rlc (ix+127)           ;; 0B3F:  DD CB 7F 06
 rrc (ix+-128)          ;; 0B43:  DD CB 80 0E
 rrc (ix)               ;; 0B47:  DD CB 00 0E
 rrc (ix+127)           ;; 0B4B:  DD CB 7F 0E
 rl (ix+-128)           ;; 0B4F:  DD CB 80 16
 rl (ix)                ;; 0B53:  DD CB 00 16
 rl (ix+127)            ;; 0B57:  DD CB 7F 16
 rr (ix+-128)           ;; 0B5B:  DD CB 80 1E
 rr (ix)                ;; 0B5F:  DD CB 00 1E
 rr (ix+127)            ;; 0B63:  DD CB 7F 1E
 sla (ix+-128)          ;; 0B67:  DD CB 80 26
 sla (ix)               ;; 0B6B:  DD CB 00 26
 sla (ix+127)           ;; 0B6F:  DD CB 7F 26
 sra (ix+-128)          ;; 0B73:  DD CB 80 2E
 sra (ix)               ;; 0B77:  DD CB 00 2E
 sra (ix+127)           ;; 0B7B:  DD CB 7F 2E
 srl (ix+-128)          ;; 0B7F:  DD CB 80 3E
 srl (ix)               ;; 0B83:  DD CB 00 3E
 srl (ix+127)           ;; 0B87:  DD CB 7F 3E
 rlc (iy+-128)          ;; 0B8B:  FD CB 80 06
 rlc (iy)               ;; 0B8F:  FD CB 00 06
 rlc (iy+127)           ;; 0B93:  FD CB 7F 06
 rrc (iy+-128)          ;; 0B97:  FD CB 80 0E
 rrc (iy)               ;; 0B9B:  FD CB 00 0E
 rrc (iy+127)           ;; 0B9F:  FD CB 7F 0E
 rl (iy+-128)           ;; 0BA3:  FD CB 80 16
 rl (iy)                ;; 0BA7:  FD CB 00 16
 rl (iy+127)            ;; 0BAB:  FD CB 7F 16
 rr (iy+-128)           ;; 0BAF:  FD CB 80 1E
 rr (iy)                ;; 0BB3:  FD CB 00 1E
 rr (iy+127)            ;; 0BB7:  FD CB 7F 1E
 sla (iy+-128)          ;; 0BBB:  FD CB 80 26
 sla (iy)               ;; 0BBF:  FD CB 00 26
 sla (iy+127)           ;; 0BC3:  FD CB 7F 26
 sra (iy+-128)          ;; 0BC7:  FD CB 80 2E
 sra (iy)               ;; 0BCB:  FD CB 00 2E
 sra (iy+127)           ;; 0BCF:  FD CB 7F 2E
 srl (iy+-128)          ;; 0BD3:  FD CB 80 3E
 srl (iy)               ;; 0BD7:  FD CB 00 3E
 srl (iy+127)           ;; 0BDB:  FD CB 7F 3E
 rl de                  ;; 0BDF:  F3
 rr de                  ;; 0BE0:  FB
 rr hl                  ;; 0BE1:  FC
 rl de'                 ;; 0BE2:  76 F3
 rr de'                 ;; 0BE4:  76 FB
 rr hl'                 ;; 0BE6:  76 FC
 rr ix                  ;; 0BE8:  DD FC
 rr iy                  ;; 0BEA:  FD FC
 bit 0, b               ;; 0BEC:  CB 40
 bit 0, c               ;; 0BEE:  CB 41
 bit 0, d               ;; 0BF0:  CB 42
 bit 0, e               ;; 0BF2:  CB 43
 bit 0, h               ;; 0BF4:  CB 44
 bit 0, l               ;; 0BF6:  CB 45
 bit 0, (hl)            ;; 0BF8:  CB 46
 bit 0, a               ;; 0BFA:  CB 47
 bit 1, b               ;; 0BFC:  CB 48
 bit 1, c               ;; 0BFE:  CB 49
 bit 1, d               ;; 0C00:  CB 4A
 bit 1, e               ;; 0C02:  CB 4B
 bit 1, h               ;; 0C04:  CB 4C
 bit 1, l               ;; 0C06:  CB 4D
 bit 1, (hl)            ;; 0C08:  CB 4E
 bit 1, a               ;; 0C0A:  CB 4F
 bit 2, b               ;; 0C0C:  CB 50
 bit 2, c               ;; 0C0E:  CB 51
 bit 2, d               ;; 0C10:  CB 52
 bit 2, e               ;; 0C12:  CB 53
 bit 2, h               ;; 0C14:  CB 54
 bit 2, l               ;; 0C16:  CB 55
 bit 2, (hl)            ;; 0C18:  CB 56
 bit 2, a               ;; 0C1A:  CB 57
 bit 3, b               ;; 0C1C:  CB 58
 bit 3, c               ;; 0C1E:  CB 59
 bit 3, d               ;; 0C20:  CB 5A
 bit 3, e               ;; 0C22:  CB 5B
 bit 3, h               ;; 0C24:  CB 5C
 bit 3, l               ;; 0C26:  CB 5D
 bit 3, (hl)            ;; 0C28:  CB 5E
 bit 3, a               ;; 0C2A:  CB 5F
 bit 4, b               ;; 0C2C:  CB 60
 bit 4, c               ;; 0C2E:  CB 61
 bit 4, d               ;; 0C30:  CB 62
 bit 4, e               ;; 0C32:  CB 63
 bit 4, h               ;; 0C34:  CB 64
 bit 4, l               ;; 0C36:  CB 65
 bit 4, (hl)            ;; 0C38:  CB 66
 bit 4, a               ;; 0C3A:  CB 67
 bit 5, b               ;; 0C3C:  CB 68
 bit 5, c               ;; 0C3E:  CB 69
 bit 5, d               ;; 0C40:  CB 6A
 bit 5, e               ;; 0C42:  CB 6B
 bit 5, h               ;; 0C44:  CB 6C
 bit 5, l               ;; 0C46:  CB 6D
 bit 5, (hl)            ;; 0C48:  CB 6E
 bit 5, a               ;; 0C4A:  CB 6F
 bit 6, b               ;; 0C4C:  CB 70
 bit 6, c               ;; 0C4E:  CB 71
 bit 6, d               ;; 0C50:  CB 72
 bit 6, e               ;; 0C52:  CB 73
 bit 6, h               ;; 0C54:  CB 74
 bit 6, l               ;; 0C56:  CB 75
 bit 6, (hl)            ;; 0C58:  CB 76
 bit 6, a               ;; 0C5A:  CB 77
 bit 7, b               ;; 0C5C:  CB 78
 bit 7, c               ;; 0C5E:  CB 79
 bit 7, d               ;; 0C60:  CB 7A
 bit 7, e               ;; 0C62:  CB 7B
 bit 7, h               ;; 0C64:  CB 7C
 bit 7, l               ;; 0C66:  CB 7D
 bit 7, (hl)            ;; 0C68:  CB 7E
 bit 7, a               ;; 0C6A:  CB 7F
 res 0, b               ;; 0C6C:  CB 80
 res 0, c               ;; 0C6E:  CB 81
 res 0, d               ;; 0C70:  CB 82
 res 0, e               ;; 0C72:  CB 83
 res 0, h               ;; 0C74:  CB 84
 res 0, l               ;; 0C76:  CB 85
 res 0, (hl)            ;; 0C78:  CB 86
 res 0, a               ;; 0C7A:  CB 87
 res 1, b               ;; 0C7C:  CB 88
 res 1, c               ;; 0C7E:  CB 89
 res 1, d               ;; 0C80:  CB 8A
 res 1, e               ;; 0C82:  CB 8B
 res 1, h               ;; 0C84:  CB 8C
 res 1, l               ;; 0C86:  CB 8D
 res 1, (hl)            ;; 0C88:  CB 8E
 res 1, a               ;; 0C8A:  CB 8F
 res 2, b               ;; 0C8C:  CB 90
 res 2, c               ;; 0C8E:  CB 91
 res 2, d               ;; 0C90:  CB 92
 res 2, e               ;; 0C92:  CB 93
 res 2, h               ;; 0C94:  CB 94
 res 2, l               ;; 0C96:  CB 95
 res 2, (hl)            ;; 0C98:  CB 96
 res 2, a               ;; 0C9A:  CB 97
 res 3, b               ;; 0C9C:  CB 98
 res 3, c               ;; 0C9E:  CB 99
 res 3, d               ;; 0CA0:  CB 9A
 res 3, e               ;; 0CA2:  CB 9B
 res 3, h               ;; 0CA4:  CB 9C
 res 3, l               ;; 0CA6:  CB 9D
 res 3, (hl)            ;; 0CA8:  CB 9E
 res 3, a               ;; 0CAA:  CB 9F
 res 4, b               ;; 0CAC:  CB A0
 res 4, c               ;; 0CAE:  CB A1
 res 4, d               ;; 0CB0:  CB A2
 res 4, e               ;; 0CB2:  CB A3
 res 4, h               ;; 0CB4:  CB A4
 res 4, l               ;; 0CB6:  CB A5
 res 4, (hl)            ;; 0CB8:  CB A6
 res 4, a               ;; 0CBA:  CB A7
 res 5, b               ;; 0CBC:  CB A8
 res 5, c               ;; 0CBE:  CB A9
 res 5, d               ;; 0CC0:  CB AA
 res 5, e               ;; 0CC2:  CB AB
 res 5, h               ;; 0CC4:  CB AC
 res 5, l               ;; 0CC6:  CB AD
 res 5, (hl)            ;; 0CC8:  CB AE
 res 5, a               ;; 0CCA:  CB AF
 res 6, b               ;; 0CCC:  CB B0
 res 6, c               ;; 0CCE:  CB B1
 res 6, d               ;; 0CD0:  CB B2
 res 6, e               ;; 0CD2:  CB B3
 res 6, h               ;; 0CD4:  CB B4
 res 6, l               ;; 0CD6:  CB B5
 res 6, (hl)            ;; 0CD8:  CB B6
 res 6, a               ;; 0CDA:  CB B7
 res 7, b               ;; 0CDC:  CB B8
 res 7, c               ;; 0CDE:  CB B9
 res 7, d               ;; 0CE0:  CB BA
 res 7, e               ;; 0CE2:  CB BB
 res 7, h               ;; 0CE4:  CB BC
 res 7, l               ;; 0CE6:  CB BD
 res 7, (hl)            ;; 0CE8:  CB BE
 res 7, a               ;; 0CEA:  CB BF
 set 0, b               ;; 0CEC:  CB C0
 set 0, c               ;; 0CEE:  CB C1
 set 0, d               ;; 0CF0:  CB C2
 set 0, e               ;; 0CF2:  CB C3
 set 0, h               ;; 0CF4:  CB C4
 set 0, l               ;; 0CF6:  CB C5
 set 0, (hl)            ;; 0CF8:  CB C6
 set 0, a               ;; 0CFA:  CB C7
 set 1, b               ;; 0CFC:  CB C8
 set 1, c               ;; 0CFE:  CB C9
 set 1, d               ;; 0D00:  CB CA
 set 1, e               ;; 0D02:  CB CB
 set 1, h               ;; 0D04:  CB CC
 set 1, l               ;; 0D06:  CB CD
 set 1, (hl)            ;; 0D08:  CB CE
 set 1, a               ;; 0D0A:  CB CF
 set 2, b               ;; 0D0C:  CB D0
 set 2, c               ;; 0D0E:  CB D1
 set 2, d               ;; 0D10:  CB D2
 set 2, e               ;; 0D12:  CB D3
 set 2, h               ;; 0D14:  CB D4
 set 2, l               ;; 0D16:  CB D5
 set 2, (hl)            ;; 0D18:  CB D6
 set 2, a               ;; 0D1A:  CB D7
 set 3, b               ;; 0D1C:  CB D8
 set 3, c               ;; 0D1E:  CB D9
 set 3, d               ;; 0D20:  CB DA
 set 3, e               ;; 0D22:  CB DB
 set 3, h               ;; 0D24:  CB DC
 set 3, l               ;; 0D26:  CB DD
 set 3, (hl)            ;; 0D28:  CB DE
 set 3, a               ;; 0D2A:  CB DF
 set 4, b               ;; 0D2C:  CB E0
 set 4, c               ;; 0D2E:  CB E1
 set 4, d               ;; 0D30:  CB E2
 set 4, e               ;; 0D32:  CB E3
 set 4, h               ;; 0D34:  CB E4
 set 4, l               ;; 0D36:  CB E5
 set 4, (hl)            ;; 0D38:  CB E6
 set 4, a               ;; 0D3A:  CB E7
 set 5, b               ;; 0D3C:  CB E8
 set 5, c               ;; 0D3E:  CB E9
 set 5, d               ;; 0D40:  CB EA
 set 5, e               ;; 0D42:  CB EB
 set 5, h               ;; 0D44:  CB EC
 set 5, l               ;; 0D46:  CB ED
 set 5, (hl)            ;; 0D48:  CB EE
 set 5, a               ;; 0D4A:  CB EF
 set 6, b               ;; 0D4C:  CB F0
 set 6, c               ;; 0D4E:  CB F1
 set 6, d               ;; 0D50:  CB F2
 set 6, e               ;; 0D52:  CB F3
 set 6, h               ;; 0D54:  CB F4
 set 6, l               ;; 0D56:  CB F5
 set 6, (hl)            ;; 0D58:  CB F6
 set 6, a               ;; 0D5A:  CB F7
 set 7, b               ;; 0D5C:  CB F8
 set 7, c               ;; 0D5E:  CB F9
 set 7, d               ;; 0D60:  CB FA
 set 7, e               ;; 0D62:  CB FB
 set 7, h               ;; 0D64:  CB FC
 set 7, l               ;; 0D66:  CB FD
 set 7, (hl)            ;; 0D68:  CB FE
 set 7, a               ;; 0D6A:  CB FF
 res 0, b'              ;; 0D6C:  76 CB 80
 res 0, c'              ;; 0D6F:  76 CB 81
 res 0, d'              ;; 0D72:  76 CB 82
 res 0, e'              ;; 0D75:  76 CB 83
 res 0, h'              ;; 0D78:  76 CB 84
 res 0, l'              ;; 0D7B:  76 CB 85
 res 0, a'              ;; 0D7E:  76 CB 87
 res 1, b'              ;; 0D81:  76 CB 88
 res 1, c'              ;; 0D84:  76 CB 89
 res 1, d'              ;; 0D87:  76 CB 8A
 res 1, e'              ;; 0D8A:  76 CB 8B
 res 1, h'              ;; 0D8D:  76 CB 8C
 res 1, l'              ;; 0D90:  76 CB 8D
 res 1, a'              ;; 0D93:  76 CB 8F
 res 2, b'              ;; 0D96:  76 CB 90
 res 2, c'              ;; 0D99:  76 CB 91
 res 2, d'              ;; 0D9C:  76 CB 92
 res 2, e'              ;; 0D9F:  76 CB 93
 res 2, h'              ;; 0DA2:  76 CB 94
 res 2, l'              ;; 0DA5:  76 CB 95
 res 2, a'              ;; 0DA8:  76 CB 97
 res 3, b'              ;; 0DAB:  76 CB 98
 res 3, c'              ;; 0DAE:  76 CB 99
 res 3, d'              ;; 0DB1:  76 CB 9A
 res 3, e'              ;; 0DB4:  76 CB 9B
 res 3, h'              ;; 0DB7:  76 CB 9C
 res 3, l'              ;; 0DBA:  76 CB 9D
 res 3, a'              ;; 0DBD:  76 CB 9F
 res 4, b'              ;; 0DC0:  76 CB A0
 res 4, c'              ;; 0DC3:  76 CB A1
 res 4, d'              ;; 0DC6:  76 CB A2
 res 4, e'              ;; 0DC9:  76 CB A3
 res 4, h'              ;; 0DCC:  76 CB A4
 res 4, l'              ;; 0DCF:  76 CB A5
 res 4, a'              ;; 0DD2:  76 CB A7
 res 5, b'              ;; 0DD5:  76 CB A8
 res 5, c'              ;; 0DD8:  76 CB A9
 res 5, d'              ;; 0DDB:  76 CB AA
 res 5, e'              ;; 0DDE:  76 CB AB
 res 5, h'              ;; 0DE1:  76 CB AC
 res 5, l'              ;; 0DE4:  76 CB AD
 res 5, a'              ;; 0DE7:  76 CB AF
 res 6, b'              ;; 0DEA:  76 CB B0
 res 6, c'              ;; 0DED:  76 CB B1
 res 6, d'              ;; 0DF0:  76 CB B2
 res 6, e'              ;; 0DF3:  76 CB B3
 res 6, h'              ;; 0DF6:  76 CB B4
 res 6, l'              ;; 0DF9:  76 CB B5
 res 6, a'              ;; 0DFC:  76 CB B7
 res 7, b'              ;; 0DFF:  76 CB B8
 res 7, c'              ;; 0E02:  76 CB B9
 res 7, d'              ;; 0E05:  76 CB BA
 res 7, e'              ;; 0E08:  76 CB BB
 res 7, h'              ;; 0E0B:  76 CB BC
 res 7, l'              ;; 0E0E:  76 CB BD
 res 7, a'              ;; 0E11:  76 CB BF
 set 0, b'              ;; 0E14:  76 CB C0
 set 0, c'              ;; 0E17:  76 CB C1
 set 0, d'              ;; 0E1A:  76 CB C2
 set 0, e'              ;; 0E1D:  76 CB C3
 set 0, h'              ;; 0E20:  76 CB C4
 set 0, l'              ;; 0E23:  76 CB C5
 set 0, a'              ;; 0E26:  76 CB C7
 set 1, b'              ;; 0E29:  76 CB C8
 set 1, c'              ;; 0E2C:  76 CB C9
 set 1, d'              ;; 0E2F:  76 CB CA
 set 1, e'              ;; 0E32:  76 CB CB
 set 1, h'              ;; 0E35:  76 CB CC
 set 1, l'              ;; 0E38:  76 CB CD
 set 1, a'              ;; 0E3B:  76 CB CF
 set 2, b'              ;; 0E3E:  76 CB D0
 set 2, c'              ;; 0E41:  76 CB D1
 set 2, d'              ;; 0E44:  76 CB D2
 set 2, e'              ;; 0E47:  76 CB D3
 set 2, h'              ;; 0E4A:  76 CB D4
 set 2, l'              ;; 0E4D:  76 CB D5
 set 2, a'              ;; 0E50:  76 CB D7
 set 3, b'              ;; 0E53:  76 CB D8
 set 3, c'              ;; 0E56:  76 CB D9
 set 3, d'              ;; 0E59:  76 CB DA
 set 3, e'              ;; 0E5C:  76 CB DB
 set 3, h'              ;; 0E5F:  76 CB DC
 set 3, l'              ;; 0E62:  76 CB DD
 set 3, a'              ;; 0E65:  76 CB DF
 set 4, b'              ;; 0E68:  76 CB E0
 set 4, c'              ;; 0E6B:  76 CB E1
 set 4, d'              ;; 0E6E:  76 CB E2
 set 4, e'              ;; 0E71:  76 CB E3
 set 4, h'              ;; 0E74:  76 CB E4
 set 4, l'              ;; 0E77:  76 CB E5
 set 4, a'              ;; 0E7A:  76 CB E7
 set 5, b'              ;; 0E7D:  76 CB E8
 set 5, c'              ;; 0E80:  76 CB E9
 set 5, d'              ;; 0E83:  76 CB EA
 set 5, e'              ;; 0E86:  76 CB EB
 set 5, h'              ;; 0E89:  76 CB EC
 set 5, l'              ;; 0E8C:  76 CB ED
 set 5, a'              ;; 0E8F:  76 CB EF
 set 6, b'              ;; 0E92:  76 CB F0
 set 6, c'              ;; 0E95:  76 CB F1
 set 6, d'              ;; 0E98:  76 CB F2
 set 6, e'              ;; 0E9B:  76 CB F3
 set 6, h'              ;; 0E9E:  76 CB F4
 set 6, l'              ;; 0EA1:  76 CB F5
 set 6, a'              ;; 0EA4:  76 CB F7
 set 7, b'              ;; 0EA7:  76 CB F8
 set 7, c'              ;; 0EAA:  76 CB F9
 set 7, d'              ;; 0EAD:  76 CB FA
 set 7, e'              ;; 0EB0:  76 CB FB
 set 7, h'              ;; 0EB3:  76 CB FC
 set 7, l'              ;; 0EB6:  76 CB FD
 set 7, a'              ;; 0EB9:  76 CB FF
 bit 0, (ix+-128)       ;; 0EBC:  DD CB 80 46
 bit 0, (ix)            ;; 0EC0:  DD CB 00 46
 bit 0, (ix+127)        ;; 0EC4:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0EC8:  DD CB 80 4E
 bit 1, (ix)            ;; 0ECC:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0ED0:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0ED4:  DD CB 80 56
 bit 2, (ix)            ;; 0ED8:  DD CB 00 56
 bit 2, (ix+127)        ;; 0EDC:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0EE0:  DD CB 80 5E
 bit 3, (ix)            ;; 0EE4:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0EE8:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0EEC:  DD CB 80 66
 bit 4, (ix)            ;; 0EF0:  DD CB 00 66
 bit 4, (ix+127)        ;; 0EF4:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0EF8:  DD CB 80 6E
 bit 5, (ix)            ;; 0EFC:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0F00:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0F04:  DD CB 80 76
 bit 6, (ix)            ;; 0F08:  DD CB 00 76
 bit 6, (ix+127)        ;; 0F0C:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0F10:  DD CB 80 7E
 bit 7, (ix)            ;; 0F14:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0F18:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0F1C:  DD CB 80 86
 res 0, (ix)            ;; 0F20:  DD CB 00 86
 res 0, (ix+127)        ;; 0F24:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0F28:  DD CB 80 8E
 res 1, (ix)            ;; 0F2C:  DD CB 00 8E
 res 1, (ix+127)        ;; 0F30:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0F34:  DD CB 80 96
 res 2, (ix)            ;; 0F38:  DD CB 00 96
 res 2, (ix+127)        ;; 0F3C:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0F40:  DD CB 80 9E
 res 3, (ix)            ;; 0F44:  DD CB 00 9E
 res 3, (ix+127)        ;; 0F48:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0F4C:  DD CB 80 A6
 res 4, (ix)            ;; 0F50:  DD CB 00 A6
 res 4, (ix+127)        ;; 0F54:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0F58:  DD CB 80 AE
 res 5, (ix)            ;; 0F5C:  DD CB 00 AE
 res 5, (ix+127)        ;; 0F60:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0F64:  DD CB 80 B6
 res 6, (ix)            ;; 0F68:  DD CB 00 B6
 res 6, (ix+127)        ;; 0F6C:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0F70:  DD CB 80 BE
 res 7, (ix)            ;; 0F74:  DD CB 00 BE
 res 7, (ix+127)        ;; 0F78:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0F7C:  DD CB 80 C6
 set 0, (ix)            ;; 0F80:  DD CB 00 C6
 set 0, (ix+127)        ;; 0F84:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0F88:  DD CB 80 CE
 set 1, (ix)            ;; 0F8C:  DD CB 00 CE
 set 1, (ix+127)        ;; 0F90:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0F94:  DD CB 80 D6
 set 2, (ix)            ;; 0F98:  DD CB 00 D6
 set 2, (ix+127)        ;; 0F9C:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0FA0:  DD CB 80 DE
 set 3, (ix)            ;; 0FA4:  DD CB 00 DE
 set 3, (ix+127)        ;; 0FA8:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0FAC:  DD CB 80 E6
 set 4, (ix)            ;; 0FB0:  DD CB 00 E6
 set 4, (ix+127)        ;; 0FB4:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0FB8:  DD CB 80 EE
 set 5, (ix)            ;; 0FBC:  DD CB 00 EE
 set 5, (ix+127)        ;; 0FC0:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0FC4:  DD CB 80 F6
 set 6, (ix)            ;; 0FC8:  DD CB 00 F6
 set 6, (ix+127)        ;; 0FCC:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0FD0:  DD CB 80 FE
 set 7, (ix)            ;; 0FD4:  DD CB 00 FE
 set 7, (ix+127)        ;; 0FD8:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0FDC:  FD CB 80 46
 bit 0, (iy)            ;; 0FE0:  FD CB 00 46
 bit 0, (iy+127)        ;; 0FE4:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0FE8:  FD CB 80 4E
 bit 1, (iy)            ;; 0FEC:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0FF0:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0FF4:  FD CB 80 56
 bit 2, (iy)            ;; 0FF8:  FD CB 00 56
 bit 2, (iy+127)        ;; 0FFC:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 1000:  FD CB 80 5E
 bit 3, (iy)            ;; 1004:  FD CB 00 5E
 bit 3, (iy+127)        ;; 1008:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 100C:  FD CB 80 66
 bit 4, (iy)            ;; 1010:  FD CB 00 66
 bit 4, (iy+127)        ;; 1014:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 1018:  FD CB 80 6E
 bit 5, (iy)            ;; 101C:  FD CB 00 6E
 bit 5, (iy+127)        ;; 1020:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 1024:  FD CB 80 76
 bit 6, (iy)            ;; 1028:  FD CB 00 76
 bit 6, (iy+127)        ;; 102C:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 1030:  FD CB 80 7E
 bit 7, (iy)            ;; 1034:  FD CB 00 7E
 bit 7, (iy+127)        ;; 1038:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 103C:  FD CB 80 86
 res 0, (iy)            ;; 1040:  FD CB 00 86
 res 0, (iy+127)        ;; 1044:  FD CB 7F 86
 res 1, (iy+-128)       ;; 1048:  FD CB 80 8E
 res 1, (iy)            ;; 104C:  FD CB 00 8E
 res 1, (iy+127)        ;; 1050:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 1054:  FD CB 80 96
 res 2, (iy)            ;; 1058:  FD CB 00 96
 res 2, (iy+127)        ;; 105C:  FD CB 7F 96
 res 3, (iy+-128)       ;; 1060:  FD CB 80 9E
 res 3, (iy)            ;; 1064:  FD CB 00 9E
 res 3, (iy+127)        ;; 1068:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 106C:  FD CB 80 A6
 res 4, (iy)            ;; 1070:  FD CB 00 A6
 res 4, (iy+127)        ;; 1074:  FD CB 7F A6
 res 5, (iy+-128)       ;; 1078:  FD CB 80 AE
 res 5, (iy)            ;; 107C:  FD CB 00 AE
 res 5, (iy+127)        ;; 1080:  FD CB 7F AE
 res 6, (iy+-128)       ;; 1084:  FD CB 80 B6
 res 6, (iy)            ;; 1088:  FD CB 00 B6
 res 6, (iy+127)        ;; 108C:  FD CB 7F B6
 res 7, (iy+-128)       ;; 1090:  FD CB 80 BE
 res 7, (iy)            ;; 1094:  FD CB 00 BE
 res 7, (iy+127)        ;; 1098:  FD CB 7F BE
 set 0, (iy+-128)       ;; 109C:  FD CB 80 C6
 set 0, (iy)            ;; 10A0:  FD CB 00 C6
 set 0, (iy+127)        ;; 10A4:  FD CB 7F C6
 set 1, (iy+-128)       ;; 10A8:  FD CB 80 CE
 set 1, (iy)            ;; 10AC:  FD CB 00 CE
 set 1, (iy+127)        ;; 10B0:  FD CB 7F CE
 set 2, (iy+-128)       ;; 10B4:  FD CB 80 D6
 set 2, (iy)            ;; 10B8:  FD CB 00 D6
 set 2, (iy+127)        ;; 10BC:  FD CB 7F D6
 set 3, (iy+-128)       ;; 10C0:  FD CB 80 DE
 set 3, (iy)            ;; 10C4:  FD CB 00 DE
 set 3, (iy+127)        ;; 10C8:  FD CB 7F DE
 set 4, (iy+-128)       ;; 10CC:  FD CB 80 E6
 set 4, (iy)            ;; 10D0:  FD CB 00 E6
 set 4, (iy+127)        ;; 10D4:  FD CB 7F E6
 set 5, (iy+-128)       ;; 10D8:  FD CB 80 EE
 set 5, (iy)            ;; 10DC:  FD CB 00 EE
 set 5, (iy+127)        ;; 10E0:  FD CB 7F EE
 set 6, (iy+-128)       ;; 10E4:  FD CB 80 F6
 set 6, (iy)            ;; 10E8:  FD CB 00 F6
 set 6, (iy+127)        ;; 10EC:  FD CB 7F F6
 set 7, (iy+-128)       ;; 10F0:  FD CB 80 FE
 set 7, (iy)            ;; 10F4:  FD CB 00 FE
 set 7, (iy+127)        ;; 10F8:  FD CB 7F FE
 ldi                    ;; 10FC:  ED A0
 ldir                   ;; 10FE:  ED B0
 ldd                    ;; 1100:  ED A8
 lddr                   ;; 1102:  ED B8
 ldisr                  ;; 1104:  ED 90
 lddsr                  ;; 1106:  ED 98
 lsdr                   ;; 1108:  ED F8
 lsir                   ;; 110A:  ED F0
 lsddr                  ;; 110C:  ED D8
 lsidr                  ;; 110E:  ED D0
 nop                    ;; 1110:  00
 ld a, xpc              ;; 1111:  ED 77
 ld a', xpc             ;; 1113:  76 ED 77
 ld xpc, a              ;; 1116:  ED 67
 rdmode                 ;; 1118:  ED 7F
 setusr                 ;; 111A:  ED 6F
 sures                  ;; 111C:  ED 7D
 syscall                ;; 111E:  ED 75
 jp 0                   ;; 1120:  C3 00 00
 jp 291                 ;; 1123:  C3 23 01
 jp 17767               ;; 1126:  C3 67 45
 jp 35243               ;; 1129:  C3 AB 89
 jp 52719               ;; 112C:  C3 EF CD
 jp 65535               ;; 112F:  C3 FF FF
 jp nz, 0               ;; 1132:  C2 00 00
 jp nz, 291             ;; 1135:  C2 23 01
 jp nz, 17767           ;; 1138:  C2 67 45
 jp nz, 35243           ;; 113B:  C2 AB 89
 jp nz, 52719           ;; 113E:  C2 EF CD
 jp nz, 65535           ;; 1141:  C2 FF FF
 jp z, 0                ;; 1144:  CA 00 00
 jp z, 291              ;; 1147:  CA 23 01
 jp z, 17767            ;; 114A:  CA 67 45
 jp z, 35243            ;; 114D:  CA AB 89
 jp z, 52719            ;; 1150:  CA EF CD
 jp z, 65535            ;; 1153:  CA FF FF
 jp nc, 0               ;; 1156:  D2 00 00
 jp nc, 291             ;; 1159:  D2 23 01
 jp nc, 17767           ;; 115C:  D2 67 45
 jp nc, 35243           ;; 115F:  D2 AB 89
 jp nc, 52719           ;; 1162:  D2 EF CD
 jp nc, 65535           ;; 1165:  D2 FF FF
 jp c, 0                ;; 1168:  DA 00 00
 jp c, 291              ;; 116B:  DA 23 01
 jp c, 17767            ;; 116E:  DA 67 45
 jp c, 35243            ;; 1171:  DA AB 89
 jp c, 52719            ;; 1174:  DA EF CD
 jp c, 65535            ;; 1177:  DA FF FF
 jp po, 0               ;; 117A:  E2 00 00
 jp po, 291             ;; 117D:  E2 23 01
 jp po, 17767           ;; 1180:  E2 67 45
 jp po, 35243           ;; 1183:  E2 AB 89
 jp po, 52719           ;; 1186:  E2 EF CD
 jp po, 65535           ;; 1189:  E2 FF FF
 jp pe, 0               ;; 118C:  EA 00 00
 jp pe, 291             ;; 118F:  EA 23 01
 jp pe, 17767           ;; 1192:  EA 67 45
 jp pe, 35243           ;; 1195:  EA AB 89
 jp pe, 52719           ;; 1198:  EA EF CD
 jp pe, 65535           ;; 119B:  EA FF FF
 jp p, 0                ;; 119E:  F2 00 00
 jp p, 291              ;; 11A1:  F2 23 01
 jp p, 17767            ;; 11A4:  F2 67 45
 jp p, 35243            ;; 11A7:  F2 AB 89
 jp p, 52719            ;; 11AA:  F2 EF CD
 jp p, 65535            ;; 11AD:  F2 FF FF
 jp m, 0                ;; 11B0:  FA 00 00
 jp m, 291              ;; 11B3:  FA 23 01
 jp m, 17767            ;; 11B6:  FA 67 45
 jp m, 35243            ;; 11B9:  FA AB 89
 jp m, 52719            ;; 11BC:  FA EF CD
 jp m, 65535            ;; 11BF:  FA FF FF
 jp lz, 0               ;; 11C2:  E2 00 00
 jp lz, 291             ;; 11C5:  E2 23 01
 jp lz, 17767           ;; 11C8:  E2 67 45
 jp lz, 35243           ;; 11CB:  E2 AB 89
 jp lz, 52719           ;; 11CE:  E2 EF CD
 jp lz, 65535           ;; 11D1:  E2 FF FF
 jp lo, 0               ;; 11D4:  EA 00 00
 jp lo, 291             ;; 11D7:  EA 23 01
 jp lo, 17767           ;; 11DA:  EA 67 45
 jp lo, 35243           ;; 11DD:  EA AB 89
 jp lo, 52719           ;; 11E0:  EA EF CD
 jp lo, 65535           ;; 11E3:  EA FF FF
 jp (hl)                ;; 11E6:  E9
 jp (ix)                ;; 11E7:  DD E9
 jp (iy)                ;; 11E9:  FD E9
 djnz ASMPC             ;; 11EB:  10 FE
 djnz b, ASMPC          ;; 11ED:  10 FE
 djnz b', ASMPC         ;; 11EF:  76 10 FE
 jr ASMPC               ;; 11F2:  18 FE
 jr nz, ASMPC           ;; 11F4:  20 FE
 jr z, ASMPC            ;; 11F6:  28 FE
 jr nc, ASMPC           ;; 11F8:  30 FE
 jr c, ASMPC            ;; 11FA:  38 FE
 call 0                 ;; 11FC:  CD 00 00
 call 291               ;; 11FF:  CD 23 01
 call 17767             ;; 1202:  CD 67 45
 call 35243             ;; 1205:  CD AB 89
 call 52719             ;; 1208:  CD EF CD
 call 65535             ;; 120B:  CD FF FF
 ret                    ;; 120E:  C9
 ret nz                 ;; 120F:  C0
 ret z                  ;; 1210:  C8
 ret nc                 ;; 1211:  D0
 ret c                  ;; 1212:  D8
 ret po                 ;; 1213:  E0
 ret pe                 ;; 1214:  E8
 ret p                  ;; 1215:  F0
 ret m                  ;; 1216:  F8
 ret lz                 ;; 1217:  E0
 ret lo                 ;; 1218:  E8
 rst 16                 ;; 1219:  D7
 rst 24                 ;; 121A:  DF
 rst 32                 ;; 121B:  E7
 rst 40                 ;; 121C:  EF
 rst 56                 ;; 121D:  FF
 ipset 0                ;; 121E:  ED 46
 ipset 1                ;; 1220:  ED 56
 ipset 2                ;; 1222:  ED 4E
 ipset 3                ;; 1224:  ED 5E
 ipres                  ;; 1226:  ED 5D
 ld iir, a              ;; 1228:  ED 4F
 ld a, iir              ;; 122A:  ED 5F
 ld a', iir             ;; 122C:  76 ED 5F
 ld eir, a              ;; 122F:  ED 47
 ld a, eir              ;; 1231:  ED 57
 ld a', eir             ;; 1233:  76 ED 57
 reti                   ;; 1236:  ED 4D
 idet                   ;; 1238:  5B
