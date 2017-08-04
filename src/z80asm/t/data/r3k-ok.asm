 tst a, b                       ; ED 04
 tst b                          ; ED 04
 tst a, c                       ; ED 0C
 tst c                          ; ED 0C
 tst a, d                       ; ED 14
 tst d                          ; ED 14
 tst a, e                       ; ED 1C
 tst e                          ; ED 1C
 tst a, h                       ; ED 24
 tst h                          ; ED 24
 tst a, l                       ; ED 2C
 tst l                          ; ED 2C
 tst a, a                       ; ED 3C
 tst a                          ; ED 3C
 tst a, (hl)                    ; ED 34
 tst (hl)                       ; ED 34
 tst a,  42                     ; ED 64 2A
 tst a, (42)                    ; ED 64 2A
 tst  42                        ; ED 64 2A
 tst (42)                       ; ED 64 2A
 cpl                            ; 2F
 cpl a                          ; 2F
 altd cpl a                     ; 76 2F
 altd cpl                       ; 76 2F
 cpl a'                         ; 76 2F
 neg                            ; ED 44
 neg a                          ; ED 44
 altd neg a                     ; 76 ED 44
 altd neg                       ; 76 ED 44
 neg a'                         ; 76 ED 44
 ccf                            ; 3F
 ccf f                          ; 3F
 altd ccf f                     ; 76 3F
 altd ccf                       ; 76 3F
 ccf f'                         ; 76 3F
 scf                            ; 37
 scf f                          ; 37
 altd scf f                     ; 76 37
 altd scf                       ; 76 37
 scf f'                         ; 76 37
 ld hl,  256                    ; 21 00 01
 ld hl, (256)                   ; 2A 00 01
 altd ld hl,  256               ; 76 21 00 01
 altd ld hl, (256)              ; 76 2A 00 01
 ld hl',  256                   ; 76 21 00 01
 ld hl', (256)                  ; 76 2A 00 01
 ld ix,  256                    ; DD 21 00 01
 ld ix, (256)                   ; DD 2A 00 01
 ld iy,  256                    ; FD 21 00 01
 ld iy, (256)                   ; FD 2A 00 01
 ld bc,  256                    ; 01 00 01
 ld bc, (256)                   ; ED 4B 00 01
 altd ld bc,  256               ; 76 01 00 01
 altd ld bc, (256)              ; 76 ED 4B 00 01
 ld bc',  256                   ; 76 01 00 01
 ld bc', (256)                  ; 76 ED 4B 00 01
 ld de,  256                    ; 11 00 01
 ld de, (256)                   ; ED 5B 00 01
 altd ld de,  256               ; 76 11 00 01
 altd ld de, (256)              ; 76 ED 5B 00 01
 ld de',  256                   ; 76 11 00 01
 ld de', (256)                  ; 76 ED 5B 00 01
 ld sp,  256                    ; 31 00 01
 ld sp, (256)                   ; ED 7B 00 01
 ld (256), hl                   ; 22 00 01
 ld (256), ix                   ; DD 22 00 01
 ld (256), iy                   ; FD 22 00 01
 ld (256), bc                   ; ED 43 00 01
 ld (256), de                   ; ED 53 00 01
 ld (256), sp                   ; ED 73 00 01
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push af                        ; F5
 push ix                        ; DD E5
 push iy                        ; FD E5
 pop bc                         ; C1
 altd pop bc                    ; 76 C1
 pop bc'                        ; 76 C1
 pop de                         ; D1
 altd pop de                    ; 76 D1
 pop de'                        ; 76 D1
 pop hl                         ; E1
 altd pop hl                    ; 76 E1
 pop hl'                        ; 76 E1
 pop af                         ; F1
 altd pop af                    ; 76 F1
 pop af'                        ; 76 F1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
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
