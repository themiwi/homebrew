require 'formula'

class Stgit <Formula
  url 'http://download.gna.org/stgit/stgit-0.15.tar.gz'
  homepage 'http://www.procode.org/stgit'
  md5 'a4721b2a5f529cf5450109f9fcb4db19'

  depends_on "asciidoc"
  depends_on "xmlto"

  def install
    ENV['XML_CATALOG_FILES'] = etc+'xml'+'catalog'
    FileUtils.rm('setup.cfg')
    # back up users ~/.pydistutils.cfg
    distcfg = Pathname.new('~/.pydistutils.cfg').expand_path()
    distcfgbak = Pathname.new(distcfg.to_s() +
                              Time.now.strftime('-homebrew-%Y-%m-%d-%H-%M-%S'))
    if distcfg.exist?
      ohai "Backing up #{distcfg} to #{distcfgbak}"
      distcfg.rename(distcfgbak)
    end
    begin
      system "make", "prefix=#{prefix}", "all", "doc"
      system "make", "prefix=#{prefix}", "install", "install-doc"
    ensure
      # always reinstate the users ~/.pydistutils.cfg, even on error
      if distcfgbak.exist?
        ohai "Recreating #{distcfg} from backup #{distcfgbak}"
        distcfgbak.rename(distcfg)
      end
    end
  end
end
