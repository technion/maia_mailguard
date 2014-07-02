{include file="html_head.tpl"}
<div id="messagebox" align="center">
{if $message}
{$message}
{/if}
</div>
{if $need_to}{assign var="cacheColumns" value="6"}{else}{assign var="cacheColumns" value="5"}{/if}
<div class="ui-widget" id="cachelistwrapper">
{form action="list-cache.php`$msid`cache_type=$cache_type" name="cache"}

<div class="ui-widget-header ui-corner-top ui-table-top">
<h1>{$header_text} {* ( {$data.from} - {$data.to} {$lang.text_of} {$data.numrows} ) *}</h1>
<div class="buttonwrapper">
   <input name="submit" value="ham" type="submit" class="cache_submit_button_plain" >
   <a class="squarebutton hambutton" href="#" onclick="document.cache.submit[0].click(); return false;"><span>{$actionlang.0}</span></a>
  <input name="submit" value="spam" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton spambutton" href="#" onclick="document.cache.submit[1].click(); return false;"><span>{$actionlang.1}</span></a>
  <input name="submit" value="delete" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton deletebutton" href="#" onclick="document.cache.submit[2].click(); return false;"><span>{$actionlang.2}</span></a>
   <input name="submit" value="resend" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton resendbutton" href="#" onclick="document.cache.submit[3].click(); return false;"><span>{$lang.button_resend}</span></a>
 {if $pages.total > 1}<span class="pager">{$links}</span>{/if}
  </div>
  <div class="toggles">
  {$lang.text_toggle} <a href="#" onClick="$(cache).allCheckboxes(); return false;">All</a>, 
  <a href="#" onClick="$(cache).noCheckboxes(); return false;">None</a>,
  <a href="#" onClick="$(cache).toggleCheckboxes(); return false;">Invert</a>
  </div>
</div>
<table class="ui-list-table" id="cachelist">
<tr>
  <td class="{$header_class} list-toggle" align="center"></td>

<td class="{$header_class}" align="center">
{if $cache_type == 'virus'}
{$lang.text_virus}
{elseif $cache_type == 'attachment'}
{$lang.text_file_name}
{else}
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.score}">{$lang.text_score}</a>
{/if}
</td>
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.subject}">{$lang.text_subject}</a></td>
<td class="{$header_class}" align="center" width="150">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.date}">{$lang.text_received}</a></td>
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.from}">{$lang.text_from}</a></td>
{if $need_to}
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.to}">{$lang.text_to}</a></td>
{/if}
</tr>

{section name=hamloop loop=$row}
{strip}

<tr class="{cycle values=$body_class,$alt_body_class }" id="row_{$row[hamloop].id}">
  <td class="list-toggle" align="center">
    <input type="checkbox" name="cache_item[generic][{$row[hamloop].id}]" value="{$row[hamloop].id}">
  </td>
<td align="center"><b>
{if $cache_type == 'virus'}
{$row[hamloop].virus_name}
{elseif $cache_type == 'attachment'}
{$row[hamloop].file}
{else}
{$row[hamloop].score}
{/if}
</b></td>
<td align="left">
<a id="link_{$row[hamloop].id}" class="thickbox HelpTipAnchor" href="view.php{$msid}mail_id={$row[hamloop].id}&amp;cache_type={$cache_type}">
{$row[hamloop].subject|mb_truncate:$truncate_subject:"...":'UTF-8':true|escape:'UTF-8'}
</a><span id="tip_link_{$row[hamloop].id}"  class="HelpTip">{$row[hamloop].subject|escape:'htmlall':'UTF-8'}</span></td>
<td align="center">
<span class="HelpTipAnchor" id="received_date{$row[hamloop].id}">{$row[hamloop].received_date|truncate:$truncate_subject:"...":true|escape:'UTF-8'}</span>
<span class="HelpTip" id="tip_received_date{$row[hamloop].id}">{$row[hamloop].received_date|escape:"javascript"|escape:'UTF-8'}</span>
</td>
<td align="center">
<span class="HelpTipAnchor" id="sender{$row[hamloop].id}">{$row[hamloop].sender_email|mb_truncate:$truncate_email:"...":'UTF-8':true|escape:'UTF-8'}</span>
<span class="HelpTip" id="tip_sender{$row[hamloop].id}">{$row[hamloop].sender_email|escape:"javascript"|escape:'UTF-8'}</span>
</td>
{if $need_to}
<td align="center">
<span class="HelpTipAnchor" id ="recipient{$row[hamloop].id}">{foreach from=$row[hamloop].recipient_email item=recip_to}
		{$recip_to|mb_truncate:$truncate_email:"...":'UTF-8':true|escape:'UTF-8'}<br>
		{/foreach}</span>
<span id="tip_recipient{$row[hamloop].id}" class="HelpTip">{foreach from=$row[hamloop].recipient_email item=recip_to}{$recip_to|escape:'UTF-8'}<br>{/foreach}</span>
</td>
{/if}
</tr>

{/strip}
{/section}

</table>
<div class="ui-widget-header ui-corner-bottom">
  <div class="toggles">
   {$lang.text_toggle} <a href="#" onClick="$(cache).allCheckboxes(); return false;">All</a>, 
   <a href="#" onClick="$(cache).noCheckboxes(); return false;">None</a>,
   <a href="#" onClick="$(cache).toggleCheckboxes(); return false;">Invert</a>
   </div>
<div class="buttonwrapper">
   <input name="submit" value="ham" type="submit" class="cache_submit_button_plain" >
   <a class="squarebutton hambutton" href="#" onclick="document.cache.submit[0].click(); return false;"><span>{$lang.button_ham}</span></a>

  <input name="submit" value="spam" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton spambutton" href="#" onclick="document.cache.submit[1].click(); return false;"><span>{$lang.button_spam}</span></a> 
  <input name="submit" value="delete" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton deletebutton" href="#" onclick="document.cache.submit[2].click(); return false;"><span>{$lang.button_delete}</span></a> 
   <input name="submit" value="resend" type="submit" class="cache_submit_button_plain" >
 <a class="squarebutton resendbutton" href="#" onclick="document.cache.submit[3].click(); return false;"><span>{$lang.button_resend}</span></a> 
  {if $pages.total > 1}<span class="pager">{$links}</span>{/if}
  </div>
</div>

<div align="center">
<a href="welcome.php{$msid}">[{$lang.link_welcome}]</a>
</div>

</form>
</div>
{include file="html_foot.tpl"}