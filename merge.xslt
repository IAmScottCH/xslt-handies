<?xml version="1.0"?>

<!--
   Merging two XML files
   Version 1.6
   LGPL (c) Oliver Becker, 2002-07-05
   obecker@informatik.hu-berlin.de
-->
<!--
// NOTE on node equivalence:
//  two elements are equivalent if they contain exactly the same element name and element attributes (names and values)
//  thus, <n1 attr1="abc"> is equivalent to <n1 attr1="abc"> but not to any of:
//     - <n2 attr1="abc">
//     - <n1 attr2="abc">
//     - <n1 attr1="abc" attr2="def">
//     - <n1 attr1="def">
//     - etc.
 -->
<!--
Sample usage in some C++ code:
const char * ClaUtility::MERGE_XSL_FILE="merge.xslt";
const int ClaUtility::XML_FLAG_REPLACE_TEXT_NODE=1;
// merge xml doc1 and xml doc2 and return the result in result.
// NOTE on node equivalence:
//  two elements are equivalent if they contain exactly the same element name and element attributes (names and values)
//  thus, <n1 attr1="abc"> is equivalent to <n1 attr1="abc"> but not to any of:
//     - <n2 attr1="abc">
//     - <n1 attr2="abc">
//     - <n1 attr1="abc" attr2="def">
//     - <n1 attr1="def">
//     - etc.
//   To change this behavior you have to change the merge XSL template.
// throws exceptions on errors:
// 1: doc 1 parse failed.
// 101: xslt apply failed (doc 1)
// 103: putting transform result in string failed
std::string & ClaUtility::XMLMerge(const std::string doc1,const std::string doc2,std::string & result, int flags)
{
	std::string tname,pvalue;
	std::string pname;
	std::ofstream tstream;
	xmlDocPtr xdoc1;
	xmlDocPtr xdoc2;
	xmlDocPtr xres;
	xsltStylesheetPtr xslt;
	const char * params[5];  // number of elements should be 2*(number of parameter tuples) +1
	params[4]=NULL;  // last element is NULL (NULL terminated list).
	xmlChar * cres;
	int cresSize;
	bool replace;

	result.clear();
	xdoc1=NULL;
	xdoc2=NULL;
	xslt=NULL;
	xres=NULL;
	cres=NULL;
	cresSize=0;

	replace=(flags & ClaUtility::XML_FLAG_REPLACE_TEXT_NODE);

	// write doc2 to a file, put the file name in the XSLT processor parameters array
	pname="with";
	tname="xmldoc2.xml";
	pvalue="'" + tname + "'";
	params[0]=pname.c_str();
	params[1]=pvalue.c_str();
	tstream.open(tname.c_str());
	tstream << doc2;
	tstream.close();

	if(replace)
	{
		params[2]="replace";
		params[3]="'1'";
	}
	else
	{
		params[2]=NULL;
	}

	// these are recommended in the libxslt docs
	xmlSubstituteEntitiesDefault(1);
	xmlLoadExtDtdDefaultValue=1;

	xslt=xsltParseStylesheetFile((const xmlChar *)(MERGE_XSL_FILE));

	xdoc1=xmlParseDoc((xmlChar *)(doc1.c_str()));
	if(xdoc1==NULL)
	{
		xsltCleanupGlobals();
		xmlCleanupParser();
		throw 1;  // parse failed
	}
	xres=xsltApplyStylesheet(xslt,xdoc1,params);
	if(xres==NULL)
	{
		xmlFreeDoc(xdoc1);
		xsltCleanupGlobals();
		xmlCleanupParser();
		throw 101; // xslt failed
	}
	if(xsltSaveResultToString(&cres,&cresSize,xres,xslt)!=0)
	{
		xmlFreeDoc(xdoc1);
		xmlFreeDoc(xres);
		xsltCleanupGlobals();
		xmlCleanupParser();
		throw 103; // xslt save result failed
	}
	result=(const char *)(cres);


	if(cres)
		free(cres);
	if(xres)
		xmlFreeDoc(xres);
	if(xdoc1)
		xmlFreeDoc(xdoc1);
	if(xdoc2)
		xmlFreeDoc(xdoc2);
	if(xslt)
		xsltFreeStylesheet(xslt);

	xsltCleanupGlobals();
	xmlCleanupParser();
	return result;
}
-->
<xslt:transform version="1.0"
                xmlns:xslt="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://informatik.hu-berlin.de/merge"
                exclude-result-prefixes="m">


<!-- Normalize the contents of text, comment, and processing-instruction
     nodes before comparing?
     Default: yes -->
<xslt:param name="normalize" select="'yes'" />

<!-- Don't merge elements with this (qualified) name -->
<xslt:param name="dontmerge" />

<!-- If set to true, text nodes in file1 will be replaced -->
<xslt:param name="replace" select="false()" />

<!-- used below by "Variant 2" -->
<xslt:param name="with" />


