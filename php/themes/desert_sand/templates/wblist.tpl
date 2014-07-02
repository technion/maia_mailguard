{include file="html_head.tpl"}

<div id="viewmessage">
{if $message}
{$message}
{/if}
</div>
{form action="wblist.php$sid" name="wblist" id="new_wblist"}
<div class="styledform ui-widget-content">
  <fieldset>
  <legend>{$lang.text_wb_bypass}</legend>
  <ol>
    <li>
      <label>{$lang.text_address_to_add}:</label>
      <input type="text" id="newaddr" name="newaddr" value="" size="40">
    </li>

<li class="buttonwrapper">
<a class="fancybutton" href="wblist.php?action=addallow"><span class="fancybutton"><span class="wballow">&nbsp;</span>{$lang.text_allow}</span></a>
<a class="fancybutton" href="wblist.php?action=addblock"><span class="fancybutton"><span class="wbblock">&nbsp;</span>{$lang.text_block}</span></a>
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
</li>
</ol>
</fieldset>
</div>
</form>

{if $show_user_table}

{form action="wblist.php$sid" name="changewblist" id="change_wblist"}
<div class="styledform ui-widget-content">
  <fieldset>
  <legend>{$lang.text_wb_bypass_list}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span></legend>
<ol>
  <li>
    <table>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
<th class="menuheader2"> </th>
</tr>

{section name=wb loop=$rows}
<tr id="wb{$rows[wb].id}">
<td><span class="wb{$rows[wb].type}ball wbball">{$rows[wb].email}</span></td>
  <td class="fancybutton">
  {if $rows[wb].type eq 'W'}
  <a class="fancybutton wb_action" href="wblist.php?action=block&id={$rows[wb].id}&ajax=true"><span class="fancybutton"><span class="wbblock actionicon">&nbsp;</span><span class="actiontext">{$lang.text_block_address}</span></span></a>
  {else}
  <a class="fancybutton wb_action" href="wblist.php?action=allow&id={$rows[wb].id}&ajax=true"><span class="fancybutton"><span class="wballow actionicon">&nbsp;</span><span class="actiontext">{$lang.text_allow_address}</span></span></a>
  {/if}
  </td>
  <td class="fancybutton">
  <a class="fancybutton" href="wblist.php?action=remove&id={$rows[wb].id}&ajax=true"><span class="fancybutton"><img src="{$template_dir}/images/Cancel.png">{$lang.text_remove_rule}</span></a>
  </td>
</tr>
{/section}
</table>
</li>
</ol>
</fieldset>
</div>
</form>
<script type="text/javascript">
{literal}
$(document).ready(function(){
  $('#change_wblist a').click(function(){
  $('#change_wblist').attr('action',this);
   $.ajax({
      type: "POST",
      url: this,
      dataType: "script",
      data: "ufid=" + document.changewblist.ufid.value
    });
  return false;
  });
});
{/literal}
</script>
{/if}
{if $show_domain_table}
<div class="styledform ui-widget-content">
  <fieldset>
  <legend>{$lang.text_blocked_by_domain}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span></legend>
<ol>
  <li>
    <table>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
<th class="menuheader2">{$lang.header_domain}</th>
</tr>
{section name=wb loop=$domain_rows}
<tr>
<td><span class="wb{$domain_rows[wb].type}ball wbball">{$domain_rows[wb].email}</span></td>
<td>{$domain_rows[wb].domain}</td>
</tr>
{/section}
</table>
</li>
</ol>
</fieldset>
</div>
{/if}
{if $show_system_table}
<div class="styledform ui-widget-content">
  <fieldset>
  <legend>{$lang.text_blocked_by_system}<br><span class="wbBball">{$lang.text_blocked}</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class="wbWball">{$lang.text_allowed}</span></legend>
<ol>
  <li>
    <table>
<tr>
<th class="menuheader2">{$lang.header_address}</th>
</tr>
{section name=wb loop=$system_rows}
<tr>
<td><span class="wb{$system_rows[wb].type}ball wbball">{$system_rows[wb].email}</span></td>
<td>{$system_rows[wb].domain}</td>
</tr>
{/section}
</table>
</li>
</ol>
</fieldset>
</div>
{/if}

{include file="html_foot.tpl"}