<div align="center">
  {if $use_logo}
    <div id="logo">
      {if $logo_url}
          <a href="{$logo_url}" onmouseover="show_tooltip(this, event, '{$logo_alt_text}')" onmouseout="hide_tooltip()">
      {/if}
          <img src="{$template_dir}{$logo_file}" border="0" alt="{$logo_alt_text}" width="130" height="130">
      {if $logo_url}
          </a>
      {/if}
    </div>
  {/if}
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td valign="top">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr><td class="topbanner" align="center" height="70" colspan="{$cols}">{$banner_title}</td></tr>
<tr><td class="topbanner2" align="center" height="40" colspan="{$cols}">{$lang.banner_subtitle}</td></tr>
{if $showmenu && !$is_a_visitor}
<tr><td class="topbanner3" align="center" height="30" colspan="{$cols}">{$username}</td></tr>
<tr>
{* home button *}
<td class="topbanner4" align="center">
{if $use_icons}
  <a href="welcome.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_welcome}')" onmouseout="hide_tooltip()">
     <img src="{$template_dir}images/welcome.png" border="0" alt="{$lang.menu_welcome}">
     </a>
{else}
  <a href="welcome.php{$msid}">[{$lang.menu_welcome}]</a>
{/if}
</td>
    {if $enable_stats_tracking}
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="stats.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_stats}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/stats.png" border="0" alt="{$lang.menu_stats}">
        </a>
    {else}
        <a href="stats.php{$msid}">[{$lang.menu_stats}]</a>
    {/if}
    </td>
    {/if}
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="settings.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_settings}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/settings.png" border="0" alt="{$lang.menu_settings}">
        </a>
    {else}
        <a href="settings.php{$msid}">[{$lang.menu_settings}]</a>
    {/if}
    </td>
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="wblist.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_whiteblacklist}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/white-black-list.png" border="0" alt="{$lang.menu_whiteblacklist}">
        </a>
    {else}
        <a href="wblist.php" . $msid . "">[{$lang.menu_whiteblacklist}]</a>
    {/if}
    </td>
    {if $admin}
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="admindex.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_admin}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/admin-int.png" border="0" alt="{$lang.menu_admin}">
        </a>
    {else}
        <a href="admindex.php{$msid}">[{$lang.menu_admin}]</a>
    {/if}
    </td>
    {/if}
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="help.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_help}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/help.png" border="0" alt="{$lang.menu_help}">
        </a>
    {else}
        <a href="help.php{$msid}">[{$lang.menu_help}]</a>
    {/if}
    </td>
    <td class="topbanner4" align="center">
    {if $use_icons}
        <a href="logout.php{$msid}" onmouseover="show_tooltip(this, event, '{$lang.menu_logout}')" onmouseout="hide_tooltip()">
            <img src="{$template_dir}images/logout.png" border="0" alt="{$lang.menu_logout}">
        </a>
    {else}
        <a href="logout.php{$msid}">[{$lang.menu_logout}]</a>
    {/if}
    </td>
</tr>
{elseif $use_logo}
<tr><td class="topbanner3" align="center" height="30" colspan="{$cols}">{$lang.text_version} {$MAIA_VERSION}</td></tr>
<tr><td class="topbanner4" align="center" colspan="{$cols}">&nbsp;</td></tr>
{/if}

 </table>
 </td>

 </tr>

</table></div><br>

