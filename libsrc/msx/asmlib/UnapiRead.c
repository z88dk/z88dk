#include <arch/msx.h>

uint8_t UnapiRead(unapi_code_block* codeBlock, uint16_t address)
{
	Z80_registers regs;
	regs.Words.HL = address;
	AsmCall((uint16_t)&(codeBlock->UnapiReadCode), &regs, REGS_MAIN, REGS_AF);
	return regs.Bytes.A;
}
