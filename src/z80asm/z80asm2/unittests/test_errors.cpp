//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "catch_amalgamated.hpp"
#include <iostream>
#include <sstream>

// Helper to capture std::cerr output
class CerrRedirect {
    std::ostringstream ss;
    std::streambuf* old;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

// Global capture for this translation unit to prevent tests from printing to the console.
// Individual tests can still create their own local CerrRedirect if they need to inspect output.
static CerrRedirect g_cerr_silencer;

TEST_CASE("Errors counts errors", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound);
    er.error(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 2);
    REQUIRE(er.has_errors());
}

TEST_CASE("Errors does not count warnings", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.warning(ErrorCode::FileNotFound);
    er.warning(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 0);
    REQUIRE_FALSE(er.has_errors());
}

TEST_CASE("Errors prints error", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("error: File not found: test.asm") != std::string::npos);
}

TEST_CASE("Errors prints warning", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.warning(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("warning: File not found: test.asm") != std::string::npos);
}

TEST_CASE("Errors prints with Location", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 42));
    er.error(ErrorCode::InvalidSyntax, "bad token");
    std::string output = redirect.str();
    REQUIRE(output.find("foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find(
                "foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
}

TEST_CASE("Errors prints with Location and source file", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 42));
    er.set_source_line("LD A, 42");
    er.set_expanded_line("LD A,42");
    er.error(ErrorCode::InvalidSyntax, "bad token");
    REQUIRE(er.last_error_message().find(
                "foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find("   |LD A, 42") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find("   |LD A,42") !=
            std::string::npos);
}

TEST_CASE("Errors::reset resets error count and last error message",
          "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "foo.asm");
    REQUIRE(er.error_count() == 1);
    REQUIRE(er.has_errors());
    REQUIRE_FALSE(er.last_error_message().empty());
    er.reset();
    REQUIRE(er.error_count() == 0);
    REQUIRE_FALSE(er.has_errors());
    REQUIRE(er.last_error_message().empty());
}

TEST_CASE("Errors::clear clears location and lines but not error count",
          "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("bar.asm", 99));
    er.set_source_line("LD HL,0");
    er.set_expanded_line("LD HL,0");
    er.error(ErrorCode::FileNotFound, "bar.asm");
    REQUIRE(er.error_count() == 1);
    er.clear();
    // error_count should remain
    REQUIRE(er.error_count() == 1);
    // location and lines should be cleared
    REQUIRE(er.filename().empty());
    REQUIRE(er.line_num() == 0);
}

TEST_CASE("Errors::filename and line_num reflect location", "[Errors]") {
    Errors er;
    er.set_location(Location("baz.asm", 123));
    REQUIRE(er.filename() == "baz.asm");
    REQUIRE(er.line_num() == 123);
}

TEST_CASE("Errors::set_source_line and set_expanded_line store lines",
          "[Errors]") {
    Errors er;
    er.set_source_line("ORG 0");
    er.set_expanded_line("ORG 0");
    // These are private, but their effect is visible in last_error_message
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 1));
    er.error(ErrorCode::InvalidSyntax, "bad");
    std::string msg = er.last_error_message();
    REQUIRE(msg.find("ORG 0") != std::string::npos);
}

TEST_CASE("Errors::last_error_message returns last error", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "file.asm");
    std::string msg = er.last_error_message();
    REQUIRE(msg.find("File not found: file.asm") != std::string::npos);
    er.error(ErrorCode::InvalidSyntax, "oops");
    std::string msg2 = er.last_error_message();
    REQUIRE(msg2.find("Invalid syntax: oops") != std::string::npos);
}

TEST_CASE("Errors::has_errors returns false when no errors", "[Errors]") {
    Errors er;
    REQUIRE_FALSE(er.has_errors());
    er.warning(ErrorCode::FileNotFound, "file.asm");
    REQUIRE_FALSE(er.has_errors());
}

TEST_CASE("Errors::error_count returns correct count", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    REQUIRE(er.error_count() == 0);
    er.error(ErrorCode::FileNotFound);
    REQUIRE(er.error_count() == 1);
    er.error(ErrorCode::InvalidSyntax);
    REQUIRE(er.error_count() == 2);
}

TEST_CASE("Errors shows both source and expanded lines when they differ",
          "[Errors][lines][different]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("diff.asm", 5));
    er.set_source_line("LD A, 42");
    er.set_expanded_line("LD A,42");
    er.error(ErrorCode::InvalidSyntax, "bad token");
    std::string out = redirect.str();
    // Error header
    REQUIRE(out.find("diff.asm:5: error: Invalid syntax: bad token") !=
            std::string::npos);
    // Source line present
    REQUIRE(out.find("   |LD A, 42") != std::string::npos);
    // Expanded line present (different spacing)
    REQUIRE(out.find("   |LD A,42") != std::string::npos);
}

TEST_CASE("Errors shows only source line when expanded line equals source",
          "[Errors][lines][equal]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("same.asm", 7));
    er.set_source_line("NOP");
    er.set_expanded_line("NOP"); // identical
    er.error(ErrorCode::InvalidSyntax, "unexpected");
    std::string out = redirect.str();
    // Header
    REQUIRE(out.find("same.asm:7: error: Invalid syntax: unexpected") !=
            std::string::npos);
    // Source line appears
    REQUIRE(out.find("   |NOP") != std::string::npos);
    // Count occurrences of the marker line; should be exactly one
    size_t pos = out.find("   |NOP");
    REQUIRE(pos != std::string::npos);
    REQUIRE(out.find("   |NOP", pos + 1) == std::string::npos);
}
