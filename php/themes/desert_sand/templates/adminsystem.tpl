{include file="html_head.tpl"}
<script type="text/javascript">
{literal}
jQuery(document).ready(function(){
	$('#form_accordion legend a').click(function() {
		$(this).parent().next().toggle('slow');
		return false;
	}).parent().next().hide();
});
{/literal} 
</script>

{form action="xadminsystem.php$sid" name="adminsystem"}
<div id="form_accordion">
<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_system_menu}</a></legend>
<ol>

<li>
<label>{$lang.text_enable_user_autocreation} <a href="adminhelp.php#enable_user_autocreation{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_user_autocreation}
<input type="radio" name="enable_user_autocreation" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_user_autocreation" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

{if $auth_method == "internal"}
<li>
<label>{$lang.text_internal_auth} <a href="adminhelp.php#internal_auth{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $internal_auth}
<input type="radio" name="internal_auth" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="internal_auth" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="internal_auth" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="internal_auth" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>
{/if}

<li>
<label>{$lang.text_enable_false_negative_management} <a href="adminhelp.php#enable_false_negative_management{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_false_negative_management}
<input type="radio" name="enable_false_negative_management" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_false_negative_management" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_false_negative_management" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_false_negative_management" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_stats_tracking} <a href="adminhelp.php#enable_stats_tracking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_stats_tracking}
<input type="radio" name="enable_stats_tracking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_tracking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_stats_tracking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_tracking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_user_virus_scanning} <a href="adminhelp.php#user_virus_scanning{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $user_virus_scanning}
<input type="radio" name="user_virus_scanning" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_virus_scanning" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_virus_scanning" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_virus_scanning" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_virus_scanning} <a href="adminhelp.php#enable_virus_scanning{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_virus_scanning}
<input type="radio" name="enable_virus_scanning" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_virus_scanning" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_virus_scanning" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_virus_scanning" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_spam_filtering} <a href="adminhelp.php#enable_spam_filtering{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_spam_filtering}
<input type="radio" name="enable_spam_filtering" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spam_filtering" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_spam_filtering" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spam_filtering" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_user_spam_filtering} <a href="adminhelp.php#user_spam_filtering{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $user_spam_filtering}
<input type="radio" name="user_spam_filtering" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_spam_filtering" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_spam_filtering" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_spam_filtering" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_banned_files_checking} <a href="adminhelp.php#enable_banned_files_checking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_banned_files_checking}
<input type="radio" name="enable_banned_files_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_banned_files_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_banned_files_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_banned_files_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_user_banned_files_checking} <a href="adminhelp.php#user_banned_files_checking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $user_banned_files_checking}
<input type="radio" name="user_banned_files_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_banned_files_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_banned_files_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_banned_files_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_bad_header_checking} <a href="adminhelp.php#enable_bad_header_checking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_bad_header_checking}
<input type="radio" name="enable_bad_header_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_bad_header_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_bad_header_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_bad_header_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_user_bad_header_checking} <a href="adminhelp.php#user_bad_header_checking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $user_bad_header_checking}
<input type="radio" name="user_bad_header_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_bad_header_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_bad_header_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_bad_header_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_spamtraps} <a href="adminhelp.php#enable_spamtraps{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_spamtraps}
<input type="radio" name="enable_spamtraps" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spamtraps" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_spamtraps" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spamtraps" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_address_linking} <a href="adminhelp.php#enable_address_linking{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_address_linking}
<input type="radio" name="enable_address_linking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_address_linking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_address_linking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_address_linking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_username_changes} <a href="adminhelp.php#enable_username_changes{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_username_changes}
<input type="radio" name="enable_username_changes" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_username_changes" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_username_changes" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_username_changes" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_enable_privacy_invasion} <a href="adminhelp.php#enable_privacy_invasion{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_privacy_invasion}
<input type="radio" name="enable_privacy_invasion" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_privacy_invasion" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_privacy_invasion" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_privacy_invasion" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_system_default_user_is_local} <a href="adminhelp.php#system_default_user_is_local{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $system_default_user_is_local}
<input type="radio" name="system_default_user_is_local" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="system_default_user_is_local" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="system_default_user_is_local" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="system_default_user_is_local" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_size_limit} <a href="adminhelp.php#size_limit{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="size_limit" size="12" value="{$size_limit}">
</li>