<!-- Variant 1: Source document looks like
     <?xml version="1.0"?>
     <merge xmlns="http://informatik.hu-berlin.de/merge">
        <file1>file1.xml</file1>
        <file2>file2.xml</file2>
     </merge>
     The transformation sheet merges file1.xml and file2.xml.
-->
<xslt:template match="m:merge" >
   <xslt:variable name="file1" select="string(m:file1)" />
   <xslt:variable name="file2" select="string(m:file2)" />
   <!--
   <xslt:message>
      <xslt:text />Merging '<xslt:value-of select="$file1" />
      <xslt:text />' and '<xslt:value-of select="$file2"/>'<xslt:text />
   </xslt:message>
   -->
   <xslt:if test="$file1='' or $file2=''">
      <xslt:message terminate="yes">
         <xslt:text>No files to merge specified</xslt:text>
      </xslt:message>
   </xslt:if>
   <xslt:call-template name="m:merge">
      <xslt:with-param name="nodes1" select="document($file1,/*)/node()" />
      <xslt:with-param name="nodes2" select="document($file2,/*)/node()" />
   </xslt:call-template>
</xslt:template>


<!-- Variant 2:
     The transformation sheet merges the source document with the
     document provided by the parameter "with".
-->

<xslt:template match="*">
<!--
  <xslt:message>
      <xslt:text />Merging input with '<xslt:value-of select="$with"/>
      <xslt:text>'</xslt:text>
   </xslt:message>
   -->
   <xslt:if test="string($with)=''">
      <xslt:message terminate="yes">
         <xslt:text>No input file specified (parameter 'with')</xslt:text>
      </xslt:message>
   </xslt:if>

   <xslt:call-template name="m:merge">
      <xslt:with-param name="nodes1" select="/node()" />
      <xslt:with-param name="nodes2" select="document($with,/*)/node()" />
   </xslt:call-template>
</xslt:template>


<!-- ============================================================== -->

<!-- The "merge" template -->
<xslt:template name="m:merge">
   <xslt:param name="nodes1" />
   <xslt:param name="nodes2" />

   <xslt:choose>
      <!-- Is $nodes1 resp. $nodes2 empty? -->
      <xslt:when test="count($nodes1)=0">
         <xslt:copy-of select="$nodes2" />
      </xslt:when>
      <xslt:when test="count($nodes2)=0">
         <xslt:copy-of select="$nodes1" />
      </xslt:when>

      <xslt:otherwise>
         <!-- Split $nodes1 and $nodes2 -->
         <xslt:variable name="first1" select="$nodes1[1]" />
         <xslt:variable name="rest1" select="$nodes1[position()!=1]" />
         <xslt:variable name="first2" select="$nodes2[1]" />
         <xslt:variable name="rest2" select="$nodes2[position()!=1]" />
         <!-- Determine type of node $first1 -->
         <xslt:variable name="type1">
            <xslt:apply-templates mode="m:detect-type" select="$first1" />
         </xslt:variable>

         <!-- Compare $first1 and $first2 -->
         <xslt:variable name="diff-first">
            <xslt:call-template name="m:compare-nodes">
               <xslt:with-param name="node1" select="$first1" />
               <xslt:with-param name="node2" select="$first2" />
            </xslt:call-template>
         </xslt:variable>

         <xslt:choose>
            <!-- $first1 != $first2 -->
            <xslt:when test="$diff-first='!'">
               <!-- Compare $first1 and $rest2 -->
               <xslt:variable name="diff-rest">
                  <xslt:for-each select="$rest2">
                     <xslt:call-template name="m:compare-nodes">
                        <xslt:with-param name="node1" select="$first1" />
                        <xslt:with-param name="node2" select="." />
                     </xslt:call-template>
                  </xslt:for-each>
               </xslt:variable>

               <xslt:choose>
                  <!-- $first1 is in $rest2 and
                       $first1 is *not* an empty text node  -->
                  <xslt:when test="contains($diff-rest,'=') and
                                      not($type1='text' and
                                          normalize-space($first1)='')">
                     <!-- determine position of $first1 in $nodes2
                          and copy all preceding nodes of $nodes2 -->
                     <xslt:variable name="pos"
                           select="string-length(substring-before(
                                                $diff-rest,'=')) + 2" />
                     <xslt:copy-of
                           select="$nodes2[position() &lt; $pos]" />
                     <!-- merge $first1 with its equivalent node -->
                     <xslt:choose>
                        <!-- Elements: merge -->
                        <xslt:when test="$type1='element'">
                           <xslt:element name="{name($first1)}"
                                         namespace="{namespace-uri($first1)}">
                              <xslt:copy-of select="$first1/namespace::*" />
                              <xslt:copy-of select="$first2/namespace::*" />
                              <xslt:copy-of select="$first1/@*" />
                              <xslt:call-template name="m:merge">
                                 <xslt:with-param name="nodes1"
                                       select="$first1/node()" />
                                 <xslt:with-param name="nodes2"
                                       select="$nodes2[position()=$pos]/node()" />
                              </xslt:call-template>
                           </xslt:element>
                        </xslt:when>
                        <!-- Other: copy -->
                        <xslt:otherwise>
                           <xslt:copy-of select="$first1" />
                        </xslt:otherwise>
                     </xslt:choose>

                     <!-- Merge $rest1 and rest of $nodes2 -->
                     <xslt:call-template name="m:merge">
                        <xslt:with-param name="nodes1" select="$rest1" />
                        <xslt:with-param name="nodes2"
                              select="$nodes2[position() &gt; $pos]" />
                     </xslt:call-template>
                  </xslt:when>

                  <!-- $first1 is a text node and replace mode was
                       activated -->
                  <xslt:when test="$type1='text' and $replace">
                     <xslt:call-template name="m:merge">
                        <xslt:with-param name="nodes1" select="$rest1" />
                        <xslt:with-param name="nodes2" select="$nodes2" />
                     </xslt:call-template>
                  </xslt:when>

                  <!-- else: $first1 is not in $rest2 or
                       $first1 is an empty text node -->
                  <xslt:otherwise>
                     <xslt:copy-of select="$first1" />
                     <xslt:call-template name="m:merge">
                        <xslt:with-param name="nodes1" select="$rest1" />
                        <xslt:with-param name="nodes2" select="$nodes2" />
                     </xslt:call-template>
                  </xslt:otherwise>
               </xslt:choose>
            </xslt:when>

            <!-- else: $first1 = $first2 -->
            <xslt:otherwise>
               <xslt:choose>
                  <!-- Elements: merge -->
                  <xslt:when test="$type1='element'">
                     <xslt:element name="{name($first1)}"
                                   namespace="{namespace-uri($first1)}">
                        <xslt:copy-of select="$first1/namespace::*" />
                        <xslt:copy-of select="$first2/namespace::*" />
                        <xslt:copy-of select="$first1/@*" />
                        <xslt:call-template name="m:merge">
                           <xslt:with-param name="nodes1"
                                            select="$first1/node()" />
                           <xslt:with-param name="nodes2"
                                            select="$first2/node()" />
                        </xslt:call-template>
                     </xslt:element>
                  </xslt:when>
                  <!-- Other: copy -->
                  <xslt:otherwise>
                     <xslt:copy-of select="$first1" />
                  </xslt:otherwise>
               </xslt:choose>

               <!-- Merge $rest1 and $rest2 -->
               <xslt:call-template name="m:merge">
                  <xslt:with-param name="nodes1" select="$rest1" />
                  <xslt:with-param name="nodes2" select="$rest2" />
               </xslt:call-template>
            </xslt:otherwise>
         </xslt:choose>
      </xslt:otherwise>
   </xslt:choose>
