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
 ld b, (hl)             ;; 0038:  46
 ld c, (hl)             ;; 0039:  4E
 ld d, (hl)             ;; 003A:  56
 ld e, (hl)             ;; 003B:  5E
 ld h, (hl)             ;; 003C:  66
 ld l, (hl)             ;; 003D:  6E
 ld a, (hl)             ;; 003E:  7E
 ld b, (ix + -128)      ;; 003F:  DD 46 80
 ld b, (ix)             ;; 0042:  DD 46 00
 ld b, (ix + 127)       ;; 0045:  DD 46 7F
 ld c, (ix + -128)      ;; 0048:  DD 4E 80
 ld c, (ix)             ;; 004B:  DD 4E 00
 ld c, (ix + 127)       ;; 004E:  DD 4E 7F
 ld d, (ix + -128)      ;; 0051:  DD 56 80
 ld d, (ix)             ;; 0054:  DD 56 00
 ld d, (ix + 127)       ;; 0057:  DD 56 7F
 ld e, (ix + -128)      ;; 005A:  DD 5E 80
 ld e, (ix)             ;; 005D:  DD 5E 00
 ld e, (ix + 127)       ;; 0060:  DD 5E 7F
 ld h, (ix + -128)      ;; 0063:  DD 66 80
 ld h, (ix)             ;; 0066:  DD 66 00
 ld h, (ix + 127)       ;; 0069:  DD 66 7F
 ld l, (ix + -128)      ;; 006C:  DD 6E 80
 ld l, (ix)             ;; 006F:  DD 6E 00
 ld l, (ix + 127)       ;; 0072:  DD 6E 7F
 ld a, (ix + -128)      ;; 0075:  DD 7E 80
 ld a, (ix)             ;; 0078:  DD 7E 00
 ld a, (ix + 127)       ;; 007B:  DD 7E 7F
 ld b, (iy + -128)      ;; 007E:  FD 46 80
 ld b, (iy)             ;; 0081:  FD 46 00
 ld b, (iy + 127)       ;; 0084:  FD 46 7F
 ld c, (iy + -128)      ;; 0087:  FD 4E 80
 ld c, (iy)             ;; 008A:  FD 4E 00
 ld c, (iy + 127)       ;; 008D:  FD 4E 7F
 ld d, (iy + -128)      ;; 0090:  FD 56 80
 ld d, (iy)             ;; 0093:  FD 56 00
 ld d, (iy + 127)       ;; 0096:  FD 56 7F
 ld e, (iy + -128)      ;; 0099:  FD 5E 80
 ld e, (iy)             ;; 009C:  FD 5E 00
 ld e, (iy + 127)       ;; 009F:  FD 5E 7F
 ld h, (iy + -128)      ;; 00A2:  FD 66 80
 ld h, (iy)             ;; 00A5:  FD 66 00
 ld h, (iy + 127)       ;; 00A8:  FD 66 7F
 ld l, (iy + -128)      ;; 00AB:  FD 6E 80
 ld l, (iy)             ;; 00AE:  FD 6E 00
 ld l, (iy + 127)       ;; 00B1:  FD 6E 7F
 ld a, (iy + -128)      ;; 00B4:  FD 7E 80
 ld a, (iy)             ;; 00B7:  FD 7E 00
 ld a, (iy + 127)       ;; 00BA:  FD 7E 7F
 ld (hl), b             ;; 00BD:  70
 ld (hl), c             ;; 00BE:  71
 ld (hl), d             ;; 00BF:  72
 ld (hl), e             ;; 00C0:  73
 ld (hl), h             ;; 00C1:  74
 ld (hl), l             ;; 00C2:  75
 ld (hl), a             ;; 00C3:  77
 ld (ix + -128), b      ;; 00C4:  DD 70 80
 ld (ix), b             ;; 00C7:  DD 70 00
 ld (ix + 127), b       ;; 00CA:  DD 70 7F
 ld (ix + -128), c      ;; 00CD:  DD 71 80
 ld (ix), c             ;; 00D0:  DD 71 00
 ld (ix + 127), c       ;; 00D3:  DD 71 7F
 ld (ix + -128), d      ;; 00D6:  DD 72 80
 ld (ix), d             ;; 00D9:  DD 72 00
 ld (ix + 127), d       ;; 00DC:  DD 72 7F
 ld (ix + -128), e      ;; 00DF:  DD 73 80
 ld (ix), e             ;; 00E2:  DD 73 00
 ld (ix + 127), e       ;; 00E5:  DD 73 7F
 ld (ix + -128), h      ;; 00E8:  DD 74 80
 ld (ix), h             ;; 00EB:  DD 74 00
 ld (ix + 127), h       ;; 00EE:  DD 74 7F
 ld (ix + -128), l      ;; 00F1:  DD 75 80
 ld (ix), l             ;; 00F4:  DD 75 00
 ld (ix + 127), l       ;; 00F7:  DD 75 7F
 ld (ix + -128), a      ;; 00FA:  DD 77 80
 ld (ix), a             ;; 00FD:  DD 77 00
 ld (ix + 127), a       ;; 0100:  DD 77 7F
 ld (iy + -128), b      ;; 0103:  FD 70 80
 ld (iy), b             ;; 0106:  FD 70 00
 ld (iy + 127), b       ;; 0109:  FD 70 7F
 ld (iy + -128), c      ;; 010C:  FD 71 80
 ld (iy), c             ;; 010F:  FD 71 00
 ld (iy + 127), c       ;; 0112:  FD 71 7F
 ld (iy + -128), d      ;; 0115:  FD 72 80
 ld (iy), d             ;; 0118:  FD 72 00
 ld (iy + 127), d       ;; 011B:  FD 72 7F
 ld (iy + -128), e      ;; 011E:  FD 73 80
 ld (iy), e             ;; 0121:  FD 73 00
 ld (iy + 127), e       ;; 0124:  FD 73 7F
 ld (iy + -128), h      ;; 0127:  FD 74 80
 ld (iy), h             ;; 012A:  FD 74 00
 ld (iy + 127), h       ;; 012D:  FD 74 7F
 ld (iy + -128), l      ;; 0130:  FD 75 80
 ld (iy), l             ;; 0133:  FD 75 00
 ld (iy + 127), l       ;; 0136:  FD 75 7F
 ld (iy + -128), a      ;; 0139:  FD 77 80
 ld (iy), a             ;; 013C:  FD 77 00
 ld (iy + 127), a       ;; 013F:  FD 77 7F
 ld (hl), 0             ;; 0142:  36 00
 ld (hl), 85            ;; 0144:  36 55
 ld (hl), 170           ;; 0146:  36 AA
 ld (hl), 255           ;; 0148:  36 FF
 ld (ix + -128), 0      ;; 014A:  DD 36 80 00
 ld (ix), 0             ;; 014E:  DD 36 00 00
 ld (ix + 127), 0       ;; 0152:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0156:  DD 36 80 55
 ld (ix), 85            ;; 015A:  DD 36 00 55
 ld (ix + 127), 85      ;; 015E:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0162:  DD 36 80 AA
 ld (ix), 170           ;; 0166:  DD 36 00 AA
 ld (ix + 127), 170     ;; 016A:  DD 36 7F AA
 ld (ix + -128), 255    ;; 016E:  DD 36 80 FF
 ld (ix), 255           ;; 0172:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0176:  DD 36 7F FF
 ld (iy + -128), 0      ;; 017A:  FD 36 80 00
 ld (iy), 0             ;; 017E:  FD 36 00 00
 ld (iy + 127), 0       ;; 0182:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0186:  FD 36 80 55
 ld (iy), 85            ;; 018A:  FD 36 00 55
 ld (iy + 127), 85      ;; 018E:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0192:  FD 36 80 AA
 ld (iy), 170           ;; 0196:  FD 36 00 AA
 ld (iy + 127), 170     ;; 019A:  FD 36 7F AA
 ld (iy + -128), 255    ;; 019E:  FD 36 80 FF
 ld (iy), 255           ;; 01A2:  FD 36 00 FF
 ld (iy + 127), 255     ;; 01A6:  FD 36 7F FF
 ld a, (bc)             ;; 01AA:  0A
 ld a, (de)             ;; 01AB:  1A
 ld (bc), a             ;; 01AC:  02
 ld (de), a             ;; 01AD:  12
 ld a, (0)              ;; 01AE:  3A 00 00
 ld a, (291)            ;; 01B1:  3A 23 01
 ld a, (17767)          ;; 01B4:  3A 67 45
 ld a, (35243)          ;; 01B7:  3A AB 89
 ld a, (52719)          ;; 01BA:  3A EF CD
 ld a, (65535)          ;; 01BD:  3A FF FF
 ld (0), a              ;; 01C0:  32 00 00
 ld (291), a            ;; 01C3:  32 23 01
 ld (17767), a          ;; 01C6:  32 67 45
 ld (35243), a          ;; 01C9:  32 AB 89
 ld (52719), a          ;; 01CC:  32 EF CD
 ld (65535), a          ;; 01CF:  32 FF FF
 add a, b               ;; 01D2:  80
 add a, c               ;; 01D3:  81
 add a, d               ;; 01D4:  82
 add a, e               ;; 01D5:  83
 add a, h               ;; 01D6:  84
 add a, l               ;; 01D7:  85
 add a, (hl)            ;; 01D8:  86
 add a, a               ;; 01D9:  87
 adc a, b               ;; 01DA:  88
 adc a, c               ;; 01DB:  89
 adc a, d               ;; 01DC:  8A
 adc a, e               ;; 01DD:  8B
 adc a, h               ;; 01DE:  8C
 adc a, l               ;; 01DF:  8D
 adc a, (hl)            ;; 01E0:  8E
 adc a, a               ;; 01E1:  8F
 sub a, b               ;; 01E2:  90
 sub a, c               ;; 01E3:  91
 sub a, d               ;; 01E4:  92
 sub a, e               ;; 01E5:  93
 sub a, h               ;; 01E6:  94
 sub a, l               ;; 01E7:  95
 sub a, (hl)            ;; 01E8:  96
 sub a, a               ;; 01E9:  97
 sbc a, b               ;; 01EA:  98
 sbc a, c               ;; 01EB:  99
 sbc a, d               ;; 01EC:  9A
 sbc a, e               ;; 01ED:  9B
 sbc a, h               ;; 01EE:  9C
 sbc a, l               ;; 01EF:  9D
 sbc a, (hl)            ;; 01F0:  9E
 sbc a, a               ;; 01F1:  9F
 and a, b               ;; 01F2:  A0
 and a, c               ;; 01F3:  A1
 and a, d               ;; 01F4:  A2
 and a, e               ;; 01F5:  A3
 and a, h               ;; 01F6:  A4
 and a, l               ;; 01F7:  A5
 and a, (hl)            ;; 01F8:  A6
 and a, a               ;; 01F9:  A7
 xor a, b               ;; 01FA:  A8
 xor a, c               ;; 01FB:  A9
 xor a, d               ;; 01FC:  AA
 xor a, e               ;; 01FD:  AB
 xor a, h               ;; 01FE:  AC
 xor a, l               ;; 01FF:  AD
 xor a, (hl)            ;; 0200:  AE
 xor a, a               ;; 0201:  AF
 or a, b                ;; 0202:  B0
 or a, c                ;; 0203:  B1
 or a, d                ;; 0204:  B2
 or a, e                ;; 0205:  B3
 or a, h                ;; 0206:  B4
 or a, l                ;; 0207:  B5
 or a, (hl)             ;; 0208:  B6
 or a, a                ;; 0209:  B7
 cp a, b                ;; 020A:  B8
 cp a, c                ;; 020B:  B9
 cp a, d                ;; 020C:  BA
 cp a, e                ;; 020D:  BB
 cp a, h                ;; 020E:  BC
 cp a, l                ;; 020F:  BD
 cp a, (hl)             ;; 0210:  BE
 cp a, a                ;; 0211:  BF
 add b                  ;; 0212:  80
 add c                  ;; 0213:  81
 add d                  ;; 0214:  82
 add e                  ;; 0215:  83
 add h                  ;; 0216:  84
 add l                  ;; 0217:  85
 add (hl)               ;; 0218:  86
 add a                  ;; 0219:  87
 adc b                  ;; 021A:  88
 adc c                  ;; 021B:  89
 adc d                  ;; 021C:  8A
 adc e                  ;; 021D:  8B
 adc h                  ;; 021E:  8C
 adc l                  ;; 021F:  8D
 adc (hl)               ;; 0220:  8E
 adc a                  ;; 0221:  8F
 sub b                  ;; 0222:  90
 sub c                  ;; 0223:  91
 sub d                  ;; 0224:  92
 sub e                  ;; 0225:  93
 sub h                  ;; 0226:  94
 sub l                  ;; 0227:  95
 sub (hl)               ;; 0228:  96
 sub a                  ;; 0229:  97
 sbc b                  ;; 022A:  98
 sbc c                  ;; 022B:  99
 sbc d                  ;; 022C:  9A
 sbc e                  ;; 022D:  9B
 sbc h                  ;; 022E:  9C
 sbc l                  ;; 022F:  9D
 sbc (hl)               ;; 0230:  9E
 sbc a                  ;; 0231:  9F
 and b                  ;; 0232:  A0
 and c                  ;; 0233:  A1
 and d                  ;; 0234:  A2
 and e                  ;; 0235:  A3
 and h                  ;; 0236:  A4
 and l                  ;; 0237:  A5
 and (hl)               ;; 0238:  A6
 and a                  ;; 0239:  A7
 xor b                  ;; 023A:  A8
 xor c                  ;; 023B:  A9
 xor d                  ;; 023C:  AA
 xor e                  ;; 023D:  AB
 xor h                  ;; 023E:  AC
 xor l                  ;; 023F:  AD
 xor (hl)               ;; 0240:  AE
 xor a                  ;; 0241:  AF
 or b                   ;; 0242:  B0
 or c                   ;; 0243:  B1
 or d                   ;; 0244:  B2
 or e                   ;; 0245:  B3
 or h                   ;; 0246:  B4
 or l                   ;; 0247:  B5
 or (hl)                ;; 0248:  B6
 or a                   ;; 0249:  B7
 cp b                   ;; 024A:  B8
 cp c                   ;; 024B:  B9
 cp d                   ;; 024C:  BA
 cp e                   ;; 024D:  BB
 cp h                   ;; 024E:  BC
 cp l                   ;; 024F:  BD
 cp (hl)                ;; 0250:  BE
 cp a                   ;; 0251:  BF
 add a, (ix+-128)       ;; 0252:  DD 86 80
 add a, (ix)            ;; 0255:  DD 86 00
 add a, (ix+127)        ;; 0258:  DD 86 7F
 adc a, (ix+-128)       ;; 025B:  DD 8E 80
 adc a, (ix)            ;; 025E:  DD 8E 00
 adc a, (ix+127)        ;; 0261:  DD 8E 7F
 sub a, (ix+-128)       ;; 0264:  DD 96 80
 sub a, (ix)            ;; 0267:  DD 96 00
 sub a, (ix+127)        ;; 026A:  DD 96 7F
 sbc a, (ix+-128)       ;; 026D:  DD 9E 80
 sbc a, (ix)            ;; 0270:  DD 9E 00
 sbc a, (ix+127)        ;; 0273:  DD 9E 7F
 and a, (ix+-128)       ;; 0276:  DD A6 80
 and a, (ix)            ;; 0279:  DD A6 00
 and a, (ix+127)        ;; 027C:  DD A6 7F
 xor a, (ix+-128)       ;; 027F:  DD AE 80
 xor a, (ix)            ;; 0282:  DD AE 00
 xor a, (ix+127)        ;; 0285:  DD AE 7F
 or a, (ix+-128)        ;; 0288:  DD B6 80
 or a, (ix)             ;; 028B:  DD B6 00
 or a, (ix+127)         ;; 028E:  DD B6 7F
 cp a, (ix+-128)        ;; 0291:  DD BE 80
 cp a, (ix)             ;; 0294:  DD BE 00
 cp a, (ix+127)         ;; 0297:  DD BE 7F
 add (ix+-128)          ;; 029A:  DD 86 80
 add (ix)               ;; 029D:  DD 86 00
 add (ix+127)           ;; 02A0:  DD 86 7F
 adc (ix+-128)          ;; 02A3:  DD 8E 80
 adc (ix)               ;; 02A6:  DD 8E 00
 adc (ix+127)           ;; 02A9:  DD 8E 7F
 sub (ix+-128)          ;; 02AC:  DD 96 80
 sub (ix)               ;; 02AF:  DD 96 00
 sub (ix+127)           ;; 02B2:  DD 96 7F
 sbc (ix+-128)          ;; 02B5:  DD 9E 80
 sbc (ix)               ;; 02B8:  DD 9E 00
 sbc (ix+127)           ;; 02BB:  DD 9E 7F
 and (ix+-128)          ;; 02BE:  DD A6 80
 and (ix)               ;; 02C1:  DD A6 00
 and (ix+127)           ;; 02C4:  DD A6 7F
 xor (ix+-128)          ;; 02C7:  DD AE 80
 xor (ix)               ;; 02CA:  DD AE 00
 xor (ix+127)           ;; 02CD:  DD AE 7F
 or (ix+-128)           ;; 02D0:  DD B6 80
 or (ix)                ;; 02D3:  DD B6 00
 or (ix+127)            ;; 02D6:  DD B6 7F
 cp (ix+-128)           ;; 02D9:  DD BE 80
 cp (ix)                ;; 02DC:  DD BE 00
 cp (ix+127)            ;; 02DF:  DD BE 7F
 add a, (iy+-128)       ;; 02E2:  FD 86 80
 add a, (iy)            ;; 02E5:  FD 86 00
 add a, (iy+127)        ;; 02E8:  FD 86 7F
 adc a, (iy+-128)       ;; 02EB:  FD 8E 80
 adc a, (iy)            ;; 02EE:  FD 8E 00
 adc a, (iy+127)        ;; 02F1:  FD 8E 7F
 sub a, (iy+-128)       ;; 02F4:  FD 96 80
 sub a, (iy)            ;; 02F7:  FD 96 00
 sub a, (iy+127)        ;; 02FA:  FD 96 7F
 sbc a, (iy+-128)       ;; 02FD:  FD 9E 80
 sbc a, (iy)            ;; 0300:  FD 9E 00
 sbc a, (iy+127)        ;; 0303:  FD 9E 7F
 and a, (iy+-128)       ;; 0306:  FD A6 80
 and a, (iy)            ;; 0309:  FD A6 00
 and a, (iy+127)        ;; 030C:  FD A6 7F
 xor a, (iy+-128)       ;; 030F:  FD AE 80
 xor a, (iy)            ;; 0312:  FD AE 00
 xor a, (iy+127)        ;; 0315:  FD AE 7F
 or a, (iy+-128)        ;; 0318:  FD B6 80
 or a, (iy)             ;; 031B:  FD B6 00
 or a, (iy+127)         ;; 031E:  FD B6 7F
 cp a, (iy+-128)        ;; 0321:  FD BE 80
 cp a, (iy)             ;; 0324:  FD BE 00
 cp a, (iy+127)         ;; 0327:  FD BE 7F
 add (iy+-128)          ;; 032A:  FD 86 80
 add (iy)               ;; 032D:  FD 86 00
 add (iy+127)           ;; 0330:  FD 86 7F
 adc (iy+-128)          ;; 0333:  FD 8E 80
 adc (iy)               ;; 0336:  FD 8E 00
 adc (iy+127)           ;; 0339:  FD 8E 7F
 sub (iy+-128)          ;; 033C:  FD 96 80
 sub (iy)               ;; 033F:  FD 96 00
 sub (iy+127)           ;; 0342:  FD 96 7F
 sbc (iy+-128)          ;; 0345:  FD 9E 80
 sbc (iy)               ;; 0348:  FD 9E 00
 sbc (iy+127)           ;; 034B:  FD 9E 7F
 and (iy+-128)          ;; 034E:  FD A6 80
 and (iy)               ;; 0351:  FD A6 00
 and (iy+127)           ;; 0354:  FD A6 7F
 xor (iy+-128)          ;; 0357:  FD AE 80
 xor (iy)               ;; 035A:  FD AE 00
 xor (iy+127)           ;; 035D:  FD AE 7F
 or (iy+-128)           ;; 0360:  FD B6 80
 or (iy)                ;; 0363:  FD B6 00
 or (iy+127)            ;; 0366:  FD B6 7F
 cp (iy+-128)           ;; 0369:  FD BE 80
 cp (iy)                ;; 036C:  FD BE 00
 cp (iy+127)            ;; 036F:  FD BE 7F
 add a, 0               ;; 0372:  C6 00
 add a, 85              ;; 0374:  C6 55
 add a, 170             ;; 0376:  C6 AA
 add a, 255             ;; 0378:  C6 FF
 adc a, 0               ;; 037A:  CE 00
 adc a, 85              ;; 037C:  CE 55
 adc a, 170             ;; 037E:  CE AA
 adc a, 255             ;; 0380:  CE FF
 sub a, 0               ;; 0382:  D6 00
 sub a, 85              ;; 0384:  D6 55
 sub a, 170             ;; 0386:  D6 AA
 sub a, 255             ;; 0388:  D6 FF
 sbc a, 0               ;; 038A:  DE 00
 sbc a, 85              ;; 038C:  DE 55
 sbc a, 170             ;; 038E:  DE AA
 sbc a, 255             ;; 0390:  DE FF
 and a, 0               ;; 0392:  E6 00
 and a, 85              ;; 0394:  E6 55
 and a, 170             ;; 0396:  E6 AA
 and a, 255             ;; 0398:  E6 FF
 xor a, 0               ;; 039A:  EE 00
 xor a, 85              ;; 039C:  EE 55
 xor a, 170             ;; 039E:  EE AA
 xor a, 255             ;; 03A0:  EE FF
 or a, 0                ;; 03A2:  F6 00
 or a, 85               ;; 03A4:  F6 55
 or a, 170              ;; 03A6:  F6 AA
 or a, 255              ;; 03A8:  F6 FF
 cp a, 0                ;; 03AA:  FE 00
 cp a, 85               ;; 03AC:  FE 55
 cp a, 170              ;; 03AE:  FE AA
 cp a, 255              ;; 03B0:  FE FF
 add 0                  ;; 03B2:  C6 00
 add 85                 ;; 03B4:  C6 55
 add 170                ;; 03B6:  C6 AA
 add 255                ;; 03B8:  C6 FF
 adc 0                  ;; 03BA:  CE 00
 adc 85                 ;; 03BC:  CE 55
 adc 170                ;; 03BE:  CE AA
 adc 255                ;; 03C0:  CE FF
 sub 0                  ;; 03C2:  D6 00
 sub 85                 ;; 03C4:  D6 55
 sub 170                ;; 03C6:  D6 AA
 sub 255                ;; 03C8:  D6 FF
 sbc 0                  ;; 03CA:  DE 00
 sbc 85                 ;; 03CC:  DE 55
 sbc 170                ;; 03CE:  DE AA
 sbc 255                ;; 03D0:  DE FF
 and 0                  ;; 03D2:  E6 00
 and 85                 ;; 03D4:  E6 55
 and 170                ;; 03D6:  E6 AA
 and 255                ;; 03D8:  E6 FF
 xor 0                  ;; 03DA:  EE 00
 xor 85                 ;; 03DC:  EE 55
 xor 170                ;; 03DE:  EE AA
 xor 255                ;; 03E0:  EE FF
 or 0                   ;; 03E2:  F6 00
 or 85                  ;; 03E4:  F6 55
 or 170                 ;; 03E6:  F6 AA
 or 255                 ;; 03E8:  F6 FF
 cp 0                   ;; 03EA:  FE 00
 cp 85                  ;; 03EC:  FE 55
 cp 170                 ;; 03EE:  FE AA
 cp 255                 ;; 03F0:  FE FF
 inc b                  ;; 03F2:  04
 inc c                  ;; 03F3:  0C
 inc d                  ;; 03F4:  14
 inc e                  ;; 03F5:  1C
 inc h                  ;; 03F6:  24
 inc l                  ;; 03F7:  2C
 inc a                  ;; 03F8:  3C
 dec b                  ;; 03F9:  05
 dec c                  ;; 03FA:  0D
 dec d                  ;; 03FB:  15
 dec e                  ;; 03FC:  1D
 dec h                  ;; 03FD:  25
 dec l                  ;; 03FE:  2D
 dec a                  ;; 03FF:  3D
 inc (hl)               ;; 0400:  34
 dec (hl)               ;; 0401:  35
 inc (ix + -128)        ;; 0402:  DD 34 80
 inc (ix)               ;; 0405:  DD 34 00
 inc (ix + 127)         ;; 0408:  DD 34 7F
 dec (ix + -128)        ;; 040B:  DD 35 80
 dec (ix)               ;; 040E:  DD 35 00
 dec (ix + 127)         ;; 0411:  DD 35 7F
 inc (iy + -128)        ;; 0414:  FD 34 80
 inc (iy)               ;; 0417:  FD 34 00
 inc (iy + 127)         ;; 041A:  FD 34 7F
 dec (iy + -128)        ;; 041D:  FD 35 80
 dec (iy)               ;; 0420:  FD 35 00
 dec (iy + 127)         ;; 0423:  FD 35 7F
 tst a, b               ;; 0426:  ED 04
 tst a, c               ;; 0428:  ED 0C
 tst a, d               ;; 042A:  ED 14
 tst a, e               ;; 042C:  ED 1C
 tst a, h               ;; 042E:  ED 24
 tst a, l               ;; 0430:  ED 2C
 tst a, a               ;; 0432:  ED 3C
 tst b                  ;; 0434:  ED 04
 tst c                  ;; 0436:  ED 0C
 tst d                  ;; 0438:  ED 14
 tst e                  ;; 043A:  ED 1C
 tst h                  ;; 043C:  ED 24
 tst l                  ;; 043E:  ED 2C
 tst a                  ;; 0440:  ED 3C
 tst a, 0               ;; 0442:  ED 64 00
 tst a, 85              ;; 0445:  ED 64 55
 tst a, 170             ;; 0448:  ED 64 AA
 tst a, 255             ;; 044B:  ED 64 FF
 tst 0                  ;; 044E:  ED 64 00
 tst 85                 ;; 0451:  ED 64 55
 tst 170                ;; 0454:  ED 64 AA
 tst 255                ;; 0457:  ED 64 FF
 tst a, (hl)            ;; 045A:  ED 34
 tst (hl)               ;; 045C:  ED 34
 daa                    ;; 045E:  27
 rld                    ;; 045F:  ED 6F
 rrd                    ;; 0461:  ED 67
 cpl                    ;; 0463:  2F
 cpl a                  ;; 0464:  2F
 neg                    ;; 0465:  ED 44
 neg a                  ;; 0467:  ED 44
 ccf                    ;; 0469:  3F
 ccf f                  ;; 046A:  3F
 scf                    ;; 046B:  37
 scf f                  ;; 046C:  37
 ld bc, 0               ;; 046D:  01 00 00
 ld bc, 291             ;; 0470:  01 23 01
 ld bc, 17767           ;; 0473:  01 67 45
 ld bc, 35243           ;; 0476:  01 AB 89
 ld bc, 52719           ;; 0479:  01 EF CD
 ld bc, 65535           ;; 047C:  01 FF FF
 ld de, 0               ;; 047F:  11 00 00
 ld de, 291             ;; 0482:  11 23 01
 ld de, 17767           ;; 0485:  11 67 45
 ld de, 35243           ;; 0488:  11 AB 89
 ld de, 52719           ;; 048B:  11 EF CD
 ld de, 65535           ;; 048E:  11 FF FF
 ld hl, 0               ;; 0491:  21 00 00
 ld hl, 291             ;; 0494:  21 23 01
 ld hl, 17767           ;; 0497:  21 67 45
 ld hl, 35243           ;; 049A:  21 AB 89
 ld hl, 52719           ;; 049D:  21 EF CD
 ld hl, 65535           ;; 04A0:  21 FF FF
 ld sp, 0               ;; 04A3:  31 00 00
 ld sp, 291             ;; 04A6:  31 23 01
 ld sp, 17767           ;; 04A9:  31 67 45
 ld sp, 35243           ;; 04AC:  31 AB 89
 ld sp, 52719           ;; 04AF:  31 EF CD
 ld sp, 65535           ;; 04B2:  31 FF FF
 ld ix, 0               ;; 04B5:  DD 21 00 00
 ld ix, 291             ;; 04B9:  DD 21 23 01
 ld ix, 17767           ;; 04BD:  DD 21 67 45
 ld ix, 35243           ;; 04C1:  DD 21 AB 89
 ld ix, 52719           ;; 04C5:  DD 21 EF CD
 ld ix, 65535           ;; 04C9:  DD 21 FF FF
 ld iy, 0               ;; 04CD:  FD 21 00 00
 ld iy, 291             ;; 04D1:  FD 21 23 01
 ld iy, 17767           ;; 04D5:  FD 21 67 45
 ld iy, 35243           ;; 04D9:  FD 21 AB 89
 ld iy, 52719           ;; 04DD:  FD 21 EF CD
 ld iy, 65535           ;; 04E1:  FD 21 FF FF
 ld hl, (0)             ;; 04E5:  2A 00 00
 ld hl, (291)           ;; 04E8:  2A 23 01
 ld hl, (17767)         ;; 04EB:  2A 67 45
 ld hl, (35243)         ;; 04EE:  2A AB 89
 ld hl, (52719)         ;; 04F1:  2A EF CD
 ld hl, (65535)         ;; 04F4:  2A FF FF
 ld ix, (0)             ;; 04F7:  DD 2A 00 00
 ld ix, (291)           ;; 04FB:  DD 2A 23 01
 ld ix, (17767)         ;; 04FF:  DD 2A 67 45
 ld ix, (35243)         ;; 0503:  DD 2A AB 89
 ld ix, (52719)         ;; 0507:  DD 2A EF CD
 ld ix, (65535)         ;; 050B:  DD 2A FF FF
 ld iy, (0)             ;; 050F:  FD 2A 00 00
 ld iy, (291)           ;; 0513:  FD 2A 23 01
 ld iy, (17767)         ;; 0517:  FD 2A 67 45
 ld iy, (35243)         ;; 051B:  FD 2A AB 89
 ld iy, (52719)         ;; 051F:  FD 2A EF CD
 ld iy, (65535)         ;; 0523:  FD 2A FF FF
 ld (0), hl             ;; 0527:  22 00 00
 ld (291), hl           ;; 052A:  22 23 01
 ld (17767), hl         ;; 052D:  22 67 45
 ld (35243), hl         ;; 0530:  22 AB 89
 ld (52719), hl         ;; 0533:  22 EF CD
 ld (65535), hl         ;; 0536:  22 FF FF
 ld (0), ix             ;; 0539:  DD 22 00 00
 ld (291), ix           ;; 053D:  DD 22 23 01
 ld (17767), ix         ;; 0541:  DD 22 67 45
 ld (35243), ix         ;; 0545:  DD 22 AB 89
 ld (52719), ix         ;; 0549:  DD 22 EF CD
 ld (65535), ix         ;; 054D:  DD 22 FF FF
 ld (0), iy             ;; 0551:  FD 22 00 00
 ld (291), iy           ;; 0555:  FD 22 23 01
 ld (17767), iy         ;; 0559:  FD 22 67 45
 ld (35243), iy         ;; 055D:  FD 22 AB 89
 ld (52719), iy         ;; 0561:  FD 22 EF CD
 ld (65535), iy         ;; 0565:  FD 22 FF FF
 ld bc, (0)             ;; 0569:  ED 4B 00 00
 ld bc, (291)           ;; 056D:  ED 4B 23 01
 ld bc, (17767)         ;; 0571:  ED 4B 67 45
 ld bc, (35243)         ;; 0575:  ED 4B AB 89
 ld bc, (52719)         ;; 0579:  ED 4B EF CD
 ld bc, (65535)         ;; 057D:  ED 4B FF FF
 ld de, (0)             ;; 0581:  ED 5B 00 00
 ld de, (291)           ;; 0585:  ED 5B 23 01
 ld de, (17767)         ;; 0589:  ED 5B 67 45
 ld de, (35243)         ;; 058D:  ED 5B AB 89
 ld de, (52719)         ;; 0591:  ED 5B EF CD
 ld de, (65535)         ;; 0595:  ED 5B FF FF
 ld sp, (0)             ;; 0599:  ED 7B 00 00
 ld sp, (291)           ;; 059D:  ED 7B 23 01
 ld sp, (17767)         ;; 05A1:  ED 7B 67 45
 ld sp, (35243)         ;; 05A5:  ED 7B AB 89
 ld sp, (52719)         ;; 05A9:  ED 7B EF CD
 ld sp, (65535)         ;; 05AD:  ED 7B FF FF
 ld (0), bc             ;; 05B1:  ED 43 00 00
 ld (291), bc           ;; 05B5:  ED 43 23 01
 ld (17767), bc         ;; 05B9:  ED 43 67 45
 ld (35243), bc         ;; 05BD:  ED 43 AB 89
 ld (52719), bc         ;; 05C1:  ED 43 EF CD
 ld (65535), bc         ;; 05C5:  ED 43 FF FF
 ld (0), de             ;; 05C9:  ED 53 00 00
 ld (291), de           ;; 05CD:  ED 53 23 01
 ld (17767), de         ;; 05D1:  ED 53 67 45
 ld (35243), de         ;; 05D5:  ED 53 AB 89
 ld (52719), de         ;; 05D9:  ED 53 EF CD
 ld (65535), de         ;; 05DD:  ED 53 FF FF
 ld (0), sp             ;; 05E1:  ED 73 00 00
 ld (291), sp           ;; 05E5:  ED 73 23 01
 ld (17767), sp         ;; 05E9:  ED 73 67 45
 ld (35243), sp         ;; 05ED:  ED 73 AB 89
 ld (52719), sp         ;; 05F1:  ED 73 EF CD
 ld (65535), sp         ;; 05F5:  ED 73 FF FF
 ld sp, hl              ;; 05F9:  F9
 ld sp, ix              ;; 05FA:  DD F9
 ld sp, iy              ;; 05FC:  FD F9
 push bc                ;; 05FE:  C5
 push de                ;; 05FF:  D5
 push hl                ;; 0600:  E5
 push af                ;; 0601:  F5
 push ix                ;; 0602:  DD E5
 push iy                ;; 0604:  FD E5
 pop bc                 ;; 0606:  C1
 pop de                 ;; 0607:  D1
 pop hl                 ;; 0608:  E1
 pop af                 ;; 0609:  F1
 pop ix                 ;; 060A:  DD E1
 pop iy                 ;; 060C:  FD E1
 add hl, bc             ;; 060E:  09
 add hl, de             ;; 060F:  19
 add hl, hl             ;; 0610:  29
 add hl, sp             ;; 0611:  39
 add ix, bc             ;; 0612:  DD 09
 add ix, de             ;; 0614:  DD 19
 add ix, ix             ;; 0616:  DD 29
 add ix, sp             ;; 0618:  DD 39
 add iy, bc             ;; 061A:  FD 09
 add iy, de             ;; 061C:  FD 19
 add iy, iy             ;; 061E:  FD 29
 add iy, sp             ;; 0620:  FD 39
 sbc hl, bc             ;; 0622:  ED 42
 sbc hl, de             ;; 0624:  ED 52
 sbc hl, hl             ;; 0626:  ED 62
 sbc hl, sp             ;; 0628:  ED 72
 adc hl, bc             ;; 062A:  ED 4A
 adc hl, de             ;; 062C:  ED 5A
 adc hl, hl             ;; 062E:  ED 6A
 adc hl, sp             ;; 0630:  ED 7A
 inc bc                 ;; 0632:  03
 inc de                 ;; 0633:  13
 inc hl                 ;; 0634:  23
 inc sp                 ;; 0635:  33
 dec bc                 ;; 0636:  0B
 dec de                 ;; 0637:  1B
 dec hl                 ;; 0638:  2B
 dec sp                 ;; 0639:  3B
 inc ix                 ;; 063A:  DD 23
 dec ix                 ;; 063C:  DD 2B
 inc iy                 ;; 063E:  FD 23
 dec iy                 ;; 0640:  FD 2B
 mlt bc                 ;; 0642:  ED 4C
 mlt de                 ;; 0644:  ED 5C
 mlt hl                 ;; 0646:  ED 6C
 mlt sp                 ;; 0648:  ED 7C
 ex af, af              ;; 064A:  08
 ex af, af'             ;; 064B:  08
 exx                    ;; 064C:  D9
 ex (sp), hl            ;; 064D:  E3
 ex (sp), ix            ;; 064E:  DD E3
 ex (sp), iy            ;; 0650:  FD E3
 ex de, hl              ;; 0652:  EB
 rlca                   ;; 0653:  07
 rrca                   ;; 0654:  0F
 rla                    ;; 0655:  17
 rra                    ;; 0656:  1F
 rlc b                  ;; 0657:  CB 00
 rlc c                  ;; 0659:  CB 01
 rlc d                  ;; 065B:  CB 02
 rlc e                  ;; 065D:  CB 03
 rlc h                  ;; 065F:  CB 04
 rlc l                  ;; 0661:  CB 05
 rlc (hl)               ;; 0663:  CB 06
 rlc a                  ;; 0665:  CB 07
 rrc b                  ;; 0667:  CB 08
 rrc c                  ;; 0669:  CB 09
 rrc d                  ;; 066B:  CB 0A
 rrc e                  ;; 066D:  CB 0B
 rrc h                  ;; 066F:  CB 0C
 rrc l                  ;; 0671:  CB 0D
 rrc (hl)               ;; 0673:  CB 0E
 rrc a                  ;; 0675:  CB 0F
 rl b                   ;; 0677:  CB 10
 rl c                   ;; 0679:  CB 11
 rl d                   ;; 067B:  CB 12
 rl e                   ;; 067D:  CB 13
 rl h                   ;; 067F:  CB 14
 rl l                   ;; 0681:  CB 15
 rl (hl)                ;; 0683:  CB 16
 rl a                   ;; 0685:  CB 17
 rr b                   ;; 0687:  CB 18
 rr c                   ;; 0689:  CB 19
 rr d                   ;; 068B:  CB 1A
 rr e                   ;; 068D:  CB 1B
 rr h                   ;; 068F:  CB 1C
 rr l                   ;; 0691:  CB 1D
 rr (hl)                ;; 0693:  CB 1E
 rr a                   ;; 0695:  CB 1F
 sla b                  ;; 0697:  CB 20
 sla c                  ;; 0699:  CB 21
 sla d                  ;; 069B:  CB 22
 sla e                  ;; 069D:  CB 23
 sla h                  ;; 069F:  CB 24
 sla l                  ;; 06A1:  CB 25
 sla (hl)               ;; 06A3:  CB 26
 sla a                  ;; 06A5:  CB 27
 sra b                  ;; 06A7:  CB 28
 sra c                  ;; 06A9:  CB 29
 sra d                  ;; 06AB:  CB 2A
 sra e                  ;; 06AD:  CB 2B
 sra h                  ;; 06AF:  CB 2C
 sra l                  ;; 06B1:  CB 2D
 sra (hl)               ;; 06B3:  CB 2E
 sra a                  ;; 06B5:  CB 2F
 srl b                  ;; 06B7:  CB 38
 srl c                  ;; 06B9:  CB 39
 srl d                  ;; 06BB:  CB 3A
 srl e                  ;; 06BD:  CB 3B
 srl h                  ;; 06BF:  CB 3C
 srl l                  ;; 06C1:  CB 3D
 srl (hl)               ;; 06C3:  CB 3E
 srl a                  ;; 06C5:  CB 3F
 sll b                  ;; 06C7:  CB 30
 sll c                  ;; 06C9:  CB 31
 sll d                  ;; 06CB:  CB 32
 sll e                  ;; 06CD:  CB 33
 sll h                  ;; 06CF:  CB 34
 sll l                  ;; 06D1:  CB 35
 sll (hl)               ;; 06D3:  CB 36
 sll a                  ;; 06D5:  CB 37
 rlc (ix+-128)          ;; 06D7:  DD CB 80 06
 rlc (ix)               ;; 06DB:  DD CB 00 06
 rlc (ix+127)           ;; 06DF:  DD CB 7F 06
 rrc (ix+-128)          ;; 06E3:  DD CB 80 0E
 rrc (ix)               ;; 06E7:  DD CB 00 0E
 rrc (ix+127)           ;; 06EB:  DD CB 7F 0E
 rl (ix+-128)           ;; 06EF:  DD CB 80 16
 rl (ix)                ;; 06F3:  DD CB 00 16
 rl (ix+127)            ;; 06F7:  DD CB 7F 16
 rr (ix+-128)           ;; 06FB:  DD CB 80 1E
 rr (ix)                ;; 06FF:  DD CB 00 1E
 rr (ix+127)            ;; 0703:  DD CB 7F 1E
 sla (ix+-128)          ;; 0707:  DD CB 80 26
 sla (ix)               ;; 070B:  DD CB 00 26
 sla (ix+127)           ;; 070F:  DD CB 7F 26
 sra (ix+-128)          ;; 0713:  DD CB 80 2E
 sra (ix)               ;; 0717:  DD CB 00 2E
 sra (ix+127)           ;; 071B:  DD CB 7F 2E
 srl (ix+-128)          ;; 071F:  DD CB 80 3E
 srl (ix)               ;; 0723:  DD CB 00 3E
 srl (ix+127)           ;; 0727:  DD CB 7F 3E
 sll (ix+-128)          ;; 072B:  DD CB 80 36
 sll (ix)               ;; 072F:  DD CB 00 36
 sll (ix+127)           ;; 0733:  DD CB 7F 36
 rlc (iy+-128)          ;; 0737:  FD CB 80 06
 rlc (iy)               ;; 073B:  FD CB 00 06
 rlc (iy+127)           ;; 073F:  FD CB 7F 06
 rrc (iy+-128)          ;; 0743:  FD CB 80 0E
 rrc (iy)               ;; 0747:  FD CB 00 0E
 rrc (iy+127)           ;; 074B:  FD CB 7F 0E
 rl (iy+-128)           ;; 074F:  FD CB 80 16
 rl (iy)                ;; 0753:  FD CB 00 16
 rl (iy+127)            ;; 0757:  FD CB 7F 16
 rr (iy+-128)           ;; 075B:  FD CB 80 1E
 rr (iy)                ;; 075F:  FD CB 00 1E
 rr (iy+127)            ;; 0763:  FD CB 7F 1E
 sla (iy+-128)          ;; 0767:  FD CB 80 26
 sla (iy)               ;; 076B:  FD CB 00 26
 sla (iy+127)           ;; 076F:  FD CB 7F 26
 sra (iy+-128)          ;; 0773:  FD CB 80 2E
 sra (iy)               ;; 0777:  FD CB 00 2E
 sra (iy+127)           ;; 077B:  FD CB 7F 2E
 srl (iy+-128)          ;; 077F:  FD CB 80 3E
 srl (iy)               ;; 0783:  FD CB 00 3E
 srl (iy+127)           ;; 0787:  FD CB 7F 3E
 sll (iy+-128)          ;; 078B:  FD CB 80 36
 sll (iy)               ;; 078F:  FD CB 00 36
 sll (iy+127)           ;; 0793:  FD CB 7F 36
 bit 0, b               ;; 0797:  CB 40
 bit 0, c               ;; 0799:  CB 41
 bit 0, d               ;; 079B:  CB 42
 bit 0, e               ;; 079D:  CB 43
 bit 0, h               ;; 079F:  CB 44
 bit 0, l               ;; 07A1:  CB 45
 bit 0, (hl)            ;; 07A3:  CB 46
 bit 0, a               ;; 07A5:  CB 47
 bit 1, b               ;; 07A7:  CB 48
 bit 1, c               ;; 07A9:  CB 49
 bit 1, d               ;; 07AB:  CB 4A
 bit 1, e               ;; 07AD:  CB 4B
 bit 1, h               ;; 07AF:  CB 4C
 bit 1, l               ;; 07B1:  CB 4D
 bit 1, (hl)            ;; 07B3:  CB 4E
 bit 1, a               ;; 07B5:  CB 4F
 bit 2, b               ;; 07B7:  CB 50
 bit 2, c               ;; 07B9:  CB 51
 bit 2, d               ;; 07BB:  CB 52
 bit 2, e               ;; 07BD:  CB 53
 bit 2, h               ;; 07BF:  CB 54
 bit 2, l               ;; 07C1:  CB 55
 bit 2, (hl)            ;; 07C3:  CB 56
 bit 2, a               ;; 07C5:  CB 57
 bit 3, b               ;; 07C7:  CB 58
 bit 3, c               ;; 07C9:  CB 59
 bit 3, d               ;; 07CB:  CB 5A
 bit 3, e               ;; 07CD:  CB 5B
 bit 3, h               ;; 07CF:  CB 5C
 bit 3, l               ;; 07D1:  CB 5D
 bit 3, (hl)            ;; 07D3:  CB 5E
 bit 3, a               ;; 07D5:  CB 5F
 bit 4, b               ;; 07D7:  CB 60
 bit 4, c               ;; 07D9:  CB 61
 bit 4, d               ;; 07DB:  CB 62
 bit 4, e               ;; 07DD:  CB 63
 bit 4, h               ;; 07DF:  CB 64
 bit 4, l               ;; 07E1:  CB 65
 bit 4, (hl)            ;; 07E3:  CB 66
 bit 4, a               ;; 07E5:  CB 67
 bit 5, b               ;; 07E7:  CB 68
 bit 5, c               ;; 07E9:  CB 69
 bit 5, d               ;; 07EB:  CB 6A
 bit 5, e               ;; 07ED:  CB 6B
 bit 5, h               ;; 07EF:  CB 6C
 bit 5, l               ;; 07F1:  CB 6D
 bit 5, (hl)            ;; 07F3:  CB 6E
 bit 5, a               ;; 07F5:  CB 6F
 bit 6, b               ;; 07F7:  CB 70
 bit 6, c               ;; 07F9:  CB 71
 bit 6, d               ;; 07FB:  CB 72
 bit 6, e               ;; 07FD:  CB 73
 bit 6, h               ;; 07FF:  CB 74
 bit 6, l               ;; 0801:  CB 75
 bit 6, (hl)            ;; 0803:  CB 76
 bit 6, a               ;; 0805:  CB 77
 bit 7, b               ;; 0807:  CB 78
 bit 7, c               ;; 0809:  CB 79
 bit 7, d               ;; 080B:  CB 7A
 bit 7, e               ;; 080D:  CB 7B
 bit 7, h               ;; 080F:  CB 7C
 bit 7, l               ;; 0811:  CB 7D
 bit 7, (hl)            ;; 0813:  CB 7E
 bit 7, a               ;; 0815:  CB 7F
 res 0, b               ;; 0817:  CB 80
 res 0, c               ;; 0819:  CB 81
 res 0, d               ;; 081B:  CB 82
 res 0, e               ;; 081D:  CB 83
 res 0, h               ;; 081F:  CB 84
 res 0, l               ;; 0821:  CB 85
 res 0, (hl)            ;; 0823:  CB 86
 res 0, a               ;; 0825:  CB 87
 res 1, b               ;; 0827:  CB 88
 res 1, c               ;; 0829:  CB 89
 res 1, d               ;; 082B:  CB 8A
 res 1, e               ;; 082D:  CB 8B
 res 1, h               ;; 082F:  CB 8C
 res 1, l               ;; 0831:  CB 8D
 res 1, (hl)            ;; 0833:  CB 8E
 res 1, a               ;; 0835:  CB 8F
 res 2, b               ;; 0837:  CB 90
 res 2, c               ;; 0839:  CB 91
 res 2, d               ;; 083B:  CB 92
 res 2, e               ;; 083D:  CB 93
 res 2, h               ;; 083F:  CB 94
 res 2, l               ;; 0841:  CB 95
 res 2, (hl)            ;; 0843:  CB 96
 res 2, a               ;; 0845:  CB 97
 res 3, b               ;; 0847:  CB 98
 res 3, c               ;; 0849:  CB 99
 res 3, d               ;; 084B:  CB 9A
 res 3, e               ;; 084D:  CB 9B
 res 3, h               ;; 084F:  CB 9C
 res 3, l               ;; 0851:  CB 9D
 res 3, (hl)            ;; 0853:  CB 9E
 res 3, a               ;; 0855:  CB 9F
 res 4, b               ;; 0857:  CB A0
 res 4, c               ;; 0859:  CB A1
 res 4, d               ;; 085B:  CB A2
 res 4, e               ;; 085D:  CB A3
 res 4, h               ;; 085F:  CB A4
 res 4, l               ;; 0861:  CB A5
 res 4, (hl)            ;; 0863:  CB A6
 res 4, a               ;; 0865:  CB A7
 res 5, b               ;; 0867:  CB A8
 res 5, c               ;; 0869:  CB A9
 res 5, d               ;; 086B:  CB AA
 res 5, e               ;; 086D:  CB AB
 res 5, h               ;; 086F:  CB AC
 res 5, l               ;; 0871:  CB AD
 res 5, (hl)            ;; 0873:  CB AE
 res 5, a               ;; 0875:  CB AF
 res 6, b               ;; 0877:  CB B0
 res 6, c               ;; 0879:  CB B1
 res 6, d               ;; 087B:  CB B2
 res 6, e               ;; 087D:  CB B3
 res 6, h               ;; 087F:  CB B4
 res 6, l               ;; 0881:  CB B5
 res 6, (hl)            ;; 0883:  CB B6
 res 6, a               ;; 0885:  CB B7
 res 7, b               ;; 0887:  CB B8
 res 7, c               ;; 0889:  CB B9
 res 7, d               ;; 088B:  CB BA
 res 7, e               ;; 088D:  CB BB
 res 7, h               ;; 088F:  CB BC
 res 7, l               ;; 0891:  CB BD
 res 7, (hl)            ;; 0893:  CB BE
 res 7, a               ;; 0895:  CB BF
 set 0, b               ;; 0897:  CB C0
 set 0, c               ;; 0899:  CB C1
 set 0, d               ;; 089B:  CB C2
 set 0, e               ;; 089D:  CB C3
 set 0, h               ;; 089F:  CB C4
 set 0, l               ;; 08A1:  CB C5
 set 0, (hl)            ;; 08A3:  CB C6
 set 0, a               ;; 08A5:  CB C7
 set 1, b               ;; 08A7:  CB C8
 set 1, c               ;; 08A9:  CB C9
 set 1, d               ;; 08AB:  CB CA
 set 1, e               ;; 08AD:  CB CB
 set 1, h               ;; 08AF:  CB CC
 set 1, l               ;; 08B1:  CB CD
 set 1, (hl)            ;; 08B3:  CB CE
 set 1, a               ;; 08B5:  CB CF
 set 2, b               ;; 08B7:  CB D0
 set 2, c               ;; 08B9:  CB D1
 set 2, d               ;; 08BB:  CB D2
 set 2, e               ;; 08BD:  CB D3
 set 2, h               ;; 08BF:  CB D4
 set 2, l               ;; 08C1:  CB D5
 set 2, (hl)            ;; 08C3:  CB D6
 set 2, a               ;; 08C5:  CB D7
 set 3, b               ;; 08C7:  CB D8
 set 3, c               ;; 08C9:  CB D9
 set 3, d               ;; 08CB:  CB DA
 set 3, e               ;; 08CD:  CB DB
 set 3, h               ;; 08CF:  CB DC
 set 3, l               ;; 08D1:  CB DD
 set 3, (hl)            ;; 08D3:  CB DE
 set 3, a               ;; 08D5:  CB DF
 set 4, b               ;; 08D7:  CB E0
 set 4, c               ;; 08D9:  CB E1
 set 4, d               ;; 08DB:  CB E2
 set 4, e               ;; 08DD:  CB E3
 set 4, h               ;; 08DF:  CB E4
 set 4, l               ;; 08E1:  CB E5
 set 4, (hl)            ;; 08E3:  CB E6
 set 4, a               ;; 08E5:  CB E7
 set 5, b               ;; 08E7:  CB E8
 set 5, c               ;; 08E9:  CB E9
 set 5, d               ;; 08EB:  CB EA
 set 5, e               ;; 08ED:  CB EB
 set 5, h               ;; 08EF:  CB EC
 set 5, l               ;; 08F1:  CB ED
 set 5, (hl)            ;; 08F3:  CB EE
 set 5, a               ;; 08F5:  CB EF
 set 6, b               ;; 08F7:  CB F0
 set 6, c               ;; 08F9:  CB F1
 set 6, d               ;; 08FB:  CB F2
 set 6, e               ;; 08FD:  CB F3
 set 6, h               ;; 08FF:  CB F4
 set 6, l               ;; 0901:  CB F5
 set 6, (hl)            ;; 0903:  CB F6
 set 6, a               ;; 0905:  CB F7
 set 7, b               ;; 0907:  CB F8
 set 7, c               ;; 0909:  CB F9
 set 7, d               ;; 090B:  CB FA
 set 7, e               ;; 090D:  CB FB
 set 7, h               ;; 090F:  CB FC
 set 7, l               ;; 0911:  CB FD
 set 7, (hl)            ;; 0913:  CB FE
 set 7, a               ;; 0915:  CB FF
 bit 0, (ix+-128)       ;; 0917:  DD CB 80 46
 bit 0, (ix)            ;; 091B:  DD CB 00 46
 bit 0, (ix+127)        ;; 091F:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0923:  DD CB 80 4E
 bit 1, (ix)            ;; 0927:  DD CB 00 4E
 bit 1, (ix+127)        ;; 092B:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 092F:  DD CB 80 56
 bit 2, (ix)            ;; 0933:  DD CB 00 56
 bit 2, (ix+127)        ;; 0937:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 093B:  DD CB 80 5E
 bit 3, (ix)            ;; 093F:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0943:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0947:  DD CB 80 66
 bit 4, (ix)            ;; 094B:  DD CB 00 66
 bit 4, (ix+127)        ;; 094F:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0953:  DD CB 80 6E
 bit 5, (ix)            ;; 0957:  DD CB 00 6E
 bit 5, (ix+127)        ;; 095B:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 095F:  DD CB 80 76
 bit 6, (ix)            ;; 0963:  DD CB 00 76
 bit 6, (ix+127)        ;; 0967:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 096B:  DD CB 80 7E
 bit 7, (ix)            ;; 096F:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0973:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0977:  DD CB 80 86
 res 0, (ix)            ;; 097B:  DD CB 00 86
 res 0, (ix+127)        ;; 097F:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0983:  DD CB 80 8E
 res 1, (ix)            ;; 0987:  DD CB 00 8E
 res 1, (ix+127)        ;; 098B:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 098F:  DD CB 80 96
 res 2, (ix)            ;; 0993:  DD CB 00 96
 res 2, (ix+127)        ;; 0997:  DD CB 7F 96
 res 3, (ix+-128)       ;; 099B:  DD CB 80 9E
 res 3, (ix)            ;; 099F:  DD CB 00 9E
 res 3, (ix+127)        ;; 09A3:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 09A7:  DD CB 80 A6
 res 4, (ix)            ;; 09AB:  DD CB 00 A6
 res 4, (ix+127)        ;; 09AF:  DD CB 7F A6
 res 5, (ix+-128)       ;; 09B3:  DD CB 80 AE
 res 5, (ix)            ;; 09B7:  DD CB 00 AE
 res 5, (ix+127)        ;; 09BB:  DD CB 7F AE
 res 6, (ix+-128)       ;; 09BF:  DD CB 80 B6
 res 6, (ix)            ;; 09C3:  DD CB 00 B6
 res 6, (ix+127)        ;; 09C7:  DD CB 7F B6
 res 7, (ix+-128)       ;; 09CB:  DD CB 80 BE
 res 7, (ix)            ;; 09CF:  DD CB 00 BE
 res 7, (ix+127)        ;; 09D3:  DD CB 7F BE
 set 0, (ix+-128)       ;; 09D7:  DD CB 80 C6
 set 0, (ix)            ;; 09DB:  DD CB 00 C6
 set 0, (ix+127)        ;; 09DF:  DD CB 7F C6
 set 1, (ix+-128)       ;; 09E3:  DD CB 80 CE
 set 1, (ix)            ;; 09E7:  DD CB 00 CE
 set 1, (ix+127)        ;; 09EB:  DD CB 7F CE
 set 2, (ix+-128)       ;; 09EF:  DD CB 80 D6
 set 2, (ix)            ;; 09F3:  DD CB 00 D6
 set 2, (ix+127)        ;; 09F7:  DD CB 7F D6
 set 3, (ix+-128)       ;; 09FB:  DD CB 80 DE
 set 3, (ix)            ;; 09FF:  DD CB 00 DE
 set 3, (ix+127)        ;; 0A03:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0A07:  DD CB 80 E6
 set 4, (ix)            ;; 0A0B:  DD CB 00 E6
 set 4, (ix+127)        ;; 0A0F:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0A13:  DD CB 80 EE
 set 5, (ix)            ;; 0A17:  DD CB 00 EE
 set 5, (ix+127)        ;; 0A1B:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0A1F:  DD CB 80 F6
 set 6, (ix)            ;; 0A23:  DD CB 00 F6
 set 6, (ix+127)        ;; 0A27:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0A2B:  DD CB 80 FE
 set 7, (ix)            ;; 0A2F:  DD CB 00 FE
 set 7, (ix+127)        ;; 0A33:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0A37:  FD CB 80 46
 bit 0, (iy)            ;; 0A3B:  FD CB 00 46
 bit 0, (iy+127)        ;; 0A3F:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0A43:  FD CB 80 4E
 bit 1, (iy)            ;; 0A47:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0A4B:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0A4F:  FD CB 80 56
 bit 2, (iy)            ;; 0A53:  FD CB 00 56
 bit 2, (iy+127)        ;; 0A57:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0A5B:  FD CB 80 5E
 bit 3, (iy)            ;; 0A5F:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0A63:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0A67:  FD CB 80 66
 bit 4, (iy)            ;; 0A6B:  FD CB 00 66
 bit 4, (iy+127)        ;; 0A6F:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0A73:  FD CB 80 6E
 bit 5, (iy)            ;; 0A77:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0A7B:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0A7F:  FD CB 80 76
 bit 6, (iy)            ;; 0A83:  FD CB 00 76
 bit 6, (iy+127)        ;; 0A87:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0A8B:  FD CB 80 7E
 bit 7, (iy)            ;; 0A8F:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0A93:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0A97:  FD CB 80 86
 res 0, (iy)            ;; 0A9B:  FD CB 00 86
 res 0, (iy+127)        ;; 0A9F:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0AA3:  FD CB 80 8E
 res 1, (iy)            ;; 0AA7:  FD CB 00 8E
 res 1, (iy+127)        ;; 0AAB:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0AAF:  FD CB 80 96
 res 2, (iy)            ;; 0AB3:  FD CB 00 96
 res 2, (iy+127)        ;; 0AB7:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0ABB:  FD CB 80 9E
 res 3, (iy)            ;; 0ABF:  FD CB 00 9E
 res 3, (iy+127)        ;; 0AC3:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0AC7:  FD CB 80 A6
 res 4, (iy)            ;; 0ACB:  FD CB 00 A6
 res 4, (iy+127)        ;; 0ACF:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0AD3:  FD CB 80 AE
 res 5, (iy)            ;; 0AD7:  FD CB 00 AE
 res 5, (iy+127)        ;; 0ADB:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0ADF:  FD CB 80 B6
 res 6, (iy)            ;; 0AE3:  FD CB 00 B6
 res 6, (iy+127)        ;; 0AE7:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0AEB:  FD CB 80 BE
 res 7, (iy)            ;; 0AEF:  FD CB 00 BE
 res 7, (iy+127)        ;; 0AF3:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0AF7:  FD CB 80 C6
 set 0, (iy)            ;; 0AFB:  FD CB 00 C6
 set 0, (iy+127)        ;; 0AFF:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0B03:  FD CB 80 CE
 set 1, (iy)            ;; 0B07:  FD CB 00 CE
 set 1, (iy+127)        ;; 0B0B:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0B0F:  FD CB 80 D6
 set 2, (iy)            ;; 0B13:  FD CB 00 D6
 set 2, (iy+127)        ;; 0B17:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0B1B:  FD CB 80 DE
 set 3, (iy)            ;; 0B1F:  FD CB 00 DE
 set 3, (iy+127)        ;; 0B23:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0B27:  FD CB 80 E6
 set 4, (iy)            ;; 0B2B:  FD CB 00 E6
 set 4, (iy+127)        ;; 0B2F:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0B33:  FD CB 80 EE
 set 5, (iy)            ;; 0B37:  FD CB 00 EE
 set 5, (iy+127)        ;; 0B3B:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0B3F:  FD CB 80 F6
 set 6, (iy)            ;; 0B43:  FD CB 00 F6
 set 6, (iy+127)        ;; 0B47:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0B4B:  FD CB 80 FE
 set 7, (iy)            ;; 0B4F:  FD CB 00 FE
 set 7, (iy+127)        ;; 0B53:  FD CB 7F FE
 ldi                    ;; 0B57:  ED A0
 ldir                   ;; 0B59:  ED B0
 ldd                    ;; 0B5B:  ED A8
 lddr                   ;; 0B5D:  ED B8
 cpi                    ;; 0B5F:  ED A1
 cpir                   ;; 0B61:  ED B1
 cpd                    ;; 0B63:  ED A9
 cpdr                   ;; 0B65:  ED B9
 nop                    ;; 0B67:  00
 halt                   ;; 0B68:  76
 slp                    ;; 0B69:  ED 76
 jp 0                   ;; 0B6B:  C3 00 00
 jp 291                 ;; 0B6E:  C3 23 01
 jp 17767               ;; 0B71:  C3 67 45
 jp 35243               ;; 0B74:  C3 AB 89
 jp 52719               ;; 0B77:  C3 EF CD
 jp 65535               ;; 0B7A:  C3 FF FF
 jp nz, 0               ;; 0B7D:  C2 00 00
 jp nz, 291             ;; 0B80:  C2 23 01
 jp nz, 17767           ;; 0B83:  C2 67 45
 jp nz, 35243           ;; 0B86:  C2 AB 89
 jp nz, 52719           ;; 0B89:  C2 EF CD
 jp nz, 65535           ;; 0B8C:  C2 FF FF
 jp z, 0                ;; 0B8F:  CA 00 00
 jp z, 291              ;; 0B92:  CA 23 01
 jp z, 17767            ;; 0B95:  CA 67 45
 jp z, 35243            ;; 0B98:  CA AB 89
 jp z, 52719            ;; 0B9B:  CA EF CD
 jp z, 65535            ;; 0B9E:  CA FF FF
 jp nc, 0               ;; 0BA1:  D2 00 00
 jp nc, 291             ;; 0BA4:  D2 23 01
 jp nc, 17767           ;; 0BA7:  D2 67 45
 jp nc, 35243           ;; 0BAA:  D2 AB 89
 jp nc, 52719           ;; 0BAD:  D2 EF CD
 jp nc, 65535           ;; 0BB0:  D2 FF FF
 jp c, 0                ;; 0BB3:  DA 00 00
 jp c, 291              ;; 0BB6:  DA 23 01
 jp c, 17767            ;; 0BB9:  DA 67 45
 jp c, 35243            ;; 0BBC:  DA AB 89
 jp c, 52719            ;; 0BBF:  DA EF CD
 jp c, 65535            ;; 0BC2:  DA FF FF
 jp po, 0               ;; 0BC5:  E2 00 00
 jp po, 291             ;; 0BC8:  E2 23 01
 jp po, 17767           ;; 0BCB:  E2 67 45
 jp po, 35243           ;; 0BCE:  E2 AB 89
 jp po, 52719           ;; 0BD1:  E2 EF CD
 jp po, 65535           ;; 0BD4:  E2 FF FF
 jp pe, 0               ;; 0BD7:  EA 00 00
 jp pe, 291             ;; 0BDA:  EA 23 01
 jp pe, 17767           ;; 0BDD:  EA 67 45
 jp pe, 35243           ;; 0BE0:  EA AB 89
 jp pe, 52719           ;; 0BE3:  EA EF CD
 jp pe, 65535           ;; 0BE6:  EA FF FF
 jp p, 0                ;; 0BE9:  F2 00 00
 jp p, 291              ;; 0BEC:  F2 23 01
 jp p, 17767            ;; 0BEF:  F2 67 45
 jp p, 35243            ;; 0BF2:  F2 AB 89
 jp p, 52719            ;; 0BF5:  F2 EF CD
 jp p, 65535            ;; 0BF8:  F2 FF FF
 jp m, 0                ;; 0BFB:  FA 00 00
 jp m, 291              ;; 0BFE:  FA 23 01
 jp m, 17767            ;; 0C01:  FA 67 45
 jp m, 35243            ;; 0C04:  FA AB 89
 jp m, 52719            ;; 0C07:  FA EF CD
 jp m, 65535            ;; 0C0A:  FA FF FF
 jp (hl)                ;; 0C0D:  E9
 jp (ix)                ;; 0C0E:  DD E9
 jp (iy)                ;; 0C10:  FD E9
 djnz ASMPC             ;; 0C12:  10 FE
 djnz b, ASMPC          ;; 0C14:  10 FE
 jr ASMPC               ;; 0C16:  18 FE
 jr nz, ASMPC           ;; 0C18:  20 FE
 jr z, ASMPC            ;; 0C1A:  28 FE
 jr nc, ASMPC           ;; 0C1C:  30 FE
 jr c, ASMPC            ;; 0C1E:  38 FE
 call 0                 ;; 0C20:  CD 00 00
 call 291               ;; 0C23:  CD 23 01
 call 17767             ;; 0C26:  CD 67 45
 call 35243             ;; 0C29:  CD AB 89
 call 52719             ;; 0C2C:  CD EF CD
 call 65535             ;; 0C2F:  CD FF FF
 call nz, 0             ;; 0C32:  C4 00 00
 call nz, 291           ;; 0C35:  C4 23 01
 call nz, 17767         ;; 0C38:  C4 67 45
 call nz, 35243         ;; 0C3B:  C4 AB 89
 call nz, 52719         ;; 0C3E:  C4 EF CD
 call nz, 65535         ;; 0C41:  C4 FF FF
 call z, 0              ;; 0C44:  CC 00 00
 call z, 291            ;; 0C47:  CC 23 01
 call z, 17767          ;; 0C4A:  CC 67 45
 call z, 35243          ;; 0C4D:  CC AB 89
 call z, 52719          ;; 0C50:  CC EF CD
 call z, 65535          ;; 0C53:  CC FF FF
 call nc, 0             ;; 0C56:  D4 00 00
 call nc, 291           ;; 0C59:  D4 23 01
 call nc, 17767         ;; 0C5C:  D4 67 45
 call nc, 35243         ;; 0C5F:  D4 AB 89
 call nc, 52719         ;; 0C62:  D4 EF CD
 call nc, 65535         ;; 0C65:  D4 FF FF
 call c, 0              ;; 0C68:  DC 00 00
 call c, 291            ;; 0C6B:  DC 23 01
 call c, 17767          ;; 0C6E:  DC 67 45
 call c, 35243          ;; 0C71:  DC AB 89
 call c, 52719          ;; 0C74:  DC EF CD
 call c, 65535          ;; 0C77:  DC FF FF
 call po, 0             ;; 0C7A:  E4 00 00
 call po, 291           ;; 0C7D:  E4 23 01
 call po, 17767         ;; 0C80:  E4 67 45
 call po, 35243         ;; 0C83:  E4 AB 89
 call po, 52719         ;; 0C86:  E4 EF CD
 call po, 65535         ;; 0C89:  E4 FF FF
 call pe, 0             ;; 0C8C:  EC 00 00
 call pe, 291           ;; 0C8F:  EC 23 01
 call pe, 17767         ;; 0C92:  EC 67 45
 call pe, 35243         ;; 0C95:  EC AB 89
 call pe, 52719         ;; 0C98:  EC EF CD
 call pe, 65535         ;; 0C9B:  EC FF FF
 call p, 0              ;; 0C9E:  F4 00 00
 call p, 291            ;; 0CA1:  F4 23 01
 call p, 17767          ;; 0CA4:  F4 67 45
 call p, 35243          ;; 0CA7:  F4 AB 89
 call p, 52719          ;; 0CAA:  F4 EF CD
 call p, 65535          ;; 0CAD:  F4 FF FF
 call m, 0              ;; 0CB0:  FC 00 00
 call m, 291            ;; 0CB3:  FC 23 01
 call m, 17767          ;; 0CB6:  FC 67 45
 call m, 35243          ;; 0CB9:  FC AB 89
 call m, 52719          ;; 0CBC:  FC EF CD
 call m, 65535          ;; 0CBF:  FC FF FF
 ret                    ;; 0CC2:  C9
 ret nz                 ;; 0CC3:  C0
 ret z                  ;; 0CC4:  C8
 ret nc                 ;; 0CC5:  D0
 ret c                  ;; 0CC6:  D8
 ret po                 ;; 0CC7:  E0
 ret pe                 ;; 0CC8:  E8
 ret p                  ;; 0CC9:  F0
 ret m                  ;; 0CCA:  F8
 rst 16                 ;; 0CCB:  D7
 rst 24                 ;; 0CCC:  DF
 rst 32                 ;; 0CCD:  E7
 rst 40                 ;; 0CCE:  EF
 rst 56                 ;; 0CCF:  FF
 rst 0                  ;; 0CD0:  C7
 rst 8                  ;; 0CD1:  CF
 rst 48                 ;; 0CD2:  F7
 in a, (0)              ;; 0CD3:  DB 00
 in a, (85)             ;; 0CD5:  DB 55
 in a, (170)            ;; 0CD7:  DB AA
 in a, (255)            ;; 0CD9:  DB FF
 in b, (c)              ;; 0CDB:  ED 40
 in c, (c)              ;; 0CDD:  ED 48
 in d, (c)              ;; 0CDF:  ED 50
 in e, (c)              ;; 0CE1:  ED 58
 in h, (c)              ;; 0CE3:  ED 60
 in l, (c)              ;; 0CE5:  ED 68
 in f, (c)              ;; 0CE7:  ED 70
 in a, (c)              ;; 0CE9:  ED 78
 in0 b, (0)             ;; 0CEB:  ED 00 00
 in0 b, (85)            ;; 0CEE:  ED 00 55
 in0 b, (170)           ;; 0CF1:  ED 00 AA
 in0 b, (255)           ;; 0CF4:  ED 00 FF
 in0 c, (0)             ;; 0CF7:  ED 08 00
 in0 c, (85)            ;; 0CFA:  ED 08 55
 in0 c, (170)           ;; 0CFD:  ED 08 AA
 in0 c, (255)           ;; 0D00:  ED 08 FF
 in0 d, (0)             ;; 0D03:  ED 10 00
 in0 d, (85)            ;; 0D06:  ED 10 55
 in0 d, (170)           ;; 0D09:  ED 10 AA
 in0 d, (255)           ;; 0D0C:  ED 10 FF
 in0 e, (0)             ;; 0D0F:  ED 18 00
 in0 e, (85)            ;; 0D12:  ED 18 55
 in0 e, (170)           ;; 0D15:  ED 18 AA
 in0 e, (255)           ;; 0D18:  ED 18 FF
 in0 h, (0)             ;; 0D1B:  ED 20 00
 in0 h, (85)            ;; 0D1E:  ED 20 55
 in0 h, (170)           ;; 0D21:  ED 20 AA
 in0 h, (255)           ;; 0D24:  ED 20 FF
 in0 l, (0)             ;; 0D27:  ED 28 00
 in0 l, (85)            ;; 0D2A:  ED 28 55
 in0 l, (170)           ;; 0D2D:  ED 28 AA
 in0 l, (255)           ;; 0D30:  ED 28 FF
 in0 f, (0)             ;; 0D33:  ED 30 00
 in0 f, (85)            ;; 0D36:  ED 30 55
 in0 f, (170)           ;; 0D39:  ED 30 AA
 in0 f, (255)           ;; 0D3C:  ED 30 FF
 in0 a, (0)             ;; 0D3F:  ED 38 00
 in0 a, (85)            ;; 0D42:  ED 38 55
 in0 a, (170)           ;; 0D45:  ED 38 AA
 in0 a, (255)           ;; 0D48:  ED 38 FF
 out (0), a             ;; 0D4B:  D3 00
 out (85), a            ;; 0D4D:  D3 55
 out (170), a           ;; 0D4F:  D3 AA
 out (255), a           ;; 0D51:  D3 FF
 out (c), b             ;; 0D53:  ED 41
 out (c), c             ;; 0D55:  ED 49
 out (c), d             ;; 0D57:  ED 51
 out (c), e             ;; 0D59:  ED 59
 out (c), h             ;; 0D5B:  ED 61
 out (c), l             ;; 0D5D:  ED 69
 out (c), 0             ;; 0D5F:  ED 71
 out (c), a             ;; 0D61:  ED 79
 out0 (0), b            ;; 0D63:  ED 01 00
 out0 (85), b           ;; 0D66:  ED 01 55
 out0 (170), b          ;; 0D69:  ED 01 AA
 out0 (255), b          ;; 0D6C:  ED 01 FF
 out0 (0), c            ;; 0D6F:  ED 09 00
 out0 (85), c           ;; 0D72:  ED 09 55
 out0 (170), c          ;; 0D75:  ED 09 AA
 out0 (255), c          ;; 0D78:  ED 09 FF
 out0 (0), d            ;; 0D7B:  ED 11 00
 out0 (85), d           ;; 0D7E:  ED 11 55
 out0 (170), d          ;; 0D81:  ED 11 AA
 out0 (255), d          ;; 0D84:  ED 11 FF
 out0 (0), e            ;; 0D87:  ED 19 00
 out0 (85), e           ;; 0D8A:  ED 19 55
 out0 (170), e          ;; 0D8D:  ED 19 AA
 out0 (255), e          ;; 0D90:  ED 19 FF
 out0 (0), h            ;; 0D93:  ED 21 00
 out0 (85), h           ;; 0D96:  ED 21 55
 out0 (170), h          ;; 0D99:  ED 21 AA
 out0 (255), h          ;; 0D9C:  ED 21 FF
 out0 (0), l            ;; 0D9F:  ED 29 00
 out0 (85), l           ;; 0DA2:  ED 29 55
 out0 (170), l          ;; 0DA5:  ED 29 AA
 out0 (255), l          ;; 0DA8:  ED 29 FF
 out0 (0), a            ;; 0DAB:  ED 39 00
 out0 (85), a           ;; 0DAE:  ED 39 55
 out0 (170), a          ;; 0DB1:  ED 39 AA
 out0 (255), a          ;; 0DB4:  ED 39 FF
 tstio 0                ;; 0DB7:  ED 74 00
 tstio 85               ;; 0DBA:  ED 74 55
 tstio 170              ;; 0DBD:  ED 74 AA
 tstio 255              ;; 0DC0:  ED 74 FF
 ini                    ;; 0DC3:  ED A2
 inir                   ;; 0DC5:  ED B2
 ind                    ;; 0DC7:  ED AA
 indr                   ;; 0DC9:  ED BA
 outi                   ;; 0DCB:  ED A3
 otir                   ;; 0DCD:  ED B3
 outd                   ;; 0DCF:  ED AB
 otdr                   ;; 0DD1:  ED BB
 otdm                   ;; 0DD3:  ED 8B
 otdmr                  ;; 0DD5:  ED 9B
 otim                   ;; 0DD7:  ED 83
 otimr                  ;; 0DD9:  ED 93
 di                     ;; 0DDB:  F3
 ei                     ;; 0DDC:  FB
 im 0                   ;; 0DDD:  ED 46
 im 1                   ;; 0DDF:  ED 56
 im 2                   ;; 0DE1:  ED 5E
 ld i, a                ;; 0DE3:  ED 47
 ld a, i                ;; 0DE5:  ED 57
 ld r, a                ;; 0DE7:  ED 4F
 ld a, r                ;; 0DE9:  ED 5F
 reti                   ;; 0DEB:  ED 4D
 retn                   ;; 0DED:  ED 45
