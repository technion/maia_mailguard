{include file="html_head.tpl"}

<h3 align="center">
{$lang.text_as_of} {$smarty.now|date_format:"%Y-%m-%d %H:%M:%S %Z"}
</h3>

<div align="center">
{if $enable_charts}
<img src="chart_stats.php{$msid}id={$user_id}">
{/if}
<table border="0" cellspacing="1" cellpadding="2" width="100%" id="content">
<tr>
    <td class="menuheader" colspan="12" align="center">{$header}</td>
</tr>
<tr>
    <td class="menuheader2" colspan="4" align="center">{$lang.header_items}</td>
    <td class="menuheader2" colspan="3" align="center">{$lang.header_score}</td>
    <td class="menuheader2" colspan="3" align="center">{$lang.header_size} (kB)</td>
    <td class="menuheader2" colspan="2" align="center">{$lang.header_bandwidth}/{$lang.text_day}</td>
</tr>
<tr>
    <td class="menuheader2" align="center">{$lang.header_type}</td>
    <td class="menuheader2" align="center">{$lang.header_count}</td>
    <td class="menuheader2" align="center">{$lang.header_items}/{$lang.text_day}</td>
    <td class="menuheader2" align="center">{$lang.header_percent}</td>
    <td class="menuheader2" align="center">{$lang.header_min}</td>
    <td class="menuheader2" align="center">{$lang.header_max}</td>
    <td class="menuheader2" align="center">{$lang.header_average}</td>
    <td class="menuheader2" align="center">{$lang.header_min}</td>
    <td class="menuheader2" align="center">{$lang.header_max}</td>
    <td class="menuheader2" align="center">{$lang.header_average}</td>
    <td class="menuheader2" align="center">MB</td>
    <td class="menuheader2" align="center">{$lang.header_cost} ({$currency_label})</td>
</tr>
{foreach from=$data key=type item=row}
<tr>
    <td class="{$type}body2" align="center">
    {if $links.$type}<a href="list-cache.php{$msid}cache_type={$links.$type}" class="statslink">{/if}
    {$lang.array_header[$type]}
    {if $links.$type}</a>{/if}
    </td>
    <td class="{$type}body2" align="center">{$row.items}</td>
    <td class="{$type}body2" align="center">{$row.rate}</td>
    <td class="{$type}body2" align="center">{$row.pct}</td>
    <td class="{$type}body2" align="center">{$row.minscore}</td>
    <td class="{$type}body2" align="center">{$row.maxscore}</td>
    <td class="{$type}body2" align="center">{$row.avgscore}</td>
    <td class="{$type}body2" align="center">{$row.minsize}</td>
    <td class="{$type}body2" align="center">{$row.maxsize}</td>
    <td class="{$type}body2" align="center">{$row.avgsize}</td>
    <td class="{$type}body2" align="center">{$row.bandwidth}</td>
    <td class="{$type}body2" align="center">{$row.cost}</td>
</tr>
{/foreach}
{if $enable_spam_filtering}
<tr>
    <td class="menuheader2" colspan="12" align="center">
           {if $enable_false_negative_management}
               {$lang.text_efficiency}  {$eff_pct*100|string_format:"%.2f"}%                
               {$lang.text_false_positive} {$fp_pct*100|string_format:"%.2f"}% 
               {$lang.text_false_negative} {$fn_pct*100|string_format:"%.2f"}%  
               <br>
               {$lang.text_sensitivity} {$sensitivity_pct*100|string_format:"%.2f"}%
               {$lang.text_ppv} {$ppv_pct*100|string_format:"%.2f"}% 
               {$lang.text_specificity} {$specificity_pct*100|string_format:"%.2f"}% 
               {$lang.text_npv} {$npv_pct*100|string_format:"%.2f"}% 
               
           {else}
       	       {$lang.text_efficiency} {$eff_pct*100|string_format:"%.2f"}% 
               {$lang.text_false_positive} {$fp_pct*100|string_format:"%.2f"}% 
               <br>
               {$lang.text_sensitivity} {$sensitivity_pct*100|string_format:"%.2f"}%
               {$lang.text_ppv}{$ppv_pct*100|string_format:"%.2f"}% 
           {/if}
    </td>
</tr>
{/if}
{if !$is_a_visitor}
    {if $user_id > 0}
        <tr>
        <td class="menuheader2" colspan="12" align="center">
        <a href="stats.php{$msid}id=0">[ {$lang.link_systemwide} ]</a></td>
        </tr>
     {else}
        <tr>
        <td class="menuheader2" colspan="12" align="center">
        <a href="stats.php{$sid}">[ {$lang.link_personal} ]</a></td>
        </tr>
        {if $enable_virus_scanning}
           <tr>
           <td class="menuheader2" colspan="12" align="center">
           <a href="virusstats.php{$sid}">[ {$lang.link_viruses} ]</a></td>
           </tr>
           <tr>
        {/if}
        {if $enable_spam_filtering}
           <td class="menuheader2" colspan="12" align="center">
           <a href="rulestats.php{$sid}">[ {$lang.link_rules} ]</a></td>
           </tr>
        {/if}
    {/if}
{/if}
</table></div><br>

{include file="html_foot.tpl"}

