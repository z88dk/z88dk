
typedef unsigned char uint8_t;
typedef unsigned int uint16_t;

uint8_t data[] = {0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3};
uint16_t *frames2[] = {data+4, data - 4 * 2};
uint16_t *frames[] = {data+(4*0),data+(4*1),data+(4*2),data+(4*3)};
