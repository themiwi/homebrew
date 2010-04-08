require 'formula'

class Xmlto <Formula
  url 'https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.23.tar.bz2'
  homepage 'http://cyberelk.net/tim/software/xmlto'
  md5 '3001d6bb2bbc2c8f6c2301f05120f074'

  depends_on 'getopt'
  depends_on 'docbook-xml'

  def install
    ENV['XML_CATALOG_FILES'] = etc+'xml/catalog'
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{prefix}/share/man"
    system "make install"
  end
end
