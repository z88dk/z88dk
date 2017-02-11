/*
Z88DK Z80 Macro Assembler

Unit test for alloc.c

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "minunit.h"
#include "alloc.h"
#include <assert.h>

static int test_no_allocation(void)
{
	m_alloc_init();
	return MU_PASS;
}

static int test_no_leak(void)
{
	char *p0, *p1;
	
	p0 = m_malloc_compat(1);
	mu_assert_ptr(p0);

	p1 = m_malloc(1);
	mu_assert_ptr(p1);

	m_free_compat(p0);
	mu_assert_ptr(p0);	/* free compat does not clear pointer */

	m_free(p1);
	mu_assert_ptr_null(p1);

	m_free(p1);
	mu_assert_ptr_null(p1);

	return MU_PASS;
}

static int test_alloc_failed(void)
{
	size_t size = 1;
	void *memptr = NULL;

	while (1) {
		memptr = m_realloc( memptr, size );
		size *= 2;
	}

	return MU_PASS;
}

static int test_unmatched_block(void)
{
	char p1[10], *p2 = p1;

	m_free(p2);

	return MU_PASS;
}

static int test_buffer_underflow(void)
{
	char *p1;

	p1 = m_malloc(1);
	p1[-1] = 0;
	m_free(p1);

	return MU_PASS;
}

static int test_buffer_overflow(void)
{
	char *p1;

	p1 = m_malloc(1);
	p1[1] = 0;
	m_free(p1);

	return MU_PASS;
}

static int test_malloc(void)
{
	char *p0, *p1;
	
	p0 = m_malloc_compat(0);
	mu_assert_ptr(p0);

	p1 = m_malloc(1);
	mu_assert_ptr(p1);

	p1[0] = 0;

	mu_assert_int( memcmp(p0-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA",      8), ==, 0 );
	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA",    9), ==, 0 );

	return MU_PASS;
}

static int test_calloc(void)
{
	char *p0, *p1;
	
	p0 = m_calloc_compat(5, 1);
	mu_assert_ptr(p0);

	p1 = m_calloc(5, 1);
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p0-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );
	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );

	return MU_PASS;
}

static int test_strdup(void)
{
	char *p0, *p1;
	
	p0 = m_strdup_compat("hello");
	mu_assert_ptr(p0);

	p1 = m_strdup("hello");
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p0-4, "\xAA\xAA\xAA\xAAhello\0\xAA\xAA\xAA\xAA", 14), ==, 0 );
	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAAhello\0\xAA\xAA\xAA\xAA", 14), ==, 0 );

	mu_assert_str( p0, ==, "hello" );
	mu_assert_str( p1, ==, "hello" );
	
	return MU_PASS;
}

static int test_realloc(void)
{
	char *p0, *p1, *p2, *p3;

	p0 = m_realloc_compat(NULL, 1);	
	mu_assert_ptr(p0);

	p1 = m_realloc(NULL, 2);	
	mu_assert_ptr(p1);

	p2 = m_realloc(NULL, 3);	
	mu_assert_ptr(p2);

	p0[0] = 1; 
	p1[0] = 1; p1[1] = 2;
	p2[0] = 1; p2[1] = 2; p2[2] = 3;

	mu_assert_int( memcmp(p0-4, "\xAA\xAA\xAA\xAA\1\xAA\xAA\xAA\xAA",      9), ==, 0 );
	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\2\xAA\xAA\xAA\xAA",   10), ==, 0 );
	mu_assert_int( memcmp(p2-4, "\xAA\xAA\xAA\xAA\1\2\3\xAA\xAA\xAA\xAA", 11), ==, 0 );

	/* shrink */
	p1 = m_realloc(p1, 1);
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\1\xAA\xAA\xAA\xAA", 9), ==, 0 );

	p1 = m_realloc(p1, 0);
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\xAA\xAA\xAA\xAA", 8), ==, 0 );

	/* grow */
	p1 = m_realloc(p1, 1);
	mu_assert_ptr(p1);

	memcpy(p1, "1", 1);

	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA" 
							    "1" 
								"\xAA\xAA\xAA\xAA", 1 + 8), ==, 0 );

	p1 = m_realloc(p1, 32);
	mu_assert_ptr(p1);

	memcpy(p1, "12345678901234567890123456789012", 32);

	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA" 
							    "12345678901234567890123456789012" 
								"\xAA\xAA\xAA\xAA", 32 + 8), ==, 0 );

	/* keep sequence of free when reallocating */
	p3 = m_malloc(4);
	mu_assert_ptr(p3);

	p1 = m_realloc(p1, 2);
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA" "12" "\xAA\xAA\xAA\xAA", 2 + 8), ==, 0 );

	return MU_PASS;
}

