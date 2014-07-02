{include file="html_head.tpl"}
<div id="messagebox">
{if $message}
<div class="messagebox" align="center">
{$message}
</div>
{/if}
</div>
<table width="90%">
<tr>
<td colspan="2">
<h1>{$lang.text_welcome_greeting}</h1>
</td></tr>
<tr>
{if $firsttime}
<td colspan="2">
{$lang.text_welcome_first_time}</td>
</tr>
<tr>
{/if}
<td colspan="2">
<p>
{$lang.text_welcome_intro}
</td>
</tr>
<tr>
<td  valign="top">
<div id="protectioncontrol">
   {form name="protectionlevel" action="welcome.php$sid"}
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td class="menubanner" align="center">
   {$lang.text_welcome_current_level}<br><center>{$lang.radio_protection.$protection}</center></td></tr>
<tr><td><input type="radio" name="protection_level" value="off" {if $protection == "off"}checked{/if}>{$lang.radio_protection.off}</td></tr>
<tr><td><input type="radio" name="protection_level" value="low" {if $protection == "low"}checked{/if}>{$lang.radio_protection.low}</td></tr>
<tr><td><input type="radio" name="protection_level" value="medium" {if $protection == "medium"}checked{/if}>{$lang.radio_protection.medium}</td></tr>
<tr><td><input type="radio" name="protection_level" value="high" {if $protection == "high"}checked{/if}>{$lang.radio_protection.high}</td></tr>
   {if $protection == "custom"}<tr><td>{$lang.text_welcome_custom_level}</td></tr>{/if}   
<tr><td><input type="submit" name="change_protection" value="{$lang.button_change_protection}"></td></tr>
   
</table>
   </form>

</div>

</td>
<td>
{* here comes the quick view of cache contents *}
<div id="quickview">
{form action="welcome.php$sid" name="cache"}
<input type="hidden" name="maxitemid" value="{$maxitemid}">
<table width="100%" border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="menubanner" align="center" colspan="2">{$lang.header_cache_contents}</td>
</tr>


<tr><td class="hambody" align="center">
<a href="list-cache.php{$msid}cache_type=ham">{if $use_icons}<img src="{$template_dir}images/ham.png" border="0" alt="{$lang.action_ham_cache}"><br>{/if}[{$lang.action_ham_cache}]</a>
</td><td class="hambody" >
{$hamtext}
</td></tr>
<tr><td class="suspected_spambody" align="center">
<a href="list-cache.php{$msid}cache_type=spam">{if $use_icons}<img src="{$template_dir}images/spam.png" border="0" alt="{$lang.action_spam_cache}"><br>{/if}[{$lang.action_spam_cache}]</a>
</td><td class="suspected_spambody" >
    {$spamtext}
</td></tr>
<tr><td class="virusbody" align="center">
<a href="list-cache.php{$msid}cache_type=virus">{if $use_icons}<img src="{$template_dir}images/virus.png" border="0" alt="{$lang.action_virus_cache}"><br>{/if}[{$lang.action_virus_cache}]</a>
</td><td class="virusbody" >
    {$virustext}
</td></tr>
<tr><td class="banned_filebody" align="center">
<a href="list-cache.php{$msid}cache_type=attachment">{if $use_icons}<img src="{$template_dir}images/banned-file.png" border="0" alt="{$lang.action_banned_cache}"><br>{/if}[{$lang.action_banned_cache}]</a>
</td><td class="banned_filebody" >
    {$bannedtext}
</td></tr>
<tr><td class="bad_headerbody" align="center">
<a href="list-cache.php{$msid}cache_type=header">{if $use_icons}<img src="{$template_dir}images/bad-header.png" border="0" alt="{$lang.action_header_cache}"><br>{/if}[{$lang.action_header_cache}]</a>
</td><td class="bad_headerbody" >
    {$headertext}
</td></tr>

<td class="menuheader" align="center" colspan=2>
<input type="submit" name="delete_all_items" value="{$lang.button_delete_all_items}">
</td>
</tr>

</table>
</form>
</div>
</td>
</tr>
<tr>
<td colspan="2">

<table align="center">
<tr>
<td class="spambody"><b>{$spam_for_user}</b> {$lang.text_welcome_spam_blocked}</td>
<td class="virusbody"><b>{$virus_for_user}</b> {$lang.text_welcome_virus_blocked}</td>
</tr>
<tr>
<td class="spambody"><b>{$spam_for_system}</b> {$lang.text_welcome_spam_blocked_system}</td>
<td class="virusbody"><b>{$virus_for_system}</b> {$lang.text_welcome_virus_blocked_system}</td>
</tr>
</table>
</td>
</tr>
</table>
{include file="html_foot.tpl"}
