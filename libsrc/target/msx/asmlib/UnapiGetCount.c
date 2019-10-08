#include <arch/msx.h>
#include <string.h>

int UnapiGetCount(char* implIdentifier)
{
	Z80_registers regs;
	regs.Words.DE=0x2222;
	regs.Bytes.A=0;
	regs.Bytes.B=0;
	
	strcpy(0xf847, implIdentifier);

	AsmCall(0xFFCA, &regs, REGS_MAIN , REGS_MAIN);
	return regs.Bytes.B;
}
