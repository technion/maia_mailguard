<div id="misc_settings" align="center">
  {form action="xsettings.php$sid" name="settings"}
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_miscellaneous}</td>
</tr>

{if !$domain_user && ($reminder_threshold_count > 0)}
   {if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
   {else}
	   {assign var="atleastone" value="1"}
   {/if}

<tr>
<td class="menubody" align="left">{$lang.text_reminders}</td>
<td class="menubody" align="left">
<input type="radio" name="reminder" value="yes" {$rm_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="reminder" value="no" {$rm_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

{if $enable_charts}

<tr>
<td class="menubody" align="left">{$lang.text_charts}</td>
<td class="menubody" align="left">
<input type="radio" name="charts" value="yes" {$ch_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="charts" value="no" {$ch_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

{if $enable_spamtraps}
<tr>
<td class="menubody" align="left">{$lang.text_spamtrap}</td>
<td class="menubody" align="left">
<input type="radio" name="spamtrap" value="yes" {$st_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="spamtrap" value="no" {$st_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

<tr>
<td class="menubody" align="left">{$lang.text_auto_whitelist}</td>
<td class="menubody" align="left">
<input type="radio" name="auto_whitelist" value="yes" {$wl_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="auto_whitelist" value="no" {$wl_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_items_per_page}</td>
<td class="menubody" align="left"><input type="text" name="items_per_page" size="5" value="{$items_per_page}"></td>
</tr>

<tr>
<td class="menubody" align="left">{if $domain_user}{$lang.text_domain_digest_interval}{else}{$lang.text_digest_interval}{/if}</td>
<td class="menubody" align="left"><input type="text" name="digest_interval" size="5" value="{$quarantine_digest_interval}"></td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_language}</td>
<td class="menubody" align="left"><select name="language">
{foreach from=$opt_lang key=abbrev item=language_option}
<option value="{$abbrev}" {if $abbrev == $language}SELECTED{/if}>{$language_option}</option>
{/foreach}
</select>
</tr>

<tr>
<td class="menubody" align="left">{if $domain_user}{$lang.text_domain_theme}{else}{$lang.text_theme}{/if}</td>
<td class="menubody" align="left">
<select name="theme_id">
{foreach from=$themes key=key item=value}
<option value="{$key}" {if $key == $theme_id}SELECTED{/if}>{$value}</option>
{/foreach}
</select>
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_truncate_subject}</td>
<td class="menubody" align="left">
<input type="text" name="truncate_subject" value="{$truncate_subject}" size="20">
</td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_truncate_email}</td>
<td class="menubody" align="left">
<input type="text" name="truncate_email" value="{$truncate_email}" size="20">
</td>
</tr>

<tr><td colspan="2" class="menulight">&nbsp;</td></tr>


<tr>
<td class="hambody3" align="left">{$lang.text_cache_ham_question}</td>
<td class="hambody3" align="left">
<input type="hidden" name="domain_id" value="{$domain_id}">
<input type="radio" name="discard_ham" value="N" {if $discard_ham == 'N'}checked{/if}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="discard_ham" value="Y" {if $discard_ham == 'Y'}checked{/if}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{if $domain_user}
{if $system_enable_user_autocreation}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
<tr>
<td class="hambody3" align="left">{$lang.text_enable_user_autocreation}</td>
<td class="hambody3" align="left">
<input type="radio" name="enable_user_autocreation" value="Y" {if $enable_user_autocreation == 'Y'}checked{/if}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N" {if $enable_user_autocreation == 'N'}checked{/if}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}
{/if}


<tr>
<td colspan="2" align="center" class="menubody">
<input type="submit" name="update_misc" value="{$lang.button_update_misc}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</td>
</tr>

</table>
</form>
</div>