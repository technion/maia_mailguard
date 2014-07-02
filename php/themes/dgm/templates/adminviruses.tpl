{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xadminviruses.php{$sid}" name="adminviruses">
<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3 outy" align="center" colspan="3">{$lang.header_virus_menu}&nbsp;
<font size="3"><a href="adminhelp.php#virus_aliases{$sid}" target="new">[?]</a></font>
</td>
</tr>
{if $numrows}
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
<tr>
<td class="virusbody" align="center" colspan="3">
<input type="submit" name="delete" value=" {$lang.button_delete} ">
</td>
</tr>
{else}
<tr><td class="virusbody" align="center" colspan="3">{$lang.text_no_aliases}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3 outy" align="center">{$lang.header_add_alias}&nbsp;
<font size="3"><a href="adminhelp.php#add_virus_alias{$sid}" target="new">[?]</a></font>
</td>
</tr>

{if !$rows}
<tr><td class="virusbody" align="center">{$lang.text_no_viruses}</td></tr>
{else}
<tr>
<td class="virusbody" align="center">
{$lang.text_make}
<select name="alias">
{foreach from=$rows key=key item=row}
<option value="{$row.id}">{$row.virus_name}</option>
{/foreach}
</select>
&nbsp;{$lang.text_an_alias_for}
<select name="virus">
{foreach from=$rows key=key item=row}
<option value="{$row.id}">{$row.virus_name}</option>
{/foreach}
</select>
</td>
</tr>
<tr>
<td class="virusbody" align="center">
<input type="submit" name="add" value=" {$lang.button_add} ">
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