<li>
<label>{$lang.text_oversize_policy} <a href="adminhelp.php#oversize_policy{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $oversize_policy == "P"}
<input type="radio" name="oversize_policy" value="P" checked>&nbsp;{$lang.text_accept}&nbsp;&nbsp;
<input type="radio" name="oversize_policy" value="B">&nbsp;{$lang.text_reject}&nbsp;&nbsp;
{else}
<input type="radio" name="oversize_policy" value="P">&nbsp;{$lang.text_accept}&nbsp;&nbsp;
<input type="radio" name="oversize_policy" value="B" checked>&nbsp;{$lang.text_reject}&nbsp;&nbsp;
{/if}
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>

<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_paths}</a></legend>
<ol>
<li>
<label>{$lang.text_admin_email} <a href="adminhelp.php#admin_email{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="admin_email" size="40" value="{$admin_email}">
</li>

<li>
<label>{$lang.text_smtp_server} <a href="adminhelp.php#smtp_server{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="smtp_server" size="40" value="{$smtp_server}">
</li>

<li>
<label>{$lang.text_smtp_port} <a href="adminhelp.php#smtp_port{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="smtp_port" size="5" value="{$smtp_port}">
</li>

<li>
<label>{$lang.text_key_file} <a href="adminhelp.php#key_file{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="key_file" size="40" value="{$key_file}">
</li>

{if $auth_method == "internal"}
<li>
<label>{$lang.text_newuser_template_file} <a href="adminhelp.php#newuser_template_file{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="newuser_template_file" size="40" value="{$newuser_template_file}">
</li>
{/if}

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>


<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_reminders}</a></legend>
<ol>

<li>
<label>{$lang.text_expiry_period} <a href="adminhelp.php#expiry_period{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="expiry_period" size="4" value="{$expiry_period}">
</li>

<li>
<label>{$lang.text_ham_cache_expiry_period} <a href="adminhelp.php#ham_cache_expiry_period{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="ham_cache_expiry_period" size="4" value="{$ham_cache_expiry_period}">
</li>

<li>
<label>{$lang.text_reminder_threshold_count} <a href="adminhelp.php#reminder_threshold_count{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reminder_threshold_count" size="6" value="{$reminder_threshold_count}">
</li>

<li>
<label>{$lang.text_reminder_threshold_size} <a href="adminhelp.php#reminder_threshold_size{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reminder_threshold_size" size="6" value="{$reminder_threshold_size}">
</li>

<li>
<label>{$lang.text_reminder_template_file} <a href="adminhelp.php#reminder_template_file{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reminder_template_file" size="40" value="{$reminder_template_file}">
</li>

<li>
<label>{$lang.text_reminder_login_url} <a href="adminhelp.php#reminder_login_url{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reminder_login_url" size="40" value="{$reminder_login_url}">
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>

<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_display}</a></legend>
<ol>
<li>
<label>{$lang.text_banner_title} <a href="adminhelp.php#banner_title{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="banner_title" size="40" value="{$banner_title}">
</li>

<li>
<label>{$lang.text_use_icons} <a href="adminhelp.php#use_icons{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $use_icons}
<input type="radio" name="use_icons" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_icons" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="use_icons" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_icons" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_use_logo} <a href="adminhelp.php#use_logo{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $use_logo}
<input type="radio" name="use_logo" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_logo" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="use_logo" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_logo" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_logo_file} <a href="adminhelp.php#logo_file{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="logo_file" size="40" value="{$logo_file}">
</li>

