<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8" />

  <!-- NOTE!  Because CSV files are not hierarchical, this template   -
    -         just concatenates all the text nodes under the elements -
    -         you specify in the first template's select together.    -
    -         That is, it flattens any hierarchy of subelements into  -
    -         a single string.  Oh, just try it, you'll see what I
    -         mean!                                                   -->

  <xsl:param name="delim" select="','" />
  <xsl:param name="quote" select="'&quot;'" />
  <xsl:param name="break" select="'&#xA;'" />

  <xsl:template match="/">
    <xsl:apply-templates select="document/tocsv" />
  </xsl:template>

  <xsl:template match="tocsv">
    <xsl:apply-templates />
    <xsl:if test="following-sibling::*">
      <xsl:value-of select="$break" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="*">
    <!-- replace normalize-space() with . if you want keep white-space at it is -->
    <xsl:variable name="s1">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text"><xsl:value-of select="normalize-space()"/></xsl:with-param>
        <xsl:with-param name="replace">/</xsl:with-param>
        <xsl:with-param name="by">//</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="s2">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text"><xsl:value-of select="$s1"/></xsl:with-param>
        <xsl:with-param name="replace">&quot;</xsl:with-param>
        <xsl:with-param name="by">/&quot;</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($quote, $s2, $quote)" />
    <xsl:if test="following-sibling::*">
      <xsl:value-of select="$delim" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" />

<!-- BEGIN string replace template -->
<xsl:template name="string-replace-all">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text"
        select="substring-after($text,$replace)" />
        <xsl:with-param name="replace" select="$replace" />
        <xsl:with-param name="by" select="$by" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!-- END string replace template -->
</xsl:stylesheet>