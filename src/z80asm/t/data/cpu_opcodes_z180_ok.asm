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
