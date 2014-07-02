{include file="html_head.tpl"}

<h3 align="center">
{$lang.text_as_of} {$smarty.now|date_format:"%Y-%m-%d %H:%M:%S %Z"}
</h3>
{if $enable_charts}
<div id="statsgraph">
<img src="chart_stats.php{$msid}id={$user_id}">
</div>
{/if}
<div id="statschart" class="styledform ui-widget-content">
<fieldset>
  <legend>{$header}</legend>
  <ol>
  <li>
<table>
<tr>
    <th class="menuheader2" colspan="4" align="center">{$lang.header_items}</td>
    <th class="menuheader2" colspan="3" align="center">{$lang.header_score}</td>
    <th class="menuheader2" colspan="3" align="center">{$lang.header_size} (kB)</td>
    <th class="menuheader2" colspan="2" align="center">{$lang.header_bandwidth}/{$lang.text_day}</td>
</tr>
<tr>
    <th class="menuheader2" align="center">{$lang.header_type}</td>
    <th class="menuheader2" align="center">{$lang.header_count}</td>
    <th class="menuheader2" align="center">{$lang.header_items}/{$lang.text_day}</td>
    <th class="menuheader2" align="center">{$lang.header_percent}</td>
    <th class="menuheader2" align="center">{$lang.header_min}</td>
    <th class="menuheader2" align="center">{$lang.header_max}</td>
    <th class="menuheader2" align="center">{$lang.header_average}</td>
    <th class="menuheader2" align="center">{$lang.header_min}</td>
    <th class="menuheader2" align="center">{$lang.header_max}</td>
    <th class="menuheader2" align="center">{$lang.header_average}</td>
    <th class="menuheader2" align="center">MB</td>
    <th class="menuheader2" align="center">{$lang.header_cost} ({$currency_label})</td>
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
</table>
</li>
{if $enable_spam_filtering}
<li>
  <table>
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
</li>
{/if}
{if !$is_a_visitor}
    {if $user_id > 0}
        <li>
        <a href="stats.php{$msid}id=0">[ {$lang.link_systemwide} ]</a>
        </li>
     {else}
        <li>
        <a href="stats.php{$sid}">[ {$lang.link_personal} ]</a>
        </li>
        {if $enable_virus_scanning}
           <li>
           <a href="virusstats.php{$sid}">[ {$lang.link_viruses} ]</a>
           </li>
        {/if}
        {if $enable_spam_filtering}
           <li>
           <a href="rulestats.php{$sid}">[ {$lang.link_rules} ]</a>
           </li>
        {/if}
    {/if}
{/if}
</ol>
</fieldset>
</div>

{include file="html_foot.tpl"}

