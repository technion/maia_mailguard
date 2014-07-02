{include file="html_head.tpl"}

<h2>{$lang.menu_users}</h2>

<a name="find_users">
<p>{$lang.adminhelp_find_users}</p>
</a>

<a name="add_email_address">
<p>{$lang.adminhelp_add_email_address}</p>
</a>

<a name="link_email_address">
<p>{$lang.adminhelp_link_email_address}</p>
</a>

<a name="delete_email_address">
<p>{$lang.adminhelp_delete_email_address}</p>
</a>

<a name="delete_user">
<p>{$lang.adminhelp_delete_user}</p>
</a>

<a name="impersonate"></a>
<p>{$lang.adminhelp_impersonate}</p>


<h2>{$lang.menu_domains}</h2>

<a name="domain_administration">
<p>{$lang.adminhelp_domain_administration}</p>
</a>

<a name="add_domain">
<p>{$lang.adminhelp_add_domain}</p>
</a>

<a name="domain_settings"></a>
<p>{$lang.adminhelp_domain_settings}</p>


{if $super}

<a name="administrators">
<p>{$lang.adminhelp_administrators}</p>
</a>

<a name="add_administrator">
<p>{$lang.adminhelp_add_administrator}</p>
</a>

<a name="domain_tranport">
<p>{$lang.adminhelp_domain_transport}</p>
</a>
{/if}

{if $super}

<h2>{$lang.menu_viruses}</h2>

<a name="virus_aliases">
<p>{$lang.adminhelp_virus_aliases}</p>
</a>

<a name="add_virus_alias">
<p>{$lang.adminhelp_add_virus_alias}</p>
</a>

<h2>{$lang.menu_languages}</h2>

<a name="languages">
<p>{$lang.adminhelp_languages}</p>
</a>

<a name="install_languages">
<p>{$lang.adminhelp_install_languages}</p>
</a>

<h2>{$lang.menu_themes}</h2>

<a name="themes">
<p>{$lang.adminhelp_themes}</p>
</a>

<a name="install_themes">
<p>{$lang.adminhelp_install_themes}</p>
</a>
<h2>{$lang.menu_system}</h2>

<a name="enable_user_autocreation">
<p>{$lang.adminhelp_enable_user_autocreation}</p>
</a>

<a name="internal_auth">
<p>{$lang.adminhelp_internal_auth}</p>
</a>

<a name="enable_false_negative_management">
<p>{$lang.adminhelp_enable_false_negative_management}</p>
</a>

<a name="enable_stats_tracking">
<p>{$lang.adminhelp_enable_stats_tracking}</p>
</a>

<a name="enable_virus_scanning">
<p>{$lang.adminhelp_enable_virus_scanning}</p>
</a>
<a name="user_virus_scanning">
<p>{$lang.adminhelp_user_virus_scanning}</p>
</a>
<a name="enable_spam_filtering">
<p>{$lang.adminhelp_enable_spam_filtering}</p>
</a>
<a name="user_spam_filtering">
<p>{$lang.adminhelp_user_spam_filtering}</p>
</a>
<a name="enable_banned_files_checking">
<p>{$lang.adminhelp_enable_banned_files_checking}</p>
</a>
<a name="user_banned_files_checking">
<p>{$lang.adminhelp_user_banned_files_checking}</p>
</a>
<a name="enable_bad_header_checking">
<p>{$lang.adminhelp_enable_bad_header_checking}</p>
</a>
<a name="user_bad_header_checking">
<p>{$lang.adminhelp_user_bad_header_checking}</p>
</a>
<a name="enable_spamtraps">
<p>{$lang.adminhelp_enable_spamtraps}</p>
</a>
<a name="enable_address_linking">
<p>{$lang.adminhelp_enable_address_linking}</p>
</a>
<a name="enable_username_changes">
<p>{$lang.adminhelp_enable_username_changes}</p>
</a>
<a name="enable_privacy_invasion">
<p>{$lang.adminhelp_enable_privacy_invasion}</p>
</a>
<a name="system_default_user_is_local">
<p>{$lang.adminhelp_system_default_user_is_local}</p>
</a>
<a name="size_limit">
<p>{$lang.adminhelp_size_limit}</p>
</a>

<a name="oversize_policy">
<p>{$lang.adminhelp_oversize_policy}</p>
</a>

<a name="admin_email">
<p>{$lang.adminhelp_admin_email}</p>
</a>

<a name="smtp_server">
<p>{$lang.adminhelp_smtp_server}</p>
</a>

