{include file="html_head.tpl"}
<h1>{$lang.heading_introduction}</h1>

<p>{$lang.help_introduction_1}</p>

<p>{$lang.help_introduction_2}</p>

<h2>
 {if $use_icons}
   <img src="{$template_dir}images/welcome.png">&nbsp;
 {else}
   [{$lang.menu_welcome}] -
 {/if}
{$lang.heading_welcome }</h2>

<p>{$lang.help_welcome_1}</p>

{if $enable_stats_tracking}
<h2>
 {if $use_icons}
   <img src="images/stats.png">&nbsp;
 {else}
   [{$lang.menu_stats}] -
 {/if}
{$lang.heading_statistics }</h2>

<p>{$lang.help_stats_1}</p>

{if $enable_false_negative_management}

<p>{$lang.help_stats_2}</p>

{/if}

<p>{$lang.help_stats_3}</p>

{if $enable_spam_filtering}

<p>{$lang.help_stats_4}</p>

<p>{$lang.help_stats_5}</p>

<p>{$lang.help_stats_6}</p>

{/if}

{if $enable_false_negative_management}

<p>{$lang.help_stats_7}</p>

{/if}

<p>{$lang.help_stats_8}</p>

<p>{$lang.help_stats_9}</p>

{if $enable_virus_scanning}

<p>{$lang.help_stats_10}</p>

{/if}

{if $enable_banned_files_checking}

<p>{$lang.help_stats_11}</p>

{/if}

{if $enable_bad_header_checking}
<p>{$lang.help_stats_12}</p>
{/if}
<p>{$lang.help_stats_13}</p>
{/if}

<h2>
{if $use_icons}
<img src="images/settings.png">&nbsp;
{else}
[{$lang.menu_settings}] - 
{/if}
{$lang.heading_settings}</h2>

<p>{$lang.help_settings_1}</p>

<h3>{$lang.header_addresses}</h3>

<p>{$lang.help_settings_2}</p>

<p>{$lang.help_settings_3}</p>

{if $auth_method == "internal"}
<h3>{$lang.header_login_info}</h3>

<p>{$lang.help_settings_21}</p>

{/if}

<h3>{$lang.header_miscellaneous}</h3>

<p>{$lang.help_settings_4}</p>

<p>{$lang.help_settings_5}</p>

<p>{$lang.help_settings_6}</p>

<p>{$lang.help_settings_22}</p>

<p>{$lang.help_settings_23}</p>

<p>{$lang.help_settings_7}</p>


<h3>{$lang.heading_per_address_settings}</h3>

{if $enable_virus_scanning}

<p>{$lang.help_settings_9}</p>

<p>{$lang.help_settings_10}</p>

{/if}

{if $enable_spam_filtering}

<p>{$lang.help_settings_11}</p>

<p>{$lang.help_settings_12}</p>

<p>{$lang.help_settings_13}</p>

<p>{$lang.help_settings_14}</p>

<p>{$lang.help_settings_15}</p>

<p>{$lang.help_settings_16}</p>

{/if}

{if $enable_banned_files_checking}

<p>{$lang.help_settings_17}</p>

<p>{$lang.help_settings_18}</p>

{/if}

{if $enable_bad_header_checking}

<p>{$lang.help_settings_19}</p>

<p>{$lang.help_settings_20}</p>

{/if}

<h2>
{if $use_icons}
<img src="images/white-black-list.png">&nbsp
{else}
[{$lang_menu_whiteblacklist}] - 
{/if}
{$lang.heading_wblist}
</h2>


<p>{$lang.help_wblist_1}</p>

<p>{$lang.help_wblist_2}</p>

<p>{$lang.help_wblist_3}</p>

<p>{$lang.help_wblist_4}</p>

<p>{$lang.help_wblist_5}</p>

<p>{$lang.help_wblist_6}</p>

<h2>
{if $use_icons}
<img src="images/quarantine.png">&nbsp;
{else}
[{$lang_menu_quarantine} - 
{/if}
{$lang.heading_quarantine}
</h2>

<p>{$lang.help_quarantine_1}</p>

{if $enable_spam_filtering}

<p>{$lang.help_quarantine_2}</p>

<p>{$lang.help_quarantine_9}
</p>

{/if}
{if $enable_virus_scanning}

<p>{$lang.help_quarantine_3}
</p>


{/if}
{if $enable_banned_files_checking}
<p>{$lang.help_quarantine_4}
</p>


{/if}

{if $enable_bad_header_checking}

<p>{$lang.help_quarantine_5}
</p>


{/if}
{if $enable_spam_filtering}

<p>{$lang.help_quarantine_6}</p>

{/if}

<p>{$lang.help_quarantine_7}</p>

<p>{$lang.help_quarantine_8}</p>

{if $enable_false_negative_management}
<h2>
{if $use_icons}
<img src="images/report-spam.png">&nbsp;
{else}
 [{$lang.menu_report} - 
{/if}
 {$lang.heading_report}
 </h2>

<p>{$lang.help_fn_1}</p>

<p>{$lang.help_fn_2}</p>

<p>{$lang.help_fn_3}</p>

<p>{$lang.help_fn_6}</p>

<p>{$lang.help_fn_4}</p>

<p>{$lang.help_fn_5}</p>

{/if}
<a name="mail_viewer"><h2>
{if $use_icons}
<img src="images/view-decoded.png">&nbsp;
{/if}
{$lang.heading_mail_viewer}
</h2></a>

<p>{$lang.help_mail_viewer_1}</p>

<p>{$lang.help_mail_viewer_2}</p>

<p>{$lang.help_mail_viewer_3}</p>

<p>{$lang.help_mail_viewer_4}</p>

{if $is_an_administrator}
<h2>
{if $use_icons}
<img src="images/admin-int.png">&nbsp;
{else}
[{$lang.menu_admin}] - 
{/if}
{$lang.heading_admin}
</h2>
<p>{$lang.help_admin_1}</p>

{/if}
<h2>{$lang.heading_for_further_assistance}</h2>

<p>{$lang.help_assistance_1}</p>


<h2>{$lang.heading_credits}</h2>

<p>{$lang.help_credits_1}</p>

{include file="html_foot.tpl"}