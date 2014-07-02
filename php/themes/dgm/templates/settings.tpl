{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}
<form method="post" action="settings.php{$sid}" name="settings"> 	 
 <input type="hidden" name="user_id" value="{$euid}">

{if $address_id === 0}
    <table class="panel1 outy">

        <tr>
        <td class="menuheader" align="center" colspan="2">{$lang.header_addresses}</td>
        </tr>

  {if !$domain_user}

        <tr>
        <td class="panel1" align="center">{$lang.text_primary}</td>
        <td class="panel1" align="right">
        <a href="settings.php{$msid}addid={$primary_email_id}">
        {$address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a></td>
        </tr>
    {foreach from=$user_addr key=key item=row}
        <tr>
        <td class="panel1" align="center"><input type="submit"
                                                   name="make_primary_{$row.addid}"
                                                   value=" {$lang.button_make_primary} ">
        </td>
        <td class="panel1" align="right">
        <a href="settings.php{$msid}addid={$row.addid}">{$row.address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a></td>
        </tr>
    {/foreach}
        <tr><td colspan="2" class="menulight">&nbsp;</td></tr>
    {if $enable_address_linking}
        <tr>
        <td class="panel1" align="left">{$login}:</td>
        <td class="panel1" align="left">
        <input type="text" name="login" value="" size="40"></td>
        </tr>
        <tr>
        <td class="panel1" align="left">{$lang.text_password}:</td>
        <td class="panel1" align="left">
        <input type="password" name="authpass" value="" size="40"></td>
        </tr>
        <tr><td colspan="2" class="menulight">&nbsp;</td></tr>
        <tr>
        <td colspan="2" align="center" class="panel1">
        <input type="submit" name="add_email_address" value="{$lang.button_add_email_address}">&nbsp;&nbsp;
        <input type="reset" name="reset" value="{$lang.button_reset}">
        </td>
        </tr>
    {/if} {* end if $enable_address_linking *}
  {else} {* if !$domain_user *}
    {foreach from=$user_addr key=key item=row}
        <tr>
        <td class="panel1" colspan="2" align="right">
        <a href="settings.php{$msid}addid={$row.addid}">{$row.address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a></td>
        </tr>
   {/foreach}
   {if !$addid}
        <tr>
        <td class="panel1" colspan="2" align="center">{$lang.text_no_addresses_linked}</td>
        </tr>
   {/if}
  {/if} {* end if !$domain_user *}

  </table>

  {if !$domain_user && $auth_method=="internal"}
    <p>&nbsp;</p>
    <table class="panel1 outy">
    
    <tr>
    <td class="menuheader" align="center" colspan="2">{$lang.header_login_info}</td>
    </tr>
    {if $enable_username_changes || $is_superadmin }
    <tr>
    <td class="panel1" align="left">{$lang.text_new_login_name}:</td>
    <td class="panel1" align="left"><input type="text" name="new_login_name" value="{$user_name}" size="40"></td>
    </tr>
    {else}
    <input type="hidden" name="new_login_name" value="{$user_name}">
    {/if}
    <tr>
    <td class="panel1" align="left">{$lang.text_new_password}:</td>
    <td class="panel1" align="left"><input type="password" name="new_password" value="" size="40"></td>
    </tr>
    
    <tr>
    <td class="panel1" align="left">{$lang.text_confirm_new_password}:</td>
    <td class="panel1" align="left"><input type="password" name="confirm_new_password" value="" size="40"></td>
    </tr>
    
    <tr><td colspan="2" class="menulight">&nbsp;</td></tr>
    
    <tr>
    <td colspan="2" align="center" class="panel1">
    <input type="submit" name="change_login_info" value="{$lang.button_change_login_info}">
    </td>
    </tr>
    
    </table>
  {/if} {* end if !$domain_user && $auth_method=="internal" *}

<p>&nbsp;</p>

<table class="panel1 outy">

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
<td class="panel1" align="left">{$lang.text_reminders}</td>
<td class="panel1" align="left">
<input type="radio" name="reminder" value="yes" {$rm_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="reminder" value="no" {$rm_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

{if $enable_charts}

<tr>
<td class="panel1" align="left">{$lang.text_charts}</td>
<td class="panel1" align="left">
<input type="radio" name="charts" value="yes" {$ch_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="charts" value="no" {$ch_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

{if $enable_spamtraps}
<tr>
<td class="panel1" align="left">{$lang.text_spamtrap}</td>
<td class="panel1" align="left">
<input type="radio" name="spamtrap" value="yes" {$st_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="spamtrap" value="no" {$st_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

<tr>
<td class="panel1" align="left">{$lang.text_auto_whitelist}</td>
<td class="panel1" align="left">
<input type="radio" name="auto_whitelist" value="yes" {$wl_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="auto_whitelist" value="no" {$wl_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="panel1" align="left">{$lang.text_items_per_page}</td>
<td class="panel1" align="left"><input type="text" name="items_per_page" size="5" value="{$items_per_page}"></td>
</tr>

<tr>
<td class="menubody" align="left">{if $domain_user}{$lang.text_domain_digest_interval}{else}{$lang.text_digest_interval}{/if}</td>
<td class="menubody" align="left"><input type="text" name="digest_interval" size="5" value="{$quarantine_digest_interval}"></td>
</tr>

<tr>
<td class="panel1" align="left">{$lang.text_language}</td>
<td class="panel1" align="left"><select name="language">
{foreach from=$opt_lang key=abbrev item=language_option}
<option value="{$abbrev}" {if $abbrev == $language}SELECTED{/if}>{$language_option}</option>
{/foreach}
</select>
</tr>

<tr>
<td class="panel1" align="left">{$lang.text_charset}</td>
<td class="panel1" align="left"><input type="text" name="charset" value="{$charset}" size="20"></td>
</tr>

<tr>
<td class="panel1" align="left">{$lang.text_theme}</td>
<td class="panel1" align="left">
<select name="theme_id">
{foreach from=$themes key=key item=value}
<option value="{$key}" {if $key == $theme_id}SELECTED{/if}>{$value}</option>
{/foreach}
</select>
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{/if}

<tr>
<td colspan="2" align="center" class="panel1">
<input type="submit" name="update_misc" value="{$lang.button_update_misc}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</td>
</tr>

</table>

{else}

<input type="hidden" name="policy" value="{$policy_id}">

<table class="panel1 outy">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_address}: {$address}</td>
</tr>

      {assign var="atleastone" value="1"}
<tr>
<td class="virus1 inny" align="left">{$lang.text_virus_scanning}</td>
<td class="virus1 inny" align="left">
	{if $user_virus_scanning}
<input type="radio" name="viruses" value="yes" {$bv_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="viruses" value="no" {$bv_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
	{else}
		{if $bv_y_checked}
			{$lang.text_enabled}
		{else}
			{$lang.text_disabled}
		{/if}
	{/if}
</td>
</tr>

<tr>
<td class="virus1 inny" align="left">{$lang.text_detected_viruses}</td>
<td class="virus1 inny" align="left">
<input type="radio" name="virus_destiny" value="label" {$v_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="quarantine" {$v_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="discard" {$v_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{else}
	   {assign var="atleastone" value="1"}
{/if}

<tr>
<td class="spam1 inny" align="left">{$lang.text_spam_filtering}</td>
<td class="spam1 inny" align="left">
	{if $user_spam_filtering}
<input type="radio" name="spam" value="yes" {$bs_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="spam" value="no" {$bs_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
	{else}
		{if $bs_y_checked}
			{$lang.text_enabled}
		{else}
			{$lang.text_disabled}
		{/if}
	{/if}
</td>
</tr>

<tr>
<td class="spam1 inny" align="left">{$lang.text_detected_spam}</td>
<td class="spam1 inny" align="left">
<input type="radio" name="spam_destiny" value="label" {$s_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="quarantine" {$s_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="discard" {$s_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="spam1 inny" align="left">{$lang.text_prefix_subject}?</td>
<td class="spam1 inny" align="left">
<input type="radio" name="modify_subject" value="yes" {$sms_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="modify_subject" value="no" {$sms_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="spam1 inny" align="left">{$lang.text_add_spam_header} >= </td>
<td class="spam1 inny" align="left">
<input type=text size=7 name=level1 value="{$level1|string_format:"%1.3f"}">
</td>
</tr>

<tr>
<td class="spam1 inny" align="left">{$lang.text_consider_mail_spam} >= </td>
<td class="spam1 inny" align="left">
<input type=text size=7 name=level2 value="{$level2|string_format:"%1.3f"}">
</td>
</tr>

<tr>
<td class="spam1 inny" align="left">{$lang.text_quarantine_spam} >= </td>
<td class="spam1 inny" align="left">
<input type=text size=7 name=level3 value="{$level3|string_format:"%1.3f"}">
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{else}
	   {assign var="atleastone" value="1"}
{/if}

<tr>
<td class="attachment1 inny" align="left">{$lang.text_attachment_filtering}</td>
<td class="attachment1 inny" align="left">
	{if $user_banned_files_checking}
<input type="radio" name="banned" value="yes" {$bb_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="banned" value="no" {$bb_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
	{else}
		{if $bb_y_checked}
			{$lang.text_enabled}
		{else}
			{$lang.text_disabled}
		{/if}
	{/if}
</td>
</tr>

<tr>
<td class="attachment1 inny" align="left">{$lang.text_mail_with_attachments}</td>
<td class="attachment1 inny" align="left">
<input type="radio" name="banned_destiny" value="label" {$b_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="quarantine" {$b_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="discard" {$b_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{else}
   {assign var="atleastone" value="1"}
{/if}

<tr>
<td class="header1 inny" align="left">{$lang.text_bad_header_filtering}</td>
<td class="header1 inny" align="left">
	{if $user_bad_header_checking}
<input type="radio" name="headers" value="yes" {$bh_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="headers" value="no" {$bh_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
	{else}
		{if $bh_y_checked}
			{$lang.text_enabled}
		{else}
			{$lang.text_disabled}
		{/if}
	{/if}
</td>
</tr>

<tr>
<td class="header1 inny" align="left">{$lang.text_mail_with_bad_headers}</td>
<td class="header1 inny" align="left">
<input type="radio" name="headers_destiny" value="label" {$h_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="quarantine" {$h_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="discard" {$h_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{/if}

<tr>
<td colspan="2" align="center" class="panel1">
<input type="submit" name="upone" value=" {$lang.button_update_address} ">
<input type="submit" name="upall" value=" {$lang.button_update_all_addresses} ">
<input type="reset" name="reset" value=" {$lang.button_reset} ">
</td>
</tr>

</table>
{/if}
<br>
</form>

{/capture}
{capture assign="headercontent"}
{if $message}
<div align="center">
{$message}
</div>
{/if}
{/capture}


{include file="container.tpl"}
