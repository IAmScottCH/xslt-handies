<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<!--
  This file contains two utilities, substring-before-last and substring-after-last which
  extract a substring before the last occurance of second string or after the last occurance
  of a second string, respectively.  It also contains a sample usage of  substring-before-last.
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
<xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

<xsl:variable name="lowerchars" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="upperchars" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="/">
<xsl:variable name="targetvalue">
<xsl:call-template name="substring-before-last">
	<xsl:with-param name="subjectstring">this_is_atest</xsl:with-param>
	<xsl:with-param name="needlestring">_</xsl:with-param>
</xsl:call-template>
</xsl:variable>

Before: <xsl:value-of select="$targetvalue" />

<xsl:variable name="targetvalue2">
<xsl:call-template name="substring-after-last">
	<xsl:with-param name="subjectstring">this_is_atest</xsl:with-param>
	<xsl:with-param name="needlestring">_</xsl:with-param>
</xsl:call-template>
</xsl:variable>

After: <xsl:value-of select="$targetvalue2" />
</xsl:template>

<!--  BEGIN utility template substring-before-last -->
<!-- credit for the substring-before-last template to "Tomalak" on StackOverflow here: -->
<!-- http://stackoverflow.com/questions/1119449/removing-the-last-characters-in-an-xslt-string/1119666#1119666 -->
<xsl:template name="substring-before-last">
	<xsl:param name="subjectstring"></xsl:param>
	<xsl:param name="needlestring"></xsl:param>
	<xsl:if test="$subjectstring != '' and $needlestring != ''">
		<xsl:variable name="head" select="substring-before($subjectstring,$needlestring)" />
		<xsl:variable name="tail" select="substring-after($subjectstring,$needlestring)" />
		<xsl:value-of select="$head" />
		<xsl:if test="contains($tail,$needlestring)">
			<xsl:value-of select="$needlestring" />
			<xsl:call-template name="substring-before-last">
				<xsl:with-param name="subjectstring" select="$tail" />
				<xsl:with-param name="needlestring" select="$needlestring" />
			</xsl:call-template>
		</xsl:if>
	</xsl:if>
</xsl:template>
<!--  END utility template substring-before-last -->

<!--  BEGIN utility template substring-after-last -->
<xsl:template name="substring-after-last">
	<xsl:param name="subjectstring"></xsl:param>
	<xsl:param name="needlestring"></xsl:param>
	<xsl:if test="$subjectstring != '' and $needlestring != ''">
		<xsl:variable name="head" select="substring-before($subjectstring,$needlestring)" />
		<xsl:variable name="tail" select="substring-after($subjectstring,$needlestring)" />
		<xsl:if test="contains($tail,$needlestring)">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="subjectstring" select="$tail" />
				<xsl:with-param name="needlestring" select="$needlestring" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(contains($tail,$needlestring))">
			<xsl:value-of select="$tail" />
		</xsl:if>
	</xsl:if>
</xsl:template>
<!--  END utility template substring-after-last -->


</xsl:stylesheet>
