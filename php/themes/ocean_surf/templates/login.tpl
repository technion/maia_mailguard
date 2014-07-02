{include file="login_head.tpl"}

<form method="post" id="loginform" name="login" action="xlogin.php">
<input type="hidden" name="super" value="{$super}">
<input type="hidden" name="offset" value="0">

<script type="text/javascript">
<!--
  var server_timestamp = {$server_timestamp};
  var client_timestamp = new Date();
  var offset = server_timestamp - Math.floor((client_timestamp.getTime() + client_timestamp.getTimezoneOffset() * 60 * 1000) / 1000);
  document.login.offset.value = offset;
// -->
</script>

{if ! $display_language_is_default}
<input type="hidden" name="language" value="{$display_language}">
{/if}
<input type="hidden" name="charset" value="{$html_charset}">

<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td colspan="3" style="font-size: 110%; background: #dddddd;"><strong>{$lang.banner_subtitle}</strong></td>
</tr>

{if ($auth_method=="pop3" && $routing_domain) || $auth_method=="ldap" || $auth_method=="exchange" || $auth_method=="sql" || $auth_method=="internal" || $auth_method == "external"}
<tr>
<td width="30%" align="right">{$lang.label_username}</td>
<td width="40%"><input type="text" id="login" name="username" value="" size="20"></td>
<td width="30%">&nbsp;</td>
</tr>
{else}
<tr>
<td width="30%" align="right">{$lang.label_email}</td>
<td width="40%"><input type="text" id="login" name="address" value="" size="20"></td>
<td width="30%">&nbsp;</td>
</tr>
{/if}

<tr>
<td width="30%" align="right">{$lang.label_password}</td>
<td width="40%"><input type="password" name="pwd" value="" size="20"></td>
<td width="30%">&nbsp;</td>
</tr>

{if $auth_method=="exchange"}
{if $nt_domain}
<input type="hidden" name="domain" value="{$nt_domain}">
{else}
<tr>
<td width="30%" align="right">{$lang.label_nt_domain}</td>
<td width="40%"><input type="text" name="domain" value="{$nt_domain}" size="20"></td>
<td width="30%">&nbsp;</td>
</tr>
{/if}
{/if}

<tr>
<td colspan="3" align="center"><input type="submit" name="submit" value=" {$lang.button_login} "></td>
</tr>

</table>

</form>
</div><br>

<p>&nbsp;</p>

<div align="center">
{foreach from=$languages key=key item=language}
   <a href="login.php?lang={$key}">[ {$language} ]</a><br>
{/foreach}
</div>
{literal}
<script type="text/javascript">
$(document).ready(function(){
   $("#login").focus();
 });
</script>
{/literal}

{include file="login_foot.tpl"}
