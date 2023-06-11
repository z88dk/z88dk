
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

uint32_t rn_fileHandleSeek(uint8_t fileHandle, int32_t offset, uint8_t seekOption) {

    // 0xb6

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_SEEK);

    hcca_writeByte(fileHandle);

    hcca_writeInt32(offset);

    hcca_writeByte(seekOption);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readUInt32();
}
