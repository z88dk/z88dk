; compiler-rt-named f32 compare helpers for ravn/llvm-z80 clang, bridged to
; z88dk's math32 (IEEE-754 binary32) core. ravn/llvm-z80 #277.
;
; Same opt-in gate as __addsf3.asm/__floatsisf.asm (see __addsf3.asm's header
; for the full ABI story): only active when clang is invoked with
; `-mllvm -z80-float-sdcccall0`.
;
; Measured ABI (llc -S disassembly of `int cmp_lt(float a,float b){return
; a<b;}` etc. under the flag, ravn/llvm-z80 Z80LegalizerInfo.cpp G_FCMP
; custom case): __cmpsf2/__gtsf2/__gesf2/__unordsf2 all take BOTH 32-bit
; float operands on the stack (4 pushes total: LHS pushed last/closest to
; the return address, RHS pushed first/deepest -- same declared-order
; convention as the arithmetic bridge), caller cleans up (4 pops after
; call), and return a 16-bit result in HL (not DE:HL -- these return an int,
; not a float).
;
; UNLIKE arithmetic/conversions, this is NOT a pure alias. z88dk's own SDCC
; compare wrappers (cm32_sdcc___fslt/__fseq/__fsgt/__fsneq, in
; libsrc/math/float/math32/c/sdcc/) return an SDCC-native carry-flag/HL
; boolean, not GCC's -1/0/+1 tri-state convention our G_FCMP legalizer
; expects (see the switch in Z80LegalizerInfo.cpp: __cmpsf2 returns -1
; (a<b), 0 (a==b), +1 (a>b or NaN); __gtsf2/__gesf2 return -1 (a<b or NaN),
; 0 (a==b), +1 (a>b) -- the NaN placement differs between the two families,
; which is also why __gtsf2/__gesf2 need their own NaN short-circuit despite
; sharing the ordinary-compare logic with __cmpsf2).
;
; This instead calls the RAW m32_compare core directly (documented in
; libsrc/math/float/math32/asm/z80/f32_fscompare.asm: entry stack = right,
; left, ret, ret -- two return addresses, because m32_compare is itself
; call-entered from a function, like this one, that is itself call-entered;
; exit Z=equal, C=left<right, non-destructive on the stack) and translates
; its Z/C flags into the -1/0/+1 tri-state clang expects.
;
; m32_compare's sign/magnitude-difference algorithm has NO awareness of IEEE
; 754 NaN (its own header comment: "IEEE float is considered zero if
; exponent is zero" -- no NaN special case at all), so a NaN operand would
; otherwise silently compare as some arbitrary large/small magnitude instead
; of being unordered. Each entry point here therefore checks both operands
; for NaN itself (exponent==0xFF && mantissa!=0, read directly off the stack
; without disturbing SP) *before* calling m32_compare, and short-circuits to
; the correct GCC NaN-fallback value if either operand is NaN.
;
; Example: for `float cmp(float a, float b)` compiled with a=3.0 (bit
; pattern 0x40400000) and b=NaN (e.g. 0x7FC00001): at entry SP+2..5 holds
; a's bytes 00 00 40 40 (LSB first) and SP+6..9 holds b's bytes 01 00 C0 7F.
; CheckNaN on b's bytes computes exponent = ((0x7F & $7F)<<1)|($C0>>7) =
; (0x7F<<1)|1 = 0xFF, and mantissa nonzero from byte2=$C0 (bits6..0=$40!=0)
; -- NaN confirmed, so __cmpsf2 returns +1 without ever calling m32_compare
; (which would otherwise have compared raw bit patterns with no NaN
; awareness at all).
;
; Verified end-to-end at runtime under ntvcm: all six ordered/unordered FCMP
; predicates, ord/uno, several NaN operand cases -- see
; z88dk/test/clang/runtime_fcmp.c + runtime_fcmp.sh.

SECTION code_l_clang

PUBLIC ___cmpsf2
PUBLIC ___gtsf2
PUBLIC ___gesf2
PUBLIC ___unordsf2
PUBLIC ___cmpsf2_fast

EXTERN m32_compare

; ---------------------------------------------------------------------
; CheckNaN: is the 4-byte (LSB-first) IEEE-754 binary32 value at (HL) NaN?
;
; entry : HL = pointer to byte0 (LSB) of the 4-byte float, stack untouched
; exit  : A = 1 if NaN, 0 otherwise. HL/DE/BC clobbered.
;
; byte3 = SEEEEEEE (S=sign, E=exponent bits 7..1)
; byte2 = Emmmmmmm (E=exponent bit 0, m=mantissa bits 22..16)
; byte1/byte0 = mantissa bits 15..8 / 7..0
;
; "sla e / rl d" (borrowed from f32_fscompare.asm's own exponent-isolating
; idiom) shifts the byte3:byte2 pair left by one bit: byte3's sign bit is
; dropped into the carry (discarded) and byte2's bit 7 (the exponent's low
; bit) rotates into byte3's bit 0 -- so after the shift, D holds the full
; 8-bit exponent, and E's zero/nonzero-ness is unchanged from byte2's low 7
; mantissa bits (a left shift doesn't change whether those bits were all
; zero), so E can still be OR'd with the other two mantissa bytes to test
; "mantissa nonzero" without needing a separate mask.
; ---------------------------------------------------------------------
.CheckNaN
    ld b,(hl)              ; b = byte0 (mantissa 7..0)
    inc hl
    ld c,(hl)              ; c = byte1 (mantissa 15..8)
    inc hl
    ld a,(hl)              ; a = byte2
    inc hl
    ld d,(hl)              ; d = byte3
    ld e,a                 ; e = byte2 (shift below leaves 0/nonzero intact)
    sla e
    rl d                   ; d = exponent
    ld a,d
    cp $FF
    jr nz,CheckNaN_no
    ld a,e
    or c
    or b
    jr z,CheckNaN_no      ; exponent=$FF, mantissa=0 -> Infinity, not NaN
    ld a,1
    ret
