 altd cpl a                     ; 76 2F
 altd cpl                       ; 76 2F
 cpl a'                         ; 76 2F
 altd neg a                     ; 76 ED 44
 altd neg                       ; 76 ED 44
 neg a'                         ; 76 ED 44
 altd ccf f                     ; 76 3F
 altd ccf                       ; 76 3F
 ccf f'                         ; 76 3F
 altd scf f                     ; 76 37
 altd scf                       ; 76 37
 scf f'                         ; 76 37
 altd ld hl,  256               ; 76 21 00 01
 altd ld hl, (256)              ; 76 2A 00 01
 ld hl',  256                   ; 76 21 00 01
 ld hl', (256)                  ; 76 2A 00 01
 altd ld bc,  256               ; 76 01 00 01
 altd ld bc, (256)              ; 76 ED 4B 00 01
 ld bc',  256                   ; 76 01 00 01
 ld bc', (256)                  ; 76 ED 4B 00 01
 altd ld de,  256               ; 76 11 00 01
 altd ld de, (256)              ; 76 ED 5B 00 01
 ld de',  256                   ; 76 11 00 01
 ld de', (256)                  ; 76 ED 5B 00 01
 altd pop bc                    ; 76 C1
 pop bc'                        ; 76 C1
 altd pop de                    ; 76 D1
 pop de'                        ; 76 D1
 altd pop hl                    ; 76 E1
 pop hl'                        ; 76 E1
 altd pop af                    ; 76 F1
 pop af'                        ; 76 F1
 push ip                        ; ED 76
 pop ip                         ; ED 7E
 push su                        ; ED 66
 pop su                         ; ED 6E
 ld hl, ix                      ; DD 7C
 altd ld hl, ix                 ; 76 DD 7C
 ld hl', ix                     ; 76 DD 7C
 ld ix, hl                      ; DD 7D
 ld hl, iy                      ; FD 7C
 altd ld hl, iy                 ; 76 FD 7C
 ld hl', iy                     ; 76 FD 7C
 ld iy, hl                      ; FD 7D
