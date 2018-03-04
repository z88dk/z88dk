
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
DEFC _call_far_rst                   = $F612

PUBLIC _jp_far
DEFC _jp_far                         = $F68E

PUBLIC _jp_far_rst
DEFC _jp_far_rst                     = $F694

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F75A

PUBLIC _memset_far
DEFC _memset_far                     = $F7F2

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F841

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F8F7

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F8FB

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F909

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F90D

PUBLIC _lock_get
DEFC _lock_get                       = $F91B

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F91F

PUBLIC _lock_try
DEFC _lock_try                       = $F924

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F928

PUBLIC _lock_give
DEFC _lock_give                      = $F930

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F934

PUBLIC _apu_init
DEFC _apu_init                       = $F95B

PUBLIC _apu_reset
DEFC _apu_reset                      = $FA03

PUBLIC _apu_chk_idle_fastcall
DEFC _apu_chk_idle_fastcall          = $FA69

PUBLIC _apu_cmd_ld_callee
DEFC _apu_cmd_ld_callee              = $FA80

PUBLIC _apu_op_rem_callee
DEFC _apu_op_rem_callee              = $FAC3

PUBLIC _asci0_init
DEFC _asci0_init                     = $FB4D

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FB5C

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FB79

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FB96

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FBA0

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FBB6

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FBC4

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FBCC

PUBLIC _asci1_init
DEFC _asci1_init                     = $FC68

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FC77

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FC94

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FCB1

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FCBB

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FCD1

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FCDF

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FCE7

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FE33

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE63

PUBLIC delay
DEFC delay                           = $FE90

PUBLIC rhexdwd
DEFC rhexdwd                         = $FE99

PUBLIC rhexwd
DEFC rhexwd                          = $FEB4

PUBLIC rhex
DEFC rhex                            = $FEC3

PUBLIC phexdwd
DEFC phexdwd                         = $FEFB

PUBLIC phexwd
DEFC phexwd                          = $FF06

PUBLIC phex
DEFC phex                            = $FF27

PUBLIC phexdwdreg
DEFC phexdwdreg                      = $FF10

PUBLIC phexwdreg
DEFC phexwdreg                       = $FF1D

PUBLIC pstring
DEFC pstring                         = $FEE7

PUBLIC pnewline
DEFC pnewline                        = $FEF1

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FF44

