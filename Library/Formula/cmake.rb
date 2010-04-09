require 'formula'

class Cmake <Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.1.tar.gz'
  md5 'a92ad653f9ccc1595d16cd9707f49acc'
  homepage 'http://www.cmake.org/'

  def install
    # xmlrpc is a stupid little library, rather than waste our users' time
    # just let cmake use its own copy. God knows why something like cmake
    # needs an xmlrpc library anyway! It is amazing!
    inreplace 'CMakeLists.txt',
              "# Mention to the user what system libraries are being used.",
              "SET(CMAKE_USE_SYSTEM_XMLRPC 0)"

    FileUtils.mkdir "build"
    FileUtils.cd "build"
    system "../bootstrap", "--prefix=#{prefix}",
                           "--system-libs",
                           "--datadir=/share/cmake",
                           "--docdir=/share/doc/cmake",
                           "--mandir=/share/man"
    # Parallel builds and directly calling "make install" interfere badly...
    system "make"
    system "make install"
  end
end
