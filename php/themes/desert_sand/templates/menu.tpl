
{if $use_logo}
<div id="logo">
    {if $logo_url}
        <a href="{$logo_url}" onmouseover="show_tooltip(this, event, '{$logo_alt_text}')" onmouseout="hide_tooltip()">
    {/if}
        <img src="{$template_dir}{$logo_file}" border="0" alt="{$logo_alt_text}">
    {if $logo_url}
        </a>
    {/if}
</div>
{/if}
{if $showmenu && !$is_a_visitor}

<p class="topbanner2">{$banner_title}</p>
<p class="topbanner3">{$lang.banner_subtitle}</p>
<br>
<p>{$username}</p>
{if $hamcount || $spamcount || $viruscount || $bannedcount || $headercount}
<br>
<p>{$lang.header_cache_contents}:</p>
<ul>
{if $hamcount}
<li class="hamheader"><a href="list-cache.php{$msid}cache_type=ham">{$lang.text_suspected_ham_item} {$hamcount}</a></li>
{/if}
{if $spamcount}
<li class="suspected_spamheader"><a href="list-cache.php{$msid}cache_type=spam">{$lang.text_suspected_spam_item} {$spamcount}</a></li>
{/if}
{if $viruscount}
<li class="virusheader"><a href="list-cache.php{$msid}cache_type=virus">{$lang.text_virus_item} {$viruscount}</a></li>
{/if}
{if $bannedcount}
<li class="banned_fileheader"><a href="list-cache.php{$msid}cache_type=attachment">{$lang.text_banned_file_item} {$bannedcount}</a></li>
{/if}
{if $headercount}
<li class="bad_headerheader"><a href="list-cache.php{$msid}cache_type=header">{$lang.text_bad_header_item} {$headercount}</a></li>
{/if}
</ul>
{/if}
<br>
<ul>
  <li>
<a href="welcome.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_welcome}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/welcome.png" border="0" alt="{$lang.menu_welcome}"><br>
            {/if}
            [ {$lang.menu_welcome} ]
        </a>
</li>
{if $enable_stats_tracking}
<li>
          <a href="stats.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_stats}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/stats.png" border="0" alt="{$lang.menu_stats}"><br>
            {/if}
            [ {$lang.menu_stats} ]
        </a>
</li>
    {/if}
<li>
        <a href="wblist.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_whiteblacklist}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/white-black-list.png" border="0" alt="{$lang.menu_whiteblacklist}"><br>
            {/if}
            [ {$lang.menu_whiteblacklist} ]
        </a>
</li>
        
<li>
        <a href="settings.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_settings}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/settings.png" border="0" alt="{$lang.menu_settings}"><br>
            {/if}
            [ {$lang.menu_settings} ]
        </a>
        </li>
{if $admin}        
        <li>
        <a href="admindex.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_admin}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/admin-int.png" border="0" alt="{$lang.menu_admin}"><br>
            {/if}
            [ {$lang.menu_admin} ]
        </a>
        </li>
    {/if}
<li>
          <a href="help.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_help}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/help.png" border="0" alt="{$lang.menu_help}"><br>
            {/if}
            [ {$lang.menu_help} ]
        </a>
</li>
<li>
          <a href="logout.php{$sid}" onmouseover="show_tooltip(this, event, '{$lang.menu_logout}')" onmouseout="hide_tooltip()">
            {if $use_icons}
            <img src="{$template_dir}images/logout.png" border="0" alt="{$lang.menu_logout}"><br>
            {/if}
            [ {$lang.menu_logout} ]
        </a>
</li>
  {/if}
</ul>
<br>
<p class="topbanner3">{$lang.text_version}</p>
<p class="topbanner4">{$MAIA_VERSION}</p>
