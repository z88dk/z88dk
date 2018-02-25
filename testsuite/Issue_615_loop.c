
int var;

int func1() {
	do {
		whilefunc();
	} while(var++,0);
}

int func1a() {
	do {
		whilefunc();
	} while(var++,1);
}


int func1b() {
	do {
		whilefunc();
	} while(var);
}
int func1c() {
	do {
		whilefunc();
	} while(var++, 1 || var);
}

int func2() {
	while ( var++, 0 ) {
		whilefunc();
	}
}

int func2a() {
	while ( var++, 1 ) {
		whilefunc();
	}
}
int func2b() {
	while ( var ) {
		whilefunc();
	}
}


int func3() {
    int i;
    for ( i = 0; var++, 0; i++ ) {
	forfunc();
    }
}

int func3a() {
     int i;
    for ( i = 0; var++, 1; i++ ) {
	forfunc();
    }
}
int func3b() {
    int i;
    for ( i = 0; var++, i; i++ ) {
	forfunc();
    }
}
int func3c() {
    int i;
    for ( i = 0; i++, 0; i++ ) {
	forfunc();
    }
}
