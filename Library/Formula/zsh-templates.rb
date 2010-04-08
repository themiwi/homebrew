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
    link_tmpl = HOMEBREW_PREFIX+'share/zsh/templates'
    init = share+'zsh/templates/Library/init/zsh'

    inreplace 'etc/zshenv', '#   ZDOT="/Library/init/zsh" ; export ZDOT',
      "ZDOT=\"#{link_tmpl}/Library/init/zsh\" ; export ZDOT"

    inreplace 'Library/init/zsh/zshrc.d/003_homebrew_env.zsh',
      "HOMEBREW_PREFIX", HOMEBREW_PREFIX

    (share+'zsh/templates').install ['Library', 'Applications', 'etc']
    doc.install ['TODO.txt', 'READ_THIS_FIRST.txt', 'LICENSE.GPL']

    # put man pages where they belong
    (init+'man').rename man
    # put html-man pages where they belong and fix names
    (man+'html').rename(doc+'html')
    Dir[doc+'html/*.html'].each {|f| FileUtils.mv f, f.sub(/(\.html)/, '.7\1') }

    # disable Fink and MacPorts setup scripts
    ['001_fink_env.zsh', '002_macports.zsh'].each do |f|
      oldname = init+'zshrc.d'+f
      newname = oldname.to_s+'.disabled'
      oldname.rename newname
    end

    # Create links for etc/zsh/{zshrc,zshenv}.
    # Do not use the files in the keg here, such that the links become invalid
    # when zsh-templates is unlinked and the files are no longer used.
    for f in ['zshenv', 'zshrc'] do
      linkname = etc+'zsh'+f
      tgtname = link_tmpl+'etc'+f
      if linkname.exist?
        if not linkname.symlink? or not (linkname.readlink.realpath <=> tgtname.realpath)
          fbak = linkname.to_s() + Time.now.strftime('-homebrew-%Y-%m-%d-%H-%M-%S')
          ohai "Backing up #{linkname} to #{fback}"
          linkname.rename fbak
        end
      end
      linkname.extend ObserverPathnameExtension
      linkname.make_relative_symlink tgtname
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
