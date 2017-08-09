 adc (hl)               ; 8E
 adc (ix)               ; DD 8E 00
 adc (ix+127)           ; DD 8E 7F
 adc (ix-128)           ; DD 8E 80
 adc (iy)               ; FD 8E 00
 adc (iy+127)           ; FD 8E 7F
 adc (iy-128)           ; FD 8E 80
 adc -128               ; CE 80
 adc 127                ; CE 7F
 adc 255                ; CE FF
 adc a                  ; 8F
 adc a,(hl)             ; 8E
 adc a,(ix)             ; DD 8E 00
 adc a,(ix+127)         ; DD 8E 7F
 adc a,(ix-128)         ; DD 8E 80
 adc a,(iy)             ; FD 8E 00
 adc a,(iy+127)         ; FD 8E 7F
 adc a,(iy-128)         ; FD 8E 80
 adc a,-128             ; CE 80
 adc a,127              ; CE 7F
 adc a,255              ; CE FF
 adc a,a                ; 8F
 adc a,b                ; 88
 adc a,c                ; 89
 adc a,d                ; 8A
 adc a,e                ; 8B
 adc a,h                ; 8C
 adc a,l                ; 8D
 adc b                  ; 88
 adc c                  ; 89
 adc d                  ; 8A
 adc e                  ; 8B
 adc h                  ; 8C
 adc hl,bc              ; ED 4A
 adc hl,de              ; ED 5A
 adc hl,hl              ; ED 6A
 adc hl,sp              ; ED 7A
 adc l                  ; 8D
 add (hl)               ; 86
 add (ix)               ; DD 86 00
 add (ix+127)           ; DD 86 7F
 add (ix-128)           ; DD 86 80
 add (iy)               ; FD 86 00
 add (iy+127)           ; FD 86 7F
 add (iy-128)           ; FD 86 80
 add -128               ; C6 80
 add 127                ; C6 7F
 add 255                ; C6 FF
 add a                  ; 87
 add a,(hl)             ; 86
 add a,(ix)             ; DD 86 00
 add a,(ix+127)         ; DD 86 7F
 add a,(ix-128)         ; DD 86 80
 add a,(iy)             ; FD 86 00
 add a,(iy+127)         ; FD 86 7F
 add a,(iy-128)         ; FD 86 80
 add a,-128             ; C6 80
 add a,127              ; C6 7F
 add a,255              ; C6 FF
 add a,a                ; 87
 add a,b                ; 80
 add a,c                ; 81
 add a,d                ; 82
 add a,e                ; 83
 add a,h                ; 84
 add a,l                ; 85
 add b                  ; 80
 add c                  ; 81
 add d                  ; 82
 add e                  ; 83
 add h                  ; 84
 add hl,bc              ; 09
 add hl,de              ; 19
 add hl,hl              ; 29
 add hl,sp              ; 39
 add ix,bc              ; DD 09
 add ix,de              ; DD 19
 add ix,ix              ; DD 29
 add ix,sp              ; DD 39
 add iy,bc              ; FD 09
 add iy,de              ; FD 19
 add iy,iy              ; FD 29
 add iy,sp              ; FD 39
 add l                  ; 85
 and (hl)               ; A6
 and (ix)               ; DD A6 00
 and (ix+127)           ; DD A6 7F
 and (ix-128)           ; DD A6 80
 and (iy)               ; FD A6 00
 and (iy+127)           ; FD A6 7F
 and (iy-128)           ; FD A6 80
 and -128               ; E6 80
 and 127                ; E6 7F
 and 255                ; E6 FF
 and a                  ; A7
 and a,(hl)             ; A6
 and a,(ix)             ; DD A6 00
 and a,(ix+127)         ; DD A6 7F
 and a,(ix-128)         ; DD A6 80
 and a,(iy)             ; FD A6 00
 and a,(iy+127)         ; FD A6 7F
 and a,(iy-128)         ; FD A6 80
 and a,-128             ; E6 80
 and a,127              ; E6 7F
 and a,255              ; E6 FF
 and a,a                ; A7
 and a,b                ; A0
 and a,c                ; A1
 and a,d                ; A2
 and a,e                ; A3
 and a,h                ; A4
 and a,l                ; A5
 and b                  ; A0
 and c                  ; A1
 and d                  ; A2
 and e                  ; A3
 and h                  ; A4
 and l                  ; A5
 call -32768            ; CD 00 80
 call 32767             ; CD FF 7F
 call 65535             ; CD FF FF
 ccf                    ; 3F
 ccf f                  ; 3F
 cp (hl)                ; BE
 cp (ix)                ; DD BE 00
 cp (ix+127)            ; DD BE 7F
 cp (ix-128)            ; DD BE 80
 cp (iy)                ; FD BE 00
 cp (iy+127)            ; FD BE 7F
 cp (iy-128)            ; FD BE 80
 cp -128                ; FE 80
 cp 127                 ; FE 7F
 cp 255                 ; FE FF
 cp a                   ; BF
 cp a,(hl)              ; BE
 cp a,(ix)              ; DD BE 00
 cp a,(ix+127)          ; DD BE 7F
 cp a,(ix-128)          ; DD BE 80
 cp a,(iy)              ; FD BE 00
 cp a,(iy+127)          ; FD BE 7F
 cp a,(iy-128)          ; FD BE 80
 cp a,-128              ; FE 80
 cp a,127               ; FE 7F
 cp a,255               ; FE FF
 cp a,a                 ; BF
 cp a,b                 ; B8
 cp a,c                 ; B9
 cp a,d                 ; BA
 cp a,e                 ; BB
 cp a,h                 ; BC
 cp a,l                 ; BD
 cp b                   ; B8
 cp c                   ; B9
 cp d                   ; BA
 cp e                   ; BB
 cp h                   ; BC
 cp l                   ; BD
 cpd                    ; ED A9
 cpdr                   ; ED B9
 cpi                    ; ED A1
 cpir                   ; ED B1
 cpl                    ; 2F
 cpl a                  ; 2F
 daa                    ; 27
 dec (hl)               ; 35
 dec (ix)               ; DD 35 00
 dec (ix+127)           ; DD 35 7F
 dec (ix-128)           ; DD 35 80
 dec (iy)               ; FD 35 00
 dec (iy+127)           ; FD 35 7F
 dec (iy-128)           ; FD 35 80
 dec a                  ; 3D
 dec b                  ; 05
 dec bc                 ; 0B
 dec c                  ; 0D
 dec d                  ; 15
 dec de                 ; 1B
 dec e                  ; 1D
 dec h                  ; 25
 dec hl                 ; 2B
 dec ix                 ; DD 2B
 dec iy                 ; FD 2B
 dec l                  ; 2D
 dec sp                 ; 3B
 di                     ; F3
 djnz ASMPC             ; 10 FE
 djnz b,ASMPC           ; 10 FE
 ei                     ; FB
 halt                   ; 76
 im 0                   ; ED 46
 im 1                   ; ED 56
 im 2                   ; ED 5E
 in a,(-128)            ; DB 80
 in a,(127)             ; DB 7F
 in a,(255)             ; DB FF
 in a,(c)               ; ED 78
 in b,(c)               ; ED 40
 in c,(c)               ; ED 48
 in d,(c)               ; ED 50
 in e,(c)               ; ED 58
 in f,(c)               ; ED 70
 in h,(c)               ; ED 60
 in l,(c)               ; ED 68
 in0 a,(-128)           ; ED 38 80
 in0 a,(127)            ; ED 38 7F
 in0 a,(255)            ; ED 38 FF
 in0 b,(-128)           ; ED 00 80
 in0 b,(127)            ; ED 00 7F
 in0 b,(255)            ; ED 00 FF
 in0 c,(-128)           ; ED 08 80
 in0 c,(127)            ; ED 08 7F
 in0 c,(255)            ; ED 08 FF
 in0 d,(-128)           ; ED 10 80
 in0 d,(127)            ; ED 10 7F
 in0 d,(255)            ; ED 10 FF
 in0 e,(-128)           ; ED 18 80
 in0 e,(127)            ; ED 18 7F
 in0 e,(255)            ; ED 18 FF
 in0 f,(-128)           ; ED 30 80
 in0 f,(127)            ; ED 30 7F
 in0 f,(255)            ; ED 30 FF
 in0 h,(-128)           ; ED 20 80
 in0 h,(127)            ; ED 20 7F
 in0 h,(255)            ; ED 20 FF
 in0 l,(-128)           ; ED 28 80
 in0 l,(127)            ; ED 28 7F
 in0 l,(255)            ; ED 28 FF
 inc (hl)               ; 34
 inc (ix)               ; DD 34 00
 inc (ix+127)           ; DD 34 7F
 inc (ix-128)           ; DD 34 80
 inc (iy)               ; FD 34 00
 inc (iy+127)           ; FD 34 7F
 inc (iy-128)           ; FD 34 80
 inc a                  ; 3C
 inc b                  ; 04
 inc bc                 ; 03
 inc c                  ; 0C
 inc d                  ; 14
 inc de                 ; 13
 inc e                  ; 1C
 inc h                  ; 24
 inc hl                 ; 23
 inc ix                 ; DD 23
 inc iy                 ; FD 23
 inc l                  ; 2C
 inc sp                 ; 33
 ind                    ; ED AA
 indr                   ; ED BA
 ini                    ; ED A2
 inir                   ; ED B2
 jp (hl)                ; E9
 jp (ix)                ; DD E9
 jp (iy)                ; FD E9
 jp -32768              ; C3 00 80
 jp 32767               ; C3 FF 7F
 jp 65535               ; C3 FF FF
 jp c,-32768            ; DA 00 80
 jp c,32767             ; DA FF 7F
 jp c,65535             ; DA FF FF
 jp m,-32768            ; FA 00 80
 jp m,32767             ; FA FF 7F
 jp m,65535             ; FA FF FF
 jp nc,-32768           ; D2 00 80
 jp nc,32767            ; D2 FF 7F
 jp nc,65535            ; D2 FF FF
 jp nz,-32768           ; C2 00 80
 jp nz,32767            ; C2 FF 7F
 jp nz,65535            ; C2 FF FF
 jp p,-32768            ; F2 00 80
 jp p,32767             ; F2 FF 7F
 jp p,65535             ; F2 FF FF
 jp pe,-32768           ; EA 00 80
 jp pe,32767            ; EA FF 7F
 jp pe,65535            ; EA FF FF
 jp po,-32768           ; E2 00 80
 jp po,32767            ; E2 FF 7F
 jp po,65535            ; E2 FF FF
 jp z,-32768            ; CA 00 80
 jp z,32767             ; CA FF 7F
 jp z,65535             ; CA FF FF
 jr ASMPC               ; 18 FE
 jr c,ASMPC             ; 38 FE
 jr nc,ASMPC            ; 30 FE
 jr nz,ASMPC            ; 20 FE
 jr z,ASMPC             ; 28 FE
 ld (-32768),a          ; 32 00 80
 ld (-32768),bc         ; ED 43 00 80
 ld (-32768),de         ; ED 53 00 80
 ld (-32768),hl         ; 22 00 80
 ld (-32768),ix         ; DD 22 00 80
 ld (-32768),iy         ; FD 22 00 80
 ld (-32768),sp         ; ED 73 00 80
 ld (32767),a           ; 32 FF 7F
 ld (32767),bc          ; ED 43 FF 7F
 ld (32767),de          ; ED 53 FF 7F
 ld (32767),hl          ; 22 FF 7F
 ld (32767),ix          ; DD 22 FF 7F
 ld (32767),iy          ; FD 22 FF 7F
 ld (32767),sp          ; ED 73 FF 7F
 ld (65535),a           ; 32 FF FF
 ld (65535),bc          ; ED 43 FF FF
 ld (65535),de          ; ED 53 FF FF
 ld (65535),hl          ; 22 FF FF
 ld (65535),ix          ; DD 22 FF FF
 ld (65535),iy          ; FD 22 FF FF
 ld (65535),sp          ; ED 73 FF FF
 ld (bc),a              ; 02
 ld (de),a              ; 12
 ld (hl),-128           ; 36 80
 ld (hl),127            ; 36 7F
 ld (hl),255            ; 36 FF
 ld (hl),a              ; 77
 ld (hl),b              ; 70
 ld (hl),c              ; 71
 ld (hl),d              ; 72
 ld (hl),e              ; 73
 ld (hl),h              ; 74
 ld (hl),l              ; 75
 ld (ix),-128           ; DD 36 00 80
 ld (ix),127            ; DD 36 00 7F
 ld (ix),255            ; DD 36 00 FF
 ld (ix),a              ; DD 77 00
 ld (ix),b              ; DD 70 00
 ld (ix),c              ; DD 71 00
 ld (ix),d              ; DD 72 00
 ld (ix),e              ; DD 73 00
 ld (ix),h              ; DD 74 00
 ld (ix),l              ; DD 75 00
 ld (ix+127),-128       ; DD 36 7F 80
 ld (ix+127),127        ; DD 36 7F 7F
 ld (ix+127),255        ; DD 36 7F FF
 ld (ix+127),a          ; DD 77 7F
 ld (ix+127),b          ; DD 70 7F
 ld (ix+127),c          ; DD 71 7F
 ld (ix+127),d          ; DD 72 7F
 ld (ix+127),e          ; DD 73 7F
 ld (ix+127),h          ; DD 74 7F
 ld (ix+127),l          ; DD 75 7F
 ld (ix-128),-128       ; DD 36 80 80
 ld (ix-128),127        ; DD 36 80 7F
 ld (ix-128),255        ; DD 36 80 FF
 ld (ix-128),a          ; DD 77 80
 ld (ix-128),b          ; DD 70 80
 ld (ix-128),c          ; DD 71 80
 ld (ix-128),d          ; DD 72 80
 ld (ix-128),e          ; DD 73 80
 ld (ix-128),h          ; DD 74 80
 ld (ix-128),l          ; DD 75 80
 ld (iy),-128           ; FD 36 00 80
 ld (iy),127            ; FD 36 00 7F
 ld (iy),255            ; FD 36 00 FF
 ld (iy),a              ; FD 77 00
 ld (iy),b              ; FD 70 00
 ld (iy),c              ; FD 71 00
 ld (iy),d              ; FD 72 00
 ld (iy),e              ; FD 73 00
 ld (iy),h              ; FD 74 00
 ld (iy),l              ; FD 75 00
 ld (iy+127),-128       ; FD 36 7F 80
 ld (iy+127),127        ; FD 36 7F 7F
 ld (iy+127),255        ; FD 36 7F FF
 ld (iy+127),a          ; FD 77 7F
 ld (iy+127),b          ; FD 70 7F
 ld (iy+127),c          ; FD 71 7F
 ld (iy+127),d          ; FD 72 7F
 ld (iy+127),e          ; FD 73 7F
 ld (iy+127),h          ; FD 74 7F
 ld (iy+127),l          ; FD 75 7F
 ld (iy-128),-128       ; FD 36 80 80
 ld (iy-128),127        ; FD 36 80 7F
 ld (iy-128),255        ; FD 36 80 FF
 ld (iy-128),a          ; FD 77 80
 ld (iy-128),b          ; FD 70 80
 ld (iy-128),c          ; FD 71 80
 ld (iy-128),d          ; FD 72 80
 ld (iy-128),e          ; FD 73 80
 ld (iy-128),h          ; FD 74 80
 ld (iy-128),l          ; FD 75 80
 ld a,(-32768)          ; 3A 00 80
 ld a,(32767)           ; 3A FF 7F
 ld a,(65535)           ; 3A FF FF
 ld a,(bc)              ; 0A
 ld a,(de)              ; 1A
 ld a,(hl)              ; 7E
 ld a,(ix)              ; DD 7E 00
 ld a,(ix+127)          ; DD 7E 7F
 ld a,(ix-128)          ; DD 7E 80
 ld a,(iy)              ; FD 7E 00
 ld a,(iy+127)          ; FD 7E 7F
 ld a,(iy-128)          ; FD 7E 80
 ld a,-128              ; 3E 80
 ld a,127               ; 3E 7F
 ld a,255               ; 3E FF
 ld a,a                 ; 7F
 ld a,b                 ; 78
 ld a,c                 ; 79
 ld a,d                 ; 7A
 ld a,e                 ; 7B
 ld a,h                 ; 7C
 ld a,i                 ; ED 57
 ld a,l                 ; 7D
 ld a,r                 ; ED 5F
 ld b,(hl)              ; 46
 ld b,(ix)              ; DD 46 00
 ld b,(ix+127)          ; DD 46 7F
 ld b,(ix-128)          ; DD 46 80
 ld b,(iy)              ; FD 46 00
 ld b,(iy+127)          ; FD 46 7F
 ld b,(iy-128)          ; FD 46 80
 ld b,-128              ; 06 80
 ld b,127               ; 06 7F
 ld b,255               ; 06 FF
 ld b,a                 ; 47
 ld b,b                 ; 40
 ld b,c                 ; 41
 ld b,d                 ; 42
 ld b,e                 ; 43
 ld b,h                 ; 44
 ld b,l                 ; 45
 ld bc,(-32768)         ; ED 4B 00 80
 ld bc,(32767)          ; ED 4B FF 7F
 ld bc,(65535)          ; ED 4B FF FF
 ld bc,-32768           ; 01 00 80
 ld bc,32767            ; 01 FF 7F
 ld bc,65535            ; 01 FF FF
 ld c,(hl)              ; 4E
 ld c,(ix)              ; DD 4E 00
 ld c,(ix+127)          ; DD 4E 7F
 ld c,(ix-128)          ; DD 4E 80
 ld c,(iy)              ; FD 4E 00
 ld c,(iy+127)          ; FD 4E 7F
 ld c,(iy-128)          ; FD 4E 80
 ld c,-128              ; 0E 80
 ld c,127               ; 0E 7F
 ld c,255               ; 0E FF
 ld c,a                 ; 4F
 ld c,b                 ; 48
 ld c,c                 ; 49
 ld c,d                 ; 4A
 ld c,e                 ; 4B
 ld c,h                 ; 4C
 ld c,l                 ; 4D
 ld d,(hl)              ; 56
 ld d,(ix)              ; DD 56 00
 ld d,(ix+127)          ; DD 56 7F
 ld d,(ix-128)          ; DD 56 80
 ld d,(iy)              ; FD 56 00
 ld d,(iy+127)          ; FD 56 7F
 ld d,(iy-128)          ; FD 56 80
 ld d,-128              ; 16 80
 ld d,127               ; 16 7F
 ld d,255               ; 16 FF
 ld d,a                 ; 57
 ld d,b                 ; 50
 ld d,c                 ; 51
 ld d,d                 ; 52
 ld d,e                 ; 53
 ld d,h                 ; 54
 ld d,l                 ; 55
 ld de,(-32768)         ; ED 5B 00 80
 ld de,(32767)          ; ED 5B FF 7F
 ld de,(65535)          ; ED 5B FF FF
 ld de,-32768           ; 11 00 80
 ld de,32767            ; 11 FF 7F
 ld de,65535            ; 11 FF FF
 ld e,(hl)              ; 5E
 ld e,(ix)              ; DD 5E 00
 ld e,(ix+127)          ; DD 5E 7F
 ld e,(ix-128)          ; DD 5E 80
 ld e,(iy)              ; FD 5E 00
 ld e,(iy+127)          ; FD 5E 7F
 ld e,(iy-128)          ; FD 5E 80
 ld e,-128              ; 1E 80
 ld e,127               ; 1E 7F
 ld e,255               ; 1E FF
 ld e,a                 ; 5F
 ld e,b                 ; 58
 ld e,c                 ; 59
 ld e,d                 ; 5A
 ld e,e                 ; 5B
 ld e,h                 ; 5C
 ld e,l                 ; 5D
 ld h,(hl)              ; 66
 ld h,(ix)              ; DD 66 00
 ld h,(ix+127)          ; DD 66 7F
 ld h,(ix-128)          ; DD 66 80
 ld h,(iy)              ; FD 66 00
 ld h,(iy+127)          ; FD 66 7F
 ld h,(iy-128)          ; FD 66 80
 ld h,-128              ; 26 80
 ld h,127               ; 26 7F
 ld h,255               ; 26 FF
 ld h,a                 ; 67
 ld h,b                 ; 60
 ld h,c                 ; 61
 ld h,d                 ; 62
 ld h,e                 ; 63
 ld h,h                 ; 64
 ld h,l                 ; 65
 ld hl,(-32768)         ; 2A 00 80
 ld hl,(32767)          ; 2A FF 7F
 ld hl,(65535)          ; 2A FF FF
 ld hl,-32768           ; 21 00 80
 ld hl,32767            ; 21 FF 7F
 ld hl,65535            ; 21 FF FF
 ld i,a                 ; ED 47
 ld ix,(-32768)         ; DD 2A 00 80
 ld ix,(32767)          ; DD 2A FF 7F
 ld ix,(65535)          ; DD 2A FF FF
 ld ix,-32768           ; DD 21 00 80
 ld ix,32767            ; DD 21 FF 7F
 ld ix,65535            ; DD 21 FF FF
 ld iy,(-32768)         ; FD 2A 00 80
 ld iy,(32767)          ; FD 2A FF 7F
 ld iy,(65535)          ; FD 2A FF FF
 ld iy,-32768           ; FD 21 00 80
 ld iy,32767            ; FD 21 FF 7F
 ld iy,65535            ; FD 21 FF FF
 ld l,(hl)              ; 6E
 ld l,(ix)              ; DD 6E 00
 ld l,(ix+127)          ; DD 6E 7F
 ld l,(ix-128)          ; DD 6E 80
 ld l,(iy)              ; FD 6E 00
 ld l,(iy+127)          ; FD 6E 7F
 ld l,(iy-128)          ; FD 6E 80
 ld l,-128              ; 2E 80
 ld l,127               ; 2E 7F
 ld l,255               ; 2E FF
 ld l,a                 ; 6F
 ld l,b                 ; 68
 ld l,c                 ; 69
 ld l,d                 ; 6A
 ld l,e                 ; 6B
 ld l,h                 ; 6C
 ld l,l                 ; 6D
 ld r,a                 ; ED 4F
 ld sp,(-32768)         ; ED 7B 00 80
 ld sp,(32767)          ; ED 7B FF 7F
 ld sp,(65535)          ; ED 7B FF FF
 ld sp,-32768           ; 31 00 80
 ld sp,32767            ; 31 FF 7F
 ld sp,65535            ; 31 FF FF
 ld sp,hl               ; F9
 ld sp,ix               ; DD F9
 ld sp,iy               ; FD F9
 ldd                    ; ED A8
 lddr                   ; ED B8
 ldi                    ; ED A0
 ldir                   ; ED B0
 mlt bc                 ; ED 4C
 mlt de                 ; ED 5C
 mlt hl                 ; ED 6C
 mlt sp                 ; ED 7C
 neg                    ; ED 44
 neg a                  ; ED 44
 nop                    ; 00
 or (hl)                ; B6
 or (ix)                ; DD B6 00
 or (ix+127)            ; DD B6 7F
 or (ix-128)            ; DD B6 80
 or (iy)                ; FD B6 00
 or (iy+127)            ; FD B6 7F
 or (iy-128)            ; FD B6 80
 or -128                ; F6 80
 or 127                 ; F6 7F
 or 255                 ; F6 FF
 or a                   ; B7
 or a,(hl)              ; B6
 or a,(ix)              ; DD B6 00
 or a,(ix+127)          ; DD B6 7F
 or a,(ix-128)          ; DD B6 80
 or a,(iy)              ; FD B6 00
 or a,(iy+127)          ; FD B6 7F
 or a,(iy-128)          ; FD B6 80
 or a,-128              ; F6 80
 or a,127               ; F6 7F
 or a,255               ; F6 FF
 or a,a                 ; B7
 or a,b                 ; B0
 or a,c                 ; B1
 or a,d                 ; B2
 or a,e                 ; B3
 or a,h                 ; B4
 or a,l                 ; B5
 or b                   ; B0
 or c                   ; B1
 or d                   ; B2
 or e                   ; B3
 or h                   ; B4
 or l                   ; B5
 otdm                   ; ED 8B
 otdmr                  ; ED 9B
 otdr                   ; ED BB
 otim                   ; ED 83
 otimr                  ; ED 93
 otir                   ; ED B3
 out (-128),a           ; D3 80
 out (127),a            ; D3 7F
 out (255),a            ; D3 FF
 out (c),0              ; ED 71
 out (c),a              ; ED 79
 out (c),b              ; ED 41
 out (c),c              ; ED 49
 out (c),d              ; ED 51
 out (c),e              ; ED 59
 out (c),h              ; ED 61
 out (c),l              ; ED 69
 out0 (-128),a          ; ED 39 80
 out0 (-128),b          ; ED 01 80
 out0 (-128),c          ; ED 09 80
 out0 (-128),d          ; ED 11 80
 out0 (-128),e          ; ED 19 80
 out0 (-128),h          ; ED 21 80
 out0 (-128),l          ; ED 29 80
 out0 (127),a           ; ED 39 7F
 out0 (127),b           ; ED 01 7F
 out0 (127),c           ; ED 09 7F
 out0 (127),d           ; ED 11 7F
 out0 (127),e           ; ED 19 7F
 out0 (127),h           ; ED 21 7F
 out0 (127),l           ; ED 29 7F
 out0 (255),a           ; ED 39 FF
 out0 (255),b           ; ED 01 FF
 out0 (255),c           ; ED 09 FF
 out0 (255),d           ; ED 11 FF
 out0 (255),e           ; ED 19 FF
 out0 (255),h           ; ED 21 FF
 out0 (255),l           ; ED 29 FF
 outd                   ; ED AB
 outi                   ; ED A3
 pop af                 ; F1
 pop bc                 ; C1
 pop de                 ; D1
 pop hl                 ; E1
 pop ix                 ; DD E1
 pop iy                 ; FD E1
 push af                ; F5
 push bc                ; C5
 push de                ; D5
 push hl                ; E5
 push ix                ; DD E5
 push iy                ; FD E5
 ret                    ; C9
 ret c                  ; D8
 ret m                  ; F8
 ret nc                 ; D0
 ret nz                 ; C0
 ret p                  ; F0
 ret pe                 ; E8
 ret po                 ; E0
 ret z                  ; C8
 reti                   ; ED 4D
 retn                   ; ED 45
 rld                    ; ED 6F
 rrd                    ; ED 67
 rst 0                  ; C7
 rst 16                 ; D7
 rst 24                 ; DF
 rst 32                 ; E7
 rst 40                 ; EF
 rst 48                 ; F7
 rst 56                 ; FF
 rst 8                  ; CF
 sbc (hl)               ; 9E
 sbc (ix)               ; DD 9E 00
 sbc (ix+127)           ; DD 9E 7F
 sbc (ix-128)           ; DD 9E 80
 sbc (iy)               ; FD 9E 00
 sbc (iy+127)           ; FD 9E 7F
 sbc (iy-128)           ; FD 9E 80
 sbc -128               ; DE 80
 sbc 127                ; DE 7F
 sbc 255                ; DE FF
 sbc a                  ; 9F
 sbc a,(hl)             ; 9E
 sbc a,(ix)             ; DD 9E 00
 sbc a,(ix+127)         ; DD 9E 7F
 sbc a,(ix-128)         ; DD 9E 80
 sbc a,(iy)             ; FD 9E 00
 sbc a,(iy+127)         ; FD 9E 7F
 sbc a,(iy-128)         ; FD 9E 80
 sbc a,-128             ; DE 80
 sbc a,127              ; DE 7F
 sbc a,255              ; DE FF
 sbc a,a                ; 9F
 sbc a,b                ; 98
 sbc a,c                ; 99
 sbc a,d                ; 9A
 sbc a,e                ; 9B
 sbc a,h                ; 9C
 sbc a,l                ; 9D
 sbc b                  ; 98
 sbc c                  ; 99
 sbc d                  ; 9A
 sbc e                  ; 9B
 sbc h                  ; 9C
 sbc hl,bc              ; ED 42
 sbc hl,de              ; ED 52
 sbc hl,hl              ; ED 62
 sbc hl,sp              ; ED 72
 sbc l                  ; 9D
 scf                    ; 37
 scf f                  ; 37
 slp                    ; ED 76
 sub (hl)               ; 96
 sub (ix)               ; DD 96 00
 sub (ix+127)           ; DD 96 7F
 sub (ix-128)           ; DD 96 80
 sub (iy)               ; FD 96 00
 sub (iy+127)           ; FD 96 7F
 sub (iy-128)           ; FD 96 80
 sub -128               ; D6 80
 sub 127                ; D6 7F
 sub 255                ; D6 FF
 sub a                  ; 97
 sub a,(hl)             ; 96
 sub a,(ix)             ; DD 96 00
 sub a,(ix+127)         ; DD 96 7F
 sub a,(ix-128)         ; DD 96 80
 sub a,(iy)             ; FD 96 00
 sub a,(iy+127)         ; FD 96 7F
 sub a,(iy-128)         ; FD 96 80
 sub a,-128             ; D6 80
 sub a,127              ; D6 7F
 sub a,255              ; D6 FF
 sub a,a                ; 97
 sub a,b                ; 90
 sub a,c                ; 91
 sub a,d                ; 92
 sub a,e                ; 93
 sub a,h                ; 94
 sub a,l                ; 95
 sub b                  ; 90
 sub c                  ; 91
 sub d                  ; 92
 sub e                  ; 93
 sub h                  ; 94
 sub l                  ; 95
 tst (hl)               ; ED 34
 tst -128               ; ED 64 80
 tst 127                ; ED 64 7F
 tst 255                ; ED 64 FF
 tst a                  ; ED 3C
 tst a,(hl)             ; ED 34
 tst a,-128             ; ED 64 80
 tst a,127              ; ED 64 7F
 tst a,255              ; ED 64 FF
 tst a,a                ; ED 3C
 tst a,b                ; ED 04
 tst a,c                ; ED 0C
 tst a,d                ; ED 14
 tst a,e                ; ED 1C
 tst a,h                ; ED 24
 tst a,l                ; ED 2C
 tst b                  ; ED 04
 tst c                  ; ED 0C
 tst d                  ; ED 14
 tst e                  ; ED 1C
 tst h                  ; ED 24
 tst l                  ; ED 2C
 tstio -128             ; ED 74 80
 tstio 127              ; ED 74 7F
 tstio 255              ; ED 74 FF
 xor (hl)               ; AE
 xor (ix)               ; DD AE 00
 xor (ix+127)           ; DD AE 7F
 xor (ix-128)           ; DD AE 80
 xor (iy)               ; FD AE 00
 xor (iy+127)           ; FD AE 7F
 xor (iy-128)           ; FD AE 80
 xor -128               ; EE 80
 xor 127                ; EE 7F
 xor 255                ; EE FF
 xor a                  ; AF
 xor a,(hl)             ; AE
 xor a,(ix)             ; DD AE 00
 xor a,(ix+127)         ; DD AE 7F
 xor a,(ix-128)         ; DD AE 80
 xor a,(iy)             ; FD AE 00
 xor a,(iy+127)         ; FD AE 7F
 xor a,(iy-128)         ; FD AE 80
 xor a,-128             ; EE 80
 xor a,127              ; EE 7F
 xor a,255              ; EE FF
 xor a,a                ; AF
 xor a,b                ; A8
 xor a,c                ; A9
 xor a,d                ; AA
 xor a,e                ; AB
 xor a,h                ; AC
 xor a,l                ; AD
 xor b                  ; A8
 xor c                  ; A9
 xor d                  ; AA
 xor e                  ; AB
 xor h                  ; AC
 xor l                  ; AD
