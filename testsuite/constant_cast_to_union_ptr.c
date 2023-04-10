#include <stdint.h>

typedef int dual;

union memory_mapper_segment_info {
    struct { uint8_t segment; uint8_t slot_id; };
    dual unified;
};
typedef union memory_mapper_segment_info MemoryMapperSegmentInfo;

#define RESOURCE_SEGMENT_ADDRESS 0x1000

#define RESOURCE_SEGMENT_TYPE_SCRIPT 10


int func()
{
  return ((MemoryMapperSegmentInfo*)RESOURCE_SEGMENT_ADDRESS)[RESOURCE_SEGMENT_TYPE_SCRIPT].slot_id;

}
