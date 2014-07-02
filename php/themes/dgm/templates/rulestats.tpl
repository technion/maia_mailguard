{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/virusstats.css">
{/capture}
{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}
<h3 align="center">
As of {$smarty.now|date_format:"%Y-%m-%d %H:%M:%S %Z"}
</h3>

<div align="center">
{if $enable_charts}
<a target="_new" href="chart_rules.php"><img src="chart_rules.php?thumb=1" alt="" border="0"></a><br>(Click on the chart for a more detailed view)
{/if}
</div><br>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
{if $data}
<tr>
    <td class="spambanner" align="center" colspan="5">
        {$lang.header_rules1}<br>
        <font size="3">{$lang.header_rules2}</font>
    </td>
</tr>
<tr>
    <td class="spamheader" align="center">{$lang.header_rule_name}</td>
    <td class="spamheader" align="center">{$lang.header_rule_description}</td>
    <td class="spamheader" align="center">{$lang.header_rule_score}</td>
    <td class="spamheader" align="center">{$lang.header_rule_count}</td>
    <td class="spamheader" align="center">{$lang.header_percent}</td>
</tr>
{foreach from=$data key=key item=row}
<tr>
    <td class="spambody" align="center">{$row.rule_name}</td>
{if strlen($row.rule_description) > 0}
    <td class="spambody" align="center">{$row.rule_description}</td>
{else}
    <td class="spambody" align="center">{$lang.text_no_description}</td>
{/if}
    <td class="spambody" align="center">{$row.rule_score|string_format:"%.3f"}</td>
    <td class="spambody" align="center">{$row.rule_count}</td>
    <td class="spambody" align="center">{$row.rule_count*100/$total|string_format:"%.1f"}</td>
</tr>
{/foreach}
<tr>
    <td class="spamheader" align="center">{$rcount} {$lang.text_rules}</td>
    <td class="spamheader" align="center">&nbsp;</td>
    <td class="spamheader" align="center">&nbsp;</td>
    <td class="spamheader" align="center">{$total}</td>
    <td class="spamheader" align="center">100%</td>
</tr>
{else}
    <tr>
    <td class="messagebox" valign="top" align="center">{$lang.message_no_rules}</td>
    </tr>
{/if}
</table></div><br>

<div align="center">
<a href="stats.php{$msid}id=0">[ {$lang.link_system_stats} ]</a>
</div>

{/capture}


{include file="container.tpl"}

