 daa                            ; 27
 rrd                            ; ED 67
 rld                            ; ED 6F
 cpl                            ; 2F
 cpl a                          ; 2F
 neg                            ; ED 44
 neg a                          ; ED 44
 ccf                            ; 3F
 ccf f                          ; 3F
 scf                            ; 37
 scf f                          ; 37
 ld hl,  256                    ; 21 00 01
 ld hl, (256)                   ; 2A 00 01
 ld ix,  256                    ; DD 21 00 01
 ld ix, (256)                   ; DD 2A 00 01
 ld iy,  256                    ; FD 21 00 01
 ld iy, (256)                   ; FD 2A 00 01
 ld bc,  256                    ; 01 00 01
 ld bc, (256)                   ; ED 4B 00 01
 ld de,  256                    ; 11 00 01
 ld de, (256)                   ; ED 5B 00 01
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
 pop de                         ; D1
 pop hl                         ; E1
 pop af                         ; F1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
