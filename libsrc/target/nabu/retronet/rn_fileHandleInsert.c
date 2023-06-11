
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

void rn_fileHandleInsert(uint8_t fileHandle, uint32_t fileOffset, uint16_t dataOffset, uint16_t dataLen, void *data) {

    //0xaa
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);

    hcca_writeByte(RETRONET_CMD_FH_WRITE_INSERT);

    hcca_writeByte(fileHandle);

    hcca_writeUInt32(fileOffset);

    hcca_writeUInt16(dataLen);

    hcca_start_write(HCCA_MODE_HDR, data + dataOffset, dataLen);

    hcca_write_wait_finished();
}
