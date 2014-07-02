{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/virusstats.css">
{/capture}

{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}
<h3 align="center">
As of {$smarty.now|date_format:"%Y-%m-%d %H:%M:%S %Z"}
</h3>

<div align="center">
{if $enable_charts}
<a target="_new" href="chart_virus.php"><img src="chart_virus.php?thumb=1" alt="" border="0"></a><br>(Click on the chart for a more detailed view)
{/if}
</div><br>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
{if $data}
<tr>
    <td class="virusbanner" align="center" colspan="3">
        {$lang.header_viruses1}<br>
        <font size="3">{$lang.header_viruses2}</font>
    </td>
</tr>
<tr>
    <td class="virusheader" align="center">{$lang.header_virus_name}</td>
    <td class="virusheader" align="center">{$lang.header_count}</td>
    <td class="virusheader" align="center">{$lang.header_percent}</td>
</tr>
{foreach from=$data key=key item=row}
<tr>
    <td class="virusbody" align="center">
        {if $row.url}<a href="{$row.url}">{/if}
        {$row.name}
        {if $row.url}</a>{/if}
    </td>
    <td class="virusbody" align="center">{$row.count}</td>
    <td class="virusbody" align="center">{$row.count*100/$total|string_format:"%.1f"}%</td>
</tr>
{/foreach}
<tr>
    <td class="virusheader" align="center">{$vcount} {$lang.text_viruses}</td>
    <td class="virusheader" align="center">{$total}</td>
    <td class="virusheader" align="center">100%</td>
</tr>
{else}
<tr>
    <td class="messagebox" valign="top" align="center">{$lang.message_no_viruses}</td>
</tr>
{/if}
</table></div><br>

<div align="center">
<a href="stats.php{$msid}id=0">[ {$lang.link_system_stats} ]</a>
</div>
{/capture}


{include file="container.tpl"}

