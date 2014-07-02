{include file="html_head.tpl"}
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
{form action="xadminthemes.php$sid" name="adminthemes"} 
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_themes_menu} <a href="adminhelp.php#themes{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if $rowcount}
<table class="ui-list-table">
  <tr>
    <td class="menuheader2" align="center">{$lang.header_uninstall}</td>
    <td class="menuheader2" align="center">{$lang.header_name}</td>
    <td class="menuheader2" align="center">{$lang.header_path}</td>
  </tr>
{foreach from=$themes_installed key=key item=row}
<tr>
<td class="menubody2" align="center">
{if $default_theme != $row.id}	
    <input type="checkbox" name="themes[]" value="{$row.id}">
{else}
    {$lang.text_required}
{/if}
</td>
<td class="menubody2" align="center">
{$row.name}
</td>
<td class="menubody2" align="center">
{$row.path}
</td>
</tr>
{/foreach}
{if $rowcount}
<tr>
	<td class="menubody2" align="center" colspan="3">{$lang.text_modification_warning}</td>
</tr>
</table>
</li>
<li class="submitrow">
<input type="submit" name="uninstall" value="{$lang.button_uninstall}">
</li>
{/if}
{else}
<li>{$lang.text_no_themes}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

{form action="xadminthemes.php$sid" name="adminthemes"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_install_theme} <a href="adminhelp.php#install_themes{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if !$atleastone}
<li>{$lang.text_no_uninstalled_themes}</li>
{else}
<li>
<td class="menubody" align="center">
<select name="theme">
{foreach from=$themes_available key=key item=row}
<option value="{$row.theme_path}">{$row.theme_name} ({$row.theme_path})</option>
{/foreach}
</select>
</li>
<li class="submitrow">
<input type="submit" name="install" value="{$lang.button_install}">
</li>
{/if}
</ol>
</fieldset>
</div>
</form>

<div class="styledform">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}
