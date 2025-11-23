// move org to have more room for software sprites

#pragma output CRT_ORG_CODE = 30000

// typical stack location when using sp1 sprite engine

#pragma output REGISTER_SP  = 0xd000

// indicate we are not returning to basic, reduces crt size

#pragma output CRT_ON_EXIT  = 0x10001

// control size of printf

#pragma printf = "%u"

// use a different font to be crazy

#pragma redirect CRT_OTERM_FONT_8X8 = _font_8x8_clairsys

// heap sizes

#pragma output CLIB_STDIO_HEAP_SIZE  = 0
