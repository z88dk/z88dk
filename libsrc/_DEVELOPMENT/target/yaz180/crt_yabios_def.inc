
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

PUBLIC _exit_far
DEFC _exit_far                       = $F751

PUBLIC _memcpy_far
DEFC _memcpy_far                     = $F793

PUBLIC _memset_far
DEFC _memset_far                     = $F82B

PUBLIC _load_hex_fastcall
DEFC _load_hex_fastcall              = $F87A

PUBLIC _bank_get_rel
DEFC _bank_get_rel                   = $F930

PUBLIC _bank_get_rel_fastcall
DEFC _bank_get_rel_fastcall          = $F934

PUBLIC _bank_get_abs
DEFC _bank_get_abs                   = $F942

PUBLIC _bank_get_abs_fastcall
DEFC _bank_get_abs_fastcall          = $F946

PUBLIC _lock_get
DEFC _lock_get                       = $F954

PUBLIC _lock_get_fastcall
DEFC _lock_get_fastcall              = $F958

PUBLIC _lock_try
DEFC _lock_try                       = $F95D

PUBLIC _lock_try_fastcall
DEFC _lock_try_fastcall              = $F961

PUBLIC _lock_give
DEFC _lock_give                      = $F969

PUBLIC _lock_give_fastcall
DEFC _lock_give_fastcall             = $F96D

PUBLIC _apu_init
DEFC _apu_init                       = $F994

PUBLIC _apu_reset
DEFC _apu_reset                      = $FA3C

PUBLIC _apu_chk_idle_fastcall
DEFC _apu_chk_idle_fastcall          = $FAA2

PUBLIC _apu_cmd_ld_callee
DEFC _apu_cmd_ld_callee              = $FAB9

PUBLIC _apu_op_rem_callee
DEFC _apu_op_rem_callee              = $FAFC

PUBLIC _asci0_init
DEFC _asci0_init                     = $FB86

PUBLIC _asci0_flush_Rx_di
DEFC _asci0_flush_Rx_di              = $FB95

PUBLIC _asci0_flush_Tx_di
DEFC _asci0_flush_Tx_di              = $FBB2

PUBLIC _asci0_reset
DEFC _asci0_reset                    = $FBCF

PUBLIC _asci0_getc
DEFC _asci0_getc                     = $FBD9

PUBLIC _asci0_peekc
DEFC _asci0_peekc                    = $FBEF

PUBLIC _asci0_pollc
DEFC _asci0_pollc                    = $FBFD

PUBLIC _asci0_putc
DEFC _asci0_putc                     = $FC05

PUBLIC _asci1_init
DEFC _asci1_init                     = $FCA1

PUBLIC _asci1_flush_Rx_di
DEFC _asci1_flush_Rx_di              = $FCB0

PUBLIC _asci1_flush_Tx_di
DEFC _asci1_flush_Tx_di              = $FCCD

PUBLIC _asci1_reset
DEFC _asci1_reset                    = $FCEA

PUBLIC _asci1_getc
DEFC _asci1_getc                     = $FCF4

PUBLIC _asci1_peekc
DEFC _asci1_peekc                    = $FD0A

PUBLIC _asci1_pollc
DEFC _asci1_pollc                    = $FD18

PUBLIC _asci1_putc
DEFC _asci1_putc                     = $FD20

PUBLIC ide_read_sector
DEFC ide_read_sector                 = $FE6C

PUBLIC ide_write_sector
DEFC ide_write_sector                = $FE9C

PUBLIC delay
DEFC delay                           = $FEC9

PUBLIC rhexdwd
DEFC rhexdwd                         = $FED2

PUBLIC rhexwd
DEFC rhexwd                          = $FEED

PUBLIC rhex
DEFC rhex                            = $FEFC

PUBLIC phexdwd
DEFC phexdwd                         = $FF34

PUBLIC phexwd
DEFC phexwd                          = $FF3F

PUBLIC phex
DEFC phex                            = $FF60

PUBLIC phexdwdreg
DEFC phexdwdreg                      = $FF49

PUBLIC phexwdreg
DEFC phexwdreg                       = $FF56

PUBLIC pstring
DEFC pstring                         = $FF20

PUBLIC pnewline
DEFC pnewline                        = $FF2A

PUBLIC _common1_phase_end
DEFC _common1_phase_end              = $FF7D

