require 'formula'

class ZshTemplates <Formula
  url 'http://zsh-templates-osx.googlecode.com/files/zsh-templates-2.0.4.tgz'
  homepage 'http://code.google.com/p/zsh-templates-osx'
  md5 'c9d1b25e4de0dbd741707c100e07c9b7'

  depends_on 'zsh'

  def patches
    DATA
  end

  def install
    link_tmpl = HOMEBREW_PREFIX+'share' + 'zsh' + 'templates'
    init = share+'zsh'+'templates'+'Library'+'init'+'zsh'

    inreplace 'etc/zshenv', '#   ZDOT="/Library/init/zsh" ; export ZDOT',
      "ZDOT=\"#{link_tmpl}/Library/init/zsh\" ; export ZDOT"

    inreplace 'Library/init/zsh/zshrc.d/003_homebrew_env.zsh',
      "HOMEBREW_PREFIX", HOMEBREW_PREFIX

    (share+'zsh'+'templates').install ['Library', 'Applications', 'etc']
    doc.install ['TODO.txt', 'READ_THIS_FIRST.txt', 'LICENSE.GPL']

    # put man pages where they belong
    (init+'man').rename(man)
    # put html-man pages where they belong and fix names
    (man+'html').rename(doc+'html')
    Dir[doc+'html'+'*.html'].each {|f| FileUtils.mv f, f.sub(/(\.html)/, '.7\1') }

    # disable Fink and MacPorts setup scripts
    ['001_fink_env.zsh', '002_macports.zsh'].each do |f|
      of = init+'zshrc.d'+f
      nf = of.to_s+'.disabled'
      of.rename(nf)
    end

    for f in ['zshenv', 'zshrc'] do
      p = etc+'zsh'+f
      o = link_tmpl+'etc'+f
      if p.exist?
        if not p.symlink? or not (p.readlink.realpath <=> o.realpath)
          fbak = p.to_s() + Time.now.strftime('-homebrew-%Y-%m-%d-%H-%M-%S')
          ohai "Backing up #{p} to #{fback}"
          p.rename fbak
        end
      end
      p.extend ObserverPathnameExtension
      p.make_relative_symlink o
    end
  end
end
__END__
diff --git a/Library/init/zsh/zshrc.d/003_homebrew_env.zsh b/Library/init/zsh/zshrc.d/003_homebrew_env.zsh
new file mode 100644
index 0000000..5949e39
--- /dev/null
+++ b/Library/init/zsh/zshrc.d/003_homebrew_env.zsh
@@ -0,0 +1,13 @@
+# Disable this file by renaming it to homebrew_env.zsh.disabled
+
+if [[ -d "HOMEBREW_PREFIX/bin" ]]; then
+  path=("HOMEBREW_PREFIX/bin" $path)
+fi
+
+if [[ -n "$SWPREFIX" && -d "$SWPREFIX" ]]; then
+  print "Warning: It appears that you have fink installed and" >&2
+  print "HOMEBREW_PREFIX/share/zsh/templates/Library/init/zsh/zshrc.d/001_fink_env.zsh" >&2
+  print "enabled. This is dangerous." >&2
+else
+  SWPREFIX='ALT_SWPREFIX'
+fi
