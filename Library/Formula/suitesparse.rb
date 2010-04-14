require 'formula'

class Metis <Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-4.0.tar.gz'
  md5 '0aa546419ff7ef50bd86ce1ec7f727c7'

  # overrides the the directory where stuff gets unpacked, does not yield
  def brew
    validate_variable :name
    validate_variable :version
    HOMEBREW_CACHE.mkpath
    downloaded_tarball = @downloader.fetch
    if downloaded_tarball.kind_of? Pathname
      verify_download_integrity downloaded_tarball
    end
    @downloader.stage
    patch
  end
end

class Suitesparse <Formula
  url 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-3.4.0.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/SuiteSparse'
  md5 'e59dcabc9173b1ba1b3659ae147006b8'

  def patches
    DATA
  end

  def install
    Metis.new.brew

    # rename ChangeLogs, pdfs and BibTeX databases
    ['AMD', 'CAMD', 'CCOLAMD', 'COLAMD', 'BTF', 'KLU', 'LDL', 'UMFPACK',
      'CHOLMOD', 'CSparse', 'CXSparse',].each do |mod|
      olog = mod+"/Doc/ChangeLog"
      nlog = mod+"/Doc/#{mod}_ChangeLog"
      FileUtils.mv olog, nlog
    end
    ['CHOLMOD', 'UMFPACK'].each do |mod|
      ['.pdf', '.bib'].each do |ext|
        old = mod+"/Doc/UserGuide"+ext
        new = mod+"/Doc/#{mod}_UserGuide"+ext
        FileUtils.mv old, new
      end
    end
    FileUtils.mv 'UMFPACK/Doc/QuickStart.pdf', 'UMFPACK/Doc/UMFPACK_QuickStart.pdf'

    # convert metis manual to pdf
    system '/System/Library/Printers/Libraries/convert',
               '-f', 'metis-4.0/Doc/manual.ps',
               '-o', 'metis-4.0/Doc/metis_manual.pdf',
               '-j', 'application/pdf'

    # build metis
    system "make -C metis-4.0"
    # build suitesparse (need two tries...)
    system "make || make"

    # install libraries
    lib.install Dir['*/Lib/lib*.a', 'metis-4.0/libmetis.a']
    # install headers (skip CSparse)
    (include+'suitesparse').install Dir['UFconfig/*.h',
      '{{,C}AMD,BTF,{C,}COLAMD,KLU,LDL,CXSparse,CHOLMOD,UMFPACK}/Include/*.h']
    (include+'metis').install Dir['metis-4.0/Lib/*.h']
    # install docs
    doc.install Dir['*/Doc/*_ChangeLog', '*/Doc/*.{pdf,bib}']
  end
end
# Below patch disables the Linux options and enables the ones for Mac
__END__
diff --git a/UFconfig/UFconfig.mk b/UFconfig/UFconfig.mk
index bda4c7b..d23ba9e 100644
--- a/UFconfig/UFconfig.mk
+++ b/UFconfig/UFconfig.mk
@@ -220,7 +220,7 @@ RTLIB =
 
 # Using default compilers:
 # CC = gcc
-CFLAGS = -O3 -fexceptions
+# CFLAGS = -O3 -fexceptions
 
 # alternatives:
 # CFLAGS = -g -fexceptions \
@@ -296,11 +296,11 @@ CFLAGS = -O3 -fexceptions
 # Macintosh
 #------------------------------------------------------------------------------
 
-# CC = gcc
-# CFLAGS = -O3 -fno-common -no-cpp-precomp -fexceptions
-# LIB = -lstdc++
-# BLAS = -framework Accelerate
-# LAPACK = -framework Accelerate
+CC = gcc
+CFLAGS = -O3 -fno-common -no-cpp-precomp -fexceptions -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE
+LIB = -lstdc++
+BLAS = -framework Accelerate
+LAPACK = -framework Accelerate
 
 #------------------------------------------------------------------------------
 # IBM RS 6000

