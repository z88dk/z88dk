#include <arch/msx.h>
#include <string.h>

#define Z80_LD_B 0x06
#define Z80_LD_A 0x3E
#define Z80_JP 0xC3
#define Z80_RET 0xC9
#define Z80_LD_A_HL 0x7E
#define Z80_LD_IY 0x21FD
#define Z80_LD_IX 0x21DD
#define Z80_BIT7_H 0x7CCB
#define Z80_JR_Z_2 0x0228
#define CALSLT 0x001C
#define RDSLT 0x000C

void UnapiBuildCodeBlock(char* implIdentifier, int implIndex, unapi_code_block* codeBlock)
{
	uint16_t* codeBlockWords;
	uint16_t ramHelperAddress;

	Z80_registers regs;
	regs.Bytes.A = implIndex;
	regs.Words.DE = 0x2222;

	if(implIdentifier != NULL) {	
		strcpy(0xf847, implIdentifier);
	}

	AsmCall(0xFFCA, &regs, REGS_MAIN , REGS_MAIN);

	//* Page 3 address: generate JP address for calling, and "ld a,(hl)" for reading

	if((regs.Bytes.H & 0xC0) == 0xC0) {
		codeBlock->UnapiCallCode[0] = Z80_JP;
		*(uint16_t*)&(codeBlock->UnapiCallCode[1]) = regs.Words.HL;

		codeBlock->UnapiReadCode[0] = Z80_LD_A_HL;
		codeBlock->UnapiReadCode[1] = Z80_RET;
		return;
	} 

	codeBlockWords=(uint16_t*)&(codeBlock->UnapiCallCode[0]);

	//* ROM or RAM segment: generate LD IY,seg+slot*256 - LD IX,address - JP...

	*(uint16_t*)&(codeBlock->UnapiCallCode[0]) = Z80_LD_IY;
	codeBlock->UnapiCallCode[2] = regs.Bytes.B;
	codeBlock->UnapiCallCode[3] = regs.Bytes.A;
	*(uint16_t*)&(codeBlock->UnapiCallCode[4]) = Z80_LD_IX;
	*(uint16_t*)&(codeBlock->UnapiCallCode[6]) = regs.Words.HL;
	codeBlock->UnapiCallCode[8] = Z80_JP;

	//* If ROM, JP is to CALSLT and read code is JP RDSLT.
	//  Otherwise, JP is to the RAM helper and read code is LD A,slot - LD B,segment - JP ramhelper+3.
	//  In both cases, read code checks first if address is >=0x8000,
	//  and if so, reverts to LD A,(HL).

    *(uint16_t*)&(codeBlock->UnapiReadCode[0]) = Z80_BIT7_H;
    *(uint16_t*)&(codeBlock->UnapiReadCode[2]) = Z80_JR_Z_2;
    codeBlock->UnapiReadCode[4] = Z80_LD_A_HL;
    codeBlock->UnapiReadCode[5] = Z80_RET;
	codeBlock->UnapiReadCode[6] = Z80_LD_A;
	codeBlock->UnapiReadCode[7] = regs.Bytes.A;

	if(regs.Bytes.B == 0xFF) {
		*(uint16_t*)&(codeBlock->UnapiCallCode[9]) = CALSLT;
		
		codeBlock->UnapiReadCode[8] = Z80_JP;
		*(uint16_t*)&(codeBlock->UnapiReadCode[9]) = RDSLT;
	} else {
		UnapiGetRamHelper(&ramHelperAddress, NULL);
		*(uint16_t*)&(codeBlock->UnapiCallCode[9]) = ramHelperAddress;

		codeBlock->UnapiReadCode[8] = Z80_LD_B;
		codeBlock->UnapiReadCode[9] = regs.Bytes.B;
		codeBlock->UnapiReadCode[10] = Z80_JP;
		*(uint16_t*)&(codeBlock->UnapiReadCode[11]) = ramHelperAddress+3;
	}
}
