 altd ld hl, (hl)       ;; 76 DD E4 00
 altd ld hl, (hl+127)   ;; 76 DD E4 7F
 altd ld hl, (ix)       ;; 76 E4 00
 altd ld hl, (ix+127)   ;; 76 E4 7F
 altd ld hl, (iy)       ;; 76 FD E4 00
 altd ld hl, (iy+127)   ;; 76 FD E4 7F
 ld (hl), hl            ;; DD F4 00
 ld (hl+127), hl        ;; DD F4 7F
 ld (ix), hl            ;; F4 00
 ld (ix+127), hl        ;; F4 7F
 ld (iy), hl            ;; FD F4 00
 ld (iy+127), hl        ;; FD F4 7F
 ld hl', (hl)           ;; 76 DD E4 00
 ld hl', (hl+127)       ;; 76 DD E4 7F
 ld hl', (ix)           ;; 76 E4 00
 ld hl', (ix+127)       ;; 76 E4 7F
 ld hl', (iy)           ;; 76 FD E4 00
 ld hl', (iy+127)       ;; 76 FD E4 7F
 ld hl, (hl)            ;; DD E4 00
 ld hl, (hl+127)        ;; DD E4 7F
 ld hl, (ix)            ;; E4 00
 ld hl, (ix+127)        ;; E4 7F
 ld hl, (iy)            ;; FD E4 00
 ld hl, (iy+127)        ;; FD E4 7F
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
