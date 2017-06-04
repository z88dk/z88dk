 adc (42)               ;; CE 2A
 adc 42                 ;; CE 2A
 adc a, (42)            ;; CE 2A
 adc a, 42              ;; CE 2A
 add (42)               ;; C6 2A
 add 42                 ;; C6 2A
 add a, (42)            ;; C6 2A
 add a, 42              ;; C6 2A
 and (42)               ;; E6 2A
 and 42                 ;; E6 2A
 and a, (42)            ;; E6 2A
 and a, 42              ;; E6 2A
 ccf                    ;; 3F
 ccf f                  ;; 3F
 cp (42)                ;; FE 2A
 cp 42                  ;; FE 2A
 cp a, (42)             ;; FE 2A
 cp a, 42               ;; FE 2A
 cpl                    ;; 2F
 cpl a                  ;; 2F
 daa                    ;; 27
 dec (hl)               ;; 35
 dec (ix)               ;; DD 35 00
 dec (ix+127)           ;; DD 35 7F
 dec (iy)               ;; FD 35 00
 dec (iy+127)           ;; FD 35 7F
 dec a                  ;; 3D
 dec b                  ;; 05
 dec c                  ;; 0D
 dec d                  ;; 15
 dec e                  ;; 1D
 dec h                  ;; 25
 dec l                  ;; 2D
 inc (hl)               ;; 34
 inc (ix)               ;; DD 34 00
 inc (ix+127)           ;; DD 34 7F
 inc (iy)               ;; FD 34 00
 inc (iy+127)           ;; FD 34 7F
 inc a                  ;; 3C
 inc b                  ;; 04
 inc c                  ;; 0C
 inc d                  ;; 14
 inc e                  ;; 1C
 inc h                  ;; 24
 inc l                  ;; 2C
 ld (4660), bc          ;; ED 43 34 12
 ld (4660), de          ;; ED 53 34 12
 ld (4660), hl          ;; 22 34 12
 ld (4660), ix          ;; DD 22 34 12
 ld (4660), iy          ;; FD 22 34 12
 ld (4660), sp          ;; ED 73 34 12
 ld bc, (4660)          ;; ED 4B 34 12
 ld bc, 4660            ;; 01 34 12
 ld de, (4660)          ;; ED 5B 34 12
 ld de, 4660            ;; 11 34 12
 ld hl, (4660)          ;; 2A 34 12
 ld hl, 4660            ;; 21 34 12
 ld ix, (4660)          ;; DD 2A 34 12
 ld ix, 4660            ;; DD 21 34 12
 ld iy, (4660)          ;; FD 2A 34 12
 ld iy, 4660            ;; FD 21 34 12
 ld sp, (4660)          ;; ED 7B 34 12
 ld sp, 4660            ;; 31 34 12
 ld sp, hl              ;; F9
 ld sp, ix              ;; DD F9
 ld sp, iy              ;; FD F9
 neg                    ;; ED 44
 neg a                  ;; ED 44
 or (42)                ;; F6 2A
 or 42                  ;; F6 2A
 or a, (42)             ;; F6 2A
 or a, 42               ;; F6 2A
 pop af                 ;; F1
 pop bc                 ;; C1
 pop de                 ;; D1
 pop hl                 ;; E1
 pop ix                 ;; DD E1
 pop iy                 ;; FD E1
 push af                ;; F5
 push bc                ;; C5
 push de                ;; D5
 push hl                ;; E5
 push ix                ;; DD E5
 push iy                ;; FD E5
 rld                    ;; ED 6F
 rrd                    ;; ED 67
 sbc (42)               ;; DE 2A
 sbc 42                 ;; DE 2A
 sbc a, (42)            ;; DE 2A
 sbc a, 42              ;; DE 2A
 scf                    ;; 37
 scf f                  ;; 37
 sub (42)               ;; D6 2A
 sub 42                 ;; D6 2A
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
 xor a, (42)            ;; EE 2A
 xor a, 42              ;; EE 2A
