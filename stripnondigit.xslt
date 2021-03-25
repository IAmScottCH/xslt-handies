<?xml version="1.0"?>
<xsl:transform version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<xsl:template match="//document">
	<xsl:variable name="teststring">864/555-5555</xsl:variable>
	<xsl:variable name="resultstring">
	<xsl:call-template name="strip_non_digit">
		<xsl:with-param name="instring"><xsl:value-of select="$teststring"/></xsl:with-param>
	</xsl:call-template>
	</xsl:variable>
Test string: <xsl:value-of select="$teststring"/> became <xsl:value-of select="$resultstring"/>.
</xsl:template>

<xsl:template name="strip_non_digit">
	<xsl:param name="instring"/>
	<xsl:param name="startpos">0</xsl:param>
	<xsl:if test="contains('0123456789',substring($instring,$startpos,1))">
		<xsl:value-of select="substring($instring,$startpos,1)"/>
	</xsl:if>
	<xsl:if test="$startpos &lt; string-length($instring)">
		<xsl:call-template name="strip_non_digit">
			<xsl:with-param name="instring" select="$instring"/>
			<xsl:with-param name="startpos" select="$startpos+1"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>                

</xsl:transform>
