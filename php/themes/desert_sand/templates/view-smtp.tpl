<fieldset id="view_headers">
<legend><a href="#"  onclick="javascript:$('#view_smtp_sender').slideToggle('slow'); return false;">{$lang.link_toggle_smtp_sender}</a></legend>
<div id="view_smtp_sender" class="message_headers">
<table width="100%" cellspacing="0" cellpadding="2" border="0">
<tbody>
  <tr>
    <td class="mailheader">{$lang.text_smtp_sender}:</font></td>
    <td><span>{$sender_email}</span><br><a class="wblist_link" href="#" onclick="javascript:wblistAction($(this).siblings('span').text(),'addblock'); return false;">{$lang.link_blacklist}</a> | <a class="wblist_link" href="#" onclick="javascript:wblistAction($(this).siblings('span').text(),'addallow'); return false;">{$lang.link_whitelist}</a></td>
  </tr>
</table>
</div>
</fieldset>
