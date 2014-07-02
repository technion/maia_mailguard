<div align="center">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="spamreportheader" align="center">{$lang.header_spam_score}</td>
<td class="spamreportheader" align="center">{$lang.header_rule_triggered}</td>
<td class="spamreportheader" align="center">{$lang.header_explanation}</td>
</tr>
{section name=rloop loop=$spamreport_rows}
<tr>
<td class="spamreport" align="center">{$spamreport_rows[rloop].rule_score}</td>
<td class="spamreport" align="left">{$spamreport_rows[rloop].rule_name}</td>
{if strlen($spamreport_rows[rloop].description) > 0}
<td class="spamreport" align="left">{$spamreport_rows[rloop].description}</td>
{else}
<td class="spamreport" align="left">{$lang.text_no_description}</td>
{/if}
</tr>
{/section}
</table>
</div>