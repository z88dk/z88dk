# 8085 full opcode map (Zilog mnemonics)

**Mnemonics:** Zilog ([feilipu/8085-opcodes](https://gitlab.com/feilipu/8085-opcodes) `8085_instructions.html`)  
**Flags / cycles:** [pastraiser](https://pastraiser.com/cpu/i8085/i8085_opcodes.html) order **S Z K A P V C**  
Immediate placeholders: `*` = d8, `**` = d16/a16.  
Undocumented / extended ops are listed in the notes column or the dedicated section.

---

## Opcode grid summary

Rows = high nibble, columns = low nibble. Cell: **Zilog mnemonic**.

|    | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | A | B | C | D | E | F |
|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **0** | nop | ld bc,** | ld (bc),a | inc bc | inc b | dec b | ld b,* | rlca | sub hl,bc | add hl,bc | ld a,(bc) | dec bc | inc c | dec c | ld c,* | rrca |
| **1** | sra hl | ld de,** | ld (de),a | inc de | inc d | dec d | ld d,* | rla | rl de | add hl,de | ld a,(de) | dec de | inc e | dec e | ld e,* | rra |
| **2** | rim | ld hl,** | ld (**),hl | inc hl | inc h | dec h | ld h,* | daa | ld de,hl+* | add hl,hl | ld hl,(**) | dec hl | inc l | dec l | ld l,* | cpl |
| **3** | sim | ld sp,** | ld (**),a | inc sp | inc (hl) | dec (hl) | ld (hl),* | scf | ld de,sp+* | add hl,sp | ld a,(**) | dec sp | inc a | dec a | ld a,* | ccf |
| **4** | ld b,b | ld b,c | ld b,d | ld b,e | ld b,h | ld b,l | ld b,(hl) | ld b,a | ld c,b | ld c,c | ld c,d | ld c,e | ld c,h | ld c,l | ld c,(hl) | ld c,a |
| **5** | ld d,b | ld d,c | ld d,d | ld d,e | ld d,h | ld d,l | ld d,(hl) | ld d,a | ld e,b | ld e,c | ld e,d | ld e,e | ld e,h | ld e,l | ld e,(hl) | ld e,a |
| **6** | ld h,b | ld h,c | ld h,d | ld h,e | ld h,h | ld h,l | ld h,(hl) | ld h,a | ld l,b | ld l,c | ld l,d | ld l,e | ld l,h | ld l,l | ld l,(hl) | ld l,a |
| **7** | ld (hl),b | ld (hl),c | ld (hl),d | ld (hl),e | ld (hl),h | ld (hl),l | halt | ld (hl),a | ld a,b | ld a,c | ld a,d | ld a,e | ld a,h | ld a,l | ld a,(hl) | ld a,a |
| **8** | add a,b | add a,c | add a,d | add a,e | add a,h | add a,l | add a,(hl) | add a,a | adc a,b | adc a,c | adc a,d | adc a,e | adc a,h | adc a,l | adc a,(hl) | adc a,a |
| **9** | sub b | sub c | sub d | sub e | sub h | sub l | sub (hl) | sub a | sbc a,b | sbc a,c | sbc a,d | sbc a,e | sbc a,h | sbc a,l | sbc a,(hl) | sbc a,a |
| **A** | and b | and c | and d | and e | and h | and l | and (hl) | and a | xor b | xor c | xor d | xor e | xor h | xor l | xor (hl) | xor a |
| **B** | or b | or c | or d | or e | or h | or l | or (hl) | or a | cp b | cp c | cp d | cp e | cp h | cp l | cp (hl) | cp a |
| **C** | ret nz | pop bc | jp nz,** | jp ** | call nz,** | push bc | add a,* | rst 00h | ret z | ret | jp z,** | rst v | call z,** | call ** | adc a,* | rst 08h |
| **D** | ret nc | pop de | jp nc,** | out (*),a | call nc,** | push de | sub * | rst 10h | ret c | ld (de),hl | jp c,** | in a,(*) | call c,** | jp nk,** | sbc a,* | rst 18h |
| **E** | ret po | pop hl | jp po,** | ex (sp),hl | call po,** | push hl | and * | rst 20h | ret pe | jp (hl) | jp pe,** | ex de,hl | call pe,** | ld hl,(de) | xor * | rst 28h |
| **F** | ret p | pop af | jp p,** | di | call p,** | push af | or * | rst 30h | ret m | ld sp,hl | jp m,** | ei | call m,** | jp k,** | cp * | rst 38h |

Undocumented / extended cells in the grid above: `08` sub hl,bc · `10` sra hl · `18` rl de · `28` ld de,hl+* · `38` ld de,sp+* · `CB` rst v · `D9` ld (de),hl · `DD` jp nk,** · `ED` ld hl,(de) · `FD` jp k,**

---

## Detailed table (op · Zilog · Intel · bytes · cycles · flags · notes)

Flags column: **SZKAPVC**.

### 0x

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| 00 | nop | NOP | 1 | 4 | ------- | |
| 01 | ld bc,** | LXI B,d16 | 3 | 10 | ------- | |
| 02 | ld (bc),a | STAX B | 1 | 7 | ------- | |
| 03 | inc bc | INX B | 1 | 6 | --K---- | K only |
| 04 | inc b | INR B | 1 | 4 | SZKAPV- | C unchanged |
| 05 | dec b | DCR B | 1 | 4 | SZKAPV- | |
| 06 | ld b,* | MVI B,d8 | 2 | 7 | ------- | |
| 07 | rlca | RLC | 1 | 4 | -----VC | |
| 08 | sub hl,bc | DSUB | 1 | 10 | SZKAPVC | undoc; HL←HL−BC |
| 09 | add hl,bc | DAD B | 1 | 10 | -----VC | |
| 0A | ld a,(bc) | LDAX B | 1 | 7 | ------- | |
| 0B | dec bc | DCX B | 1 | 6 | --K---- | |
| 0C | inc c | INR C | 1 | 4 | SZKAPV- | |
| 0D | dec c | DCR C | 1 | 4 | SZKAPV- | |
| 0E | ld c,* | MVI C,d8 | 2 | 7 | ------- | |
| 0F | rrca | RRC | 1 | 4 | -----0C | V←0 |

### 1x

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| 10 | sra hl | ARHL | 1 | 7 | -----0C | undoc; bit15 preserved; C←old bit0; V←0 |
| 11 | ld de,** | LXI D,d16 | 3 | 10 | ------- | |
| 12 | ld (de),a | STAX D | 1 | 7 | ------- | |
| 13 | inc de | INX D | 1 | 6 | --K---- | |
| 14 | inc d | INR D | 1 | 4 | SZKAPV- | |
| 15 | dec d | DCR D | 1 | 4 | SZKAPV- | |
| 16 | ld d,* | MVI D,d8 | 2 | 7 | ------- | |
| 17 | rla | RAL | 1 | 4 | -----VC | |
| 18 | rl de | RDEL | 1 | 10 | -----VC | undoc; 16-bit rotate left through C |
| 19 | add hl,de | DAD D | 1 | 10 | -----VC | |
| 1A | ld a,(de) | LDAX D | 1 | 7 | ------- | |
| 1B | dec de | DCX D | 1 | 6 | --K---- | |
| 1C | inc e | INR E | 1 | 4 | SZKAPV- | |
| 1D | dec e | DCR E | 1 | 4 | SZKAPV- | |
| 1E | ld e,* | MVI E,d8 | 2 | 7 | ------- | |
| 1F | rra | RAR | 1 | 4 | -----0C | V←0 |

### 2x

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| 20 | rim | RIM | 1 | 4 | ------- | 8085 serial/interrupt read |
| 21 | ld hl,** | LXI H,d16 | 3 | 10 | ------- | |
| 22 | ld (**),hl | SHLD a16 | 3 | 16 | ------- | |
| 23 | inc hl | INX H | 1 | 6 | --K---- | |
| 24 | inc h | INR H | 1 | 4 | SZKAPV- | |
| 25 | dec h | DCR H | 1 | 4 | SZKAPV- | |
| 26 | ld h,* | MVI H,d8 | 2 | 7 | ------- | |
| 27 | daa | DAA | 1 | 4 | SZKAPVC | |
| 28 | ld de,hl+* | LDHI d8 | 2 | 10 | ------- | undoc; * unsigned |
| 29 | add hl,hl | DAD H | 1 | 10 | -----VC | |
| 2A | ld hl,(**) | LHLD a16 | 3 | 16 | ------- | |
| 2B | dec hl | DCX H | 1 | 6 | --K---- | |
| 2C | inc l | INR L | 1 | 4 | SZKAPV- | |
| 2D | dec l | DCR L | 1 | 4 | SZKAPV- | |
| 2E | ld l,* | MVI L,d8 | 2 | 7 | ------- | |
| 2F | cpl | CMA | 1 | 4 | ------- | one's complement A |

### 3x

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| 30 | sim | SIM | 1 | 4 | ------- | 8085 serial/interrupt write |
| 31 | ld sp,** | LXI SP,d16 | 3 | 10 | ------- | |
| 32 | ld (**),a | STA a16 | 3 | 13 | ------- | |
| 33 | inc sp | INX SP | 1 | 6 | --K---- | |
| 34 | inc (hl) | INR M | 1 | 10 | SZKAPV- | |
| 35 | dec (hl) | DCR M | 1 | 10 | SZKAPV- | |
| 36 | ld (hl),* | MVI M,d8 | 2 | 10 | ------- | |
| 37 | scf | STC | 1 | 4 | ------1 | C←1 |
| 38 | ld de,sp+* | LDSI d8 | 2 | 10 | ------- | undoc; * unsigned |
| 39 | add hl,sp | DAD SP | 1 | 10 | -----VC | |
| 3A | ld a,(**) | LDA a16 | 3 | 13 | ------- | |
| 3B | dec sp | DCX SP | 1 | 6 | --K---- | |
| 3C | inc a | INR A | 1 | 4 | SZKAPV- | |
| 3D | dec a | DCR A | 1 | 4 | SZKAPV- | |
| 3E | ld a,* | MVI A,d8 | 2 | 7 | ------- | |
| 3F | ccf | CMC | 1 | 4 | ------C | C toggled |

### 4x–7x — 8-bit loads

All `ld r,r'` / `ld r,(hl)` / `ld (hl),r`: flags `-------`.  
Cycles: register–register **4**; involving `(hl)` **7**.  
`halt` (76): 1 byte, **5** cycles, `-------`.

| Pattern | Intel | Example |
|---------|-------|---------|
| `ld r,r'` | MOV r,r' | `ld a,b` |
| `ld r,(hl)` | MOV r,M | `ld a,(hl)` |
| `ld (hl),r` | MOV M,r | `ld (hl),a` |
| `halt` | HLT | |

Encoding: high nibble destination row (4=B,5=D,6=H,7=M/A), low nibble source (same order B C D E H L M A).

### 8x — add / adc

| Op | Zilog | Intel | B | Cyc | Flags |
|----|-------|-------|---|-----|-------|
| 80–87 | add a,{b,c,d,e,h,l,(hl),a} | ADD r/M | 1 | 4/7 | SZKAPVC |
| 88–8F | adc a,{b,c,d,e,h,l,(hl),a} | ADC r/M | 1 | 4/7 | SZKAPVC |

`(hl)` forms are 7 cycles; others 4.

### 9x — sub / sbc

| Op | Zilog | Intel | B | Cyc | Flags |
|----|-------|-------|---|-----|-------|
| 90–97 | sub {b,c,d,e,h,l,(hl),a} | SUB r/M | 1 | 4/7 | SZKAPVC |
| 98–9F | sbc a,{b,c,d,e,h,l,(hl),a} | SBB r/M | 1 | 4/7 | SZKAPVC |

### Ax — and / xor

| Op | Zilog | Intel | B | Cyc | Flags |
|----|-------|-------|---|-----|-------|
| A0–A7 | and {b,c,d,e,h,l,(hl),a} | ANA r/M | 1 | 4/7 | SZKAPVC |
| A8–AF | xor {b,c,d,e,h,l,(hl),a} | XRA r/M | 1 | 4/7 | SZKAPVC |

### Bx — or / cp

| Op | Zilog | Intel | B | Cyc | Flags |
|----|-------|-------|---|-----|-------|
| B0–B7 | or {b,c,d,e,h,l,(hl),a} | ORA r/M | 1 | 4/7 | SZKAPVC |
| B8–BF | cp {b,c,d,e,h,l,(hl),a} | CMP r/M | 1 | 4/7 | SZKAPVC |

### Cx — control / stack / ALU immediate

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| C0 | ret nz | RNZ | 1 | 12/6 | ------- | |
| C1 | pop bc | POP B | 1 | 10 | ------- | |
| C2 | jp nz,** | JNZ a16 | 3 | 10/7 | ------- | |
| C3 | jp ** | JMP a16 | 3 | 10 | ------- | |
| C4 | call nz,** | CNZ a16 | 3 | 18/9 | ------- | |
| C5 | push bc | PUSH B | 1 | 12 | ------- | |
| C6 | add a,* | ADI d8 | 2 | 7 | SZKAPVC | |
| C7 | rst 00h | RST 0 | 1 | 12 | ------- | PC←0000h |
| C8 | ret z | RZ | 1 | 12/6 | ------- | |
| C9 | ret | RET | 1 | 10 | ------- | |
| CA | jp z,** | JZ a16 | 3 | 10/7 | ------- | |
| CB | rst v | RSTV | 1 | 12/6 | ------- | undoc; if V: call 0040h |
| CC | call z,** | CZ a16 | 3 | 18/9 | ------- | |
| CD | call ** | CALL a16 | 3 | 18 | ------- | |
| CE | adc a,* | ACI d8 | 2 | 7 | SZKAPVC | |
| CF | rst 08h | RST 1 | 1 | 12 | ------- | PC←0008h |

### Dx

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| D0 | ret nc | RNC | 1 | 12/6 | ------- | |
| D1 | pop de | POP D | 1 | 10 | ------- | |
| D2 | jp nc,** | JNC a16 | 3 | 10/7 | ------- | |
| D3 | out (*),a | OUT d8 | 2 | 10 | ------- | |
| D4 | call nc,** | CNC a16 | 3 | 18/9 | ------- | |
| D5 | push de | PUSH D | 1 | 12 | ------- | |
| D6 | sub * | SUI d8 | 2 | 7 | SZKAPVC | |
| D7 | rst 10h | RST 2 | 1 | 12 | ------- | PC←0010h |
| D8 | ret c | RC | 1 | 12/6 | ------- | |
| D9 | ld (de),hl | SHLX | 1 | 10 | ------- | undoc; (DE)←L; (DE+1)←H |
| DA | jp c,** | JC a16 | 3 | 10/7 | ------- | |
| DB | in a,(*) | IN d8 | 2 | 10 | ------- | |
| DC | call c,** | CC a16 | 3 | 18/9 | ------- | |
| DD | jp nk,** | JNK a16 | 3 | 10/7 | ------- | undoc; also jnx5 / jnui |
| DE | sbc a,* | SBI d8 | 2 | 7 | SZKAPVC | |
| DF | rst 18h | RST 3 | 1 | 12 | ------- | PC←0018h |

### Ex

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| E0 | ret po | RPO | 1 | 12/6 | ------- | parity odd |
| E1 | pop hl | POP H | 1 | 10 | ------- | |
| E2 | jp po,** | JPO a16 | 3 | 10/7 | ------- | |
| E3 | ex (sp),hl | XTHL | 1 | 16 | ------- | |
| E4 | call po,** | CPO a16 | 3 | 18/9 | ------- | |
| E5 | push hl | PUSH H | 1 | 12 | ------- | |
| E6 | and * | ANI d8 | 2 | 7 | SZKAPVC | |
| E7 | rst 20h | RST 4 | 1 | 12 | ------- | PC←0020h |
| E8 | ret pe | RPE | 1 | 12/6 | ------- | parity even |
| E9 | jp (hl) | PCHL | 1 | 6 | ------- | PC←HL |
| EA | jp pe,** | JPE a16 | 3 | 10/7 | ------- | |
| EB | ex de,hl | XCHG | 1 | 4 | ------- | |
| EC | call pe,** | CPE a16 | 3 | 18/9 | ------- | |
| ED | ld hl,(de) | LHLX | 1 | 10 | ------- | undoc; L←(DE); H←(DE+1) |
| EE | xor * | XRI d8 | 2 | 7 | SZKAPVC | |
| EF | rst 28h | RST 5 | 1 | 12 | ------- | PC←0028h |

### Fx

| Op | Zilog | Intel | B | Cyc | Flags | Notes |
|----|-------|-------|---|-----|-------|-------|
| F0 | ret p | RP | 1 | 12/6 | ------- | S=0 |
| F1 | pop af | POP PSW | 1 | 10 | SZKAPVC | restores all flags |
| F2 | jp p,** | JP a16 | 3 | 10/7 | ------- | |
| F3 | di | DI | 1 | 4 | ------- | |
| F4 | call p,** | CP a16 | 3 | 18/9 | ------- | |
| F5 | push af | PUSH PSW | 1 | 12 | ------- | |
| F6 | or * | ORI d8 | 2 | 7 | SZKAPVC | |
| F7 | rst 30h | RST 6 | 1 | 12 | ------- | PC←0030h |
| F8 | ret m | RM | 1 | 12/6 | ------- | S=1 |
| F9 | ld sp,hl | SPHL | 1 | 6 | ------- | |
| FA | jp m,** | JM a16 | 3 | 10/7 | ------- | |
| FB | ei | EI | 1 | 4 | ------- | enable after next instruction |
| FC | call m,** | CM a16 | 3 | 18/9 | ------- | |
| FD | jp k,** | JK a16 | 3 | 10/7 | ------- | undoc; also jx5 / jui |
| FE | cp * | CPI d8 | 2 | 7 | SZKAPVC | |
| FF | rst 38h | RST 7 | 1 | 12 | ------- | PC←0038h |

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
| rst v (undoc) | CB | 0040h if V set |

---

## Macro / multi-instruction helpers (from 8085_instructions.html)

These are **not** single opcodes; assemblers may expand them:

| Zilog macro | Typical expansion idea | Bytes | Cyc (approx) |
|-------------|------------------------|-------|----------------|
| `ld bc,de` | move D→B, E→C | 2 | 8 |
| `ld bc,hl` | | 2 | 8 |
| `ld de,bc` | | 2 | 8 |
| `ld de,hl` | | 2 | 8 |
| `ld hl,bc` | | 2 | 8 |
| `ld hl,de` | | 2 | 8 |
| `ld hl,sp+*` (undoc path) | via `ld de,sp+*` + move | 4 | 18 |
| `ld (de),r` / `ld r,(de)` | | 3 | 15 |
| `ld (**),de` / `ld de,(**)` | | 5 | 24 |

Prefer real single ops where available (`ld (de),hl`, `ld hl,(de)`, `ex de,hl`, etc.).

---

## Category color key (pastraiser)

Useful when reading the original HTML tables:

- Misc/control — `nop`, `halt`, `di`, `ei`, `rim`, `sim`, …
- Jumps/calls — `jp`, `call`, `ret`, `rst`, …
- 8-bit load/store/move — `ld r,…`, `ld (hl),…`, …
- 16-bit load/store/move — `ld rp,**`, `ld (**),hl`, stack, `ex`, …
- 8-bit arithmetic/logical — `add`/`sub`/`and`/`or`/`xor`/`cp`/`inc`/`dec`/`daa`/rotates
- 16-bit arithmetic/logical — `inc`/`dec` rp, `add hl,rp`, `sub hl,bc`, `sra hl`, `rl de`
