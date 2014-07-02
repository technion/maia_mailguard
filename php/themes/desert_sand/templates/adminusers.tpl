{include file="html_head.tpl"}

{form action="xadminusers.php$sid" name="findadminusers"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_users_menu} <a href="adminhelp.php#find_users{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
  <li>
    <label for="lookup_input">{$lang.text_lookup_user}</label>
    <input type="text" id="lookup_input" name="lookup" value="*" size="40">
    <p>(* = {$lang.text_wildcard})</p>
  </li>
  <li class="submitrow">
    <input type="submit" name="button_find" value="{$lang.button_lookup}">
  </li>
</ol>
</fieldset>
</div>
</form>

{form action="xadminusers.php$sid" name="add_email"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_add_email} <a href="adminhelp.php#add_email_address{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
  <li>
    <label for="new_email_input">{$lang.text_new_email}:</label>
    <input id="new_email_input" type="text" name="new_email" value="" size="40">
  </li>
  <li class="submitrow">
    <input type="submit" name="button_add" value=" {$lang.button_add_email} ">
  </li>
</ol>
</fieldset>
</div>
</form>

{form action="xadminusers.php$sid" name="link_user"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_link_email} <a href="adminhelp.php#link_email_address{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
  <ol>
{if $addresses && $users}
    <li>
      <label for="email_input">{$lang.text_email}:</label>
      <select id="email_input" name="email[]" size="5" multiple>
        {foreach from=$address key=email item=id}
        <option value="{$id}">{$email}</option>
        {/foreach}
      </select>
    </li>
    <li>
      <label for="user_input">{$lang.text_user}:</label>
      <select id="user_input" name="user" size="5">
        {foreach from=$user key=key item=id}
        <option value="{$id}">{$key}</option>
        {/foreach}
      </select>
    </li>
    <li class="submitrow">
      <input type="submit" name="button_link" value=" {$lang.button_link_email} ">
    </li>
{elseif $addresses}
    <li>{$lang.text_no_users}</li>
{else}
    <li>{$lang.text_no_addresses}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

{form action="xadminusers.php$sid" name="delete_email"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_delete_email} <a href="adminhelp.php#delete_email_address{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
{if $delete_addresses}
    <li>
      <label for="delete_email_input">{$lang.text_delete_email}:</label>
      <select id="delete_email_input" name="delete_email[]" size="5" multiple>
        {foreach from=$delete_address key=email item=id}
        <option value="{$id}">{$email}</option>
        {/foreach}
      </select>
    </li>
    <li class="submitrow">
    <input type="submit" name="button_delete_email" value=" {$lang.button_delete_email} ">
    </li>
{else}
    <li>{$lang.text_no_addresses}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

{form action="xadminusers.php$sid" name="delete_user"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_delete_user} <a href="adminhelp.php#delete_user{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>

{if $del_users}
    <li>
      <label for="delete_user_input">{$lang.text_user}:</label>
      <select id="delete_user_input" name="del_user[]" size="5" multiple>
        {foreach from=$del_user key=key item=id}
        <option value="{$id}">{$key}</option>
        {/foreach}
      </select>
    </li>
    <li class="submitrow">
      <input type="submit" name="button_delete_user" value=" {$lang.button_delete_user} ">
    </li>
{else}
    <li>{$lang.text_no_users}</li>
{/if}
</ol>
</fieldset>
</div>
</form>

<div class="styledform">
<a href="admindex.php{$sid}">[{$lang.link_admin_menu}]</a>
</div>


{include file="html_foot.tpl"}