</xslt:template>


<!-- Comparing single nodes:
     if $node1 and $node2 are equivalent then the template creates a
     text node "=" otherwise a text node "!" -->
<xslt:template name="m:compare-nodes">
   <xslt:param name="node1" />
   <xslt:param name="node2" />
   <xslt:variable name="type1">
      <xslt:apply-templates mode="m:detect-type" select="$node1" />
   </xslt:variable>
   <xslt:variable name="type2">
      <xslt:apply-templates mode="m:detect-type" select="$node2" />
   </xslt:variable>

   <xslt:choose>
      <!-- Are $node1 and $node2 element nodes with the same name? -->
      <xslt:when test="$type1='element' and $type2='element' and
                       local-name($node1)=local-name($node2) and
                       namespace-uri($node1)=namespace-uri($node2) and
                       name($node1)!=$dontmerge and name($node2)!=$dontmerge">
         <!-- Comparing the attributes -->
         <xslt:variable name="diff-att">
            <!-- same number ... -->
            <xslt:if test="count($node1/@*)!=count($node2/@*)">.</xslt:if>
            <!-- ... and same name/content -->
            <xslt:for-each select="$node1/@*">
               <xslt:if test="not($node2/@*
                        [local-name()=local-name(current()) and
                         namespace-uri()=namespace-uri(current()) and
                         .=current()])">.</xslt:if>
            </xslt:for-each>
         </xslt:variable>
         <xslt:choose>
            <xslt:when test="string-length($diff-att)!=0">!</xslt:when>
            <xslt:otherwise>=</xslt:otherwise>
         </xslt:choose>
      </xslt:when>

      <!-- Other nodes: test for the same type and content -->
      <xslt:when test="$type1!='element' and $type1=$type2 and
                       name($node1)=name($node2) and
                       ($node1=$node2 or
                          ($normalize='yes' and
                           normalize-space($node1)=
                           normalize-space($node2)))">=</xslt:when>

      <!-- Otherwise: different node types or different name/content -->
      <xslt:otherwise>!</xslt:otherwise>
   </xslt:choose>
</xslt:template>


<!-- Type detection, thanks to M. H. Kay -->
<xslt:template match="*" mode="m:detect-type">element</xslt:template>
<xslt:template match="text()" mode="m:detect-type">text</xslt:template>
<xslt:template match="comment()" mode="m:detect-type">comment</xslt:template>
<xslt:template match="processing-instruction()" mode="m:detect-type">pi</xslt:template>

</xslt:transform>
