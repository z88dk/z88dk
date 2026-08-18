# gbz80 full opcode map (Zilog mnemonics)

**Mnemonics:** Zilog (z88dk house style). Nintendo / Intel names from
[pastraiser](https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html)
are in the Intel column.

**Flags / cycles:** Pastraiser order **Z N H C**.

**Encodings:** `src/z80asm/dev/cpu/cpu_test_gbz80_strict_ok.asm` (native /
accepted aliases) and `cpu_test_gbz80_ok.asm` (synthetics). Opcode bytes
match Pastraiser **100%**. Unused cells are the same 11 holes.

Immediate placeholders: `*` = 8-bit, `**` = 16-bit. `*` is signed on
`jr`, `add sp,*`, and `ld hl,sp+*`. `*` is an unsigned HRAM offset on `ldh`.

---

## Opcode grid summary

Rows = high nibble, columns = low nibble. Cell: **Zilog mnemonic**.

|    | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | A | B | C | D | E | F |
|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **0** | nop | ld bc,** | ld (bc),a | inc bc | inc b | dec b | ld b,* | rlca | ld (**),sp | add hl,bc | ld a,(bc) | dec bc | inc c | dec c | ld c,* | rrca |
| **1** | stop | ld de,** | ld (de),a | inc de | inc d | dec d | ld d,* | rla | jr * | add hl,de | ld a,(de) | dec de | inc e | dec e | ld e,* | rra |
| **2** | jr nz,* | ld hl,** | ld (hl+),a | inc hl | inc h | dec h | ld h,* | daa | jr z,* | add hl,hl | ld a,(hl+) | dec hl | inc l | dec l | ld l,* | cpl |
| **3** | jr nc,* | ld sp,** | ld (hl-),a | inc sp | inc (hl) | dec (hl) | ld (hl),* | scf | jr c,* | add hl,sp | ld a,(hl-) | dec sp | inc a | dec a | ld a,* | ccf |
| **4** | ld b,b | ld b,c | ld b,d | ld b,e | ld b,h | ld b,l | ld b,(hl) | ld b,a | ld c,b | ld c,c | ld c,d | ld c,e | ld c,h | ld c,l | ld c,(hl) | ld c,a |
| **5** | ld d,b | ld d,c | ld d,d | ld d,e | ld d,h | ld d,l | ld d,(hl) | ld d,a | ld e,b | ld e,c | ld e,d | ld e,e | ld e,h | ld e,l | ld e,(hl) | ld e,a |
| **6** | ld h,b | ld h,c | ld h,d | ld h,e | ld h,h | ld h,l | ld h,(hl) | ld h,a | ld l,b | ld l,c | ld l,d | ld l,e | ld l,h | ld l,l | ld l,(hl) | ld l,a |
| **7** | ld (hl),b | ld (hl),c | ld (hl),d | ld (hl),e | ld (hl),h | ld (hl),l | halt | ld (hl),a | ld a,b | ld a,c | ld a,d | ld a,e | ld a,h | ld a,l | ld a,(hl) | ld a,a |
| **8** | add a,b | add a,c | add a,d | add a,e | add a,h | add a,l | add a,(hl) | add a,a | adc a,b | adc a,c | adc a,d | adc a,e | adc a,h | adc a,l | adc a,(hl) | adc a,a |
| **9** | sub b | sub c | sub d | sub e | sub h | sub l | sub (hl) | sub a | sbc a,b | sbc a,c | sbc a,d | sbc a,e | sbc a,h | sbc a,l | sbc a,(hl) | sbc a,a |
| **A** | and b | and c | and d | and e | and h | and l | and (hl) | and a | xor b | xor c | xor d | xor e | xor h | xor l | xor (hl) | xor a |
| **B** | or b | or c | or d | or e | or h | or l | or (hl) | or a | cp b | cp c | cp d | cp e | cp h | cp l | cp (hl) | cp a |
| **C** | ret nz | pop bc | jp nz,** | jp ** | call nz,** | push bc | add a,* | rst 00h | ret z | ret | jp z,** | prefix cb | call z,** | call ** | adc a,* | rst 08h |
| **D** | ret nc | pop de | jp nc,** | — | call nc,** | push de | sub * | rst 10h | ret c | reti | jp c,** | — | call c,** | — | sbc a,* | rst 18h |
| **E** | ldh (*),a | pop hl | ld (c),a | — | — | push hl | and * | rst 20h | add sp,* | jp (hl) | ld (**),a | — | — | — | xor * | rst 28h |
| **F** | ldh a,(*) | pop af | ld a,(c) | di | — | push af | or * | rst 30h | ld hl,sp+* | ld sp,hl | ld a,(**) | ei | — | — | cp * | rst 38h |

