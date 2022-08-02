<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:ss="https://endings.uvic.ca/staticSearch"
    exclude-result-prefixes="#all"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Aug 1, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text"/>
    
    <xsl:variable name="githubUrl" select="'https://raw.githubusercontent.com/snowballstem/snowball-data/master/'"/>
    <xsl:variable name="languages" select="map{
        'english': 'en',
        'french': 'fr',
        'german': 'de'
        }"/>
    
    <xsl:template name="go">
        <xsl:for-each select="map:keys($languages)">
            <xsl:message>Testing <xsl:value-of select="."/></xsl:message>
            <xsl:variable name="langCode" select="$languages(.)"/>
            <xsl:variable name="vocUrl" select="$githubUrl || '/' || . || '/voc.txt'"/>
            <xsl:variable name="outputUrl" select="$githubUrl || '/' || . || '/output.txt'"/>
            <xsl:variable name="voc" select="unparsed-text-lines($vocUrl)"/>
            <xsl:variable name="output" select="unparsed-text-lines($outputUrl)"/>
            <xsl:for-each select="$voc">
                <xsl:variable name="pos" select="position()"/>
                <xsl:variable name="stem" select="ss:stem(.,$langCode)"/>
                <xsl:variable name="expected" select="$output[$pos]"/>
                <xsl:message select="(if ($stem = $expected) then 'PASSED: ' else 'FAILED: ') 
                    || 'Input: ' || . 
                    || ' | Expected: ' ||  $expected 
                    || ' | Actual: ' || $stem"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>