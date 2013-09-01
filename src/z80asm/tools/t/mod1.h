#pragma once
extern void init_1(void);
extern void fini_1(void);

typedef struct Module1 {
	char *name;
	int   count;
} Module1;

extern void struct_Module1_init(struct Module1 *self);
extern void struct_Module1_fini(struct Module1 *self);
