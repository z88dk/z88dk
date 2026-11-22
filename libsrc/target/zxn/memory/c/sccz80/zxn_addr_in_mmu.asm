; unsigned int zxn_addr_in_mmu(unsigned char mmu, unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_addr_in_mmu

EXTERN asm_zxn_addr_in_mmu

zxn_addr_in_mmu:

   pop de
   pop hl
   dec sp
   pop af
   
   push af
   inc sp
   push hl
   push de

   jp asm_zxn_addr_in_mmu

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_addr_in_mmu
defc _zxn_addr_in_mmu = zxn_addr_in_mmu
ENDIF

