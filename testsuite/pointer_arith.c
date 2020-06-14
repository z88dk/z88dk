
int c;

char *func1a(char *ptr) {
	return ptr + 2;
}
char *func1b(char *ptr) {
	return 2 + ptr;
}
int func1c(char *p1, char *p2) {
        return p2 - p1;
}
char *func1d(char *ptr) {
	return ptr - c;
}
char *func1e(char *ptr) {
	return ptr--;
}

int *func2a(int *ptr) {
	return ptr + 2;
}
int *func2b(int *ptr) {
	return 2 + ptr;
}
int func2c(int *p1, int *p2) {
        return p2 - p1;
}
int *func2d(int *ptr) {
	return ptr - c;
}
int *func2e(int *ptr) {
	return ptr--;
}

short *func3a(short *ptr) {
	return ptr + 2;
}
short *func3b(short *ptr) {
	return 2 + ptr;
}
int func3c(short *p1, short *p2) {
        return p2 - p1;
}
short *func3d(short *ptr) {
	return ptr - c;
}
short *func3e(short *ptr) {
	return ptr--;
}

long *func4a(long *ptr) {
	return ptr + 2;
}
long *func4b(long *ptr) {
	return 2 + ptr;
}
int func4c(long *p1, long *p2) {
        return p2 - p1;
}
long *func4d(long *ptr) {
	return ptr - c;
}
long *func4e(long *ptr) {
	return ptr--;
}


long **func5a(long **ptr) {
	return ptr + 2;
}
long **func5b(long **ptr) {
	return 2 + ptr;
}

int func5c(long **p1, long **p2) {
        return p2 - p1;
}
long **func5d(long **ptr) {
	return ptr - c;
}
long **func5e(long **ptr) {
	return ptr--;
}
