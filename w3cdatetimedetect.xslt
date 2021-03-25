<?xml version="1.0"?>
<xsl:transform version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://informatik.hu-berlin.de/merge"
                exclude-result-prefixes="m">
<xsl:output method="text"/>

<xsl:template match="//w3cdetect/dtselem">
  <xsl:value-of select="."/>|<xsl:call-template name="IsW3CDateTime"><xsl:with-param name="string" select="." /></xsl:call-template>|
</xsl:template>

<xsl:variable name="w3cdigits">0123456789</xsl:variable>
<xsl:template name="IsW3CDateTime">
  <!-- emits either VALID or INVALID -->
  <xsl:param name="string">EMPTY</xsl:param>
  <!-- state S -->
  <xsl:variable name="result"><xsl:call-template name="isw3cstateS"><xsl:with-param name="string"><xsl:value-of  select="substring($string,1,4)"/></xsl:with-param>
                                 <xsl:with-param name="remainingstring"><xsl:value-of  select="$string"/></xsl:with-param>
                               </xsl:call-template></xsl:variable>
  <xsl:value-of select="$result"/>
</xsl:template>

<xsl:template name="isw3cstateS">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="remainingstring"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)!=4 or string-length(translate($string,$w3cdigits,''))!=0">INVALID</xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="isw3cstateYear1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($remainingstring,5)"/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateYear1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
       <xsl:call-template name="isw3cstateYear2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
    <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateYear2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 3 or substring($string,1,1)!='-' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0">
    <xsl:call-template name="isw3cstateYear3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="substring($string,1,1)='-' and string-length(substring($string,2,2))!=2">INVALID</xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateMonth1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,4)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateYear3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 6 or substring($string,1,1)!='T' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0 or substring($string,4,1)!=':' or string-length(translate(substring($string,5,2),$w3cdigits,''))!=0">INVALID</xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateMin1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMonth1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
       <xsl:call-template name="isw3cstateMonth2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMonth2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 3 or substring($string,1,1)!='-' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0">
    <xsl:call-template name="isw3cstateMonth3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateDay1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,4)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMonth3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 6 or substring($string,1,1)!='T' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0 or substring($string,4,1)!=':' or string-length(translate(substring($string,5,2),$w3cdigits,''))!=0">INVALID</xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateMin1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateDay1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateDay2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateDay2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 6 or substring($string,1,1)!='T' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0 or substring($string,4,1)!=':' or string-length(translate(substring($string,5,2),$w3cdigits,''))!=0">
    <xsl:call-template name="isw3cstateDay3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateMin1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateDay3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="substring($string,1,1)!='Z'">
    <xsl:call-template name="isw3cstateDay4AndDay5">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateDay4AndDay5">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &gt; 5 and (substring($string,1,1)='-' or substring($string,1,1)='+') and string-length(translate(substring($string,2,2),$w3cdigits,''))=0 and substring($string,4,1)=':' and string-length(translate(substring($string,5,2),$w3cdigits,''))=0">
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateTZ">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMin1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateMin2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMin2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 3 or substring($string,1,1)!=':' or string-length(translate(substring($string,2,2),$w3cdigits,''))!=0">
    <xsl:call-template name="isw3cstateMin3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateSec1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,4)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMin3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="substring($string,1,1)!='Z'">
    <xsl:call-template name="isw3cstateMin4AndMin5">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateMin4AndMin5">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &gt; 5 and (substring($string,1,1)='-' or substring($string,1,1)='+') and string-length(translate(substring($string,2,2),$w3cdigits,''))=0 and substring($string,4,1)=':' and string-length(translate(substring($string,5,2),$w3cdigits,''))=0">
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateSec1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateSec2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateSec2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &lt; 2 or substring($string,1,1)!='.'"> <!-- less than 2 because there must be at least one digit after a . -->
    <xsl:call-template name="isw3cstateSec3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstatePrefrac">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateSec3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="substring($string,1,1)!='Z'">
    <xsl:call-template name="isw3cstateSec4AndSec5">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateSec4AndSec5">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &gt; 5 and (substring($string,1,1)='-' or substring($string,1,1)='+') and string-length(translate(substring($string,2,2),$w3cdigits,''))=0 and substring($string,4,1)=':' and string-length(translate(substring($string,5,2),$w3cdigits,''))=0">
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstatePrefrac">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0 or string-length(translate(substring($string,1,1),$w3cdigits,''))!=0">INVALID</xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateFrac1">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
     </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateFrac1">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)!=0 and string-length(translate(substring($string,1,1),$w3cdigits,''))=0">
      <xsl:call-template name="isw3cstateFrac1">
          <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateFrac2">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
     </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateFrac2">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($string)=0">VALID</xsl:when>
    <xsl:otherwise>
    <xsl:call-template name="isw3cstateFrac3">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
     </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateFrac3">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="substring($string,1,1)!='Z'">
    <xsl:call-template name="isw3cstateFrac4AndFrac5">
        <xsl:with-param name="string"><xsl:value-of  select="$string"/></xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,2)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="isw3cstateFrac4AndFrac5">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
  <xsl:when test="string-length($string) &gt; 5 and (substring($string,1,1)='-' or substring($string,1,1)='+') and string-length(translate(substring($string,2,2),$w3cdigits,''))=0 and substring($string,4,1)=':' and string-length(translate(substring($string,5,2),$w3cdigits,''))=0">
    <xsl:call-template name="isw3cstateTZ">
        <xsl:with-param name="string"><xsl:value-of  select="substring($string,7)"/></xsl:with-param>
    </xsl:call-template>
    </xsl:when>
     <xsl:otherwise>INVALID</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- BEGIN disable implicit templates -->
<!-- put this at the end of an XSLT to disable implicit templates -->
<xsl:template match="@*|text()">
</xsl:template>
<!-- BEGIN disable implicit templates -->

</xsl:transform>