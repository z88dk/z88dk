
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yabios provided labels found in common area 1 ;;;;;;;;;;;;;;
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

PUBLIC _call_far_rst
DEFC _call_far_rst                   = $F58F

PUBLIC _jp_far
DEFC _jp_far                         = $F607

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F60D

PUBLIC _exit_far
DEFC _exit_far                       = $F6C6

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F704

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F7A0

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F851

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F855

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F863

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F867

PUBLIC _lock_get
DEFC _lock_get                       = $F873

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F877

PUBLIC _lock_try
DEFC _lock_try                       = $F87C

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F880

PUBLIC _lock_give
DEFC _lock_give                      = $F888

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F88C

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F8BE

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $F99C

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $F9F6

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA0D

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FA49

PUBLIC asm_asci0_init
DEFC asm_asci0_init                  = $FABD

PUBLIC asm_asci0_flush_Rx_di
DEFC asm_asci0_flush_Rx_di           = $FAD7

PUBLIC asm_asci0_flush_Tx_di
DEFC asm_asci0_flush_Tx_di           = $FAEF

PUBLIC asm_asci0_reset
DEFC asm_asci0_reset                 = $FB07

PUBLIC asm_asci0_getc
DEFC asm_asci0_getc                  = $FB11

PUBLIC asm_asci0_peekc
DEFC asm_asci0_peekc                 = $FB27

PUBLIC asm_asci0_pollc
DEFC asm_asci0_pollc                 = $FB33

PUBLIC asm_asci0_putc
DEFC asm_asci0_putc                  = $FB3B

PUBLIC asm_asci1_init
DEFC asm_asci1_init                  = $FBDA

PUBLIC asm_asci1_flush_Rx_di
DEFC asm_asci1_flush_Rx_di           = $FBF4

PUBLIC asm_asci1_flush_Tx_di
DEFC asm_asci1_flush_Tx_di           = $FC0C

PUBLIC asm_asci1_reset
DEFC asm_asci1_reset                 = $FC24

PUBLIC asm_asci1_getc
DEFC asm_asci1_getc                  = $FC2E

PUBLIC asm_asci1_peekc
DEFC asm_asci1_peekc                 = $FC44

PUBLIC asm_asci1_pollc
DEFC asm_asci1_pollc                 = $FC50

PUBLIC asm_asci1_putc
DEFC asm_asci1_putc                  = $FC58

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FD9E

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FDCE

PUBLIC asm_phexwd
DEFC asm_phexwd                      = $FE05

PUBLIC asm_phex
DEFC asm_phex                        = $FE0F

PUBLIC asm_pchar
DEFC asm_pchar                       = $FE22

PUBLIC asm_pstring
DEFC asm_pstring                     = $FDFB

PUBLIC asm_rhex
DEFC asm_rhex                        = $FE2C

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FE52