Unused (illegal) cells: `D3` `DB` `DD` `E3` `E4` `EB` `EC` `ED` `F4` `FC` `FD`.

GB-only cells vs Z80 at the same byte: `08` `10` `22` `2A` `32` `3A` `D9`
`E0` `E2` `E8` `EA` `F0` `F2` `F8` `FA`, plus `CB 30`–`CB 37` (`swap`).

---

## Detailed table (op · Zilog · Nintendo · bytes · cycles · flags · notes)

Flags column: **ZNHC**.

### 0x

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| 00 | nop | NOP | 1 | 4 | ---- | |
| 01 | ld bc,** | LD BC,d16 | 3 | 12 | ---- | |
| 02 | ld (bc),a | LD (BC),A | 1 | 8 | ---- | |
| 03 | inc bc | INC BC | 1 | 8 | ---- | |
| 04 | inc b | INC B | 1 | 4 | Z0H- | |
| 05 | dec b | DEC B | 1 | 4 | Z1H- | |
| 06 | ld b,* | LD B,d8 | 2 | 8 | ---- | |
| 07 | rlca | RLCA | 1 | 4 | 000C | Z←0 |
| 08 | ld (**),sp | LD (a16),SP | 3 | 20 | ---- | GB-only. Not Z80 `ex af,af'` |
| 09 | add hl,bc | ADD HL,BC | 1 | 8 | -0HC | Z unchanged |
| 0A | ld a,(bc) | LD A,(BC) | 1 | 8 | ---- | |
| 0B | dec bc | DEC BC | 1 | 8 | ---- | does **not** set Z |
| 0C | inc c | INC C | 1 | 4 | Z0H- | |
| 0D | dec c | DEC C | 1 | 4 | Z1H- | |
| 0E | ld c,* | LD C,d8 | 2 | 8 | ---- | |
| 0F | rrca | RRCA | 1 | 4 | 000C | Z←0 |

### 1x

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| 10 | stop | STOP 0 | 2 | 4 | ---- | encoding `10 00`. Not Z80 `djnz` |
| 11 | ld de,** | LD DE,d16 | 3 | 12 | ---- | |
| 12 | ld (de),a | LD (DE),A | 1 | 8 | ---- | |
| 13 | inc de | INC DE | 1 | 8 | ---- | |
| 14 | inc d | INC D | 1 | 4 | Z0H- | |
| 15 | dec d | DEC D | 1 | 4 | Z1H- | |
| 16 | ld d,* | LD D,d8 | 2 | 8 | ---- | |
| 17 | rla | RLA | 1 | 4 | 000C | Z←0 |
| 18 | jr * | JR r8 | 2 | 12 | ---- | * signed |
| 19 | add hl,de | ADD HL,DE | 1 | 8 | -0HC | |
| 1A | ld a,(de) | LD A,(DE) | 1 | 8 | ---- | |
| 1B | dec de | DEC DE | 1 | 8 | ---- | |
| 1C | inc e | INC E | 1 | 4 | Z0H- | |
| 1D | dec e | DEC E | 1 | 4 | Z1H- | |
| 1E | ld e,* | LD E,d8 | 2 | 8 | ---- | |
| 1F | rra | RRA | 1 | 4 | 000C | Z←0 |

### 2x

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| 20 | jr nz,* | JR NZ,r8 | 2 | 12/8 | ---- | * signed |
| 21 | ld hl,** | LD HL,d16 | 3 | 12 | ---- | |
| 22 | ld (hl+),a | LD (HL+),A | 1 | 8 | ---- | also `ld (hli),a` / `ldi (hl),a` |
| 23 | inc hl | INC HL | 1 | 8 | ---- | |
| 24 | inc h | INC H | 1 | 4 | Z0H- | |
| 25 | dec h | DEC H | 1 | 4 | Z1H- | |
| 26 | ld h,* | LD H,d8 | 2 | 8 | ---- | |
| 27 | daa | DAA | 1 | 4 | Z-0C | |
| 28 | jr z,* | JR Z,r8 | 2 | 12/8 | ---- | |
| 29 | add hl,hl | ADD HL,HL | 1 | 8 | -0HC | |
| 2A | ld a,(hl+) | LD A,(HL+) | 1 | 8 | ---- | also `ld a,(hli)` / `ldi a,(hl)` |
| 2B | dec hl | DEC HL | 1 | 8 | ---- | |
| 2C | inc l | INC L | 1 | 4 | Z0H- | |
| 2D | dec l | DEC L | 1 | 4 | Z1H- | |
| 2E | ld l,* | LD L,d8 | 2 | 8 | ---- | |
| 2F | cpl | CPL | 1 | 4 | -11- | |

