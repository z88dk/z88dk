 ld b, b                ;; 0000:  40
 ld b, c                ;; 0001:  41
 ld b, d                ;; 0002:  42
 ld b, e                ;; 0003:  43
 ld b, h                ;; 0004:  44
 ld b, l                ;; 0005:  45
 ld b, a                ;; 0006:  47
 ld c, b                ;; 0007:  48
 ld c, c                ;; 0008:  49
 ld c, d                ;; 0009:  4A
 ld c, e                ;; 000A:  4B
 ld c, h                ;; 000B:  4C
 ld c, l                ;; 000C:  4D
 ld c, a                ;; 000D:  4F
 ld d, b                ;; 000E:  50
 ld d, c                ;; 000F:  51
 ld d, d                ;; 0010:  52
 ld d, e                ;; 0011:  53
 ld d, h                ;; 0012:  54
 ld d, l                ;; 0013:  55
 ld d, a                ;; 0014:  57
 ld e, b                ;; 0015:  58
 ld e, c                ;; 0016:  59
 ld e, d                ;; 0017:  5A
 ld e, e                ;; 0018:  5B
 ld e, h                ;; 0019:  5C
 ld e, l                ;; 001A:  5D
 ld e, a                ;; 001B:  5F
 ld h, b                ;; 001C:  60
 ld h, c                ;; 001D:  61
 ld h, d                ;; 001E:  62
 ld h, e                ;; 001F:  63
 ld h, h                ;; 0020:  64
 ld h, l                ;; 0021:  65
 ld h, a                ;; 0022:  67
 ld l, b                ;; 0023:  68
 ld l, c                ;; 0024:  69
 ld l, d                ;; 0025:  6A
 ld l, e                ;; 0026:  6B
 ld l, h                ;; 0027:  6C
 ld l, l                ;; 0028:  6D
 ld l, a                ;; 0029:  6F
 ld a, b                ;; 002A:  78
 ld a, c                ;; 002B:  79
 ld a, d                ;; 002C:  7A
 ld a, e                ;; 002D:  7B
 ld a, h                ;; 002E:  7C
 ld a, l                ;; 002F:  7D
 ld a, a                ;; 0030:  7F
 ld b, 0                ;; 0031:  06 00
 ld b, 85               ;; 0033:  06 55
 ld b, 170              ;; 0035:  06 AA
 ld b, 255              ;; 0037:  06 FF
 ld c, 0                ;; 0039:  0E 00
 ld c, 85               ;; 003B:  0E 55
 ld c, 170              ;; 003D:  0E AA
 ld c, 255              ;; 003F:  0E FF
 ld d, 0                ;; 0041:  16 00
 ld d, 85               ;; 0043:  16 55
 ld d, 170              ;; 0045:  16 AA
 ld d, 255              ;; 0047:  16 FF
 ld e, 0                ;; 0049:  1E 00
 ld e, 85               ;; 004B:  1E 55
 ld e, 170              ;; 004D:  1E AA
 ld e, 255              ;; 004F:  1E FF
 ld h, 0                ;; 0051:  26 00
 ld h, 85               ;; 0053:  26 55
 ld h, 170              ;; 0055:  26 AA
 ld h, 255              ;; 0057:  26 FF
 ld l, 0                ;; 0059:  2E 00
 ld l, 85               ;; 005B:  2E 55
 ld l, 170              ;; 005D:  2E AA
 ld l, 255              ;; 005F:  2E FF
 ld a, 0                ;; 0061:  3E 00
 ld a, 85               ;; 0063:  3E 55
 ld a, 170              ;; 0065:  3E AA
 ld a, 255              ;; 0067:  3E FF
 ld b, (hl)             ;; 0069:  46
 ld c, (hl)             ;; 006A:  4E
 ld d, (hl)             ;; 006B:  56
 ld e, (hl)             ;; 006C:  5E
 ld h, (hl)             ;; 006D:  66
 ld l, (hl)             ;; 006E:  6E
 ld a, (hl)             ;; 006F:  7E
 ld b, (ix + -128)      ;; 0070:  DD 46 80
 ld b, (ix)             ;; 0073:  DD 46 00
 ld b, (ix + 127)       ;; 0076:  DD 46 7F
 ld c, (ix + -128)      ;; 0079:  DD 4E 80
 ld c, (ix)             ;; 007C:  DD 4E 00
 ld c, (ix + 127)       ;; 007F:  DD 4E 7F
 ld d, (ix + -128)      ;; 0082:  DD 56 80
 ld d, (ix)             ;; 0085:  DD 56 00
 ld d, (ix + 127)       ;; 0088:  DD 56 7F
 ld e, (ix + -128)      ;; 008B:  DD 5E 80
 ld e, (ix)             ;; 008E:  DD 5E 00
 ld e, (ix + 127)       ;; 0091:  DD 5E 7F
 ld h, (ix + -128)      ;; 0094:  DD 66 80
 ld h, (ix)             ;; 0097:  DD 66 00
 ld h, (ix + 127)       ;; 009A:  DD 66 7F
 ld l, (ix + -128)      ;; 009D:  DD 6E 80
 ld l, (ix)             ;; 00A0:  DD 6E 00
 ld l, (ix + 127)       ;; 00A3:  DD 6E 7F
 ld a, (ix + -128)      ;; 00A6:  DD 7E 80
 ld a, (ix)             ;; 00A9:  DD 7E 00
 ld a, (ix + 127)       ;; 00AC:  DD 7E 7F
 ld b, (iy + -128)      ;; 00AF:  FD 46 80
 ld b, (iy)             ;; 00B2:  FD 46 00
 ld b, (iy + 127)       ;; 00B5:  FD 46 7F
 ld c, (iy + -128)      ;; 00B8:  FD 4E 80
 ld c, (iy)             ;; 00BB:  FD 4E 00
 ld c, (iy + 127)       ;; 00BE:  FD 4E 7F
 ld d, (iy + -128)      ;; 00C1:  FD 56 80
 ld d, (iy)             ;; 00C4:  FD 56 00
 ld d, (iy + 127)       ;; 00C7:  FD 56 7F
 ld e, (iy + -128)      ;; 00CA:  FD 5E 80
 ld e, (iy)             ;; 00CD:  FD 5E 00
 ld e, (iy + 127)       ;; 00D0:  FD 5E 7F
 ld h, (iy + -128)      ;; 00D3:  FD 66 80
 ld h, (iy)             ;; 00D6:  FD 66 00
 ld h, (iy + 127)       ;; 00D9:  FD 66 7F
 ld l, (iy + -128)      ;; 00DC:  FD 6E 80
 ld l, (iy)             ;; 00DF:  FD 6E 00
 ld l, (iy + 127)       ;; 00E2:  FD 6E 7F
 ld a, (iy + -128)      ;; 00E5:  FD 7E 80
 ld a, (iy)             ;; 00E8:  FD 7E 00
 ld a, (iy + 127)       ;; 00EB:  FD 7E 7F
 ld (hl), b             ;; 00EE:  70
 ld (hl), c             ;; 00EF:  71
 ld (hl), d             ;; 00F0:  72
 ld (hl), e             ;; 00F1:  73
 ld (hl), h             ;; 00F2:  74
 ld (hl), l             ;; 00F3:  75
 ld (hl), a             ;; 00F4:  77
 ld (ix + -128), b      ;; 00F5:  DD 70 80
 ld (ix), b             ;; 00F8:  DD 70 00
 ld (ix + 127), b       ;; 00FB:  DD 70 7F
 ld (ix + -128), c      ;; 00FE:  DD 71 80
 ld (ix), c             ;; 0101:  DD 71 00
 ld (ix + 127), c       ;; 0104:  DD 71 7F
 ld (ix + -128), d      ;; 0107:  DD 72 80
 ld (ix), d             ;; 010A:  DD 72 00
 ld (ix + 127), d       ;; 010D:  DD 72 7F
 ld (ix + -128), e      ;; 0110:  DD 73 80
 ld (ix), e             ;; 0113:  DD 73 00
 ld (ix + 127), e       ;; 0116:  DD 73 7F
 ld (ix + -128), h      ;; 0119:  DD 74 80
 ld (ix), h             ;; 011C:  DD 74 00
 ld (ix + 127), h       ;; 011F:  DD 74 7F
 ld (ix + -128), l      ;; 0122:  DD 75 80
 ld (ix), l             ;; 0125:  DD 75 00
 ld (ix + 127), l       ;; 0128:  DD 75 7F
 ld (ix + -128), a      ;; 012B:  DD 77 80
 ld (ix), a             ;; 012E:  DD 77 00
 ld (ix + 127), a       ;; 0131:  DD 77 7F
 ld (iy + -128), b      ;; 0134:  FD 70 80
 ld (iy), b             ;; 0137:  FD 70 00
 ld (iy + 127), b       ;; 013A:  FD 70 7F
 ld (iy + -128), c      ;; 013D:  FD 71 80
 ld (iy), c             ;; 0140:  FD 71 00
 ld (iy + 127), c       ;; 0143:  FD 71 7F
 ld (iy + -128), d      ;; 0146:  FD 72 80
 ld (iy), d             ;; 0149:  FD 72 00
 ld (iy + 127), d       ;; 014C:  FD 72 7F
 ld (iy + -128), e      ;; 014F:  FD 73 80
 ld (iy), e             ;; 0152:  FD 73 00
 ld (iy + 127), e       ;; 0155:  FD 73 7F
 ld (iy + -128), h      ;; 0158:  FD 74 80
 ld (iy), h             ;; 015B:  FD 74 00
 ld (iy + 127), h       ;; 015E:  FD 74 7F
 ld (iy + -128), l      ;; 0161:  FD 75 80
 ld (iy), l             ;; 0164:  FD 75 00
 ld (iy + 127), l       ;; 0167:  FD 75 7F
 ld (iy + -128), a      ;; 016A:  FD 77 80
 ld (iy), a             ;; 016D:  FD 77 00
 ld (iy + 127), a       ;; 0170:  FD 77 7F
 ld (hl), 0             ;; 0173:  36 00
 ld (hl), 85            ;; 0175:  36 55
 ld (hl), 170           ;; 0177:  36 AA
 ld (hl), 255           ;; 0179:  36 FF
 ld (ix + -128), 0      ;; 017B:  DD 36 80 00
 ld (ix), 0             ;; 017F:  DD 36 00 00
 ld (ix + 127), 0       ;; 0183:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0187:  DD 36 80 55
 ld (ix), 85            ;; 018B:  DD 36 00 55
 ld (ix + 127), 85      ;; 018F:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0193:  DD 36 80 AA
 ld (ix), 170           ;; 0197:  DD 36 00 AA
 ld (ix + 127), 170     ;; 019B:  DD 36 7F AA
 ld (ix + -128), 255    ;; 019F:  DD 36 80 FF
 ld (ix), 255           ;; 01A3:  DD 36 00 FF
 ld (ix + 127), 255     ;; 01A7:  DD 36 7F FF
 ld (iy + -128), 0      ;; 01AB:  FD 36 80 00
 ld (iy), 0             ;; 01AF:  FD 36 00 00
 ld (iy + 127), 0       ;; 01B3:  FD 36 7F 00
 ld (iy + -128), 85     ;; 01B7:  FD 36 80 55
 ld (iy), 85            ;; 01BB:  FD 36 00 55
 ld (iy + 127), 85      ;; 01BF:  FD 36 7F 55
 ld (iy + -128), 170    ;; 01C3:  FD 36 80 AA
 ld (iy), 170           ;; 01C7:  FD 36 00 AA
 ld (iy + 127), 170     ;; 01CB:  FD 36 7F AA
 ld (iy + -128), 255    ;; 01CF:  FD 36 80 FF
 ld (iy), 255           ;; 01D3:  FD 36 00 FF
 ld (iy + 127), 255     ;; 01D7:  FD 36 7F FF
 ld a, (bc)             ;; 01DB:  0A
 ld a, (de)             ;; 01DC:  1A
 ld (bc), a             ;; 01DD:  02
 ld (de), a             ;; 01DE:  12
 ld a, (0)              ;; 01DF:  3A 00 00
 ld a, (291)            ;; 01E2:  3A 23 01
 ld a, (17767)          ;; 01E5:  3A 67 45
 ld a, (35243)          ;; 01E8:  3A AB 89
 ld a, (52719)          ;; 01EB:  3A EF CD
 ld a, (65535)          ;; 01EE:  3A FF FF
 ld (0), a              ;; 01F1:  32 00 00
 ld (291), a            ;; 01F4:  32 23 01
 ld (17767), a          ;; 01F7:  32 67 45
 ld (35243), a          ;; 01FA:  32 AB 89
 ld (52719), a          ;; 01FD:  32 EF CD
 ld (65535), a          ;; 0200:  32 FF FF
 add a, b               ;; 0203:  80
 add a, c               ;; 0204:  81
 add a, d               ;; 0205:  82
 add a, e               ;; 0206:  83
 add a, h               ;; 0207:  84
 add a, l               ;; 0208:  85
 add a, (hl)            ;; 0209:  86
 add a, a               ;; 020A:  87
 adc a, b               ;; 020B:  88
 adc a, c               ;; 020C:  89
 adc a, d               ;; 020D:  8A
 adc a, e               ;; 020E:  8B
 adc a, h               ;; 020F:  8C
 adc a, l               ;; 0210:  8D
 adc a, (hl)            ;; 0211:  8E
 adc a, a               ;; 0212:  8F
 sub a, b               ;; 0213:  90
 sub a, c               ;; 0214:  91
 sub a, d               ;; 0215:  92
 sub a, e               ;; 0216:  93
 sub a, h               ;; 0217:  94
 sub a, l               ;; 0218:  95
 sub a, (hl)            ;; 0219:  96
 sub a, a               ;; 021A:  97
 sbc a, b               ;; 021B:  98
 sbc a, c               ;; 021C:  99
 sbc a, d               ;; 021D:  9A
 sbc a, e               ;; 021E:  9B
 sbc a, h               ;; 021F:  9C
 sbc a, l               ;; 0220:  9D
 sbc a, (hl)            ;; 0221:  9E
 sbc a, a               ;; 0222:  9F
 and a, b               ;; 0223:  A0
 and a, c               ;; 0224:  A1
 and a, d               ;; 0225:  A2
 and a, e               ;; 0226:  A3
 and a, h               ;; 0227:  A4
 and a, l               ;; 0228:  A5
 and a, (hl)            ;; 0229:  A6
 and a, a               ;; 022A:  A7
 xor a, b               ;; 022B:  A8
 xor a, c               ;; 022C:  A9
 xor a, d               ;; 022D:  AA
 xor a, e               ;; 022E:  AB
 xor a, h               ;; 022F:  AC
 xor a, l               ;; 0230:  AD
 xor a, (hl)            ;; 0231:  AE
 xor a, a               ;; 0232:  AF
 or a, b                ;; 0233:  B0
 or a, c                ;; 0234:  B1
 or a, d                ;; 0235:  B2
 or a, e                ;; 0236:  B3
 or a, h                ;; 0237:  B4
 or a, l                ;; 0238:  B5
 or a, (hl)             ;; 0239:  B6
 or a, a                ;; 023A:  B7
 cp a, b                ;; 023B:  B8
 cp a, c                ;; 023C:  B9
 cp a, d                ;; 023D:  BA
 cp a, e                ;; 023E:  BB
 cp a, h                ;; 023F:  BC
 cp a, l                ;; 0240:  BD
 cp a, (hl)             ;; 0241:  BE
 cp a, a                ;; 0242:  BF
 add b                  ;; 0243:  80
 add c                  ;; 0244:  81
 add d                  ;; 0245:  82
 add e                  ;; 0246:  83
 add h                  ;; 0247:  84
 add l                  ;; 0248:  85
 add (hl)               ;; 0249:  86
 add a                  ;; 024A:  87
 adc b                  ;; 024B:  88
 adc c                  ;; 024C:  89
 adc d                  ;; 024D:  8A
 adc e                  ;; 024E:  8B
 adc h                  ;; 024F:  8C
 adc l                  ;; 0250:  8D
 adc (hl)               ;; 0251:  8E
 adc a                  ;; 0252:  8F
 sub b                  ;; 0253:  90
 sub c                  ;; 0254:  91
 sub d                  ;; 0255:  92
 sub e                  ;; 0256:  93
 sub h                  ;; 0257:  94
 sub l                  ;; 0258:  95
 sub (hl)               ;; 0259:  96
 sub a                  ;; 025A:  97
 sbc b                  ;; 025B:  98
 sbc c                  ;; 025C:  99
 sbc d                  ;; 025D:  9A
 sbc e                  ;; 025E:  9B
 sbc h                  ;; 025F:  9C
 sbc l                  ;; 0260:  9D
 sbc (hl)               ;; 0261:  9E
 sbc a                  ;; 0262:  9F
 and b                  ;; 0263:  A0
 and c                  ;; 0264:  A1
 and d                  ;; 0265:  A2
 and e                  ;; 0266:  A3
 and h                  ;; 0267:  A4
 and l                  ;; 0268:  A5
 and (hl)               ;; 0269:  A6
 and a                  ;; 026A:  A7
 xor b                  ;; 026B:  A8
 xor c                  ;; 026C:  A9
 xor d                  ;; 026D:  AA
 xor e                  ;; 026E:  AB
 xor h                  ;; 026F:  AC
 xor l                  ;; 0270:  AD
 xor (hl)               ;; 0271:  AE
 xor a                  ;; 0272:  AF
 or b                   ;; 0273:  B0
 or c                   ;; 0274:  B1
 or d                   ;; 0275:  B2
 or e                   ;; 0276:  B3
 or h                   ;; 0277:  B4
 or l                   ;; 0278:  B5
 or (hl)                ;; 0279:  B6
 or a                   ;; 027A:  B7
 cp b                   ;; 027B:  B8
 cp c                   ;; 027C:  B9
 cp d                   ;; 027D:  BA
 cp e                   ;; 027E:  BB
 cp h                   ;; 027F:  BC
 cp l                   ;; 0280:  BD
 cp (hl)                ;; 0281:  BE
 cp a                   ;; 0282:  BF
 add a, (ix+-128)       ;; 0283:  DD 86 80
 add a, (ix)            ;; 0286:  DD 86 00
 add a, (ix+127)        ;; 0289:  DD 86 7F
 adc a, (ix+-128)       ;; 028C:  DD 8E 80
 adc a, (ix)            ;; 028F:  DD 8E 00
 adc a, (ix+127)        ;; 0292:  DD 8E 7F
 sub a, (ix+-128)       ;; 0295:  DD 96 80
 sub a, (ix)            ;; 0298:  DD 96 00
 sub a, (ix+127)        ;; 029B:  DD 96 7F
 sbc a, (ix+-128)       ;; 029E:  DD 9E 80
 sbc a, (ix)            ;; 02A1:  DD 9E 00
 sbc a, (ix+127)        ;; 02A4:  DD 9E 7F
 and a, (ix+-128)       ;; 02A7:  DD A6 80
 and a, (ix)            ;; 02AA:  DD A6 00
 and a, (ix+127)        ;; 02AD:  DD A6 7F
 xor a, (ix+-128)       ;; 02B0:  DD AE 80
 xor a, (ix)            ;; 02B3:  DD AE 00
 xor a, (ix+127)        ;; 02B6:  DD AE 7F
 or a, (ix+-128)        ;; 02B9:  DD B6 80
 or a, (ix)             ;; 02BC:  DD B6 00
 or a, (ix+127)         ;; 02BF:  DD B6 7F
 cp a, (ix+-128)        ;; 02C2:  DD BE 80
 cp a, (ix)             ;; 02C5:  DD BE 00
 cp a, (ix+127)         ;; 02C8:  DD BE 7F
 add (ix+-128)          ;; 02CB:  DD 86 80
 add (ix)               ;; 02CE:  DD 86 00
 add (ix+127)           ;; 02D1:  DD 86 7F
 adc (ix+-128)          ;; 02D4:  DD 8E 80
 adc (ix)               ;; 02D7:  DD 8E 00
 adc (ix+127)           ;; 02DA:  DD 8E 7F
 sub (ix+-128)          ;; 02DD:  DD 96 80
 sub (ix)               ;; 02E0:  DD 96 00
 sub (ix+127)           ;; 02E3:  DD 96 7F
 sbc (ix+-128)          ;; 02E6:  DD 9E 80
 sbc (ix)               ;; 02E9:  DD 9E 00
 sbc (ix+127)           ;; 02EC:  DD 9E 7F
 and (ix+-128)          ;; 02EF:  DD A6 80
 and (ix)               ;; 02F2:  DD A6 00
 and (ix+127)           ;; 02F5:  DD A6 7F
 xor (ix+-128)          ;; 02F8:  DD AE 80
 xor (ix)               ;; 02FB:  DD AE 00
 xor (ix+127)           ;; 02FE:  DD AE 7F
 or (ix+-128)           ;; 0301:  DD B6 80
 or (ix)                ;; 0304:  DD B6 00
 or (ix+127)            ;; 0307:  DD B6 7F
 cp (ix+-128)           ;; 030A:  DD BE 80
 cp (ix)                ;; 030D:  DD BE 00
 cp (ix+127)            ;; 0310:  DD BE 7F
 add a, (iy+-128)       ;; 0313:  FD 86 80
 add a, (iy)            ;; 0316:  FD 86 00
 add a, (iy+127)        ;; 0319:  FD 86 7F
 adc a, (iy+-128)       ;; 031C:  FD 8E 80
 adc a, (iy)            ;; 031F:  FD 8E 00
 adc a, (iy+127)        ;; 0322:  FD 8E 7F
 sub a, (iy+-128)       ;; 0325:  FD 96 80
 sub a, (iy)            ;; 0328:  FD 96 00
 sub a, (iy+127)        ;; 032B:  FD 96 7F
 sbc a, (iy+-128)       ;; 032E:  FD 9E 80
 sbc a, (iy)            ;; 0331:  FD 9E 00
 sbc a, (iy+127)        ;; 0334:  FD 9E 7F
 and a, (iy+-128)       ;; 0337:  FD A6 80
 and a, (iy)            ;; 033A:  FD A6 00
 and a, (iy+127)        ;; 033D:  FD A6 7F
 xor a, (iy+-128)       ;; 0340:  FD AE 80
 xor a, (iy)            ;; 0343:  FD AE 00
 xor a, (iy+127)        ;; 0346:  FD AE 7F
 or a, (iy+-128)        ;; 0349:  FD B6 80
 or a, (iy)             ;; 034C:  FD B6 00
 or a, (iy+127)         ;; 034F:  FD B6 7F
 cp a, (iy+-128)        ;; 0352:  FD BE 80
 cp a, (iy)             ;; 0355:  FD BE 00
 cp a, (iy+127)         ;; 0358:  FD BE 7F
 add (iy+-128)          ;; 035B:  FD 86 80
 add (iy)               ;; 035E:  FD 86 00
 add (iy+127)           ;; 0361:  FD 86 7F
 adc (iy+-128)          ;; 0364:  FD 8E 80
 adc (iy)               ;; 0367:  FD 8E 00
 adc (iy+127)           ;; 036A:  FD 8E 7F
 sub (iy+-128)          ;; 036D:  FD 96 80
 sub (iy)               ;; 0370:  FD 96 00
 sub (iy+127)           ;; 0373:  FD 96 7F
 sbc (iy+-128)          ;; 0376:  FD 9E 80
 sbc (iy)               ;; 0379:  FD 9E 00
 sbc (iy+127)           ;; 037C:  FD 9E 7F
 and (iy+-128)          ;; 037F:  FD A6 80
 and (iy)               ;; 0382:  FD A6 00
 and (iy+127)           ;; 0385:  FD A6 7F
 xor (iy+-128)          ;; 0388:  FD AE 80
 xor (iy)               ;; 038B:  FD AE 00
 xor (iy+127)           ;; 038E:  FD AE 7F
 or (iy+-128)           ;; 0391:  FD B6 80
 or (iy)                ;; 0394:  FD B6 00
 or (iy+127)            ;; 0397:  FD B6 7F
 cp (iy+-128)           ;; 039A:  FD BE 80
 cp (iy)                ;; 039D:  FD BE 00
 cp (iy+127)            ;; 03A0:  FD BE 7F
 add a, 0               ;; 03A3:  C6 00
 add a, 85              ;; 03A5:  C6 55
 add a, 170             ;; 03A7:  C6 AA
 add a, 255             ;; 03A9:  C6 FF
 adc a, 0               ;; 03AB:  CE 00
 adc a, 85              ;; 03AD:  CE 55
 adc a, 170             ;; 03AF:  CE AA
 adc a, 255             ;; 03B1:  CE FF
 sub a, 0               ;; 03B3:  D6 00
 sub a, 85              ;; 03B5:  D6 55
 sub a, 170             ;; 03B7:  D6 AA
 sub a, 255             ;; 03B9:  D6 FF
 sbc a, 0               ;; 03BB:  DE 00
 sbc a, 85              ;; 03BD:  DE 55
 sbc a, 170             ;; 03BF:  DE AA
 sbc a, 255             ;; 03C1:  DE FF
 and a, 0               ;; 03C3:  E6 00
 and a, 85              ;; 03C5:  E6 55
 and a, 170             ;; 03C7:  E6 AA
 and a, 255             ;; 03C9:  E6 FF
 xor a, 0               ;; 03CB:  EE 00
 xor a, 85              ;; 03CD:  EE 55
 xor a, 170             ;; 03CF:  EE AA
 xor a, 255             ;; 03D1:  EE FF
 or a, 0                ;; 03D3:  F6 00
 or a, 85               ;; 03D5:  F6 55
 or a, 170              ;; 03D7:  F6 AA
 or a, 255              ;; 03D9:  F6 FF
 cp a, 0                ;; 03DB:  FE 00
 cp a, 85               ;; 03DD:  FE 55
 cp a, 170              ;; 03DF:  FE AA
 cp a, 255              ;; 03E1:  FE FF
 add 0                  ;; 03E3:  C6 00
 add 85                 ;; 03E5:  C6 55
 add 170                ;; 03E7:  C6 AA
 add 255                ;; 03E9:  C6 FF
 adc 0                  ;; 03EB:  CE 00
 adc 85                 ;; 03ED:  CE 55
 adc 170                ;; 03EF:  CE AA
 adc 255                ;; 03F1:  CE FF
 sub 0                  ;; 03F3:  D6 00
 sub 85                 ;; 03F5:  D6 55
 sub 170                ;; 03F7:  D6 AA
 sub 255                ;; 03F9:  D6 FF
 sbc 0                  ;; 03FB:  DE 00
 sbc 85                 ;; 03FD:  DE 55
 sbc 170                ;; 03FF:  DE AA
 sbc 255                ;; 0401:  DE FF
 and 0                  ;; 0403:  E6 00
 and 85                 ;; 0405:  E6 55
 and 170                ;; 0407:  E6 AA
 and 255                ;; 0409:  E6 FF
 xor 0                  ;; 040B:  EE 00
 xor 85                 ;; 040D:  EE 55
 xor 170                ;; 040F:  EE AA
 xor 255                ;; 0411:  EE FF
 or 0                   ;; 0413:  F6 00
 or 85                  ;; 0415:  F6 55
 or 170                 ;; 0417:  F6 AA
 or 255                 ;; 0419:  F6 FF
 cp 0                   ;; 041B:  FE 00
 cp 85                  ;; 041D:  FE 55
 cp 170                 ;; 041F:  FE AA
 cp 255                 ;; 0421:  FE FF
 inc b                  ;; 0423:  04
 inc c                  ;; 0424:  0C
 inc d                  ;; 0425:  14
 inc e                  ;; 0426:  1C
 inc h                  ;; 0427:  24
 inc l                  ;; 0428:  2C
 inc a                  ;; 0429:  3C
 dec b                  ;; 042A:  05
 dec c                  ;; 042B:  0D
 dec d                  ;; 042C:  15
 dec e                  ;; 042D:  1D
 dec h                  ;; 042E:  25
 dec l                  ;; 042F:  2D
 dec a                  ;; 0430:  3D
 inc (hl)               ;; 0431:  34
 dec (hl)               ;; 0432:  35
 inc (ix + -128)        ;; 0433:  DD 34 80
 inc (ix)               ;; 0436:  DD 34 00
 inc (ix + 127)         ;; 0439:  DD 34 7F
 dec (ix + -128)        ;; 043C:  DD 35 80
 dec (ix)               ;; 043F:  DD 35 00
 dec (ix + 127)         ;; 0442:  DD 35 7F
 inc (iy + -128)        ;; 0445:  FD 34 80
 inc (iy)               ;; 0448:  FD 34 00
 inc (iy + 127)         ;; 044B:  FD 34 7F
 dec (iy + -128)        ;; 044E:  FD 35 80
 dec (iy)               ;; 0451:  FD 35 00
 dec (iy + 127)         ;; 0454:  FD 35 7F
 tst a, b               ;; 0457:  ED 04
 tst a, c               ;; 0459:  ED 0C
 tst a, d               ;; 045B:  ED 14
 tst a, e               ;; 045D:  ED 1C
 tst a, h               ;; 045F:  ED 24
 tst a, l               ;; 0461:  ED 2C
 tst a, a               ;; 0463:  ED 3C
 tst b                  ;; 0465:  ED 04
 tst c                  ;; 0467:  ED 0C
 tst d                  ;; 0469:  ED 14
 tst e                  ;; 046B:  ED 1C
 tst h                  ;; 046D:  ED 24
 tst l                  ;; 046F:  ED 2C
 tst a                  ;; 0471:  ED 3C
 tst a, 0               ;; 0473:  ED 64 00
 tst a, 85              ;; 0476:  ED 64 55
 tst a, 170             ;; 0479:  ED 64 AA
 tst a, 255             ;; 047C:  ED 64 FF
 tst 0                  ;; 047F:  ED 64 00
 tst 85                 ;; 0482:  ED 64 55
 tst 170                ;; 0485:  ED 64 AA
 tst 255                ;; 0488:  ED 64 FF
 tst a, (hl)            ;; 048B:  ED 34
 tst (hl)               ;; 048D:  ED 34
 daa                    ;; 048F:  27
 rld                    ;; 0490:  ED 6F
 rrd                    ;; 0492:  ED 67
 cpl                    ;; 0494:  2F
 cpl a                  ;; 0495:  2F
 neg                    ;; 0496:  ED 44
 neg a                  ;; 0498:  ED 44
 ccf                    ;; 049A:  3F
 ccf f                  ;; 049B:  3F
 scf                    ;; 049C:  37
 scf f                  ;; 049D:  37
 ld bc, 0               ;; 049E:  01 00 00
 ld bc, 291             ;; 04A1:  01 23 01
 ld bc, 17767           ;; 04A4:  01 67 45
 ld bc, 35243           ;; 04A7:  01 AB 89
 ld bc, 52719           ;; 04AA:  01 EF CD
 ld bc, 65535           ;; 04AD:  01 FF FF
 ld de, 0               ;; 04B0:  11 00 00
 ld de, 291             ;; 04B3:  11 23 01
 ld de, 17767           ;; 04B6:  11 67 45
 ld de, 35243           ;; 04B9:  11 AB 89
 ld de, 52719           ;; 04BC:  11 EF CD
 ld de, 65535           ;; 04BF:  11 FF FF
 ld hl, 0               ;; 04C2:  21 00 00
 ld hl, 291             ;; 04C5:  21 23 01
 ld hl, 17767           ;; 04C8:  21 67 45
 ld hl, 35243           ;; 04CB:  21 AB 89
 ld hl, 52719           ;; 04CE:  21 EF CD
 ld hl, 65535           ;; 04D1:  21 FF FF
 ld sp, 0               ;; 04D4:  31 00 00
 ld sp, 291             ;; 04D7:  31 23 01
 ld sp, 17767           ;; 04DA:  31 67 45
 ld sp, 35243           ;; 04DD:  31 AB 89
 ld sp, 52719           ;; 04E0:  31 EF CD
 ld sp, 65535           ;; 04E3:  31 FF FF
 ld ix, 0               ;; 04E6:  DD 21 00 00
 ld ix, 291             ;; 04EA:  DD 21 23 01
 ld ix, 17767           ;; 04EE:  DD 21 67 45
 ld ix, 35243           ;; 04F2:  DD 21 AB 89
 ld ix, 52719           ;; 04F6:  DD 21 EF CD
 ld ix, 65535           ;; 04FA:  DD 21 FF FF
 ld iy, 0               ;; 04FE:  FD 21 00 00
 ld iy, 291             ;; 0502:  FD 21 23 01
 ld iy, 17767           ;; 0506:  FD 21 67 45
 ld iy, 35243           ;; 050A:  FD 21 AB 89
 ld iy, 52719           ;; 050E:  FD 21 EF CD
 ld iy, 65535           ;; 0512:  FD 21 FF FF
 ld hl, (0)             ;; 0516:  2A 00 00
 ld hl, (291)           ;; 0519:  2A 23 01
 ld hl, (17767)         ;; 051C:  2A 67 45
 ld hl, (35243)         ;; 051F:  2A AB 89
 ld hl, (52719)         ;; 0522:  2A EF CD
 ld hl, (65535)         ;; 0525:  2A FF FF
 ld ix, (0)             ;; 0528:  DD 2A 00 00
 ld ix, (291)           ;; 052C:  DD 2A 23 01
 ld ix, (17767)         ;; 0530:  DD 2A 67 45
 ld ix, (35243)         ;; 0534:  DD 2A AB 89
 ld ix, (52719)         ;; 0538:  DD 2A EF CD
 ld ix, (65535)         ;; 053C:  DD 2A FF FF
 ld iy, (0)             ;; 0540:  FD 2A 00 00
 ld iy, (291)           ;; 0544:  FD 2A 23 01
 ld iy, (17767)         ;; 0548:  FD 2A 67 45
 ld iy, (35243)         ;; 054C:  FD 2A AB 89
 ld iy, (52719)         ;; 0550:  FD 2A EF CD
 ld iy, (65535)         ;; 0554:  FD 2A FF FF
 ld (0), hl             ;; 0558:  22 00 00
 ld (291), hl           ;; 055B:  22 23 01
 ld (17767), hl         ;; 055E:  22 67 45
 ld (35243), hl         ;; 0561:  22 AB 89
 ld (52719), hl         ;; 0564:  22 EF CD
 ld (65535), hl         ;; 0567:  22 FF FF
 ld (0), ix             ;; 056A:  DD 22 00 00
 ld (291), ix           ;; 056E:  DD 22 23 01
 ld (17767), ix         ;; 0572:  DD 22 67 45
 ld (35243), ix         ;; 0576:  DD 22 AB 89
 ld (52719), ix         ;; 057A:  DD 22 EF CD
 ld (65535), ix         ;; 057E:  DD 22 FF FF
 ld (0), iy             ;; 0582:  FD 22 00 00
 ld (291), iy           ;; 0586:  FD 22 23 01
 ld (17767), iy         ;; 058A:  FD 22 67 45
 ld (35243), iy         ;; 058E:  FD 22 AB 89
 ld (52719), iy         ;; 0592:  FD 22 EF CD
 ld (65535), iy         ;; 0596:  FD 22 FF FF
 ld bc, (0)             ;; 059A:  ED 4B 00 00
 ld bc, (291)           ;; 059E:  ED 4B 23 01
 ld bc, (17767)         ;; 05A2:  ED 4B 67 45
 ld bc, (35243)         ;; 05A6:  ED 4B AB 89
 ld bc, (52719)         ;; 05AA:  ED 4B EF CD
 ld bc, (65535)         ;; 05AE:  ED 4B FF FF
 ld de, (0)             ;; 05B2:  ED 5B 00 00
 ld de, (291)           ;; 05B6:  ED 5B 23 01
 ld de, (17767)         ;; 05BA:  ED 5B 67 45
 ld de, (35243)         ;; 05BE:  ED 5B AB 89
 ld de, (52719)         ;; 05C2:  ED 5B EF CD
 ld de, (65535)         ;; 05C6:  ED 5B FF FF
 ld sp, (0)             ;; 05CA:  ED 7B 00 00
 ld sp, (291)           ;; 05CE:  ED 7B 23 01
 ld sp, (17767)         ;; 05D2:  ED 7B 67 45
 ld sp, (35243)         ;; 05D6:  ED 7B AB 89
 ld sp, (52719)         ;; 05DA:  ED 7B EF CD
 ld sp, (65535)         ;; 05DE:  ED 7B FF FF
 ld (0), bc             ;; 05E2:  ED 43 00 00
 ld (291), bc           ;; 05E6:  ED 43 23 01
 ld (17767), bc         ;; 05EA:  ED 43 67 45
 ld (35243), bc         ;; 05EE:  ED 43 AB 89
 ld (52719), bc         ;; 05F2:  ED 43 EF CD
 ld (65535), bc         ;; 05F6:  ED 43 FF FF
 ld (0), de             ;; 05FA:  ED 53 00 00
 ld (291), de           ;; 05FE:  ED 53 23 01
 ld (17767), de         ;; 0602:  ED 53 67 45
 ld (35243), de         ;; 0606:  ED 53 AB 89
 ld (52719), de         ;; 060A:  ED 53 EF CD
 ld (65535), de         ;; 060E:  ED 53 FF FF
 ld (0), sp             ;; 0612:  ED 73 00 00
 ld (291), sp           ;; 0616:  ED 73 23 01
 ld (17767), sp         ;; 061A:  ED 73 67 45
 ld (35243), sp         ;; 061E:  ED 73 AB 89
 ld (52719), sp         ;; 0622:  ED 73 EF CD
 ld (65535), sp         ;; 0626:  ED 73 FF FF
 ld sp, hl              ;; 062A:  F9
 ld sp, ix              ;; 062B:  DD F9
 ld sp, iy              ;; 062D:  FD F9
 push bc                ;; 062F:  C5
 push de                ;; 0630:  D5
 push hl                ;; 0631:  E5
 push af                ;; 0632:  F5
 push ix                ;; 0633:  DD E5
 push iy                ;; 0635:  FD E5
 pop bc                 ;; 0637:  C1
 pop de                 ;; 0638:  D1
 pop hl                 ;; 0639:  E1
 pop af                 ;; 063A:  F1
 pop ix                 ;; 063B:  DD E1
 pop iy                 ;; 063D:  FD E1
 add hl, bc             ;; 063F:  09
 add hl, de             ;; 0640:  19
 add hl, hl             ;; 0641:  29
 add hl, sp             ;; 0642:  39
 add ix, bc             ;; 0643:  DD 09
 add ix, de             ;; 0645:  DD 19
 add ix, ix             ;; 0647:  DD 29
 add ix, sp             ;; 0649:  DD 39
 add iy, bc             ;; 064B:  FD 09
 add iy, de             ;; 064D:  FD 19
 add iy, iy             ;; 064F:  FD 29
 add iy, sp             ;; 0651:  FD 39
 sbc hl, bc             ;; 0653:  ED 42
 sbc hl, de             ;; 0655:  ED 52
 sbc hl, hl             ;; 0657:  ED 62
 sbc hl, sp             ;; 0659:  ED 72
 adc hl, bc             ;; 065B:  ED 4A
 adc hl, de             ;; 065D:  ED 5A
 adc hl, hl             ;; 065F:  ED 6A
 adc hl, sp             ;; 0661:  ED 7A
 inc bc                 ;; 0663:  03
 inc de                 ;; 0664:  13
 inc hl                 ;; 0665:  23
 inc sp                 ;; 0666:  33
 dec bc                 ;; 0667:  0B
 dec de                 ;; 0668:  1B
 dec hl                 ;; 0669:  2B
 dec sp                 ;; 066A:  3B
 inc ix                 ;; 066B:  DD 23
 dec ix                 ;; 066D:  DD 2B
 inc iy                 ;; 066F:  FD 23
 dec iy                 ;; 0671:  FD 2B
 mlt bc                 ;; 0673:  ED 4C
 mlt de                 ;; 0675:  ED 5C
 mlt hl                 ;; 0677:  ED 6C
 mlt sp                 ;; 0679:  ED 7C
 ex af, af              ;; 067B:  08
 ex af, af'             ;; 067C:  08
 exx                    ;; 067D:  D9
 ex (sp), hl            ;; 067E:  E3
 ex (sp), ix            ;; 067F:  DD E3
 ex (sp), iy            ;; 0681:  FD E3
 ex de, hl              ;; 0683:  EB
 rlca                   ;; 0684:  07
 rrca                   ;; 0685:  0F
 rla                    ;; 0686:  17
 rra                    ;; 0687:  1F
 rlc b                  ;; 0688:  CB 00
 rlc c                  ;; 068A:  CB 01
 rlc d                  ;; 068C:  CB 02
 rlc e                  ;; 068E:  CB 03
 rlc h                  ;; 0690:  CB 04
 rlc l                  ;; 0692:  CB 05
 rlc (hl)               ;; 0694:  CB 06
 rlc a                  ;; 0696:  CB 07
 rrc b                  ;; 0698:  CB 08
 rrc c                  ;; 069A:  CB 09
 rrc d                  ;; 069C:  CB 0A
 rrc e                  ;; 069E:  CB 0B
 rrc h                  ;; 06A0:  CB 0C
 rrc l                  ;; 06A2:  CB 0D
 rrc (hl)               ;; 06A4:  CB 0E
 rrc a                  ;; 06A6:  CB 0F
 rl b                   ;; 06A8:  CB 10
 rl c                   ;; 06AA:  CB 11
 rl d                   ;; 06AC:  CB 12
 rl e                   ;; 06AE:  CB 13
 rl h                   ;; 06B0:  CB 14
 rl l                   ;; 06B2:  CB 15
 rl (hl)                ;; 06B4:  CB 16
 rl a                   ;; 06B6:  CB 17
 rr b                   ;; 06B8:  CB 18
 rr c                   ;; 06BA:  CB 19
 rr d                   ;; 06BC:  CB 1A
 rr e                   ;; 06BE:  CB 1B
 rr h                   ;; 06C0:  CB 1C
 rr l                   ;; 06C2:  CB 1D
 rr (hl)                ;; 06C4:  CB 1E
 rr a                   ;; 06C6:  CB 1F
 sla b                  ;; 06C8:  CB 20
 sla c                  ;; 06CA:  CB 21
 sla d                  ;; 06CC:  CB 22
 sla e                  ;; 06CE:  CB 23
 sla h                  ;; 06D0:  CB 24
 sla l                  ;; 06D2:  CB 25
 sla (hl)               ;; 06D4:  CB 26
 sla a                  ;; 06D6:  CB 27
 sra b                  ;; 06D8:  CB 28
 sra c                  ;; 06DA:  CB 29
 sra d                  ;; 06DC:  CB 2A
 sra e                  ;; 06DE:  CB 2B
 sra h                  ;; 06E0:  CB 2C
 sra l                  ;; 06E2:  CB 2D
 sra (hl)               ;; 06E4:  CB 2E
 sra a                  ;; 06E6:  CB 2F
 srl b                  ;; 06E8:  CB 38
 srl c                  ;; 06EA:  CB 39
 srl d                  ;; 06EC:  CB 3A
 srl e                  ;; 06EE:  CB 3B
 srl h                  ;; 06F0:  CB 3C
 srl l                  ;; 06F2:  CB 3D
 srl (hl)               ;; 06F4:  CB 3E
 srl a                  ;; 06F6:  CB 3F
 sll b                  ;; 06F8:  CB 30
 sll c                  ;; 06FA:  CB 31
 sll d                  ;; 06FC:  CB 32
 sll e                  ;; 06FE:  CB 33
 sll h                  ;; 0700:  CB 34
 sll l                  ;; 0702:  CB 35
 sll (hl)               ;; 0704:  CB 36
 sll a                  ;; 0706:  CB 37
 rlc (ix+-128)          ;; 0708:  DD CB 80 06
 rlc (ix)               ;; 070C:  DD CB 00 06
 rlc (ix+127)           ;; 0710:  DD CB 7F 06
 rrc (ix+-128)          ;; 0714:  DD CB 80 0E
 rrc (ix)               ;; 0718:  DD CB 00 0E
 rrc (ix+127)           ;; 071C:  DD CB 7F 0E
 rl (ix+-128)           ;; 0720:  DD CB 80 16
 rl (ix)                ;; 0724:  DD CB 00 16
 rl (ix+127)            ;; 0728:  DD CB 7F 16
 rr (ix+-128)           ;; 072C:  DD CB 80 1E
 rr (ix)                ;; 0730:  DD CB 00 1E
 rr (ix+127)            ;; 0734:  DD CB 7F 1E
 sla (ix+-128)          ;; 0738:  DD CB 80 26
 sla (ix)               ;; 073C:  DD CB 00 26
 sla (ix+127)           ;; 0740:  DD CB 7F 26
 sra (ix+-128)          ;; 0744:  DD CB 80 2E
 sra (ix)               ;; 0748:  DD CB 00 2E
 sra (ix+127)           ;; 074C:  DD CB 7F 2E
 srl (ix+-128)          ;; 0750:  DD CB 80 3E
 srl (ix)               ;; 0754:  DD CB 00 3E
 srl (ix+127)           ;; 0758:  DD CB 7F 3E
 sll (ix+-128)          ;; 075C:  DD CB 80 36
 sll (ix)               ;; 0760:  DD CB 00 36
 sll (ix+127)           ;; 0764:  DD CB 7F 36
 rlc (iy+-128)          ;; 0768:  FD CB 80 06
 rlc (iy)               ;; 076C:  FD CB 00 06
 rlc (iy+127)           ;; 0770:  FD CB 7F 06
 rrc (iy+-128)          ;; 0774:  FD CB 80 0E
 rrc (iy)               ;; 0778:  FD CB 00 0E
 rrc (iy+127)           ;; 077C:  FD CB 7F 0E
 rl (iy+-128)           ;; 0780:  FD CB 80 16
 rl (iy)                ;; 0784:  FD CB 00 16
 rl (iy+127)            ;; 0788:  FD CB 7F 16
 rr (iy+-128)           ;; 078C:  FD CB 80 1E
 rr (iy)                ;; 0790:  FD CB 00 1E
 rr (iy+127)            ;; 0794:  FD CB 7F 1E
 sla (iy+-128)          ;; 0798:  FD CB 80 26
 sla (iy)               ;; 079C:  FD CB 00 26
 sla (iy+127)           ;; 07A0:  FD CB 7F 26
 sra (iy+-128)          ;; 07A4:  FD CB 80 2E
 sra (iy)               ;; 07A8:  FD CB 00 2E
 sra (iy+127)           ;; 07AC:  FD CB 7F 2E
 srl (iy+-128)          ;; 07B0:  FD CB 80 3E
 srl (iy)               ;; 07B4:  FD CB 00 3E
 srl (iy+127)           ;; 07B8:  FD CB 7F 3E
 sll (iy+-128)          ;; 07BC:  FD CB 80 36
 sll (iy)               ;; 07C0:  FD CB 00 36
 sll (iy+127)           ;; 07C4:  FD CB 7F 36
 bit 0, b               ;; 07C8:  CB 40
 bit 0, c               ;; 07CA:  CB 41
 bit 0, d               ;; 07CC:  CB 42
 bit 0, e               ;; 07CE:  CB 43
 bit 0, h               ;; 07D0:  CB 44
 bit 0, l               ;; 07D2:  CB 45
 bit 0, (hl)            ;; 07D4:  CB 46
 bit 0, a               ;; 07D6:  CB 47
 bit 1, b               ;; 07D8:  CB 48
 bit 1, c               ;; 07DA:  CB 49
 bit 1, d               ;; 07DC:  CB 4A
 bit 1, e               ;; 07DE:  CB 4B
 bit 1, h               ;; 07E0:  CB 4C
 bit 1, l               ;; 07E2:  CB 4D
 bit 1, (hl)            ;; 07E4:  CB 4E
 bit 1, a               ;; 07E6:  CB 4F
 bit 2, b               ;; 07E8:  CB 50
 bit 2, c               ;; 07EA:  CB 51
 bit 2, d               ;; 07EC:  CB 52
 bit 2, e               ;; 07EE:  CB 53
 bit 2, h               ;; 07F0:  CB 54
 bit 2, l               ;; 07F2:  CB 55
 bit 2, (hl)            ;; 07F4:  CB 56
 bit 2, a               ;; 07F6:  CB 57
 bit 3, b               ;; 07F8:  CB 58
 bit 3, c               ;; 07FA:  CB 59
 bit 3, d               ;; 07FC:  CB 5A
 bit 3, e               ;; 07FE:  CB 5B
 bit 3, h               ;; 0800:  CB 5C
 bit 3, l               ;; 0802:  CB 5D
 bit 3, (hl)            ;; 0804:  CB 5E
 bit 3, a               ;; 0806:  CB 5F
 bit 4, b               ;; 0808:  CB 60
 bit 4, c               ;; 080A:  CB 61
 bit 4, d               ;; 080C:  CB 62
 bit 4, e               ;; 080E:  CB 63
 bit 4, h               ;; 0810:  CB 64
 bit 4, l               ;; 0812:  CB 65
 bit 4, (hl)            ;; 0814:  CB 66
 bit 4, a               ;; 0816:  CB 67
 bit 5, b               ;; 0818:  CB 68
 bit 5, c               ;; 081A:  CB 69
 bit 5, d               ;; 081C:  CB 6A
 bit 5, e               ;; 081E:  CB 6B
 bit 5, h               ;; 0820:  CB 6C
 bit 5, l               ;; 0822:  CB 6D
 bit 5, (hl)            ;; 0824:  CB 6E
 bit 5, a               ;; 0826:  CB 6F
 bit 6, b               ;; 0828:  CB 70
 bit 6, c               ;; 082A:  CB 71
 bit 6, d               ;; 082C:  CB 72
 bit 6, e               ;; 082E:  CB 73
 bit 6, h               ;; 0830:  CB 74
 bit 6, l               ;; 0832:  CB 75
 bit 6, (hl)            ;; 0834:  CB 76
 bit 6, a               ;; 0836:  CB 77
 bit 7, b               ;; 0838:  CB 78
 bit 7, c               ;; 083A:  CB 79
 bit 7, d               ;; 083C:  CB 7A
 bit 7, e               ;; 083E:  CB 7B
 bit 7, h               ;; 0840:  CB 7C
 bit 7, l               ;; 0842:  CB 7D
 bit 7, (hl)            ;; 0844:  CB 7E
 bit 7, a               ;; 0846:  CB 7F
 res 0, b               ;; 0848:  CB 80
 res 0, c               ;; 084A:  CB 81
 res 0, d               ;; 084C:  CB 82
 res 0, e               ;; 084E:  CB 83
 res 0, h               ;; 0850:  CB 84
 res 0, l               ;; 0852:  CB 85
 res 0, (hl)            ;; 0854:  CB 86
 res 0, a               ;; 0856:  CB 87
 res 1, b               ;; 0858:  CB 88
 res 1, c               ;; 085A:  CB 89
 res 1, d               ;; 085C:  CB 8A
 res 1, e               ;; 085E:  CB 8B
 res 1, h               ;; 0860:  CB 8C
 res 1, l               ;; 0862:  CB 8D
 res 1, (hl)            ;; 0864:  CB 8E
 res 1, a               ;; 0866:  CB 8F
 res 2, b               ;; 0868:  CB 90
 res 2, c               ;; 086A:  CB 91
 res 2, d               ;; 086C:  CB 92
 res 2, e               ;; 086E:  CB 93
 res 2, h               ;; 0870:  CB 94
 res 2, l               ;; 0872:  CB 95
 res 2, (hl)            ;; 0874:  CB 96
 res 2, a               ;; 0876:  CB 97
 res 3, b               ;; 0878:  CB 98
 res 3, c               ;; 087A:  CB 99
 res 3, d               ;; 087C:  CB 9A
 res 3, e               ;; 087E:  CB 9B
 res 3, h               ;; 0880:  CB 9C
 res 3, l               ;; 0882:  CB 9D
 res 3, (hl)            ;; 0884:  CB 9E
 res 3, a               ;; 0886:  CB 9F
 res 4, b               ;; 0888:  CB A0
 res 4, c               ;; 088A:  CB A1
 res 4, d               ;; 088C:  CB A2
 res 4, e               ;; 088E:  CB A3
 res 4, h               ;; 0890:  CB A4
 res 4, l               ;; 0892:  CB A5
 res 4, (hl)            ;; 0894:  CB A6
 res 4, a               ;; 0896:  CB A7
 res 5, b               ;; 0898:  CB A8
 res 5, c               ;; 089A:  CB A9
 res 5, d               ;; 089C:  CB AA
 res 5, e               ;; 089E:  CB AB
 res 5, h               ;; 08A0:  CB AC
 res 5, l               ;; 08A2:  CB AD
 res 5, (hl)            ;; 08A4:  CB AE
 res 5, a               ;; 08A6:  CB AF
 res 6, b               ;; 08A8:  CB B0
 res 6, c               ;; 08AA:  CB B1
 res 6, d               ;; 08AC:  CB B2
 res 6, e               ;; 08AE:  CB B3
 res 6, h               ;; 08B0:  CB B4
 res 6, l               ;; 08B2:  CB B5
 res 6, (hl)            ;; 08B4:  CB B6
 res 6, a               ;; 08B6:  CB B7
 res 7, b               ;; 08B8:  CB B8
 res 7, c               ;; 08BA:  CB B9
 res 7, d               ;; 08BC:  CB BA
 res 7, e               ;; 08BE:  CB BB
 res 7, h               ;; 08C0:  CB BC
 res 7, l               ;; 08C2:  CB BD
 res 7, (hl)            ;; 08C4:  CB BE
 res 7, a               ;; 08C6:  CB BF
 set 0, b               ;; 08C8:  CB C0
 set 0, c               ;; 08CA:  CB C1
 set 0, d               ;; 08CC:  CB C2
 set 0, e               ;; 08CE:  CB C3
 set 0, h               ;; 08D0:  CB C4
 set 0, l               ;; 08D2:  CB C5
 set 0, (hl)            ;; 08D4:  CB C6
 set 0, a               ;; 08D6:  CB C7
 set 1, b               ;; 08D8:  CB C8
 set 1, c               ;; 08DA:  CB C9
 set 1, d               ;; 08DC:  CB CA
 set 1, e               ;; 08DE:  CB CB
 set 1, h               ;; 08E0:  CB CC
 set 1, l               ;; 08E2:  CB CD
 set 1, (hl)            ;; 08E4:  CB CE
 set 1, a               ;; 08E6:  CB CF
 set 2, b               ;; 08E8:  CB D0
 set 2, c               ;; 08EA:  CB D1
 set 2, d               ;; 08EC:  CB D2
 set 2, e               ;; 08EE:  CB D3
 set 2, h               ;; 08F0:  CB D4
 set 2, l               ;; 08F2:  CB D5
 set 2, (hl)            ;; 08F4:  CB D6
 set 2, a               ;; 08F6:  CB D7
 set 3, b               ;; 08F8:  CB D8
 set 3, c               ;; 08FA:  CB D9
 set 3, d               ;; 08FC:  CB DA
 set 3, e               ;; 08FE:  CB DB
 set 3, h               ;; 0900:  CB DC
 set 3, l               ;; 0902:  CB DD
 set 3, (hl)            ;; 0904:  CB DE
 set 3, a               ;; 0906:  CB DF
 set 4, b               ;; 0908:  CB E0
 set 4, c               ;; 090A:  CB E1
 set 4, d               ;; 090C:  CB E2
 set 4, e               ;; 090E:  CB E3
 set 4, h               ;; 0910:  CB E4
 set 4, l               ;; 0912:  CB E5
 set 4, (hl)            ;; 0914:  CB E6
 set 4, a               ;; 0916:  CB E7
 set 5, b               ;; 0918:  CB E8
 set 5, c               ;; 091A:  CB E9
 set 5, d               ;; 091C:  CB EA
 set 5, e               ;; 091E:  CB EB
 set 5, h               ;; 0920:  CB EC
 set 5, l               ;; 0922:  CB ED
 set 5, (hl)            ;; 0924:  CB EE
 set 5, a               ;; 0926:  CB EF
 set 6, b               ;; 0928:  CB F0
 set 6, c               ;; 092A:  CB F1
 set 6, d               ;; 092C:  CB F2
 set 6, e               ;; 092E:  CB F3
 set 6, h               ;; 0930:  CB F4
 set 6, l               ;; 0932:  CB F5
 set 6, (hl)            ;; 0934:  CB F6
 set 6, a               ;; 0936:  CB F7
 set 7, b               ;; 0938:  CB F8
 set 7, c               ;; 093A:  CB F9
 set 7, d               ;; 093C:  CB FA
 set 7, e               ;; 093E:  CB FB
 set 7, h               ;; 0940:  CB FC
 set 7, l               ;; 0942:  CB FD
 set 7, (hl)            ;; 0944:  CB FE
 set 7, a               ;; 0946:  CB FF
 bit 0, (ix+-128)       ;; 0948:  DD CB 80 46
 bit 0, (ix)            ;; 094C:  DD CB 00 46
 bit 0, (ix+127)        ;; 0950:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0954:  DD CB 80 4E
 bit 1, (ix)            ;; 0958:  DD CB 00 4E
 bit 1, (ix+127)        ;; 095C:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0960:  DD CB 80 56
 bit 2, (ix)            ;; 0964:  DD CB 00 56
 bit 2, (ix+127)        ;; 0968:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 096C:  DD CB 80 5E
 bit 3, (ix)            ;; 0970:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0974:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0978:  DD CB 80 66
 bit 4, (ix)            ;; 097C:  DD CB 00 66
 bit 4, (ix+127)        ;; 0980:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0984:  DD CB 80 6E
 bit 5, (ix)            ;; 0988:  DD CB 00 6E
 bit 5, (ix+127)        ;; 098C:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0990:  DD CB 80 76
 bit 6, (ix)            ;; 0994:  DD CB 00 76
 bit 6, (ix+127)        ;; 0998:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 099C:  DD CB 80 7E
 bit 7, (ix)            ;; 09A0:  DD CB 00 7E
 bit 7, (ix+127)        ;; 09A4:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 09A8:  DD CB 80 86
 res 0, (ix)            ;; 09AC:  DD CB 00 86
 res 0, (ix+127)        ;; 09B0:  DD CB 7F 86
 res 1, (ix+-128)       ;; 09B4:  DD CB 80 8E
 res 1, (ix)            ;; 09B8:  DD CB 00 8E
 res 1, (ix+127)        ;; 09BC:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 09C0:  DD CB 80 96
 res 2, (ix)            ;; 09C4:  DD CB 00 96
 res 2, (ix+127)        ;; 09C8:  DD CB 7F 96
 res 3, (ix+-128)       ;; 09CC:  DD CB 80 9E
 res 3, (ix)            ;; 09D0:  DD CB 00 9E
 res 3, (ix+127)        ;; 09D4:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 09D8:  DD CB 80 A6
 res 4, (ix)            ;; 09DC:  DD CB 00 A6
 res 4, (ix+127)        ;; 09E0:  DD CB 7F A6
 res 5, (ix+-128)       ;; 09E4:  DD CB 80 AE
 res 5, (ix)            ;; 09E8:  DD CB 00 AE
 res 5, (ix+127)        ;; 09EC:  DD CB 7F AE
 res 6, (ix+-128)       ;; 09F0:  DD CB 80 B6
 res 6, (ix)            ;; 09F4:  DD CB 00 B6
 res 6, (ix+127)        ;; 09F8:  DD CB 7F B6
 res 7, (ix+-128)       ;; 09FC:  DD CB 80 BE
 res 7, (ix)            ;; 0A00:  DD CB 00 BE
 res 7, (ix+127)        ;; 0A04:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A08:  DD CB 80 C6
 set 0, (ix)            ;; 0A0C:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A10:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A14:  DD CB 80 CE
 set 1, (ix)            ;; 0A18:  DD CB 00 CE
 set 1, (ix+127)        ;; 0A1C:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0A20:  DD CB 80 D6
 set 2, (ix)            ;; 0A24:  DD CB 00 D6
 set 2, (ix+127)        ;; 0A28:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0A2C:  DD CB 80 DE
 set 3, (ix)            ;; 0A30:  DD CB 00 DE
 set 3, (ix+127)        ;; 0A34:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0A38:  DD CB 80 E6
 set 4, (ix)            ;; 0A3C:  DD CB 00 E6
 set 4, (ix+127)        ;; 0A40:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0A44:  DD CB 80 EE
 set 5, (ix)            ;; 0A48:  DD CB 00 EE
 set 5, (ix+127)        ;; 0A4C:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0A50:  DD CB 80 F6
 set 6, (ix)            ;; 0A54:  DD CB 00 F6
 set 6, (ix+127)        ;; 0A58:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0A5C:  DD CB 80 FE
 set 7, (ix)            ;; 0A60:  DD CB 00 FE
 set 7, (ix+127)        ;; 0A64:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0A68:  FD CB 80 46
 bit 0, (iy)            ;; 0A6C:  FD CB 00 46
 bit 0, (iy+127)        ;; 0A70:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0A74:  FD CB 80 4E
 bit 1, (iy)            ;; 0A78:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0A7C:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0A80:  FD CB 80 56
 bit 2, (iy)            ;; 0A84:  FD CB 00 56
 bit 2, (iy+127)        ;; 0A88:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0A8C:  FD CB 80 5E
 bit 3, (iy)            ;; 0A90:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0A94:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0A98:  FD CB 80 66
 bit 4, (iy)            ;; 0A9C:  FD CB 00 66
 bit 4, (iy+127)        ;; 0AA0:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0AA4:  FD CB 80 6E
 bit 5, (iy)            ;; 0AA8:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0AAC:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0AB0:  FD CB 80 76
 bit 6, (iy)            ;; 0AB4:  FD CB 00 76
 bit 6, (iy+127)        ;; 0AB8:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0ABC:  FD CB 80 7E
 bit 7, (iy)            ;; 0AC0:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0AC4:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0AC8:  FD CB 80 86
 res 0, (iy)            ;; 0ACC:  FD CB 00 86
 res 0, (iy+127)        ;; 0AD0:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0AD4:  FD CB 80 8E
 res 1, (iy)            ;; 0AD8:  FD CB 00 8E
 res 1, (iy+127)        ;; 0ADC:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0AE0:  FD CB 80 96
 res 2, (iy)            ;; 0AE4:  FD CB 00 96
 res 2, (iy+127)        ;; 0AE8:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0AEC:  FD CB 80 9E
 res 3, (iy)            ;; 0AF0:  FD CB 00 9E
 res 3, (iy+127)        ;; 0AF4:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0AF8:  FD CB 80 A6
 res 4, (iy)            ;; 0AFC:  FD CB 00 A6
 res 4, (iy+127)        ;; 0B00:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0B04:  FD CB 80 AE
 res 5, (iy)            ;; 0B08:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B0C:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B10:  FD CB 80 B6
 res 6, (iy)            ;; 0B14:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B18:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0B1C:  FD CB 80 BE
 res 7, (iy)            ;; 0B20:  FD CB 00 BE
 res 7, (iy+127)        ;; 0B24:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0B28:  FD CB 80 C6
 set 0, (iy)            ;; 0B2C:  FD CB 00 C6
 set 0, (iy+127)        ;; 0B30:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0B34:  FD CB 80 CE
 set 1, (iy)            ;; 0B38:  FD CB 00 CE
 set 1, (iy+127)        ;; 0B3C:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0B40:  FD CB 80 D6
 set 2, (iy)            ;; 0B44:  FD CB 00 D6
 set 2, (iy+127)        ;; 0B48:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0B4C:  FD CB 80 DE
 set 3, (iy)            ;; 0B50:  FD CB 00 DE
 set 3, (iy+127)        ;; 0B54:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0B58:  FD CB 80 E6
 set 4, (iy)            ;; 0B5C:  FD CB 00 E6
 set 4, (iy+127)        ;; 0B60:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0B64:  FD CB 80 EE
 set 5, (iy)            ;; 0B68:  FD CB 00 EE
 set 5, (iy+127)        ;; 0B6C:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0B70:  FD CB 80 F6
 set 6, (iy)            ;; 0B74:  FD CB 00 F6
 set 6, (iy+127)        ;; 0B78:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0B7C:  FD CB 80 FE
 set 7, (iy)            ;; 0B80:  FD CB 00 FE
 set 7, (iy+127)        ;; 0B84:  FD CB 7F FE
 ldi                    ;; 0B88:  ED A0
 ldir                   ;; 0B8A:  ED B0
 ldd                    ;; 0B8C:  ED A8
 lddr                   ;; 0B8E:  ED B8
 cpi                    ;; 0B90:  ED A1
 cpir                   ;; 0B92:  ED B1
 cpd                    ;; 0B94:  ED A9
 cpdr                   ;; 0B96:  ED B9
 nop                    ;; 0B98:  00
 halt                   ;; 0B99:  76
 slp                    ;; 0B9A:  ED 76
 jp 0                   ;; 0B9C:  C3 00 00
 jp 291                 ;; 0B9F:  C3 23 01
 jp 17767               ;; 0BA2:  C3 67 45
 jp 35243               ;; 0BA5:  C3 AB 89
 jp 52719               ;; 0BA8:  C3 EF CD
 jp 65535               ;; 0BAB:  C3 FF FF
 jp nz, 0               ;; 0BAE:  C2 00 00
 jp nz, 291             ;; 0BB1:  C2 23 01
 jp nz, 17767           ;; 0BB4:  C2 67 45
 jp nz, 35243           ;; 0BB7:  C2 AB 89
 jp nz, 52719           ;; 0BBA:  C2 EF CD
 jp nz, 65535           ;; 0BBD:  C2 FF FF
 jp z, 0                ;; 0BC0:  CA 00 00
 jp z, 291              ;; 0BC3:  CA 23 01
 jp z, 17767            ;; 0BC6:  CA 67 45
 jp z, 35243            ;; 0BC9:  CA AB 89
 jp z, 52719            ;; 0BCC:  CA EF CD
 jp z, 65535            ;; 0BCF:  CA FF FF
 jp nc, 0               ;; 0BD2:  D2 00 00
 jp nc, 291             ;; 0BD5:  D2 23 01
 jp nc, 17767           ;; 0BD8:  D2 67 45
 jp nc, 35243           ;; 0BDB:  D2 AB 89
 jp nc, 52719           ;; 0BDE:  D2 EF CD
 jp nc, 65535           ;; 0BE1:  D2 FF FF
 jp c, 0                ;; 0BE4:  DA 00 00
 jp c, 291              ;; 0BE7:  DA 23 01
 jp c, 17767            ;; 0BEA:  DA 67 45
 jp c, 35243            ;; 0BED:  DA AB 89
 jp c, 52719            ;; 0BF0:  DA EF CD
 jp c, 65535            ;; 0BF3:  DA FF FF
 jp po, 0               ;; 0BF6:  E2 00 00
 jp po, 291             ;; 0BF9:  E2 23 01
 jp po, 17767           ;; 0BFC:  E2 67 45
 jp po, 35243           ;; 0BFF:  E2 AB 89
 jp po, 52719           ;; 0C02:  E2 EF CD
 jp po, 65535           ;; 0C05:  E2 FF FF
 jp pe, 0               ;; 0C08:  EA 00 00
 jp pe, 291             ;; 0C0B:  EA 23 01
 jp pe, 17767           ;; 0C0E:  EA 67 45
 jp pe, 35243           ;; 0C11:  EA AB 89
 jp pe, 52719           ;; 0C14:  EA EF CD
 jp pe, 65535           ;; 0C17:  EA FF FF
 jp p, 0                ;; 0C1A:  F2 00 00
 jp p, 291              ;; 0C1D:  F2 23 01
 jp p, 17767            ;; 0C20:  F2 67 45
 jp p, 35243            ;; 0C23:  F2 AB 89
 jp p, 52719            ;; 0C26:  F2 EF CD
 jp p, 65535            ;; 0C29:  F2 FF FF
 jp m, 0                ;; 0C2C:  FA 00 00
 jp m, 291              ;; 0C2F:  FA 23 01
 jp m, 17767            ;; 0C32:  FA 67 45
 jp m, 35243            ;; 0C35:  FA AB 89
 jp m, 52719            ;; 0C38:  FA EF CD
 jp m, 65535            ;; 0C3B:  FA FF FF
 jp (hl)                ;; 0C3E:  E9
 jp (ix)                ;; 0C3F:  DD E9
 jp (iy)                ;; 0C41:  FD E9
 djnz ASMPC             ;; 0C43:  10 FE
 djnz b, ASMPC          ;; 0C45:  10 FE
 jr ASMPC               ;; 0C47:  18 FE
 jr nz, ASMPC           ;; 0C49:  20 FE
 jr z, ASMPC            ;; 0C4B:  28 FE
 jr nc, ASMPC           ;; 0C4D:  30 FE
 jr c, ASMPC            ;; 0C4F:  38 FE
 call 0                 ;; 0C51:  CD 00 00
 call 291               ;; 0C54:  CD 23 01
 call 17767             ;; 0C57:  CD 67 45
 call 35243             ;; 0C5A:  CD AB 89
 call 52719             ;; 0C5D:  CD EF CD
 call 65535             ;; 0C60:  CD FF FF
 call nz, 0             ;; 0C63:  C4 00 00
 call nz, 291           ;; 0C66:  C4 23 01
 call nz, 17767         ;; 0C69:  C4 67 45
 call nz, 35243         ;; 0C6C:  C4 AB 89
 call nz, 52719         ;; 0C6F:  C4 EF CD
 call nz, 65535         ;; 0C72:  C4 FF FF
 call z, 0              ;; 0C75:  CC 00 00
 call z, 291            ;; 0C78:  CC 23 01
 call z, 17767          ;; 0C7B:  CC 67 45
 call z, 35243          ;; 0C7E:  CC AB 89
 call z, 52719          ;; 0C81:  CC EF CD
 call z, 65535          ;; 0C84:  CC FF FF
 call nc, 0             ;; 0C87:  D4 00 00
 call nc, 291           ;; 0C8A:  D4 23 01
 call nc, 17767         ;; 0C8D:  D4 67 45
 call nc, 35243         ;; 0C90:  D4 AB 89
 call nc, 52719         ;; 0C93:  D4 EF CD
 call nc, 65535         ;; 0C96:  D4 FF FF
 call c, 0              ;; 0C99:  DC 00 00
 call c, 291            ;; 0C9C:  DC 23 01
 call c, 17767          ;; 0C9F:  DC 67 45
 call c, 35243          ;; 0CA2:  DC AB 89
 call c, 52719          ;; 0CA5:  DC EF CD
 call c, 65535          ;; 0CA8:  DC FF FF
 call po, 0             ;; 0CAB:  E4 00 00
 call po, 291           ;; 0CAE:  E4 23 01
 call po, 17767         ;; 0CB1:  E4 67 45
 call po, 35243         ;; 0CB4:  E4 AB 89
 call po, 52719         ;; 0CB7:  E4 EF CD
 call po, 65535         ;; 0CBA:  E4 FF FF
 call pe, 0             ;; 0CBD:  EC 00 00
 call pe, 291           ;; 0CC0:  EC 23 01
 call pe, 17767         ;; 0CC3:  EC 67 45
 call pe, 35243         ;; 0CC6:  EC AB 89
 call pe, 52719         ;; 0CC9:  EC EF CD
 call pe, 65535         ;; 0CCC:  EC FF FF
 call p, 0              ;; 0CCF:  F4 00 00
 call p, 291            ;; 0CD2:  F4 23 01
 call p, 17767          ;; 0CD5:  F4 67 45
 call p, 35243          ;; 0CD8:  F4 AB 89
 call p, 52719          ;; 0CDB:  F4 EF CD
 call p, 65535          ;; 0CDE:  F4 FF FF
 call m, 0              ;; 0CE1:  FC 00 00
 call m, 291            ;; 0CE4:  FC 23 01
 call m, 17767          ;; 0CE7:  FC 67 45
 call m, 35243          ;; 0CEA:  FC AB 89
 call m, 52719          ;; 0CED:  FC EF CD
 call m, 65535          ;; 0CF0:  FC FF FF
 ret                    ;; 0CF3:  C9
 ret nz                 ;; 0CF4:  C0
 ret z                  ;; 0CF5:  C8
 ret nc                 ;; 0CF6:  D0
 ret c                  ;; 0CF7:  D8
 ret po                 ;; 0CF8:  E0
 ret pe                 ;; 0CF9:  E8
 ret p                  ;; 0CFA:  F0
 ret m                  ;; 0CFB:  F8
 rst 16                 ;; 0CFC:  D7
 rst 24                 ;; 0CFD:  DF
 rst 32                 ;; 0CFE:  E7
 rst 40                 ;; 0CFF:  EF
 rst 56                 ;; 0D00:  FF
 rst 0                  ;; 0D01:  C7
 rst 8                  ;; 0D02:  CF
 rst 48                 ;; 0D03:  F7
 in a, (0)              ;; 0D04:  DB 00
 in a, (85)             ;; 0D06:  DB 55
 in a, (170)            ;; 0D08:  DB AA
 in a, (255)            ;; 0D0A:  DB FF
 in b, (c)              ;; 0D0C:  ED 40
 in c, (c)              ;; 0D0E:  ED 48
 in d, (c)              ;; 0D10:  ED 50
 in e, (c)              ;; 0D12:  ED 58
 in h, (c)              ;; 0D14:  ED 60
 in l, (c)              ;; 0D16:  ED 68
 in f, (c)              ;; 0D18:  ED 70
 in a, (c)              ;; 0D1A:  ED 78
 in0 b, (0)             ;; 0D1C:  ED 00 00
 in0 b, (85)            ;; 0D1F:  ED 00 55
 in0 b, (170)           ;; 0D22:  ED 00 AA
 in0 b, (255)           ;; 0D25:  ED 00 FF
 in0 c, (0)             ;; 0D28:  ED 08 00
 in0 c, (85)            ;; 0D2B:  ED 08 55
 in0 c, (170)           ;; 0D2E:  ED 08 AA
 in0 c, (255)           ;; 0D31:  ED 08 FF
 in0 d, (0)             ;; 0D34:  ED 10 00
 in0 d, (85)            ;; 0D37:  ED 10 55
 in0 d, (170)           ;; 0D3A:  ED 10 AA
 in0 d, (255)           ;; 0D3D:  ED 10 FF
 in0 e, (0)             ;; 0D40:  ED 18 00
 in0 e, (85)            ;; 0D43:  ED 18 55
 in0 e, (170)           ;; 0D46:  ED 18 AA
 in0 e, (255)           ;; 0D49:  ED 18 FF
 in0 h, (0)             ;; 0D4C:  ED 20 00
 in0 h, (85)            ;; 0D4F:  ED 20 55
 in0 h, (170)           ;; 0D52:  ED 20 AA
 in0 h, (255)           ;; 0D55:  ED 20 FF
 in0 l, (0)             ;; 0D58:  ED 28 00
 in0 l, (85)            ;; 0D5B:  ED 28 55
 in0 l, (170)           ;; 0D5E:  ED 28 AA
 in0 l, (255)           ;; 0D61:  ED 28 FF
 in0 f, (0)             ;; 0D64:  ED 30 00
 in0 f, (85)            ;; 0D67:  ED 30 55
 in0 f, (170)           ;; 0D6A:  ED 30 AA
 in0 f, (255)           ;; 0D6D:  ED 30 FF
 in0 a, (0)             ;; 0D70:  ED 38 00
 in0 a, (85)            ;; 0D73:  ED 38 55
 in0 a, (170)           ;; 0D76:  ED 38 AA
 in0 a, (255)           ;; 0D79:  ED 38 FF
 out (0), a             ;; 0D7C:  D3 00
 out (85), a            ;; 0D7E:  D3 55
 out (170), a           ;; 0D80:  D3 AA
 out (255), a           ;; 0D82:  D3 FF
 out (c), b             ;; 0D84:  ED 41
 out (c), c             ;; 0D86:  ED 49
 out (c), d             ;; 0D88:  ED 51
 out (c), e             ;; 0D8A:  ED 59
 out (c), h             ;; 0D8C:  ED 61
 out (c), l             ;; 0D8E:  ED 69
 out (c), 0             ;; 0D90:  ED 71
 out (c), a             ;; 0D92:  ED 79
 out0 (0), b            ;; 0D94:  ED 01 00
 out0 (85), b           ;; 0D97:  ED 01 55
 out0 (170), b          ;; 0D9A:  ED 01 AA
 out0 (255), b          ;; 0D9D:  ED 01 FF
 out0 (0), c            ;; 0DA0:  ED 09 00
 out0 (85), c           ;; 0DA3:  ED 09 55
 out0 (170), c          ;; 0DA6:  ED 09 AA
 out0 (255), c          ;; 0DA9:  ED 09 FF
 out0 (0), d            ;; 0DAC:  ED 11 00
 out0 (85), d           ;; 0DAF:  ED 11 55
 out0 (170), d          ;; 0DB2:  ED 11 AA
 out0 (255), d          ;; 0DB5:  ED 11 FF
 out0 (0), e            ;; 0DB8:  ED 19 00
 out0 (85), e           ;; 0DBB:  ED 19 55
 out0 (170), e          ;; 0DBE:  ED 19 AA
 out0 (255), e          ;; 0DC1:  ED 19 FF
 out0 (0), h            ;; 0DC4:  ED 21 00
 out0 (85), h           ;; 0DC7:  ED 21 55
 out0 (170), h          ;; 0DCA:  ED 21 AA
 out0 (255), h          ;; 0DCD:  ED 21 FF
 out0 (0), l            ;; 0DD0:  ED 29 00
 out0 (85), l           ;; 0DD3:  ED 29 55
 out0 (170), l          ;; 0DD6:  ED 29 AA
 out0 (255), l          ;; 0DD9:  ED 29 FF
 out0 (0), a            ;; 0DDC:  ED 39 00
 out0 (85), a           ;; 0DDF:  ED 39 55
 out0 (170), a          ;; 0DE2:  ED 39 AA
 out0 (255), a          ;; 0DE5:  ED 39 FF
 tstio 0                ;; 0DE8:  ED 74 00
 tstio 85               ;; 0DEB:  ED 74 55
 tstio 170              ;; 0DEE:  ED 74 AA
 tstio 255              ;; 0DF1:  ED 74 FF
 ini                    ;; 0DF4:  ED A2
 inir                   ;; 0DF6:  ED B2
 ind                    ;; 0DF8:  ED AA
 indr                   ;; 0DFA:  ED BA
 outi                   ;; 0DFC:  ED A3
 otir                   ;; 0DFE:  ED B3
 outd                   ;; 0E00:  ED AB
 otdr                   ;; 0E02:  ED BB
 otdm                   ;; 0E04:  ED 8B
 otdmr                  ;; 0E06:  ED 9B
 otim                   ;; 0E08:  ED 83
 otimr                  ;; 0E0A:  ED 93
 di                     ;; 0E0C:  F3
 ei                     ;; 0E0D:  FB
 im 0                   ;; 0E0E:  ED 46
 im 1                   ;; 0E10:  ED 56
 im 2                   ;; 0E12:  ED 5E
 ld i, a                ;; 0E14:  ED 47
 ld a, i                ;; 0E16:  ED 57
 ld r, a                ;; 0E18:  ED 4F
 ld a, r                ;; 0E1A:  ED 5F
 reti                   ;; 0E1C:  ED 4D
 retn                   ;; 0E1E:  ED 45
