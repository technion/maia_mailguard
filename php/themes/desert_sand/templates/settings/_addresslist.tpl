<div id="addresslist_settings" class="styledform ui-widget-content">
  {form action="xsettings.php$sid" name="addresssettings"}
   <input type="hidden" name="user_id" value="{$euid}">
   <fieldset>
 <legend>{$lang.header_addresses}</legend>
<ol>

<li><label>{$lang.text_primary}</label>
<a href="settings.php{$msid}addid={$primary_email_id}">
{$address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a>
</li>
   {foreach from=$user_addr key=key item=row}
<li><label><input type="submit"
                                           name="make_primary_{$row.addid}"
                                           value="{$lang.button_make_primary}">
</label>
<a href="settings.php{$msid}addid={$row.addid}">{$row.address}&nbsp;<img class="edit_icon" src="{$template_dir}images/edit.png" alt="edit icon"></a>
</li>
   {/foreach}
<li>&nbsp;</li>
</ol>
</fieldset>
</form>
   {if $enable_address_linking}
{form action="xsettings.php$sid" name="addresslinking"}
<fieldset><legend>{$lang.header_add_email}</legend>
<ol>
<li><label>{$login}:</label>
<input type="text" name="login" value="" size="40">
</li>

<li><label>{$lang.text_password}:</label>
<input type="password" name="authpass" value="" size="40">
</li>

<li class="submitrow">
<input type="submit" name="add_email_address" value="{$lang.button_add_email_address}">&nbsp;&nbsp;
<input type="reset" name="reset" value="{$lang.button_reset}">
</li>
</ol>
</fieldset>
</form>
    {/if}
</div>