<li>
<label>{$lang.text_logo_alt_text} <a href="adminhelp.php#logo_alt_text{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="logo_alt_text" size="40" value="{$logo_alt_text}">
</li>

<li>
<label>{$lang.text_logo_url} <a href="adminhelp.php#logo_url{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="logo_url" size="40" value="{$logo_url}">
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>

<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_virus_info}</a></legend>
<ol>
<li>
<label>{$lang.text_virus_info_url} <a href="adminhelp.php#virus_info_url{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="virus_info_url" size="40" value="{$virus_info_url}">
</li>

<li>
<label>{$lang.text_virus_lookup} <a href="adminhelp.php#virus_lookup{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<select name="virus_lookup">
{if $virus_lookup == ""}
<option value="" selected>{$lang.text_none}</option>
{else}
<option value="">{$lang.text_none}</option>
{/if}
{if $virus_lookup == "fprot"}
<option value="fprot" selected>{$lang.text_fprot}</option>
{else}
<option value="fprot">{$lang.text_fprot}</option>
{/if}
{if $virus_lookup == "fsecure"}
<option value="fsecure" selected>{$lang.text_fsecure}</option>
{else}
<option value="fsecure">{$lang.text_fsecure}</option>
{/if}
{if $virus_lookup == "fsecurejp"}
<option value="fsecurejp" selected>{$lang.text_fsecurejp}</option>
{else}
<option value="fsecurejp">{$lang.text_fsecurejp}</option>
{/if}
{if $virus_lookup == "google"}
<option value="google" selected>{$lang.text_google}</option>
{else}
<option value="google">{$lang.text_google}</option>
{/if}
{if $virus_lookup == "mcafee"}
<option value="mcafee" selected>{$lang.text_mcafee}</option>
{else}
<option value="mcafee">{$lang.text_mcafee}</option>
{/if}
{if $virus_lookup == "nod32"}
<option value="nod32" selected>{$lang.text_nod32}</option>
{else}
<option value="nod32">{$lang.text_nod32}</option>
{/if}
{if $virus_lookup == "norman"}
<option value="norman" selected>{$lang.text_norman}</option>
{else}
<option value="norman">{$lang.text_norman}</option>
{/if}
{if $virus_lookup == "sophos"}
<option value="sophos" selected>{$lang.text_sophos}</option>
{else}
<option value="sophos">{$lang.text_sophos}</option>
{/if}
{if $virus_lookup == "symantec"}
<option value="symantec" selected>{$lang.text_symantec}</option>
{else}
<option value="symantec">{$lang.text_symantec}</option>
{/if}
{if $virus_lookup == "trend"}
<option value="trend" selected>{$lang.text_trend}</option>
{else}
<option value="trend">{$lang.text_trend}</option>
{/if}
</select>
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>


<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_bandwidth}</a></legend>
<ol>
<li>
<label>{$lang.text_currency_label} <a href="adminhelp.php#currency_label{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="currency_label" size="5" value="{$currency_label}">
</li>

