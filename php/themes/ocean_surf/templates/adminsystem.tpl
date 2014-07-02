{include file="html_head.tpl"}

{form action="xadminsystem.php$sid" name="adminsystem"}

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="100%">

<tr>
<td class="menubanner" align="center" colspan="2">{$lang.header_system_menu}</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_user_autocreation}&nbsp;
<font size="2"><a href="adminhelp.php#enable_user_autocreation{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_user_autocreation}
<input type="radio" name="enable_user_autocreation" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_user_autocreation" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_user_autocreation" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

{if $auth_method == "internal"}
<tr>
<td class="menuheader2" align="left">
{$lang.text_internal_auth}&nbsp;
<font size="2"><a href="adminhelp.php#internal_auth{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $internal_auth}
<input type="radio" name="internal_auth" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="internal_auth" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="internal_auth" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="internal_auth" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>
{/if}

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_false_negative_management}&nbsp;
<font size="2"><a href="adminhelp.php#enable_false_negative_management{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_false_negative_management}
<input type="radio" name="enable_false_negative_management" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_false_negative_management" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_false_negative_management" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_false_negative_management" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_stats_tracking}&nbsp;
<font size="2"><a href="adminhelp.php#enable_stats_tracking{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_stats_tracking}
<input type="radio" name="enable_stats_tracking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_tracking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_stats_tracking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_tracking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_user_virus_scanning}&nbsp;
<font size="2"><a href="adminhelp.php#user_virus_scanning{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $user_virus_scanning}
<input type="radio" name="user_virus_scanning" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_virus_scanning" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_virus_scanning" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_virus_scanning" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_virus_scanning}&nbsp;
<font size="2"><a href="adminhelp.php#enable_virus_scanning{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_virus_scanning}
<input type="radio" name="enable_virus_scanning" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_virus_scanning" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_virus_scanning" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_virus_scanning" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_spam_filtering}&nbsp;
<font size="2"><a href="adminhelp.php#enable_spam_filtering{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_spam_filtering}
<input type="radio" name="enable_spam_filtering" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spam_filtering" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_spam_filtering" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spam_filtering" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_user_spam_filtering}&nbsp;
<font size="2"><a href="adminhelp.php#user_spam_filtering{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $user_spam_filtering}
<input type="radio" name="user_spam_filtering" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_spam_filtering" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_spam_filtering" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_spam_filtering" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_banned_files_checking}&nbsp;
<font size="2"><a href="adminhelp.php#enable_banned_files_checking{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_banned_files_checking}
<input type="radio" name="enable_banned_files_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_banned_files_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_banned_files_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_banned_files_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_user_banned_files_checking}&nbsp;
<font size="2"><a href="adminhelp.php#user_banned_files_checking{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $user_banned_files_checking}
<input type="radio" name="user_banned_files_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_banned_files_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_banned_files_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_banned_files_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_bad_header_checking}&nbsp;
<font size="2"><a href="adminhelp.php#enable_bad_header_checking{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_bad_header_checking}
<input type="radio" name="enable_bad_header_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_bad_header_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_bad_header_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_bad_header_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_user_bad_header_checking}&nbsp;
<font size="2"><a href="adminhelp.php#user_bad_header_checking<?php print($sid); ?>" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $user_bad_header_checking}
<input type="radio" name="user_bad_header_checking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_bad_header_checking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="user_bad_header_checking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="user_bad_header_checking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_spamtraps}&nbsp;
<font size="2"><a href="adminhelp.php#enable_spamtraps{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_spamtraps}
<input type="radio" name="enable_spamtraps" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spamtraps" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_spamtraps" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_spamtraps" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_address_linking}&nbsp;
<font size="2"><a href="adminhelp.php#enable_address_linking{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_address_linking}
<input type="radio" name="enable_address_linking" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_address_linking" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_address_linking" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_address_linking" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_username_changes}&nbsp;
<font size="2"><a href="adminhelp.php#enable_username_changes{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_username_changes}
<input type="radio" name="enable_username_changes" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_username_changes" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_username_changes" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_username_changes" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_privacy_invasion}&nbsp;
<font size="2"><a href="adminhelp.php#enable_privacy_invasion{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_privacy_invasion}
<input type="radio" name="enable_privacy_invasion" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_privacy_invasion" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_privacy_invasion" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_privacy_invasion" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_system_default_user_is_local}&nbsp;
<font size="2"><a href="adminhelp.php#system_default_user_is_local{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $system_default_user_is_local}
<input type="radio" name="system_default_user_is_local" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="system_default_user_is_local" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="system_default_user_is_local" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="system_default_user_is_local" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_size_limit}&nbsp;
<font size="2"><a href="adminhelp.php#size_limit{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="size_limit" size="12" value="{$size_limit}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_oversize_policy}&nbsp;
<font size="2"><a href="adminhelp.php#oversize_policy{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $oversize_policy == "P"}
<input type="radio" name="oversize_policy" value="P" checked>&nbsp;{$lang.text_accept}&nbsp;&nbsp;
<input type="radio" name="oversize_policy" value="B">&nbsp;{$lang.text_reject}&nbsp;&nbsp;
{else}
<input type="radio" name="oversize_policy" value="P">&nbsp;{$lang.text_accept}&nbsp;&nbsp;
<input type="radio" name="oversize_policy" value="B" checked>&nbsp;{$lang.text_reject}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_paths}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_admin_email}&nbsp;
<font size="2"><a href="adminhelp.php#admin_email{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="admin_email" size="50" value="{$admin_email}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_smtp_server}&nbsp;
<font size="2"><a href="adminhelp.php#smtp_server{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="smtp_server" size="50" value="{$smtp_server}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_smtp_port}&nbsp;
<font size="2"><a href="adminhelp.php#smtp_port{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="smtp_port" size="5" value="{$smtp_port}">
</td>
</tr>
<tr>
<td class="menuheader2" align="left">
{$lang.text_key_file}&nbsp;
<font size="2"><a href="adminhelp.php#key_file{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="key_file" size="50" value="{$key_file}">
</td>
</tr>
{if $auth_method == "internal"}
<tr>
<td class="menuheader2" align="left">
{$lang.text_newuser_template_file}&nbsp;
<font size="2"><a href="adminhelp.php#newuser_template_file{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="newuser_template_file" size="50" value="{$newuser_template_file}">
</td>
</tr>
{/if}

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_reminders}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_expiry_period}&nbsp;
<font size="2"><a href="adminhelp.php#expiry_period{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="expiry_period" size="4" value="{$expiry_period}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_ham_cache_expiry_period}&nbsp;
<font size="2"><a href="adminhelp.php#ham_cache_expiry_period{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="ham_cache_expiry_period" size="4" value="{$ham_cache_expiry_period}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reminder_threshold_count}&nbsp;
<font size="2"><a href="adminhelp.php#reminder_threshold_count{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reminder_threshold_count" size="6" value="{$reminder_threshold_count}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reminder_threshold_size}&nbsp;
<font size="2"><a href="adminhelp.php#reminder_threshold_size{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reminder_threshold_size" size="6" value="{$reminder_threshold_size}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reminder_template_file}&nbsp;
<font size="2"><a href="adminhelp.php#reminder_template_file{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reminder_template_file" size="50" value="{$reminder_template_file}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reminder_login_url}&nbsp;
<font size="2"><a href="adminhelp.php#reminder_login_url{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reminder_login_url" size="50" value="{$reminder_login_url}">
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_display}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_banner_title}&nbsp;
<font size="2"><a href="adminhelp.php#banner_title{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="banner_title" size="50" value="{$banner_title}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_use_icons}&nbsp;
<font size="2"><a href="adminhelp.php#use_icons{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $use_icons}
<input type="radio" name="use_icons" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_icons" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="use_icons" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_icons" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_use_logo}&nbsp;
<font size="2"><a href="adminhelp.php#use_logo{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $use_logo}
<input type="radio" name="use_logo" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_logo" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="use_logo" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="use_logo" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_logo_file}&nbsp;
<font size="2"><a href="adminhelp.php#logo_file{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="logo_file" size="50" value="{$logo_file}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_logo_alt_text}&nbsp;
<font size="2"><a href="adminhelp.php#logo_alt_text{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="logo_alt_text" size="50" value="{$logo_alt_text}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_logo_url}&nbsp;
<font size="2"><a href="adminhelp.php#logo_url{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="logo_url" size="50" value="{$logo_url}">
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_virus_info}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_virus_info_url}&nbsp;
<font size="2"><a href="adminhelp.php#virus_info_url{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="virus_info_url" size="50" value="{$virus_info_url}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_virus_lookup}&nbsp;
<font size="2"><a href="adminhelp.php#virus_lookup{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
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
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_bandwidth}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_currency_label}&nbsp;
<font size="2"><a href="adminhelp.php#currency_label{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="currency_label" size="5" value="{$currency_label}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_bandwidth_cost}&nbsp;
<font size="2"><a href="adminhelp.php#bandwidth_cost{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="bandwidth_cost" size="5" value="{$bandwidth_cost}">
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>
<!-- no stats reporting for now
{*  commenting out until implemented 
<tr><td class="menuheader" align="center" colspan="2">{$lang.header_stats_reporting}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_stats_reporting}&nbsp;
<font size="2"><a href="adminhelp.php#enable_stats_reporting{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_stats_reporting}
<input type="radio" name="enable_stats_reporting" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_reporting" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_stats_reporting" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_stats_reporting" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_primary_report_server}&nbsp;
<font size="2"><a href="adminhelp.php#primary_report_server{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="primary_report_server" size="50" value="{$primary_report_server}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_primary_report_port}&nbsp;
<font size="2"><a href="adminhelp.php#primary_report_port{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="primary_report_port" size="5" value="{$primary_report_port}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_secondary_report_server}&nbsp;
<font size="2"><a href="adminhelp.php#secondary_report_server{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="secondary_report_server" size="50" value="{$secondary_report_server}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_secondary_report_port}&nbsp;
<font size="2"><a href="adminhelp.php#secondary_report_port{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="secondary_report_port" size="5" value="{$secondary_report_port}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reporter_sitename}&nbsp;
<font size="2"><a href="adminhelp.php#reporter_sitename{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reporter_sitename" size="50" value="{$reporter_sitename}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reporter_username}&nbsp;
<font size="2"><a href="adminhelp.php#reporter_username{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="reporter_username" size="50" value="{$reporter_username}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_reporter_password}&nbsp;
<font size="2"><a href="adminhelp.php#reporter_password{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="password" name="reporter_password" size="50" value="{$reporter_password}">
</td>
</tr>

