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
 ld b, (ix + 0)         ;; 0073:  DD 46 00
 ld b, (ix + 127)       ;; 0076:  DD 46 7F
 ld c, (ix + -128)      ;; 0079:  DD 4E 80
 ld c, (ix + 0)         ;; 007C:  DD 4E 00
 ld c, (ix + 127)       ;; 007F:  DD 4E 7F
 ld d, (ix + -128)      ;; 0082:  DD 56 80
 ld d, (ix + 0)         ;; 0085:  DD 56 00
 ld d, (ix + 127)       ;; 0088:  DD 56 7F
 ld e, (ix + -128)      ;; 008B:  DD 5E 80
 ld e, (ix + 0)         ;; 008E:  DD 5E 00
 ld e, (ix + 127)       ;; 0091:  DD 5E 7F
 ld h, (ix + -128)      ;; 0094:  DD 66 80
 ld h, (ix + 0)         ;; 0097:  DD 66 00
 ld h, (ix + 127)       ;; 009A:  DD 66 7F
 ld l, (ix + -128)      ;; 009D:  DD 6E 80
 ld l, (ix + 0)         ;; 00A0:  DD 6E 00
 ld l, (ix + 127)       ;; 00A3:  DD 6E 7F
 ld a, (ix + -128)      ;; 00A6:  DD 7E 80
 ld a, (ix + 0)         ;; 00A9:  DD 7E 00
 ld a, (ix + 127)       ;; 00AC:  DD 7E 7F
 ld b, (iy + -128)      ;; 00AF:  FD 46 80
 ld b, (iy + 0)         ;; 00B2:  FD 46 00
 ld b, (iy + 127)       ;; 00B5:  FD 46 7F
 ld c, (iy + -128)      ;; 00B8:  FD 4E 80
 ld c, (iy + 0)         ;; 00BB:  FD 4E 00
 ld c, (iy + 127)       ;; 00BE:  FD 4E 7F
 ld d, (iy + -128)      ;; 00C1:  FD 56 80
 ld d, (iy + 0)         ;; 00C4:  FD 56 00
 ld d, (iy + 127)       ;; 00C7:  FD 56 7F
 ld e, (iy + -128)      ;; 00CA:  FD 5E 80
 ld e, (iy + 0)         ;; 00CD:  FD 5E 00
 ld e, (iy + 127)       ;; 00D0:  FD 5E 7F
 ld h, (iy + -128)      ;; 00D3:  FD 66 80
 ld h, (iy + 0)         ;; 00D6:  FD 66 00
 ld h, (iy + 127)       ;; 00D9:  FD 66 7F
 ld l, (iy + -128)      ;; 00DC:  FD 6E 80
 ld l, (iy + 0)         ;; 00DF:  FD 6E 00
 ld l, (iy + 127)       ;; 00E2:  FD 6E 7F
 ld a, (iy + -128)      ;; 00E5:  FD 7E 80
 ld a, (iy + 0)         ;; 00E8:  FD 7E 00
 ld a, (iy + 127)       ;; 00EB:  FD 7E 7F
 ld (hl), b             ;; 00EE:  70
 ld (hl), c             ;; 00EF:  71
 ld (hl), d             ;; 00F0:  72
 ld (hl), e             ;; 00F1:  73
 ld (hl), h             ;; 00F2:  74
 ld (hl), l             ;; 00F3:  75
 ld (hl), a             ;; 00F4:  77
 ld (ix + -128), b      ;; 00F5:  DD 70 80
 ld (ix + 0), b         ;; 00F8:  DD 70 00
 ld (ix + 127), b       ;; 00FB:  DD 70 7F
 ld (ix + -128), c      ;; 00FE:  DD 71 80
 ld (ix + 0), c         ;; 0101:  DD 71 00
 ld (ix + 127), c       ;; 0104:  DD 71 7F
 ld (ix + -128), d      ;; 0107:  DD 72 80
 ld (ix + 0), d         ;; 010A:  DD 72 00
 ld (ix + 127), d       ;; 010D:  DD 72 7F
 ld (ix + -128), e      ;; 0110:  DD 73 80
 ld (ix + 0), e         ;; 0113:  DD 73 00
 ld (ix + 127), e       ;; 0116:  DD 73 7F
 ld (ix + -128), h      ;; 0119:  DD 74 80
 ld (ix + 0), h         ;; 011C:  DD 74 00
 ld (ix + 127), h       ;; 011F:  DD 74 7F
 ld (ix + -128), l      ;; 0122:  DD 75 80
 ld (ix + 0), l         ;; 0125:  DD 75 00
 ld (ix + 127), l       ;; 0128:  DD 75 7F
 ld (ix + -128), a      ;; 012B:  DD 77 80
 ld (ix + 0), a         ;; 012E:  DD 77 00
 ld (ix + 127), a       ;; 0131:  DD 77 7F
 ld (iy + -128), b      ;; 0134:  FD 70 80
 ld (iy + 0), b         ;; 0137:  FD 70 00
 ld (iy + 127), b       ;; 013A:  FD 70 7F
 ld (iy + -128), c      ;; 013D:  FD 71 80
 ld (iy + 0), c         ;; 0140:  FD 71 00
 ld (iy + 127), c       ;; 0143:  FD 71 7F
 ld (iy + -128), d      ;; 0146:  FD 72 80
 ld (iy + 0), d         ;; 0149:  FD 72 00
 ld (iy + 127), d       ;; 014C:  FD 72 7F
 ld (iy + -128), e      ;; 014F:  FD 73 80
 ld (iy + 0), e         ;; 0152:  FD 73 00
 ld (iy + 127), e       ;; 0155:  FD 73 7F
 ld (iy + -128), h      ;; 0158:  FD 74 80
 ld (iy + 0), h         ;; 015B:  FD 74 00
 ld (iy + 127), h       ;; 015E:  FD 74 7F
 ld (iy + -128), l      ;; 0161:  FD 75 80
 ld (iy + 0), l         ;; 0164:  FD 75 00
 ld (iy + 127), l       ;; 0167:  FD 75 7F
 ld (iy + -128), a      ;; 016A:  FD 77 80
 ld (iy + 0), a         ;; 016D:  FD 77 00
 ld (iy + 127), a       ;; 0170:  FD 77 7F
 ld (hl), 0             ;; 0173:  36 00
 ld (hl), 85            ;; 0175:  36 55
 ld (hl), 170           ;; 0177:  36 AA
 ld (hl), 255           ;; 0179:  36 FF
 ld (ix + -128), 0      ;; 017B:  DD 36 80 00
 ld (ix + 0), 0         ;; 017F:  DD 36 00 00
 ld (ix + 127), 0       ;; 0183:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0187:  DD 36 80 55
 ld (ix + 0), 85        ;; 018B:  DD 36 00 55
 ld (ix + 127), 85      ;; 018F:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0193:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0197:  DD 36 00 AA
 ld (ix + 127), 170     ;; 019B:  DD 36 7F AA
 ld (ix + -128), 255    ;; 019F:  DD 36 80 FF
 ld (ix + 0), 255       ;; 01A3:  DD 36 00 FF
 ld (ix + 127), 255     ;; 01A7:  DD 36 7F FF
 ld (iy + -128), 0      ;; 01AB:  FD 36 80 00
 ld (iy + 0), 0         ;; 01AF:  FD 36 00 00
 ld (iy + 127), 0       ;; 01B3:  FD 36 7F 00
 ld (iy + -128), 85     ;; 01B7:  FD 36 80 55
 ld (iy + 0), 85        ;; 01BB:  FD 36 00 55
 ld (iy + 127), 85      ;; 01BF:  FD 36 7F 55
 ld (iy + -128), 170    ;; 01C3:  FD 36 80 AA
 ld (iy + 0), 170       ;; 01C7:  FD 36 00 AA
 ld (iy + 127), 170     ;; 01CB:  FD 36 7F AA
 ld (iy + -128), 255    ;; 01CF:  FD 36 80 FF
 ld (iy + 0), 255       ;; 01D3:  FD 36 00 FF
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
 add a, (ix+0)          ;; 0286:  DD 86 00
 add a, (ix+127)        ;; 0289:  DD 86 7F
 adc a, (ix+-128)       ;; 028C:  DD 8E 80
 adc a, (ix+0)          ;; 028F:  DD 8E 00
 adc a, (ix+127)        ;; 0292:  DD 8E 7F
 sub a, (ix+-128)       ;; 0295:  DD 96 80
 sub a, (ix+0)          ;; 0298:  DD 96 00
 sub a, (ix+127)        ;; 029B:  DD 96 7F
 sbc a, (ix+-128)       ;; 029E:  DD 9E 80
 sbc a, (ix+0)          ;; 02A1:  DD 9E 00
 sbc a, (ix+127)        ;; 02A4:  DD 9E 7F
 and a, (ix+-128)       ;; 02A7:  DD A6 80
 and a, (ix+0)          ;; 02AA:  DD A6 00
 and a, (ix+127)        ;; 02AD:  DD A6 7F
 xor a, (ix+-128)       ;; 02B0:  DD AE 80
 xor a, (ix+0)          ;; 02B3:  DD AE 00
 xor a, (ix+127)        ;; 02B6:  DD AE 7F
 or a, (ix+-128)        ;; 02B9:  DD B6 80
 or a, (ix+0)           ;; 02BC:  DD B6 00
 or a, (ix+127)         ;; 02BF:  DD B6 7F
 cp a, (ix+-128)        ;; 02C2:  DD BE 80
 cp a, (ix+0)           ;; 02C5:  DD BE 00
 cp a, (ix+127)         ;; 02C8:  DD BE 7F
 add (ix+-128)          ;; 02CB:  DD 86 80
 add (ix+0)             ;; 02CE:  DD 86 00
 add (ix+127)           ;; 02D1:  DD 86 7F
 adc (ix+-128)          ;; 02D4:  DD 8E 80
 adc (ix+0)             ;; 02D7:  DD 8E 00
 adc (ix+127)           ;; 02DA:  DD 8E 7F
 sub (ix+-128)          ;; 02DD:  DD 96 80
 sub (ix+0)             ;; 02E0:  DD 96 00
 sub (ix+127)           ;; 02E3:  DD 96 7F
 sbc (ix+-128)          ;; 02E6:  DD 9E 80
 sbc (ix+0)             ;; 02E9:  DD 9E 00
 sbc (ix+127)           ;; 02EC:  DD 9E 7F
 and (ix+-128)          ;; 02EF:  DD A6 80
 and (ix+0)             ;; 02F2:  DD A6 00
 and (ix+127)           ;; 02F5:  DD A6 7F
 xor (ix+-128)          ;; 02F8:  DD AE 80
 xor (ix+0)             ;; 02FB:  DD AE 00
 xor (ix+127)           ;; 02FE:  DD AE 7F
 or (ix+-128)           ;; 0301:  DD B6 80
 or (ix+0)              ;; 0304:  DD B6 00
 or (ix+127)            ;; 0307:  DD B6 7F
 cp (ix+-128)           ;; 030A:  DD BE 80
 cp (ix+0)              ;; 030D:  DD BE 00
 cp (ix+127)            ;; 0310:  DD BE 7F
 add a, (iy+-128)       ;; 0313:  FD 86 80
 add a, (iy+0)          ;; 0316:  FD 86 00
 add a, (iy+127)        ;; 0319:  FD 86 7F
 adc a, (iy+-128)       ;; 031C:  FD 8E 80
 adc a, (iy+0)          ;; 031F:  FD 8E 00
 adc a, (iy+127)        ;; 0322:  FD 8E 7F
 sub a, (iy+-128)       ;; 0325:  FD 96 80
 sub a, (iy+0)          ;; 0328:  FD 96 00
 sub a, (iy+127)        ;; 032B:  FD 96 7F
 sbc a, (iy+-128)       ;; 032E:  FD 9E 80
 sbc a, (iy+0)          ;; 0331:  FD 9E 00
 sbc a, (iy+127)        ;; 0334:  FD 9E 7F
 and a, (iy+-128)       ;; 0337:  FD A6 80
 and a, (iy+0)          ;; 033A:  FD A6 00
 and a, (iy+127)        ;; 033D:  FD A6 7F
 xor a, (iy+-128)       ;; 0340:  FD AE 80
 xor a, (iy+0)          ;; 0343:  FD AE 00
 xor a, (iy+127)        ;; 0346:  FD AE 7F
 or a, (iy+-128)        ;; 0349:  FD B6 80
 or a, (iy+0)           ;; 034C:  FD B6 00
 or a, (iy+127)         ;; 034F:  FD B6 7F
 cp a, (iy+-128)        ;; 0352:  FD BE 80
 cp a, (iy+0)           ;; 0355:  FD BE 00
 cp a, (iy+127)         ;; 0358:  FD BE 7F
 add (iy+-128)          ;; 035B:  FD 86 80
 add (iy+0)             ;; 035E:  FD 86 00
 add (iy+127)           ;; 0361:  FD 86 7F
 adc (iy+-128)          ;; 0364:  FD 8E 80
 adc (iy+0)             ;; 0367:  FD 8E 00
 adc (iy+127)           ;; 036A:  FD 8E 7F
 sub (iy+-128)          ;; 036D:  FD 96 80
 sub (iy+0)             ;; 0370:  FD 96 00
 sub (iy+127)           ;; 0373:  FD 96 7F
 sbc (iy+-128)          ;; 0376:  FD 9E 80
 sbc (iy+0)             ;; 0379:  FD 9E 00
 sbc (iy+127)           ;; 037C:  FD 9E 7F
 and (iy+-128)          ;; 037F:  FD A6 80
 and (iy+0)             ;; 0382:  FD A6 00
 and (iy+127)           ;; 0385:  FD A6 7F
 xor (iy+-128)          ;; 0388:  FD AE 80
 xor (iy+0)             ;; 038B:  FD AE 00
 xor (iy+127)           ;; 038E:  FD AE 7F
 or (iy+-128)           ;; 0391:  FD B6 80
 or (iy+0)              ;; 0394:  FD B6 00
 or (iy+127)            ;; 0397:  FD B6 7F
 cp (iy+-128)           ;; 039A:  FD BE 80
 cp (iy+0)              ;; 039D:  FD BE 00
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
 inc (ix + 0)           ;; 0436:  DD 34 00
 inc (ix + 127)         ;; 0439:  DD 34 7F
 dec (ix + -128)        ;; 043C:  DD 35 80
 dec (ix + 0)           ;; 043F:  DD 35 00
 dec (ix + 127)         ;; 0442:  DD 35 7F
 inc (iy + -128)        ;; 0445:  FD 34 80
 inc (iy + 0)           ;; 0448:  FD 34 00
 inc (iy + 127)         ;; 044B:  FD 34 7F
 dec (iy + -128)        ;; 044E:  FD 35 80
 dec (iy + 0)           ;; 0451:  FD 35 00
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
 cpl                    ;; 048F:  2F
 neg                    ;; 0490:  ED 44
 ccf                    ;; 0492:  3F
 scf                    ;; 0493:  37
 ld bc, 0               ;; 0494:  01 00 00
 ld bc, 291             ;; 0497:  01 23 01
 ld bc, 17767           ;; 049A:  01 67 45
 ld bc, 35243           ;; 049D:  01 AB 89
 ld bc, 52719           ;; 04A0:  01 EF CD
 ld bc, 65535           ;; 04A3:  01 FF FF
 ld de, 0               ;; 04A6:  11 00 00
 ld de, 291             ;; 04A9:  11 23 01
 ld de, 17767           ;; 04AC:  11 67 45
 ld de, 35243           ;; 04AF:  11 AB 89
 ld de, 52719           ;; 04B2:  11 EF CD
 ld de, 65535           ;; 04B5:  11 FF FF
 ld hl, 0               ;; 04B8:  21 00 00
 ld hl, 291             ;; 04BB:  21 23 01
 ld hl, 17767           ;; 04BE:  21 67 45
 ld hl, 35243           ;; 04C1:  21 AB 89
 ld hl, 52719           ;; 04C4:  21 EF CD
 ld hl, 65535           ;; 04C7:  21 FF FF
 ld sp, 0               ;; 04CA:  31 00 00
 ld sp, 291             ;; 04CD:  31 23 01
 ld sp, 17767           ;; 04D0:  31 67 45
 ld sp, 35243           ;; 04D3:  31 AB 89
 ld sp, 52719           ;; 04D6:  31 EF CD
 ld sp, 65535           ;; 04D9:  31 FF FF
 ld ix, 0               ;; 04DC:  DD 21 00 00
 ld ix, 291             ;; 04E0:  DD 21 23 01
 ld ix, 17767           ;; 04E4:  DD 21 67 45
 ld ix, 35243           ;; 04E8:  DD 21 AB 89
 ld ix, 52719           ;; 04EC:  DD 21 EF CD
 ld ix, 65535           ;; 04F0:  DD 21 FF FF
 ld iy, 0               ;; 04F4:  FD 21 00 00
 ld iy, 291             ;; 04F8:  FD 21 23 01
 ld iy, 17767           ;; 04FC:  FD 21 67 45
 ld iy, 35243           ;; 0500:  FD 21 AB 89
 ld iy, 52719           ;; 0504:  FD 21 EF CD
 ld iy, 65535           ;; 0508:  FD 21 FF FF
 ld hl, (0)             ;; 050C:  2A 00 00
 ld hl, (291)           ;; 050F:  2A 23 01
 ld hl, (17767)         ;; 0512:  2A 67 45
 ld hl, (35243)         ;; 0515:  2A AB 89
 ld hl, (52719)         ;; 0518:  2A EF CD
 ld hl, (65535)         ;; 051B:  2A FF FF
 ld ix, (0)             ;; 051E:  DD 2A 00 00
 ld ix, (291)           ;; 0522:  DD 2A 23 01
 ld ix, (17767)         ;; 0526:  DD 2A 67 45
 ld ix, (35243)         ;; 052A:  DD 2A AB 89
 ld ix, (52719)         ;; 052E:  DD 2A EF CD
 ld ix, (65535)         ;; 0532:  DD 2A FF FF
 ld iy, (0)             ;; 0536:  FD 2A 00 00
 ld iy, (291)           ;; 053A:  FD 2A 23 01
 ld iy, (17767)         ;; 053E:  FD 2A 67 45
 ld iy, (35243)         ;; 0542:  FD 2A AB 89
 ld iy, (52719)         ;; 0546:  FD 2A EF CD
 ld iy, (65535)         ;; 054A:  FD 2A FF FF
 ld (0), hl             ;; 054E:  22 00 00
 ld (291), hl           ;; 0551:  22 23 01
 ld (17767), hl         ;; 0554:  22 67 45
 ld (35243), hl         ;; 0557:  22 AB 89
 ld (52719), hl         ;; 055A:  22 EF CD
 ld (65535), hl         ;; 055D:  22 FF FF
 ld (0), ix             ;; 0560:  DD 22 00 00
 ld (291), ix           ;; 0564:  DD 22 23 01
 ld (17767), ix         ;; 0568:  DD 22 67 45
 ld (35243), ix         ;; 056C:  DD 22 AB 89
 ld (52719), ix         ;; 0570:  DD 22 EF CD
 ld (65535), ix         ;; 0574:  DD 22 FF FF
 ld (0), iy             ;; 0578:  FD 22 00 00
 ld (291), iy           ;; 057C:  FD 22 23 01
 ld (17767), iy         ;; 0580:  FD 22 67 45
 ld (35243), iy         ;; 0584:  FD 22 AB 89
 ld (52719), iy         ;; 0588:  FD 22 EF CD
 ld (65535), iy         ;; 058C:  FD 22 FF FF
 ld bc, (0)             ;; 0590:  ED 4B 00 00
 ld bc, (291)           ;; 0594:  ED 4B 23 01
 ld bc, (17767)         ;; 0598:  ED 4B 67 45
 ld bc, (35243)         ;; 059C:  ED 4B AB 89
 ld bc, (52719)         ;; 05A0:  ED 4B EF CD
 ld bc, (65535)         ;; 05A4:  ED 4B FF FF
 ld de, (0)             ;; 05A8:  ED 5B 00 00
 ld de, (291)           ;; 05AC:  ED 5B 23 01
 ld de, (17767)         ;; 05B0:  ED 5B 67 45
 ld de, (35243)         ;; 05B4:  ED 5B AB 89
 ld de, (52719)         ;; 05B8:  ED 5B EF CD
 ld de, (65535)         ;; 05BC:  ED 5B FF FF
 ld sp, (0)             ;; 05C0:  ED 7B 00 00
 ld sp, (291)           ;; 05C4:  ED 7B 23 01
 ld sp, (17767)         ;; 05C8:  ED 7B 67 45
 ld sp, (35243)         ;; 05CC:  ED 7B AB 89
 ld sp, (52719)         ;; 05D0:  ED 7B EF CD
 ld sp, (65535)         ;; 05D4:  ED 7B FF FF
 ld (0), bc             ;; 05D8:  ED 43 00 00
 ld (291), bc           ;; 05DC:  ED 43 23 01
 ld (17767), bc         ;; 05E0:  ED 43 67 45
 ld (35243), bc         ;; 05E4:  ED 43 AB 89
 ld (52719), bc         ;; 05E8:  ED 43 EF CD
 ld (65535), bc         ;; 05EC:  ED 43 FF FF
 ld (0), de             ;; 05F0:  ED 53 00 00
 ld (291), de           ;; 05F4:  ED 53 23 01
 ld (17767), de         ;; 05F8:  ED 53 67 45
 ld (35243), de         ;; 05FC:  ED 53 AB 89
 ld (52719), de         ;; 0600:  ED 53 EF CD
 ld (65535), de         ;; 0604:  ED 53 FF FF
 ld (0), sp             ;; 0608:  ED 73 00 00
 ld (291), sp           ;; 060C:  ED 73 23 01
 ld (17767), sp         ;; 0610:  ED 73 67 45
 ld (35243), sp         ;; 0614:  ED 73 AB 89
 ld (52719), sp         ;; 0618:  ED 73 EF CD
 ld (65535), sp         ;; 061C:  ED 73 FF FF
 ld sp, hl              ;; 0620:  F9
 ld sp, ix              ;; 0621:  DD F9
 ld sp, iy              ;; 0623:  FD F9
 push bc                ;; 0625:  C5
 push de                ;; 0626:  D5
 push hl                ;; 0627:  E5
 push af                ;; 0628:  F5
 push ix                ;; 0629:  DD E5
 push iy                ;; 062B:  FD E5
 push ip                ;; 062D:  ED 76
 push su                ;; 062F:  ED 66
 pop bc                 ;; 0631:  C1
 pop de                 ;; 0632:  D1
 pop hl                 ;; 0633:  E1
 pop af                 ;; 0634:  F1
 pop ix                 ;; 0635:  DD E1
 pop iy                 ;; 0637:  FD E1
 pop ip                 ;; 0639:  ED 7E
 pop su                 ;; 063B:  ED 6E
 ld hl, ix              ;; 063D:  DD 7C
 ld hl, iy              ;; 063F:  FD 7C
 ld ix, hl              ;; 0641:  DD 7D
 ld iy, hl              ;; 0643:  FD 7D
 ld hl, (hl + -128)     ;; 0645:  DD E4 80
 ld hl, (hl + 0)        ;; 0648:  DD E4 00
 ld hl, (hl + 127)      ;; 064B:  DD E4 7F
 ld hl, (ix + -128)     ;; 064E:  E4 80
 ld hl, (ix + 0)        ;; 0650:  E4 00
 ld hl, (ix + 127)      ;; 0652:  E4 7F
 ld hl, (iy + -128)     ;; 0654:  FD E4 80
 ld hl, (iy + 0)        ;; 0657:  FD E4 00
 ld hl, (iy + 127)      ;; 065A:  FD E4 7F
 ld (hl + -128), hl     ;; 065D:  DD F4 80
 ld (hl + 0), hl        ;; 0660:  DD F4 00
 ld (hl + 127), hl      ;; 0663:  DD F4 7F
 ld (ix + -128), hl     ;; 0666:  F4 80
 ld (ix + 0), hl        ;; 0668:  F4 00
 ld (ix + 127), hl      ;; 066A:  F4 7F
 ld (iy + -128), hl     ;; 066C:  FD F4 80
 ld (iy + 0), hl        ;; 066F:  FD F4 00
 ld (iy + 127), hl      ;; 0672:  FD F4 7F
 ldp (0), hl            ;; 0675:  ED 65 00 00
 ldp (291), hl          ;; 0679:  ED 65 23 01
 ldp (17767), hl        ;; 067D:  ED 65 67 45
 ldp (35243), hl        ;; 0681:  ED 65 AB 89
 ldp (52719), hl        ;; 0685:  ED 65 EF CD
 ldp (65535), hl        ;; 0689:  ED 65 FF FF
 ldp (0), ix            ;; 068D:  DD 65 00 00
 ldp (291), ix          ;; 0691:  DD 65 23 01
 ldp (17767), ix        ;; 0695:  DD 65 67 45
 ldp (35243), ix        ;; 0699:  DD 65 AB 89
 ldp (52719), ix        ;; 069D:  DD 65 EF CD
 ldp (65535), ix        ;; 06A1:  DD 65 FF FF
 ldp (0), iy            ;; 06A5:  FD 65 00 00
 ldp (291), iy          ;; 06A9:  FD 65 23 01
 ldp (17767), iy        ;; 06AD:  FD 65 67 45
 ldp (35243), iy        ;; 06B1:  FD 65 AB 89
 ldp (52719), iy        ;; 06B5:  FD 65 EF CD
 ldp (65535), iy        ;; 06B9:  FD 65 FF FF
 ldp hl, (0)            ;; 06BD:  ED 6D 00 00
 ldp hl, (291)          ;; 06C1:  ED 6D 23 01
 ldp hl, (17767)        ;; 06C5:  ED 6D 67 45
 ldp hl, (35243)        ;; 06C9:  ED 6D AB 89
 ldp hl, (52719)        ;; 06CD:  ED 6D EF CD
 ldp hl, (65535)        ;; 06D1:  ED 6D FF FF
 ldp ix, (0)            ;; 06D5:  DD 6D 00 00
 ldp ix, (291)          ;; 06D9:  DD 6D 23 01
 ldp ix, (17767)        ;; 06DD:  DD 6D 67 45
 ldp ix, (35243)        ;; 06E1:  DD 6D AB 89
 ldp ix, (52719)        ;; 06E5:  DD 6D EF CD
 ldp ix, (65535)        ;; 06E9:  DD 6D FF FF
 ldp iy, (0)            ;; 06ED:  FD 6D 00 00
 ldp iy, (291)          ;; 06F1:  FD 6D 23 01
 ldp iy, (17767)        ;; 06F5:  FD 6D 67 45
 ldp iy, (35243)        ;; 06F9:  FD 6D AB 89
 ldp iy, (52719)        ;; 06FD:  FD 6D EF CD
 ldp iy, (65535)        ;; 0701:  FD 6D FF FF
 ldp (hl), hl           ;; 0705:  ED 64
 ldp (ix), hl           ;; 0707:  DD 64
 ldp (iy), hl           ;; 0709:  FD 64
 ldp hl, (hl)           ;; 070B:  ED 6C
 ldp hl, (ix)           ;; 070D:  DD 6C
 ldp hl, (iy)           ;; 070F:  FD 6C
 ld (sp + 0), hl        ;; 0711:  D4 00
 ld (sp + 85), hl       ;; 0713:  D4 55
 ld (sp + 170), hl      ;; 0715:  D4 AA
 ld (sp + 255), hl      ;; 0717:  D4 FF
 ld (sp + 0), ix        ;; 0719:  DD D4 00
 ld (sp + 85), ix       ;; 071C:  DD D4 55
 ld (sp + 170), ix      ;; 071F:  DD D4 AA
 ld (sp + 255), ix      ;; 0722:  DD D4 FF
 ld (sp + 0), iy        ;; 0725:  FD D4 00
 ld (sp + 85), iy       ;; 0728:  FD D4 55
 ld (sp + 170), iy      ;; 072B:  FD D4 AA
 ld (sp + 255), iy      ;; 072E:  FD D4 FF
 ld hl, (sp + 0)        ;; 0731:  C4 00
 ld hl, (sp + 85)       ;; 0733:  C4 55
 ld hl, (sp + 170)      ;; 0735:  C4 AA
 ld hl, (sp + 255)      ;; 0737:  C4 FF
 ld ix, (sp + 0)        ;; 0739:  DD C4 00
 ld ix, (sp + 85)       ;; 073C:  DD C4 55
 ld ix, (sp + 170)      ;; 073F:  DD C4 AA
 ld ix, (sp + 255)      ;; 0742:  DD C4 FF
 ld iy, (sp + 0)        ;; 0745:  FD C4 00
 ld iy, (sp + 85)       ;; 0748:  FD C4 55
 ld iy, (sp + 170)      ;; 074B:  FD C4 AA
 ld iy, (sp + 255)      ;; 074E:  FD C4 FF
 ld bc', bc             ;; 0751:  ED 49
 ld bc', de             ;; 0753:  ED 41
 ld de', bc             ;; 0755:  ED 59
 ld de', de             ;; 0757:  ED 51
 ld hl', bc             ;; 0759:  ED 69
 ld hl', de             ;; 075B:  ED 61
 add hl, bc             ;; 075D:  09
 add hl, de             ;; 075E:  19
 add hl, hl             ;; 075F:  29
 add hl, sp             ;; 0760:  39
 add ix, bc             ;; 0761:  DD 09
 add ix, de             ;; 0763:  DD 19
 add ix, ix             ;; 0765:  DD 29
 add ix, sp             ;; 0767:  DD 39
 add iy, bc             ;; 0769:  FD 09
 add iy, de             ;; 076B:  FD 19
 add iy, iy             ;; 076D:  FD 29
 add iy, sp             ;; 076F:  FD 39
 sbc hl, bc             ;; 0771:  ED 42
 sbc hl, de             ;; 0773:  ED 52
 sbc hl, hl             ;; 0775:  ED 62
 sbc hl, sp             ;; 0777:  ED 72
 adc hl, bc             ;; 0779:  ED 4A
 adc hl, de             ;; 077B:  ED 5A
 adc hl, hl             ;; 077D:  ED 6A
 adc hl, sp             ;; 077F:  ED 7A
 inc bc                 ;; 0781:  03
 inc de                 ;; 0782:  13
 inc hl                 ;; 0783:  23
 inc sp                 ;; 0784:  33
 dec bc                 ;; 0785:  0B
 dec de                 ;; 0786:  1B
 dec hl                 ;; 0787:  2B
 dec sp                 ;; 0788:  3B
 inc ix                 ;; 0789:  DD 23
 dec ix                 ;; 078B:  DD 2B
 inc iy                 ;; 078D:  FD 23
 dec iy                 ;; 078F:  FD 2B
 add sp, -128           ;; 0791:  27 80
 add sp, 0              ;; 0793:  27 00
 add sp, 127            ;; 0795:  27 7F
 and hl, de             ;; 0797:  DC
 or hl, de              ;; 0798:  EC
 and ix, de             ;; 0799:  DD DC
 or ix, de              ;; 079B:  DD EC
 and iy, de             ;; 079D:  FD DC
 or iy, de              ;; 079F:  FD EC
 bool hl                ;; 07A1:  CC
 bool ix                ;; 07A2:  DD CC
 bool iy                ;; 07A4:  FD CC
 mlt bc                 ;; 07A6:  ED 4C
 mlt de                 ;; 07A8:  ED 5C
 mlt hl                 ;; 07AA:  ED 6C
 mul                    ;; 07AC:  F7
 uma                    ;; 07AD:  ED C0
 ums                    ;; 07AF:  ED C8
 ex af, af              ;; 07B1:  08
 ex af, af'             ;; 07B2:  08
 exx                    ;; 07B3:  D9
 ex (sp), hl            ;; 07B4:  ED 54
 ex (sp), ix            ;; 07B6:  DD E3
 ex (sp), iy            ;; 07B8:  FD E3
 ex de, hl              ;; 07BA:  EB
 ex de', hl             ;; 07BB:  E3
 ex de, hl'             ;; 07BC:  76 EB
 ex de', hl'            ;; 07BE:  76 E3
 rlca                   ;; 07C0:  07
 rrca                   ;; 07C1:  0F
 rla                    ;; 07C2:  17
 rra                    ;; 07C3:  1F
 rlc b                  ;; 07C4:  CB 00
 rlc c                  ;; 07C6:  CB 01
 rlc d                  ;; 07C8:  CB 02
 rlc e                  ;; 07CA:  CB 03
 rlc h                  ;; 07CC:  CB 04
 rlc l                  ;; 07CE:  CB 05
 rlc (hl)               ;; 07D0:  CB 06
 rlc a                  ;; 07D2:  CB 07
 rrc b                  ;; 07D4:  CB 08
 rrc c                  ;; 07D6:  CB 09
 rrc d                  ;; 07D8:  CB 0A
 rrc e                  ;; 07DA:  CB 0B
 rrc h                  ;; 07DC:  CB 0C
 rrc l                  ;; 07DE:  CB 0D
 rrc (hl)               ;; 07E0:  CB 0E
 rrc a                  ;; 07E2:  CB 0F
 rl b                   ;; 07E4:  CB 10
 rl c                   ;; 07E6:  CB 11
 rl d                   ;; 07E8:  CB 12
 rl e                   ;; 07EA:  CB 13
 rl h                   ;; 07EC:  CB 14
 rl l                   ;; 07EE:  CB 15
 rl (hl)                ;; 07F0:  CB 16
 rl a                   ;; 07F2:  CB 17
 rr b                   ;; 07F4:  CB 18
 rr c                   ;; 07F6:  CB 19
 rr d                   ;; 07F8:  CB 1A
 rr e                   ;; 07FA:  CB 1B
 rr h                   ;; 07FC:  CB 1C
 rr l                   ;; 07FE:  CB 1D
 rr (hl)                ;; 0800:  CB 1E
 rr a                   ;; 0802:  CB 1F
 sla b                  ;; 0804:  CB 20
 sla c                  ;; 0806:  CB 21
 sla d                  ;; 0808:  CB 22
 sla e                  ;; 080A:  CB 23
 sla h                  ;; 080C:  CB 24
 sla l                  ;; 080E:  CB 25
 sla (hl)               ;; 0810:  CB 26
 sla a                  ;; 0812:  CB 27
 sra b                  ;; 0814:  CB 28
 sra c                  ;; 0816:  CB 29
 sra d                  ;; 0818:  CB 2A
 sra e                  ;; 081A:  CB 2B
 sra h                  ;; 081C:  CB 2C
 sra l                  ;; 081E:  CB 2D
 sra (hl)               ;; 0820:  CB 2E
 sra a                  ;; 0822:  CB 2F
 srl b                  ;; 0824:  CB 38
 srl c                  ;; 0826:  CB 39
 srl d                  ;; 0828:  CB 3A
 srl e                  ;; 082A:  CB 3B
 srl h                  ;; 082C:  CB 3C
 srl l                  ;; 082E:  CB 3D
 srl (hl)               ;; 0830:  CB 3E
 srl a                  ;; 0832:  CB 3F
 rlc (ix+-128)          ;; 0834:  DD CB 80 06
 rlc (ix+0)             ;; 0838:  DD CB 00 06
 rlc (ix+127)           ;; 083C:  DD CB 7F 06
 rrc (ix+-128)          ;; 0840:  DD CB 80 0E
 rrc (ix+0)             ;; 0844:  DD CB 00 0E
 rrc (ix+127)           ;; 0848:  DD CB 7F 0E
 rl (ix+-128)           ;; 084C:  DD CB 80 16
 rl (ix+0)              ;; 0850:  DD CB 00 16
 rl (ix+127)            ;; 0854:  DD CB 7F 16
 rr (ix+-128)           ;; 0858:  DD CB 80 1E
 rr (ix+0)              ;; 085C:  DD CB 00 1E
 rr (ix+127)            ;; 0860:  DD CB 7F 1E
 sla (ix+-128)          ;; 0864:  DD CB 80 26
 sla (ix+0)             ;; 0868:  DD CB 00 26
 sla (ix+127)           ;; 086C:  DD CB 7F 26
 sra (ix+-128)          ;; 0870:  DD CB 80 2E
 sra (ix+0)             ;; 0874:  DD CB 00 2E
 sra (ix+127)           ;; 0878:  DD CB 7F 2E
 srl (ix+-128)          ;; 087C:  DD CB 80 3E
 srl (ix+0)             ;; 0880:  DD CB 00 3E
 srl (ix+127)           ;; 0884:  DD CB 7F 3E
 rlc (iy+-128)          ;; 0888:  FD CB 80 06
 rlc (iy+0)             ;; 088C:  FD CB 00 06
 rlc (iy+127)           ;; 0890:  FD CB 7F 06
 rrc (iy+-128)          ;; 0894:  FD CB 80 0E
 rrc (iy+0)             ;; 0898:  FD CB 00 0E
 rrc (iy+127)           ;; 089C:  FD CB 7F 0E
 rl (iy+-128)           ;; 08A0:  FD CB 80 16
 rl (iy+0)              ;; 08A4:  FD CB 00 16
 rl (iy+127)            ;; 08A8:  FD CB 7F 16
 rr (iy+-128)           ;; 08AC:  FD CB 80 1E
 rr (iy+0)              ;; 08B0:  FD CB 00 1E
 rr (iy+127)            ;; 08B4:  FD CB 7F 1E
 sla (iy+-128)          ;; 08B8:  FD CB 80 26
 sla (iy+0)             ;; 08BC:  FD CB 00 26
 sla (iy+127)           ;; 08C0:  FD CB 7F 26
 sra (iy+-128)          ;; 08C4:  FD CB 80 2E
 sra (iy+0)             ;; 08C8:  FD CB 00 2E
 sra (iy+127)           ;; 08CC:  FD CB 7F 2E
 srl (iy+-128)          ;; 08D0:  FD CB 80 3E
 srl (iy+0)             ;; 08D4:  FD CB 00 3E
 srl (iy+127)           ;; 08D8:  FD CB 7F 3E
 rl de                  ;; 08DC:  F3
 rr de                  ;; 08DD:  FB
 rr hl                  ;; 08DE:  FC
 rr ix                  ;; 08DF:  DD FC
 rr iy                  ;; 08E1:  FD FC
 bit 0, b               ;; 08E3:  CB 40
 bit 0, c               ;; 08E5:  CB 41
 bit 0, d               ;; 08E7:  CB 42
 bit 0, e               ;; 08E9:  CB 43
 bit 0, h               ;; 08EB:  CB 44
 bit 0, l               ;; 08ED:  CB 45
 bit 0, (hl)            ;; 08EF:  CB 46
 bit 0, a               ;; 08F1:  CB 47
 bit 1, b               ;; 08F3:  CB 48
 bit 1, c               ;; 08F5:  CB 49
 bit 1, d               ;; 08F7:  CB 4A
 bit 1, e               ;; 08F9:  CB 4B
 bit 1, h               ;; 08FB:  CB 4C
 bit 1, l               ;; 08FD:  CB 4D
 bit 1, (hl)            ;; 08FF:  CB 4E
 bit 1, a               ;; 0901:  CB 4F
 bit 2, b               ;; 0903:  CB 50
 bit 2, c               ;; 0905:  CB 51
 bit 2, d               ;; 0907:  CB 52
 bit 2, e               ;; 0909:  CB 53
 bit 2, h               ;; 090B:  CB 54
 bit 2, l               ;; 090D:  CB 55
 bit 2, (hl)            ;; 090F:  CB 56
 bit 2, a               ;; 0911:  CB 57
 bit 3, b               ;; 0913:  CB 58
 bit 3, c               ;; 0915:  CB 59
 bit 3, d               ;; 0917:  CB 5A
 bit 3, e               ;; 0919:  CB 5B
 bit 3, h               ;; 091B:  CB 5C
 bit 3, l               ;; 091D:  CB 5D
 bit 3, (hl)            ;; 091F:  CB 5E
 bit 3, a               ;; 0921:  CB 5F
 bit 4, b               ;; 0923:  CB 60
 bit 4, c               ;; 0925:  CB 61
 bit 4, d               ;; 0927:  CB 62
 bit 4, e               ;; 0929:  CB 63
 bit 4, h               ;; 092B:  CB 64
 bit 4, l               ;; 092D:  CB 65
 bit 4, (hl)            ;; 092F:  CB 66
 bit 4, a               ;; 0931:  CB 67
 bit 5, b               ;; 0933:  CB 68
 bit 5, c               ;; 0935:  CB 69
 bit 5, d               ;; 0937:  CB 6A
 bit 5, e               ;; 0939:  CB 6B
 bit 5, h               ;; 093B:  CB 6C
 bit 5, l               ;; 093D:  CB 6D
 bit 5, (hl)            ;; 093F:  CB 6E
 bit 5, a               ;; 0941:  CB 6F
 bit 6, b               ;; 0943:  CB 70
 bit 6, c               ;; 0945:  CB 71
 bit 6, d               ;; 0947:  CB 72
 bit 6, e               ;; 0949:  CB 73
 bit 6, h               ;; 094B:  CB 74
 bit 6, l               ;; 094D:  CB 75
 bit 6, (hl)            ;; 094F:  CB 76
 bit 6, a               ;; 0951:  CB 77
 bit 7, b               ;; 0953:  CB 78
 bit 7, c               ;; 0955:  CB 79
 bit 7, d               ;; 0957:  CB 7A
 bit 7, e               ;; 0959:  CB 7B
 bit 7, h               ;; 095B:  CB 7C
 bit 7, l               ;; 095D:  CB 7D
 bit 7, (hl)            ;; 095F:  CB 7E
 bit 7, a               ;; 0961:  CB 7F
 res 0, b               ;; 0963:  CB 80
 res 0, c               ;; 0965:  CB 81
 res 0, d               ;; 0967:  CB 82
 res 0, e               ;; 0969:  CB 83
 res 0, h               ;; 096B:  CB 84
 res 0, l               ;; 096D:  CB 85
 res 0, (hl)            ;; 096F:  CB 86
 res 0, a               ;; 0971:  CB 87
 res 1, b               ;; 0973:  CB 88
 res 1, c               ;; 0975:  CB 89
 res 1, d               ;; 0977:  CB 8A
 res 1, e               ;; 0979:  CB 8B
 res 1, h               ;; 097B:  CB 8C
 res 1, l               ;; 097D:  CB 8D
 res 1, (hl)            ;; 097F:  CB 8E
 res 1, a               ;; 0981:  CB 8F
 res 2, b               ;; 0983:  CB 90
 res 2, c               ;; 0985:  CB 91
 res 2, d               ;; 0987:  CB 92
 res 2, e               ;; 0989:  CB 93
 res 2, h               ;; 098B:  CB 94
 res 2, l               ;; 098D:  CB 95
 res 2, (hl)            ;; 098F:  CB 96
 res 2, a               ;; 0991:  CB 97
 res 3, b               ;; 0993:  CB 98
 res 3, c               ;; 0995:  CB 99
 res 3, d               ;; 0997:  CB 9A
 res 3, e               ;; 0999:  CB 9B
 res 3, h               ;; 099B:  CB 9C
 res 3, l               ;; 099D:  CB 9D
 res 3, (hl)            ;; 099F:  CB 9E
 res 3, a               ;; 09A1:  CB 9F
 res 4, b               ;; 09A3:  CB A0
 res 4, c               ;; 09A5:  CB A1
 res 4, d               ;; 09A7:  CB A2
 res 4, e               ;; 09A9:  CB A3
 res 4, h               ;; 09AB:  CB A4
 res 4, l               ;; 09AD:  CB A5
 res 4, (hl)            ;; 09AF:  CB A6
 res 4, a               ;; 09B1:  CB A7
 res 5, b               ;; 09B3:  CB A8
 res 5, c               ;; 09B5:  CB A9
 res 5, d               ;; 09B7:  CB AA
 res 5, e               ;; 09B9:  CB AB
 res 5, h               ;; 09BB:  CB AC
 res 5, l               ;; 09BD:  CB AD
 res 5, (hl)            ;; 09BF:  CB AE
 res 5, a               ;; 09C1:  CB AF
 res 6, b               ;; 09C3:  CB B0
 res 6, c               ;; 09C5:  CB B1
 res 6, d               ;; 09C7:  CB B2
 res 6, e               ;; 09C9:  CB B3
 res 6, h               ;; 09CB:  CB B4
 res 6, l               ;; 09CD:  CB B5
 res 6, (hl)            ;; 09CF:  CB B6
 res 6, a               ;; 09D1:  CB B7
 res 7, b               ;; 09D3:  CB B8
 res 7, c               ;; 09D5:  CB B9
 res 7, d               ;; 09D7:  CB BA
 res 7, e               ;; 09D9:  CB BB
 res 7, h               ;; 09DB:  CB BC
 res 7, l               ;; 09DD:  CB BD
 res 7, (hl)            ;; 09DF:  CB BE
 res 7, a               ;; 09E1:  CB BF
 set 0, b               ;; 09E3:  CB C0
 set 0, c               ;; 09E5:  CB C1
 set 0, d               ;; 09E7:  CB C2
 set 0, e               ;; 09E9:  CB C3
 set 0, h               ;; 09EB:  CB C4
 set 0, l               ;; 09ED:  CB C5
 set 0, (hl)            ;; 09EF:  CB C6
 set 0, a               ;; 09F1:  CB C7
 set 1, b               ;; 09F3:  CB C8
 set 1, c               ;; 09F5:  CB C9
 set 1, d               ;; 09F7:  CB CA
 set 1, e               ;; 09F9:  CB CB
 set 1, h               ;; 09FB:  CB CC
 set 1, l               ;; 09FD:  CB CD
 set 1, (hl)            ;; 09FF:  CB CE
 set 1, a               ;; 0A01:  CB CF
 set 2, b               ;; 0A03:  CB D0
 set 2, c               ;; 0A05:  CB D1
 set 2, d               ;; 0A07:  CB D2
 set 2, e               ;; 0A09:  CB D3
 set 2, h               ;; 0A0B:  CB D4
 set 2, l               ;; 0A0D:  CB D5
 set 2, (hl)            ;; 0A0F:  CB D6
 set 2, a               ;; 0A11:  CB D7
 set 3, b               ;; 0A13:  CB D8
 set 3, c               ;; 0A15:  CB D9
 set 3, d               ;; 0A17:  CB DA
 set 3, e               ;; 0A19:  CB DB
 set 3, h               ;; 0A1B:  CB DC
 set 3, l               ;; 0A1D:  CB DD
 set 3, (hl)            ;; 0A1F:  CB DE
 set 3, a               ;; 0A21:  CB DF
 set 4, b               ;; 0A23:  CB E0
 set 4, c               ;; 0A25:  CB E1
 set 4, d               ;; 0A27:  CB E2
 set 4, e               ;; 0A29:  CB E3
 set 4, h               ;; 0A2B:  CB E4
 set 4, l               ;; 0A2D:  CB E5
 set 4, (hl)            ;; 0A2F:  CB E6
 set 4, a               ;; 0A31:  CB E7
 set 5, b               ;; 0A33:  CB E8
 set 5, c               ;; 0A35:  CB E9
 set 5, d               ;; 0A37:  CB EA
 set 5, e               ;; 0A39:  CB EB
 set 5, h               ;; 0A3B:  CB EC
 set 5, l               ;; 0A3D:  CB ED
 set 5, (hl)            ;; 0A3F:  CB EE
 set 5, a               ;; 0A41:  CB EF
 set 6, b               ;; 0A43:  CB F0
 set 6, c               ;; 0A45:  CB F1
 set 6, d               ;; 0A47:  CB F2
 set 6, e               ;; 0A49:  CB F3
 set 6, h               ;; 0A4B:  CB F4
 set 6, l               ;; 0A4D:  CB F5
 set 6, (hl)            ;; 0A4F:  CB F6
 set 6, a               ;; 0A51:  CB F7
 set 7, b               ;; 0A53:  CB F8
 set 7, c               ;; 0A55:  CB F9
 set 7, d               ;; 0A57:  CB FA
 set 7, e               ;; 0A59:  CB FB
 set 7, h               ;; 0A5B:  CB FC
 set 7, l               ;; 0A5D:  CB FD
 set 7, (hl)            ;; 0A5F:  CB FE
 set 7, a               ;; 0A61:  CB FF
 bit 0, (ix+-128)       ;; 0A63:  DD CB 80 46
 bit 0, (ix+0)          ;; 0A67:  DD CB 00 46
 bit 0, (ix+127)        ;; 0A6B:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0A6F:  DD CB 80 4E
 bit 1, (ix+0)          ;; 0A73:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0A77:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0A7B:  DD CB 80 56
 bit 2, (ix+0)          ;; 0A7F:  DD CB 00 56
 bit 2, (ix+127)        ;; 0A83:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0A87:  DD CB 80 5E
 bit 3, (ix+0)          ;; 0A8B:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0A8F:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0A93:  DD CB 80 66
 bit 4, (ix+0)          ;; 0A97:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A9B:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A9F:  DD CB 80 6E
 bit 5, (ix+0)          ;; 0AA3:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0AA7:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0AAB:  DD CB 80 76
 bit 6, (ix+0)          ;; 0AAF:  DD CB 00 76
 bit 6, (ix+127)        ;; 0AB3:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0AB7:  DD CB 80 7E
 bit 7, (ix+0)          ;; 0ABB:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0ABF:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0AC3:  DD CB 80 86
 res 0, (ix+0)          ;; 0AC7:  DD CB 00 86
 res 0, (ix+127)        ;; 0ACB:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0ACF:  DD CB 80 8E
 res 1, (ix+0)          ;; 0AD3:  DD CB 00 8E
 res 1, (ix+127)        ;; 0AD7:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0ADB:  DD CB 80 96
 res 2, (ix+0)          ;; 0ADF:  DD CB 00 96
 res 2, (ix+127)        ;; 0AE3:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0AE7:  DD CB 80 9E
 res 3, (ix+0)          ;; 0AEB:  DD CB 00 9E
 res 3, (ix+127)        ;; 0AEF:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0AF3:  DD CB 80 A6
 res 4, (ix+0)          ;; 0AF7:  DD CB 00 A6
 res 4, (ix+127)        ;; 0AFB:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0AFF:  DD CB 80 AE
 res 5, (ix+0)          ;; 0B03:  DD CB 00 AE
 res 5, (ix+127)        ;; 0B07:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0B0B:  DD CB 80 B6
 res 6, (ix+0)          ;; 0B0F:  DD CB 00 B6
 res 6, (ix+127)        ;; 0B13:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0B17:  DD CB 80 BE
 res 7, (ix+0)          ;; 0B1B:  DD CB 00 BE
 res 7, (ix+127)        ;; 0B1F:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0B23:  DD CB 80 C6
 set 0, (ix+0)          ;; 0B27:  DD CB 00 C6
 set 0, (ix+127)        ;; 0B2B:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0B2F:  DD CB 80 CE
 set 1, (ix+0)          ;; 0B33:  DD CB 00 CE
 set 1, (ix+127)        ;; 0B37:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0B3B:  DD CB 80 D6
 set 2, (ix+0)          ;; 0B3F:  DD CB 00 D6
 set 2, (ix+127)        ;; 0B43:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0B47:  DD CB 80 DE
 set 3, (ix+0)          ;; 0B4B:  DD CB 00 DE
 set 3, (ix+127)        ;; 0B4F:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0B53:  DD CB 80 E6
 set 4, (ix+0)          ;; 0B57:  DD CB 00 E6
 set 4, (ix+127)        ;; 0B5B:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0B5F:  DD CB 80 EE
 set 5, (ix+0)          ;; 0B63:  DD CB 00 EE
 set 5, (ix+127)        ;; 0B67:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0B6B:  DD CB 80 F6
 set 6, (ix+0)          ;; 0B6F:  DD CB 00 F6
 set 6, (ix+127)        ;; 0B73:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0B77:  DD CB 80 FE
 set 7, (ix+0)          ;; 0B7B:  DD CB 00 FE
 set 7, (ix+127)        ;; 0B7F:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0B83:  FD CB 80 46
 bit 0, (iy+0)          ;; 0B87:  FD CB 00 46
 bit 0, (iy+127)        ;; 0B8B:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0B8F:  FD CB 80 4E
 bit 1, (iy+0)          ;; 0B93:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0B97:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B9B:  FD CB 80 56
 bit 2, (iy+0)          ;; 0B9F:  FD CB 00 56
 bit 2, (iy+127)        ;; 0BA3:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0BA7:  FD CB 80 5E
 bit 3, (iy+0)          ;; 0BAB:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0BAF:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0BB3:  FD CB 80 66
 bit 4, (iy+0)          ;; 0BB7:  FD CB 00 66
 bit 4, (iy+127)        ;; 0BBB:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0BBF:  FD CB 80 6E
 bit 5, (iy+0)          ;; 0BC3:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0BC7:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0BCB:  FD CB 80 76
 bit 6, (iy+0)          ;; 0BCF:  FD CB 00 76
 bit 6, (iy+127)        ;; 0BD3:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0BD7:  FD CB 80 7E
 bit 7, (iy+0)          ;; 0BDB:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0BDF:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0BE3:  FD CB 80 86
 res 0, (iy+0)          ;; 0BE7:  FD CB 00 86
 res 0, (iy+127)        ;; 0BEB:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0BEF:  FD CB 80 8E
 res 1, (iy+0)          ;; 0BF3:  FD CB 00 8E
 res 1, (iy+127)        ;; 0BF7:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0BFB:  FD CB 80 96
 res 2, (iy+0)          ;; 0BFF:  FD CB 00 96
 res 2, (iy+127)        ;; 0C03:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0C07:  FD CB 80 9E
 res 3, (iy+0)          ;; 0C0B:  FD CB 00 9E
 res 3, (iy+127)        ;; 0C0F:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0C13:  FD CB 80 A6
 res 4, (iy+0)          ;; 0C17:  FD CB 00 A6
 res 4, (iy+127)        ;; 0C1B:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0C1F:  FD CB 80 AE
 res 5, (iy+0)          ;; 0C23:  FD CB 00 AE
 res 5, (iy+127)        ;; 0C27:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0C2B:  FD CB 80 B6
 res 6, (iy+0)          ;; 0C2F:  FD CB 00 B6
 res 6, (iy+127)        ;; 0C33:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0C37:  FD CB 80 BE
 res 7, (iy+0)          ;; 0C3B:  FD CB 00 BE
 res 7, (iy+127)        ;; 0C3F:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0C43:  FD CB 80 C6
 set 0, (iy+0)          ;; 0C47:  FD CB 00 C6
 set 0, (iy+127)        ;; 0C4B:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0C4F:  FD CB 80 CE
 set 1, (iy+0)          ;; 0C53:  FD CB 00 CE
 set 1, (iy+127)        ;; 0C57:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0C5B:  FD CB 80 D6
 set 2, (iy+0)          ;; 0C5F:  FD CB 00 D6
 set 2, (iy+127)        ;; 0C63:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0C67:  FD CB 80 DE
 set 3, (iy+0)          ;; 0C6B:  FD CB 00 DE
 set 3, (iy+127)        ;; 0C6F:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0C73:  FD CB 80 E6
 set 4, (iy+0)          ;; 0C77:  FD CB 00 E6
 set 4, (iy+127)        ;; 0C7B:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0C7F:  FD CB 80 EE
 set 5, (iy+0)          ;; 0C83:  FD CB 00 EE
 set 5, (iy+127)        ;; 0C87:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0C8B:  FD CB 80 F6
 set 6, (iy+0)          ;; 0C8F:  FD CB 00 F6
 set 6, (iy+127)        ;; 0C93:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0C97:  FD CB 80 FE
 set 7, (iy+0)          ;; 0C9B:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C9F:  FD CB 7F FE
 ldi                    ;; 0CA3:  ED A0
 ldir                   ;; 0CA5:  ED B0
 ldd                    ;; 0CA7:  ED A8
 lddr                   ;; 0CA9:  ED B8
 ldisr                  ;; 0CAB:  ED 90
 lddsr                  ;; 0CAD:  ED 98
 lsdr                   ;; 0CAF:  ED F8
 lsir                   ;; 0CB1:  ED F0
 lsddr                  ;; 0CB3:  ED D8
 lsidr                  ;; 0CB5:  ED D0
 nop                    ;; 0CB7:  00
 altd                   ;; 0CB8:  76
 ld a, xpc              ;; 0CB9:  ED 77
 ld xpc, a              ;; 0CBB:  ED 67
 rdmode                 ;; 0CBD:  ED 7F
 setusr                 ;; 0CBF:  ED 6F
 sures                  ;; 0CC1:  ED 7D
 syscall                ;; 0CC3:  ED 75
 jp 0                   ;; 0CC5:  C3 00 00
 jp 291                 ;; 0CC8:  C3 23 01
 jp 17767               ;; 0CCB:  C3 67 45
 jp 35243               ;; 0CCE:  C3 AB 89
 jp 52719               ;; 0CD1:  C3 EF CD
 jp 65535               ;; 0CD4:  C3 FF FF
 jp nz, 0               ;; 0CD7:  C2 00 00
 jp nz, 291             ;; 0CDA:  C2 23 01
 jp nz, 17767           ;; 0CDD:  C2 67 45
 jp nz, 35243           ;; 0CE0:  C2 AB 89
 jp nz, 52719           ;; 0CE3:  C2 EF CD
 jp nz, 65535           ;; 0CE6:  C2 FF FF
 jp z, 0                ;; 0CE9:  CA 00 00
 jp z, 291              ;; 0CEC:  CA 23 01
 jp z, 17767            ;; 0CEF:  CA 67 45
 jp z, 35243            ;; 0CF2:  CA AB 89
 jp z, 52719            ;; 0CF5:  CA EF CD
 jp z, 65535            ;; 0CF8:  CA FF FF
 jp nc, 0               ;; 0CFB:  D2 00 00
 jp nc, 291             ;; 0CFE:  D2 23 01
 jp nc, 17767           ;; 0D01:  D2 67 45
 jp nc, 35243           ;; 0D04:  D2 AB 89
 jp nc, 52719           ;; 0D07:  D2 EF CD
 jp nc, 65535           ;; 0D0A:  D2 FF FF
 jp c, 0                ;; 0D0D:  DA 00 00
 jp c, 291              ;; 0D10:  DA 23 01
 jp c, 17767            ;; 0D13:  DA 67 45
 jp c, 35243            ;; 0D16:  DA AB 89
 jp c, 52719            ;; 0D19:  DA EF CD
 jp c, 65535            ;; 0D1C:  DA FF FF
 jp po, 0               ;; 0D1F:  E2 00 00
 jp po, 291             ;; 0D22:  E2 23 01
 jp po, 17767           ;; 0D25:  E2 67 45
 jp po, 35243           ;; 0D28:  E2 AB 89
 jp po, 52719           ;; 0D2B:  E2 EF CD
 jp po, 65535           ;; 0D2E:  E2 FF FF
 jp pe, 0               ;; 0D31:  EA 00 00
 jp pe, 291             ;; 0D34:  EA 23 01
 jp pe, 17767           ;; 0D37:  EA 67 45
 jp pe, 35243           ;; 0D3A:  EA AB 89
 jp pe, 52719           ;; 0D3D:  EA EF CD
 jp pe, 65535           ;; 0D40:  EA FF FF
 jp p, 0                ;; 0D43:  F2 00 00
 jp p, 291              ;; 0D46:  F2 23 01
 jp p, 17767            ;; 0D49:  F2 67 45
 jp p, 35243            ;; 0D4C:  F2 AB 89
 jp p, 52719            ;; 0D4F:  F2 EF CD
 jp p, 65535            ;; 0D52:  F2 FF FF
 jp m, 0                ;; 0D55:  FA 00 00
 jp m, 291              ;; 0D58:  FA 23 01
 jp m, 17767            ;; 0D5B:  FA 67 45
 jp m, 35243            ;; 0D5E:  FA AB 89
 jp m, 52719            ;; 0D61:  FA EF CD
 jp m, 65535            ;; 0D64:  FA FF FF
 jp lz, 0               ;; 0D67:  E2 00 00
 jp lz, 291             ;; 0D6A:  E2 23 01
 jp lz, 17767           ;; 0D6D:  E2 67 45
 jp lz, 35243           ;; 0D70:  E2 AB 89
 jp lz, 52719           ;; 0D73:  E2 EF CD
 jp lz, 65535           ;; 0D76:  E2 FF FF
 jp lo, 0               ;; 0D79:  EA 00 00
 jp lo, 291             ;; 0D7C:  EA 23 01
 jp lo, 17767           ;; 0D7F:  EA 67 45
 jp lo, 35243           ;; 0D82:  EA AB 89
 jp lo, 52719           ;; 0D85:  EA EF CD
 jp lo, 65535           ;; 0D88:  EA FF FF
 jp (hl)                ;; 0D8B:  E9
 jp (ix)                ;; 0D8C:  DD E9
 jp (iy)                ;; 0D8E:  FD E9
 djnz ASMPC             ;; 0D90:  10 FE
 jr ASMPC               ;; 0D92:  18 FE
 jr nz, ASMPC           ;; 0D94:  20 FE
 jr z, ASMPC            ;; 0D96:  28 FE
 jr nc, ASMPC           ;; 0D98:  30 FE
 jr c, ASMPC            ;; 0D9A:  38 FE
 call 0                 ;; 0D9C:  CD 00 00
 call 291               ;; 0D9F:  CD 23 01
 call 17767             ;; 0DA2:  CD 67 45
 call 35243             ;; 0DA5:  CD AB 89
 call 52719             ;; 0DA8:  CD EF CD
 call 65535             ;; 0DAB:  CD FF FF
 ret                    ;; 0DAE:  C9
 ret nz                 ;; 0DAF:  C0
 ret z                  ;; 0DB0:  C8
 ret nc                 ;; 0DB1:  D0
 ret c                  ;; 0DB2:  D8
 ret po                 ;; 0DB3:  E0
 ret pe                 ;; 0DB4:  E8
 ret p                  ;; 0DB5:  F0
 ret m                  ;; 0DB6:  F8
 ret lz                 ;; 0DB7:  E0
 ret lo                 ;; 0DB8:  E8
 rst 16                 ;; 0DB9:  D7
 rst 24                 ;; 0DBA:  DF
 rst 32                 ;; 0DBB:  E7
 rst 40                 ;; 0DBC:  EF
 rst 56                 ;; 0DBD:  FF
 ioe                    ;; 0DBE:  DB
 ioi                    ;; 0DBF:  D3
 ipset 0                ;; 0DC0:  ED 46
 ipset 1                ;; 0DC2:  ED 56
 ipset 2                ;; 0DC4:  ED 4E
 ipset 3                ;; 0DC6:  ED 5E
 ipres                  ;; 0DC8:  ED 5D
 ld iir, a              ;; 0DCA:  ED 4F
 ld a, iir              ;; 0DCC:  ED 5F
 ld eir, a              ;; 0DCE:  ED 47
 ld a, eir              ;; 0DD0:  ED 57
 reti                   ;; 0DD2:  ED 4D
 idet                   ;; 0DD4:  5B
