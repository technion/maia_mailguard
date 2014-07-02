{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/config.css">
{/capture}

{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}
<form method="post" action="xadminsystem.php{$sid}" name="adminsystem">
<div class="config_table panel1 outy">
 <div class="config_header panel2 outy">{$lang.header_system_menu}</div>
	
	{boolean_config_row option="enable_user_autocreation"}
{if $auth_method == "internal"}
{boolean_config_row option="internal_auth"}
{/if}
{boolean_config_row option="enable_false_negative_management"}
{boolean_config_row option="enable_stats_tracking"}
{boolean_config_row option="user_virus_scanning"}
{boolean_config_row option="enable_virus_scanning"}
{boolean_config_row option="enable_spam_filtering"}
{boolean_config_row option="user_spam_filtering"}
{boolean_config_row option="enable_banned_files_checking"}
{boolean_config_row option="user_banned_files_checking"}
{boolean_config_row option="enable_bad_header_checking"}
{boolean_config_row option="user_bad_header_checking"}
{boolean_config_row option="enable_spamtraps"}
{boolean_config_row option="enable_address_linking"}
{boolean_config_row option="enable_username_changes"}
{boolean_config_row option="enable_privacy_invasion"}
{boolean_config_row option="system_default_user_is_local"}
{text_config_row option="size_limit"}
{boolean_config_row option="oversize_policy"}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_paths}</div>
{text_config_row option="admin_email"}
{text_config_row option="smtp_server"}
{text_config_row option="smtp_port"}
{text_config_row option="key_file"}
{if $auth_method == "internal"}
{text_config_row option="newuser_template_file"}
{/if}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_reminders}</div>
{text_config_row option="expiry_period"}
{text_config_row option="ham_cache_expiry_period"}
{text_config_row option="reminder_threshold_count"}
{text_config_row option="reminder_threshold_size"}
{text_config_row option="reminder_template_file"}
{text_config_row option="reminder_login_url"}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_display}</div>
{text_config_row option="banner_title"}
{boolean_config_row option="use_icons"}
{boolean_config_row option="use_logo"}
{text_config_row option="logo_file"}
{text_config_row option="logo_alt_text"}
{text_config_row option="logo_url"}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_virus_info}</div>
{text_config_row option="virus_info_url"}


<div class="config_row panel1 inny"><span class="config_key">{$lang.text_virus_lookup}
<font size="2"><a href="adminhelp.php#virus_lookup{$sid}" target="new">[?]</a></font></span>
<span class="config_value">
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
</select></span>
</div>

</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_bandwidth}</div>

{text_config_row option="currency_label"}
{text_config_row option="bandwidth_cost"}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_stats_reporting}</div>
{boolean_config_row option="enable_stats_reporting"}
{text_config_row option="primary_report_server"}
{text_config_row option="primary_report_port"}
{text_config_row option="secondary_report_server"}
{text_config_row option="secondary_report_port"}
{text_config_row option="reporter_sitename"}
{text_config_row option="reporter_username"}
{text_config_row option="reporter_password"}
</div>

<div class="config_table panel1 outy">
<div class="config_header panel2 outy">{$lang.header_charts}</div>
{boolean_config_row option="enable_charts"}
{text_config_row option="chart_ham_colour"}
{text_config_row option="chart_spam_colour"}
{text_config_row option="chart_virus_colour"}
{text_config_row option="chart_fp_colour"}
{text_config_row option="chart_fn_colour"}
{text_config_row option="chart_suspected_ham_colour"}
{text_config_row option="chart_suspected_spam_colour"}
{text_config_row option="chart_wl_colour"}
{text_config_row option="chart_bl_colour"}
{text_config_row option="chart_background_colour"}
{text_config_row option="chart_font_colour"}
{*
{text_config_row option="chart_autogeneration_interval"}
*}
</div>

<input type="submit" name="submit" value=" {$lang.button_submit} ">&nbsp;&nbsp;
<input type="reset" name="reset" value=" {$lang.button_restore} ">

</form>

<div >
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>
{/capture}


{include file="container.tpl"}
