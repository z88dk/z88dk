
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; yabios v2.2 provided labels found in common area 1 ;;;;;;;
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
DEFC _call_far_rst                   = $F5FB

PUBLIC _jp_far
DEFC _jp_far                         = $F66F

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F675

PUBLIC _exit_far
DEFC _exit_far                       = $F728

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F764

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F800

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F8B1

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F8B5

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F8C3

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F8C7

PUBLIC _lock_get
DEFC _lock_get                       = $F8D3

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F8D7

PUBLIC _lock_try
DEFC _lock_try                       = $F8DC

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F8E0

PUBLIC _lock_give
DEFC _lock_give                      = $F8E8

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F8EC

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F920

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $F9FE

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $FA58

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA6F

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FAAB

PUBLIC asm_asci0_init
DEFC asm_asci0_init                  = $FB2E

PUBLIC asm_asci0_flush_Rx_di
DEFC asm_asci0_flush_Rx_di           = $FB48

PUBLIC _asci0_flush_Rx
DEFC _asci0_flush_Rx                 = $FB48

PUBLIC asm_asci0_flush_Rx
DEFC asm_asci0_flush_Rx              = $FB52

PUBLIC asm_asci0_flush_Tx_di
DEFC asm_asci0_flush_Tx_di           = $FB60

PUBLIC asm_asci0_flush_Tx
DEFC asm_asci0_flush_Tx              = $FB6A

PUBLIC asm_asci0_reset
DEFC asm_asci0_reset                 = $FB78

PUBLIC asm_asci0_getc
DEFC asm_asci0_getc                  = $FB82

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB82

PUBLIC asm_asci0_peekc
DEFC asm_asci0_peekc                 = $FBA4

PUBLIC asm_asci0_pollc
DEFC asm_asci0_pollc                 = $FBB0

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FBB0

PUBLIC asm_asci0_putc
DEFC asm_asci0_putc                  = $FBB8

PUBLIC asm_asci1_init
DEFC asm_asci1_init                  = $FC57

PUBLIC asm_asci1_flush_Rx_di
DEFC asm_asci1_flush_Rx_di           = $FC71

PUBLIC _asci1_flush_Rx
DEFC _asci1_flush_Rx                 = $FC71

PUBLIC asm_asci1_flush_Rx
DEFC asm_asci1_flush_Rx              = $FC7B

PUBLIC asm_asci1_flush_Tx_di
DEFC asm_asci1_flush_Tx_di           = $FC89

PUBLIC asm_asci1_flush_Tx
DEFC asm_asci1_flush_Tx              = $FC93

PUBLIC asm_asci1_reset
DEFC asm_asci1_reset                 = $FCA1

PUBLIC asm_asci1_getc
DEFC asm_asci1_getc                  = $FCAB

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FCAB

PUBLIC asm_asci1_peekc
DEFC asm_asci1_peekc                 = $FCC1

PUBLIC asm_asci1_pollc
DEFC asm_asci1_pollc                 = $FCCD

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FCCD

PUBLIC asm_asci1_putc
DEFC asm_asci1_putc                  = $FCD5

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FE0F

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE3F

PUBLIC asm_phexwd
DEFC asm_phexwd                      = $FE76

PUBLIC asm_phex
DEFC asm_phex                        = $FE80

PUBLIC asm_pchar
DEFC asm_pchar                       = $FE93

PUBLIC asm_pstring
DEFC asm_pstring                     = $FE6C

PUBLIC asm_rhex
DEFC asm_rhex                        = $FE9D

PUBLIC asm_rchar
DEFC asm_rchar                       = $FEB7

PUBLIC asm_delay
DEFC asm_delay                       = $FEC1

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FED0

