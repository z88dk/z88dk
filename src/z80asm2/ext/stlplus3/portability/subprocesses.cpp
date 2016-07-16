////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

// Bug fix by Alistair Low: kill on Windows now kills grandchild processes as
// well as the child process. This is done using jobs - which has to be
// enabled by stating that the version of Windows is at least 5.0
#if defined(_WIN32) || defined(_WIN32_WCE)
#define _WIN32_WINNT 0x0500
#endif

#include "subprocesses.hpp"
#include "file_system.hpp"
#include "dprintf.hpp"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#ifdef MSWINDOWS
#ifdef __BORLANDC__
// missing declaration in Borland headers
LPTCH WINAPI GetEnvironmentStringsA(void);
#endif
#else
extern char** environ;
#include <signal.h>
#include <errno.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>
#endif

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // argument-vector related stuff

  static void skip_white (const std::string& command, unsigned& i)
  {
    while(i < command.size() && isspace(command[i]))
      i++;
  }

  // get_argument is the main function for breaking a string down into separate command arguments
  // it mimics the way shells break down a command into an argv[] and unescapes the escaped characters on the way

  static std::string get_argument (const std::string& command, unsigned& i)
  {
    std::string result;
#ifdef MSWINDOWS

  // as far as I know, there is only double-quoting and no escape character in DOS
  // so, how do you include a double-quote in an argument???

    bool dquote = false;
    for ( ; i < command.size(); i++)
    {
      char ch = command[i];
      if (!dquote && isspace(ch)) break;
      if (dquote)
      {
        if (ch == '\"')
          dquote = false;
        else
          result += ch;
      }
      else if (ch == '\"')
        dquote = true;
      else
        result += ch;
    }
#else
    bool squote = false;
    bool dquote = false;
    bool escaped = false;
    for ( ; i < command.size(); i++)
    {
      char ch = command[i];
      if (!squote && !dquote && !escaped && isspace(ch)) break;
      if (escaped)
      {
        result += ch;
        escaped = false;
      }
      else if (squote)
      {
        if (ch == '\'')
          squote = false;
        else
          result += ch;
      }
      else if (ch == '\\')
        escaped = true;
      else if (dquote)
      {
        if (ch == '\"')
          dquote = false;
        else
          result += ch;
      }
      else if (ch == '\'')
        squote = true;
      else if (ch == '\"')
        dquote = true;
      else
        result += ch;
    }
#endif

    return result;
  }


  // this function performs the reverse of the above on a single argument
  // it escapes special characters and quotes the argument if necessary ready for shell interpretation

  static std::string make_argument (const std::string& arg)
  {
    std::string result;
    bool needs_quotes = false;

    for (unsigned i = 0; i < arg.size(); i++)
    {
      switch (arg[i])
      {
        // set of characters requiring escapes
#ifdef MSWINDOWS
#else
      case '\\': case '\'': case '\"': case '`': case '(': case ')':
      case '&': case '|': case '<': case '>': case '*': case '?': case '!':
        result += '\\';
        result += arg[i];
        break;
#endif
        // set of whitespace characters that force quoting
      case ' ':
        result += arg[i];
        needs_quotes = true;
        break;
      default:
        result += arg[i];
        break;
      }
    }

    if (needs_quotes)
    {
      result.insert(result.begin(), '"');
      result += '"';
    }
    return result;
  }

  static char* copy_string (const char* str)
  {
    char* result = new char[strlen(str)+1];
    strcpy(result,str);
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

  arg_vector::arg_vector (void)
  {
    m_argv = 0;
  }

  arg_vector::arg_vector (const arg_vector& a)
  {
    m_argv = 0;
    *this = a;
  }

  arg_vector::arg_vector (char** a)
  {
    m_argv = 0;
    *this = a;
  }

  arg_vector::arg_vector (const std::string& command)
  {
    m_argv = 0;
    *this = command;
  }

  arg_vector::arg_vector (const char* command)
  {
    m_argv = 0;
    *this = command;
  }

  arg_vector::~arg_vector (void)
  {
    clear();
  }

  arg_vector& arg_vector::operator = (const arg_vector& a)
  {
    return *this = a.m_argv;
  }

  arg_vector& arg_vector::operator = (char** argv)
  {
    clear();
    for (unsigned i = 0; argv[i]; i++)
      operator += (argv[i]);
    return *this;
  }

  arg_vector& arg_vector::operator = (const std::string& command)
  {
    clear();
    for (unsigned i = 0; i < command.size(); )
    {
      std::string argument = get_argument(command, i);
      operator += (argument);
      skip_white(command, i);
    }
    return *this;
  }

  arg_vector& arg_vector::operator = (const char* command)
  {
    return operator = (std::string(command));
  }

  arg_vector& arg_vector::operator += (const std::string& str)
  {
    insert(size(), str);
    return *this;
  }

  arg_vector& arg_vector::operator -= (const std::string& str)
  {
    insert(0, str);
    return *this;
  }

  void arg_vector::insert (unsigned index, const std::string& str) throw(std::out_of_range)
  {
    if (index > size()) throw std::out_of_range("arg_vector::insert");
    // copy up to but not including index, then add the new argument, then copy the rest
    char** new_argv = new char*[size()+2];
    unsigned i = 0;
    for ( ; i < index; i++)
      new_argv[i] = copy_string(m_argv[i]);
    new_argv[index] = copy_string(str.c_str());
    for ( ; i < size(); i++)
      new_argv[i+1] = copy_string(m_argv[i]);
    new_argv[i+1] = 0;
    clear();
    m_argv = new_argv;
  }

  void arg_vector::clear (unsigned index) throw(std::out_of_range)
  {
    if (index >= size()) throw std::out_of_range("arg_vector::clear");
    // copy up to index, skip it, then copy the rest
    char** new_argv = new char*[size()];
    unsigned i = 0;
    for ( ; i < index; i++)
      new_argv[i] = copy_string(m_argv[i]);
    i++;
    for ( ; i < size(); i++)
      new_argv[i-1] = copy_string(m_argv[i]);
    new_argv[i-1] = 0;
    clear();
    m_argv = new_argv;
  }

  void arg_vector::clear(void)
  {
    if (m_argv)
    {
      for (unsigned i = 0; m_argv[i]; i++)
        delete[] m_argv[i];
      delete[] m_argv;
      m_argv = 0;
    }
  }

  unsigned arg_vector::size (void) const
  {
    unsigned i = 0;
    if (m_argv)
      while (m_argv[i])
        i++;
    return i;
  }

  arg_vector::operator char** (void) const
  {
    return m_argv;
  }

  char** arg_vector::argv (void) const
  {
    return m_argv;
  }

  char* arg_vector::operator [] (unsigned index) const throw(std::out_of_range)
  {
    if (index >= size()) throw std::out_of_range("arg_vector::operator[]");
    return m_argv[index];
  }

  char* arg_vector::argv0 (void) const throw(std::out_of_range)
  {
    return operator [] (0);
  }

  std::string arg_vector::image (void) const
  {
    std::string result;
    for (unsigned i = 0; i < size(); i++)
    {
      if (i) result += ' ';
      result += make_argument(m_argv[i]);
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // environment-vector

  // Windoze environment is a single string containing null-terminated
  // name=value strings and the whole terminated by a null

  // Unix environment is a null-terminated vector of pointers to null-terminated strings

  ////////////////////////////////////////////////////////////////////////////////
  // platform specifics

#ifdef MSWINDOWS
  // Windows utilities

  // Windows environment variables are case-insensitive and I do comparisons by converting to lowercase
  static std::string lowercase(const std::string& val)
  {
    std::string text = val;
    for (unsigned i = 0; i < text.size(); i++)
      text[i] = tolower(text[i]);
    return text;
  }

  static unsigned envp_size(const char* envp)
  {
    unsigned size = 0;
    while (envp[size] || (size > 0 && envp[size-1])) size++;
    size++;
    return size;
  }

  static void envp_extract(std::string& name, std::string& value, const char* envp, unsigned& envi)
  {
    name.erase();
    value.erase();
    if (!envp[envi]) return;
    // some special variables start with '=' so ensure at least one character in the name
    name += envp[envi++];
    while(envp[envi] != '=')
      name += envp[envi++];
    envi++;
    while(envp[envi])
      value += envp[envi++];
    envi++;
  }

  static void envp_append(const std::string& name, const std::string& value, char* envp, unsigned& envi)
  {
    for (unsigned i = 0; i < name.size(); i++)
      envp[envi++] = name[i];
    envp[envi++] = '=';
    for (unsigned j = 0; j < value.size(); j++)
      envp[envi++] = value[j];
    envp[envi++] = '\0';
    envp[envi] = '\0';
  }

  static char* envp_copy(const char* envp)
  {
    unsigned size = envp_size(envp);
    char* result = new char[size];
    result[0] = '\0';
    unsigned i = 0;
    unsigned j = 0;
    while(envp[i])
    {
      std::string name;
      std::string value;
      envp_extract(name, value, envp, i);
      envp_append(name, value, result, j);
    }
    return result;
  }

  static void envp_clear(char*& envp)
  {
    if (envp)
    {
      delete[] envp;
      envp = 0;
    }
  }

  static bool envp_equal(const std::string& left, const std::string& right)
  {
    return lowercase(left) == lowercase(right);
  }

  static bool envp_less(const std::string& left, const std::string& right)
  {
    return lowercase(left) < lowercase(right);
  }

#else
  // Unix utilities

  static unsigned envp_size(char* const* envp)
  {
    unsigned size = 0;
    while(envp[size]) size++;
    size++;
    return size;
  }

  static void envp_extract(std::string& name, std::string& value, char* const* envp, unsigned& envi)
  {
    name = "";
    value = "";
    if (!envp[envi]) return;
    unsigned i = 0;
    while(envp[envi][i] != '=')
      name += envp[envi][i++];
    i++;
    while(envp[envi][i])
      value += envp[envi][i++];
    envi++;
  }

  static void envp_append(const std::string& name, const std::string& value, char** envp, unsigned& envi)
  {
    std::string entry = name + "=" + value;
    envp[envi] = copy_string(entry.c_str());
    envi++;
    envp[envi] = 0;
  }

  static char** envp_copy(char* const* envp)
  {
    unsigned size = envp_size(envp);
    char** result = new char*[size];
    unsigned i = 0;
    unsigned j = 0;
    while(envp[i])
    {
      std::string name;
      std::string value;
      envp_extract(name, value, envp, i);
      envp_append(name, value, result, j);
    }
    return result;
  }

  static void envp_clear(char**& envp)
  {
    if (envp)
    {
      for (unsigned i = 0; envp[i]; i++)
        delete[] envp[i];
      delete[] envp;
      envp = 0;
    }
  }

  static bool envp_equal(const std::string& left, const std::string& right)
  {
    return left == right;
  }

  static bool envp_less(const std::string& left, const std::string& right)
  {
    return left < right;
  }

#endif
  ////////////////////////////////////////////////////////////////////////////////

  env_vector::env_vector(void)
  {
#ifdef MSWINDOWS
    char* env = (char*)GetEnvironmentStringsA();
    m_env = envp_copy(env);
    FreeEnvironmentStringsA(env);
#else
    m_env = envp_copy(::environ);
#endif
  }

  env_vector::env_vector (const env_vector& a)
  {
    m_env = 0;
    *this = a;
  }

  env_vector::~env_vector (void)
  {
    clear();
  }

  env_vector& env_vector::operator = (const env_vector& a)
  {
    clear();
    m_env = envp_copy(a.m_env);
    return *this;
  }

  void env_vector::clear(void)
  {
    envp_clear(m_env);
  }

  void env_vector::add(const std::string& name, const std::string& value)
  {
    // the trick is to add the value in alphabetic order
    // this is done by copying the existing environment string to a new
    // string, inserting the new value when a name greater than it is found
    unsigned size = envp_size(m_env);
#ifdef MSWINDOWS
    size_t new_size = size + name.size() + value.size() + 2;
    char* new_v = new char[new_size];
    new_v[0] = '\0';
#else
    unsigned new_size = size + 1;
    char** new_v = new char*[new_size];
    new_v[0] = 0;
#endif
    // now extract each name=value pair and check the ordering
    bool added = false;
    unsigned i = 0;
    unsigned j = 0;
    while(m_env[i])
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, i);
      if (envp_equal(name,current_name))
      {
        // replace an existing value
        envp_append(name, value, new_v, j);
      }
      else if (!added && envp_less(name,current_name))
      {
        // add the new value first, then the existing one
        envp_append(name, value, new_v, j);
        envp_append(current_name, current_value, new_v, j);
        added = true;
      }
      else
      {
        // just add the existing value
        envp_append(current_name, current_value, new_v, j);
      }
    }
    if (!added)
      envp_append(name, value, new_v, j);
    envp_clear(m_env);
    m_env = new_v;
  }


  bool env_vector::remove (const std::string& name)
  {
    bool result = false;
    // this is done by copying the existing environment string to a new string, but excluding the specified name
    unsigned size = envp_size(m_env);
#ifdef MSWINDOWS
    char* new_v = new char[size];
    new_v[0] = '\0';
#else
    char** new_v = new char*[size];
    new_v[0] = 0;
#endif
    unsigned i = 0;
    unsigned j = 0;
    while(m_env[i])
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, i);
      if (envp_equal(name,current_name))
        result = true;
      else
        envp_append(current_name, current_value, new_v, j);
    }
    envp_clear(m_env);
    m_env = new_v;
    return result;
  }

  bool env_vector::present (const std::string& name) const
  {
    unsigned i = 0;
    while(m_env[i])
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, i);
      if (envp_equal(name,current_name))
        return true;
    }
    return false;
  }

  std::string env_vector::operator [] (const std::string& name) const
  {
    return get(name);
  }

  std::string env_vector::get (const std::string& name) const
  {
    unsigned i = 0;
    while(m_env[i])
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, i);
      if (envp_equal(name,current_name))
        return current_value;
    }
    return std::string();
  }

  unsigned env_vector::size (void) const
  {
    unsigned i = 0;
#ifdef MSWINDOWS
    unsigned offset = 0;
    while(m_env[offset])
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, offset);
      i++;
    }
