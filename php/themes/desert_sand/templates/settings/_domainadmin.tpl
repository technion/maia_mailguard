<div id="revoke_admin" class="styledform ui-widget-content">
{form action="xsettings.php$sid" name="del_domainadmin"}
<input type="hidden" name="domain_id" value="{$domain_id}">
<fieldset>
<legend>{$lang.header_admins}&nbsp;<a href="adminhelp.php#administrators{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>

{if $admins}
    <li>
    <label>&nbsp;</label>
    <table class="ui-list-table">
    <tr>
    <td class="menuheader2">{$lang.header_revoke}</td>
    <td class="menuheader2">{$lang.header_admin_name}</td>
    </tr>
    {foreach from=$admins item=admin}
        <tr>
        <td class="menubody2">
        <input type="checkbox" name="revoke_id[]" value="{$admin.id}">
        </td><td class="menubody2">
        {$admin.name}
        </td></tr>
    {/foreach}
    </table>
    <li class="submitrow">
    <input type="submit" name="revoke" value="{$lang.button_revoke}">
    </li>
{else}
    <li>{$lang.text_no_admins}</li>
{/if}
</ol>
</fieldset>
</form></div>

<div id="grant_admin" class="styledform ui-widget-content">
{form action="xsettings.php$sid" name="add_domainadmin"}
<input type="hidden" name="domain_id" value="{$domain_id}">
<fieldset>
<legend>{$lang.header_add_administrator}&nbsp;<a href="adminhelp.php#add_administrator{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>

{if $add_admins}
    <li>
    <select multiple name="administrators[]" size="5">
    {foreach from=$add_admins item=admin}
        <option value="{$admin.id}">{$admin.name}</option>
    {/foreach}
    </select>
    </li>
    <li class="submitrow">
    <input type="submit" name="grant" value="{$lang.button_grant}">
    </li>
{else}
    <li>{$lang.text_no_available_admins}</li>
{/if}
</ol>
</fieldset>
</form>
</div>