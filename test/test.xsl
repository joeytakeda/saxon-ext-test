<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:ss="https://endings.uvic.ca/staticSearch"
    xmlns:local="https://local.com"
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
    
    <xsl:param name="baseDir" 
        select="tokenize(static-base-uri(),'/')[position() ne last()] => string-join('/')"
        as="xs:string"/>    
    <xsl:param name="testDataDir"
        select="$baseDir || '/snowball-data-master/'" 
        as="xs:string"/>
    <xsl:param name="outDir"
        select="$baseDir || '/results/'"
        as="xs:string"/>
    <xsl:param name="failOnError" as="xs:string" select="'false'" static="yes"/>
    <xsl:param name="verbose" as="xs:string" select="'false'" static="yes"/>
    <xsl:param name="langs" select="''" as="xs:string"/>
    
    <xsl:variable name="_failOnError" as="xs:boolean" 
        select="matches($failOnError,'y(es)?|t(rue)|1','i')"
        static="yes"/>
    <xsl:variable name="_verbose" 
        as="xs:boolean"
        select="matches($verbose,'y(es)?|t(rue)|1','i')"
        static="yes"/>
    
    <xsl:variable name="languages" select="map{
        'ar': 'arabic',
        'hy': 'armenian',
        'eu': 'basque',
        'ca': 'catalan',
        'da': 'danish',
        'nl': 'dutch',
        'en': 'english',
        'fi': 'finnish',
        'fr': 'french',
        'de': 'german',
        'el': 'greek',
        'hi': 'hindi',
        'hu': 'hungarian',
        'id': 'indonesian',
        'ga': 'irish',
        'it': 'italian',
        'lt': 'lithuanian',
        'ne': 'nepali',
        'no': 'norwegian',
        'pt': 'portuguese',
        (: Special Porter value for the Porter1 stemmer :)
        'porter': 'porter', 
        'ro': 'romanian',
        'ru': 'russian',
        'sr': 'serbian',
        'es': 'spanish',
        'sv': 'swedish',
        'ta': 'tamil',
        'tr': 'turkish',
        'yi': 'yiddish'
        }"/>
    
    <xsl:variable name="langsToTest" select="
        if ($langs = '')
        then map:keys($languages)
        else map:keys($languages)[. = tokenize($langs,'\s*,\s*')]" as="xs:string*"/>
    
    <xd:doc>
        <xd:desc>Driver</xd:desc>
    </xd:doc>
    <xsl:template name="go">
        <xsl:if test="empty($langsToTest)">
            <xsl:message terminate="yes">ERROR: $lang specified, but no languages
            found for <xsl:value-of select="$langs"/></xsl:message>
        </xsl:if>
        <xsl:for-each select="sort($langsToTest)">
            <xsl:call-template name="runTest"/>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Main test template</xd:desc>
    </xd:doc>
    <xsl:template name="runTest">
        <xsl:variable name="langCode" select="." as="xs:string"/>
        <xsl:variable name="lang" select="$languages(.)" as="xs:string"/>
        <xsl:message expand-text="yes">Testing {$langCode} ({$lang})</xsl:message>
        <xsl:variable name="langDir" select="$testDataDir || $lang" as="xs:string"/>
        <xsl:variable name="voc" 
            select="unparsed-text-lines($langDir || '/voc.txt')" 
            as="xs:string+"/>
        <xsl:variable name="expected" 
            select="unparsed-text-lines($langDir || '/output.txt')" 
            as="xs:string+"/>
        <xsl:iterate select="1 to count($voc)">
            <xsl:param name="errors" 
                select="()"
                as="map(xs:string, xs:string)*"/>
            <xsl:param name="testWords" select="$voc" as="xs:string*"/>
            <xsl:param name="expectedWords" select="$expected" as="xs:string*"/>
            <xsl:on-completion>
                <xsl:if test="not(empty($errors))">
                    <xsl:message _terminate="{$_failOnError}">
                        <xsl:value-of select="count($errors) || ' tests failed'"/>
                        <xsl:sequence select="$errors ! ss:print(.)"/>
                    </xsl:message>
                </xsl:if>
            </xsl:on-completion>
            <xsl:variable name="pos" select="." as="xs:integer"/>
            <xsl:variable name="word" select="$testWords[1]" as="xs:string"/>
            <xsl:variable name="stem" select="ss:stem($word, $langCode)" as="xs:string"/>
            <xsl:variable name="expectedResult" select="$expectedWords[1]" as="xs:string"/>
            <xsl:variable name="passed" select="$stem = $expectedResult" as="xs:boolean"/>
            <xsl:variable name="currResult" as="map(xs:string, xs:string)" select="map{
                'pos': xs:string($pos) || '/' || last(),
                'status': ('Fail', 'Success')[xs:integer($passed) + 1],
                'word': $word,
                'expected': $expectedResult,
                'actual': $stem,
                'langCode': $langCode
                }"/>
            <xsl:if test="(not($passed) and $_failOnError) or $_verbose">
                 <xsl:message _terminate="{$_failOnError}"
                     select="ss:print($currResult)"/>
            </xsl:if>
            <xsl:next-iteration>
                <xsl:with-param name="testWords" select="tail($testWords)"/>
                <xsl:with-param name="expectedWords" select="tail($expectedWords)"/>
                <xsl:with-param name="errors" 
                    select="if ($passed) then $errors else ($errors, $currResult)"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:template>
    
    <xd:doc>
        <xd:desc><xd:ref name="ss:print" type="function">ss:print</xd:ref> renders
        a string format for the result map.</xd:desc>
        <xd:param name="result">The map to print</xd:param>
        <xd:result>A string representation of the map</xd:result>
    </xd:doc>
    <xsl:function name="ss:print" as="xs:string">
        <xsl:param name="result" as="map(xs:string, xs:string)"/>
        <xsl:variable name="keys" 
            select="('langCode', 'pos', 'status', 'word', 'expected', 'actual')"
            as="xs:string+"/>
        <xsl:sequence select="string-join(($keys ! concat(.,': ', $result(.))),'; ')"/>
    </xsl:function>
</xsl:stylesheet>