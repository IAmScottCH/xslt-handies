<!-- Credit here for the original transform:
   - https://stackoverflow.com/questions/5268182/how-to-remove-namespaces-from-xml-using-xslt
   - by jasso
  -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:bp="http://www.bepress.com/document-import.xsd">


    <xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="yes"/>

    <!-- Stylesheet to remove all namespaces from a document -->
    <!-- NOTE: this will lead to attribute name clash, if an element contains
        two attributes with same local name but different namespace prefix -->
    <!-- Nodes that cannot have a namespace are copied as such -->

    <!-- template to copy elements -->
    <xsl:template match="bp:*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <!-- template to copy attributes -->
    <xsl:template match="@*">
    		<xsl:choose>
    		<xsl:when test="(starts-with(.,'bp:'))">
          <xsl:attribute name="{name()}">
	            <xsl:value-of select="substring(.,4)"/>
	        </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="{name()}">
	            <xsl:value-of select="."/>
	        </xsl:attribute>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template to copy the rest of the nodes -->
    <xsl:template match="comment() | text() | processing-instruction()">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
