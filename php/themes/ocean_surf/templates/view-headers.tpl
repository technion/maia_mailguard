<fieldset id="view_headers">
<legend><a href="#" alt="" onclick="javascript:$('.message_headers').slideToggle('slow'); return false;">{$lang.link_toggle_header}</a></legend>
<div id="view_simple_headers" class="message_headers">
<table width="100%" cellspacing="0" cellpadding="2" border="0">
<tbody>
  {foreach from=$headers.from item=from}
  <tr>
    <td class="mailheader">From:</font></td>
    <td><span>{$from}</span><br><a class="wblist_link" href="#" onclick="javascript:wblistAction($(this).siblings('span').text(),'addblock'); return false;">{$lang.link_blacklist}</a> | <a class="wblist_link" href="#" onclick="javascript:wblistAction($(this).siblings('span').text(),'addallow'); return false;">{$lang.link_whitelist}</a></td>
  </tr>
  {/foreach}
  {foreach from=$headers.to item=to}
  <tr>
    <td class="mailheader">To:</font></td>
    <td>{$to}</td>
  </tr>
  {/foreach}
  {foreach from=$headers.subject item=subject}
  <tr>
    <td class="mailheader">Subject:</font></td>
    <td>{$subject}</td>
  </tr>
  {/foreach}
</tbody></table>
</div>
<div id="view_full_headers"  class="message_headers">
  <table width="100%" cellspacing="0" cellpadding="2" border="0">
  <tbody>
{foreach from=$headers key=key item=row}
{foreach from=$row item=rowitem}
    <tr>
      <td class="mailheader">{$key}:</font></td>
      <td>{$rowitem}</td>
    </tr>
    {/foreach}
{/foreach}
  </tbody>
  </table>
</div>
</fieldset>