<a name="smtp_port">
<p>{$lang.adminhelp_smtp_port}</p>
</a>

<a name="key_file">
<p>{$lang.adminhelp_key_file}</p>
</a>

<a name="newuser_template_file">
<p>{$lang.adminhelp_newuser_template_file}</p>
</a>

<a name="expiry_period">
<p>{$lang.adminhelp_expiry_period}</p>
</a>

<a name="ham_cache_expiry_period">
<p>{$lang.adminhelp_ham_cache_expiry_period}</p>
</a>

<a name="reminder_threshold_count">
<p>{$lang.adminhelp_reminder_threshold_count}</p>
</a>

<a name="reminder_threshold_size">
<p>{$lang.adminhelp_reminder_threshold_size}</p>
</a>

<a name="reminder_template_file">
<p>{$lang.adminhelp_reminder_template_file}</p>
</a>

<a name="reminder_login_url">
<p>{$lang.adminhelp_reminder_login_url}</p>
</a>

<a name="banner_title">
<p>{$lang.adminhelp_banner_title}</p>
</a>

<a name="use_icons">
<p>{$lang.adminhelp_use_icons}</p>
</a>

<a name="use_logo">
<p>{$lang.adminhelp_use_logo}</p>
</a>

<a name="logo_file">
<p>{$lang.adminhelp_logo_file}</p>
</a>

<a name="logo_alt_text">
<p>{$lang.adminhelp_logo_alt_text}</p>
</a>

<a name="logo_url">
<p>{$lang.adminhelp_logo_url}</p>
</a>

<a name="virus_info_url">
<p>{$lang.adminhelp_virus_info_url}</p>
</a>

<a name="virus_lookup">
<p>{$lang.adminhelp_virus_lookup}</p>
</a>

<a name="currency_label">
<p>{$lang.adminhelp_currency_label}</p>
</a>

<a name="bandwidth_cost">
<p>{$lang.adminhelp_bandwidth_cost}</p>
</a>

<a name="enable_stats_reporting">
<p>{$lang.adminhelp_enable_stats_reporting}</p>
</a>

<a name="primary_report_server">
<p>{$lang.adminhelp_primary_report_server}</p>
</a>

<a name="primary_report_port">
<p>{$lang.adminhelp_primary_report_port}</p>
</a>

<a name="secondary_report_server">
<p>{$lang.adminhelp_secondary_report_server}</p>
</a>

<a name="secondary_report_port">
<p>{$lang.adminhelp_secondary_report_port}</p>
</a>

<a name="reporter_sitename">
<p>{$lang.adminhelp_reporter_sitename}</p>
</a>

<a name="reporter_username">
<p>{$lang.adminhelp_reporter_username}</p>
</a>

<a name="reporter_password">
<p>{$lang.adminhelp_reporter_password}</p>
</a>

<a name="enable_charts">
<p>{$lang.adminhelp_enable_charts}</p>
</a>

<a name="chart_ham_colour">
<p>{$lang.adminhelp_chart_ham_colour}</p>
</a>

<a name="chart_spam_colour">
<p>{$lang.adminhelp_chart_spam_colour}</p>
</a>

<a name="chart_virus_colour">
<p>{$lang.adminhelp_chart_virus_colour}</p>
</a>

<a name="chart_fp_colour">
<p>{$lang.adminhelp_chart_fp_colour}</p>
</a>

<a name="chart_fn_colour">
<p>{$lang.adminhelp_chart_fn_colour}</p>
</a>

<a name="chart_suspected_ham_colour">
<p>{$lang.adminhelp_chart_suspected_ham_colour}</p>
</a>

<a name="chart_suspected_spam_colour">
<p>{$lang.adminhelp_chart_suspected_spam_colour}</p>
</a>

<a name="chart_wl_colour">
<p>{$lang.adminhelp_chart_wl_colour}</p>
</a>

<a name="chart_bl_colour">
<p>{$lang.adminhelp_chart_bl_colour}</p>
</a>

<a name="chart_background_colour">
<p>{$lang.adminhelp_chart_background_colour}</p>
</a>

<a name="chart_font_colour">
<p>{$lang.adminhelp_chart_font_colour}</p>
</a>

<a name="chart_autogeneration_interval">
<p>{$lang.adminhelp_chart_autogeneration_interval}</p>
</a>

<h2>{$lang.menu_statistics}</h2>

<a name="reset_statistics">
<p>{$lang.adminhelp_reset_stats}</p>
</a>

{/if}

{include file="html_foot.tpl"}
