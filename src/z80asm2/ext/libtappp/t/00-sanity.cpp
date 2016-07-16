#include <exception>
#include <string>
#include <cstdlib>
#define WANT_TEST_EXTRAS
#include <tap++/tap++.h>

using namespace TAP;

class exception : public std::exception {
    std::string message;
public:
    exception(const std::string& _message) : message(_message) {
    }
    virtual const char* what() const throw() {
        return message.c_str();
    }
    ~exception() throw() {
    }
};

int main() {
    TEST_START(13);

    ok(true, "True is ok");
    not_ok(false, "False is not ok");
    is(1, 1, "1 == 1");
    isnt(1, 2, "1 == 2");
    is(1.0, 1.0, "1.0 == 1.0");
    not_ok(float(0.1) == 0.1, "float(0.1) != 0.1");
    is(float(67329.234), float(67329.242), "Adjacent floats");
    isnt(1.0, 2.0, "1.0 != 2.0");

    TRY(std::rand(), "rand shouldn't throw exceptions");
    FAIL(throw exception("Runtime exception"), "Should throw a Runtime exception");

    BLOCK_START(1);
    skip("Should skip");
    is(0, 1, "0 == 1");
    BLOCK_END;

    TRY_DECL(int foo = std::rand(), "int foo = std::rand()");
    ok(++foo, "++foo");

    TEST_END;
}
