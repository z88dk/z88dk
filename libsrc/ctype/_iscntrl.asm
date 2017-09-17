; int iscntrl(int c)

SECTION code_clib
SECTION code_string

MODULE _iscntrl_sdcc
GLOBAL _iscntrl
GLOBAL iscntrl

defc _iscntrl = iscntrl

