<div id="addresslist_settings" align="center">
  {form action="xsettings.php$sid" name="settings"}
   <input type="hidden" name="user_id" value="{$euid}">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_addresses}</td>
</tr>

<tr>
<td class="menubody" align="center">{$lang.text_primary}</td>
<td class="menubody" align="right">
<a href="settings.php{$msid}addid={$primary_email_id}">
{$address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a></a></td>
</tr>
   {foreach from=$user_addr key=key item=row}
<tr>
<td class="menubody" align="center"><input type="submit"
                                           name="make_primary_{$row.addid}"
                                           value=" {$lang.button_make_primary} ">
</td>
<td class="menubody" align="right">
<a href="settings.php{$msid}addid={$row.addid}">{$row.address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a></a></td>
</tr>
   {/foreach}
</table>
</form>
   {if $enable_address_linking}
{form action="xsettings.php$sid" name="addresslinking"}
<br>
<table border="0" cellspacing="2" cellpadding="2" width="600">
  <tr>
  <td class="menuheader" align="center" colspan="2">{$lang.header_add_email}</td>
  </tr>
<tr>
<td class="menubody" align="left">{$login}:</td>
<td class="menubody" align="left">
<input type="text" name="login" value="" size="40"></td>
</tr>
<tr>
<td class="menubody" align="left">{$lang.text_password}:</td>
<td class="menubody" align="left">
<input type="password" name="authpass" value="" size="40"></td>
</tr>
<tr><td colspan="2" class="menulight">&nbsp;</td></tr>
<tr>
<td colspan="2" align="center" class="menubody">
<input type="submit" name="add_email_address" value="{$lang.button_add_email_address}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</td>
</tr>
    {/if}

</table>
</form>
</div>