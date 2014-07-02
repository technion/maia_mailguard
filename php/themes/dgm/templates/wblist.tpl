{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

{if $message}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="messagebox" align="center">
{$message}
</td>
</tr>

</table>
</center><br>
{/if}
<form method="post" action="wblist.php{$sid}" name="wblist">
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="menuheader2">
{$lang.text_address_to_add}:
</td>
<td class="menuheader2">
<input type="text" name="newaddr" value="" size="40">
</td>
</tr>

<tr>
<td class="menuheader2">
{$lang.text_list_to_add_to}:
</td>
<td class="menuheader2">
<input type="radio" name="list" value="W" checked>&nbsp;{$lang.radio_button_whitelist}&nbsp;&nbsp;&nbsp;
<input type="radio" name="list" value="B">&nbsp;{$lang.radio_button_blacklist}&nbsp;&nbsp;
</td>
</tr>

<tr>
<td class="menuheader2" colspan="2" align="center">
<input type="submit" name="addaddress" value="{$lang.button_add_to_list}">
</td>
</tr>

</table>
</div><br>

{if $showtable}

<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<th class="menuheader">{$lang.header_address}</th>
<th class="menuheader">{$lang.header_whitelist}</th>
<th class="menuheader">{$lang.header_blacklist}</th>
<th class="menuheader">{$lang.header_remove}</th>
</tr>

{section name=wb loop=$rows}
<tr>
<td class="menuheader2">{$rows[wb].email}</td>
<td class="whitelist" align="center"><input type="radio" name="add{$rows[wb].id}" value="W" {$rows[wb].wselected}></td>
<td class="blacklist" align="center"><input type="radio" name="add{$rows[wb].id}" value="B" {$rows[wb].bselected}></td>
<td class="remove" align="center"><input type="radio" name="add{$rows[wb].id}" value="R"></td>
</tr>
{/section}
<tr>
<td class="menuheader2" colspan="4" align="center">
<input type="submit" name="addchange" value="{$lang.button_update}">&nbsp;&nbsp;&nbsp;
<input type="reset" name="reset" value=" Reset ">
</td>
</tr>

</table>
</div><br>

{/if}
</form>
    </div>
{/capture}
{assign var="page_javascript" value=""}
{include file="container.tpl"}