#else
    while(m_env[i])
      i++;
#endif

    return i;
  }

  std::pair<std::string,std::string> env_vector::operator [] (unsigned index) const throw(std::out_of_range)
  {
    return get(index);
  }

  std::pair<std::string,std::string> env_vector::get (unsigned index) const throw(std::out_of_range)
  {
    if (index >= size()) throw std::out_of_range("arg_vector::get");
    unsigned j = 0;
    for (unsigned i = 0; i < index; i++)
    {
      std::string current_name;
      std::string current_value;
      envp_extract(current_name, current_value, m_env, j);
    }
    std::string name;
    std::string value;
    envp_extract(name, value, m_env, j);
    return std::make_pair(name,value);
  }

  ENVIRON_TYPE env_vector::envp (void) const
  {
    return m_env;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Synchronous subprocess
  // Win32 implementation mostly cribbed from MSDN examples and then made (much) more readable
  // Unix implementation mostly from man pages and bitter experience
  ////////////////////////////////////////////////////////////////////////////////

#ifdef MSWINDOWS

  subprocess::subprocess(void)
  {
    m_pid.hProcess = 0;
    m_job = 0;
    m_child_in = 0;
    m_child_out = 0;
    m_child_err = 0;
    m_err = 0;
    m_status = 0;
  }

#else

  subprocess::subprocess(void)
  {
    m_pid = -1;
    m_child_in = -1;
    m_child_out = -1;
    m_child_err = -1;
    m_err = 0;
    m_status = 0;
  }

#endif

#ifdef MSWINDOWS

  subprocess::~subprocess(void)
  {
    if (m_pid.hProcess != 0)
    {
      close_stdin();
      close_stdout();
      close_stderr();
      kill();
      WaitForSingleObject(m_pid.hProcess, INFINITE);
      CloseHandle(m_pid.hThread);
      CloseHandle(m_pid.hProcess);
      CloseHandle(m_job);
    }
  }

#else

  subprocess::~subprocess(void)
  {
    if (m_pid != -1)
    {
      close_stdin();
      close_stdout();
      close_stderr();
      kill();
      for (;;)
      {
        int wait_status = 0;
        int wait_ret_val = waitpid(m_pid, &wait_status, 0);
        if (wait_ret_val != -1 || errno != EINTR) break;
      }
    }
  }

#endif

  void subprocess::set_error(int e)
  {
    m_err = e;
  }

  void subprocess::add_variable(const std::string& name, const std::string& value)
  {
    m_env.add(name, value);
  }

  bool subprocess::remove_variable(const std::string& name)
  {
    return m_env.remove(name);
  }

  const env_vector& subprocess::get_variables(void) const
  {
  	return m_env;
  }

#ifdef MSWINDOWS

  bool subprocess::spawn(const std::string& path, const arg_vector& argv,
                         bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    bool result = true;
    // first create the pipes to be used to connect to the child stdin/out/err
    // If no pipes requested, then connect to the parent stdin/out/err
    // for some reason you have to create a pipe handle, then duplicate it
    // This is not well explained in MSDN but seems to work
    PIPE_TYPE parent_stdin = 0;
    if (!connect_stdin)
      parent_stdin = GetStdHandle(STD_INPUT_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&parent_stdin, &tmp, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_in, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    PIPE_TYPE parent_stdout = 0;
    if (!connect_stdout)
      parent_stdout = GetStdHandle(STD_OUTPUT_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&tmp, &parent_stdout, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_out, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    PIPE_TYPE parent_stderr = 0;
    if (!connect_stderr)
      parent_stderr = GetStdHandle(STD_ERROR_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&tmp, &parent_stderr, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_err, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    // Now create the subprocess
    // The horrible trick of creating a console window and hiding it seems to be required for the pipes to work
    // Note that the child will inherit a copy of the pipe handles
    STARTUPINFOA startup = {sizeof(STARTUPINFO),0,0,0,0,0,0,0,0,0,0,
                            STARTF_USESTDHANDLES|STARTF_USESHOWWINDOW,SW_HIDE,0,0,
                            parent_stdin,parent_stdout,parent_stderr};
    bool created = CreateProcessA(path.c_str(),(char*)argv.image().c_str(),0,0,TRUE,CREATE_SUSPENDED,m_env.envp(),0,&startup,&m_pid) != 0;
    // close the parent copy of the pipe handles so that the pipes will be closed when the child releases them
    if (connect_stdin) CloseHandle(parent_stdin);
    if (connect_stdout) CloseHandle(parent_stdout);
    if (connect_stderr) CloseHandle(parent_stderr);
    if (!created)
    {
      set_error(GetLastError());
      close_stdin();
      close_stdout();
      close_stderr();
      result = false;
    }
    else
    {
      m_job = CreateJobObject(NULL, NULL);
      AssignProcessToJobObject(m_job, m_pid.hProcess);
      ResumeThread(m_pid.hThread);

      // The child process is now running so call the user's callback
      // The convention is that the callback can return false, in which case this will kill the child (if its still running)
      if (!callback())
      {
        result = false;
        kill();
      }
      close_stdin();
      close_stdout();
      close_stderr();
      // wait for the child to finish
      // TODO - kill the child if a timeout happens
      WaitForSingleObject(m_pid.hProcess, INFINITE);
      DWORD exit_status = 0;
      if (!GetExitCodeProcess(m_pid.hProcess, &exit_status))
      {
        set_error(GetLastError());
        result = false;
      }
      else if (exit_status != 0)
        result = false;
      m_status = (int)exit_status;
      CloseHandle(m_pid.hThread);
      CloseHandle(m_pid.hProcess);
      CloseHandle(m_job);
    }
    m_pid.hProcess = 0;
    return result;
  }

#else

  bool subprocess::spawn(const std::string& path, const arg_vector& argv,
                         bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    bool result = true;
    // first create the pipes to be used to connect to the child stdin/out/err

    int stdin_pipe [2] = {-1, -1};
    if (connect_stdin)
      if (::pipe(stdin_pipe) != 0)
        set_error(errno);

    int stdout_pipe [2] = {-1, -1};
    if (connect_stdout)
      if (::pipe(stdout_pipe) != 0)
        set_error(errno);

    int stderr_pipe [2] = {-1, -1};
    if (connect_stderr)
      if (::pipe(stderr_pipe) != 0)
        set_error(errno);

    // now create the subprocess
    // In Unix, this is done by forking (creating two copies of the parent), then overwriting the child copy using exec
    m_pid = ::fork();
    switch(m_pid)
    {
    case -1:   // failed to fork
      set_error(errno);
      if (connect_stdin)
      {
        ::close(stdin_pipe[0]);
        ::close(stdin_pipe[1]);
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[0]);
        ::close(stdout_pipe[1]);
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[0]);
        ::close(stderr_pipe[1]);
      }
      result = false;
      break;
    case 0:  // in child;
    {
      // for each pipe, close the end of the duplicated pipe that is being used by the parent
      // and connect the child's end of the pipe to the appropriate standard I/O device
      if (connect_stdin)
      {
        ::close(stdin_pipe[1]);
        ::dup2(stdin_pipe[0],STDIN_FILENO);
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[0]);
        ::dup2(stdout_pipe[1],STDOUT_FILENO);
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[0]);
        ::dup2(stderr_pipe[1],STDERR_FILENO);
      }
      execve(path.c_str(), argv.argv(), m_env.envp());
      // will only ever get here if the exec() failed completely - *must* now exit the child process
      // by using errno, the parent has some chance of diagnosing the cause of the problem
      exit(errno);
    }
    break;
    default:  // in parent
    {
      // for each pipe, close the end of the duplicated pipe that is being used by the child
      // and connect the parent's end of the pipe to the class members so that they are visible to the parent() callback
      if (connect_stdin)
      {
        ::close(stdin_pipe[0]);
        m_child_in = stdin_pipe[1];
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[1]);
        m_child_out = stdout_pipe[0];
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[1]);
        m_child_err = stderr_pipe[0];
      }
      // call the user's callback
      if (!callback())
      {
        result = false;
        kill();
      }
      // close the pipes and wait for the child to finish
      // wait exits on a signal which may be the child signalling its exit or may be an interrupt
      close_stdin();
      close_stdout();
      close_stderr();
      int wait_status = 0;
      for (;;)
      {
        int wait_ret_val = waitpid(m_pid, &wait_status, 0);
        if (wait_ret_val != -1 || errno != EINTR) break;
      }
      // establish whether an error occurred
      if (WIFSIGNALED(wait_status))
      {
        // set_error(errno);
        m_status = WTERMSIG(wait_status);
        result = false;
      }
      else if (WIFEXITED(wait_status))
      {
        m_status = WEXITSTATUS(wait_status);
        if (m_status != 0)
          result = false;
      }
      m_pid = -1;
    }
    break;
    }
    return result;
  }

