{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xadminthemes.php{$sid}" name="adminthemes">
	{if $message}
	<div align="center">
	<table border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td class="messagebox" align="center">
	{$message}
	</td>
	</tr>
	</table>
	</div><br>
	{/if}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menubanner" align="center" colspan="3">{$lang.header_themes_menu}&nbsp;
<font size="3"><a href="adminhelp.php#themes{$sid}" target="new">[?]</a></font>
</td>
</tr>
{if $rowcount}
<td class="menuheader2" align="center">{$lang.header_uninstall}</td>
<td class="menuheader2" align="center">{$lang.header_name}</td>
<td class="menuheader2" align="center">{$lang.header_path}</td>
</tr>
{foreach from=$themes_installed key=key item=row}
<tr>
<td class="menubody" align="center">
{if $default_theme != $row.id}	
    <input type="checkbox" name="themes[]" value="{$row.id}">
{else}
    {$lang.text_required}
{/if}
</td>
<td class="menubody" align="center">
{$row.name}
</td>
<td class="menubody" align="center">
{$row.path}
</td>
</tr>
{/foreach}
{if $rowcount}
<tr>
	<td class="menubody2" align="center" colspan="3">{$lang.text_modification_warning}</td>
</tr>
<tr>
<td class="menubody" align="center" colspan="3">
<input type="submit" name="uninstall" value="{$lang.button_uninstall}">
</td>
</tr>
{/if}
{else}
<tr><td class="menubody" align="center" colspan="3">{$lang.text_no_themes}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menubanner" align="center">{$lang.header_install_theme}&nbsp;
<font size="3"><a href="adminhelp.php#install_themes{$sid}" target="new">[?]</a></font>
</td>
</tr>

{if !$atleastone}
<tr><td class="menubody" align="center">{$lang.text_no_uninstalled_themes}</td></tr>
{else}
<tr>
<td class="menubody" align="center">
<select name="theme">
{foreach from=$themes_available key=key item=row}
<option value="{$row.theme_path}">{$row.theme_name} ({$row.theme_path})</option>
{/foreach}
</select>
</td>
</tr>
<tr>
<td class="menubody" align="center">
<input type="submit" name="install" value="{$lang.button_install}">
</td>
</tr>

{/if}

</table></div>
</form>

<div align="center">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{/capture}
{include file="container.tpl"}