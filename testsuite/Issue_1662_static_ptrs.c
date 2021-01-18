

struct x {
	char buf[10];
};

int *pint;
long *plong;
long long *plonglong;
struct x *pstr;


int iinc() {
	return *pint++;
}

long linc() {
	return *plong++;
}

long long llinc() {
	return *plonglong++;
}

struct x *stinc() {
	return pstr++;
}

int idec() {
	return *pint--;
}


long ldec() {
	return *plong--;
}

long long lldec() {
	return *plonglong--;
}
