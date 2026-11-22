
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; yabios v2.1 provided labels found in common area 1 ;;;;;;;
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
EXTERN asm_am9511a_opp          ; Operand bank in B, Pointer to operand in DE, APU command in C
EXTERN asm_am9511a_cmd          ; APU command in C

EXTERN asm_asci0_init           ; initialise the ASCI0 - 115200 8n1
EXTERN asm_asci0_flush_Rx_di
EXTERN asm_asci0_flush_Rx
EXTERN asm_asci0_flush_Tx_di
EXTERN asm_asci0_flush_Tx
EXTERN asm_asci0_reset
EXTERN asm_asci0_getc
EXTERN asm_asci0_peekc
EXTERN asm_asci0_pollc
EXTERN asm_asci0_putc

EXTERN asm_asci1_init           ; initialise the ASCI1 - 9600 8n2
EXTERN asm_asci1_flush_Rx_di
EXTERN asm_asci1_flush_Rx
EXTERN asm_asci1_flush_Tx_di
EXTERN asm_asci1_flush_Tx
EXTERN asm_asci1_reset
EXTERN asm_asci1_getc
EXTERN asm_asci1_peekc
EXTERN asm_asci1_pollc
EXTERN asm_asci1_putc

EXTERN ide_read_sector          ; LBA specified by the 4 bytes in BCDE
                                ; the address of the buffer to fill is in HL
                                ; HL is left incremented by 512 bytes

EXTERN ide_write_sector         ; specified by the 4 bytes in BCDE
                                ; the address of the origin buffer is in HL
                                ; HL is left incremented by 512 bytes

EXTERN asm_phexwd               ; print contents of HL as 16 bit number in ASCII HEX, modifies AF & HL
EXTERN asm_phex                 ; print contents of L as 8 bit number in ASCII HEX to asci0/1, modifies AF & HL
EXTERN asm_pchar                ; print contents of L to asci0/1, modifies AF & HL
EXTERN asm_pstring              ; print string from location in DE to asci0/1, modifies AF, DE, & HL
EXTERN asm_rhex                 ; Returns byte in A, modifies HL
EXTERN asm_rchar                ; Rx byte in L (A = byte Rx too) SCF if char read
EXTERN asm_delay                ; short delay about 48 cycles * 65536 iterations

