<div id="revoke_admin" align="center">
{form action="xsettings.php$sid" name="del_domainadmin"}
<input type="hidden" name="domain_id" value="{$domain_id}">

<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_admins}&nbsp;
<font size="3"><a href="adminhelp.php#administrators{$sid}" target="new">[?]</a></font>
</tr>

{if $admins}
    <tr>
    <td class="menuheader2" align="center">{$lang.header_revoke}</td>
    <td class="menuheader2" align="center">{$lang.header_admin_name}</td>
    </tr>
    {foreach from=$admins item=admin}
        <tr>
        <td class="menubody" align="center">
        <input type="checkbox" name="revoke_id[]" value="{$admin.id}">
        </td>
        <td class="menubody" align="center">
        {$admin.name}
        </td>
        </tr>
    {/foreach}
    <tr>
    <td class="menubody" align="center" colspan="2">
    <input type="submit" name="revoke" value="{$lang.button_revoke}">
    </td>
    </tr>
{else}
    <tr><td class="menubody" align="center" colspan="2">{$lang.text_no_admins}</td></tr>
{/if}

</table>
</form></div>
<div id="grant_admin" align="center">
{form action="xsettings.php$sid" name="add_domainadmin"}
<input type="hidden" name="domain_id" value="{$domain_id}">

<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center">{$lang.header_add_administrator}&nbsp;
<font size="3"><a href="adminhelp.php#add_administrator{$sid}" target="new">[?]</a></font>
</td>
</tr>

{if $add_admins}
    <tr>
    <td class="menubody" align="center">
    <select multiple name="administrators[]" size="5">
    {foreach from=$add_admins item=admin}
        <option value="{$admin.id}">{$admin.name}</option>
    {/foreach}
    </select>
    </td>
    </tr>
    <tr>
    <td class="menubody" align="center">
    <input type="submit" name="grant" value="{$lang.button_grant}">
    </td>
    </tr>
{else}
    <tr><td class="menubody" align="center">{$lang.text_no_available_admins}</td></tr>
{/if}

</table>
</form>
</div>