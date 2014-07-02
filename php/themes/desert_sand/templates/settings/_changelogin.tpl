<div id="change_login" class="styledform ui-widget-content">
  {form action="xsettings.php$sid" name="changelogin"}
   <input type="hidden" name="user_id" value="{$euid}">
   <fieldset>
   <legend>{$lang.header_login_info}</legend>
<ol>
   {if $enable_username_changes || $super }
<li>
<label>{$lang.text_new_login_name}:</label>
<input type="text" name="new_login_name" value="{$user_name}" size="40">
</li>
  {else}
<li>
<input type="hidden" name="new_login_name" value="{$user_name}">
</li>
  {/if}
<li>
<label>{$lang.text_new_password}:</label>
<input type="password" name="new_password" value="" size="40">
</li>

<li>
<label>{$lang.text_confirm_new_password}:</label>
<input type="password" name="confirm_new_password" value="" size="40">
</li>

<li class="submitrow">
<input type="submit" name="change_login_info" value="{$lang.button_change_login_info}">
</li>
</ol>
</fieldset>
</form>
</div>