.CheckNaN_no
    xor a
    ret

; Entry (plain call from clang): stack = left(4B) @ SP+2, right(4B) @ SP+6,
; own retaddr @ SP+0 -- see __addsf3.asm's header for why LHS lands shallower
; than RHS. None of the CheckNaN/m32_compare calls below push anything onto
; the stack beyond their own balanced call/ret pair, so recomputing "SP+2"/
; "SP+6" after each nested call still lands on the same bytes.
___cmpsf2:
    ld hl,2
    add hl,sp
    call CheckNaN
    or a
    jr nz,cmpsf2_nan
    ld hl,6
    add hl,sp
    call CheckNaN
    or a
    jr nz,cmpsf2_nan
    call m32_compare
    jr z,cmpsf2_eq
    jr c,cmpsf2_lt
    ld hl,1
    ret
.cmpsf2_lt
    ld hl,$FFFF
    ret
.cmpsf2_eq
    ld hl,0
    ret
.cmpsf2_nan
    ld hl,1                ; __cmpsf2 NaN -> +1 (see header)
    ret

; __gtsf2/__gesf2 share the same -1/0/+1 encoding as __cmpsf2 (their
; ICMP_SGT/ICMP_SGE comparisons against 0 in Z80LegalizerInfo.cpp already
; distinguish correctly from this single encoding); only the NaN fallback
; differs (-1 instead of +1), so both share one body.
___gtsf2:
___gesf2:
    ld hl,2
    add hl,sp
    call CheckNaN
    or a
    jr nz,gtsf2_nan
    ld hl,6
    add hl,sp
    call CheckNaN
    or a
    jr nz,gtsf2_nan
    call m32_compare
    jr z,gtsf2_eq
    jr c,gtsf2_lt
    ld hl,1
    ret
.gtsf2_lt
    ld hl,$FFFF
    ret
.gtsf2_eq
    ld hl,0
    ret
.gtsf2_nan
    ld hl,$FFFF             ; __gtsf2/__gesf2 NaN -> -1 (see header)
    ret

; __unordsf2: nonzero (1) if either operand is NaN, 0 otherwise. Never needs
; to call m32_compare at all -- it's a pure bit-pattern predicate.
___unordsf2:
    ld hl,2
    add hl,sp
    call CheckNaN
    or a
    jr nz,unordsf2_yes
    ld hl,6
    add hl,sp
    call CheckNaN
    or a
    jr nz,unordsf2_yes
    ld hl,0
    ret
.unordsf2_yes
    ld hl,1
    ret

; ___cmpsf2_fast: sdcccall(0) fast-math tri-state compare, NO NaN check.
;
; Emitted (Z80LegalizerInfo.cpp's hasAllFastFlags/"Fast" path) only when
; clang's fcmp carries all three fast-math flags (nnan+ninf+nsz) -- i.e.
; only under `-ffast-math` or an explicit fast-math attribute. A plain
; fcmp never emits this; it always uses ___cmpsf2/__gtsf2/__gesf2 above.
;
; Same entry stack shape as ___cmpsf2 (single `call` from clang: left @
; SP+2, right @ SP+6, own retaddr @ SP+0), same body as ___cmpsf2's
; ordinary path, just without the two CheckNaN calls: nnan tells the
; compiler NaN cannot occur here, and m32_compare itself already has no
; NaN awareness (see its own header + this file's intro comment) -- so
; skipping the check is a correct match, not a behaviour change, under
; the flag's contract.
;
; Measured 2026-08-01 (MATH32_BRIDGE.md Sec 5): this removes ~327
; T-states/call versus ___cmpsf2 (946 -> ~619 T-states/call, matching
; m32_compare's own raw cost).
___cmpsf2_fast:
    call m32_compare
    jr z,cmpsf2_fast_eq
    jr c,cmpsf2_fast_lt
    ld hl,1
    ret
.cmpsf2_fast_lt
    ld hl,$FFFF
    ret
.cmpsf2_fast_eq
    ld hl,0
    ret
