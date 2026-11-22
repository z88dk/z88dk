
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

uint16_t rn_fileList(uint8_t pathLen, char *path, uint8_t wildcardLen, char *wildcard, uint8_t fileListFlags) {

    // 0xb1

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_LIST);

    hcca_writeByte(pathLen);

    hcca_writeBytes(0, pathLen, path);

    hcca_writeByte(wildcardLen);

    hcca_writeBytes(0, wildcardLen, wildcard);

    hcca_writeByte(fileListFlags);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readUInt16();
}
