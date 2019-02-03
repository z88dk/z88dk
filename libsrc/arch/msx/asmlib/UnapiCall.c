#include <arch/msx.h>

void UnapiCall(unapi_code_block* codeBlock, uint8_t functionNumber, Z80_registers* registers, register_usage inRegistersDetail, register_usage outRegistersDetail) 
{
	registers->Bytes.A = functionNumber;
	AsmCall((uint16_t)&(codeBlock->UnapiCallCode), registers, inRegistersDetail == REGS_NONE ? REGS_AF : inRegistersDetail, outRegistersDetail);
}
