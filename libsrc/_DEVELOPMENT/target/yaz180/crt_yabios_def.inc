
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

PUBLIC _memset_far
DEFC _memset_far                     = $F825

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F874

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F925

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F929

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F937

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F93B

PUBLIC _lock_get
DEFC _lock_get                       = $F949

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F94D

PUBLIC _lock_try
DEFC _lock_try                       = $F952

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F956

PUBLIC _lock_give
DEFC _lock_give                      = $F95E

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F962

PUBLIC _apu_init
DEFC _apu_init                       = $F989

PUBLIC _apu_reset
DEFC _apu_reset                      = $FA31

PUBLIC _apu_chk_idle_fastcall
DEFC _apu_chk_idle_fastcall          = $FA97

PUBLIC _apu_cmd_ld_callee
DEFC _apu_cmd_ld_callee              = $FAAE

PUBLIC _apu_op_rem_callee
DEFC _apu_op_rem_callee              = $FAF1

PUBLIC _asci0_init
DEFC _asci0_init                     = $FB7B

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FB94

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FBAC

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FBC4

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FBCE

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FBE4

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FBF2

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FBFA

PUBLIC _asci1_init
DEFC _asci1_init                     = $FC96

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FCAF

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FCC7

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FCDF

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FCE9

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FCFF

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FD0D

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FD15

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FE61

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE91

PUBLIC rhexwd
DEFC rhexwd                          = $FEBE

PUBLIC rhex
DEFC rhex                            = $FECD

PUBLIC phexwd
DEFC phexwd                          = $FF05

PUBLIC phex
DEFC phex                            = $FF19

PUBLIC phexwdreg
DEFC phexwdreg                       = $FF0F

PUBLIC pstring
DEFC pstring                         = $FEF1

PUBLIC pnewline
DEFC pnewline                        = $FEFB

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FF36

