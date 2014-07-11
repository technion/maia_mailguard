{include file="html_head.tpl"}
<div id="messagebox">{if $message}<div  class="messagebox">{$message}</div>{/if}</div>
{if $need_to}{assign var="cacheColumns" value="8"}{else}{assign var="cacheColumns" value="7"}{/if}
{form action="list-cache.php`$msid`cache_type=$cache_type" name="cache"}

{literal}
<SCRIPT type="text/javascript" Language="JavaScript">
	
	function AllSpam()
	{
		for(var i=0;i<document.cache.elements.length;i++)
		{
		if(document.cache.elements[i].type == "radio" && document.cache.elements[i].id.search('spam') > -1)
		{
			document.cache.elements[i].checked = true;
		}
		}
		document.cache.CheckAllHam.checked = false
		document.cache.CheckAllDelete.checked = false
	
	}
	
	function AllHam()
	{
		for(var i=0;i<document.cache.elements.length;i++)
		{
		if(document.cache.elements[i].type == "radio" && document.cache.elements[i].id.search('ham') > -1)
		{
			document.cache.elements[i].checked = true;
		}
		}
		document.cache.CheckAllSpam.checked = false
		document.cache.CheckAllDelete.checked = false
	
	}
	
	function AllDelete()
	{
		for(var i=0;i<document.cache.elements.length;i++)
		{
		if(document.cache.elements[i].type == "radio" && document.cache.elements[i].id.search('delete') > -1)
		{
			document.cache.elements[i].checked = true;
		}
		}
		document.cache.CheckAllSpam.checked = false
		document.cache.CheckAllHam.checked = false
	
	}
	
</SCRIPT>
{/literal}
<div align="center">
<table id="cachelist" border="0" cellspacing="2" cellpadding="2" width="100%">

<tr>
<th class="{$banner_class}" colspan="{$cacheColumns}" align="center">
{$header_text} {* ( {$data.from} - {$data.to} {$lang.text_of} {$data.numrows} ) *}
</th>
</tr>  {* pager stuff *}
<tr>
<td class="{$header_class}" colspan="{$cacheColumns}" align="center">
<input type="submit" name="submit" value="{$lang.button_confirm}">
</td>
</tr>

{if $pages.total > 1}
<tr>
<td class="{$body_class}" colspan="{$cacheColumns}" align="center">
{$links}
</td>
</tr>
{/if}
{* end of pager stuff *}

<tr>
<td class="{$header_class}" align="center">
{if $cache_type == 'virus'}
{$lang.text_virus}
{elseif $cache_type == 'attachment'}
{$lang.text_file_name}
{else}
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.score}">{$lang.text_score}</a>
{/if}
</td>
<td class="{$header_class}" align="center" width="150">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.date}">{$lang.text_received}</a></td>
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.from}">{$lang.text_from}</a></td>
{if $need_to}
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.to}">{$lang.text_to}</a></td>
{/if}
<td class="{$header_class}" align="center">
<a href="list-cache.php{$msid}cache_type={$cache_type}&amp;sort={$sortby.subject}">{$lang.text_subject}</a></td>
 <td class="{$header_class}" align="center"><input type=radio name="CheckAllSpam" value="All Spam" onClick="if (this.checked) AllSpam(); return false;" {if $def_rb == 'spam'}checked{/if}>{$lang.text_spam}</td>
<td class="{$header_class}" align="center"> <input type=radio name="CheckAllHam" value="All Ham" onClick="if (this.checked) AllHam(); return false;" {if $def_rb == 'ham'}checked{/if}>{$lang.text_ham}</td>
<td class="{$header_class}" align="center"> <input type=radio name="CheckAllDelete" value="All Delete" onClick="if (this.checked) AllDelete(); return false;" {if $def_rb == 'delete'}checked{/if}>{$lang.text_delete}</td>
</tr>
{section name=hamloop loop=$row}
{strip}

<tr class="{cycle values="$body_class,$alt_body_class" }" id="row_{$row[hamloop].id}">
<td align="center"><b>
{if $cache_type == 'virus'}
{$row[hamloop].virus_name}
{elseif $cache_type == 'attachment'}
{$row[hamloop].file}
{else}
{$row[hamloop].score}
{/if}
</b></td>
<td align="center">
<span id="received_date{$row[hamloop].id}" class="HelpTipAnchor">{$row[hamloop].received_date|truncate:$truncate_subject:"...":true|escape:'UTF-8'}</span>
<span id="tip_received_date{$row[hamloop].id}" class="HelpTip">  {$row[hamloop].received_date|escape:"javascript"|escape:'UTF-8'}</span>
</td>

<td align="center">
<span id="sender{$row[hamloop].id}" class="HelpTipAnchor">{$row[hamloop].sender_email|mb_truncate:$truncate_email:"...":'UTF-8':true|escape:'UTF-8'}</span>
<span id="tip_sender{$row[hamloop].id}" class="HelpTip">{$row[hamloop].sender_email|escape:"javascript"|escape:'UTF-8'}</span>
</td>
{if $need_to}
<td align="center">
<span id="recipient{$row[hamloop].id}" class="HelpTipAnchor">{foreach from=$row[hamloop].recipient_email item=recip_to}
		{$recip_to|mb_truncate:$truncate_email:"...":'UTF-8':true|escape:'UTF-8'}<br>
		{/foreach}</span>
<span id="tip_recipient{$row[hamloop].id}" class="HelpTip">{foreach from=$row[hamloop].recipient_email item=recip_to}{$recip_to|escape:'UTF-8'}<br>{/foreach}</span>
</td>
{/if}
<td align="left">
<a id="link_{$row[hamloop].id}" class="thickbox HelpTipAnchor" href="view.php{$msid}id={$row[hamloop].id}&amp;cache_type={$cache_type}&amp;height=350&amp;width=700">
{$row[hamloop].subject|mb_truncate:$truncate_subject:"...":'UTF-8':true|escape:'UTF-8'}
</a><span id="tip_link_{$row[hamloop].id}" class="HelpTip">{$row[hamloop].subject|escape:'UTF-8'}</span></td>


<td align="center">
<input type="radio" id="spam_{$row[hamloop].id}" name="cache_item[multiple][{$row[hamloop].id}]" value="spam" {if $def_rb == 'spam'}checked{/if}>
</td>

<td align="center">
<input type="radio" id="ham_{$row[hamloop].id}" name="cache_item[multiple][{$row[hamloop].id}]" value="ham" {if $def_rb == 'ham'}checked{/if}>
</td>

<td align="center">
<input type="radio" id="delete_{$row[hamloop].id}" name="cache_item[multiple][{$row[hamloop].id}]" value="delete" {if $def_rb == 'delete'}checked{/if}>
</td>

</tr>

{/strip}
{/section}

{* pager stuff *}
<tr>
<td class="{$header_class}" colspan="{$cacheColumns}" align="center">
<input type="submit" name="submit" value="{$lang.button_confirm}">
</td>
</tr>
{if $pages.total > 1}
<tr>
<td class="{$body_class}" colspan="{$cacheColumns}" align="center">
{$links}
</td>
</tr>
{/if}
{* end of pager stuff *}

</table>
</div>

<div align="center">
<a href="welcome.php{$msid}">[{$lang.link_welcome}]</a>
</div>

</form>
{include file="html_foot.tpl"}