### 3x

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| 30 | jr nc,* | JR NC,r8 | 2 | 12/8 | ---- | |
| 31 | ld sp,** | LD SP,d16 | 3 | 12 | ---- | |
| 32 | ld (hl-),a | LD (HL-),A | 1 | 8 | ---- | also `ld (hld),a` / `ldd (hl),a` |
| 33 | inc sp | INC SP | 1 | 8 | ---- | |
| 34 | inc (hl) | INC (HL) | 1 | 12 | Z0H- | |
| 35 | dec (hl) | DEC (HL) | 1 | 12 | Z1H- | |
| 36 | ld (hl),* | LD (HL),d8 | 2 | 12 | ---- | |
| 37 | scf | SCF | 1 | 4 | -001 | C←1 |
| 38 | jr c,* | JR C,r8 | 2 | 12/8 | ---- | |
| 39 | add hl,sp | ADD HL,SP | 1 | 8 | -0HC | |
| 3A | ld a,(hl-) | LD A,(HL-) | 1 | 8 | ---- | also `ld a,(hld)` / `ldd a,(hl)` |
| 3B | dec sp | DEC SP | 1 | 8 | ---- | |
| 3C | inc a | INC A | 1 | 4 | Z0H- | |
| 3D | dec a | DEC A | 1 | 4 | Z1H- | |
| 3E | ld a,* | LD A,d8 | 2 | 8 | ---- | |
| 3F | ccf | CCF | 1 | 4 | -00C | C toggled |

### 4x–7x — 8-bit loads

All `ld r,r'` / `ld r,(hl)` / `ld (hl),r`: flags `----`.
Cycles: register–register **4**; involving `(hl)` **8**.
`halt` (`76`): 1 byte, **4** cycles, `----`.

| Pattern | Nintendo | Example |
|---------|----------|---------|
| `ld r,r'` | LD r,r' | `ld a,b` |
| `ld r,(hl)` | LD r,(HL) | `ld a,(hl)` |
| `ld (hl),r` | LD (HL),r | `ld (hl),a` |
| `halt` | HALT | |

Encoding: high nibble destination row (4=B, 5=D, 6=H, 7=(HL)/A), low nibble
source (B C D E H L (HL) A).

### 8x — add / adc

| Op | Zilog | Nintendo | B | Cyc | Flags |
|----|-------|----------|---|-----|-------|
| 80–87 | add a,{b,c,d,e,h,l,(hl),a} | ADD A,r | 1 | 4/8 | Z0HC |
| 88–8F | adc a,{b,c,d,e,h,l,(hl),a} | ADC A,r | 1 | 4/8 | Z0HC |

`(hl)` forms are 8 cycles; others 4.

### 9x — sub / sbc

| Op | Zilog | Nintendo | B | Cyc | Flags |
|----|-------|----------|---|-----|-------|
| 90–97 | sub {b,c,d,e,h,l,(hl),a} | SUB r | 1 | 4/8 | Z1HC |
| 98–9F | sbc a,{b,c,d,e,h,l,(hl),a} | SBC A,r | 1 | 4/8 | Z1HC |

Normal-mode aliases: `sub a,r`. House style in `8-gbz80/` writes `sub a,r`.

### Ax — and / xor

| Op | Zilog | Nintendo | B | Cyc | Flags |
|----|-------|----------|---|-----|-------|
| A0–A7 | and {b,c,d,e,h,l,(hl),a} | AND r | 1 | 4/8 | Z010 |
| A8–AF | xor {b,c,d,e,h,l,(hl),a} | XOR r | 1 | 4/8 | Z000 |

### Bx — or / cp

| Op | Zilog | Nintendo | B | Cyc | Flags |
|----|-------|----------|---|-----|-------|
| B0–B7 | or {b,c,d,e,h,l,(hl),a} | OR r | 1 | 4/8 | Z000 |
| B8–BF | cp {b,c,d,e,h,l,(hl),a} | CP r | 1 | 4/8 | Z1HC |

