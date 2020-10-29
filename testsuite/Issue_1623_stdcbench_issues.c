


static const int (*y_endpos)[16];
static const int *x_endpos[16];


int func() {
	return y_endpos[10][2];
}
int func2() {
	return x_endpos[10][2];
}

#define STDCBENCH_CLOCKS_PER_SEC 1000000
#define SECONDS (STDCBENCH_CLOCKS_PER_SEC * 8UL)

static unsigned long stdcbench_end;
static unsigned long stdcbench_start;
static unsigned long iterations;

int func3() {
	return (iterations * (1000 * SECONDS / (stdcbench_end - stdcbench_start)) / 100);
}
