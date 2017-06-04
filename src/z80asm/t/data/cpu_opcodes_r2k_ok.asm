 adc (42)               ;; CE 2A
 adc 42                 ;; CE 2A
 adc a', (42)           ;; 76 CE 2A
 adc a', 42             ;; 76 CE 2A
 adc a, (42)            ;; CE 2A
 adc a, 42              ;; CE 2A
 add (42)               ;; C6 2A
 add 42                 ;; C6 2A
 add a', (42)           ;; 76 C6 2A
 add a', 42             ;; 76 C6 2A
 add a, (42)            ;; C6 2A
 add a, 42              ;; C6 2A
 altd adc a, (42)       ;; 76 CE 2A
 altd adc a, 42         ;; 76 CE 2A
 altd add a, (42)       ;; 76 C6 2A
 altd add a, 42         ;; 76 C6 2A
 altd and a, (42)       ;; 76 E6 2A
 altd and a, 42         ;; 76 E6 2A
 altd ccf f             ;; 76 3F
 altd cp a, (42)        ;; 76 FE 2A
 altd cp a, 42          ;; 76 FE 2A
 altd cpl a             ;; 76 2F
 altd dec a             ;; 76 3D
 altd dec b             ;; 76 05
 altd dec c             ;; 76 0D
 altd dec d             ;; 76 15
 altd dec e             ;; 76 1D
 altd dec h             ;; 76 25
 altd dec l             ;; 76 2D
 altd inc a             ;; 76 3C
 altd inc b             ;; 76 04
 altd inc c             ;; 76 0C
 altd inc d             ;; 76 14
 altd inc e             ;; 76 1C
 altd inc h             ;; 76 24
 altd inc l             ;; 76 2C
 altd ld bc, (4660)     ;; 76 ED 4B 34 12
 altd ld bc, 4660       ;; 76 01 34 12
 altd ld de, (4660)     ;; 76 ED 5B 34 12
 altd ld de, 4660       ;; 76 11 34 12
 altd ld hl, (4660)     ;; 76 2A 34 12
 altd ld hl, (hl)       ;; 76 DD E4 00
 altd ld hl, (hl+127)   ;; 76 DD E4 7F
 altd ld hl, (ix)       ;; 76 E4 00
 altd ld hl, (ix+127)   ;; 76 E4 7F
 altd ld hl, (iy)       ;; 76 FD E4 00
 altd ld hl, (iy+127)   ;; 76 FD E4 7F
 altd ld hl, 4660       ;; 76 21 34 12
 altd ld hl, ix         ;; 76 DD 7C
 altd ld hl, iy         ;; 76 FD 7C
 altd neg a             ;; 76 ED 44
 altd or a, (42)        ;; 76 F6 2A
 altd or a, 42          ;; 76 F6 2A
 altd pop af            ;; 76 F1
 altd pop bc            ;; 76 C1
 altd pop de            ;; 76 D1
 altd pop hl            ;; 76 E1
 altd pop ix            ;; 76 DD E1
 altd pop iy            ;; 76 FD E1
 altd sbc a, (42)       ;; 76 DE 2A
 altd sbc a, 42         ;; 76 DE 2A
 altd scf f             ;; 76 37
 altd sub a, (42)       ;; 76 D6 2A
 altd sub a, 42         ;; 76 D6 2A
 altd xor a, (42)       ;; 76 EE 2A
 altd xor a, 42         ;; 76 EE 2A
 and (42)               ;; E6 2A
 and 42                 ;; E6 2A
 and a', (42)           ;; 76 E6 2A
 and a', 42             ;; 76 E6 2A
 and a, (42)            ;; E6 2A
 and a, 42              ;; E6 2A
 ccf                    ;; 3F
 ccf f                  ;; 3F
 ccf f'                 ;; 76 3F
 cp (42)                ;; FE 2A
 cp 42                  ;; FE 2A
 cp a', (42)            ;; 76 FE 2A
 cp a', 42              ;; 76 FE 2A
 cp a, (42)             ;; FE 2A
 cp a, 42               ;; FE 2A
 cpl                    ;; 2F
 cpl a                  ;; 2F
 cpl a'                 ;; 76 2F
 dec (hl)               ;; 35
 dec (ix)               ;; DD 35 00
 dec (ix+127)           ;; DD 35 7F
 dec (iy)               ;; FD 35 00
 dec (iy+127)           ;; FD 35 7F
 dec a                  ;; 3D
 dec a'                 ;; 76 3D
 dec b                  ;; 05
 dec b'                 ;; 76 05
 dec c                  ;; 0D
 dec c'                 ;; 76 0D
 dec d                  ;; 15
 dec d'                 ;; 76 15
 dec e                  ;; 1D
 dec e'                 ;; 76 1D
 dec h                  ;; 25
 dec h'                 ;; 76 25
 dec l                  ;; 2D
 dec l'                 ;; 76 2D
 inc (hl)               ;; 34
 inc (ix)               ;; DD 34 00
 inc (ix+127)           ;; DD 34 7F
 inc (iy)               ;; FD 34 00
 inc (iy+127)           ;; FD 34 7F
 inc a                  ;; 3C
 inc a'                 ;; 76 3C
 inc b                  ;; 04
 inc b'                 ;; 76 04
 inc c                  ;; 0C
 inc c'                 ;; 76 0C
 inc d                  ;; 14
 inc d'                 ;; 76 14
 inc e                  ;; 1C
 inc e'                 ;; 76 1C
 inc h                  ;; 24
 inc h'                 ;; 76 24
 inc l                  ;; 2C
 inc l'                 ;; 76 2C
 ld (4660), bc          ;; ED 43 34 12
 ld (4660), de          ;; ED 53 34 12
 ld (4660), hl          ;; 22 34 12
 ld (4660), ix          ;; DD 22 34 12
 ld (4660), iy          ;; FD 22 34 12
 ld (4660), sp          ;; ED 73 34 12
 ld (hl), hl            ;; DD F4 00
 ld (hl+127), hl        ;; DD F4 7F
 ld (ix), hl            ;; F4 00
 ld (ix+127), hl        ;; F4 7F
 ld (iy), hl            ;; FD F4 00
 ld (iy+127), hl        ;; FD F4 7F
 ld bc', (4660)         ;; 76 ED 4B 34 12
 ld bc', 4660           ;; 76 01 34 12
 ld bc, (4660)          ;; ED 4B 34 12
 ld bc, 4660            ;; 01 34 12
 ld de', (4660)         ;; 76 ED 5B 34 12
 ld de', 4660           ;; 76 11 34 12
 ld de, (4660)          ;; ED 5B 34 12
 ld de, 4660            ;; 11 34 12
 ld hl', (4660)         ;; 76 2A 34 12
 ld hl', (hl)           ;; 76 DD E4 00
 ld hl', (hl+127)       ;; 76 DD E4 7F
 ld hl', (ix)           ;; 76 E4 00
 ld hl', (ix+127)       ;; 76 E4 7F
 ld hl', (iy)           ;; 76 FD E4 00
 ld hl', (iy+127)       ;; 76 FD E4 7F
 ld hl', 4660           ;; 76 21 34 12
 ld hl', ix             ;; 76 DD 7C
 ld hl', iy             ;; 76 FD 7C
 ld hl, (4660)          ;; 2A 34 12
 ld hl, (hl)            ;; DD E4 00
 ld hl, (hl+127)        ;; DD E4 7F
 ld hl, (ix)            ;; E4 00
 ld hl, (ix+127)        ;; E4 7F
 ld hl, (iy)            ;; FD E4 00
 ld hl, (iy+127)        ;; FD E4 7F
 ld hl, 4660            ;; 21 34 12
 ld hl, ix              ;; DD 7C
 ld hl, iy              ;; FD 7C
 ld ix, (4660)          ;; DD 2A 34 12
 ld ix, 4660            ;; DD 21 34 12
 ld ix, hl              ;; DD 7D
 ld iy, (4660)          ;; FD 2A 34 12
 ld iy, 4660            ;; FD 21 34 12
 ld iy, hl              ;; FD 7D
 ld sp, (4660)          ;; ED 7B 34 12
 ld sp, 4660            ;; 31 34 12
 ld sp, hl              ;; F9
 ld sp, ix              ;; DD F9
 ld sp, iy              ;; FD F9
 ldp (4660), hl         ;; ED 65 34 12
 ldp (4660), ix         ;; DD 65 34 12
 ldp (4660), iy         ;; FD 65 34 12
 ldp (hl), hl           ;; ED 64
 ldp (ix), hl           ;; DD 64
 ldp (iy), hl           ;; FD 64
 ldp hl, (4660)         ;; ED 6D 34 12
 ldp hl, (hl)           ;; ED 6C
 ldp hl, (ix)           ;; DD 6C
 ldp hl, (iy)           ;; FD 6C
 ldp ix, (4660)         ;; DD 6D 34 12
 ldp iy, (4660)         ;; FD 6D 34 12
 neg                    ;; ED 44
 neg a                  ;; ED 44
 neg a'                 ;; 76 ED 44
 or (42)                ;; F6 2A
 or 42                  ;; F6 2A
 or a', (42)            ;; 76 F6 2A
 or a', 42              ;; 76 F6 2A
 or a, (42)             ;; F6 2A
 or a, 42               ;; F6 2A
 pop af                 ;; F1
 pop af'                ;; 76 F1
 pop bc                 ;; C1
 pop bc'                ;; 76 C1
 pop de                 ;; D1
 pop de'                ;; 76 D1
 pop hl                 ;; E1
 pop hl'                ;; 76 E1
 pop ip                 ;; ED 7E
 pop ix                 ;; DD E1
 pop iy                 ;; FD E1
 push af                ;; F5
 push bc                ;; C5
 push de                ;; D5
 push hl                ;; E5
 push ip                ;; ED 76
 push ix                ;; DD E5
 push iy                ;; FD E5
 sbc (42)               ;; DE 2A
 sbc 42                 ;; DE 2A
 sbc a', (42)           ;; 76 DE 2A
 sbc a', 42             ;; 76 DE 2A
 sbc a, (42)            ;; DE 2A
 sbc a, 42              ;; DE 2A
 scf                    ;; 37
 scf f                  ;; 37
 scf f'                 ;; 76 37
 sub (42)               ;; D6 2A
 sub 42                 ;; D6 2A
 sub a', (42)           ;; 76 D6 2A
 sub a', 42             ;; 76 D6 2A
 sub a, (42)            ;; D6 2A
 sub a, 42              ;; D6 2A
 tst (42)               ;; ED 64 2A
 tst (hl)               ;; ED 34
 tst 42                 ;; ED 64 2A
 tst a                  ;; ED 3C
 tst a, (42)            ;; ED 64 2A
 tst a, (hl)            ;; ED 34
 tst a, 42              ;; ED 64 2A
 tst a, a               ;; ED 3C
 tst a, b               ;; ED 04
 tst a, c               ;; ED 0C
 tst a, d               ;; ED 14
 tst a, e               ;; ED 1C
 tst a, h               ;; ED 24
 tst a, l               ;; ED 2C
 tst b                  ;; ED 04
 tst c                  ;; ED 0C
 tst d                  ;; ED 14
 tst e                  ;; ED 1C
 tst h                  ;; ED 24
 tst l                  ;; ED 2C
 xor (42)               ;; EE 2A
 xor 42                 ;; EE 2A
 xor a', (42)           ;; 76 EE 2A
 xor a', 42             ;; 76 EE 2A
 xor a, (42)            ;; EE 2A
 xor a, 42              ;; EE 2A
