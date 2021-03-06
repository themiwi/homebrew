require 'formula'

class Cmake <Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.2.tar.gz'
  md5 '8c967d5264657a798f22ee23976ff0d9'
  homepage 'http://www.cmake.org/'

  def patches
    # CMAKE_OSX_ARCHITECTURES quoting bug. See: http://www.vtk.org/Bug/view.php?id=11244
    # Not needed with CMake 2.8.3 and above.
    [ "http://cmake.org/gitweb?p=cmake.git;a=patch;h=a8ded533",
      "http://cmake.org/gitweb?p=cmake.git;a=patch;h=0790af3b" ]
  end

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
    ENV.j1 # There appear to be parallelism issues.
    system "make"
    system "make install"
  end
end
