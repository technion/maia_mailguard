{include file="html_head.tpl"}

<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_admin_menu}</legend>
<ol>

<li>
<a href="adminusers.php{$sid}"> {$lang.menu_users} </a>
</li>

<li>
<a href="admindomains.php{$sid}"> {$lang.menu_domains} </a>
</li>

{if $super}
<li>
<a href="adminviruses.php{$sid}"> {$lang.menu_viruses} </a>
</li>

<li>
<a href="adminlanguages.php{$sid}"> {$lang.menu_languages} </a>
</li>

<li>
<a href="adminthemes.php{$sid}"> {$lang.menu_themes} </a>
</li>

<li>
<a href="adminsystem.php{$sid}"> {$lang.menu_system} </a>
</li>

{if $enable_stats_tracking}
<li>
<a href="adminstats.php{$sid}"> {$lang.menu_statistics} </a>
</li>
{/if}

{/if}

<li>
<a href="adminhelp.php{$sid}" target="new"> {$lang.menu_help} </a>
</li>
</ol>
</fieldset>
</div>

{include file="html_foot.tpl"}
