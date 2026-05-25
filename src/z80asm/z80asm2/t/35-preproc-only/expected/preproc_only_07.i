# 2 "t/35-preproc-only/input/preproc_only_07.asm"
 ld b,1
# 1 "t/35-preproc-only/input/preproc_only_07.inc"
 ld a,1
# 1
 call xpto

 ld a,2
# 3
 call xpto
 ld a,3
# 4
 call xpto
 ld a,4
# 5
 call xpto
# 4 "t/35-preproc-only/input/preproc_only_07.asm"
 ld b,2
# 1 "t/35-preproc-only/input/preproc_only_07.inc"
 ld a,1
# 1
 call xpto
# 6 "t/35-preproc-only/input/preproc_only_07.asm"
 ld b,3
