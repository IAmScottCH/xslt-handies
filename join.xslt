<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
]>

<!--
  - join an arbitrary number of strings together by some other character.  Kind of like PHP's join() function.
  - NOTE: the join-nodeset template assumes some kind of node-set function is available in the processor.
  -       the join template does not have this limitation, but you are limited to building the node set
  -       via a select= on the variable declaration.  Since you can't always force an ordering that way,
  -       your strings may get concatentated in a different order than you want.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
                version="1.0">

<xsl:template match="/">

	First, the join template:
	<xsl:variable name="xns" select="//document/elema/something | //document/elemd | //document/elemc | //document/elemb" />
	<xsl:call-template name="join">
		<xsl:with-param name="thenodes" select="$xns" />
	</xsl:call-template>

  Second, the join-nodeset template:
	<xsl:variable name="somenodes">
	  <anode><xsl:value-of select="//document/elema/something"/></anode>
	  <anode><xsl:value-of select="//document/elemd"/></anode>
	  <anode><xsl:value-of select="//document/elemc"/></anode>
	  <anode><xsl:value-of select="//document/elemb"/></anode>
	</xsl:variable>

	<xsl:variable name="tildelim">~~~</xsl:variable>
	<xsl:call-template name="join-nodeset">
		<xsl:with-param name="treefrag" select="$somenodes" />
		<xsl:with-param name="delimiter" select="$tildelim" />
	</xsl:call-template>

  Third, the join-nodeset template with two internal empty nodes and a trailing empty node:
	<xsl:variable name="somemorenodes">
	  <anode><xsl:value-of select="//document/elema/something"/></anode>
	  <anode><xsl:value-of select="//document/elemd"/></anode>
	  <anode><xsl:value-of select="//document/elemc"/></anode>
	  <anode><xsl:value-of select="//document/elemf"/></anode>
	  <anode><xsl:value-of select="//document/elemb"/></anode>
	  <anode><xsl:value-of select="//document/elemg"/></anode>
	</xsl:variable>

	<xsl:call-template name="join-nodeset">
		<xsl:with-param name="treefrag" select="$somemorenodes" />
		<xsl:with-param name="delimiter" select="$tildelim" />
	</xsl:call-template>

	Fourth, the join template with multiple internal empty nodes:
	<xsl:variable name="xns2" select="//document/elema/something | //document/elemd | //document/elemf | //document/elemg | //document/elemc | //document/elemb" />
	<xsl:call-template name="join">
		<xsl:with-param name="thenodes" select="$xns2" />
	</xsl:call-template>

	Fifth, the join template with only empty nodes:
	<xsl:variable name="xns3" select=" //document/elemf | //document/elemg | //document/elemc " />
	<xsl:call-template name="join">
		<xsl:with-param name="thenodes" select="$xns3" />
	</xsl:call-template>

	Sixth, the join template with only nodes with content:
	<xsl:variable name="xns4" select=" //document/elema/something | //document/elemd | //document/elemb " />
	<xsl:call-template name="join">
		<xsl:with-param name="thenodes" select="$xns4" />
	</xsl:call-template>


</xsl:template>

<xsl:template name="join-nodeset">
	<xsl:param name="treefrag"></xsl:param>
	<xsl:param name="delimiter">, </xsl:param>
	<xsl:call-template name="join">
		<xsl:with-param name="thenodes" select="exsl:node-set($treefrag)/anode"/>
		<xsl:with-param name="delimiter" select="$delimiter"/>
	</xsl:call-template>

</xsl:template>

<!-- this will join the nodes in the order given -->
<xsl:template name="join">
	<xsl:param name="thenodes"></xsl:param>
	<xsl:param name="delimiter">, </xsl:param>
	<xsl:variable name="nodecount" select="count($thenodes)" />
	<xsl:for-each select="$thenodes">
		<xsl:variable name="nextnodenum" select="position()+1" />
		<xsl:variable name="prevnodenum" select="position()-1" />
		<xsl:if test="string-length(.)>0">
			<xsl:value-of select="."/>
			<xsl:if test="$nextnodenum &lt;= $nodecount">
				<xsl:variable name="nextnode" select="$thenodes[$nextnodenum]" />
				<xsl:if test="string-length($nextnode)>0">
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<!-- if the node was empty and the previous node was not, then
		  -  I emitted the previous node without a trailing delimiter.
		  -  So, if I'm not emitting this node, I need to see if the
		  -  previous one contained text, and if so, if any forward
		  -  nodes will contain text, I need to drop a delimiter now
		  -->
		<xsl:if test="string-length(.)=0">
			<xsl:if test="$prevnodenum &gt; 0">
				<xsl:variable name="prevnode" select="$thenodes[$prevnodenum]" />
				<xsl:if test="string-length($prevnode)>0">
					<xsl:call-template name="emit-delimiter-if-later-text">
						<xsl:with-param name="thenodes" select="$thenodes" />
						<xsl:with-param name="nextnodenum" select="$nextnodenum" />
						<xsl:with-param name="delimiter" select="$delimiter" />
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="emit-delimiter-if-later-text">
	<xsl:param name="thenodes"></xsl:param>
	<xsl:param name="nextnodenum"></xsl:param>
	<xsl:param name="delimiter"></xsl:param>
	<xsl:if test="string-length($thenodes[$nextnodenum])>0">
		<xsl:value-of select="$delimiter" />
	</xsl:if>
	<xsl:if test="string-length($thenodes[$nextnodenum])=0">
		<xsl:variable name="nn" select="$nextnodenum+1" />
		<xsl:if test="$nn &lt;= count($thenodes)">
			<xsl:call-template name="emit-delimiter-if-later-text">
				<xsl:with-param name="thenodes" select="$thenodes" />
				<xsl:with-param name="nextnodenum" select="$nn" />
				<xsl:with-param name="delimiter" select="$delimiter" />
			</xsl:call-template>
		</xsl:if>
	</xsl:if>

</xsl:template>

</xsl:stylesheet>
