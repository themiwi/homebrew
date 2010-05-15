require 'formula'

class Devtodo <Formula
  url 'http://swapoff.org/files/devtodo/devtodo-0.1.20.tar.gz'
  homepage 'http://swapoff.org/DevTodo'
  md5 '4a6241437cb56f237f850bcd2233c3c4'

  depends_on "readline"

  def install
    # Rename Regex.h to Regex.hh to avoid confusion with regex.h
    FileUtils.mv "util/Regex.h", "util/Regex.hh"
    inreplace ["util/Lexer.h", "util/Makefile.in", "util/Regex.cc"],
      "Regex.h", "Regex.hh"
    # Ensure that GNU Readline gets picked up
    readline = Formula.factory('readline')
    ENV.append 'CPPFLAGS', "-I#{readline.include}"
    ENV.append 'LDFLAGS', "-L#{readline.lib}"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{prefix}/share/man"
    system "make install"
    # Install contrib
    system "install -d -m 755 #{prefix}/share/doc/devtodo/contrib"
    system "install -c -m 644 contrib/* #{prefix}/share/doc/devtodo/contrib"
  end
end
