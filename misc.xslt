<!-- this contains a bunch of misc. XSLT utility templates -->

<!-- BEGIN tolower or to upper -->
<!-- You don't really need a template for this, just a couple of variables -->
<xsl:variable name="lowerchars" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="upperchars" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:value-of select="translate('AllToUpper',$lowerchars,$upperchars)" />
<xsl:value-of select="translate('AllToLower',$upperchars,$lowerchars)" />
<!-- END tolower or to upper -->

<!-- BEGIN PHP escape -->
<!-- escapes single quotes and back slashes in a string so you can emit the
     result as the content of a single quoted string in PHP code.  uses the string replace
     template below as well.
-->
<xsl:variable name="squote">'</xsl:variable>
<xsl:variable name="esquote">\'</xsl:variable>
<xsl:variable name="bslash">\</xsl:variable>
<xsl:variable name="dbslash">\\</xsl:variable>

<xsl:template name="phpescape-sq-string">
<xsl:param name="unescapedtext" />
<xsl:variable name="escaped1text">
	<xsl:call-template name="string-replace-all">
		<xsl:with-param name="text" select="$unescapedtext" />
		<xsl:with-param name="replace" select="$bslash" />
		<xsl:with-param name="by" select="$dbslash" />
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="escapedtext">
	<xsl:call-template name="string-replace-all">
		<xsl:with-param name="text" select="$escaped1text" />
		<xsl:with-param name="replace" select="$squote" />
		<xsl:with-param name="by" select="$esquote" />
	</xsl:call-template>
</xsl:variable>
<xsl:value-of select="$escapedtext" />
</xsl:template>
<!-- END PHP escape -->

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

<!-- BEGIN find elements by basename and index -->
<xsl:template name="findbyindex">
	<xsl:param name="idxn" select="0" />
	<xsl:param name="basename"></xsl:param>
	<xsl:variable name="tgtname" select="concat($basename,$idxn)" />
	Seeking <xsl:value-of select="$tgtname"/>:
	<xsl:choose>
		<xsl:when test="//document/*[name()=$tgtname]">
			<xsl:for-each select="//document/*[name()=$tgtname]">
				<xsl:variable name="nn" select="local-name(.)"></xsl:variable>
				<xsl:value-of select="$nn"/>
				<xsl:call-template name="findbyindex">
					<xsl:with-param name="idxn" select="$idxn + 1"/>
					<xsl:with-param name="basename" select="$basename"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
END SEEK
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- END find elements by basename and index -->

<!-- BEGIN disable implicit templates -->
<!-- put this at the end of an XSLT to disable implicit templates -->
<xsl:template match="@*|text()">
</xsl:template>
<!-- BEGIN disable implicit templates -->
