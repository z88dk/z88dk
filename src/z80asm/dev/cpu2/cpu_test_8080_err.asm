 adi hl, -128                   ; Error
 adi hl, 127                    ; Error
 adi hl, 255                    ; Error
 adi sp, -128                   ; Error
 adi sp, 127                    ; Error
 adi sp, 255                    ; Error
 arhl                           ; Error
 dsub                           ; Error
 jk -32768                      ; Error
 jk 32767                       ; Error
 jk 65535                       ; Error
 jnk -32768                     ; Error
 jnk 32767                      ; Error
 jnk 65535                      ; Error
 jnx5 -32768                    ; Error
 jnx5 32767                     ; Error
 jnx5 65535                     ; Error
 jx5 -32768                     ; Error
 jx5 32767                      ; Error
 jx5 65535                      ; Error
 ld (de), hl                    ; Error
 ld de, hl+-128                 ; Error
 ld de, hl+127                  ; Error
 ld de, hl+255                  ; Error
 ld de, sp+-128                 ; Error
 ld de, sp+127                  ; Error
 ld de, sp+255                  ; Error
 ld hl, (de)                    ; Error
 ldhi -128                      ; Error
 ldhi 127                       ; Error
 ldhi 255                       ; Error
 ldsi -128                      ; Error
 ldsi 127                       ; Error
 ldsi 255                       ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 ovrst8                         ; Error
 rdel                           ; Error
 rim                            ; Error
 rl de                          ; Error
 rlde                           ; Error
 rrhl                           ; Error
 rstv                           ; Error
 shlde                          ; Error
 shlx                           ; Error
 sim                            ; Error
 sra hl                         ; Error
 sub hl, bc                     ; Error
