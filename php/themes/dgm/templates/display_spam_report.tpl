<div class="spam_report_table clearfix">
<div class="spam_report_row">
<span class="spam_report_header">{$lang.header_spam_score}</span>
<span class="spam_report_header">{$lang.header_rule_triggered}</span>
<span class="spam_report_header">{$lang.header_explanation}</span>
</div>
{section name=rloop loop=$spamreport_rows}
<div class="spam_report_row">
<span class="spam_report_score" align="center">{$spamreport_rows[rloop].rule_score}</span>
<span class="spam_report_name" align="left">{$spamreport_rows[rloop].rule_name}</span>
{if strlen($spamreport_rows[rloop].description) > 0}
<span class="spam_report_description" align="left">{$spamreport_rows[rloop].description}</span>
{else}
<span class="spam_report_description" align="left">{$lang.text_no_description}</span>
{/if}
</div>
{/section}
</div>