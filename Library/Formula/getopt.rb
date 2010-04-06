require 'formula'

class Getopt <Formula
  url 'http://software.frodo.looijaard.name/getopt/files/getopt-1.1.4.tar.gz'
  homepage 'http://software.frodo.looijaard.name/getopt'
  md5 '02188ca68da27c4175d6e9f3da732101'

  depends_on 'gettext'

  def patches
    DATA
  end

  def install
    #system "make prefix=%p WITH_GETTEXT=1 LIBCGETOPT=0 LDFLAGS=\"-L%p/lib -lintl\" localedir=%p/share/locale"
    gettext = Formula.factory('gettext')
    inreplace 'getopt.1', '@PREFIX@', prefix
    inreplace 'Makefile', /^CPPFLAGS=/, "CPPFLAGS=-I./gnu -I#{gettext.include} "
    system "make", "prefix=#{prefix}", "WITH_GETTEXT=1", "LIBCGETOPT=0",
      "LDFLAGS=-L#{gettext.lib} -lintl", "mandir=#{prefix}/share/man",
      "getoptdir=#{prefix}/share/doc/getopt", "localedir=#{prefix}/share/locale",
      "install", "install_doc"
  end
end

__END__
diff --git a/Makefile b/Makefile
index f930a28..b32137c 100644
--- a/Makefile
+++ b/Makefile
@@ -3,11 +3,11 @@
 DESTDIR=
 prefix=/usr/local
 bindir=$(prefix)/bin
-mandir=$(prefix)/man
+mandir=$(prefix)/share/man
 man1dir=$(mandir)/man1
 libdir=$(prefix)/lib
 sharedir=$(prefix)/share
-getoptdir=$(libdir)/getopt
+getoptdir=$(sharedir)/getopt
 localedir=$(sharedir)/locale
 
 # Define this to 0 to use the getopt(3) routines in this package.
diff --git a/getopt.1 b/getopt.1
index 874e462..9fe39f4 100644
--- a/getopt.1
+++ b/getopt.1
@@ -402,10 +402,8 @@ if it is called with
 .SH EXAMPLES
 Example scripts for (ba)sh and (t)csh are provided with the
 .BR getopt (1)
-distribution, and are optionally installed in 
-.B /usr/local/lib/getopt 
-or 
-.BR /usr/lib/getopt .
+distribution, and are installed in 
+.B @PREFIX@/share/doc/getopt .
 .SH ENVIRONMENT
 .IP POSIXLY_CORRECT
 This environment variable is examined by the
