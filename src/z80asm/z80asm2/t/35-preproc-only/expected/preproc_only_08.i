# 2 "t/35-preproc-only/input/preproc_only_08.asm"
 CP 0x30
# 2
 jr c,__HLA_2
# 2
 CP 0x39
# 2
 jr z,__HLA_3
# 2
 jr nc,__HLA_2
# 2
 __HLA_3:
 rst 0x10
# 2
 __HLA_2:
# 2
 __HLA_1:
