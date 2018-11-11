#include <arch/msx.h>

void BiosCall(uint16_t address, Z80_registers* regs, register_usage outRegistersDetail)
{
    regs->Bytes.IYh = *((uint8_t*)0xFCC1);
    regs->Words.IX = address;
    AsmCall(0x001C,regs,REGS_ALL, outRegistersDetail);
}
