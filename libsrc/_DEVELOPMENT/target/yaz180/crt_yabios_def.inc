
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
DEFC _call_far_rst                   = $F60C

PUBLIC _jp_far
DEFC _jp_far                         = $F688

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F68E

PUBLIC _exit_far
DEFC _exit_far                       = $F74B

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F78D

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F829

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F8DA

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F8DE

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F8EC

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F8F0

PUBLIC _lock_get
DEFC _lock_get                       = $F8FE

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F902

PUBLIC _lock_try
DEFC _lock_try                       = $F907

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F90B

PUBLIC _lock_give
DEFC _lock_give                      = $F913

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F917

PUBLIC _apu_init
DEFC _apu_init                       = $F949

PUBLIC _apu_reset
DEFC _apu_reset                      = $F9F1

PUBLIC _apu_chk_idle_fastcall
DEFC _apu_chk_idle_fastcall          = $FA57

PUBLIC _apu_cmd_ld_callee
DEFC _apu_cmd_ld_callee              = $FA6E

PUBLIC _apu_op_rem_callee
DEFC _apu_op_rem_callee              = $FAB1

PUBLIC _asci0_init
DEFC _asci0_init                     = $FB3B

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FB54

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FB6C

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FB84

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FB8E

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FBA4

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FBB0

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FBB8

PUBLIC _asci1_init
DEFC _asci1_init                     = $FC57

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FC70

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FC88

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FCA0

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FCAA

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FCC0

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FCCC

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FCD4

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FE1A

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE4A

PUBLIC rhex
DEFC rhex                            = $FEB1

PUBLIC phexwd
DEFC phexwd                          = $FE8A

PUBLIC phex
DEFC phex                            = $FE94

PUBLIC pstring
DEFC pstring                         = $FE77

PUBLIC pnewline
DEFC pnewline                        = $FE81

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FED7

