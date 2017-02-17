divert(-1)

###############################################################
# MASTER CONFIGURATION FILE
# user edits are applied to config_*.m4 files in the directory

ifdef(`CFG_ASM_PUB', `define(`CFG_ASM_DEF', 1)')

###############################################################

divert(0)

dnl############################################################
dnl# BEGIN IF GUARDS
dnl############################################################

ifdef(`CFG_ASM_DEF',
`
IFNDEF __CONFIG_Z88DK_INC_
defc   __CONFIG_Z88DK_INC_ = 1

; Automatically Generated at Library Build Time

')

ifdef(`CFG_C_DEF',
`
#ifndef __CONFIG_Z88DK_H_
#define __CONFIG_Z88DK_H_

// Automatically Generated at Library Build Time

')

dnl############################################################
dnl# INCLUDE ALL CONFIG FILES
dnl############################################################

include(`target/z88dk_version.m4')
include(`target/zx/config_target.m4')
include(`target/zx/config_cpu.m4')
include(`target/zx/config_clib.m4')
include(`target/zx/config_clib_const.m4')
include(`target/zx/config_bifrost_2.m4')
include(`target/zx/config_bifrost_h.m4')
include(`target/zx/config_bifrost_l.m4')
include(`target/zx/config_nirvanam.m4')
include(`target/zx/config_nirvanap.m4')
include(`target/zx/config_sound_bit.m4')
include(`target/zx/config_sp1.m4')

dnl############################################################
dnl# END IF GUARDS
dnl############################################################

ifdef(`CFG_C_DEF',
`
#endif
')

ifdef(`CFG_ASM_DEF',
`
ENDIF
')
