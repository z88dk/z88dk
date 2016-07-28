//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "util.hpp"
#include "file_system.hpp"

std::istream& safeGetline(std::istream& is, std::string& t)
{
    t.clear();

    // The characters in the stream are read one-by-one using a std::streambuf.
    // That is faster than reading them one-by-one using the std::istream.
    // Code that uses streambuf this way must be guarded by a sentry object.
    // The sentry object performs various tasks,
    // such as thread synchronization and updating the stream state.

    std::istream::sentry se(is, true);
    std::streambuf* sb = is.rdbuf();

    for(;;) {
        int c = sb->sbumpc();
        switch (c) {
        case '\n':
            return is;
        case '\r':
            if(sb->sgetc() == '\n')
                sb->sbumpc();
            return is;
        case EOF:
            // Also handle the case when the last line has no line ending
			if (t.empty())
				is.setstate(std::ios::eofbit);
            
            return is;
        default:
            t += (char)c;
        }
    }
}

std::string file_lookup(const std::string& filename, const std::vector<std::string>& list)
{
	if (stlplus::is_file(filename))
		return filename;
	else {
		for (unsigned i = 0; i < list.size(); i++) {
			std::string test_file = stlplus::folder_append_separator(list[i]);
			test_file += filename;
			if (stlplus::is_file(test_file))
				return test_file;
		}
		return filename;
	}
}

