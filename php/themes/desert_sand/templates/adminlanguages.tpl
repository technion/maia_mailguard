{include file="html_head.tpl"}

{form action="xadminlanguages.php$sid" name="adminlanguages"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_languages_menu} <a href="adminhelp.php#languages{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if $rowcount}
<li>
  <table class="ui-list-table">
    <tr>
      <td class="menuheader2" align="center">{$lang.header_uninstall}</td>
      <td class="menuheader2" align="center">{$lang.header_language}</td>
      <td class="menuheader2" align="center">{$lang.header_abbrev}</td>
    </tr>
{foreach from=$languages key=key item=row}
<tr>
<td class="menubody2" align="center">
{if $row.language_abbrev != "en"}
    <input type="checkbox" name="{$row.language_abbrev}" value="{$row.language_id}">
{else}
    ({$lang.text_required})
{/if}
</td>
<td class="menubody2" align="center">
{$row.language_name}
</td>
<td class="menubody2" align="center">
{$row.language_abbrev}
</td>
</tr>
{/foreach}
</table>
{if $rowcount}
<li class="submitrow">
<input type="submit" name="uninstall" value="{$lang.button_uninstall}">
</li>
{/if}
{else}
<li>{$lang.text_no_languages}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

<p>&nbsp;</p>

{form action="xadminlanguages.php$sid" name="adminlanguages"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_install_language} <a href="adminhelp.php#install_language{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if !$atleastone}
<li>{$lang.text_no_uninstalled_languages}</li>
{else}
<li>

<select name="language" size="10">
{foreach from=$dirlist key=key item=row}
<option value="{$row.language_abbrev}">{$row.language_name} ({$row.language_abbrev})</option>
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
<br>
<div>
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

{include file="html_foot.tpl"}
