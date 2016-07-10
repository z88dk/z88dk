rem Build tools with Visual Studio solution
if not exist bin mkdir bin
devenv win32\z88dk.sln /Build Release
