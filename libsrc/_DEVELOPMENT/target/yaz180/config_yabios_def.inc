
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; yabios v2.0 provided labels found in common area 1 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEFC z180_int_int1                   = $FFE0
DEFC z180_int_int2                   = $FFE2
DEFC z180_int_prt0                   = $FFE4
DEFC z180_int_prt1                   = $FFE6
DEFC z180_int_dma0                   = $FFE8
DEFC z180_int_dma1                   = $FFEA
DEFC z180_int_csio                   = $FFEC
DEFC z180_int_asci0                  = $FFEE
DEFC z180_int_asci1                  = $FFF0

DEFC _bios_sp                        = $FFDE
DEFC _bank_sp                        = $003B

DEFC _bankLockBase                   = $F500
DEFC _shadowLock                     = $F510
DEFC _prt0Lock                       = $F511
DEFC _prt1Lock                       = $F512
DEFC _dmac0Lock                      = $F513
DEFC _dmac1Lock                      = $F514
DEFC _csioLock                       = $F515
DEFC __system_time_fraction          = $F516
DEFC __system_time                   = $F517
DEFC APULock                         = $F527
DEFC asci0RxLock                     = $F52E
DEFC asci0TxLock                     = $F534
DEFC asci1RxLock                     = $F53A
DEFC asci1TxLock                     = $F540

DEFC _call_far_rst                   = $F58F
DEFC _jp_far                         = $F607
DEFC _jp_far_rst                     = $F60D
DEFC _exit_far                       = $F6C6
DEFC _memcpy_far                     = $F704
DEFC _load_hex_fastcall              = $F7A0
DEFC _bank_get_rel                   = $F851
DEFC _bank_get_rel_fastcall          = $F855
DEFC _bank_get_abs                   = $F863
DEFC _bank_get_abs_fastcall          = $F867
DEFC _lock_get                       = $F873
DEFC _lock_get_fastcall              = $F877
DEFC _lock_try                       = $F87C
DEFC _lock_try_fastcall              = $F880
DEFC _lock_give                      = $F888
DEFC _lock_give_fastcall             = $F88C

DEFC asm_am9511a_isr                 = $F8BE
DEFC asm_am9511a_reset               = $F99C
DEFC asm_am9511a_chk_idle            = $F9F6
DEFC asm_am9511a_opp                 = $FA0D
DEFC asm_am9511a_cmd                 = $FA49

DEFC asm_asci0_init                  = $FABD
DEFC asm_asci0_flush_Rx_di           = $FAD7
DEFC asm_asci0_flush_Rx              = $FAE1
DEFC asm_asci0_flush_Tx_di           = $FAEF
DEFC asm_asci0_flush_Tx              = $FAF9
DEFC asm_asci0_reset                 = $FB07
DEFC asm_asci0_getc                  = $FB11
DEFC asm_asci0_peekc                 = $FB27
DEFC asm_asci0_pollc                 = $FB33
DEFC asm_asci0_putc                  = $FB3B
DEFC asm_asci1_init                  = $FBDA
DEFC asm_asci1_flush_Rx_di           = $FBF4
DEFC asm_asci1_flush_Rx              = $FBFE
DEFC asm_asci1_flush_Tx_di           = $FC0C
DEFC asm_asci1_flush_Tx              = $FC16
DEFC asm_asci1_reset                 = $FC24
DEFC asm_asci1_getc                  = $FC2E
DEFC asm_asci1_peekc                 = $FC44
DEFC asm_asci1_pollc                 = $FC50
DEFC asm_asci1_putc                  = $FC58

DEFC _asci0_flush_Rx                 = $FAD7
DEFC _asci0_getc                     = $FB11
DEFC _asci0_pollc                    = $FB33
DEFC _asci1_flush_Rx                 = $FBF4
DEFC _asci1_getc                     = $FC2E
DEFC _asci1_pollc                    = $FC50

DEFC ide_read_sector                 = $FD92
DEFC ide_write_sector                = $FDC2

DEFC asm_phexwd                      = $FDF9
DEFC asm_phex                        = $FE03
DEFC asm_pchar                       = $FE16
DEFC asm_pstring                     = $FDEF
DEFC asm_rhex                        = $FE20
DEFC asm_rchar                       = $FE3A

DEFC _common1_phase_end              = $FE46

