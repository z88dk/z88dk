#include <arch/msx.h>

void UnapiParseCodeBlock(unapi_code_block* codeBlock, uint8_t* slot, uint8_t* segment, uint16_t* address)
{
	if(codeBlock->UnapiCallCode[0] == 0xC3) {
		*address = *(uint16_t*)&(codeBlock->UnapiCallCode[1]);
		return;
	}

	*address = *(uint16_t*)&(codeBlock->UnapiCallCode[6]);
	*segment = codeBlock->UnapiCallCode[2];
	*slot = codeBlock->UnapiCallCode[3];
}
