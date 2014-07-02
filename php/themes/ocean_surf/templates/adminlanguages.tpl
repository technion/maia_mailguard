{include file="html_head.tpl"}
  <div id="messagebox">
  {if $message}
  <div class="messagebox" align="center">
  {$message}
  </div>
  {/if}
  </div>

{form action="xadminlanguages.php$sid" name="adminlanguages"}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menubanner" align="center" colspan="3">{$lang.header_languages_menu}&nbsp;
<font size="3"><a href="adminhelp.php#languages{$sid}" target="new">[?]</a></font>
</td>
</tr>
{if $rowcount}
<td class="menuheader2" align="center">{$lang.header_uninstall}</td>
<td class="menuheader2" align="center">{$lang.header_language}</td>
<td class="menuheader2" align="center">{$lang.header_abbrev}</td>
</tr>
{foreach from=$languages key=key item=row}
<tr>
<td class="menubody" align="center">
{if $row.language_abbrev != "en"}
    <input type="checkbox" name="{$row.language_abbrev}" value="{$row.language_id}">
{else}
    ({$lang.text_required})
{/if}
</td>
<td class="menubody" align="center">
{$row.language_name}
</td>
<td class="menubody" align="center">
{$row.language_abbrev}
</td>
</tr>
{/foreach}
{if $rowcount}
<tr>
<td class="menubody" align="center" colspan="3">
<input type="submit" name="uninstall" value="{$lang.button_uninstall}">
</td>
</tr>
{/if}
{else}
<tr><td class="menubody" align="center" colspan="3">{$lang.text_no_languages}</td></tr>
{/if}

</table></div>
</form>

<p>&nbsp;</p>

{form action="xadminlanguages.php$sid" name="adminlanguages"}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menubanner" align="center">{$lang.header_install_language}&nbsp;
<font size="3"><a href="adminhelp.php#install_language{$sid}" target="new">[?]</a></font>
</td>
</tr>

{if !$atleastone}
<tr><td class="menubody" align="center">{$lang.text_no_uninstalled_languages}</td></tr>
{else}
<tr>
<td class="menubody" align="center">
<select name="language">
{foreach from=$dirlist key=key item=row}
<option value="{$row.language_abbrev}">{$row.language_name} ({$row.language_abbrev})</option>
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

{include file="html_foot.tpl"}
