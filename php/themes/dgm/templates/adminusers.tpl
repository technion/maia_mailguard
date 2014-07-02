{capture assign="maincontent"}{* capture text to insert into page wrapper at bottom *}

<form method="post" action="xadminusers.php{$sid}" name="adminusers">

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3 outy" align="center" colspan="2">{$lang.header_users_menu}&nbsp;
<font size="3"><a href="adminhelp.php#find_users{$sid}" target="new">[?]</a></font></td>
</tr>

<tr>
<td class="panel2" align="center">
{$lang.text_lookup_user} (* = {$lang.text_wildcard}):</td>
<td class="panel2" align="left">
<input type="text" name="lookup" value="*" size="50">
</td>
</tr>

<tr>
<td class="" align="center" colspan="2">
<input type="submit" name="button_find" value=" {$lang.button_lookup} ">
</td>
</tr>

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3 outy" align="center" colspan="2">{$lang.header_add_email}&nbsp;
<font size="3"><a href="adminhelp.php#add_email_address{$sid}" target="new">[?]</a></font></td>
</tr>

<tr>
<td class="panel2" align="center">
{$lang.text_new_email}:</td>
<td class="panel2" align="left">
<input type="text" name="new_email" value="" size="50">
</td>
</tr>

<tr>
<td class="" align="center" colspan="2">
<input type="submit" name="button_add" value=" {$lang.button_add_email} ">
</td>
</tr>

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3" align="center" colspan="2">{$lang.header_link_email}&nbsp;
<font size="3"><a href="adminhelp.php#link_email_address{$sid}" target="new">[?]</a></font></td>
</tr>

{if $addresses && $users}
    <tr><td class="panel2" align="center">{$lang.text_email}:</td>
    <td class="panel2" align="left">
    <select name="email[]" size="5" multiple>
    {foreach from=$address key=email item=id}
        <option value="{$id}">{$email}</option>
    {/foreach}
    </select></td></tr>
    <tr><td class="panel2" align="center">{$lang.text_user}:</td>
    <td class="panel2" align="left">
    <select name="user" size="5">
    {foreach from=$user key=key item=id}
        <option value="{$id}">{$key}</option>
    {/foreach}
    </select></td></tr>
    <tr><td class="panel2" align="center" colspan="2">
    <input type="submit" name="button_link" value=" {$lang.button_link_email} ">
    </td></tr>
{elseif $addresses}
    <tr><td class="panel2" align="center" colspan="2">{$lang.text_no_users}</td></tr>
{else}
    <tr><td class="panel2" align="center" colspan="2">{$lang.text_no_addresses}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3" align="center" colspan="2">{$lang.header_delete_email}&nbsp;
<font size="3"><a href="adminhelp.php#delete_email_address{$sid}" target="new">[?]</a></font></td>
</tr>

{if $delete_addresses}
    <tr>
    <td class="panel2" align="center">{$lang.text_delete_email}:</td>
    <td class="panel2" align="left">
    <select name="delete_email[]" size="5" multiple>
    {foreach from=$delete_address key=email item=id}
        <option value="{$id}">{$email}</option>
    {/foreach}
    </select></td></tr>
    <tr><td class="panel2" align="center" colspan="2">
    <input type="submit" name="button_delete_email" value=" {$lang.button_delete_email} ">
    </td></tr>
{else}
    <tr><td class="panel2" align="center" colspan="2">{$lang.text_no_addresses}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<table border="0" cellspacing="2" cellpadding="2" width="600" class="panel1 outy">

<tr>
<td class="panel3" align="center" colspan="2">{$lang.header_delete_user}&nbsp;
<font size="3"><a href="adminhelp.php#delete_user{$sid}" target="new">[?]</a></font></td>
</tr>

{if $del_users}
    <tr><td class="panel2" align="center">{$lang.text_user}:</td>
    <td class="panel2" align="left">
    <select name="del_user[]" size="5" multiple>
    {foreach from=$del_user key=key item=id}
        <option value="{$id}">{$key}</option>
    {/foreach}
    </select></td></tr>
    <tr><td class="panel2" align="center" colspan="2">
    <input type="submit" name="button_delete_user" value=" {$lang.button_delete_user} ">
    </td></tr>
{else}
    <tr><td class="menpanel2" align="center" colspan="2">{$lang.text_no_users}</td></tr>
{/if}

</table></div>

<p>&nbsp;</p>

<div align="center">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>

</form>
{/capture}
{include file="container.tpl"}