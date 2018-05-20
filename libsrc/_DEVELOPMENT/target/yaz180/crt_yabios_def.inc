
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

PUBLIC _APULock
DEFC _APULock                        = $F52C

PUBLIC _bios_ioByte
DEFC _bios_ioByte                    = $F52D

PUBLIC _asci0RxLock
DEFC _asci0RxLock                    = $F533

PUBLIC _asci0TxLock
DEFC _asci0TxLock                    = $F539

PUBLIC _asci1RxLock
DEFC _asci1RxLock                    = $F53F

PUBLIC _asci1TxLock
DEFC _asci1TxLock                    = $F545

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

PUBLIC _apu_init
DEFC _apu_init                       = $F8C9

PUBLIC _apu_reset
DEFC _apu_reset                      = $F971

PUBLIC _apu_chk_idle_fastcall
DEFC _apu_chk_idle_fastcall          = $F9D7

PUBLIC _apu_cmd_ld_callee
DEFC _apu_cmd_ld_callee              = $F9EE

PUBLIC _apu_op_rem_callee
DEFC _apu_op_rem_callee              = $FA31

PUBLIC _asci0_init
DEFC _asci0_init                     = $FABB

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FAD4

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FAEC

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FB04

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB0E

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FB24

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FB30

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FB38

PUBLIC _asci1_init
DEFC _asci1_init                     = $FBD7

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FBF0

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FC08

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FC20

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FC2A

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FC40

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FC4C

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FC54

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FD9A

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FDCA

PUBLIC rhex
DEFC rhex                            = $FE31

PUBLIC phexwd
DEFC phexwd                          = $FE0A

PUBLIC phex
DEFC phex                            = $FE14

PUBLIC pstring
DEFC pstring                         = $FDF7

PUBLIC pnewline
DEFC pnewline                        = $FE01

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FE57

