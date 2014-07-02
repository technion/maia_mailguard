{include file="html_head.tpl"}

<h3 align="center">
As of {$smarty.now|date_format:"%Y-%m-%d %H:%M:%S %Z"}
</h3>

<div align="center">
{if $enable_charts}
<a target="_new" href="chart_virus.php"><img src="chart_virus.php?thumb=1" alt="" border="0"></a><br>(Click on the chart for a more detailed view)
{/if}
</div><br>

<div class="styledform ui-widget-content">
  <fieldset><legend>{$lang.header_viruses1} : {$lang.header_viruses2}</legend>
    <ol>
{if $data}
<li>
  <table class="ui-list-table">
<tr>
    <td class="virusheader2" align="center">{$lang.header_virus_name}</td>
    <td class="virusheader2" align="center">{$lang.header_count}</td>
    <td class="virusheader2" align="center">{$lang.header_percent}</td>
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
</table>
</li>
{else}
<li>
    {$lang.message_no_viruses}
</li>
{/if}
</ol>
</fieldset>
</div>

<div class="styledform">
<a href="stats.php{$msid}id=0">[ {$lang.link_system_stats} ]</a>
</div>

{include file="html_foot.tpl"}
