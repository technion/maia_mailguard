{include file="html_head.tpl"}

{form action="xdomainsettings.php$sid" name="domainsettings"}
<input type="hidden" name="domain_id" value="{$domain_id}">

<input type="hidden" name="policy" value="{$policy_id}">

<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_domain}: {$address}&nbsp;
<font size="3"><a href="adminhelp.php#domain_settings{$sid}" target="new">[?]</a></font>
</tr>

{assign var="atleastone" value="1"}

<tr>
<td class="virusbody3" align="left">{$lang.text_virus_scanning}</td>
<td class="virusbody3" align="left">
<input type="radio" name="viruses" value="yes" {$bv_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="viruses" value="no" {$bv_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="virusbody3" align="left">{$lang.text_detected_viruses}</td>
<td class="virusbody3" align="left">
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
<td class="spambody3" align="left">{$lang.text_spam_filtering}</td>
<td class="spambody3" align="left">
<input type="radio" name="spam" value="yes" {$bs_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="spam" value="no" {$bs_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="spambody3" align="left">{$lang.text_detected_spam}</td>
<td class="spambody3" align="left">
<input type="radio" name="spam_destiny" value="label" {$s_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="quarantine" {$s_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="discard" {$s_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="spambody3" align="left">{$lang.text_prefix_subject}?</td>
<td class="spambody3" align="left">
<input type="radio" name="modify_subject" value="yes" {$sms_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="modify_subject" value="no" {$sms_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="spambody3" align="left">{$lang.text_add_spam_header} >= </td>
<td class="spambody3" align="left">
<input type=text size=7 name=level1 value="{$level1|string_format:"%1.3f"}">
</td>
</tr>

<tr>
<td class="spambody3" align="left">{$lang.text_consider_mail_spam} >= </td>
<td class="spambody3" align="left">
<input type=text size=7 name=level2 value="{$level2|string_format:"%1.3f"}">
</td>
</tr>

<tr>
<td class="spambody3" align="left">{$lang.text_quarantine_spam} >= </td>
<td class="spambody3" align="left">
<input type=text size=7 name=level3 value="{$level3|string_format:"%1.3f"}">
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{else}
{assign var="atleastone" value="1"}
{/if}

<tr>
<td class="banned_filebody3" align="left">{$lang.text_attachment_filtering}</td>
<td class="banned_filebody3" align="left">
<input type="radio" name="banned" value="yes" {$bb_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="banned" value="no" {$bb_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="banned_filebody3" align="left">{$lang.text_mail_with_attachments}</td>
<td class="banned_filebody3" align="left">
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
<td class="bad_headerbody3" align="left">{$lang.text_bad_header_filtering}</td>
<td class="bad_headerbody3" align="left">
<input type="radio" name="headers" value="yes" {$bh_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="headers" value="no" {$bh_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="bad_headerbody3" align="left">{$lang.text_mail_with_bad_headers}</td>
<td class="bad_headerbody3" align="left">
<input type="radio" name="headers_destiny" value="label" {$h_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="quarantine" {$h_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="discard" {$h_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</td>
</tr>

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{/if}

<tr>
<td class="hambody3" align="left">{$lang.text_cache_ham_question}</td>
<td class="hambody3" align="left">
<input type="radio" name="discard_ham" value="cache" {$dh_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="discard_ham" value="discard" {$dh_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{if $system_enable_user_autocreation}
<tr>
<td class="hambody3" align="left">{$lang.text_enable_user_autocreation}</td>
<td class="hambody3" align="left">
<input type="radio" name="enable_user_autocreation" value="yes" {$ua_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="no" {$ua_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</td>
</tr>
{/if}

{if $atleastone}
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
{/if}
<tr>
<td class="hambody3" align="left">{$lang.text_domain_theme}</td>
<td class="hambody3" align="left"><select name="theme_id">
{foreach from=$themes key=key item=value}
<option value="{$key}" {if $key == $theme_id}SELECTED{/if}>{$value}</option>
{/foreach}
</select>
</td>
</tr>
<tr>
<td colspan="2" align="center" class="menubody">
<input type="submit" name="update_domain" value="{$lang.button_update_domain}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</td>
</tr>

</table></div>

{if $super && !$system_default}

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_admins}&nbsp;
<font size="3"><a href="adminhelp.php#administrators{$sid}" target="new">[?]</a></font>
</tr>

{if $admins}
    <tr>
    <td class="menuheader2" align="center">{$lang.header_revoke}</td>
    <td class="menuheader2" align="center">{$lang.header_admin_name}</td>
    </tr>
    {foreach from=$admins item=admin}
        <tr>
        <td class="menubody" align="center">
        <input type="checkbox" name="{$admin.var_name}" value="{$admin.id}">
        </td>
        <td class="menubody" align="center">
        {$admin.name}
        </td>
        </tr>
    {/foreach}
    <tr>
    <td class="menubody" align="center" colspan="2">
    <input type="submit" name="revoke" value="{$lang.button_revoke}">
    </td>
    </tr>
{else}
    <tr><td class="menubody" align="center" colspan="2">{$lang.text_no_admins}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center">{$lang.header_add_administrator}&nbsp;
<font size="3"><a href="adminhelp.php#add_administrator{$sid}" target="new">[?]</a></font>
</td>
</tr>

{if $add_admins}
    <tr>
    <td class="menubody" align="center">
    <select multiple name="administrators[]" size="5">
    {foreach from=$add_admins item=admin}
        <option value="{$admin.id}">{$admin.name}</option>
    {/foreach}
    </select>
    </td>
    </tr>
    <tr>
    <td class="menubody" align="center">
    <input type="submit" name="grant" value="{$lang.button_grant}">
    </td>
    </tr>
{else}
    <tr><td class="menubody" align="center">{$lang.text_no_available_admins}</td></tr>
{/if}

</table></div>

{/if}

</form>
<p>&nbsp;</p>

<div align="center">
<a href="admindomains.php{$sid}">[{$lang.link_admin_domains}]</a>
</div>

{include file="html_foot.tpl"}
