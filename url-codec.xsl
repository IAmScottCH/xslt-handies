<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- ISO-8859-1 based URL-encoding demo
       Written by Mike J. Brown, mike@skew.org.
       Updated 2015-10-24 (to update the license).

       License: CC0 <https://creativecommons.org/publicdomain/zero/1.0/deed.en>

       Also see http://skew.org/xml/misc/URI-i18n/ for a discussion of
       non-ASCII characters in URIs.
  -->


  <xsl:output method="xml" />

  <xsl:param name="url" select="'urn:check%20out%20my%20r%E9sum%E9'"/>
  <!-- The string to URL-encode.
       Note: By "iso-string" we mean a Unicode string where all
       the characters happen to fall in the ASCII and ISO-8859-1
       ranges (32-126 and 160-255) -->
  <xsl:param name="iso-string" select="'&#161;Hola, C&#233;sar!&#038; Brutus'"/>


  <xsl:template match="/">

    <result>
    	<url>
    	<xsl:value-of select="$url" />
    	</url>
    	<decoded>
    <xsl:call-template name="url-decode">
      <xsl:with-param name="encoded" select="$url"/>
    </xsl:call-template>

    	</decoded>
      <string>
        <xsl:value-of select="$iso-string"/>
      </string>
      <hex>
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="$iso-string"/>
        </xsl:call-template>
      </hex>
    </result>

  </xsl:template>

  <!-- some variables used in translation -->
  <xsl:variable name="hex" select="'0123456789ABCDEF'"/>
  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
  <!-- Characters we'll support.
       We could add control chars 0-31 and 127-159, but we won't. -->
  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>

	<!-- BEGIN UTILITY url-encode TEMPLATE -->
  <xsl:template name="url-encode">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="codepoint">
            <xsl:choose>
              <xsl:when test="contains($ascii,$first-char)">
                <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
              </xsl:when>
              <xsl:when test="contains($latin1,$first-char)">
                <xsl:value-of select="string-length(substring-before($latin1,$first-char)) + 160"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
                <xsl:text>63</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>
	<!-- END UTILITY url-encode TEMPLATE -->


	<!-- BEGIN UTILITY url-decode TEMPLATE -->
  <xsl:template name="url-decode">
    <xsl:param name="encoded"/>
    <xsl:choose>
      <xsl:when test="contains($encoded,'%')">
        <xsl:value-of select="substring-before($encoded,'%')"/>
        <xsl:variable name="hexpair" select="translate(substring(substring-after($encoded,'%'),1,2),'abcdef','ABCDEF')"/>
        <xsl:variable name="decimal" select="(string-length(substring-before($hex,substring($hexpair,1,1))))*16 + string-length(substring-before($hex,substring($hexpair,2,1)))"/>
        <xsl:choose>
          <xsl:when test="$decimal &lt; 127 and $decimal &gt; 31">
            <xsl:value-of select="substring($ascii,$decimal - 31,1)"/>
          </xsl:when>
          <xsl:when test="$decimal &gt; 159">
            <xsl:value-of select="substring($latin1,$decimal - 159,1)"/>
          </xsl:when>
          <xsl:otherwise>?</xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="url-decode">
          <xsl:with-param name="encoded" select="substring(substring-after($encoded,'%'),3)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$encoded"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	<!-- BEGIN UTILITY url-decode TEMPLATE -->

</xsl:stylesheet>
