<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<!--
  Use this to try out xpath statements against an XML doc.
  xsltproc  -param expression 'XPATH_EXPRESSION' tryxpath.xslt XML-FILE-PATH/NAME
-->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dyn="http://exslt.org/dynamic"
xmlns:com="http://exslt.org/common"
      extension-element-prefixes="dyn com"
>

<!--
  the xpath expression
-->
<xsl:param name="x"/>

<xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

<xsl:template match="/">
  <xsl:variable name="astring" select="string('//html/body/h1')" />
  Expression is [<xsl:value-of select="$x"/>]
	<xsl:variable name="xns" select="dyn:evaluate($astring)" />
	which results in <xsl:value-of select="count($xns)" /> nodes
	<xsl:call-template name="shownodes">
		<xsl:with-param name="basenodes" select="$xns" />
	</xsl:call-template>
</xsl:template>

<xsl:template name="shownodes">
	<xsl:param name="basenodes"></xsl:param>
	<xsl:variable name="thenodes" select="com:node-set($basenodes)" />
	<xsl:variable name="nodecount" select="count($thenodes)" />
	There are <xsl:value-of select="$nodecount" /> nodes.
	<xsl:for-each select="$thenodes">
		<xsl:value-of select="." />
	</xsl:for-each>
</xsl:template>

<!-- BEGIN disable implicit templates -->
<!-- put this at the end of an XSLT to disable implicit templates -->
<xsl:template match="@*|text()">
</xsl:template>
<!-- BEGIN disable implicit templates -->

</xsl:stylesheet>
