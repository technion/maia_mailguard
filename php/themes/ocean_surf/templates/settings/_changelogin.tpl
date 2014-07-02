<div id="change_login" align="center">
  {form action="xsettings.php$sid" name="settings"}
   <input type="hidden" name="user_id" value="{$euid}">
<table border="0" cellspacing="2" cellpadding="2" width="600">

<tr>
<td class="menuheader" align="center" colspan="2">{$lang.header_login_info}</td>
</tr>
   {if $enable_username_changes || $super }
<tr>
<td class="menubody" align="left">{$lang.text_new_login_name}:</td>
<td class="menubody" align="left"><input type="text" name="new_login_name" value="{$user_name}" size="40"></td>
</tr>
  {else}
<input type="hidden" name="new_login_name" value="{$user_name}">
  {/if}
<tr>
<td class="menubody" align="left">{$lang.text_new_password}:</td>
<td class="menubody" align="left"><input type="password" name="new_password" value="" size="40"></td>
</tr>

<tr>
<td class="menubody" align="left">{$lang.text_confirm_new_password}:</td>
<td class="menubody" align="left"><input type="password" name="confirm_new_password" value="" size="40"></td>
</tr>

<tr><td colspan="2" class="menulight">&nbsp;</td></tr>

<tr>
<td colspan="2" align="center" class="menubody">
<input type="submit" name="change_login_info" value="{$lang.button_change_login_info}">
</td>
</tr>

</table>
</form>
</div>