### Cx

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| C0 | ret nz | RET NZ | 1 | 20/8 | ---- | |
| C1 | pop bc | POP BC | 1 | 12 | ---- | |
| C2 | jp nz,** | JP NZ,a16 | 3 | 16/12 | ---- | |
| C3 | jp ** | JP a16 | 3 | 16 | ---- | |
| C4 | call nz,** | CALL NZ,a16 | 3 | 24/12 | ---- | |
| C5 | push bc | PUSH BC | 1 | 16 | ---- | |
| C6 | add a,* | ADD A,d8 | 2 | 8 | Z0HC | |
| C7 | rst 00h | RST 00H | 1 | 16 | ---- | PC←0000h |
| C8 | ret z | RET Z | 1 | 20/8 | ---- | |
| C9 | ret | RET | 1 | 16 | ---- | |
| CA | jp z,** | JP Z,a16 | 3 | 16/12 | ---- | |
| CB | prefix cb | PREFIX CB | 1 | 4 | ---- | see CB grid. Not 8085 `rst v` |
| CC | call z,** | CALL Z,a16 | 3 | 24/12 | ---- | |
| CD | call ** | CALL a16 | 3 | 24 | ---- | |
| CE | adc a,* | ADC A,d8 | 2 | 8 | Z0HC | |
| CF | rst 08h | RST 08H | 1 | 16 | ---- | PC←0008h |

### Dx

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| D0 | ret nc | RET NC | 1 | 20/8 | ---- | |
| D1 | pop de | POP DE | 1 | 12 | ---- | |
| D2 | jp nc,** | JP NC,a16 | 3 | 16/12 | ---- | |
| D3 | — | — | | | | unused |
| D4 | call nc,** | CALL NC,a16 | 3 | 24/12 | ---- | |
| D5 | push de | PUSH DE | 1 | 16 | ---- | |
| D6 | sub * | SUB d8 | 2 | 8 | Z1HC | |
| D7 | rst 10h | RST 10H | 1 | 16 | ---- | PC←0010h |
| D8 | ret c | RET C | 1 | 20/8 | ---- | |
| D9 | reti | RETI | 1 | 16 | ---- | GB-only. Not Z80 `exx` |
| DA | jp c,** | JP C,a16 | 3 | 16/12 | ---- | |
| DB | — | — | | | | unused (not `in`) |
| DC | call c,** | CALL C,a16 | 3 | 24/12 | ---- | |
| DD | — | — | | | | unused (not IX prefix) |
| DE | sbc a,* | SBC A,d8 | 2 | 8 | Z1HC | |
| DF | rst 18h | RST 18H | 1 | 16 | ---- | PC←0018h |

### Ex

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| E0 | ldh (*),a | LDH (a8),A | 2 | 12 | ---- | (`$FF00`+\*)←A. `ld a,($ff00+n)` is **not** this op (that is `FA`). Write `ldh` |
| E1 | pop hl | POP HL | 1 | 12 | ---- | |
| E2 | ld (c),a | LD (C),A | 1 | 8 | ---- | (`$FF00`+C)←A. Also `ldh (c),a` / `ld (0xff00+c),a`. Pastraiser length column says 2. z80asm emits **1** |
| E3 | — | — | | | | unused (not `ex (sp),hl`) |
| E4 | — | — | | | | unused |
| E5 | push hl | PUSH HL | 1 | 16 | ---- | |
| E6 | and * | AND d8 | 2 | 8 | Z010 | |
| E7 | rst 20h | RST 20H | 1 | 16 | ---- | PC←0020h |
| E8 | add sp,* | ADD SP,r8 | 2 | 16 | 00HC | * signed. Z←0 |
| E9 | jp (hl) | JP (HL) | 1 | 4 | ---- | |
| EA | ld (**),a | LD (a16),A | 3 | 16 | ---- | not Z80 `jp pe` |
| EB | — | — | | | | unused (not `ex de,hl`) |
| EC | — | — | | | | unused |
| ED | — | — | | | | unused (not Z80 ED prefix) |
| EE | xor * | XOR d8 | 2 | 8 | Z000 | |
| EF | rst 28h | RST 28H | 1 | 16 | ---- | PC←0028h |

### Fx

