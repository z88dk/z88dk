#include "mod1.h"
#include <stdio.h>
#include <glib.h>

void init_1(void)
{
	printf("init_1()\n");
}

void fini_1(void)
{
	printf("fini_1()\n");
}

void struct_Person_init(struct Person *self, char *name, int age)
{
	self->name = g_strdup(name);
	self->age  = age;
	printf("Person init name=%s, age=%d, allocated memory\n", self->name, self->age);
}

void struct_Person_fini(struct Person *self)
{
	printf("Person fini %s, freed memory\n", self->name);
	g_free(self->name);
}
