<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<!--
  This file contains a split utility.  It also contains a sample usage.
  You can test drive it wth xsltproc against any XML file.
-->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
xmlns:oai_qdc="http://www.example.com/oai_qdc/"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cuir="http://www.clemson.edu/cuir/1.0/"
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:cu-gn="http://www.clemson.edu/cu-gn/1.0/"
>
<xsl:output omit-xml-declaration="yes" method="text" indent="yes" />

<xsl:variable name="lowerchars" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="upperchars" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="/">
<xsl:variable name="targetvalue">
<xsl:call-template name="split-string">
	<xsl:with-param name="subjectstring">this_is_a_test</xsl:with-param>
	<xsl:with-param name="delimiter">_</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="split-string">
	<xsl:with-param name="subjectstring">_this_is_a_second_test</xsl:with-param>
	<xsl:with-param name="delimiter">_</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="split-string">
	<xsl:with-param name="subjectstring">thisisathirdtest</xsl:with-param>
	<xsl:with-param name="delimiter">_</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="split-string">
	<xsl:with-param name="subjectstring">this_is_a_fourth_test_</xsl:with-param>
	<xsl:with-param name="delimiter">_</xsl:with-param>
</xsl:call-template>
</xsl:variable>
Captured Output:
<xsl:value-of select="$targetvalue" />
</xsl:template>

<xsl:template name="emitstring">
	<xsl:param name="thestring"></xsl:param>
	<xsl:value-of select="$thestring"/><xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- BEGIN split string template -->
<!-- Splits the subjectstring on the delimiter and calls a template called "emitstring"  -->
<!-- on each part.  the emitstring template must accept one parameter called "thestring" -->
<xsl:template name="split-string">
	<xsl:param name="subjectstring"></xsl:param>
	<xsl:param name="delimiter"></xsl:param>
	<xsl:if test="$subjectstring != '' and $delimiter != ''">
		<xsl:variable name="head" select="substring-before($subjectstring,$delimiter)" />
		<xsl:variable name="tail" select="substring-after($subjectstring,$delimiter)" />
		<xsl:if test="$head = '' and $tail = ''">
			<xsl:call-template name="emitstring">
				<xsl:with-param name="thestring"><xsl:value-of select="$subjectstring" /></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$head != ''">
			<xsl:call-template name="emitstring">
				<xsl:with-param name="thestring"><xsl:value-of select="$head" /></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains($tail,$delimiter)">
				<xsl:call-template name="split-string">
					<xsl:with-param name="subjectstring" select="$tail" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$tail != ''">
				<xsl:call-template name="emitstring">
					<xsl:with-param name="thestring"><xsl:value-of select="$tail" /></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>
<!-- END split string template -->

<!-- BEGIN disable implicit templates -->
<!-- put this at the end of an XSLT to disable implicit templates -->
<xsl:template match="@*|text()">
</xsl:template>
<!-- BEGIN disable implicit templates -->

</xsl:stylesheet>
