<div id="misc_settings"  class="styledform ui-widget-content">
  {form action="xsettings.php$sid" name="miscsettings"}
   <fieldset>
  <legend>{$lang.header_miscellaneous}</legend>
<ol>

{if !$domain_user && ($reminder_threshold_count > 0)}
<li><label>{$lang.text_reminders}</label>
<input type="radio" name="reminder" value="yes" {$rm_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="reminder" value="no" {$rm_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>
{/if}

{if $enable_charts}
<li><label>{$lang.text_charts}</label>
<input type="radio" name="charts" value="yes" {$ch_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="charts" value="no" {$ch_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>
{/if}

{if $enable_spamtraps}
<li><label>{$lang.text_spamtrap}</label>
<input type="radio" name="spamtrap" value="yes" {$st_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="spamtrap" value="no" {$st_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>
{/if}

<li><label>{$lang.text_auto_whitelist}</label>
<input type="radio" name="auto_whitelist" value="yes" {$wl_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="auto_whitelist" value="no" {$wl_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>

<li>
<label>{$lang.text_items_per_page}</label>
<input type="text" name="items_per_page" size="5" value="{$items_per_page}">
</li>

<li>
<label>{if $domain_user}{$lang.text_domain_digest_interval}{else}{$lang.text_digest_interval}{/if}</label>
<input type="text" name="digest_interval" size="5" value="{$quarantine_digest_interval}">
</li>

<li>
<label>{$lang.text_language}</label>
<select name="language">
{foreach from=$opt_lang key=abbrev item=language_option}
<option value="{$abbrev}" {if $abbrev == $language}SELECTED{/if}>{$language_option}</option>
{/foreach}
</select>
</li>

<li>
<label>{if $domain_user}{$lang.text_domain_theme}{else}{$lang.text_theme}{/if}</label>
<select name="theme_id">
{foreach from=$themes key=key item=value}
<option value="{$key}" {if $key == $theme_id}SELECTED{/if}>{$value}</option>
{/foreach}
</select>
</li>

<li>
<label>{$lang.text_truncate_subject}</label>
<input type="text" name="truncate_subject" value="{$truncate_subject}" size="20">
</li>

<li>
<label>{$lang.text_truncate_email}</label>
<input type="text" name="truncate_email" value="{$truncate_email}" size="20">
</li>

<li>&nbsp;</li>


<li>
<label>{$lang.text_cache_ham_question}</label>
<input type="hidden" name="domain_id" value="{$domain_id}">
<input type="radio" name="discard_ham" value="N" {if $discard_ham == 'N'}checked{/if}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="discard_ham" value="Y" {if $discard_ham == 'Y'}checked{/if}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>
{if $domain_user}
{if $system_enable_user_autocreation}
<li class="menulight">&nbsp;</li>

<li>
<label>{$lang.text_enable_user_autocreation}</label>
<input type="radio" name="enable_user_autocreation" value="Y" {if $enable_user_autocreation == 'Y'}checked{/if}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N" {if $enable_user_autocreation == 'N'}checked{/if}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>
{/if}
{/if}


<li class="submitrow">
<input type="submit" name="update_misc" value="{$lang.button_update_misc}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</li>
</ol>
</fieldset>

</form>
</div>