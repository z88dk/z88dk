#pragma once
extern void init_1(void);
extern void fini_1(void);

typedef struct Person {
	char *name;
	int   age;
} Person;

extern void struct_Person_init(Person *self, char *name, int age);
extern void struct_Person_fini(Person *self);

typedef struct Person0 {
	char *name;
	int   age;
} Person0;

typedef struct Person1 {
	char *name;
	int   age;
} Person1;

typedef struct Person2 {
	char *name;
	int   age;
} Person2;

typedef struct Person3 {
	char *name;
	int   age;
} Person3;

