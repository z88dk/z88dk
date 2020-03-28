#include <arch/msx.h>

void DosCall(uint8_t function, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail)
{
    regs->Bytes.C = function;
    AsmCall(0x0005,regs,inRegistersDetail < REGS_MAIN ? REGS_MAIN : inRegistersDetail, outRegistersDetail);
}
