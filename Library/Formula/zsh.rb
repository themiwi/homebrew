require 'formula'

class Zsh <Formula
  url 'http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.10/zsh-4.3.10.tar.gz'
  homepage 'http://www.zsh.org/'
  md5 '031efc8c8efb9778ffa8afbcd75f0152'

  def install
    html = doc+'html'
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share+'zsh'+'functions'}",
                          "--enable-scriptdir=#{share+'zsh'+'scripts'}",
                          # specify sys-config directory
                          "--enable-etcdir=#{etc+'zsh'}",
                          # HTML doc directory
                          "--htmldir=#{html}"

    # Again, don't version installation directories
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install install.html install.info pdf"

    # Install docs
    doc.install Dir['INSTALL', 'LICENCE', 'META-FAQ', 'README',
                     'StartupFiles/*', 'ChangeLog*', 'Doc/zsh.pdf']
    (html+'index.html').make_symlink(html+'zsh.html')

    # prepare HOMEBREW_PREFIX/etc/zsh directory
    (etc+'zsh').mkpath
    # prepare HOMEBREW_PREFIX/share/zsh directory to reduce number of symlinks
    # when combined with zsh-templates
    (HOMEBREW_PREFIX+'share'+'zsh').mkpath
  end

  def skip_clean? path
    true
  end
end
