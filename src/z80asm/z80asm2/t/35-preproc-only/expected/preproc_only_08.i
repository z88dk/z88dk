# 2 "t/35-preproc-only/input/preproc_only_08.asm"
 CP $30
# 2
 jr c,__HLA_2
# 2
 CP $39
# 2
 jr z,__HLA_3
# 2
 jr nc,__HLA_2
# 2
 __HLA_3:
 rst $10
# 2
 __HLA_2:
# 2
 __HLA_1:
