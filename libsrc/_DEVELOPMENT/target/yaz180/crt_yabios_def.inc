
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
DEFC _call_far_rst                   = $F592

PUBLIC _jp_far
DEFC _jp_far                         = $F60E

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F614

PUBLIC _exit_far
DEFC _exit_far                       = $F6D1

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F713

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F7AF

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F860

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F864

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F872

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F876

PUBLIC _lock_get
DEFC _lock_get                       = $F882

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F886

PUBLIC _lock_try
DEFC _lock_try                       = $F88B

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F88F

PUBLIC _lock_give
DEFC _lock_give                      = $F897

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F89B

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F8CD

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $F9AB

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $FA05

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA1C

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FA58

PUBLIC asm_asci0_init
DEFC asm_asci0_init                  = $FACC

PUBLIC asm_asci0_flush_Rx_di
DEFC asm_asci0_flush_Rx_di           = $FAE6

PUBLIC asm_asci0_flush_Tx_di
DEFC asm_asci0_flush_Tx_di           = $FAFE

PUBLIC asm_asci0_reset
DEFC asm_asci0_reset                 = $FB16

PUBLIC asm_asci0_getc
DEFC asm_asci0_getc                  = $FB20

PUBLIC asm_asci0_peekc
DEFC asm_asci0_peekc                 = $FB36

PUBLIC asm_asci0_pollc
DEFC asm_asci0_pollc                 = $FB42

PUBLIC asm_asci0_putc
DEFC asm_asci0_putc                  = $FB4A

PUBLIC asm_asci1_init
DEFC asm_asci1_init                  = $FBE9

PUBLIC asm_asci1_flush_Rx_di
DEFC asm_asci1_flush_Rx_di           = $FC03

PUBLIC asm_asci1_flush_Tx_di
DEFC asm_asci1_flush_Tx_di           = $FC1B

PUBLIC asm_asci1_reset
DEFC asm_asci1_reset                 = $FC33

PUBLIC asm_asci1_getc
DEFC asm_asci1_getc                  = $FC3D

PUBLIC asm_asci1_peekc
DEFC asm_asci1_peekc                 = $FC53

PUBLIC asm_asci1_pollc
DEFC asm_asci1_pollc                 = $FC5F

PUBLIC asm_asci1_putc
DEFC asm_asci1_putc                  = $FC67

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FDAD

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FDDD

PUBLIC asm_phexwd
DEFC asm_phexwd                      = $FE14

PUBLIC asm_phex
DEFC asm_phex                        = $FE1E

PUBLIC asm_pchar
DEFC asm_pchar                       = $FE31

PUBLIC asm_pstring
DEFC asm_pstring                     = $FE0A

PUBLIC asm_rhex
DEFC asm_rhex                        = $FE3B

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FE61

