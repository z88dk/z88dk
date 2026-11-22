; r800 override for l_mult/l_mult_u. codegen.c already inlines muluw
; hl,de directly for int*int compiled fresh under -mr800 (see
; multreg/mult_const in src/sccz80/codegen.c), so this file exists purely
; to catch CALL l_mult sites already baked into the shared classic clib's
; pre-built .o files (fread.c, fwrite.c, HeapCalloc_callee.asm, ...) -
; those were compiled once, generically, for plain z80 and never see
; -mr800, so the call site itself can't be inlined; only overriding what
; it resolves to at link time reaches them.
;
; z80asm has no muluw mnemonic; $ED,$D3 is `muluw hl,de` raw-encoded.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_mult
PUBLIC l_mult_u

; Entry: hl = value1
;        de = value2
; Exit:  hl = value1 * value2
.l_mult
.l_mult_u
    defb $ED,$D3        ; muluw hl,de -- dehl = hl*de, truncate to hl
    ret
