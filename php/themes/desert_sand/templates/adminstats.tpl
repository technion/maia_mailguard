{include file="html_head.tpl"}

{form action="xadminstats.php$sid" name="adminstats"}
<div class="styledform ui-widget-content">
<fieldset>
<legend>{$lang.header_reset_stats} <a href="adminhelp.php#reset_statistics{$sid}" target="new" class="ui-icon ui-icon-help ui-border-all"></a></legend>
<ol>
<li>
<label  for="reset_users_submit">{$lang.text_reset_user_stats}</label>
<input type="submit" id="reset_users_submit" name="reset_users" value="{$lang.button_reset}">
</li>

<li>
<label for="reset_viruses_submit">{$lang.text_reset_virus_stats}</label>
<input type="submit" name="reset_viruses" id="reset_viruses_submit" value="{$lang.button_reset}">
</li>

<li>
<label for="reset_rules_submit">{$lang.text_reset_rule_stats}</label>
<input type="submit" name="reset_rules" id="reset_rules_submit" value="{$lang.button_reset}">
</li>

<li>
<label for="reset_all_input">{$lang.text_reset_all_stats}</label>
<input type="submit" name="reset_all" id="reset_all_input" value="{$lang.button_reset}">
</li>

</ol>
</fieldset>
</div>
</form>
<br>
<div>
<a href="admindex.php{$sid}">[ {$lang.link_admin_menu} ]</a>
</div>

{include file="html_foot.tpl"}
