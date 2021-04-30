
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; yabios v2.1 provided labels found in common area 1 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC z180_int_int1
DEFC z180_int_int1                   = $FFE0

PUBLIC z180_int_int2
DEFC z180_int_int2                   = $FFE2

PUBLIC z180_int_prt0
DEFC z180_int_prt0                   = $FFE4

PUBLIC z180_int_prt1
DEFC z180_int_prt1                   = $FFE6

PUBLIC z180_int_dma0
DEFC z180_int_dma0                   = $FFE8

PUBLIC z180_int_dma1
DEFC z180_int_dma1                   = $FFEA

PUBLIC z180_int_csio
DEFC z180_int_csio                   = $FFEC

PUBLIC z180_int_asci0
DEFC z180_int_asci0                  = $FFEE

PUBLIC z180_int_asci1
DEFC z180_int_asci1                  = $FFF0

PUBLIC _bios_sp
DEFC _bios_sp                        = $FFDE

PUBLIC _bank_sp
DEFC _bank_sp                        = $003B

PUBLIC _bankLockBase
DEFC _bankLockBase                   = $F500

PUBLIC _shadowLock
DEFC _shadowLock                     = $F510

PUBLIC _prt0Lock
DEFC _prt0Lock                       = $F511

PUBLIC _prt1Lock
DEFC _prt1Lock                       = $F512

PUBLIC _dmac0Lock
DEFC _dmac0Lock                      = $F513

PUBLIC _dmac1Lock
DEFC _dmac1Lock                      = $F514

PUBLIC _csioLock
DEFC _csioLock                       = $F515

PUBLIC __system_time_fraction
DEFC __system_time_fraction          = $F516

PUBLIC __system_time
DEFC __system_time                   = $F517

PUBLIC APULock
DEFC APULock                         = $F527

PUBLIC asci0RxLock
DEFC asci0RxLock                     = $F52E

PUBLIC asci0TxLock
DEFC asci0TxLock                     = $F534

PUBLIC asci1RxLock
DEFC asci1RxLock                     = $F53A

PUBLIC asci1TxLock
DEFC asci1TxLock                     = $F540

PUBLIC asm_z180_trap
DEFC asm_z180_trap                   = $F5A0

PUBLIC _call_far_rst
DEFC _call_far_rst                   = $F5F6

PUBLIC _jp_far
DEFC _jp_far                         = $F66E

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F674

PUBLIC _exit_far
DEFC _exit_far                       = $F72D

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F76B

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F807

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F8B8

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F8BC

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F8CA

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F8CE

PUBLIC _lock_get
DEFC _lock_get                       = $F8DA

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F8DE

PUBLIC _lock_try
DEFC _lock_try                       = $F8E3

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F8E7

PUBLIC _lock_give
DEFC _lock_give                      = $F8EF

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F8F3

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F927

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $FA05

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $FA5F

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA76

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FAB2

PUBLIC asm_asci0_init
DEFC asm_asci0_init                  = $FB26

PUBLIC asm_asci0_flush_Rx_di
DEFC asm_asci0_flush_Rx_di           = $FB40

PUBLIC _asci0_flush_Rx
DEFC _asci0_flush_Rx                 = $FB40

PUBLIC asm_asci0_flush_Rx
DEFC asm_asci0_flush_Rx              = $FB4A

PUBLIC asm_asci0_flush_Tx_di
DEFC asm_asci0_flush_Tx_di           = $FB58

PUBLIC asm_asci0_flush_Tx
DEFC asm_asci0_flush_Tx              = $FB62

PUBLIC asm_asci0_reset
DEFC asm_asci0_reset                 = $FB70

PUBLIC asm_asci0_getc
DEFC asm_asci0_getc                  = $FB7A

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB7A

PUBLIC asm_asci0_peekc
DEFC asm_asci0_peekc                 = $FB90

PUBLIC asm_asci0_pollc
DEFC asm_asci0_pollc                 = $FB9C

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FB9C

PUBLIC asm_asci0_putc
DEFC asm_asci0_putc                  = $FBA4

PUBLIC asm_asci1_init
DEFC asm_asci1_init                  = $FC43

PUBLIC asm_asci1_flush_Rx_di
DEFC asm_asci1_flush_Rx_di           = $FC5D

PUBLIC _asci1_flush_Rx
DEFC _asci1_flush_Rx                 = $FC5D

PUBLIC asm_asci1_flush_Rx
DEFC asm_asci1_flush_Rx              = $FC67

PUBLIC asm_asci1_flush_Tx_di
DEFC asm_asci1_flush_Tx_di           = $FC75

PUBLIC asm_asci1_flush_Tx
DEFC asm_asci1_flush_Tx              = $FC7F

PUBLIC asm_asci1_reset
DEFC asm_asci1_reset                 = $FC8D

PUBLIC asm_asci1_getc
DEFC asm_asci1_getc                  = $FC97

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FC97

PUBLIC asm_asci1_peekc
DEFC asm_asci1_peekc                 = $FCAD

PUBLIC asm_asci1_pollc
DEFC asm_asci1_pollc                 = $FCB9

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FCB9

PUBLIC asm_asci1_putc
DEFC asm_asci1_putc                  = $FCC1

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FDFB

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE2B

PUBLIC asm_phexwd
DEFC asm_phexwd                      = $FE62

PUBLIC asm_phex
DEFC asm_phex                        = $FE6C

PUBLIC asm_pchar
DEFC asm_pchar                       = $FE7F

PUBLIC asm_pstring
DEFC asm_pstring                     = $FE58

PUBLIC asm_rhex
DEFC asm_rhex                        = $FE89

PUBLIC asm_rchar
DEFC asm_rchar                       = $FEA3

PUBLIC asm_delay
DEFC asm_delay                       = $FEAD

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FEBC

