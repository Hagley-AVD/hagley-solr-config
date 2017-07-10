<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3"
     exclude-result-prefixes="mods">

  <!-- Eliminate excessive specificity with root name elements. -->
  <xsl:template match="mods:mods/mods:name[mods:role/mods:roleTerm]" mode="slurping_MODS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz_'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '" />

    <xsl:variable name="base_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="concat(translate(@type, ' ', '_'), '_')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:for-each select="mods:role/mods:roleTerm">
      <xsl:variable name="this_prefix" select="concat($base_prefix, translate(normalize-space(.), $uppercase, $lowercase), '_')"/>

      <xsl:apply-templates select="../../mods:namePart" mode="hagley_slurp_mods_name">
        <xsl:with-param name="prefix" select="$this_prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="mods:namePart" mode="hagley_slurp_mods_name">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>


    <xsl:variable name="value" select="normalize-space(.)"/>
    <xsl:if test="$value">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="$prefix"/>
          <xsl:value-of select="local-name()"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="$suffix"/>
        </xsl:attribute>
        <xsl:value-of select="$value"/>
      </field>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
