<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
]>

<!--
  - given two xpaths, pair the firsts of each, the seconds of each, etc.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
                version="1.0">

<xsl:variable name="newline" select="'&#10;'"/>

<xsl:template match="/">
'coordinates'=>array(
<xsl:call-template name="pair-sub-nodes">
		<xsl:with-param name="xpath1" select="//document/pair1/*" />
		<xsl:with-param name="xpath2" select="//document/pair2/*" />
		<xsl:with-param name="prefix">[</xsl:with-param>
		<xsl:with-param name="infix">,</xsl:with-param>
		<xsl:with-param name="suffix">],</xsl:with-param>
</xsl:call-template>
),
</xsl:template>

<xsl:template name="pair-sub-nodes">
	<xsl:param name="xpath1"></xsl:param>
	<xsl:param name="xpath2"></xsl:param>
	<xsl:param name="prefix"></xsl:param>
	<xsl:param name="infix">,</xsl:param>
	<xsl:param name="suffix"></xsl:param>
	<xsl:for-each select="$xpath1">
	  <xsl:variable name="cposn"><xsl:number value="position()" format="1"/></xsl:variable>
	  <xsl:value-of select="$prefix"/><xsl:value-of select="." /><xsl:value-of select="$infix"/><xsl:value-of select="$xpath2[$cposn=position()]"/><xsl:value-of select="$suffix"/>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
