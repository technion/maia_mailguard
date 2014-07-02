{include file="html_head.tpl"}

{form action="xadminviruses.php$sid" name="deleteviruses"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_virus_menu} <a href="adminhelp.php#virus_aliases{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if $numrows}
<li>
  <table class="ui-list-table">
    <tr>
      <td class="virusheader2" align="center">{$lang.header_delete}</td>
      <td class="virusheader2" align="center">{$lang.header_alias}</td>
      <td class="virusheader2" align="center">{$lang.header_virus}</td>
    </tr>
{foreach from=$viruses key=key item=row}
<tr>
<td class="virusbody" align="center">
<input type="checkbox" name="{$row.virus_alias}" value="{$row.virus_id}">
</td>
<td class="virusbody" align="center">
{$row.virus_alias}
</td>
<td class="virusbody" align="center">
{$row.virus_name}
</td>
</tr>
{/foreach}
</table>
</li>
<li class="submitrow">
<input type="submit" name="delete" value="{$lang.button_delete}">
</li>
{else}
<li>
  {$lang.text_no_aliases}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

{form action="xadminviruses.php$sid" name="adminviruses"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_add_alias} <a href="adminhelp.php#add_virus_alias{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>

{if !$rows}
<li>{$lang.text_no_viruses}</li>
{else}
<li>
<label for="alias_input">{$lang.text_make}</label>
<select name="alias" id="alias_input">
{foreach from=$rows key=key item=row}
<option value="{$row.id}">{$row.virus_name}</option>
{/foreach}
</select></li>
<li>
<label for="virus_input">{$lang.text_an_alias_for}</label>
<select name="virus" id="virus_input">
{foreach from=$rows key=key item=row}
<option value="{$row.id}">{$row.virus_name}</option>
{/foreach}
</select>
</li>
<li class="submitrow">
<input type="submit" name="add" value=" {$lang.button_add} ">
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
