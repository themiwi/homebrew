require 'formula'

class Pip <Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-0.7.tar.gz'
  homepage 'http://pip.openplans.org/'
  md5 '8d4b4f7266fe0808569182e6832d74ac'
  version '0.7.0'

  depends_on 'setuptools'

  def script lib_path
    <<-EOS
#!/usr/bin/env python
"""
This is the Homebrew pip wrapper
"""
import sys
sys.path.insert(0, '#{lib_path}')
from pip import main

if __name__ == '__main__':
    main()
    EOS
  end

  def patches
    # better default paths for build, source-cache and log locations
    DATA
  end

  def install
    dest = prefix+"lib/pip"

    # make sure we use the right python (distutils rewrites the shebang)
    # also adds the pip lib path to the PYTHONPATH
    (bin+'pip').write(script(dest))

    # FIXME? If we use /usr/bin/env python in the pip script
    # then should we be hardcoding this version? I dunno.
    python_version = `python -V 2>&1`.match('Python (\d+\.\d+)').captures.at(0)

    dest.install('pip')
    cp 'pip.egg-info/PKG-INFO', "#{dest}/pip-#{version}-py#{python_version}.egg-info"
  end

  def two_line_instructions
    "pip installs packages. Python packages.\n"+
    "Run 'pip help' to see a list of commands."
  end

  def caveats
    # I'm going to add a proper two_line_instructions formula function at some point
    two_line_instructions
  end
end

__END__
diff --git a/pip/locations.py b/pip/locations.py
index bd70d92..e517292 100755
--- a/pip/locations.py
+++ b/pip/locations.py
@@ -4,19 +4,20 @@ import sys
 import os
 from distutils import sysconfig
 
+user_dir = os.path.expanduser('~')
+
 if getattr(sys, 'real_prefix', None):
     ## FIXME: is build/ a good name?
     build_prefix = os.path.join(sys.prefix, 'build')
     src_prefix = os.path.join(sys.prefix, 'src')
 else:
-    ## FIXME: this isn't a very good default
-    build_prefix = os.path.join(os.getcwd(), 'build')
-    src_prefix = os.path.join(os.getcwd(), 'src')
+    build_prefix = user_dir + '/.pip/build'
+    src_prefix = user_dir + '/.pip/sources'
 
 # FIXME doesn't account for venv linked to global site-packages
 
 site_packages = sysconfig.get_python_lib()
-user_dir = os.path.expanduser('~')
+
 if sys.platform == 'win32':
     bin_py = os.path.join(sys.prefix, 'Scripts')
     # buildout uses 'bin' on Windows too?
@@ -30,7 +30,7 @@ else:
     bin_py = os.path.join(sys.prefix, 'bin')
     default_storage_dir = os.path.join(user_dir, '.pip')
     default_config_file = os.path.join(default_storage_dir, 'pip.conf')
-    default_log_file = os.path.join(default_storage_dir, 'pip.log')
+    default_log_file = os.path.expanduser('~/Library/Logs/pip.log')
     # Forcing to use /usr/local/bin for standard Mac OS X framework installs
     if sys.platform[:6] == 'darwin' and sys.prefix[:16] == '/System/Library/':
         bin_py = '/usr/local/bin'
