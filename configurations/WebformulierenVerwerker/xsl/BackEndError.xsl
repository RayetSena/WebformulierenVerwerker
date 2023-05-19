<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text" version="1.0" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates select="error" />
    </xsl:template>
    <xsl:template match="error">
        <xsl:choose>
            <xsl:when test="code='ServerError'">500</xsl:when>
            <xsl:when test="code='ClientError'">400</xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
