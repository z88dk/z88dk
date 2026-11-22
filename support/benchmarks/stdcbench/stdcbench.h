#include "portme.h"

extern const char stdcbench_name_version_string[];

unsigned long stdcbench(void);

void stdcbench_error(const char *message);

stdcbench_clock_t stdcbench_clock(void);

union stdcbench_buffer
{
	unsigned char unsigned_char [1536];
	char basic_char [1536];
	signed int signed_int [32];
};

extern union stdcbench_buffer stdcbench_buffer;

#ifdef C90BASE
extern unsigned long c90base_score;
unsigned long c90base(void);
#endif

#ifdef C90FLOAT
unsigned long c90float(void);
#endif

#ifdef C90DOUBLE
unsigned long c90double(void);
#endif

#ifdef C90LIB
extern unsigned long c90lib_score;
unsigned long c90lib(void);
#endif

