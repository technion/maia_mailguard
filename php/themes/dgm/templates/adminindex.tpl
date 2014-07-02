{capture assign="page_css"}
<link rel="stylesheet" TYPE="text/css" HREF="{$template_dir}/css/config.css">
{/capture}
{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<div class="adminindex">
<table border="0" cellspacing="2" cellpadding="2" >

<tr>
<td class="menubanner" align="center">{$lang.header_admin_menu}</td>
</tr>

<tr>
<td class="menuheader" align="center"><a href="adminusers.php{$sid}">[ {$lang.menu_users} ]</a></td>
</tr>

<tr>
<td class="menuheader" align="center"><a href="admindomains.php{$sid}">[ {$lang.menu_domains} ]</a></td>
</tr>

{if $super}
<tr>
<td class="menuheader" align="center"><a href="adminviruses.php{$sid}">[ {$lang.menu_viruses} ]</a></td>
</tr>

<tr>
<td class="menuheader" align="center"><a href="adminlanguages.php{$sid}">[ {$lang.menu_languages} ]</a></td>
</tr>

<tr>
<td class="menuheader" align="center"><a href="adminthemes.php{$sid}">[ {$lang.menu_themes} ]</a></td>
</tr>

<tr>
<td class="menuheader" align="center"><a href="adminsystem.php{$sid}">[ {$lang.menu_system} ]</a></td>
</tr>

{if $enable_stats_tracking}
<tr>
<td class="menuheader" align="center"><a href="adminstats.php{$sid}">[ {$lang.menu_statistics} ]</a></td>
</tr>
{/if}

{/if}

<tr>
<td class="menuheader" align="center"><a href="adminhelp.php{$sid}" target="new">[ {$lang.menu_help} ]</a></td>
</tr>

</table></div>
{/capture}


{include file="container.tpl"}

