<!-- XSLT Demo -->

<!--*****************************************************************
     BASIC TEMPLATE MATCHING
     List of book and magazine titles
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book">
  <BookTitle> <xsl:value-of select="Title" /> </BookTitle>
</xsl:template>

<xsl:template match="Magazine">
  <MagazineTitle> <xsl:value-of select="Title" /> </MagazineTitle>
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     SIMPLE XPATH, COPY-OF
     All books costing less than $90
     Note unwanted concatentated text
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book[@Price &lt; 90]">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     NULL TEMPLATE
     All books costing less than $90, without extra text
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book[@Price &lt; 90]">
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="text()" />

</xsl:stylesheet>

<!--*****************************************************************
     TEMPLATE-MATCHING AMBIGUITY
     Discard books, but also copy books and magazines
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book" />

<xsl:template match="Book">
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="Magazine">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     TEMPLATE-MATCHING AMBIGUITY
     Swap order of Book templates
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book">
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="Book" />

<xsl:template match="Magazine">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     TEMPLATE-MATCHING AMBIGUITY
     Copy inexpensive books and discard others
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book[@Price &lt; 90]">
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="Book" />

<xsl:template match="Magazine">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     TEMPLATE-MATCHING AMBIGUITY
     Make Book templates equally specific
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="Book[@Price &lt; 90]">
   <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="Book[Title]" />

<xsl:template match="Magazine">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     COPY ENTIRE DOCUMENT
     Easy way (can equally replace "/" with "Bookstore"
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="/">
   <xsl:copy-of select="." />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     COPY ENTIRE DOCUMENT
     Hard way - recursive APPLY-TEMPLATES
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="*|@*|text()">
   <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
   </xsl:copy>
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     SELECTIVE TRANSFORMATIONS
     Copy document but transform all attributes to subelements,
     author name subelements to attributes
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="*|@*|text()">
   <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
   </xsl:copy>
</xsl:template>

<xsl:template match="@ISBN">
   <ISBN><xsl:value-of select="." /></ISBN>
</xsl:template>

<xsl:template match="@Price">
   <Price><xsl:value-of select="." /></Price>
</xsl:template>

<xsl:template match="@Edition">
   <Edition><xsl:value-of select="." /></Edition>
</xsl:template>

<xsl:template match="@Month">
   <Month><xsl:value-of select="." /></Month>
</xsl:template>

<xsl:template match="@Year">
   <Year><xsl:value-of select="." /></Year>
</xsl:template>

<xsl:template match="Author">
  <Author LN="{Last_Name}" FN="{First_Name}" />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     Remove first template in above to show need for recursive
     APPLY-TEMPLATES
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="@ISBN">
   <ISBN><xsl:value-of select="." /></ISBN>
</xsl:template>

<xsl:template match="@Price">
   <Price><xsl:value-of select="." /></Price>
</xsl:template>

<xsl:template match="@Edition">
   <Edition><xsl:value-of select="." /></Edition>
</xsl:template>

<xsl:template match="@Month">
   <Month><xsl:value-of select="." /></Month>
</xsl:template>

<xsl:template match="@Year">
   <Year><xsl:value-of select="." /></Year>
</xsl:template>

<xsl:template match="Author">
  <Author LN="{Last_Name}" FN="{First_Name}" />
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     ITERATION, SORT, CONDITIONAL, TRANSFORMATION TO HTML
     Table of books costing less than $90, sorted by price
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" />

<xsl:template match="/">
   <html>
   <table border="1">
      <th>Book</th>
      <th>Cost</th>
      <xsl:for-each select="Bookstore/Book">
      <xsl:sort select="@Price" />
         <xsl:if test="@Price &lt; 90">
            <tr>
            <td><i><xsl:value-of select="Title" /></i></td>
            <td><xsl:value-of select="@Price" /></td>
            </tr>
         </xsl:if>
      </xsl:for-each>
   </table>
   </html>
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     Expunge 'Jennifer', change 'Widom' to 'Ms. Widom'
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="*|@*|text()">
   <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
   </xsl:copy>
</xsl:template>

<xsl:template match="First_Name[data(.) = 'Jennifer']">
</xsl:template>

<xsl:template match="Last_Name[data(.) = 'Widom']">
  <Name>Ms. Widom</Name>
</xsl:template>

</xsl:stylesheet>

<!--*****************************************************************
     Alternate version of above
******************************************************************-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="*|@*|text()">
   <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
   </xsl:copy>
</xsl:template>

<xsl:template match="Author[First_Name[data(.) = 'Jennifer']]">
  <Author>
    <Name>Ms. Widom</Name>
  </Author>
</xsl:template>

</xsl:stylesheet>
