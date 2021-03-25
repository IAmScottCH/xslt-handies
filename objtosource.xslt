<?xml version="1.0"?>
<!--
  Turn an OPN repo object's full XML into a _sys_sourcemetadata element
-->
<xsl:transform version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:template match="/">
<_sys_sourcemetadata><xsl:text>&#xa;</xsl:text>
<xsl:apply-templates/><xsl:text>&#xa;</xsl:text>
</_sys_sourcemetadata>
</xsl:template>

<xsl:template match="//object/*/*[not(starts-with(name(),'_s_'))]">
	<xsl:choose>
		<xsl:when test="substring(name(),string-length(name())-1)='-0'">
			<xsl:variable name="newname" select="substring(name(),1,string-length(name())-2)" />
			<xsl:element name="{$newname}">
			<xsl:copy-of select="@*" /><xsl:text>&#xa;</xsl:text>
<xsl:copy-of select="./*" /><xsl:text>&#xa;</xsl:text>
			</xsl:element><xsl:text>&#xa;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
<xsl:copy-of select="." /><xsl:text>&#xa;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- BEGIN disable implicit templates -->
<!-- put this at the end of an XSLT to disable implicit templates -->
<xsl:template match="@*|text()">
</xsl:template>
<!-- END disable implicit templates -->

</xsl:transform>