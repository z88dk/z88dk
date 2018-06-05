
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
DEFC _call_far_rst                   = $F58C

PUBLIC _jp_far
DEFC _jp_far                         = $F608

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F60E

PUBLIC _exit_far
DEFC _exit_far                       = $F6CB

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F70D

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F7A9

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F85A

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F85E

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F86C

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F870

PUBLIC _lock_get
DEFC _lock_get                       = $F87E

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F882

PUBLIC _lock_try
DEFC _lock_try                       = $F887

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F88B

PUBLIC _lock_give
DEFC _lock_give                      = $F893

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F897

PUBLIC asm_am9511a_isr
DEFC asm_am9511a_isr                 = $F8C9

PUBLIC asm_am9511a_reset
DEFC asm_am9511a_reset               = $F993

PUBLIC asm_am9511a_chk_idle
DEFC asm_am9511a_chk_idle            = $F9ED

PUBLIC asm_am9511a_opp
DEFC asm_am9511a_opp                 = $FA04

PUBLIC asm_am9511a_cmd
DEFC asm_am9511a_cmd                 = $FA40

PUBLIC _asci0_init
DEFC _asci0_init                     = $FAB4

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FACD

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FAE5

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FAFD

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB07

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FB1D

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FB29

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FB31

PUBLIC _asci1_init
DEFC _asci1_init                     = $FBD0

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FBE9

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FC01

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FC19

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FC23

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FC39

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FC45

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FC4D

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FD93

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FDC3

PUBLIC rhex
DEFC rhex                            = $FE2A

PUBLIC phexwd
DEFC phexwd                          = $FE03

PUBLIC phex
DEFC phex                            = $FE0D

PUBLIC pstring
DEFC pstring                         = $FDF0

PUBLIC pnewline
DEFC pnewline                        = $FDFA

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FE50

