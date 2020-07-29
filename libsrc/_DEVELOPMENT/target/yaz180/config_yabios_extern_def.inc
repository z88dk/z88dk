
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; yabios v2.0 provided labels found in common area 1 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EXTERN z180_int_int1
EXTERN z180_int_int2
EXTERN z180_int_prt0
EXTERN z180_int_prt1
EXTERN z180_int_dma0
EXTERN z180_int_dma1
EXTERN z180_int_csio
EXTERN z180_int_asci0
EXTERN z180_int_asci1

EXTERN _bios_sp
EXTERN _bank_sp

EXTERN _bankLockBase
EXTERN _shadowLock
EXTERN _prt0Lock
EXTERN _prt1Lock
EXTERN _dmac0Lock
EXTERN _dmac1Lock
EXTERN _csioLock

EXTERN APULock
EXTERN asci0RxLock
EXTERN asci0TxLock
EXTERN asci1RxLock
EXTERN asci1TxLock

EXTERN _call_far_rst
EXTERN _jp_far
EXTERN _jp_far_rst
EXTERN _exit_far
EXTERN _memcpy_far
EXTERN _load_hex_fastcall
EXTERN _bank_get_rel
EXTERN _bank_get_rel_fastcall
EXTERN _bank_get_abs
EXTERN _bank_get_abs_fastcall
EXTERN _lock_get
EXTERN _lock_get_fastcall
EXTERN _lock_try
EXTERN _lock_try_fastcall
EXTERN _lock_give
EXTERN _lock_give_fastcall

EXTERN asm_am9511a_isr
EXTERN asm_am9511a_reset
EXTERN asm_am9511a_chk_idle
EXTERN asm_am9511a_opp
EXTERN asm_am9511a_cmd

EXTERN asm_asci0_init
EXTERN asm_asci0_flush_Rx_di
EXTERN asm_asci0_flush_Rx
EXTERN asm_asci0_flush_Tx_di
EXTERN asm_asci0_flush_Tx
EXTERN asm_asci0_reset
EXTERN asm_asci0_getc
EXTERN asm_asci0_peekc
EXTERN asm_asci0_pollc
EXTERN asm_asci0_putc

EXTERN asm_asci1_init
EXTERN asm_asci1_flush_Rx_di
EXTERN asm_asci1_flush_Rx
EXTERN asm_asci1_flush_Tx_di
EXTERN asm_asci1_flush_Tx
EXTERN asm_asci1_reset
EXTERN asm_asci1_getc
EXTERN asm_asci1_peekc
EXTERN asm_asci1_pollc
EXTERN asm_asci1_putc

EXTERN ide_read_sector
EXTERN ide_write_sector

EXTERN asm_phexwd
EXTERN asm_phex
EXTERN asm_pchar
EXTERN asm_pstring
EXTERN asm_rhex
EXTERN asm_rchar

