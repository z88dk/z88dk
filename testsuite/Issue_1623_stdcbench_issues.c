


static const int y_endpositions[20][16];
static const int (*const volatile y_endpos)[16];
static const int *x_endpos[16];


int func0() {
	return y_endpositions[10][2];
}
int func1() {
	return y_endpos[10][2];
}
int func0b(int i) {
	return y_endpositions[i][2];
}
int func1b(int i) {
	return y_endpos[i][2];
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
