
double func(double a);
double func2(double a,double b);

double assign(void) { double a = 2.5; return a; }
double assign2(void) { double a; a = 2.5; func(a); return a; }
double assign_via_pointer(double *a) { *a = 10.0; }
double funccall(double a) { return func(a); }

double funcptr(double a) {
    double (*ptr)(double,double) = func2;

    return ptr(a,1.0);
}

double add(double a, double b) { return a + b; }
double sub(double a, double b) { return a - b; }
double mul(double a, double b) { return a * b; }
double div(double a, double b) { return a / b; }

int eq(double a, double b) { return a == b; }
int ne(double a, double b) { return a != b; }
int lt(double a, double b) { return a < b; }
int le(double a, double b) { return a <= b; }
int gt(double a, double b) { return a > b; }
int ge(double a, double b) { return a >= b; }

double neg(double a) { return -a; }

double inverse(double a) { return 1/a; }

double cschar(signed char c) { return (double) c; }
double cuchar(unsigned char c) { return (double) c; }
double csint(signed int i) { return (double) i; }
double cuint(unsigned int i) { return (double) i; }
double cslong(signed long i) { return (double) i; }
double culong(unsigned long i) { return (double) i; }