| Op | Zilog | Nintendo | B | Cyc | Flags | Notes |
|----|-------|----------|---|-----|-------|-------|
| F0 | ldh a,(*) | LDH A,(a8) | 2 | 12 | ---- | A←(`$FF00`+\*). Write `ldh`, not `ld a,($ff00+n)` |
| F1 | pop af | POP AF | 1 | 12 | ZNHC | low nibble of F stays 0 |
| F2 | ld a,(c) | LD A,(C) | 1 | 8 | ---- | A←(`$FF00`+C). Also `ldh a,(c)` / `ld a,(0xff00+c)`. Pastraiser length 2. z80asm **1** |
| F3 | di | DI | 1 | 4 | ---- | |
| F4 | — | — | | | | unused |
| F5 | push af | PUSH AF | 1 | 16 | ---- | |
| F6 | or * | OR d8 | 2 | 8 | Z000 | |
| F7 | rst 30h | RST 30H | 1 | 16 | ---- | PC←0030h |
| F8 | ld hl,sp+* | LD HL,SP+r8 | 2 | 12 | 00HC | * signed. Also `ldhl sp,*`. `ld hl,sp` = `F8 00` |
| F9 | ld sp,hl | LD SP,HL | 1 | 8 | ---- | |
| FA | ld a,(**) | LD A,(a16) | 3 | 16 | ---- | not Z80 `jp m` |
| FB | ei | EI | 1 | 4 | ---- | enable after the next instruction |
| FC | — | — | | | | unused |
| FD | — | — | | | | unused (not IY prefix) |
| FE | cp * | CP d8 | 2 | 8 | Z1HC | |
| FF | rst 38h | RST 38H | 1 | 16 | ---- | PC←0038h |

---

## RST targets

| Zilog | Op | Vector |
|-------|-----|--------|
| rst 00h | C7 | 0000h |
| rst 08h | CF | 0008h |
| rst 10h | D7 | 0010h |
| rst 18h | DF | 0018h |
| rst 20h | E7 | 0020h |
| rst 28h | EF | 0028h |
| rst 30h | F7 | 0030h |
| rst 38h | FF | 0038h |

z80asm also accepts `rst 0`…`rst 7` and `rst 8`/`16`/`24`/`32`/`40`/`48`/`56`
as the same eight ops.

---

## Prefix CB

Second byte. Register order in the low 3 bits: `b c d e h l (hl) a`.

| CB hi | Zilog | Nintendo | B | Cyc | Flags |
|-------|-------|----------|---|-----|-------|
| `00`–`07` | rlc r | RLC r | 2 | 8/16 | Z00C |
| `08`–`0F` | rrc r | RRC r | 2 | 8/16 | Z00C |
| `10`–`17` | rl r | RL r | 2 | 8/16 | Z00C |
| `18`–`1F` | rr r | RR r | 2 | 8/16 | Z00C |
| `20`–`27` | sla r | SLA r | 2 | 8/16 | Z00C |
| `28`–`2F` | sra r | SRA r | 2 | 8/16 | Z000† |
| `30`–`37` | swap r | SWAP r | 2 | 8/16 | Z000 |
| `38`–`3F` | srl r | SRL r | 2 | 8/16 | Z00C |
| `40`–`7F` | bit n,r | BIT n,r | 2 | 8/16 | Z01- |
| `80`–`BF` | res n,r | RES n,r | 2 | 8/16 | ---- |
| `C0`–`FF` | set n,r | SET n,r | 2 | 8/16 | ---- |

`(hl)` forms are 16 cycles; others 8. `n` for bit/res/set is `(op − base) / 8`.

† Pastraiser prints `Z 0 0 0` for `sra`. `l_asr.asm` uses `sra h` / `rr l`
and needs C = old bit 0 of H. Treat C as live when you write shifts.

`swap` is Game Boy only (Z80 uses this CB row for `sll`, undocumented).

---

## Nintendo aliases accepted by z80asm (same encoding)

Write the Zilog form in new sources. These assemble on `-mgbz80` (strict too,
unless noted).

| Nintendo / alias | Zilog | Enc |
|------------------|-------|-----|
| `ld (hli),a` / `ldi (hl),a` | `ld (hl+),a` | `22` |
| `ld a,(hli)` / `ldi a,(hl)` | `ld a,(hl+)` | `2A` |
| `ld (hld),a` / `ldd (hl),a` | `ld (hl-),a` | `32` |
| `ld a,(hld)` / `ldd a,(hl)` | `ld a,(hl-)` | `3A` |
| `ldhl sp,*` | `ld hl,sp+*` | `F8 *` |
| `ld hl,sp` | `ld hl,sp+0` | `F8 00` |
| `ldh (c),a` / `ld (0xff00+c),a` | `ld (c),a` | `E2` |
| `ldh a,(c)` / `ld a,(0xff00+c)` | `ld a,(c)` | `F2` |
| `ldh (*),a` | (house name) | `E0 *` |
| `ldh a,(*)` | (house name) | `F0 *` |

