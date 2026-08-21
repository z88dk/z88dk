# Z80 opcode map (Zilog mnemonics)

**Mnemonics:** Zilog. z88dk writes these forms in all tree sources.  
**Flags / T-states:** [clrhome Z80 opcode table](https://clrhome.org/table/) (`opcode-table.json`).  
**Encodings:** `src/z80asm/dev/cpu/cpu_test_z80_strict_ok.asm` (documented native ops).  
Undocumented forms that z80asm still accepts in **normal** mode: `cpu_test_z80_ok.asm`.

Immediate placeholders: `*` = signed or unsigned 8-bit (d8 / displacement), `**` = 16-bit immediate or address.

When encodings disagree, **the z80asm fixture wins**. When flags or T-states disagree with other web tables, **clrhome wins**. The tree still wins over this skill if a fixture later changes.

clrhome also lists **Z180-only** ops (`mlt`, `slp`, `tst`, `in0`, `out0`, `otim` / `otdm`, …). Those are **not** Z80. See `cpu-z180`.

---

## Flag notation

Documented F bits, high to low: **S Z H P/V N C**. Compact column **SZHPNC**.

| Glyph | Meaning |
|-------|---------|
| letter (`S`,`Z`,`H`,`P`,`N`,`C`) | Flag is set as defined |
| `V` | P/V as overflow |
| `P` | P/V as parity |
| `-` | unchanged |
| `0` / `1` | forced clear / set |
| `*` | special (see notes) |

Y (bit 5) and X (bit 3) are undocumented copies. This map does not track them.

Condition codes: `nz` `z` `nc` `c` `po` `pe` `p` `m`. There is **no** `k` / `nk` on Z80.

---

## Unprefixed grid

Rows = high nibble, columns = low nibble. Cell: **Zilog**.

|    | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | A | B | C | D | E | F |
|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **0** | nop | ld bc,** | ld (bc),a | inc bc | inc b | dec b | ld b,* | rlca | ex af,af' | add hl,bc | ld a,(bc) | dec bc | inc c | dec c | ld c,* | rrca |
| **1** | djnz * | ld de,** | ld (de),a | inc de | inc d | dec d | ld d,* | rla | jr * | add hl,de | ld a,(de) | dec de | inc e | dec e | ld e,* | rra |
| **2** | jr nz,* | ld hl,** | ld (**),hl | inc hl | inc h | dec h | ld h,* | daa | jr z,* | add hl,hl | ld hl,(**) | dec hl | inc l | dec l | ld l,* | cpl |
| **3** | jr nc,* | ld sp,** | ld (**),a | inc sp | inc (hl) | dec (hl) | ld (hl),* | scf | jr c,* | add hl,sp | ld a,(**) | dec sp | inc a | dec a | ld a,* | ccf |
| **4** | ld b,b | ld b,c | ld b,d | ld b,e | ld b,h | ld b,l | ld b,(hl) | ld b,a | ld c,b | ld c,c | ld c,d | ld c,e | ld c,h | ld c,l | ld c,(hl) | ld c,a |
| **5** | ld d,b | ld d,c | ld d,d | ld d,e | ld d,h | ld d,l | ld d,(hl) | ld d,a | ld e,b | ld e,c | ld e,d | ld e,e | ld e,h | ld e,l | ld e,(hl) | ld e,a |
| **6** | ld h,b | ld h,c | ld h,d | ld h,e | ld h,h | ld h,l | ld h,(hl) | ld h,a | ld l,b | ld l,c | ld l,d | ld l,e | ld l,h | ld l,l | ld l,(hl) | ld l,a |
| **7** | ld (hl),b | ld (hl),c | ld (hl),d | ld (hl),e | ld (hl),h | ld (hl),l | halt | ld (hl),a | ld a,b | ld a,c | ld a,d | ld a,e | ld a,h | ld a,l | ld a,(hl) | ld a,a |
| **8** | add a,b | add a,c | add a,d | add a,e | add a,h | add a,l | add a,(hl) | add a,a | adc a,b | adc a,c | adc a,d | adc a,e | adc a,h | adc a,l | adc a,(hl) | adc a,a |
| **9** | sub b | sub c | sub d | sub e | sub h | sub l | sub (hl) | sub a | sbc a,b | sbc a,c | sbc a,d | sbc a,e | sbc a,h | sbc a,l | sbc a,(hl) | sbc a,a |
| **A** | and b | and c | and d | and e | and h | and l | and (hl) | and a | xor b | xor c | xor d | xor e | xor h | xor l | xor (hl) | xor a |
| **B** | or b | or c | or d | or e | or h | or l | or (hl) | or a | cp b | cp c | cp d | cp e | cp h | cp l | cp (hl) | cp a |
| **C** | ret nz | pop bc | jp nz,** | jp ** | call nz,** | push bc | add a,* | rst 00h | ret z | ret | jp z,** | CB | call z,** | call ** | adc a,* | rst 08h |
| **D** | ret nc | pop de | jp nc,** | out (*),a | call nc,** | push de | sub * | rst 10h | ret c | exx | jp c,** | in a,(*) | call c,** | DD | sbc a,* | rst 18h |
| **E** | ret po | pop hl | jp po,** | ex (sp),hl | call po,** | push hl | and * | rst 20h | ret pe | jp (hl) | jp pe,** | ex de,hl | call pe,** | ED | xor * | rst 28h |
| **F** | ret p | pop af | jp p,** | di | call p,** | push af | or * | rst 30h | ret m | ld sp,hl | jp m,** | ei | call m,** | FD | cp * | rst 38h |

`CB` / `DD` / `ED` / `FD` are prefixes, not 8085-style one-byte extended ops.

---

## CB prefix grid

Second byte. `sll` (row **3**, CB 30–37) is **undocumented**. z80asm accepts it in normal mode. Strict mode rejects it.

|    | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | A | B | C | D | E | F |
|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **0** | rlc b | rlc c | rlc d | rlc e | rlc h | rlc l | rlc (hl) | rlc a | rrc b | rrc c | rrc d | rrc e | rrc h | rrc l | rrc (hl) | rrc a |
| **1** | rl b | rl c | rl d | rl e | rl h | rl l | rl (hl) | rl a | rr b | rr c | rr d | rr e | rr h | rr l | rr (hl) | rr a |
| **2** | sla b | sla c | sla d | sla e | sla h | sla l | sla (hl) | sla a | sra b | sra c | sra d | sra e | sra h | sra l | sra (hl) | sra a |
| **3** | sll b | sll c | sll d | sll e | sll h | sll l | sll (hl) | sll a | srl b | srl c | srl d | srl e | srl h | srl l | srl (hl) | srl a |
| **4** | bit 0,b | bit 0,c | bit 0,d | bit 0,e | bit 0,h | bit 0,l | bit 0,(hl) | bit 0,a | bit 1,b | bit 1,c | bit 1,d | bit 1,e | bit 1,h | bit 1,l | bit 1,(hl) | bit 1,a |
| **5** | bit 2,… | | | | | | bit 2,(hl) | | bit 3,… | | | | | | bit 3,(hl) | |
| **6** | bit 4,… | | | | | | bit 4,(hl) | | bit 5,… | | | | | | bit 5,(hl) | |
| **7** | bit 6,… | | | | | | bit 6,(hl) | | bit 7,… | | | | | | bit 7,(hl) | |
| **8** | res 0,b … | | | | | | res 0,(hl) | res 0,a | res 1,… | | | | | | res 1,(hl) | |
| **9–B** | res 2…7, same register order | | | | | | | | | | | | | | | |
| **C** | set 0,b … | | | | | | set 0,(hl) | set 0,a | set 1,… | | | | | | set 1,(hl) | |
| **D–F** | set 2…7, same register order | | | | | | | | | | | | | | | |

`bit`/`res`/`set` encoding: `CB (b<<3)+r+$40` / `+$80` / `+$C0` with r = B C D E H L (HL) A.

---

## ED prefix (documented Z80)

Empty / Z180 / undocumented cells are omitted. z80asm `-mz80` **strict** matches this documented set.

| Op | Zilog | B | Cyc | SZHPNC | Notes |
|----|-------|---|-----|--------|-------|
| 40–78 step 8 | `in r,(c)` | 2 | 12 | `SZ0P0-` | r = b,c,d,e,h,l,a. P = parity |
| 41–79 step 8 | `out (c),r` | 2 | 12 | `------` | |
| 42 / 52 / 62 / 72 | `sbc hl,bc/de/hl/sp` | 2 | 15 | `SZHV1C` | |
| 4A / 5A / 6A / 7A | `adc hl,bc/de/hl/sp` | 2 | 15 | `SZHV0C` | |
| 43 / 53 / 73 | `ld (**),bc/de/sp` | 4 | 20 | `------` | |
| 4B / 5B / 7B | `ld bc/de/sp,(**)` | 4 | 20 | `------` | |
| 44 | `neg` | 2 | 8 | `SZHV1C` | A ← 0−A |
| 45 | `retn` | 2 | 14 | `------` | restores IFF from IFF2 |
| 46 | `im 0` | 2 | 8 | `------` | |
| 47 | `ld i,a` | 2 | 9 | `------` | |
| 4D | `reti` | 2 | 14 | `------` | |
| 4F | `ld r,a` | 2 | 9 | `------` | |
| 56 | `im 1` | 2 | 8 | `------` | |
| 57 | `ld a,i` | 2 | 9 | `SZ0*0-` | P/V ← IFF2 |
| 5E | `im 2` | 2 | 8 | `------` | |
| 5F | `ld a,r` | 2 | 9 | `SZ0*0-` | P/V ← IFF2 |
| 67 | `rrd` | 2 | 18 | `SZ0P0-` | |
| 6F | `rld` | 2 | 18 | `SZ0P0-` | |
| A0 | `ldi` | 2 | 16 | `--00*-` | P/V set if BC≠0 after |
| A1 | `cpi` | 2 | 16 | `SZH*1-` | P/V set if BC≠0 after |
| A2 | `ini` | 2 | 16 | `----1*` | N=1. Z set if B becomes 0. Other flags undocumented |
| A3 | `outi` | 2 | 16 | `----1*` | same as `ini` |
| A8 | `ldd` | 2 | 16 | `--00*-` | |
| A9 | `cpd` | 2 | 16 | `SZH*1-` | |
| AA | `ind` | 2 | 16 | `----1*` | same as `ini` |
| AB | `outd` | 2 | 16 | `----1*` | |
| B0 | `ldir` | 2 | 21/16 | `--000-` | P/V reset when done |
| B1 | `cpir` | 2 | 21/16 | `SZH*1-` | |
| B2 | `inir` | 2 | 21/16 | `----11` | Z=1 when finished |
| B3 | `otir` | 2 | 21/16 | `----11` | |
| B8 | `lddr` | 2 | 21/16 | `--000-` | |
| B9 | `cpdr` | 2 | 21/16 | `SZH*1-` | |
| BA | `indr` | 2 | 21/16 | `----11` | |
| BB | `otdr` | 2 | 21/16 | `----11` | |

`ld hl,(**)` documented is **`2A`**, not `ED 6B`. `ld (**),hl` documented is **`22`**, not `ED 63`. Those ED forms are undocumented duplicates. z80asm still emits `2A` / `22` for the Zilog source.

---

## DD / FD (IX / IY)

Prefix **DD** = IX. Prefix **FD** = IY. Same T-state add on both.

Documented (in `*_strict_ok.asm`):

| Pattern | Bytes | Cyc | Notes |
|---------|-------|-----|-------|
| `add ix,bc/de/ix/sp` | 2 | 15 | flags as `add hl,rp` |
| `inc ix` / `dec ix` | 2 | 10 | no flags |
| `ld ix,**` | 4 | 14 | |
| `ld ix,(**)` / `ld (**),ix` | 4 | 20 | |
| `inc (ix+*)` / `dec (ix+*)` | 3 | 23 | 8-bit flags |
| `ld (ix+*),*` | 4 | 19 | |
| `ld r,(ix+*)` / `ld (ix+*),r` | 3 | 19 | r is 8-bit, not h/l of ix |
| ALU `op (ix+*)` | 3 | 19 | |
| `pop ix` / `push ix` | 2 | 14 / 15 | |
| `ex (sp),ix` | 2 | 23 | |
| `jp (ix)` | 2 | 8 | |
| `ld sp,ix` | 2 | 10 | |
| `CB` on `(ix+*)` | 4 | see CB+(ix) | `DD CB d op` |

Displacement `*` is **signed** 8-bit.

---

## Detailed unprefixed groups

Cyc for `(hl)` is the higher figure when two are given.

### 0x–3x misc / 16-bit / JR

| Op | Zilog | B | Cyc | SZHPNC | Notes |
|----|-------|---|-----|--------|-------|
| 00 | nop | 1 | 4 | `------` | |
| 01 / 11 / 21 / 31 | ld bc/de/hl/sp,** | 3 | 10 | `------` | |
| 02 / 12 | ld (bc)/(de),a | 1 | 7 | `------` | |
| 03 / 13 / 23 / 33 | inc bc/de/hl/sp | 1 | 6 | `------` | **no Z** |
| 0B / 1B / 2B / 3B | dec bc/de/hl/sp | 1 | 6 | `------` | **no Z** |
| 09 / 19 / 29 / 39 | add hl,rp | 1 | 11 | `--H-0C` | Z unchanged |
| 07 | rlca | 1 | 4 | `--0-0C` | **Z unchanged** |
| 0F | rrca | 1 | 4 | `--0-0C` | **Z unchanged** |
| 17 | rla | 1 | 4 | `--0-0C` | **Z unchanged** |
| 1F | rra | 1 | 4 | `--0-0C` | **Z unchanged** |
| 08 | ex af,af' | 1 | 4 | `------` | swaps the whole F |
| 10 | djnz * | 2 | 13/8 | `------` | B−− internally. **no flags** |
| 18 | jr * | 2 | 12 | `------` | |
| 20 / 28 / 30 / 38 | jr nz/z/nc/c,* | 2 | 12/7 | `------` | |
| 22 | ld (**),hl | 3 | 16 | `------` | |
| 2A | ld hl,(**) | 3 | 16 | `------` | |
| 27 | daa | 1 | 4 | `SZH*P*` | C and H exceptional |
| 2F | cpl | 1 | 4 | `--1-1-` | H=1 N=1 |
| 32 | ld (**),a | 3 | 13 | `------` | |
| 3A | ld a,(**) | 3 | 13 | `------` | |
| 37 | scf | 1 | 4 | `--0-01` | C=1 N=0 H=0 |
| 3F | ccf | 1 | 4 | `--*-0*` | N=0. C inverted. H exceptional |

### 8-bit inc / dec / ld immediate

| Pattern | B | Cyc | SZHPNC |
|---------|---|-----|--------|
| `inc r` | 1 | 4 | `SZHV0-` |
| `dec r` | 1 | 4 | `SZHV1-` |
| `inc (hl)` / `dec (hl)` | 1 | 11 | same |
| `ld r,*` | 2 | 7 | `------` |
| `ld (hl),*` | 2 | 10 | `------` |

### 4x–7x loads

Flags `------`. Cyc 4, or 7 if `(hl)` is involved. `halt` (76): 1 byte, **4** T, `------`.

### 8-bit ALU

| Ops | Cyc r / (hl) / n | SZHPNC |
|-----|------------------|--------|
| `add a,r` `adc a,r` | 4 / 7 / 7 | `SZHV0C` |
| `sub r` `sbc a,r` `cp r` | 4 / 7 / 7 | `SZHV1C` |
| `and r` | 4 / 7 / 7 | `SZ1P00` |
| `xor r` `or r` | 4 / 7 / 7 | `SZ0P00` |

### Control / stack / I/O

| Op | Zilog | B | Cyc | Notes |
|----|-------|---|-----|-------|
| C0… | ret cc | 1 | 11/5 | |
| C1 / D1 / E1 / F1 | pop bc/de/hl/af | 1 | 10 | `pop af` restores F |
| C2… | jp cc,** | 3 | **10** | always 10. Not 8085 10/7 |
| C3 | jp ** | 3 | 10 | |
| C4… | call cc,** | 3 | 17/10 | |
| CD | call ** | 3 | 17 | |
| C5… | push bc/de/hl/af | 1 | 11 | |
| C9 | ret | 1 | 10 | |
| D3 | out (*),a | 2 | 11 | |
| DB | in a,(*) | 2 | 11 | |
| D9 | exx | 1 | 4 | |
| E3 | ex (sp),hl | 1 | 19 | |
| E9 | jp (hl) | 1 | 4 | |
| EB | ex de,hl | 1 | 4 | |
| F3 / FB | di / ei | 1 | 4 | ei takes effect after the **next** instruction |
| F9 | ld sp,hl | 1 | 6 | |
| C7…FF | rst p | 1 | 11 | p = 00,08,…,38 |

---

## CB timings and flags

| Group | B | Cyc r / (hl) | SZHPNC |
|-------|---|--------------|--------|
| `rlc` `rrc` `rl` `rr` `sla` `sra` `srl` | 2 | 8 / 15 | `SZ0P0C` |
| `sll` (undoc) | 2 | 8 / 15 | `SZ0P0C` |
| `bit b,r` | 2 | 8 / 12 | `--1?0-` Z as defined. S and P/V undocumented |
| `res` / `set` | 2 | 8 / 15 | `------` |

`(ix+*)` CB forms: 4 bytes. Rotate/shift **23** T. `bit` **20** T. `res`/`set` **23** T.

---

## Undocumented Z80 (clrhome + z80asm normal `*_ok.asm`)

**Not** in `cpu_test_z80_strict_ok.asm`. Do not emit these in strict builds. Prefer documented ops in new library code unless a measured win needs them.

| Form | Encoding | Cyc | Notes |
|------|----------|-----|-------|
| `sll r` / `sll (hl)` | CB 30–37 | 8 / 15 | shift left, copy 1 into bit 0 |
| `ixh` / `ixl` / `iyh` / `iyl` | DD/FD + H/L slot | 8 | 8-bit half of IX/IY. Not with `(hl)` |
| `in (c)` / `in f,(c)` | ED 70 | 12 | sets flags from the port byte; no register load |
| `out (c),0` | ED 71 | 12 | writes 0 (some CMOS chips write 255) |
| `op (ix+*),r` | DD CB d (op+r) | 23 | rotate/shift/res/set memory **and** copy to r |
| `ld hl,(**)` via ED 6B | ED 6B nn | 20 | duplicate of `2A`. z80asm `ld hl,(nn)` is `2A` |
| `ld (**),hl` via ED 63 | ED 63 nn | 20 | duplicate of `22` |

---

## Not Z80 (on the clrhome page as “Z180 only”)

These encodings are **absent** from `cpu_test_z80_ok.asm` and `*_strict_ok.asm`.

`mlt bc/de/hl/sp`, `slp`, `tst r/(hl)/n`, `tstio n`, `in0 r,(n)`, `out0 (n),r`, `otim` / `otimr` / `otdm` / `otdmr`.

Use `cpu-z180` and `-mz180`.

---

## RST vectors

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
