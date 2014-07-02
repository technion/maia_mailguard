{include file="html_head.tpl"}
{literal}
<script type="text/javascript">
  $(document).ready(function(){
    $(".tabs").tabs({selected: {/literal}{$tab}{literal}});
  });
</script>
{/literal}
{if $message}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<td align="center" class="messagebox">
{$message}
</td>
</tr>
</table>
</div>
{/if}

{if $domain_user}
    <div class="tabs" align="center">
      <ul>
        <li><a href="#address_settings"><span>{$lang.tab_domain_settings}</span></a></li>
        <li><a href="#misc_settings"><span>{$lang.tab_misc_settings}</span></a></li>
        {if $super && $address_id != 1 && $domain_user}
        <li><a href="#revoke_admin"><span>{$lang.tab_revoke_admin}</span></a></li>
        <li><a href="#grant_admin"><span>{$lang.tab_grant_admin}</span></a></li>
        {/if}
        <li><a href="#transport"><span>{$lang.tab_transport}</span></a></li>
      </ul>
    {include file="settings/_address.tpl"}
    {include file="settings/_misc.tpl"}
    {if $super && $address_id != 1}
      {include file="settings/_domainadmin.tpl"}
    {/if}
    {if $super}
    {include file="settings/_transport.tpl"}
    {/if}
    </div>
{else}
  {if $address_id === 0}
     <div class="tabs" align="center">
        <ul>
          <li><a href="#addresslist_settings"><span>{$lang.tab_addresses}</span></a></li>
          <li><a href="#misc_settings"><span>{$lang.tab_misc_settings}</span></a></li>
          {if $auth_method=="internal"}
          <li><a href="#change_login"><span>{$lang.tab_change_login}</span></a></li>
          {/if}
        </ul>
    {include file="settings/_addresslist.tpl"}
    {if $auth_method=="internal"}
      {include file="settings/_changelogin.tpl"}
    {/if}
    {include file="settings/_misc.tpl"}
    </div>
  {else}
    {include file="settings/_address.tpl"}
    <div class="styledform">
    <a href="settings.php{$sid}">[{$lang.link_settings}]</a>
    </div>
  {/if}
{/if}
{include file="html_foot.tpl"}
