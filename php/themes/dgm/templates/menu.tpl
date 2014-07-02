<div class="menu">
{if $showmenu && !$is_a_visitor}

<div class="menuitem">
<a href="welcome.php{$sid}" {popup text=$lang.menu_welcome snapx=20 snapy=20 delay=500}>
            {if $use_icons}
            <img src="{$template_dir}images/welcome.png" border="0" alt="{$lang.menu_welcome}"><br>
            {/if}
            [ {$lang.menu_welcome} ]
        </a>
</div><br>
{if $enable_stats_tracking}
<div class="menuitem">
<a href="stats.php{$sid}" {popup text=$lang.menu_stats}>
            {if $use_icons}
            <img src="{$template_dir}images/stats.png" border="0" alt="{$lang.menu_stats}"><br>
            {/if}
            [ {$lang.menu_stats} ]
        </a>
</div>
<br>
    {/if}
    <div class="menuitem">
<a href="wblist.php{$sid}" {popup text=$lang.menu_whiteblacklist}>
            {if $use_icons}
            <img src="{$template_dir}images/white-black-list.png" border="0" alt="{$lang.menu_whiteblacklist}"><br>
            {/if}
            [ {$lang.menu_whiteblacklist} ]
        </a>
</div>
<br>
<div class="menuitem">
        <a href="settings.php{$sid}" {popup text=$lang.menu_settings}>
            {if $use_icons}
            <img src="{$template_dir}images/settings.png" border="0" alt="{$lang.menu_settings}"><br>
            {/if}
            [ {$lang.menu_settings} ]
        </a>
</div>
<br>
        {if $admin}
<div class="menuitem">
        <a href="admindex.php{$sid}" {popup text=$lang.menu_admin}>
            {if $use_icons}
            <img src="{$template_dir}images/admin-int.png" border="0" alt="{$lang.menu_admin}"><br>
            {/if}
            [ {$lang.menu_admin} ]
        </a>
</div>
        <br>
    {/if}
<div class="menuitem">
        <a href="help.php{$sid}" {popup text=$lang.menu_help}>
            {if $use_icons}
            <img src="{$template_dir}images/help.png" border="0" alt="{$lang.menu_help}"><br>
            {/if}
            [ {$lang.menu_help} ]
        </a>
</div>
<div class="menuitem">
        <a href="logout.php{$sid}" {popup text=$lang.menu_logout}>
            {if $use_icons}
            <img src="{$template_dir}images/logout.png" border="0" alt="{$lang.menu_logout}"><br>
            {/if}
            [ {$lang.menu_logout} ]
        </a>
</div>
        <br>
{/if}

<div id="version">
{if $use_logo}
<img src="{$template_dir}images/poweredbymaia.gif" class="poweredby" width="75" height="38" border="0" alt="{$lang.powered_by}"><br>
{/if}
{$lang.text_version}
{$MAIA_VERSION}
</div><!-- end version div -->
</div><!-- end menu div -->