#endif

  bool subprocess::spawn(const std::string& command_line,
                                  bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    arg_vector arguments = command_line;
    if (arguments.size() == 0) return false;
    std::string path = path_lookup(arguments.argv0());
    if (path.empty()) return false;
    return spawn(path, arguments, connect_stdin, connect_stdout, connect_stderr);
  }

  bool subprocess::callback(void)
  {
    return true;
  }

#ifdef MSWINDOWS

  bool subprocess::kill (void)
  {
    if (!m_pid.hProcess) return false;
    close_stdin();
    close_stdout();
    close_stderr();
    if (!TerminateJobObject(m_job, (UINT)-1))
    {
      set_error(GetLastError());
//      return false;
    }
	// we also terminate the pid (not relying on TerminateJobObject)
	if (!TerminateProcess(m_pid.hProcess, (UINT)-1))
	{
		set_error(GetLastError());
		return false;
	}
    return true;
  }

#else

  bool subprocess::kill (void)
  {
    if (m_pid == -1) return false;
    close_stdin();
    close_stdout();
    close_stderr();
    if (::kill(m_pid, SIGINT) == -1)
    {
      set_error(errno);
      return false;
    }
    return true;
  }

#endif

#ifdef MSWINDOWS

  int subprocess::write_stdin (std::string& buffer)
  {
    if (m_child_in == 0) return -1;
    // do a blocking write of the whole buffer
    DWORD bytes = 0;
    if (!WriteFile(m_child_in, buffer.c_str(), (DWORD)buffer.size(), &bytes, 0))
    {
      set_error(GetLastError());
      close_stdin();
      return -1;
    }
    // now discard that part of the buffer that was written
    if (bytes > 0)
      buffer.erase(0, bytes);
    return bytes;
  }

