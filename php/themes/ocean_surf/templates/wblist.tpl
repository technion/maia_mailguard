{include file="html_head.tpl"}

<div id="messagebox">
{if $message}
<div class="messagebox" align="center">
{$message}
</div>
{/if}
</div>
{form action="wblist.php$sid" name="wblist" id="new_wblist"}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">

<tr>
<td class="menuheader2">
{$lang.text_address_to_add}:
</td>
<td class="menuheader2">
<input type="text" id="newaddr" name="newaddr" value="" size="40">
</td>
</tr>
<tr>
<td class="menuheader2" colspan="2" align="center">
  <a class="fancybutton" href="wblist.php?action=addallow"><span><img src="{$template_dir}/images/Add.png">{$lang.text_allow}</span></a>
  <a class="fancybutton" href="wblist.php?action=addblock"><span><img src="{$template_dir}/images/Delete.png">{$lang.text_block}</span></a>
  <script type="text/javascript">
  {literal}
  $(document).ready(function(){
    $('#new_wblist a').click(function(){
    $('#new_wblist').attr('action',this);
    $('#new_wblist').submit();
    return false;
    });
    $('#new_wblist').submit(function() {
      if ($('#newaddr').val() == "") {
        alert("{/literal}{$lang.text_enter_address}{literal}");
      } else {
        return true;
      }
      return false;
    });
    $('#newaddr').keydown(function(e) {
      if(e.keyCode == 13) {
        alert("{/literal}{$lang.text_submit_by_click}{literal}");
        return false;
      }
    });
  });
  {/literal}
  </script>
</td>
</tr>

</table>
</div>
</form>
{if $show_user_table}
<br>
{form action="wblist.php$sid" name="wblist" id="change_wblist"}
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr class="menuheader2">
  <td colspan="3" >
    {$lang.text_wb_bypass_list}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span>
  </td>
</tr>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
<th class="menuheader2"> </th>
<th class="menuheader2"> </th>
</tr>

{section name=wb loop=$rows}
<tr id="wb{$rows[wb].id}">
<td class="menuheader2"><span class="wb{$rows[wb].type}ball">{$rows[wb].email}</span></td>
  <td class="fancybutton menuheader2">
  {if $rows[wb].type eq 'W'}
  <a class="fancybutton" href="wblist.php?action=block&id={$rows[wb].id}"><span><img src="{$template_dir}/images/Delete.png">{$lang.text_block_address}</span></a>
  {else}
  <a class="fancybutton" href="wblist.php?action=allow&id={$rows[wb].id}"><span><img src="{$template_dir}/images/Add.png">{$lang.text_allow_address}</span></a>
  {/if}
  </td>
  <td class="fancybutton menuheader2">
  <a class="fancybutton" href="wblist.php?action=remove&id={$rows[wb].id}"><span><img src="{$template_dir}/images/Cancel.png">{$lang.text_remove_rule}</span></a>
  </td>
</tr>
{/section}
</table>
</div>
</form>
<script type="text/javascript">
{literal}
$(document).ready(function(){
  $('#change_wblist a').click(function(){
  $('#change_wblist').attr('action',this);
  $('#change_wblist').submit();
  return false;
  });
});
{/literal}
</script>
<br>
{/if}
{if $show_domain_table}
<br>
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr class="menuheader2">
  <td colspan="2" >
    {$lang.text_blocked_by_domain}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span>
  </td>
</tr>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
<th class="menuheader2">{$lang.header_domain}</th>
</tr>

{section name=wb loop=$domain_rows}
<tr>
<td class="menuheader2"><span class="wb{$domain_rows[wb].type}ball">{$domain_rows[wb].email}</span></td>
  <td class="fancybutton menuheader2">
  {$domain_rows[wb].domain}
  </td>
</tr>
{/section}
</table>
</div>
{/if}

{if $show_system_table}
<br>
<div align="center">
<table border="0" cellspacing="2" cellpadding="2">
<tr class="menuheader2">
  <td >
    {$lang.text_blocked_by_system}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span>
  </td>
</tr>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
</tr>

{section name=wb loop=$system_rows}
<tr>
<td class="menuheader2"><span class="wb{$system_rows[wb].type}ball">{$system_rows[wb].email}</span></td>
</tr>
{/section}
</table>
</div>
{/if}

{include file="html_foot.tpl"}