static int test_new(void)
{
	char *p0, *p1, *p2, *p3;
	
	p0 = m_new(char);
	mu_assert_ptr(p0);

	p1 = m_new(char);
	mu_assert_ptr(p1);

	mu_assert_int( memcmp(p0-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9), ==, 0 );
	mu_assert_int( memcmp(p1-4, "\xAA\xAA\xAA\xAA\0\xAA\xAA\xAA\xAA", 9), ==, 0 );

	p2 = m_new_n(char, 5);
	mu_assert_ptr(p2);

	p3 = m_new_n(char, 5);
	mu_assert_ptr(p3);

	mu_assert_int( memcmp(p2-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );
	mu_assert_int( memcmp(p3-4, "\xAA\xAA\xAA\xAA\0\0\0\0\0\xAA\xAA\xAA\xAA", 13), ==, 0 );

	return MU_PASS;
}

typedef struct {
	char *name;
	int   age;
} Person;

static void Person_delete( Person *self )
{
	check(self, "Person is NULL");

	log_info("destroy Person(%s, %d)", self->name, self->age);
	m_free(self->name);
error: ;
}
	
static void destroy_string(char *text)
{
	check(text, "text is NULL");

	log_info("destroy string(%s)", text);
error: ;
}

static Person *Person_new( char *name, int age )
{
	static Bool toggle = FALSE;

	char   *name_copy;
	Person *self;
	void   *p;

	toggle = ! toggle;
	if ( toggle ) {
		log_info("create %s bottom-up to assure destruction order", name);

		name_copy	= m_strdup(name);
		self		= m_new(Person);
		p = m_clear_in_collection( name_copy );
		assert( p == name_copy );
	}
	else {
		log_info("create %s top-down and use in_collection to assure destruction order", name);

		self		= m_new(Person);
		name_copy	= m_strdup(name);
		p = m_set_in_collection( name_copy );
		assert( p == name_copy );
	}

	p = m_set_destructor( self,		 (destructor_t) Person_delete );
	assert( p == self );

	p = m_set_destructor( name_copy, (destructor_t) destroy_string );
	assert( p == name_copy );

	self->name = name_copy;
	self->age  = age;

	log_info("create Person(%s, %d)", self->name, self->age);
	return self;
}

static int test_destructor(void)
{
	char *s0, *s1, *s2;
	Person *p1, *p2;
	void *p;

	s0 = m_strdup("hello");	
	s1 =   strdup("big");	
	s2 = m_strdup("world");	

	p = m_destroy_atexit(s0);
	assert( p == s0 );

	p = m_destroy_atexit(s1);
	assert( p == s1 );

	p = m_destroy_atexit(s2);
	assert( p == s2 );

	mu_assert(   m_is_managed(s0), "s0 should be managed" );
	mu_assert( ! m_is_managed(s1), "s1 should not be managed" );
	mu_assert(   m_is_managed(s2), "s2 should be managed" );

	log_info("allocated %s, %s and %s", s0, s1, s2 );

	p = m_set_destructor( s0, (destructor_t) destroy_string );
	assert( p == s0 );

	p = m_set_destructor( s1, (destructor_t) destroy_string );	/* will croak */
	assert( p == s1 );

	p = m_set_destructor( s2, (destructor_t) destroy_string );
	assert( p == s2 );


	p = m_set_in_collection( s1 );		/* will croak */
	assert( p == s1 );

	p = m_clear_in_collection( s1 );	/* will croak */
	assert( p == s1 );

	p1 = Person_new("John", 15);
	p2 = Person_new("Fred", 16); 

	log_info("allocated %s and %s", p1->name, p2->name );

	/* s0 and s2 will be deleted by garbage collector */
	free(s1);

	return MU_PASS;
}

int main(int argc, char *argv[])
{
	mu_init(argc, argv);
    mu_run_test(MU_PASS, test_no_allocation);
    mu_run_test(MU_PASS, test_no_leak);
    mu_run_test(MU_FAIL, test_alloc_failed);
    mu_run_test(MU_PASS, test_unmatched_block);
    mu_run_test(MU_PASS, test_buffer_underflow);
    mu_run_test(MU_PASS, test_buffer_overflow);
    mu_run_test(MU_PASS, test_malloc);
    mu_run_test(MU_PASS, test_calloc);
    mu_run_test(MU_PASS, test_strdup);
    mu_run_test(MU_PASS, test_realloc);
    mu_run_test(MU_PASS, test_new);
	mu_run_test(MU_PASS, test_destructor);
	mu_fini();
}
