 <?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match='/countries'>
            <xsl:for-each select = 'country'>
            <country languages = 'count(language)' cities = 'count(city)'>
                <name><xsl:value-of select = '@name'/></name>
                <population><xsl:value-of select = '@population' /></population>
            </country>
            </xsl:for-each>
        </xsl:template>

        <xsl:template match = 'text()' />
        
    </xsl:stylesheet>

