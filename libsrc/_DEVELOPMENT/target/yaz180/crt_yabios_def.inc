
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yabios provided labels found in common area 1 ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

PUBLIC _bios_ioByte
DEFC _bios_ioByte                    = $F528

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
DEFC _lock_get                       = $F884

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F888

PUBLIC _lock_try
DEFC _lock_try                       = $F88D

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F891

PUBLIC _lock_give
DEFC _lock_give                      = $F899

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F89D

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F8CF

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $F9A1

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $F9FB

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA12

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FA4E

PUBLIC _asci0_init
DEFC _asci0_init                     = $FAC2

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FADC

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FAF4

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FB0C

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB16

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FB2C

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FB38

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FB40

PUBLIC _asci1_init
DEFC _asci1_init                     = $FBDF

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FBF9

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FC11

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FC29

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FC33

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FC49

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FC55

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FC5D

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FDA3

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FDD3

PUBLIC rhex
DEFC rhex                            = $FE3A

PUBLIC phexwd
DEFC phexwd                          = $FE13

PUBLIC phex
DEFC phex                            = $FE1D

PUBLIC pchar
DEFC pchar                           = $FE30

PUBLIC pstring
DEFC pstring                         = $FE00

PUBLIC pnewline
DEFC pnewline                        = $FE0A

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FE60