<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>
*}
-->

<tr><td class="menuheader" align="center" colspan="2">{$lang.header_charts}</td></tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_enable_charts}&nbsp;
<font size="2"><a href="adminhelp.php#enable_charts{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="center">
{if $enable_charts}
<input type="radio" name="enable_charts" value="Y" checked>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_charts" value="N">&nbsp;{$lang.text_no}&nbsp;&nbsp;
{else}
<input type="radio" name="enable_charts" value="Y">&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="enable_charts" value="N" checked>&nbsp;{$lang.text_no}&nbsp;&nbsp;
{/if}
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_ham_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_ham_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_ham_colour" size="10" value="{$chart_ham_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_spam_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_spam_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_spam_colour" size="10" value="{$chart_spam_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_virus_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_virus_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_virus_colour" size="10" value="{$chart_virus_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_fp_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_fp_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_fp_colour" size="10" value="{$chart_fp_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_fn_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_fn_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_fn_colour" size="10" value="{$chart_fn_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_suspected_ham_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_suspected_ham_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_suspected_ham_colour" size="10" value="{$chart_suspected_ham_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_suspected_spam_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_suspected_spam_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_suspected_spam_colour" size="10" value="{$chart_suspected_spam_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_wl_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_wl_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_wl_colour" size="10" value="{$chart_wl_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_bl_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_bl_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_bl_colour" size="10" value="{$chart_bl_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_background_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_background_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_background_colour" size="10" value="{$chart_background_colour}">
</td>
</tr>

<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_font_colour}&nbsp;
<font size="2"><a href="adminhelp.php#chart_font_colour{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_font_colour" size="10" value="{$chart_font_colour}">
</td>
</tr>
{*
<tr>
<td class="menuheader2" align="left">
{$lang.text_chart_autogeneration_interval}&nbsp;
<font size="2"><a href="adminhelp.php#chart_autogeneration_interval{$sid}" target="new">[?]</a></font>
</td>
<td class="menubody2" align="left">
<input type="text" name="chart_autogeneration_interval" size="4" value="{$chart_autogeneration_interval}">
</td>
</tr>
*}
<tr><td class="menulight" colspan="2" align="center">
<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">
</td></tr>

</table></div>
</form>

<div align="center">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}