---

## Synthetics (normal mode, from `cpu_test_gbz80_ok.asm`)

Not in Pastraiser as single opcodes. z80asm expands them. Strict mode
rejects the free ones. Intel 8080 spellings (`mov`, `lxi`, `dad`, …) also
assemble in normal mode. Do not write them.

### Pair copies (prefer)

| Zilog | Enc |
|-------|-----|
| `ld bc,de` | `42 4B` |
| `ld bc,hl` | `44 4D` |
| `ld de,bc` | `50 59` |
| `ld de,hl` | `54 5D` |
| `ld hl,bc` | `60 69` |
| `ld hl,de` | `62 6B` |

### Post-inc / post-dec (A+(bc/de) and r≠A+(hl) are sugar)

| Zilog | Enc | Notes |
|-------|-----|-------|
| `ld a,(de+)` / `ldi a,(de)` | `1A 13` | native A+(hl) is `2A` |
| `ld (de+),a` / `ldi (de),a` | `12 13` | used by `__z80asm__ldi` |
| `ld a,(de-)` / `ldd a,(de)` | `1A 1B` | |
| `ld (de-),a` / `ldd (de),a` | `12 1B` | |
| `ld a,(bc+)` / `ld (bc+),a` | `0A 03` / `02 03` | same for `-` |
| `ld r,(hl+)` (r≠a) | `ld r,(hl)` `inc hl` | |
| `ld (hl+),r` (r≠a) | `ld (hl),r` `inc hl` | |
| `add a,(hl+)` / `sub (hl+)` / … | ALU `(hl)` + `inc hl` | all 8-bit ALU |

### Word memory and address math (usually avoid)

| Zilog | Shape | Why avoid |
|-------|-------|-----------|
| `ld (hl),bc` / `ld bc,(hl)` | two byte loads + `inc`/`dec` | OK if HL is the pointer |
| `ld (hl+),bc` / `ldi (hl),bc` | two post-inc stores | OK for streams |
| `ld (**),hl` / `ld hl,(**)` | two `ld a,(**)` plus park A | large |
| `ld de,hl+*` / `ld de,sp+*` | `ex` synthetic + `add hl` | use `ld hl,sp+*` |
| `ex de,hl` | `E5 D5 E1 D1` | 56c. Prefer pair copy |
| `ex bc,hl` | `E5 C5 E1 C1` | same idea |

### Control sugar

| Zilog | Enc | Notes |
|-------|-----|-------|
| `djnz *` | `05 20 rel` | `dec b` / `jr nz` |
| `jp (bc)` / `jp (de)` | `C5 C9` / `D5 C9` | `push` / `ret` |
| `jr eq,*` / `jp ne,**` / `ret ltu` | maps to z/nz/c/nc | write `z`/`nz`/`c`/`nc` |

### 16-bit ALU sugar / helpers

| Zilog | Kind |
|-------|------|
| `sra hl` / `rl de` / `rr bc` | two CB ops (inline) |
| `and hl,bc` / `or hl,de` / `xor hl,bc` | push AF + byte ALU |
| `neg` / `neg hl` / `clr r` | `cpl`/`inc` or `ld *,0` |
| `adc hl,bc` / `sbc hl,de` / `sub hl,bc` | `call __z80asm__*` |
| `add hl,a` / `add de,a` / `add bc,a` | `call __z80asm__*` |
| `ex (sp),hl` | `call __z80asm__ex_sp_hl` (148c) |
| `ldi` / `ldir` / `ldd` / `lddr` / `cpi` / `cpir` / `rld` / `rrd` / `call (hl)` | `call __z80asm__*` |

---

## Category color key (Pastraiser)

- Misc/control — `nop`, `stop`, `halt`, `di`, `ei`, `cb` prefix
- Jumps/calls — `jr`, `jp`, `call`, `ret`, `reti`, `rst`
- 8-bit load/store/move — `ld r,…`, `ld (hl),…`, `ldh`, `(hl+)`/`(hl-)` of A
- 16-bit load/store/move — `ld rp,**`, `ld (**),sp`, `ld hl,sp+*`, push/pop
- 8-bit arithmetic/logical — `add`/`sub`/`and`/`or`/`xor`/`cp`/`inc`/`dec`/`daa`/A-rotates
- 16-bit arithmetic/logical — `inc`/`dec` rp, `add hl,rp`, `add sp,*`
- CB — rotates, `swap`, `bit`/`res`/`set`
