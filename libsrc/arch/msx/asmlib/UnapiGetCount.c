#include <arch/msx.h>

int UnapiGetCount(char* implIdentifier)
{
	char* arg;

	Z80_registers regs;
	regs.Words.DE=0x2222;
	regs.Bytes.A=0;
	regs.Bytes.B=0;
	
	arg=(char*)0xF847;
	while(*arg++ = *implIdentifier++); //This is just a funny strcpy

	AsmCall(0xFFCA, &regs, REGS_MAIN , REGS_MAIN);
	return regs.Bytes.B;
}