<li>
<label>{$lang.text_bandwidth_cost} <a href="adminhelp.php#bandwidth_cost{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="bandwidth_cost" size="5" value="{$bandwidth_cost}">
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>
<!-- no stats reporting for now
{* commenting out until implemented

  <div class="styledform ui-widget-content">
  <fieldset>
  <legend><a href="#">{$lang.header_stats_reporting}</a></fieldset>
<ol>
<li>
<label>{$lang.text_enable_stats_reporting} <a href="adminhelp.php#enable_stats_reporting{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
{if $enable_stats_reporting}
<input type="radio" name="enable_stats_reporting" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_reporting" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_stats_reporting" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_reporting" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_primary_report_server} <a href="adminhelp.php#primary_report_server{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="primary_report_server" size="40" value="{$primary_report_server}">
</li>

<li>
<label>{$lang.text_primary_report_port} <a href="adminhelp.php#primary_report_port{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="primary_report_port" size="5" value="{$primary_report_port}">
</li>

<li>
<label>{$lang.text_secondary_report_server} <a href="adminhelp.php#secondary_report_server{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="secondary_report_server" size="40" value="{$secondary_report_server}">
</li>

<li>
<label>{$lang.text_secondary_report_port} <a href="adminhelp.php#secondary_report_port{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="secondary_report_port" size="5" value="{$secondary_report_port}">
</li>

<li>
<label>{$lang.text_reporter_sitename} <a href="adminhelp.php#reporter_sitename{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reporter_sitename" size="40" value="{$reporter_sitename}">
</li>

<li>
<label>{$lang.text_reporter_username} <a href="adminhelp.php#reporter_username{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="reporter_username" size="40" value="{$reporter_username}">
</li>

<li>
<label>{$lang.text_reporter_password} <a href="adminhelp.php#reporter_password{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="password" name="reporter_password" size="40" value="{$reporter_password}">
</li>

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>
*}
-->
<div class="styledform ui-widget-content">
<fieldset>
<legend><a href="#">{$lang.header_charts}</a></legend>
<ol>
<li>
<label>{$lang.text_enable_charts} <a href="adminhelp.php#enable_charts{$sid}" target="new" alt="?" class="ui-icon ui-icon-help ui-border-all"></a>
</label>
{if $enable_charts}
<input type="radio" name="enable_charts" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_charts" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_charts" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_charts" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</li>

<li>
<label>{$lang.text_chart_ham_colour} <a href="adminhelp.php#chart_ham_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_ham_colour" size="10" value="{$chart_ham_colour}">
</li>

<li>
<label>{$lang.text_chart_spam_colour} <a href="adminhelp.php#chart_spam_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_spam_colour" size="10" value="{$chart_spam_colour}">
</li>

<li>
<label>{$lang.text_chart_virus_colour} <a href="adminhelp.php#chart_virus_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_virus_colour" size="10" value="{$chart_virus_colour}">
</li>

<li>
<label>{$lang.text_chart_fp_colour} <a href="adminhelp.php#chart_fp_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_fp_colour" size="10" value="{$chart_fp_colour}">
</li>

<li>
<label>{$lang.text_chart_fn_colour} <a href="adminhelp.php#chart_fn_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_fn_colour" size="10" value="{$chart_fn_colour}">
</li>

<li>
<label>{$lang.text_chart_suspected_ham_colour} <a href="adminhelp.php#chart_suspected_ham_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_suspected_ham_colour" size="10" value="{$chart_suspected_ham_colour}">
</li>

<li>
<label>{$lang.text_chart_suspected_spam_colour} <a href="adminhelp.php#chart_suspected_spam_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_suspected_spam_colour" size="10" value="{$chart_suspected_spam_colour}">
</li>

<li>
<label>{$lang.text_chart_wl_colour} <a href="adminhelp.php#chart_wl_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_wl_colour" size="10" value="{$chart_wl_colour}">
</li>

<li>
<label>{$lang.text_chart_bl_colour} <a href="adminhelp.php#chart_bl_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_bl_colour" size="10" value="{$chart_bl_colour}">
</li>

<li>
<label>{$lang.text_chart_background_colour} <a href="adminhelp.php#chart_background_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_background_colour" size="10" value="{$chart_background_colour}">
</li>

<li>
<label>{$lang.text_chart_font_colour} <a href="adminhelp.php#chart_font_colour{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_font_colour" size="10" value="{$chart_font_colour}">
</li>
{*
<li>
<label>{$lang.text_chart_autogeneration_interval} <a href="adminhelp.php#chart_autogeneration_interval{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></label>
<input type="text" name="chart_autogeneration_interval" size="4" value="{$chart_autogeneration_interval}">
</li>
*}

<li class="submitrow">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</li>
</ol>
</fieldset>
</div>
</div>
</form>

<div class="styledform">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}
