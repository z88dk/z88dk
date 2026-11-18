

#define __IO_LAYER_2_CONFIG  0x123b

#define __IL2C_ENABLE_LOWER_16K  0x01
#define __IL2C_SHOW_LAYER_2  0x02
#define __IL2C_SELECT_SHADOW_BUFFER  0x08
#define __IL2C_BANK_SELECT_MASK  0xc0
#define __IL2C_BANK_SELECT_0  0x00
#define __IL2C_BANK_SELECT_1  0x40
#define __IL2C_BANK_SELECT_2  0x80

#define __IO_123B_ENABLE_LOWER_16K  0x01
#define __IO_123B_SHOW_LAYER_2  0x02
#define __IO_123B_SELECT_SHADOW_BUFFER  0x08
#define __IO_123B_BANK_SELECT_MASK  0xc0
#define __IO_123B_BANK_SELECT_0  0x00
#define __IO_123B_BANK_SELECT_1  0x40
#define __IO_123B_BANK_SELECT_2  0x80

// NextZXOS dotn loader (classic dotn_crt0.asm); values match newlib config_zxn_private.inc

#define __nextos_rc_bank_alloc  1
#define __nextos_rc_bank_free  3
#define __nextos_rc_banktype_zx  0
#define __nextos_rc_banktype_mmc  1
#define __NEXTOS_IDE_BANK  0x01bd
#define __ROM3_BC_SPACES  0x0030
#define __SYSVAR_BANKM  0x5b5c
#define __SYSVAR_BANK678  0x5b67
#define __SYS_IY  0x5c3a
#define __ERRB_D_BREAK_CONT_REPEATS  13
#define __ZXNEXT_LAST_PAGE  223
#define __ZXNEXT_LAST_DIVMMC  15
#define __IO_DIVIDE_CONTROL  0xe3
#define __IDC_CONMEM  0x80
#define __IO_1FFD  0x1ffd
#define __IO_DFFD  0xdffd
#define __IO_7FFD  0x7ffd
#define __REG_MMU0  80
#define __REG_MMU2  82
#define __REG_TURBO_MODE  7
#define __RTM_14MHZ  0x02
#define __REG_PERIPHERAL_3  8
#define __RP3_UNLOCK_7FFD  0x80
