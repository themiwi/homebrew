require 'formula'

class DocbookXmlDdt45 <Formula
  url 'http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip'
  md5 '03083e288e87a7e829e437358da7ef9e'
end

class DocbookXmlDdt44 <Formula
  url 'http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip'
  md5 'cbb04e9a700955d88c50962ef22c1634'
end

class DocbookXmlDdt43 <Formula
  url 'http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip'
  md5 'ab200202b9e136a144db1e0864c45074'
end

class DocbookXmlDdt42 <Formula
  url 'http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip'
  md5 '73fe50dfe74ca631c1602f558ed8961f'
end

class DocbookXmlDdt412 <Formula
  url 'http://www.docbook.org/xml/4.1.2/docbkx412.zip'
  md5 '900d7609fb7e6d78901b357e4acfbc17'
end

class DocbookXsl <Formula
  url 'http://downloads.sourceforge.net/project/docbook/docbook-xsl/1.75.2/docbook-xsl-1.75.2.tar.bz2'
  md5 '0c76a58a8e6cb5ab49f819e79917308f'
end

class DocbookXslDoc <Formula
  url 'http://downloads.sourceforge.net/project/docbook/docbook-xsl-doc/1.75.2/docbook-xsl-doc-1.75.2.tar.bz2'
  md5 '0a59c4c1796683fca32881c221df0b16'
end

class DocbookXml <Formula
  url 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
  homepage 'http://www.docbook.org'
  md5 '2411c19ed4fb141f3fa3d389fae40736'

  def dbx; share+'xml'+'dtd'+'docbookx' end

  def xsl; share+'xml'+'xsl'+'docbook-xsl' end

  def catalogs
    [
      ["5.0"  , dbx+"5.0.0"+"catalog.xml"],
      ["4.5"  , dbx+"4.5.0"+"catalog.xml"],
      ["4.4"  , dbx+"4.4.0"+"catalog.xml"],
      ["4.3"  , dbx+"4.3.0"+"catalog.xml"],
      ["4.2"  , dbx+"4.2.0"+"catalog.xml"],
      ["4.1.2", dbx+"4.1.2"+"docbook.cat"],
    ]
  end

  def xml_catalog
    # catalog head
    catalog = <<-EOS
<?xml version='1.0'?>
<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog" prefer="public">
    EOS
    # catalog body (DTD)
    catalogs.each do |v,c|
      if(/4.[23]/.match(v))
        catalog += <<-EOS
  <system
     systemId="http://www.oasis-open.org/docbook/xml/#{v}/docbookx.dtd"
     uri="#{dbx}/#{v}.0/docbookx.dtd"/>
  <system
     systemId="http://docbook.org/xml/#{v}/docbookx.dtd"
     uri="#{dbx}/#{v}.0/docbookx.dtd"/>
        EOS
      end
      catalog += <<-EOS
  <delegatePublic
     publicIdStartString="-//OASIS//DTD DocBook XML V#{v}//EN"
     catalog="#{c}"/>
  <delegateSystem
     systemIdStartString="http://www.oasis-open.org/docbook/xml/#{v}"
     catalog="#{c}"/>
  <delegateSystem
     systemIdStartString="http://docbook.org/xml/#{v}"
     catalog="#{c}"/>

      EOS
    end
    # catalog body (XSL)
    catalog += <<-EOS
  <delegateURI
     uriStartString="http://docbook.sourceforge.net/release/xsl/"
     catalog="file://#{xsl}/catalog.xml"/>
  <delegateSystem
     systemIdStartString="http://docbook.sourceforge.net/release/xsl/"
     catalog="file://#{xsl}/catalog.xml"/>
    EOS
    # catalog foot
    catalog += <<-EOS
</catalog>
    EOS
    return catalog
  end

  def install
    (dbx+'5.0').install Dir['*']

    DocbookXmlDdt412.new.brew { (dbx+'4.1.2').install Dir['*'] }
    DocbookXmlDdt42.new.brew  { (dbx+'4.2.0').install Dir['*'] }
    DocbookXmlDdt43.new.brew  { (dbx+'4.3.0').install Dir['*'] }
    DocbookXmlDdt44.new.brew  { (dbx+'4.4.0').install Dir['*'] }
    DocbookXmlDdt45.new.brew  { (dbx+'4.5.0').install Dir['*'] }
    DocbookXsl.new.brew       { xsl.install Dir['*'] }
    DocbookXslDoc.new.brew    { (share+"doc"+"docbook-xsl").install Dir['doc/*'] }

    # catalog file
    catalog = etc+'xml'+'catalog'
    FileUtils.mkdir_p(etc+'xml')
    catalog.unlink if catalog.exist?
    (etc+'xml'+'catalog').write(xml_catalog)
  end

  def caveats; <<-EOS
This package contains versions 4.1.2, 4.2, 4.3, 4.4, 4.5 and 5.0 of the
DocBook-XML DTD and version 1.75.2 of the  DocBook-XSL style sheets (with
documentation).

Make sure to point XML_CATALOG_FILES to
#{etc}/xml/catalogs.
    EOS
  end
end