#else

  int subprocess::write_stdin (std::string& buffer)
  {
    if (m_child_in == -1) return -1;
    // do a blocking write of the whole buffer
    int bytes = write(m_child_in, buffer.c_str(), buffer.size());
    if (bytes == -1)
    {
      set_error(errno);
      close_stdin();
      return -1;
    }
    // now discard that part of the buffer that was written
    if (bytes > 0)
      buffer.erase(0, bytes);
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  int subprocess::read_stdout (std::string& buffer)
  {
    if (m_child_out == 0) return -1;
    DWORD bytes = 0;
    DWORD buffer_size = 256;
    char* tmp = new char[buffer_size];
    if (!ReadFile(m_child_out, tmp, buffer_size, &bytes, 0))
    {
      if (GetLastError() != ERROR_BROKEN_PIPE)
        set_error(GetLastError());
      close_stdout();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stdout();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return (int)bytes;
  }

#else

  int subprocess::read_stdout (std::string& buffer)
  {
    if (m_child_out == -1) return -1;
    int buffer_size = 256;
    char* tmp = new char[buffer_size];
    int bytes = read(m_child_out, tmp, buffer_size);
    if (bytes == -1)
    {
      set_error(errno);
      close_stdout();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stdout();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  int subprocess::read_stderr(std::string& buffer)
  {
    if (m_child_err == 0) return -1;
    DWORD bytes = 0;
    DWORD buffer_size = 256;
    char* tmp = new char[buffer_size];
    if (!ReadFile(m_child_err, tmp, buffer_size, &bytes, 0))
    {
      if (GetLastError() != ERROR_BROKEN_PIPE)
        set_error(GetLastError());
      close_stderr();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stderr();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return (int)bytes;
  }

#else

  int subprocess::read_stderr (std::string& buffer)
  {
    if (m_child_err == -1) return -1;
    int buffer_size = 256;
    char* tmp = new char[buffer_size];
    int bytes = read(m_child_err, tmp, buffer_size);
    if (bytes == -1)
    {
      set_error(errno);
      close_stderr();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stderr();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  void subprocess::close_stdin (void)
  {
    if (m_child_in)
    {
      CloseHandle(m_child_in);
      m_child_in = 0;
    }
  }

#else

  void subprocess::close_stdin (void)
  {
    if (m_child_in != -1)
    {
      ::close(m_child_in);
      m_child_in = -1;
    }
  }

#endif

#ifdef MSWINDOWS

  void subprocess::close_stdout (void)
  {
    if (m_child_out)
    {
      CloseHandle(m_child_out);
      m_child_out = 0;
    }
  }

#else

  void subprocess::close_stdout (void)
  {
    if (m_child_out != -1)
    {
      ::close(m_child_out);
      m_child_out = -1;
    }
  }

#endif

#ifdef MSWINDOWS

  void subprocess::close_stderr (void)
  {
    if (m_child_err)
    {
      CloseHandle(m_child_err);
      m_child_err = 0;
    }
  }

#else

  void subprocess::close_stderr (void)
  {
    if (m_child_err != -1)
    {
      ::close(m_child_err);
      m_child_err = -1;
    }
  }

#endif

  bool subprocess::error(void) const
  {
    return m_err != 0;
  }

  int subprocess::error_number(void) const
  {
    return m_err;
  }

#ifdef MSWINDOWS

  std::string subprocess::error_text(void) const
  {
    if (!error()) return std::string();
    char* message;
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                  0,
                  m_err,
                  MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                  (LPTSTR)&message,
                  0,0);
    std::string result = message;
    LocalFree(message);
    // the error message is for some perverse reason newline terminated - remove this
    if (result[result.size()-1] == '\n')
      result.erase(result.end()-1);
    if (result[result.size()-1] == '\r')
      result.erase(result.end()-1);
    return result;
  }

#else

  std::string subprocess::error_text(void) const
  {
    if (!error()) return std::string();
    char* text = strerror(m_err);
    if (text) return std::string(text);
    return "error number " + dformat("%d",m_err);
  }

#endif

  int subprocess::exit_status(void) const
  {
    return m_status;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // backtick subprocess and operations

  backtick_subprocess::backtick_subprocess(void) : subprocess()
  {
  }

  bool backtick_subprocess::callback(void)
  {
    for (;;)
    {
      std::string buffer;
      int read_size = read_stdout(buffer);
      if (read_size < 0) break;
      m_text += buffer;
    }
    return !error();
  }

  bool backtick_subprocess::spawn(const std::string& path, const arg_vector& argv)
  {
    return subprocess::spawn(path, argv, false, true, false);
  }

  bool backtick_subprocess::spawn(const std::string& command_line)
  {
    return subprocess::spawn(command_line, false, true, false);
  }

  std::vector<std::string> backtick_subprocess::text(void) const
  {
    std::vector<std::string> result;
    // convert the raw text into a vector of strings, each corresponding to a line
    // in the process, strip out platform-specific line-endings
    result.push_back(std::string());
    for (unsigned i = 0; i < m_text.size(); i++)
    {
      // handle any kind of line-ending - Dos, Unix or MacOS
      switch(m_text[i])
      {
      case '\xd': // carriage-return - optionally followed by linefeed
      {
        // discard optional following linefeed
        if ((i+1 < m_text.size()) && (m_text[i+1] == '\xa'))
          i++;
        // add a new line to the end of the vector
        result.push_back(std::string());
        break;
      }
      case '\xa': // linefeed
      {
        // add a new line to the end of the vector
        result.push_back(std::string());
        break;
      }
      default:
      {
        result.back() += m_text[i];
        break;
      }
      }
    }
    // tidy up - if the last line ended with a newline, the vector will end with an empty string - discard this
    if ((result.size()) > 0 && result.back().empty())
      result.erase(result.end()-1);
    return result;
  }

  std::vector<std::string> backtick(const std::string& path, const arg_vector& argv)
  {
    backtick_subprocess sub;
    sub.spawn(path, argv);
    return sub.text();
  }

  std::vector<std::string> backtick(const std::string& command_line)
  {
    backtick_subprocess sub;
    sub.spawn(command_line);
    return sub.text();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Asynchronous subprocess

#ifdef MSWINDOWS

  async_subprocess::async_subprocess(void)
  {
    m_pid.hProcess = 0;
    m_job = 0;
    m_child_in = 0;
    m_child_out = 0;
    m_child_err = 0;
    m_err = 0;
    m_status = 0;
  }

#else

  async_subprocess::async_subprocess(void)
  {
    m_pid = -1;
    m_child_in = -1;
    m_child_out = -1;
    m_child_err = -1;
    m_err = 0;
    m_status = 0;
  }

#endif

#ifdef MSWINDOWS

  async_subprocess::~async_subprocess(void)
  {
    if (m_pid.hProcess != 0)
    {
      close_stdin();
      close_stdout();
      close_stderr();
      kill();
      WaitForSingleObject(m_pid.hProcess, INFINITE);
      CloseHandle(m_pid.hThread);
      CloseHandle(m_pid.hProcess);
      CloseHandle(m_job);
    }
  }

#else

  async_subprocess::~async_subprocess(void)
  {
    if (m_pid != -1)
    {
      close_stdin();
      close_stdout();
      close_stderr();
      kill();
      for (;;)
      {
        int wait_status = 0;
        int wait_ret_val = waitpid(m_pid, &wait_status, 0);
        if (wait_ret_val != -1 || errno != EINTR) break;
      }
    }
  }

#endif

  void async_subprocess::set_error(int e)
  {
    m_err = e;
  }

  void async_subprocess::add_variable(const std::string& name, const std::string& value)
  {
    m_env.add(name, value);
  }

  bool async_subprocess::remove_variable(const std::string& name)
  {
    return m_env.remove(name);
  }

  const env_vector& async_subprocess::get_variables(void) const
  {
  	return m_env;
  }

#ifdef MSWINDOWS

  bool async_subprocess::spawn(const std::string& path, const arg_vector& argv,
                                        bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    bool result = true;
    // first create the pipes to be used to connect to the child stdin/out/err
    // If no pipes requested, then connect to the parent stdin/out/err
    // for some reason you have to create a pipe handle, then duplicate it
    // This is not well explained in MSDN but seems to work
    PIPE_TYPE parent_stdin = 0;
    if (!connect_stdin)
      parent_stdin = GetStdHandle(STD_INPUT_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&parent_stdin, &tmp, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_in, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    PIPE_TYPE parent_stdout = 0;
    if (!connect_stdout)
      parent_stdout = GetStdHandle(STD_OUTPUT_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&tmp, &parent_stdout, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_out, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    PIPE_TYPE parent_stderr = 0;
    if (!connect_stderr)
      parent_stderr = GetStdHandle(STD_ERROR_HANDLE);
    else
    {
      PIPE_TYPE tmp = 0;
      SECURITY_ATTRIBUTES inherit_handles = {sizeof(SECURITY_ATTRIBUTES), 0, TRUE};
      CreatePipe(&tmp, &parent_stderr, &inherit_handles, 0);
      DuplicateHandle(GetCurrentProcess(), tmp, GetCurrentProcess(), &m_child_err, 0, FALSE, DUPLICATE_CLOSE_SOURCE | DUPLICATE_SAME_ACCESS);
    }

    // Now create the subprocess
    // The horrible trick of creating a console window and hiding it seems to be required for the pipes to work
    // Note that the child will inherit a copy of the pipe handles
    STARTUPINFOA startup = {sizeof(STARTUPINFO),0,0,0,0,0,0,0,0,0,0,
                            STARTF_USESTDHANDLES|STARTF_USESHOWWINDOW,SW_HIDE,0,0,
                            parent_stdin,parent_stdout,parent_stderr};
    bool created = CreateProcessA(path.c_str(),(char*)argv.image().c_str(),0,0,TRUE,CREATE_SUSPENDED,m_env.envp(),0,&startup,&m_pid) != 0;
    // close the parent copy of the pipe handles so that the pipes will be closed when the child releases them
    if (connect_stdin) CloseHandle(parent_stdin);
    if (connect_stdout) CloseHandle(parent_stdout);
    if (connect_stderr) CloseHandle(parent_stderr);
    if (!created)
    {
      set_error(GetLastError());
      close_stdin();
      close_stdout();
      close_stderr();
      result = false;
    }
    else
    {
      m_job = CreateJobObject(NULL, NULL);
      AssignProcessToJobObject(m_job, m_pid.hProcess);
      ResumeThread(m_pid.hThread);
    }
    return result;
  }

#else

  bool async_subprocess::spawn(const std::string& path, const arg_vector& argv,
                               bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    bool result = true;
    // first create the pipes to be used to connect to the child stdin/out/err

    int stdin_pipe [2] = {-1, -1};
    if (connect_stdin)
      if (::pipe(stdin_pipe) != 0)
        set_error(errno);

    int stdout_pipe [2] = {-1, -1};
    if (connect_stdout)
      if (::pipe(stdout_pipe) != 0)
        set_error(errno);

    int stderr_pipe [2] = {-1, -1};
    if (connect_stderr)
      if (::pipe(stderr_pipe) != 0)
        set_error(errno);

    // now create the subprocess
    // In Unix, this is done by forking (creating two copies of the parent), then overwriting the child copy using exec
    m_pid = ::fork();
    switch(m_pid)
    {
    case -1:   // failed to fork
      set_error(errno);
      if (connect_stdin)
      {
        ::close(stdin_pipe[0]);
        ::close(stdin_pipe[1]);
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[0]);
        ::close(stdout_pipe[1]);
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[0]);
        ::close(stderr_pipe[1]);
      }
      result = false;
      break;
    case 0:  // in child;
    {
      // for each pipe, close the end of the duplicated pipe that is being used by the parent
      // and connect the child's end of the pipe to the appropriate standard I/O device
      if (connect_stdin)
      {
        ::close(stdin_pipe[1]);
        ::dup2(stdin_pipe[0],STDIN_FILENO);
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[0]);
        ::dup2(stdout_pipe[1],STDOUT_FILENO);
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[0]);
        ::dup2(stderr_pipe[1],STDERR_FILENO);
      }
      ::execve(path.c_str(), argv.argv(), m_env.envp());
      // will only ever get here if the exec() failed completely - *must* now exit the child process
      // by using errno, the parent has some chance of diagnosing the cause of the problem
      ::exit(errno);
    }
    break;
    default:  // in parent
    {
      // for each pipe, close the end of the duplicated pipe that is being used by the child
      // and connect the parent's end of the pipe to the class members so that they are visible to the parent() callback
      if (connect_stdin)
      {
        ::close(stdin_pipe[0]);
        m_child_in = stdin_pipe[1];
        if (fcntl(m_child_in, F_SETFL, O_NONBLOCK) == -1)
        {
          set_error(errno);
          result = false;
        }
      }
      if (connect_stdout)
      {
        ::close(stdout_pipe[1]);
        m_child_out = stdout_pipe[0];
        if (fcntl(m_child_out, F_SETFL, O_NONBLOCK) == -1)
        {
          set_error(errno);
          result = false;
        }
      }
      if (connect_stderr)
      {
        ::close(stderr_pipe[1]);
        m_child_err = stderr_pipe[0];
        if (fcntl(m_child_err, F_SETFL, O_NONBLOCK) == -1)
        {
          set_error(errno);
          result = false;
        }
      }
    }
    break;
    }
    return result;
  }

#endif

  bool async_subprocess::spawn(const std::string& command_line,
                               bool connect_stdin, bool connect_stdout, bool connect_stderr)
  {
    arg_vector arguments = command_line;
    if (arguments.size() == 0) return false;
    std::string path = path_lookup(arguments.argv0());
    if (path.empty()) return false;
    return spawn(path, arguments, connect_stdin, connect_stdout, connect_stderr);
  }

  bool async_subprocess::callback(void)
  {
    return true;
  }

#ifdef MSWINDOWS

  bool async_subprocess::tick(void)
  {
    bool result = true;
    if (!callback())
      kill();
    DWORD exit_status = 0;
    if (!GetExitCodeProcess(m_pid.hProcess, &exit_status))
    {
      set_error(GetLastError());
      result = false;
    }
    else if (exit_status != STILL_ACTIVE)
    {
      CloseHandle(m_pid.hThread);
      CloseHandle(m_pid.hProcess);
      CloseHandle(m_job);
      m_pid.hProcess = 0;
      result = false;
    }
    m_status = (int)exit_status;
    return result;
  }

#else

  bool async_subprocess::tick(void)
  {
    bool result = true;
    if (!callback())
      kill();
    int wait_status = 0;
    int wait_ret_val = waitpid(m_pid, &wait_status, WNOHANG);
    if (wait_ret_val == -1 && errno != EINTR)
    {
      set_error(errno);
      result = false;
    }
    else if (wait_ret_val != 0)
    {
      // the only states that indicate a terminated child are WIFSIGNALLED and WIFEXITED
      if (WIFSIGNALED(wait_status))
      {
        // set_error(errno);
        m_status = WTERMSIG(wait_status);
        result = false;
      }
      else if (WIFEXITED(wait_status))
      {
        // child has exited
        m_status = WEXITSTATUS(wait_status);
        result = false;
      }
    }
    if (!result)
      m_pid = -1;
    return result;
  }

#endif

#ifdef MSWINDOWS

  bool async_subprocess::kill(void)
  {
    if (!m_pid.hProcess) return false;
    close_stdin();
    close_stdout();
    close_stderr();
    if (!TerminateJobObject(m_job, (UINT)-1))
    {
      set_error(GetLastError());
//      return false;
    }
	// we also terminate the pid (not relying on TerminateJobObject)
	if (!TerminateProcess(m_pid.hProcess, (UINT)-1))
	{
		set_error(GetLastError());
		return false;
	}
    return true;
  }

#else

  bool async_subprocess::kill(void)
  {
    if (m_pid == -1) return false;
    close_stdin();
    close_stdout();
    close_stderr();
    if (::kill(m_pid, SIGINT) == -1)
    {
      set_error(errno);
      return false;
    }
    return true;
  }

#endif

#ifdef MSWINDOWS

  int async_subprocess::write_stdin (std::string& buffer)
  {
    if (m_child_in == 0) return -1;
    // there doesn't seem to be a way of doing non-blocking writes under Windoze
    DWORD bytes = 0;
    if (!WriteFile(m_child_in, buffer.c_str(), (DWORD)buffer.size(), &bytes, 0))
    {
      set_error(GetLastError());
      close_stdin();
      return -1;
    }
    // now discard that part of the buffer that was written
    if (bytes > 0)
      buffer.erase(0, bytes);
    return (int)bytes;
  }

#else

  int async_subprocess::write_stdin (std::string& buffer)
  {
    if (m_child_in == -1) return -1;
    // relies on the pipe being non-blocking
    // This does block under Windoze
    int bytes = write(m_child_in, buffer.c_str(), buffer.size());
    if (bytes == -1 && errno == EAGAIN)
    {
      // not ready
      return 0;
    }
    if (bytes == -1)
    {
      // error on write - close the pipe and give up
      set_error(errno);
      close_stdin();
      return -1;
    }
    // successful write
    // now discard that part of the buffer that was written
    if (bytes > 0)
      buffer.erase(0, bytes);
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  int async_subprocess::read_stdout (std::string& buffer)
  {
    if (m_child_out == 0) return -1;
    // peek at the buffer to see how much data there is in the first place
    DWORD buffer_size = 0;
    if (!PeekNamedPipe(m_child_out, 0, 0, 0, &buffer_size, 0))
    {
      if (GetLastError() != ERROR_BROKEN_PIPE)
        set_error(GetLastError());
      close_stdout();
      return -1;
    }
    if (buffer_size == 0) return 0;
    DWORD bytes = 0;
    char* tmp = new char[buffer_size];
    if (!ReadFile(m_child_out, tmp, buffer_size, &bytes, 0))
    {
      set_error(GetLastError());
      close_stdout();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stdout();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return (int)bytes;
  }

#else

  int async_subprocess::read_stdout (std::string& buffer)
  {
    if (m_child_out == -1) return -1;
    // rely on the pipe being non-blocking
    int buffer_size = 256;
    char* tmp = new char[buffer_size];
    int bytes = read(m_child_out, tmp, buffer_size);
    if (bytes == -1 && errno == EAGAIN)
    {
      // not ready
      delete[] tmp;
      return 0;
    }
    if (bytes == -1)
    {
      // error
      set_error(errno);
      close_stdout();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stdout();
      delete[] tmp;
      return -1;
    }
    // successful read
    buffer.append(tmp, bytes);
    delete[] tmp;
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  int async_subprocess::read_stderr (std::string& buffer)
  {
    if (m_child_err == 0) return -1;
    // peek at the buffer to see how much data there is in the first place
    DWORD buffer_size = 0;
    if (!PeekNamedPipe(m_child_err, 0, 0, 0, &buffer_size, 0))
    {
      if (GetLastError() != ERROR_BROKEN_PIPE)
        set_error(GetLastError());
      close_stderr();
      return -1;
    }
    if (buffer_size == 0) return 0;
    DWORD bytes = 0;
    char* tmp = new char[buffer_size];
    if (!ReadFile(m_child_err, tmp, buffer_size, &bytes, 0))
    {
      set_error(GetLastError());
      close_stderr();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stderr();
      delete[] tmp;
      return -1;
    }
    buffer.append(tmp, bytes);
    delete[] tmp;
    return (int)bytes;
  }

#else

  int async_subprocess::read_stderr (std::string& buffer)
  {
    if (m_child_err == -1) return -1;
    // rely on the pipe being non-blocking
    int buffer_size = 256;
    char* tmp = new char[buffer_size];
    int bytes = read(m_child_err, tmp, buffer_size);
    if (bytes == -1 && errno == EAGAIN)
    {
      // not ready
      delete[] tmp;
      return 0;
    }
    if (bytes == -1)
    {
      // error
      set_error(errno);
      close_stderr();
      delete[] tmp;
      return -1;
    }
    if (bytes == 0)
    {
      // EOF
      close_stderr();
      delete[] tmp;
      return -1;
    }
    // successful read
    buffer.append(tmp, bytes);
    delete[] tmp;
    return bytes;
  }

#endif

#ifdef MSWINDOWS

  void async_subprocess::close_stdin (void)
  {
    if (m_child_in)
    {
      CloseHandle(m_child_in);
      m_child_in = 0;
    }
  }

#else

  void async_subprocess::close_stdin (void)
  {
    if (m_child_in != -1)
    {
      ::close(m_child_in);
      m_child_in = -1;
    }
  }

#endif

#ifdef MSWINDOWS

  void async_subprocess::close_stdout (void)
  {
    if (m_child_out)
    {
      CloseHandle(m_child_out);
      m_child_out = 0;
    }
  }

#else

  void async_subprocess::close_stdout (void)
  {
    if (m_child_out != -1)
    {
      ::close(m_child_out);
      m_child_out = -1;
    }
  }

#endif

#ifdef MSWINDOWS

  void async_subprocess::close_stderr (void)
  {
    if (m_child_err)
    {
      CloseHandle(m_child_err);
      m_child_err = 0;
    }
  }

#else

  void async_subprocess::close_stderr (void)
  {
    if (m_child_err != -1)
    {
      ::close(m_child_err);
      m_child_err = -1;
    }
  }

#endif

  bool async_subprocess::error(void) const
  {
    return m_err != 0;
  }

  int async_subprocess::error_number(void) const
  {
    return m_err;
  }

#ifdef MSWINDOWS

  std::string async_subprocess::error_text(void) const
  {
    if (!error()) return std::string();
    char* message;
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                  0,
                  m_err,
                  MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                  (LPTSTR)&message,
                  0,0);
    std::string result = message;
    LocalFree(message);
    // the error message is for some perverse reason newline terminated - remove this
    if (result[result.size()-1] == '\n')
      result.erase(result.end()-1);
    if (result[result.size()-1] == '\r')
      result.erase(result.end()-1);
    return result;
  }

#else

  std::string async_subprocess::error_text(void) const
  {
    if (!error()) return std::string();
    char* text = strerror(m_err);
    if (text) return std::string(text);
    return "error number " + dformat("%d",m_err);
  }

#endif

  int async_subprocess::exit_status(void) const
  {
    return m_status;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
