{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/config.css">
{/capture}

{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xdomainsettings.php{$sid}" name="domainsettings">
<input type="hidden" name="domain_id" value="{$domain_id}">

<input type="hidden" name="policy" value="{$policy_id}">

<div class="config_table panel1 outy">
<div class="config_header panel3 outy">{$lang.header_domain}:&nbsp;{$address}
<font size="3"><a href="adminhelp.php#domain_settings{$sid}" target="new">[?]</a></font></div>


{assign var="atleastone" value="1"}

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_virus_scanning}</span>
<span class="virus1 config_value">
<input type="radio" name="viruses" value="yes" {$bv_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="viruses" value="no" {$bv_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_detected_viruses}</span>
<span class="virus1 config_value">
<input type="radio" name="virus_destiny" value="label" {$v_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="quarantine" {$v_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="discard" {$v_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</span>
</div>

<div>&nbsp;</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_spam_filtering}</span>
<span class="spam1 config_value">
<input type="radio" name="spam" value="yes" {$bs_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="spam" value="no" {$bs_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_detected_spam}</span>
<span class="spam1 config_value">
<input type="radio" name="spam_destiny" value="label" {$s_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="quarantine" {$s_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="discard" {$s_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_prefix_subject}?</span>
<span class="spam1 config_value">
<input type="radio" name="modify_subject" value="yes" {$sms_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="modify_subject" value="no" {$sms_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_add_spam_header} >= </span>
<span class="spam1 config_value">
<input type=text size=7 name=level1 value="{$level1|string_format:"%1.3f"}">
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_consider_mail_spam} >= </span>
<span class="spam1 config_value">
<input type=text size=7 name=level2 value="{$level2|string_format:"%1.3f"}">
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_quarantine_spam} >= </span>
<span class="spam1 config_value">
<input type=text size=7 name=level3 value="{$level3|string_format:"%1.3f"}">
</span>
</div>


<div>&nbsp;</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_attachment_filtering}</span>
<span class="attachment1 config_value">
<input type="radio" name="banned" value="yes" {$bb_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="banned" value="no" {$bb_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_mail_with_attachments}</span>
<span class="attachment1 config_value">
<input type="radio" name="banned_destiny" value="label" {$b_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="quarantine" {$b_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="discard" {$b_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</span>
</div>

<div>&nbsp;</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_bad_header_filtering}</span>
<span class="header1 config_value">
<input type="radio" name="headers" value="yes" {$bh_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="headers" value="no" {$bh_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
</span>
</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_mail_with_bad_headers}</span>
<span class="header1 config_value">
<input type="radio" name="headers_destiny" value="label" {$h_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="quarantine" {$h_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="discard" {$hl_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</span>
</div>

<div>&nbsp;</div>

<div class="config_row panel1 inny"><span class="config_key">{$lang.text_cache_ham_question}</span>
<span class="ham1 config_value">
<input type="radio" name="discard_ham" value="cache" {$dh_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="discard_ham" value="discard" {$dh_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</span>
</div>
{if $system_enable_user_autocreation}
<div class="config_row panel1 inny"><span class="config_key">{$lang.text_enable_user_autocreation}</span>
<span class="ham1 config_value">
<select name="theme_id">
{foreach from=$themes key=key item=value}
<option value="{$key}" {if $key == $theme_id}SELECTED{/if}>{$value}</option>
{/foreach}
</select>
</span>
</div>
{/if}
<div>&nbsp;</div>
<div class="config_row panel1 inny"><span class="config_key">{$lang.text_domain_theme}</span>
<span class="ham1 config_value">
<input type="radio" name="enable_user_autocreation" value="yes" {$ua_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="no" {$ua_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</span>
</div>

<div class="config_submit">
<input type="submit" name="update_domain" value="{$lang.button_update_domain}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</div>

</div>

{if $super && !$system_default}

<div class="panel1 config_table outy"> 

<div class="config_header panel3 outy">{$lang.header_admins}&nbsp;
<a href="adminhelp.php#administrators{$sid}" target="new">[?]</a></div>

{if $admins}
    <div class="config_row panel2 outy"><span class="config_key">{$lang.header_revoke}</span>
    <span class="panel2 config_value">{$lang.header_admin_name}</span>
    </div>
    {foreach from=$admins item=admin}
        <div class="config_row panel1 inny"><span class="config_key">
        <input type="checkbox" name="{$admin.var_name}" value="{$admin.id}">
        </span>
        <span class="config_value panel1">
        {$admin.name}
        </span>
        </div>
    {/foreach}
    <div class="config_submit panel1">
    <input type="submit" name="revoke" value="{$lang.button_revoke}">    
    </div>
{else}
    <div class="panel1">{$lang.text_no_admins}</div>
{/if}

</div>


<div class="config_table panel1 outy">


<div class="config_header panel3 outy">{$lang.header_add_administrator}&nbsp;
<font size="3"><a href="adminhelp.php#add_administrator{$sid}" target="new">[?]</a></font>
</div>

{if $add_admins}
    <div class="config_single">
    <select multiple name="administrators[]" size="5">
    {foreach from=$add_admins item=admin}
        <option value="{$admin.id}">{$admin.name}</option>
    {/foreach}
    </select>
    </div>
    <div class="config_submit">
    <input type="submit" name="grant" value="{$lang.button_grant}">
    </div>
    
{else}
    <div class="panel1">{$lang.text_no_available_admins}</div>
{/if}

</div>

{/if}

</form>
<div style="clear: both;">&nbsp;</div>

<div align="center">
<a href="admindomains.php{$sid}">[{$lang.link_admin_domains}]</a>
</div>

{/capture}
{include file="container.tpl"}
