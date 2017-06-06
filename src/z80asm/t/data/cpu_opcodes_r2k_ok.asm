 altd ccf f             ;; 76 3F
 altd cpl a             ;; 76 2F
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
 altd pop af            ;; 76 F1
 altd pop bc            ;; 76 C1
 altd pop de            ;; 76 D1
 altd pop hl            ;; 76 E1
 altd pop ix            ;; 76 DD E1
 altd pop iy            ;; 76 FD E1
 altd scf f             ;; 76 37
 ccf                    ;; 3F
 ccf f                  ;; 3F
 ccf f'                 ;; 76 3F
 cpl                    ;; 2F
 cpl a                  ;; 2F
 cpl a'                 ;; 76 2F
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
 scf                    ;; 37
 scf f                  ;; 37
 scf f'                 ;; 76 37
