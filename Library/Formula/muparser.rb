require 'formula'

class Muparser <Formula
  url 'http://downloads.sourceforge.net/project/muparser/muparser/Version%201.34/muparser_v134.tar.gz'
  homepage 'http://muparser.sourceforge.net/'
  md5 '0c4f4bf86aa2a5a737adc0e08cb77737'
  version '1.34'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-shared=yes"
    system "make lib install"
  end
end
